--[ja] ボスフォルダ関係の命令 
--[[
	EXF_ScreenTitleMenu_background();
	EXF_ScreenSelectMusic_decorations();
	EXF_ScreenStageInformation_underlay();
	EXF_ScreenGameplay();
	EXF_ScreenEvaluation();
--]]

function EXF_ScreenTitleMenu()
	return Def.Quad{
		InitCommand=cmd(visible,false);
		OnCommand=function(self)
			EXF_ScreenTitleMenu_On();
		end;
	};
end;

function EXF_ScreenTitleMenu_On()
	-- [ja] ExFolderの設定が残っている場合削除 
	if GetUserPref_Theme("ExFolderFlag") then
		if GetUserPref_Theme("ExFolderFlag")~="" then
			SetUserPref_Theme("ExFolderFlag","");
		end;
	end;
end;

function EXF_ScreenSelectMusic()
	return Def.Quad{
		InitCommand=cmd(visible,false);
		BeginCommand=function(self)
			EXF_ScreenSelectMusic_Begin();
		end;
	};
end;

function EXF_ScreenSelectMusic_Begin()
	-- [ja] 強制EX2専用フォルダ 
	if GetUserPref_Theme("ExFolderFlag")=="Ex1Result"
		and GetGroupParameter(GetUserPref_Theme("ExGroupName"),"Extra2List")~="" then
		SetUserPref_Theme("ExFolderFlag","Ex2SelectMusic");
		SCREENMAN:SetNewScreen("ScreenSelectExMusic");
	elseif GetUserPref_Theme("ExFolderFlag")=="Ex1GamePlay" then
		SetUserPref_Theme("ExFolderFlag","Ex1SelectMusic");
		SCREENMAN:SetNewScreen("ScreenSelectExMusic");
	elseif GetUserPref_Theme("ExFolderFlag")=="Ex2GamePlay" then
		SetUserPref_Theme("ExFolderFlag","Ex2SelectMusic");
		SCREENMAN:SetNewScreen("ScreenSelectExMusic");
	elseif GetUserPref_Theme("ExGroupName")~="" then
	--	GAMESTATE:ApplyGameCommand( "mod,bar");
	--	MESSAGEMAN:Broadcast( "SongOptionsChanged" );
		SetUserPref_Theme("ExLifeLevel","Normal");
		SetUserPref_Theme("ExGroupName","");
		SetUserPref_Theme("ExFolderFlag","");
		SetUserPref_Theme("ExDifficultyP1","");
		SetUserPref_Theme("ExDifficultyP2","");
	end;
end;

function EXF_ScreenStageInformation()
	return Def.Quad{
		InitCommand=function(self)
			EXF_ScreenStageInformation_Begin();
		end;
	};
end;

function EXF_ScreenStageInformation_Init()
	-- [ja] オプションで意図しない難易度に変更されている可能性があるので強制的に設定する 
	for pn=1,2 do
		if GAMESTATE:IsHumanPlayer('PlayerNumber_P'..pn) then
			GAMESTATE:SetCurrentSteps('PlayerNumber_P'..pn,
				_SONG():GetOneSteps(GAMESTATE:GetCurrentStyle():GetStepsType(),GetUserPref_Theme("ExDifficultyP"..pn)));
		end;
	end;
	-- ------
	if GAMESTATE:IsAnExtraStage()
		and (GetUserPref_Theme("ExFolderFlag")~="Ex1GamePlay"
		and GetUserPref_Theme("ExFolderFlag")~="Ex2GamePlay") then
		if GAMESTATE:GetPreferredSongGroup() == "---Group All---" then
			local song = GAMESTATE:GetCurrentSong()
			GAMESTATE:SetPreferredSongGroup( song:GetGroupName() )
		end

		local bExtra2 = GAMESTATE:IsExtraStage2()
		local style = GAMESTATE:GetCurrentStyle()
		local song, steps = SONGMAN:GetExtraStageInfo( bExtra2, style )
		local po, so
		if bExtra2 then
			local f=OpenFile("/Songs/"..GetActiveGroupName().."/extra2.crs");
			if not f then
				f=OpenFile("/AdditionalSongs/"..GetActiveGroupName().."/extra2.crs");
			end;
			if f then
				local opt=split(":",GetFileParameter(f,"song"))[3];
				local opt=string.lower(opt);
				local life=GetFileParameter(f,"lives");
				if life=="" or life=="1" then
					life="1 life";
				else
					life=""..life.." lives";
				end;
				if string.find(opt,"battery",0,true) then
					so="faildefault,battery,"..life.."";
				elseif string.find(opt,"norecover",0,true) then
					so="bar,failimmediate,norecover";
				elseif string.find(opt,"suddendeath",0,true) then
					so="bar,failimmediate,suddendeath";
				else
					so="bar,failimmediate,normal-drain";
				end;
				opt=string.gsub(opt,",",", ");
				CloseFile(f);
				for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
					local ps = GAMESTATE:GetPlayerState(pn);
					local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", "..opt;
					ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
					ps:SetPlayerOptions('ModsLevel_Song', modstr);
				end;
				GAMESTATE:SetSongOptions( "ModsLevel_Stage", so );
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				so=nil;
			else
				po = THEME:GetMetric("SongManager","OMESPlayerModifiers");
				so = THEME:GetMetric("SongManager","OMESStageModifiers");
			end;
		else
			local f=OpenFile("/Songs/"..GetActiveGroupName().."/extra1.crs");
			if not f then
				f=OpenFile("/AdditionalSongs/"..GetActiveGroupName().."/extra1.crs");
			end;
			if f then
				local opt=split(":",GetFileParameter(f,"song"))[3];
				local opt=string.lower(opt);
				local life=GetFileParameter(f,"lives");
				if life=="" then
					life="4 lives";
				elseif life=="1" then
					life="1 life";
				else
					life=""..life.." lives";
				end;
				if string.find(opt,"battery",0,true) then
					so="faildefault,battery,"..life.."";
				elseif string.find(opt,"norecover",0,true) then
					so="bar,failimmediate,norecover";
				elseif string.find(opt,"suddendeath",0,true) then
					so="bar,failimmediate,suddendeath";
				else
					so="bar,failimmediate,normal-drain";
				end;
				opt=string.gsub(opt,",",", ");
				CloseFile(f);
				for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
					local ps = GAMESTATE:GetPlayerState(pn);
					local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", "..opt;
					ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
					ps:SetPlayerOptions('ModsLevel_Song', modstr);
				end;
				GAMESTATE:SetSongOptions( "ModsLevel_Stage", so );
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				so=nil;
			else
				po = THEME:GetMetric("SongManager","ExtraStagePlayerModifiers");
				so = THEME:GetMetric("SongManager","ExtraStageStageModifiers");
			end;
		end;
		
		if po or so then
			local difficulty = steps:GetDifficulty()
			local Reverse = PlayerNumber:Reverse()

			GAMESTATE:SetCurrentSong( song )
			GAMESTATE:SetPreferredSong( song )

			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				GAMESTATE:SetCurrentSteps( pn, steps )
				GAMESTATE:GetPlayerState(pn):SetPlayerOptions( "ModsLevel_Stage", po )
				GAMESTATE:SetPreferredDifficulty( pn, difficulty )
				MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
			end
			GAMESTATE:SetSongOptions( "ModsLevel_Stage", so )
			MESSAGEMAN:Broadcast( "SongOptionsChanged" )
		end;
	elseif GetUserPref_Theme("ExFolderFlag")=="Ex1GamePlay"
		or GetUserPref_Theme("ExFolderFlag")=="Ex2GamePlay" then
		-- [ja] 強制的に現在の設定を反映させることでEXステージでもプレイヤーオプションが初期化されない 
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			local ps = GAMESTATE:GetPlayerState(pn);
			local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Stage");
			ps:SetPlayerOptions("ModsLevel_Stage", modstr);
			MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
		end
		EXFolderLifeSetting();
	end;
