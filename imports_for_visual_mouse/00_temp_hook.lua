---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- AddGlobalClassPostConstruct("widgets/widget", "Widget", function(self,name)

--     -- print("create new widget",name)

--     local old_Show = self.Show
--     self.Show = function(self,...)
--         print("show widget",name)
--         return old_Show(self,...)
--     end

-- end)


require("frontend")
local TheFrontEnd = _G.FrontEnd

-- local old_PushScreen = TheFrontEnd.PushScreen
-- TheFrontEnd.PushScreen = function(self, ...)
--     print("++++++++ push screen",...)
--     return old_PushScreen(self, ...)
-- end

local ignore_apis = {
    ["Update"] = true,    
}

-- for index, value in pairs(TheFrontEnd) do
--     if type(value) == "function" and not ignore_apis[index] then
--         local old = TheFrontEnd[index]
--         TheFrontEnd[index] = function(self,...)
--             print("call TheFrontEnd",index,...)
--             return old(self,...)
--         end
--     end
-- end

local old_Update = TheFrontEnd.Update

TheFrontEnd.Update = function(self, dt)
    if TUNING.__test_update_fn then
        TUNING.__test_update_fn(dt)
    end
    local ret = { old_Update(self, dt)}
    if TUNING.__test_update_post_fn then
        TUNING.__test_update_post_fn(dt)
    end
    return unpack(ret)
end



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local TheInput = require("input")

-- local old_OnControl = TheInput.OnControl

-- TheInput.OnControl = function(self, control, digitalvalue, analogvalue)
--     print("OnControl",control,digitalvalue,analogvalue)
--     return old_OnControl(self, control, digitalvalue, analogvalue)
-- end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------