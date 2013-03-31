-- [ja] 旧バージョンではDataフォルダに保存していたが公式曰く非推奨 
local PrefOldPath = "Data/UserPrefs/waiei/";
local PrefPath = "Save/UserPrefs/waiei/";

--[[ begin internal stuff; no need to edit below this line. ]]

-- Local internal function to write envs. ___Not for themer use.___
local function WriteEnv(envName,envValue)
	return setenv(envName,envValue)
end

function ReadPrefFromFile_Theme(name)
	local f = RageFileUtil.CreateRageFile()
	local fullFilename = PrefPath..name..".cfg"
	local fullOldFilename = PrefOldPath..name..".cfg"
	local option

	if f:Open(fullFilename,1) then
		option = tostring( f:Read() )
		WriteEnv(name,option)
		f:destroy()
		return option
	elseif f:Open(fullOldFilename,1) then
		option = tostring( f:Read() )
		WriteEnv(name,option)
		f:destroy()
		return option
	else
		local fError = f:GetError()
		Trace( "[FileUtils] Error reading ".. fullFilename ..": ".. fError )
		f:ClearError()
		f:destroy()
		return nil
	end
end

function WritePrefToFile_Theme(name,value)
	local f = RageFileUtil.CreateRageFile()
	local fullFilename = PrefPath..name..".cfg"

	if f:Open(fullFilename, 2) then
		f:Write( tostring(value) )
		WriteEnv(name,value)
	else
		local fError = f:GetError()
		Trace( "[FileUtils] Error writing to ".. fullFilename ..": ".. fError )
		f:ClearError()
		f:destroy()
		return false
	end

	f:destroy()
	return true
end

