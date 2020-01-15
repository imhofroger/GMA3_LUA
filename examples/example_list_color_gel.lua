---------------------------------------------------------------------------
local pluginName    = select(1,...);
local componentName = select(2,...); 
local signalTable   = select(3,...);
local my_handle     = select(4,...);
---------------------------------------------------------------------------
-- **************************************************
-- **Scriptname		: example_list_color_gel.lua
-- **Description	: Write the Color with Code from a chosen ColorGel Group
-- **Author			: Roger Imhof
-- **Github			: https://github.com/imhofroger/GMA3_LUA
-- **Date			: 15.01.2020
-- **************************************************

local function MyMain(display_handle)
	-- run Function
	local root = Root();
	local path = root.ShowData.GelPools;
	local ColorGels=path:Children()
	
	-- Create a Choise for each Gel Group in Table
	local choise = {};
	for k in ipairs(ColorGels) do
		table.insert(choise,"'"..ColorGels[k].name.."'")        
	end
	
	-- Setup the Messagebox with Gel Groups to Choise
	library.PrintSystemMonitorMessage(2);
	local ret = PopupInput("Select Plugin Option", display_handle, choise);
	
	-- Write the Color from the chosen GelGroup
	local Color=path:Children()[ret+1]
	for k in ipairs(Color) do
		Echo(""..Color[k].name.." with Color Code r:"..Color[k].r..", g:"..Color[k].g..", b:"..Color[k].b.."")    
	end

end

return MyMain
