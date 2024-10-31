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

local function create_screen(front_root)
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
        -- install_visual_mouse_to_page(base_root)
        Visual_Mouse_Install_For_Screen(base_root)
        base_root.inst.prefab = "base_root"
    ----------------------------------------------------------------------------------
    ---
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
    return base_root
end

local function install_widget_open_event(inst)
    inst:ListenForEvent("OpenTestWidget",function()
        local front_root  = ThePlayer.HUD

        if front_root.test_widget then
            front_root.test_widget:PushEvent("Kill")
        end
        front_root.test_widget = create_screen(front_root)
        front_root.test_widget.inst:ListenForEvent("onremove",function()
            front_root.test_widget = nil
        end)
    end)
end
AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(0,function()
        if inst == ThePlayer and inst.HUD then
            install_widget_open_event(inst)
        end
    end)
end)