end;

function EXF_ScreenGameplay()
	return Def.Quad{
		InitCommand=cmd(visible,false;);
		OffCommand=function(self)
			EXF_ScreenGameplay_Off();
		end;
	};
end;

function EXF_ScreenGameplay_Off()
	if GetUserPref_Theme("ExGroupName")~="" then
		SetUserPref_Theme("ExLifeLevel","Normal");
	end;
end;

function EXF_ScreenEvaluation()
	return Def.Quad{
		InitCommand=cmd(visible,false);
		BeginCommand=function(self)
			EXF_ScreenEvaluation_Begin();
		end;
	};
end;

function EXF_ScreenEvaluation_Begin()
	local chk_grade=false;
	if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
		local player_grade=STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetGrade();
		if player_grade=="Grade_Tier01" or player_grade=="Grade_Tier02"
			or player_grade=="Grade_Tier03" then
			chk_grade=true;
		end;
	end;
	if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		local player_grade=STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetGrade();
		if player_grade=="Grade_Tier01" or player_grade=="Grade_Tier02"
			or player_grade=="Grade_Tier03" then
			chk_grade=true;
		end;
	end;

	if GetUserPref_Theme("ExFolderFlag") then
		if GetUserPref_Theme("ExFolderFlag")=="Ex1GamePlay"	and chk_grade then
			GAMESTATE:ApplyGameCommand( "mod,bar");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			GAMESTATE:ApplyGameCommand( "mod,normal-drain");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			SetUserPref_Theme("ExFolderFlag","Ex1Result");
			SetUserPref_Theme("ExGroupName",GetActiveGroupName());
		elseif GetUserPref_Theme("ExFolderFlag")=="Ex2GamePlay" or GetUserPref_Theme("ExFolderFlag")=="Ex1GamePlay" then
			GAMESTATE:ApplyGameCommand( "mod,bar");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			GAMESTATE:ApplyGameCommand( "mod,normal-drain");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			GAMESTATE:ApplyGameCommand( "mod,4 lives");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			SetUserPref_Theme("ExLifeLevel","Normal");
			SetUserPref_Theme("ExGroupName","");
			SetUserPref_Theme("ExFolderFlag","");
			SetUserPref_Theme("ExDifficultyP1","");
			SetUserPref_Theme("ExDifficultyP2","");
		else
		--[ja] ExFolder以外の場合、意図的にバッテリーライフにしている可能性があるので初期化しない 
		--[[
			GAMESTATE:ApplyGameCommand( "mod,bar");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			GAMESTATE:ApplyGameCommand( "mod,normal-drain");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
		--]]
			SetUserPref_Theme("ExLifeLevel","Normal");
			SetUserPref_Theme("ExGroupName","");
			SetUserPref_Theme("ExFolderFlag","");
			SetUserPref_Theme("ExDifficultyP1","");
			SetUserPref_Theme("ExDifficultyP2","");
		end;
	end;
end;
