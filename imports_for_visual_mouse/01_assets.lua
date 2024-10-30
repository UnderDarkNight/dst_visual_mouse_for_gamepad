
if Assets == nil then
    Assets = {}
end

local temp_assets = {


	---------------------------------------------------------------------------
	---
		Asset("IMAGE", "images/widgets/test_widget.tex"),
		Asset("ATLAS", "images/widgets/test_widget.xml"),
	---------------------------------------------------------------------------


}

for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end

