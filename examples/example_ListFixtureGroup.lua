---------------------------------------------------------------------------
local pluginName    = select(1,...);
local componentName = select(2,...); 
local signalTable   = select(3,...);
local my_handle     = select(4,...);
---------------------------------------------------------------------------
-- **************************************************
-- **Scriptname		:
-- **Description	: 
-- **Author			: Roger Imhof
-- **Github			: https://github.com/imhofroger/GMA3_LUA
-- **Date			: 14.01.2020
-- **************************************************

function ListFixtureGroups()
	local root = Root();
	-- Store all Groups to a Table
	local FixtureGroups=root.ShowData.DataPools.Default.Groups:Children()

	return FixtureGroups
end

--

local function MyMain(display_handle)
	-- run Function
	local FixtureGroups = ListFixtureGroups();
	
	-- Create a Choise for each Group in Table
	local choise = {};
	for k in ipairs(FixtureGroups) do
		table.insert(choise,"'"..FixtureGroups[k].name.."'")        
	end
	
	-- Setup the Messagebox
	local ret = PopupInput("Select Plugin Option", display_handle, choise);
	-- Select the Choised Group with Cmd
	Cmd("SelFix Group '"..FixtureGroups[ret+1].name.."'")
	
end

--

return MyMain

