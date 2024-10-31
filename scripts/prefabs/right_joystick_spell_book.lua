
local assets = {

}
local function ReticuleTargetAllowWaterFn()
	local player = ThePlayer
	local ground = TheWorld.Map
	local pos = Vector3()
	--Cast range is 8, leave room for error
	--4 is the aoe range
	for r = 7, 0, -.25 do
		pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
		if ground:IsPassableAtPoint(pos.x, 0, pos.z, true) and not ground:IsGroundTargetBlocked(pos) then
			return pos
		end
	end
	return pos
end
local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	-- MakeInventoryPhysics(inst)

	-- inst.AnimState:SetBank("book_maxwell")
	-- inst.AnimState:SetBuild("book_maxwell")
	-- inst.AnimState:PlayAnimation("idle")

	-- inst:AddTag("book")
	inst:AddTag("FX")
	inst:AddTag("fx")
	inst:AddTag("INLIMBO")
	inst:AddTag("nosteal")
	-- inst:AddTag("shadowmagic")

	-- MakeInventoryFloatable(inst, "med", nil, 0.75)

	inst:AddComponent("spellbook")
	-- inst.components.spellbook:SetRequiredTag("shadowmagic")
	inst.components.spellbook:SetRadius(1)
	inst.components.spellbook:SetFocusRadius(1)
    inst.components.spellbook.CanBeUsedBy = function()
        return true
    end
    inst.components.spellbook.SelectSpell = function()
        return true
    end

	inst:AddComponent("aoetargeting")
	inst.components.aoetargeting:SetAllowWater(true)
	inst.components.aoetargeting.reticule.targetfn = ReticuleTargetAllowWaterFn
	inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
	inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
	inst.components.aoetargeting.reticule.ease = true
	inst.components.aoetargeting.reticule.mouseenabled = true
	inst.components.aoetargeting.reticule.twinstickmode = 1
	inst.components.aoetargeting.reticule.twinstickrange = 8


	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	-- inst:AddComponent("inspectable")
	-- inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.keepondeath = true
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.RIGHT_JOYSTICK_SPELL_BOOK


	inst:AddComponent("aoespell")
	inst:AddComponent("spellcaster")

    inst:DoTaskInTime(0,function()
        if inst.Ready ~= true then
            inst:Remove()
        end
    end)


	return inst
end

return Prefab("right_joystick_spell_book", fn, assets)