--[[ end internal functions; still don't edit below this line ]]

function GetUserPref_Theme(name)
	return ReadPrefFromFile_Theme(name)
end

function SetUserPref_Theme(name,value)
	return WritePrefToFile_Theme(name,value)
end
-- [ja] ここまで_fallbackから抜き出し＋命令や変数名が被らないように修正 

local function OptionNameString(str)
	return THEME:GetString('OptionNames',str)
end

-- Example usage of new system (not really implemented yet)
local Prefs =
{
	AutoSetStyle =
	{
		Default = false,
		Choices = { "ON", "OFF" },
		Values = { true, false }
	},
	GameplayShowScore =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	LongFail =
	{
		Default = false,
		Choices = { OptionNameString('Short'), OptionNameString('Long') },
		Values = { false, true }
	},
	NotePosition =
	{
		Default = true,
		Choices = { OptionNameString('Normal'), OptionNameString('Lower') },
		Values = { true, false }
	},
	ComboOnRolls =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	FlashyCombo =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ComboUnderField =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
}

ThemePrefs.InitAll(Prefs)

function InitUserPrefs_Theme()
	local Prefs = {
		UserScreenFilterP1 = 'Off',
		UserScreenFilterP2 = 'Off',
		UserLightEffect = 'Auto',
		UserBGScale = 'Fit',
		UserBGAtoLua = 'Auto',
		UserHoldJudgmentType = 'DDR',
		UserDifficultyName = 'StepMania',
		UserDifficultyColor = 'StepMania',
		UserJudgementLabel = 'StepMania',
		UserMeterType = 'Default',
		UserMineHitMiss = 'false',
		UserHaishin = 'Off',
		UserScoreMode = 'Default',
		UserSpeedAssistP1 = 'Off',
		UserSpeedAssistP2 = 'Off',
		UserTarget = 'Off',
		UserColor = 'Blue',
		UserColorPath = '',
		UserLife = 'Default',
		UserCustomScore = 'Off',
		UserMinCombo = 'TapNoteScore_W3',
		UserWheelMode = 'Jacket->Banner',
		UserWheelText = 'Default'
	}
	for k, v in pairs(Prefs) do
		-- kind of xxx
		-- local GetPref = type(v) == "boolean" and GetUserPrefB or GetUserPref
		if GetUserPref_Theme(k) == nil then
			SetUserPref_Theme(k, v)
		end
	end
end

InitUserPrefs_Theme();

-- [ja] 追加部分

function UserLightEffect()
	local t = {
		Name = "UserLightEffect",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Never','Auto','Always' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserLightEffect") ~= nil then
				if (GetUserPref_Theme("UserLightEffect")=='Auto') then
					list[2] = true
				elseif (GetUserPref_Theme("UserLightEffect")=='Always') then
					list[3] = true
				else
					list[1] = true
				end
			else
				SetUserPref_Theme("UserLightEffect", 'Auto');
				list[2] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local val;
			if list[1] then val='Never'; elseif list[2] then val='Auto'; else val='Always'; end;
			SetUserPref_Theme("UserLightEffect", val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end
	}
	setmetatable(t, t)
	return t
end

function UserHoldJudgmentType()
	local t = {
		Name = "UserHoldJudgmentType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'StepMania','DDR' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserHoldJudgmentType") ~= nil then
				if (GetUserPref_Theme("UserHoldJudgmentType")=='DDR') then
					list[2] = true
				else
					list[1] = true
				end
			else
				SetUserPref_Theme("UserHoldJudgmentType", 'StepMania');
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local val = list[2] and 'DDR' or 'StepMania';
			SetUserPref_Theme("UserHoldJudgmentType", val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end
	}
	setmetatable(t, t)
	return t
end

function UserBGAtoLua()
	local t = {
		Name = "UserBGAtoLua",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Never','Auto','Always' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserBGAtoLua") ~= nil then
				if (GetUserPref_Theme("UserBGAtoLua")=='Auto') then
					list[2] = true
				elseif (GetUserPref_Theme("UserBGAtoLua")=='Always') then
					list[3] = true
				else
					list[1] = true
				end
			else
				SetUserPref_Theme("UserBGAtoLua", 'Auto');
				list[2] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local val;
			if list[1] then val='Never'; elseif list[2] then val='Auto'; else val='Always'; end;
			SetUserPref_Theme("UserBGAtoLua", val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end
	}
	setmetatable(t, t)
	return t
end

function PlayerJudgment()
	local t = {
		Name = "UserPlayerJudgment",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'DDR','DDR SuperNOVA','ITG','Emoticon' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserJudgementLabel" .. ToEnumShortString(pn)) ~= nil then
				
				local bJudgment=GetUserPref_Theme("UserJudgementLabel" .. ToEnumShortString(pn));
				
				if bJudgment == 'DDR' then
					list[1] = true
				elseif bJudgment == 'SuperNOVA' then
					list[2] = true
				elseif bJudgment == 'ITG' then
					list[3] = true
				elseif bJudgment == 'Emoticon' then
					list[4] = true
				end;
				
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='DDR';
			elseif list[2] then
				bSave='SuperNOVA';
			elseif list[3] then
				bSave='ITG';
			elseif list[4] then
				bSave='Emoticon';
			end;
			SetUserPref_Theme("UserJudgementLabel" .. ToEnumShortString(pn), bSave);
		end
	}
	setmetatable(t, t)
	return t
end	

function UserScreenFilter()
	local t = {
		Name = "UserScreenFilter",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'Off','25%','50%','75%','100%' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserScreenFilter" .. ToEnumShortString(pn)) ~= nil then
				local bShow=GetUserPref_Theme("UserScreenFilter" .. ToEnumShortString(pn));
				if bShow == 'Off' then
					list[1] = true
				elseif bShow == '25%' then
					list[2] = true
				elseif bShow == '50%' then
					list[3] = true
				elseif bShow == '75%' then
					list[4] = true
				else
					list[5] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Off';
			elseif list[2] then
				bSave='25%';
			elseif list[3] then
				bSave='50%';
			elseif list[4] then
				bSave='75%';
			elseif list[5] then
				bSave='100%';
			end;
			SetUserPref_Theme("UserScreenFilter" .. ToEnumShortString(pn), bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserBGScale()
	local t = {
		Name = "UserBGScale",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Fit','Cover' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserBGScale") ~= nil then
				if GetUserPref_Theme("UserBGScale") == 'Fit' then
					list[1] = true
				else
					list[2] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Fit';
			else
				bSave='Cover';
			end;
			SetUserPref_Theme("UserBGScale", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserDifficultyName()
	local t = {
		Name = "UserDifficultyName",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'StepMania','DDR','DDR EXTREME','DDR SuperNOVA' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserDifficultyName") ~= nil then
				if GetUserPref_Theme("UserDifficultyName") == 'DDR' then
					list[2] = true
				elseif GetUserPref_Theme("UserDifficultyName") == 'DDR EXTREME' then
					list[3] = true
				elseif GetUserPref_Theme("UserDifficultyName") == 'DDR SuperNOVA' then
					list[4] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='DDR';
			elseif list[3] then
				bSave='DDR EXTREME';
			elseif list[4] then
				bSave='DDR SuperNOVA';
			else
				bSave='StepMania';
			end;
			SetUserPref_Theme("UserDifficultyName", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserDifficultyColor()
	local t = {
		Name = "UserDifficultyColor",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'StepMania','DDR' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserDifficultyColor") ~= nil then
				if GetUserPref_Theme("UserDifficultyColor") == 'DDR' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='DDR';
			else
				bSave='StepMania';
			end;
			SetUserPref_Theme("UserDifficultyColor", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserJudgementLabel()
	local t = {
		Name = "UserJudgementLabel",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'StepMania','DDR','DDR SuperNOVA' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserJudgementLabel") ~= nil then
				if GetUserPref_Theme("UserJudgementLabel") == 'DDR' then
					list[2] = true
				elseif GetUserPref_Theme("UserJudgementLabel") == 'DDR SuperNOVA' then
					list[3] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='DDR';
			elseif list[3] then
				bSave='DDR SuperNOVA';
			else
				bSave='StepMania';
			end;
			SetUserPref_Theme("UserJudgementLabel", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserMeterType()
	local t = {
		Name = "UserMeterType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Default','DDR (MAX12)','DDR (MAX10)','DDR X','LV100','LV20' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserMeterType") ~= nil then
				if GetUserPref_Theme("UserMeterType") == 'DDR' then
					list[2] = true
				elseif GetUserPref_Theme("UserMeterType") == 'DDR MAX10' then
					list[3] = true
				elseif GetUserPref_Theme("UserMeterType") == 'DDR X' then
					list[4] = true
				elseif GetUserPref_Theme("UserMeterType") == 'LV100' then
					list[5] = true
				elseif GetUserPref_Theme("UserMeterType") == 'LV20' then
					list[6] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='DDR';
			elseif list[3] then
				bSave='DDR MAX10';
			elseif list[4] then
				bSave='DDR X';
			elseif list[5] then
				bSave='LV100';
			elseif list[6] then
				bSave='LV20';
			else
				bSave='Default';
			end;
			SetUserPref_Theme("UserMeterType", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserMineHitMiss()
	local t = {
		Name = "UserMineHitMiss",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'false','true' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserMineHitMiss") ~= nil then
				if GetUserPref_Theme("UserMineHitMiss") == 'false' then
					list[1] = true
				else
					list[2] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave=false;
			else
				bSave=true;
			end;
			SetUserPref_Theme("UserMineHitMiss", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserHaishin()
	local t = {
		Name = "UserHaishin",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserHaishin") ~= nil then
				if GetUserPref_Theme("UserHaishin") == 'On' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='On';
			else
				bSave='Off';
			end;
			SetUserPref_Theme("UserHaishin", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserScoreMode()
	local t = {
		Name = "UserScoreMode",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Default','DDR SuperNOVA2','DancePoints' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserScoreMode") ~= nil then
				if GetUserPref_Theme("UserScoreMode") == 'DDR SuperNOVA2' then
					list[2] = true
				elseif GetUserPref_Theme("UserScoreMode") == 'DancePoints' then
					list[3] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='DDR SuperNOVA2';
			elseif list[3] then
				bSave='DancePoints';
			else
				bSave='Default';
			end;
			SetUserPref_Theme("UserScoreMode", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserSpeedAssist()
	local t = {
		Name = "UserSpeedAssist",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserSpeedAssist" .. ToEnumShortString(pn)) ~= nil then
				if GetUserPref_Theme("UserSpeedAssist" .. ToEnumShortString(pn)) == 'On' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='On';
			else
				bSave='Off';
			end;
			SetUserPref_Theme("UserSpeedAssist" .. ToEnumShortString(pn), bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserTarget()
	local t = {
		Name = "UserTarget",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserTarget") ~= nil then
				if GetUserPref_Theme("UserTarget") == 'On' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='On';
			else
				bSave='Off';
			end;
			SetUserPref_Theme("UserTarget", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserColor()
	local t = {
		Name = "UserColor",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Blue','Black','Ice' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserColor") ~= nil then
				if GetUserPref_Theme("UserColor") == 'Blue' then
					list[1] = true
				elseif GetUserPref_Theme("UserColor") == 'Ice' then
					list[3] = true
				else
					list[2] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Blue';
			elseif list[3] then
				bSave='Ice';
			else
				bSave='Black';
			end;
			SetUserPref_Theme("UserColor", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserLife()
	local t = {
		Name = "UserLife",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Default','Beta' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserLife") ~= nil then
				if GetUserPref_Theme("UserLife") == 'Beta' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='Beta';
			else
				bSave='Default';
			end;
			SetUserPref_Theme("UserLife", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserCustomScore()
	local customscore=GetCustomScoreMode();
	local t = {
		Name = "UserCustomScore",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','3.9',"Hybrid","SuperNOVA2" },
		LoadSelections = function(self, list, pn)
			if customscore=="old" then
				if GetUserPref("UserPrefScoringMode") ~= nil then
					if GetUserPref("UserPrefScoringMode") == 'DDR Extreme' then
						list[2] = true
					elseif GetUserPref("UserPrefScoringMode") == 'Hybrid' then
						list[3] = true
					elseif GetUserPref("UserPrefScoringMode") == 'DDR SuperNOVA 2' then
						list[4] = true
					else
						list[1] = true
					end;
				else
					list[1] = true
				end;
			elseif customscore~="non" then
				if GetUserPref_Theme("UserCustomScore") ~= nil then
					if GetUserPref_Theme("UserCustomScore") == '3.9' then
						list[2] = true
					elseif GetUserPref_Theme("UserCustomScore") == 'Hybrid' then
						list[3] = true
					elseif GetUserPref_Theme("UserCustomScore") == 'SuperNOVA2' then
						list[4] = true
					else
						list[1] = true
					end;
				else
					list[1] = true
				end;
			else
				list[1] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			local bSaveF;
			local bSaveT;
			if customscore~="non" then
				if list[2] then
					bSaveF='DDR Extreme';
					bSaveT='3.9';
				elseif list[3] then
					bSaveF='Hybrid';
					bSaveT='Hybrid';
				elseif list[4] then
					bSaveF='DDR SuperNOVA 2';
					bSaveT='SuperNOVA2';
				else
					bSaveF='DDR Extreme';
					bSaveT='Off';
				end;
				SetUserPref("UserPrefScoringMode", bSaveF);
				SetUserPref_Theme("UserCustomScore", bSaveT);
			else
				SetUserPref("UserCustomScore", "DDR Extreme");
				SetUserPref_Theme("UserCustomScore", "Off");
			end;
		end
	}
	setmetatable(t, t)
	return t
end

function UserMinCombo()
	local t = {
		Name = "UserMinCombo",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'W1','W2',"W3 (Default)","W4" },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserMinCombo") ~= nil then
				if GetUserPref_Theme("UserMinCombo") == 'TapNoteScore_W1' then
					list[1] = true
				elseif GetUserPref_Theme("UserMinCombo") == 'TapNoteScore_W2' then
					list[2] = true
				elseif GetUserPref_Theme("UserMinCombo") == 'TapNoteScore_W4' then
					list[4] = true
				else
					list[3] = true
				end;
			else
				list[3] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			if list[1] then
				SetUserPref_Theme("UserMinCombo", 'TapNoteScore_W1');
			elseif list[2] then
				SetUserPref_Theme("UserMinCombo", 'TapNoteScore_W2');
			elseif list[4] then
				SetUserPref_Theme("UserMinCombo", 'TapNoteScore_W4');
			else
				SetUserPref_Theme("UserMinCombo", 'TapNoteScore_W3');
			end;
		end
	}
	setmetatable(t, t)
	return t
end

function UserWheelMode()
	local t = {
		Name = "UserWheelMode",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Jacket->Banner','Jacket->BG','Banner->Jacket' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserWheelMode") ~= nil then
				if GetUserPref_Theme("UserWheelMode") == 'Jacket->Banner' then
					list[1] = true
				elseif GetUserPref_Theme("UserWheelMode") == 'Jacket->BG' then
					list[2] = true
				elseif GetUserPref_Theme("UserWheelMode") == 'Banner->Jacket' then
					list[3] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			if list[1] then
				SetUserPref_Theme("UserWheelMode", 'Jacket->Banner');
			elseif list[2] then
				SetUserPref_Theme("UserWheelMode", 'Jacket->BG');
			elseif list[3] then
				SetUserPref_Theme("UserWheelMode", 'Banner->Jacket');
			else
				SetUserPref_Theme("UserWheelMode", 'Jacket->Banner');
			end;
		end
	}
	setmetatable(t, t)
	return t
end

function UserWheelText()
	local t = {
		Name = "UserWheelText",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'None','Default','All' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserWheelText") ~= nil then
				if GetUserPref_Theme("UserWheelText") == 'None' then
					list[1] = true
				elseif GetUserPref_Theme("UserWheelText") == 'All' then
					list[3] = true
				else
					list[2] = true
				end;
			else
				list[2] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			if list[1] then
				SetUserPref_Theme("UserWheelText", 'None');
			elseif list[3] then
				SetUserPref_Theme("UserWheelText", 'All');
			else
				SetUserPref_Theme("UserWheelText", 'Default');
			end;
		end
	}
	setmetatable(t, t)
	return t
end

--[[ end option rows ]]
