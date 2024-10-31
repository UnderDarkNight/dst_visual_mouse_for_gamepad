---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    示例界面

]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 界面调试
local Widget = require "widgets/widget"
local Image = require "widgets/image" -- 引入image控件
local UIAnim = require "widgets/uianim"


local Screen = require "widgets/screen"
local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
local Menu = require "widgets/menu"
local Text = require "widgets/text"
local TEMPLATES = require "widgets/redux/templates"
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function IsCloseButton(key)
    if key == CONTROL_CANCEL or key == CONTROL_CONTROLLER_ALTACTION then
        return true
    end
    return false
end
local function IsSelectButton(key)
    --- X 56 55 68
    if key == CONTROL_CONTROLLER_ATTACK or key == CONTROL_PUTSTACK or key == CONTROL_MENU_MISC_1 then
        return true
    end
    --- Y 57 29(CONTROL_ACCEPT)
    if key == CONTROL_CONTROLLER_ACTION or key == CONTROL_ACCEPT  then
        return true
    end
    --- A 59 3 69
    if key == CONTROL_USE_ITEM_ON_ITEM or key == CONTROL_INSPECT or key == CONTROL_MENU_MISC_2 then
        return true
    end
    return false
end
local function GetMouseOverButtonInst(x,y)

    local entitiesundermouse = TheSim:GetEntitiesAtScreenPoint(x,y)
    -- print("num",#entitiesundermouse)
    if #entitiesundermouse > 0 then
        for k, temp_inst in pairs(entitiesundermouse) do
            if temp_inst.ButtonRoot then
                print("temp_inst.ButtonRoot",temp_inst)
            end
            local temp_parent_inst = temp_inst.entity:GetParent()
            if temp_parent_inst and temp_parent_inst.ButtonRoot then
                return temp_parent_inst
            end
            -- print("temp_inst",temp_inst,temp_inst.prefab,temp_inst.entity:GetParent())
        end
    end
     
end
local function install_visual_mouse_to_page(front_root)
    front_root.inst:DoTaskInTime(0.5,function()                
        ----------------------------------------------------------------------------------
        --- 一些参数
            local scrnw, scrnh = TheSim:GetScreenSize()
            local window_w,window_h = TheSim:GetWindowSize() -- 获取窗口大小
        ----------------------------------------------------------------------------------
        --- 基础节点
            local base_root = front_root:AddChild(Widget())
            base_root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            base_root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            base_root:SetPosition(0,0)
            base_root:SetScaleMode(SCALEMODE_NONE)   --- 缩放模式

            front_root.inst:ListenForEvent("onremove",function()
                base_root:Kill()
            end)
            base_root:SetClickable(false)
        ----------------------------------------------------------------------------------.
        ---- 根节点
            local root = base_root:AddChild(Widget())
            local main_scale = 0.6
            -- root:SetScale(main_scale,main_scale,main_scale)
        ----------------------------------------------------------------------------------
        ---- 虚拟鼠标
            local mouse_over_inst = nil
            local mouse = root:AddChild(Image("images/widgets/test_widget.xml", "mouse.tex"))
            function mouse:move(delta_x,delta_y)
                local x,y,z = self:GetPositionXYZ()
                local window_w,window_h = TheSim:GetWindowSize() -- 获取窗口大小
                x = math.clamp(x+delta_x,0,window_w)
                y = math.clamp(y+delta_y,0,window_h)                        
                self:SetPosition(x,y)
                
                TheInputProxy:SetOSCursorPos(x,y) -- 控制 实体鼠标 去指定坐标。（无法超出窗口）
                TheInputProxy:SetCursorVisible(false) -- 隐藏 实体鼠标

                local inst = GetMouseOverButtonInst(x,y)
                if inst and inst ~= mouse_over_inst then
                    mouse_over_inst = inst
                    -- mouse_over_inst.ButtonRoot:SetFocus()
                    -- mouse_over_inst.ButtonRoot:OnGainFocus()
                    ----------------------------------------------------------------------
                    -- mouse_over_inst.ButtonRoot.focus = true                            
                    TheFrontEnd:Update(0)
                    ----------------------------------------------------------------------
                elseif mouse_over_inst and inst == nil then
                    -- mouse_over_inst.ButtonRoot:OnLoseFocus()
                    ----------------------------------------------------------------------
                    -- mouse_over_inst.ButtonRoot.focus = false
                    ----------------------------------------------------------------------                            
                    mouse_over_inst = nil
                end
            end
            mouse:SetScale(main_scale,main_scale,main_scale)
            mouse:move(window_w/2,window_h/2)
        ----------------------------------------------------------------------------------
        ---- handler
            local handler = TheInput:AddGeneralControlHandler(function(key,down)
                if not down then
                    if IsCloseButton(key) then
                        front_root.inst:PushEvent("Kill")
                        return
                    end
                    if IsSelectButton(key) and mouse_over_inst then
                        -- mouse_over_inst.ButtonRoot:OnControl(MOUSEBUTTON_LEFT,true)
                        -- mouse_over_inst.ButtonRoot:OnLoseFocus()
                        -- mouse_over_inst.ButtonRoot:OnGainFocus()
                        -- print("focus",mouse_over_inst)
                        
                        -- local button = mouse_over_inst.ButtonRoot

                        -- print(button.control,button.mouseonly,button.down)
                        -- print("down",button:OnControl(button.control,true))
                        -- print(button:OnControl(button.control,false))

                        -- print(mouse_over_inst.ButtonRoot:OnControl(mouse_over_inst.ButtonRoot.control,true))
                        -- print(mouse_over_inst.ButtonRoot:OnControl(mouse_over_inst.ButtonRoot.control,false))
                        -- TheInput:OnMouseButton(mouse_over_inst.ButtonRoot.control,true,x,y)
                        -- mouse_over_inst.ButtonRoot:Select()
                    end
                end
            end)
            front_root.inst:ListenForEvent("onremove",function()
                handler:Remove()
            end)
            ----------------------------------------------------------------------
            --- 速度控制器
                local speed = 1
                local max_speed = 20
                local min_speed = 7
                local delta_speed = FRAMES*5

                local function GetSpeed()
                    return speed
                end
                local function Speed_Up()
                    speed = math.clamp(speed + delta_speed,min_speed,max_speed)                        
                end
                local function Speed_Down()
                    speed = math.clamp(speed - delta_speed,min_speed,max_speed)   
                end
            ----------------------------------------------------------------------
            base_root.inst:DoPeriodicTask(FRAMES,function()
                local speed_up_flag = false
                if TheInput:IsControlPressed(CONTROL_MOVE_UP) then
                    -- print("up",math.random(1,100))
                    mouse:move(0,GetSpeed())
                    speed_up_flag = true
                end
                if TheInput:IsControlPressed(CONTROL_MOVE_DOWN) then
                    -- print("down",math.random(1,100))
                    mouse:move(0,-GetSpeed())
                    speed_up_flag = true
                end
                if TheInput:IsControlPressed(CONTROL_MOVE_LEFT) then
                    -- print("left",math.random(1,100))
                    mouse:move(-GetSpeed(),0)
                    speed_up_flag = true
                end
                if TheInput:IsControlPressed(CONTROL_MOVE_RIGHT) then
                    -- print("right",math.random(1,100))
                    mouse:move(GetSpeed(),0)
                    speed_up_flag = true
                end
                if speed_up_flag then
                    Speed_Up()
                else
                    Speed_Down()
                end
            end)
        ----------------------------------------------------------------------------------
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

rawset(_G,"Visual_Mouse_Install_For_Screen",function(front_root)
    install_visual_mouse_to_page(front_root)
end)