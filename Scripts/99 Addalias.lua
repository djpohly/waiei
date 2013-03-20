-- [ja] 何度も同じの書くのめんどいんで 

-- [ja] デバッグ用
function _SYS(text)
	SCREENMAN:SystemMessage(""..text);
end;

-- [ja] 曲 
function _SONG()
	return GAMESTATE:GetCurrentSong();
end;

-- [ja] 曲の現在地 
function _MUSICSECOND()
	return GAMESTATE:GetSongPosition():GetMusicSeconds();
end;

-- [ja] コース 
function _COURSE()
	return GAMESTATE:GetCurrentCourse();
end;

-- MaxStage
function _MAXSTAGE()
	return PREFSMAN:GetPreference("SongsPerPlay");
end;

-- [ja] 難易度名 
local DDRSNDif = {
	Beginner	= "Beginner",
	Easy		= "Basic",
	Medium		= "Difficult",
	Hard		= "Expert",
	Challenge	= "Challenge",
	Edit 		= "Edit",
	Couple		= "Couple",
	Routine		= "Routine"
};
local DDREXTREMEDif = {
	Beginner	= "Beginner",
	Easy		= "Light",
	Medium		= "Standard",
	Hard		= "Heavy",
	Challenge	= "Challenge",
	Edit 		= "Edit",
	Couple		= "Couple",
	Routine		= "Routine"
};
local DDRDif = {
	Beginner	= "Beginner",
	Easy		= "Basic",
	Medium		= "Another",
	Hard		= "Maniac",
	Challenge	= "SManiac",
	Edit 		= "Edit",
	Couple		= "Couple",
	Routine		= "Routine"
};
function _DifficultyNAME(dif)
	local sdif=ToEnumShortString(dif);
	local ret="";
	if GetUserPref_Theme("UserDifficultyName") then
		if GetUserPref_Theme("UserDifficultyName")=='DDR SuperNOVA' then
			ret=DDRSNDif[sdif];
		elseif GetUserPref_Theme("UserDifficultyName")=='DDR EXTREME' then
			ret=DDREXTREMEDif[sdif];
		elseif GetUserPref_Theme("UserDifficultyName")=='DDR' then
			ret=DDRDif[sdif];
		else
			ret=THEME:GetString("CustomDifficulty",sdif);
		end;
	else
		ret=THEME:GetString("CustomDifficulty",sdif);
	end;
	return ret;
end;
function _DifficultyNAME2(difname,dif)
	local sdif=ToEnumShortString(dif);
	local ret="";
	if difname=="DDR SuperNOVA" then
		ret=DDRSNDif[sdif];
	elseif difname=="DDR EXTREME" then
		ret=DDREXTREMEDif[sdif];
	elseif difname=="DDR" then
		ret=DDRDif[sdif];
	else
		ret=THEME:GetString("CustomDifficulty",sdif);
	end;
	return ret;
end;

-- [ja] 難易度色 
local DDRCol = {
		Beginner	= color("#1cd8ff"),			-- light cyan
		Easy		= color("#fee600"),			-- green
		Medium		= color("#ff2f39"),			-- yellow
		Hard		= color("#2cff00"),			-- red
		Challenge	= color("#C032ff"),			-- light blue
		Edit		= color("0.8,0.8,0.8,1"),	-- gray
		Couple		= color("#ed0972"),			-- hot pink
		Routine		= color("#ff9a00")			-- orange
};
function _DifficultyCOLOR(dif)
	local sdif=ToEnumShortString(dif);
	local ret=color("#ffffff");
	if GetUserPref_Theme("UserDifficultyColor") then
		if GetUserPref_Theme("UserDifficultyColor")=='DDR' then
			ret=DDRCol[sdif];
		else
			ret=CustomDifficultyToColor(sdif);
		end;
	else
		ret=CustomDifficultyToColor(sdif);
	end;
	return ret;
end;
function _DifficultyLightCOLOR(dif)
	local c = _DifficultyCOLOR(dif)
	return { scale(c[1],0,1,0.5,1), scale(c[2],0,1,0.5,1), scale(c[3],0,1,0.5,1), c[4] }
end
function _DifficultyCOLOR2(difcolor,dif)
	local sdif=ToEnumShortString(dif);
	local ret=color("#ffffff");
	if difcolor=='DDR' then
		ret=DDRCol[sdif];
	else
		ret=CustomDifficultyToColor(sdif);
	end;
	return ret;
end;
function _DifficultyLightCOLOR2(difcolor,dif)
	local c = _DifficultyCOLOR2(difcolor,dif)
	return { scale(c[1],0,1,0.5,1), scale(c[2],0,1,0.5,1), scale(c[3],0,1,0.5,1), c[4] }
end

-- [ja] Darkカラーは ColorDarkTone(_DifficultyCOLOR(dif)) で可 

-- [ja] 通常のライトトーンより自然な色になるので 
function ColorLightTone2(c)
	return { scale(c[1],0,1,0.5,1), scale(c[2],0,1,0.5,1), scale(c[3],0,1,0.5,1), c[4] }
end

-- [ja] 判定名 
local DDRJud = {
	W1		= "Marvelous",
	W2		= "Perfect",
	W3		= "Great",
	W4		= "Good",
	W5		= "Boo",
	Miss	= "Miss",
	Held	= "O.K.",
	MaxCombo	= "Max Combo"
};
local DDRSNJud = {
	W1		= "Marvelous",
	W2		= "Perfect",
	W3		= "Great",
	W4		= "Good",
	W5		= "Almost",
	Miss	= "Boo",
	Held	= "O.K.",
	MaxCombo	= "Max Combo"
};
function _JudgementLabel(jud)
	local sjud=ToEnumShortString(jud);
	local ret="";
	if GetUserPref_Theme("UserJudgementLabel") then
		if GetUserPref_Theme("UserJudgementLabel")=='DDR' then
			ret=DDRJud[sjud];
		elseif GetUserPref_Theme("UserJudgementLabel")=='DDR SuperNOVA' then
			ret=DDRSNJud[sjud];
		else
			ret=THEME:GetString("JudgmentLine",sjud);
		end;
	else
		ret=THEME:GetString("JudgmentLine",sjud);
	end;
	return ret;
end;
function _JudgementLabel2(judlabel,jud)
	local sjud=ToEnumShortString(jud);
	local ret="";
	if judlabel then
		ret=DDRJud[sjud];
	elseif judlabel then
		ret=DDRSNJud[sjud];
	else
		ret=THEME:GetString("JudgmentLine",sjud);
	end;
	return ret;
end;
