--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local flg,error_code = pcall(function()
    print("WARNING:PCALL START +++++++++++++++++++++++++++++++++++++++++++++++++")
    local x,y,z =    ThePlayer.Transform:GetWorldPosition()  
    ----------------------------------------------------------------------------------------------------------------
    -- 虚拟鼠标
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
        local function setup_visual_mouset(front_root)
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

                    local speed = 10
                    base_root.inst:DoPeriodicTask(FRAMES,function()
                        if TheInput:IsControlPressed(CONTROL_MOVE_UP) then
                            -- print("up",math.random(1,100))
                            mouse:move(0,speed)
                        end
                        if TheInput:IsControlPressed(CONTROL_MOVE_DOWN) then
                            -- print("down",math.random(1,100))
                            mouse:move(0,-speed)
                        end
                        if TheInput:IsControlPressed(CONTROL_MOVE_LEFT) then
                            -- print("left",math.random(1,100))
                            mouse:move(-speed,0)
                        end
                        if TheInput:IsControlPressed(CONTROL_MOVE_RIGHT) then
                            -- print("right",math.random(1,100))
                            mouse:move(speed,0)
                        end
                    end)
                ----------------------------------------------------------------------------------
            end)
        end
    ----------------------------------------------------------------------------------------------------------------
    --
       local front_root  = ThePlayer.HUD

        if front_root.__test_root  then
            -- front_root.__test_root:Kill()
            front_root.__test_root.inst:PushEvent("Kill")
        end
        ----------------------------------------------------------------------------------
        --- 基础根节点创建，用来进行主锚点定义，以及控制移动控制
            local base_root = front_root:AddChild(Screen())
            TheFrontEnd:PushScreen(base_root) -- 激活根节点并锁定移动控制
            base_root.inst:ListenForEvent("Kill",function()
                TheFrontEnd:PopScreen(base_root) -- 移除根节点并解锁移动控制
                base_root:Kill() -- 移除根节点
                print("info widget killed")
            end)
            base_root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            base_root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            base_root:SetPosition(0,0)
            base_root:MoveToBack()
            base_root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式

            base_root.inst:ListenForEvent("onremove",function()
                print("base root on remove event active")
            end)
            setup_visual_mouset(base_root)
            base_root.inst.prefab = "base_root"
        ----------------------------------------------------------------------------------
        --- 界面绘画用的 根节点
            local root = base_root:AddChild(Widget())
            local main_scale = 0.6
            root:SetScale(main_scale, main_scale,main_scale)
            root.inst:ListenForEvent("Kill",function()
                base_root.inst:PushEvent("Kill")
            end)
            root.inst.prefab = "test_root"
        ----------------------------------------------------------------------------------
        --- 背景
            local bg = root:AddChild(Image("images/widgets/test_widget.xml", "background.tex"))
            bg.inst.prefab = "test_bg"
        ----------------------------------------------------------------------------------
        --- 关闭按钮
            local button_close = root:AddChild(ImageButton("images/widgets/test_widget.xml", 
                "button_close.tex",
                "button_close.tex",
                "button_close.tex",
                "button_close.tex",
                "button_close.tex"        
            ))
            button_close:SetOnClick(function()
                root.inst:PushEvent("Kill")
            end)
            button_close:SetPosition(500,300,0)
            button_close.inst.prefab = "test_button_close"
        ----------------------------------------------------------------------------------
        --- 测试按钮
            local points = {
                Vector3(-350,200,0) , Vector3(0,200,0) , Vector3(350,200,0),
                Vector3(-350,0,0) , Vector3(0,0,0) , Vector3(350,0,0),
                Vector3(-350,-200,0) , Vector3(0,-200,0) , Vector3(350,-200,0),
            }

            for i, pt in ipairs(points) do
                local temp_button = root:AddChild(ImageButton("images/global_redux.xml",
                    "button_carny_long_normal.tex",
                    "button_carny_long_hover.tex",
                    "button_carny_long_disabled.tex",
                    "button_carny_long_down.tex"
                ))
                temp_button:SetPosition(pt.x,pt.y,0)
                temp_button:SetOnClick(function()
                    local x,y,z = temp_button:GetPositionXYZ()
                    print("button click",i,x,y,z)
                end)
                temp_button.inst.prefab = "test_button"
                temp_button.image.inst.prefab = "test_button_image"

                -- temp_button.old_OnControl = temp_button.OnControl
                -- temp_button.OnControl = function(self, key, down)
                --     print("button control",key,down)
                --     return self.old_OnControl(self,key,down)
                -- end

                -- local old_OnGainFocus = temp_button.OnGainFocus
                -- temp_button.OnGainFocus = function(self,...)
                --     print("fake error ++++++++++++")
                --     print("fake error ++++++++++++")
                --     print("fake error ++++++++++++")
                --     print("fake error ++++++++++++")
                --     print("fake error ++++++++++++")
                --     return old_OnGainFocus(self,...)
                -- end

            end
        ----------------------------------------------------------------------------------



        
        ----------------------------------------------------------------------------------
        front_root.__test_root = base_root
    ----------------------------------------------------------------------------------------------------------------
    
        TUNING.__test_update_fn = function()
            local self = TheFrontEnd
            -- print(TheFrontEnd.saving_indicator)
            -- print(TheFrontEnd:IsControlsDisabled())
            -- print(TheInput:ControllerAttached())
            -- print(self.consoletext.shown)
            -- print(#self.updating_widgets_alt)
            -- self.helptext:Hide()
            -- print(self.helptext)
            -- self:UpdateHelpTextSize(1)
        end
        TUNING.__test_update_post_fn = function()
            -- local self = TheFrontEnd

            -- self.helptext:Show()
        end

    
        -- print(type(TheInputProxy))
        -- local _TheInputProxy = getmetatable(TheInputProxy).__index
        -- for k, v in pairs(_TheInputProxy) do
        --     print(k,v)
        -- end
        TheInputProxy:SetCursorVisible(true)
        -- TheInputProxy:SetCursorVisible(false)
        -- TheInputProxy:SetOSCursorPos(x,y)
        local window_w,window_h = TheSim:GetWindowSize() -- 获取窗口大小
        -- TheInputProxy:SetOSCursorPos(100,200)
        TheInputProxy:SetOSCursorPos(window_w,window_h)

    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))