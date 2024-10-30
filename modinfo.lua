author = "幕夜之下"
-- from stringutil.lua

local function ChooseTranslationTable_Test(_table)
  if ChooseTranslationTable then
    return ChooseTranslationTable(_table)
  else
    return _table["zh"]
  end
end


----------------------------------------------------------------------------
--- 版本号管理（暂定）：最后一位为内部开发版本号，或者修复小bug的时候进行增量。
---                   倒数第二位为对外发布的内容量版本号，有新内容的时候进行增量。
---                   第二位为大版本号，进行主题更新、大DLC发布的时候进行增量。
---                   第一位暂时预留。 
----------------------------------------------------------------------------
local the_version = "0.02.00.00008"



local function Check_Mod_is_Internal_Version()
  return false
end

local function GetName()
  ----------------------------------------------------------------------------
  ---- 参数表： loc.lua 里面的localizations 表，code 为 这里用的index
  local temp_table = {
      "手柄虚拟鼠标",                               ----- 默认情况下(英文)
      ["zh"] = "手柄虚拟鼠标",                                 ----- 中文
  }

  local temp_table_internal = {
    "手柄虚拟鼠标",                               ----- 默认情况下(英文)
    ["zh"] = "手柄虚拟鼠标",                                 ----- 中文
  }

  if Check_Mod_is_Internal_Version() then
    return ChooseTranslationTable_Test(temp_table_internal)
  end
  return ChooseTranslationTable_Test(temp_table)
end

local function GetDesc()
    local temp_table = {
      [[
        
      ]],
      ["zh"] = [[

      ]]
    }
    local ret = the_version .. "  \n  "..ChooseTranslationTable_Test(temp_table)
    return ret
end

name = GetName()
description = GetDesc()

version = the_version ------ MOD版本，上传的时候必须和已经在工坊的版本不一样

api_version = 10
icon_atlas = "modicon.xml"
icon = "modicon.tex"
forumthread = ""
dont_starve_compatible = true
dst_compatible = true
all_clients_require_mod = true

-- priority = -10000000000  -- MOD加载优先级 影响某些功能的兼容性，比如官方Com 的 Hook
priority = 10000000000  -- MOD加载优先级 影响某些功能的兼容性，比如官方Com 的 Hook

configuration_options =
{
   
}
