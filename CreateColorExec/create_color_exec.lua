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


local function MyMain(display_handle)
	-- run Function
  local root = Root();
  -- Store all Display Settings in a  Table and define the middle of Display 1
  local DisplayPath=root.GraphicsRoot.PultCollect[1].DisplayCollect:Children()
  local DisplayMidW=math.floor(DisplayPath[1].W /2)
  local DisplayMidH=math.floor(DisplayPath[1].H /2)

	-- Store all Groups in a Table
	local FixtureGroups=root.ShowData.DataPools.Default.Groups:Children()
	
  -- Store all ColorGel in a Table
  local ColorPath = root.ShowData.GelPools
  local ColorGels = ColorPath:Children()

  -- Store all Used CustomImage in a Table to find free number, and define the Images
  local tblImages = root.ShowData.ImagePools.Custom:Children()
  local intImageNr
  for k in pairs(tblImages) do 
    intImageNr = k
  end
  if intImageNr == nil then
    intImageNr=0
  end
  local tbkImageImport = {
    {Name="\"White-on\"",FileName="\"white-on.png\"",Filepath="\"../lib_plugins/CreateColorExec/images\""},
    {Name="\"White-off\"",FileName="\"white-off.png\"",Filepath="\"../lib_plugins/CreateColorExec/images\""}
  }
  
  -- Store all Used Appearances in a Table to find free number
  local tblAppearances = root.ShowData.Appearances:Children()
  local intAppNr
  for k in pairs(tblAppearances) do 
    intAppNr = k
  end
  
  -- same same with Layout
  local tblLayout = root.ShowData.DataPools.Default.Layouts:Children()
  local tblLayoutNr
  for k in pairs(tblLayout) do 
    tblLayoutNr = k
  end
  local intLayoutElementX
  local intLayoutElementY=tblLayout[tblLayoutNr].DimensionH
  
  
  -- Define more
  local intLayoutElementW=100
  local intLayoutElementH=100
  local intLayoutElementNr=1
  local intAppNrNow
  local intAppNrNeed
  local intAppCreatet = 0
  local tblColors
  local strSeqName
  local strColorName
  local strColorCode
  local strAppNameOn
  local strAppNameOff
  local strAppOn="\"Showdata.ImagePools.Custom.White-on\""
  local strAppOff="\"Showdata.ImagePools.Custom.White-off\""
  local intColornr
  local selgroup
  local choisefix
  local choiseGel
  local selColorGel 
  local SelectedGroup = {};
  local SelectedGel;
  local Message = "Add Fixture Group and ColorGel, set beginning Sequence Number\n\n Selected Group(s) are: \n";
  local ColorGelButton = "Add ColorGel";
  local SeqNrStart = 801;
  local SeqNrText = "SeqNr";
  
---- Main Box
  ::MainBox::
  local box = MessageBox(
    {
      title='Test',
      message= Message,
      commands={
        {name='Cancel', value=0},
        {name='Add Group', value=11},
        {name=ColorGelButton, value=12},
        {name='Ok GO!', value=1}
      },
      inputs={
        {name=SeqNrText, value=SeqNrStart, maxTextLength=3}
      }
    }
   );

  if(box.result==11) then
    local count = 0;
    for k in pairs(FixtureGroups) do
      count = count + 1
    end
    if(count==0) then
      Printf("all Groups are added")
      Confirm ("all Groups are added")
      SeqNrStart=box.inputs.SeqNr
      goto MainBox
    else
      Printf("add Group")
      SeqNrStart=box.inputs.SeqNr
      goto addGroup
    end
  elseif(box.result==12) then
    Printf("add ColorGel")
    SeqNrStart=box.inputs.SeqNr
    goto addColorGel
  elseif(box.result==1) then
    if SelectedGel == nil then
      Confirm ("no ColorGel are selected!")
      SeqNrStart=box.inputs.SeqNr
      goto addColorGel
    elseif next(SelectedGroup) == nil then
      Confirm ("no Group are added!")
      SeqNrStart=box.inputs.SeqNr
      goto addGroup
    else
      SeqNrStart=box.inputs.SeqNr
      Printf("now i do some Magic stuff...")
      goto doMagicStuff
    end
  elseif(box.result==0) then
    Printf("User Cancled")
    goto cancle
  end  
---- End Main Box  
  

  
---- Choise Fixture Group  
	-- Create a Choise for each Group in Table
  ::addGroup::
  choisefix = {};
	for k in ipairs(FixtureGroups) do
		table.insert(choisefix,"'"..FixtureGroups[k].name.."'")        
	end
	-- Setup the Messagebox
	library.PrintSystemMonitorMessage(2);
	selgroup = PopupInput("Select Fixture Group", display_handle, choisefix, "", DisplayMidW,DisplayMidH);
  table.insert(SelectedGroup,"'"..FixtureGroups[selgroup+1].name.."'")
  Message = Message .. FixtureGroups[selgroup+1].name .."\n"
  Printf("Select Group "..FixtureGroups[selgroup+1].name)
  table.remove(FixtureGroups,selgroup+1)
  goto MainBox
