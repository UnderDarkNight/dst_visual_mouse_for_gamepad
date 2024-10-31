----------------------------------------------------------------------------------------------------------------------------------
--[[

    右摇杆控制器
    
    

]]--
----------------------------------------------------------------------------------------------------------------------------------
    local function GetReplicaCom(self)
        return self.inst.replica.right_joystick_controller or self.inst.replica._.right_joystick_controller    
    end

    local function SetSpellBook(self, spellbook)
        local replica_com = GetReplicaCom(self)
        if replica_com then
            replica_com:SetSpellBook(spellbook)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
local right_joystick_controller = Class(function(self, inst)
    self.inst = inst

    self.spellbook = nil
    inst:DoTaskInTime(0.1,function()
        self:SpawnSpellBook()
        self:HookDropItemAPI()
    end)


end,
nil,
{
    spellbook = SetSpellBook,
})
------------------------------------------------------------------------------------------------------------------------------
--- 
    function right_joystick_controller:SpawnSpellBook()
        if self.spellbook then
            self.spellbook:Remove()
        end
        --[[
            【重要笔记】必须是在 物品栏、装备栏、背包 里的物品
            才能正常在 带洞穴的存档里成功运行 指示器，否则无法成功 运行指示圈。
        ]]--
        local item = SpawnPrefab("right_joystick_spell_book")
        self.inst.components.inventory:Equip(item)
        self.spellbook = item
        item.Ready = true
    end
    function right_joystick_controller:GetSpellBook()
        if self.spellbook and self.spellbook:IsValid() then
            return self.spellbook
        end
        self:SpawnSpellBook()
        return self.spellbook
    end
------------------------------------------------------------------------------------------------------------------------------
--- 安装函数和激活技能
    function right_joystick_controller:Install_And_Active_Spell(fn)
        local spellbook = self:GetSpellBook()
        if spellbook and type(fn) == "function" then
            fn(spellbook)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
--- 防止物品被弄掉落。
    function right_joystick_controller:HookDropItemAPI()

        local inventory = self.inst.components.inventory
        if not inventory.__right_joystick_controller_hooked_flag then
            local old_DropItem = inventory.DropItem
            inventory.DropItem = function(self,item,...)
                if item and item.prefab == "right_joystick_spell_book" then
                    return
                end
                return old_DropItem(self,item,...)
            end
            inventory.__right_joystick_controller_hooked_flag = true
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return right_joystick_controller







