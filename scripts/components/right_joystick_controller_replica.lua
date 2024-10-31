----------------------------------------------------------------------------------------------------------------------------------
--[[

    右摇杆控制器
    
    给客户端 挂载使用，激活的函数 由外部 往客户端激活。

    重要素材
    TheSim:GetScreenPos(ThePlayer.Transform:GetWorldPosition())
                TheInputProxy:SetOSCursorPos(x,y) -- 控制 实体鼠标 去指定坐标。（无法超出窗口）

        CONTROL_INVENTORY_LEFT = 47 -- right joystick left
        CONTROL_INVENTORY_RIGHT = 48 -- right joystick right
        CONTROL_INVENTORY_UP = 49 --  right joystick up
        CONTROL_INVENTORY_DOWN = 50 -- right joystick down

]]--
----------------------------------------------------------------------------------------------------------------------------------
local right_joystick_controller = Class(function(self, inst)
    self.inst = inst
    -- self.__right_joystick_handler = TheInput:AddGeneralControlHandler(function(key,down)
    --     print("handler",key,down)
    -- end)
    self.__right_joystick_for_mouse_task = nil

    self.x = 0
    self.y = 0

    self.speed = 1
    self.max_speed = 20
    self.min_speed = 7
    self.delta_speed = FRAMES*5



    self.__net_inst = net_entity(inst.GUID,"right_joystick_controller_net_inst","right_joystick_controller_net_inst")
    if not TheNet:IsDedicated() then
        self.inst:ListenForEvent("right_joystick_controller_net_inst",function()
            self:SetSpellBook(self.__net_inst:value())
        end)
    end
end)    
------------------------------------------------------------------------------------------------------------------------------
--- 鼠标坐标控制、速度控制器
    -- function right_joystick_controller:SetMousePos(x,y)
    --     local window_w,window_h = TheSim:GetWindowSize() -- 获取窗口大小
    --     x = math.clamp(x,0,window_w)
    --     y = math.clamp(y,0,window_h)
    --     TheInputProxy:SetOSCursorPos(x,y)
    --     self.x = x
    --     self.y = y
    -- end
    -- function right_joystick_controller:MouseMove(delta_x,delta_y)
    --     self:SetMousePos(self.x + delta_x,self.y + delta_y)
    -- end
    -- function right_joystick_controller:GetSpeed()
    --     return self.speed
    -- end
    -- function right_joystick_controller:Speed_Up_By_Frame()
    --     self.speed = math.clamp(self.speed + self.delta_speed,self.min_speed,self.max_speed)
    -- end
    -- function right_joystick_controller:Speed_Down_By_Frame()
    --     self.speed = math.clamp(self.speed - self.delta_speed,self.min_speed,self.max_speed)
    -- end
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
--- 激活API
    -- function right_joystick_controller:Active()
    --     if ThePlayer ~= self.inst or TheFrontEnd == nil then
    --         return
    --     end
    --     TheFrontEnd:SetRightJoystickBlocking(true)
    --     TheInputProxy:SetCursorVisible(true) -- 隐藏 实体鼠标


    --     if self.__right_joystick_handler then
    --         self.__right_joystick_handler:Remove()
    --     end
    --     --- 获取玩家位置，把鼠标放玩家身上。        
    --     local screen_x,screen_y = TheSim:GetScreenPos(ThePlayer.Transform:GetWorldPosition())
    --     TheInputProxy:SetOSCursorPos(screen_x,screen_y)
    --     if self.__right_joystick_for_mouse_task then
    --         self.__right_joystick_for_mouse_task:Cancel()
    --     end
    --     --- 速度控制器

    --     --- 循环检测任务
    --     self.__right_joystick_for_mouse_task = self.inst:DoPeriodicTask(FRAMES,function()
    --         local right_joystick_used_flag = false
    --         if TheInput:IsControlPressed(CONTROL_INVENTORY_LEFT) then
    --             self:MouseMove(-self:GetSpeed(),0)
    --             right_joystick_used_flag = true
    --         end
    --         if TheInput:IsControlPressed(CONTROL_INVENTORY_RIGHT) then
    --             self:MouseMove(self:GetSpeed(),0)
    --             right_joystick_used_flag = true
    --         end
    --         if TheInput:IsControlPressed(CONTROL_INVENTORY_UP) then
    --             self:MouseMove(0,self:GetSpeed())
    --             right_joystick_used_flag = true
    --         end
    --         if TheInput:IsControlPressed(CONTROL_INVENTORY_DOWN) then
    --             self:MouseMove(0,-self:GetSpeed())
    --             right_joystick_used_flag = true
    --         end
    --         if right_joystick_used_flag then
    --             self:Speed_Up_By_Frame()
    --         else
    --             self:Speed_Down_By_Frame()
    --         end
    --     end)
    -- end
    -- function right_joystick_controller:Deactive()
    --     if ThePlayer ~= self.inst or TheFrontEnd == nil then
    --         return
    --     end
    --     TheFrontEnd:SetRightJoystickBlocking(false)
    --     if self.__right_joystick_for_mouse_task then
    --         self.__right_joystick_for_mouse_task:Cancel()
    --         self.__right_joystick_for_mouse_task = nil
    --     end
    -- end
------------------------------------------------------------------------------------------------------------------------------
---
    function right_joystick_controller:SetSpellBook(spellbook)
        if TheWorld.ismastersim then
            self.__net_inst:set(spellbook)
        end
        self.spellbook = spellbook
    end
    function right_joystick_controller:GetSpellBook()
        if TheWorld.ismastersim then
            return self.inst.components.right_joystick_controller:GetSpellBook()
        end
        return self.spellbook
    end
------------------------------------------------------------------------------------------------------------------------------
--- 安装函数和激活技能
    function right_joystick_controller:Install_And_Active_Spell(fn)
        local spellbook = self:GetSpellBook()
        if spellbook and type(fn) == "function" then
            fn(spellbook)
            if TheWorld.ismastersim then
                self.inst.components.right_joystick_controller:Install_And_Active_Spell(fn)
            end
            if not TheNet:IsDedicated() and ThePlayer == self.inst then
                local playercontroller = self.inst.components.playercontroller
                if playercontroller ~= nil then
                    playercontroller:StartAOETargetingUsing(spellbook)
                end
            end
        end        
    end
------------------------------------------------------------------------------------------------------------------------------
return right_joystick_controller