---- End Choise Fixture Group	

---- Choise ColorGel  
	-- Create a Choise for each Group in Table
  ::addColorGel::
  choiseGel = {};
	for k in ipairs(ColorGels) do
		table.insert(choiseGel,"'"..ColorGels[k].name.."'")        
	end
	-- Setup the Messagebox
	library.PrintSystemMonitorMessage(2);
	selColorGel = PopupInput("Select ColorGel", display_handle, choiseGel, "", DisplayMidW,DisplayMidH);
  SelectedGel = ColorGels[selColorGel+1].name;
  SelectedGelNr = selColorGel+1
  Printf("ColorGel "..ColorGels[selColorGel+1].name.." selected")
  ColorGelButton="ColorGel "..ColorGels[selColorGel+1].name.." selected"
  goto MainBox
---- End ColorGel	


---- Magic Stuff
  ::doMagicStuff::
  
---- Import Images
  intImageNr = math.floor(intImageNr + 1);
  Printf(tbkImageImport[1].Name)
  Printf(tbkImageImport[1].FileName)
  Printf(tbkImageImport[1].Filepath)
  Cmd("Store Image 3."..intImageNr.." "..tbkImageImport[1].Name.." Filename="..tbkImageImport[1].FileName.." filepath="..tbkImageImport[1].Filepath.."")
  intImageNr = math.floor(intImageNr + 1);
  Cmd("Store Image 3."..intImageNr.." "..tbkImageImport[2].Name.." Filename="..tbkImageImport[2].FileName.." filepath="..tbkImageImport[2].Filepath.."")
---- End Images  
 
---- Create Appearances/Sequences
  
  -- Create new Layout View
  tblLayoutNr = tblLayoutNr +1
  Cmd("Store Layout "..tblLayoutNr.." Colors")
  
  tblColors = ColorPath:Children()[SelectedGelNr]
  
  for g in ipairs(SelectedGroup) do
  intAppNrNow = math.floor(intAppNr + 1);
  intAppNrNeed = math.floor(intAppNr + 1);
  intLayoutElementX=0
  intLayoutElementY = math.floor(intLayoutElementY - intLayoutElementH)
    for col in ipairs(tblColors) do
      strColorCode="\""..tblColors[col].r..","..tblColors[col].g..","..tblColors[col].b..",1\""
      strColorName=tblColors[col].name
      intColornr=SelectedGelNr.."."..tblColors[col].no
      
      -- Cretae Appearances only 1 times
      if(intAppCreatet==0) then
        strAppNameOn="\""..strColorName.." on\""
        strAppNameOff="\""..strColorName.." off\""
        Cmd("Store App "..intAppNrNow.." "..strAppNameOn.." Appearance="..strAppOn.." color="..strColorCode.."")
        intAppNrNow = math.floor(intAppNrNow + 1);
        Cmd("Store App "..intAppNrNow.." "..strAppNameOff.." Appearance="..strAppOff.." color="..strColorCode.."")
        intAppNrNow = math.floor(intAppNrNow + 1);
      end
      -- end Appearances

      -- Create Sequences
      strSeqName=strColorName.." "..SelectedGroup[g]:gsub('\'', '')
      Cmd("clearall;Group "..SelectedGroup[g].." at Gel "..intColornr..";Store Sequence "..SeqNrStart.." \""..strSeqName.."\"")
      -- Add Cmd to Squence
      Cmd("set seq "..SeqNrStart.." cue \"CueZero\" cmd=\"Set Layout "..tblLayoutNr.."."..intLayoutElementNr.." Appearance="..intAppNrNeed.."\"")
      Cmd("set seq "..SeqNrStart.." cue \"OffCue\" cmd=\"Set Layout "..tblLayoutNr.."."..intLayoutElementNr.." Appearance="..intAppNrNeed + 1 .."\"")
      -- end Sequences
      
      -- Add Squences to Layout
      intAppNrNeed = math.floor(intAppNrNeed + 1); --Set Nr App to off
      Cmd("Assign Seq "..SeqNrStart.." at Layout "..tblLayoutNr)
      Cmd("Set Layout "..tblLayoutNr.."."..intLayoutElementNr.." appearance="..intAppNrNeed.." Positionx="..intLayoutElementX.." Positiony="..intLayoutElementY.." Positionw="..intLayoutElementW.." Positionh="..intLayoutElementH.." Objectname=0 bar=0")
      
      
      
      intAppNrNeed = math.floor(intAppNrNeed + 1); --Set App Nr to next off
      intLayoutElementX = math.floor(intLayoutElementX + intLayoutElementW + 20)
      
      
      
      intLayoutElementNr=math.floor(intLayoutElementNr + 1)
      -- end Squences to Layout
      
      SeqNrStart = math.floor(SeqNrStart + 1)
    end
    intAppCreatet = 1
    intLayoutElementY=math.floor(intLayoutElementY-20)
  end
  
---- end Appearances/Sequences 


::cancle::
end

--

return MyMain