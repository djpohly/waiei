local waieiInfo={
	BGScale="Off",
	Haishin="Off",
	BGRatio=1.333333,
};

function SetwaieiInfo(prm,var)
	if prm=="BGScale" then
		waieiInfo["BGScale"]=var;
	elseif prm=="Haishin" then
		waieiInfo["Haishin"]=var;
	elseif prm=="BGRatio" then
		if var~="" then
			waieiInfo["BGRatio"]=tonumber(var);
		else
			waieiInfo["BGRatio"]=1.333333;
		end;
	end;
end;

function Actor:scale_or_crop_background()
	local gw = self:GetWidth()
	local gh = self:GetHeight()

	local graphicAspect = gw/gh
	local displayAspect = DISPLAY:GetDisplayWidth()/DISPLAY:GetDisplayHeight()

	local bgs = waieiInfo["BGScale"];
	if not bgs then
		bgs = 'Fit';
	end;
	--[[
	if bgs == 'Cover' or
		math.abs(PREFSMAN:GetPreference("DisplayAspectRatio")-waieiInfo["BGRatio"])<= 0.01 then
		self:scaletocover( -SCREEN_WIDTH/2,-SCREEN_HEIGHT/2,SCREEN_WIDTH/2,SCREEN_HEIGHT/2 );
	else
		self:scaletofit( -SCREEN_WIDTH/2,-SCREEN_HEIGHT/2,SCREEN_WIDTH/2,SCREEN_HEIGHT/2 );
	end;
	self:Center();
	--]]
	if bgs == 'Cover' or
		math.abs(PREFSMAN:GetPreference("DisplayAspectRatio")-waieiInfo["BGRatio"])<= 0.01 then
		self:scaletocover( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
	else
		self:scaletofit( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
	end;

end;

function ScreenSelectMusic:setupmusicstagemods()
	Trace( "setupmusicstagemods" )
	local pm = GAMESTATE:GetPlayMode()

	if pm == "PlayMode_Battle" or pm == "PlayMode_Rave" then
		local so = GAMESTATE:GetDefaultSongOptions()
		GAMESTATE:SetSongOptions( "ModsLevel_Stage", so )
		MESSAGEMAN:Broadcast( "SongOptionsChanged" )
	elseif GAMESTATE:IsAnExtraStage() then
		if GAMESTATE:GetPreferredSongGroup() == "---Group All---" then
			local song = GAMESTATE:GetCurrentSong()
			GAMESTATE:SetPreferredSongGroup( song:GetGroupName() )
		end

		local bExtra2 = GAMESTATE:IsExtraStage2()
		local style = GAMESTATE:GetCurrentStyle()
		local song, steps = SONGMAN:GetExtraStageInfo( bExtra2, style )
		local po, so
		if bExtra2 then
			po = THEME:GetMetric("SongManager","OMESPlayerModifiers")
			so = THEME:GetMetric("SongManager","OMESStageModifiers")
		else
			po = THEME:GetMetric("SongManager","ExtraStagePlayerModifiers")
			so = THEME:GetMetric("SongManager","ExtraStageStageModifiers")
		end

		local difficulty = steps:GetDifficulty()
		local Reverse = PlayerNumber:Reverse()

		GAMESTATE:SetCurrentSong( song )
		GAMESTATE:SetPreferredSong( song )

		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			GAMESTATE:SetCurrentSteps( pn, steps )
--			GAMESTATE:GetPlayerState(pn):SetPlayerOptions( "ModsLevel_Stage", po )
			GAMESTATE:SetPreferredDifficulty( pn, difficulty )
--			MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
		end

--		GAMESTATE:SetSongOptions( "ModsLevel_Stage", so )
--		MESSAGEMAN:Broadcast( "SongOptionsChanged" )
	end
end;


function ScreenSelectMusic:setupcoursestagemods()
	local mode = GAMESTATE:GetPlayMode()

	if mode == "PlayMode_Oni" then
		local po = "clearall,default"
		local def_mod=PREFSMAN:GetPreference("DefaultModifiers");
		if def_mod~="" then
			po=po..","..def_mod..",1x,no reverse";
		end;
		-- Let SSMusic set battery.
		-- local so = "failimmediate,battery"
		local so = "failimmediate"
		local Reverse = PlayerNumber:Reverse()

		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			GAMESTATE:GetPlayerState(pn):SetPlayerOptions( "ModsLevel_Stage", po )
			MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
		end

		GAMESTATE:SetSongOptions( "ModsLevel_Stage", so )
		MESSAGEMAN:Broadcast( "SongOptionsChanged" )
	end
end;

local function CurGameName()
	return GAMESTATE:GetCurrentGame():GetName()
end

function ComboContinue()
	local Continue = {
		dance = GAMESTATE:GetPlayMode() == "PlayMode_Oni" and "TapNoteScore_W2" or GetUserPref_Theme("UserMinCombo"),
		pump = "TapNoteScore_W3",
		beat = "TapNoteScore_W3",
		kb7 = "TapNoteScore_W3",
		para = "TapNoteScore_W4"
	}
	return Continue[CurGameName()]
end

function ComboMaintain()
	local Maintain = {
		dance = GetUserPref_Theme("UserMinCombo"),
		pump = "TapNoteScore_W4",
		beat = "TapNoteScore_W3",
		kb7 = "TapNoteScore_W3",
		para = "TapNoteScore_W4"
	}
	return Maintain[CurGameName()]
end

function GameCompatibleModes()
	local Modes = {
		dance = "Single,Versus,Double,Solo,Couple",
		pump = "Single,Versus,Double,HalfDouble,Couple,Routine",
		beat = "5Keys,Versus5,7Keys,10Keys,14Keys,Versus7",
		kb7 = "KB7",
		para = "Single",
		maniax = "Single,Versus,Double",
		-- todo: add versus modes for technomotion
		techno = "Single4,Single5,Single8,Double4,Double5,Double8",
		lights = "Single" -- lights shouldn't be playable
	}
	return Modes[CurGameName()]
end

function Actor:LyricCommand(side)
	self:settext( Var "LyricText" )
	self:draworder(102)

	self:stoptweening()
	self:shadowlengthx(0)
	self:shadowlengthy(5)
	self:strokecolor(color("#000000"))

	local Zoom = SCREEN_WIDTH / (self:GetZoomedWidth()+1)
	if( Zoom > 1 ) then
		Zoom = 1
	end
	self:zoomx( Zoom )

	local lyricColor = Var "LyricColor"
	local Factor = 1
	if side == "Back" then
		Factor = 0.5
	elseif side == "Front" then
		Factor = 0.9
	end
	self:diffuse( {
		lyricColor[1] * Factor,
		lyricColor[2] * Factor,
		lyricColor[3] * Factor,
		lyricColor[4] * Factor } )

	if side == "Front" then
		self:cropright(0)
	else
		self:cropleft(1)
	end

	self:diffusealpha(0)
	self:linear(0.2)
	self:diffusealpha(0.75)
	self:linear( Var "LyricDuration" * 0.75)
	--[[
	if side == "Front" then
		self:cropright(0)
	else
		self:cropleft(1)
	end
	--]]
	self:sleep( Var "LyricDuration" * 0.25 )
	self:linear(0.05)
	self:diffusealpha(0)
end
