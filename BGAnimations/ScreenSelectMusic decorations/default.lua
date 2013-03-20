local t = LoadFallbackB();

t[#t+1]=EXF_ScreenSelectMusic();

-- Legacy StepMania 4 Function
local function StepsDisplay(pn)
	local function set(self, player)
		self:SetFromGameState( player );
	end

	local t = Def.StepsDisplay {
		InitCommand=cmd(Load,"StepsDisplay",GAMESTATE:GetPlayerState(pn););
	};

	if pn == PLAYER_1 then
		t.CurrentStepsP1ChangedMessageCommand=function(self) set(self, pn); end;
		t.CurrentTrailP1ChangedMessageCommand=function(self) set(self, pn); end;
	else
		t.CurrentStepsP2ChangedMessageCommand=function(self) set(self, pn); end;
		t.CurrentTrailP2ChangedMessageCommand=function(self) set(self, pn); end;
	end

	return t;
end

t[#t+1] = StandardDecorationFromFileOptional("AlternateHelpDisplay","AlternateHelpDisplay");

local function PercentScore(pn)
	local t = LoadFont("Common normal")..{
		InitCommand=cmd(zoom,0.625;shadowlength,1);
		BeginCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			local SongOrCourse, StepsOrTrail;
			if GAMESTATE:IsCourseMode() then
				SongOrCourse = GAMESTATE:GetCurrentCourse();
				StepsOrTrail = GAMESTATE:GetCurrentTrail(pn);
			else
				SongOrCourse = GAMESTATE:GetCurrentSong();
				StepsOrTrail = GAMESTATE:GetCurrentSteps(pn);
			end;

			local profile, scorelist;
			local text = "";
			if SongOrCourse and StepsOrTrail then
				local st = StepsOrTrail:GetStepsType();
				local diff = StepsOrTrail:GetDifficulty();
				local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
				local cd = GetCustomDifficulty(st, diff, courseType);
				self:diffuse(CustomDifficultyToColor(cd));
				self:shadowcolor(CustomDifficultyToDarkColor(cd));

				if PROFILEMAN:IsPersistentProfile(pn) then
					-- player profile
					profile = PROFILEMAN:GetProfile(pn);
				else
					-- machine profile
					profile = PROFILEMAN:GetMachineProfile();
				end;

				scorelist = profile:GetHighScoreList(SongOrCourse,StepsOrTrail);
				assert(scorelist)
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];
				if topscore then
					text = string.format("%.2f%%", topscore:GetPercentDP()*100.0);
					-- 100% hack
					if text == "100.00%" then
						text = "100%";
					end;
				else
					text = string.format("%.2f%%", 0);
				end;
			else
				text = "";
			end;
			self:settext(text);
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
	};

	if pn == PLAYER_1 then
		t.CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
		t.CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
	else
		t.CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
		t.CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	end

	return t;
end

-- Legacy StepMania 4 Function
--[[
for pn in ivalues(PlayerNumber) do
	local MetricsName = "StepsDisplay" .. PlayerNumberToString(pn);
	t[#t+1] = StepsDisplay(pn) .. {
		InitCommand=function(self) self:player(pn); self:name(MetricsName); ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen"); end;
		PlayerJoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:visible(true);
				(cmd(zoom,0;bounceend,0.3;zoom,1))(self);
			end;
		end;
		PlayerUnjoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:visible(true);
				(cmd(bouncebegin,0.3;zoom,0))(self);
			end;
		end;
	};
	if ShowStandardDecoration("PercentScore"..ToEnumShortString(pn)) then
		t[#t+1] = StandardDecorationFromTable("PercentScore"..ToEnumShortString(pn), PercentScore(pn));
	end;
end
--]]

t[#t+1] = StandardDecorationFromFileOptional("BannerFrame","BannerFrame");
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,THEME:GetMetric("ScreenSelectMusic","BannerFrameX");y,THEME:GetMetric("ScreenSelectMusic","BannerFrameY"));
	--[[
	LoadActor(THEME:GetPathG("ScreenSelectMusic","BannerFrame/split"))..{
		InitCommand=function(self)
			self:x(-30);
		end;
		SetMessageCommand=function(self)
			self:stoptweening();
			local st=GAMESTATE:GetCurrentSteps(GetSidePlayer(PLAYER_1));
			if true then
				self:visible(true);
			else
				self:visible(false);
			end;
			if SCREEN_HEIGHT/SCREEN_WIDTH>=0.65 then
				self:y(22);
			else
				self:y(52);
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	};
	--]]
};
t[#t+1] = StandardDecorationFromFileOptional("DifficultyList","DifficultyList");
t[#t+1] = StandardDecorationFromFileOptional("CourseContentsList","CourseContentsList");
t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay")..{
	SetCommand=function(self)
		local st=GAMESTATE:GetCurrentStyle():GetStepsType();
		local f=0;
		local song=_SONG();
		if tonumber(VersionDate())>=20120408 then
			if song then
				for i=1,6 do
					if song:HasStepsTypeAndDifficulty(st,Difficulty[i]) then
						if song:IsStepsUsingDifferentTiming(song:GetOneSteps(st,Difficulty[i])) then
							f=10;
							break;
						end;
					end;
				end;
			end;
		end;
		if SCREEN_HEIGHT/SCREEN_WIDTH>=0.65 then
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-100+30-f);
		else
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-100-f);
		end;
	end;
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
	OnCommand=cmd(maxwidth,128;horizalign,left;strokecolor,Color("Outline");playcommand,"Set";decelerate,0.2;zoomx,1;);
	BeginCommand=cmd(zoomx,0;);
};
t[#t+1] = StandardDecorationFromFileOptional("BPMLabel","BPMLabel")..{
	SetCommand=function(self)
		local st=GAMESTATE:GetCurrentStyle():GetStepsType();
		local f=0;
		local song=_SONG();
		if tonumber(VersionDate())>=20120408 then
			if song then
				for i=1,6 do
					if song:HasStepsTypeAndDifficulty(st,Difficulty[i]) then
						if song:IsStepsUsingDifferentTiming(song:GetOneSteps(st,Difficulty[i])) then
							f=10;
							break;
						end;
					end;
				end;
			end;
		end;
		
		
		if SCREEN_HEIGHT/SCREEN_WIDTH>=0.65 then
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-100+30-f);
		else
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-100-f);
		end;
	end;
	CurrentSongChangedMessageCommand=cmd(finishtweening;linear,0.2;playcommand,"Set");
	OnCommand=cmd(finishtweening;playcommand,"Set";decelerate,0.2;addx,SCREEN_CENTER_X;zoomx,1;);
	BeginCommand=cmd(zoomx,0;addx,-SCREEN_CENTER_X;);
};
t[#t+1] = StandardDecorationFromFileOptional("SegmentDisplay","SegmentDisplay");
--[[ t[#t+1] = StandardDecorationFromFileOptional("NegativeDisplay","NegativeDisplay") .. {
}; --]]

t[#t+1] = StandardDecorationFromFileOptional("SongTime","SongTime") .. {
	SetCommand=function(self)
		local curSelection = nil;
		local length = 0.0;
		self:x(SCREEN_CENTER_X-137);
		local f=0;
		if GAMESTATE:IsCourseMode() then
			curSelection = GAMESTATE:GetCurrentCourse();
			if curSelection then
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				if trail then
					length = TrailUtil.GetTotalSeconds(trail);
				else
					length = 0.0;
				end;
			else
				length = 0.0;
			end;
		else
			curSelection = _SONG();
			if curSelection then
				length = curSelection:MusicLengthSeconds();
				if curSelection:IsLong() then
					f=10;
				elseif curSelection:IsMarathon() then
					f=10;
				else
					f=0;
				end
			else
				length = 0.0;
			end;
		end;
		if SCREEN_HEIGHT/SCREEN_WIDTH>=0.65 then
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-100+30-f);
		else
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-100-f);
		end;
		(cmd(zoom,0.75;strokecolor,Color("Outline");shadowlength,1;))(self);
		self:settext( SecondsToMSS(length) );
	end;
	OnCommand=cmd(finishtweening;playcommand,"Set");
	CurrentSongChangedMessageCommand=cmd(finishtweening;linear,0.2;playcommand,"Set");
	CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
};

if not GAMESTATE:IsCourseMode() then
	t[#t+1] = StandardDecorationFromFileOptional("NewSong","NewSong") .. {
	 	NewShowCommand=THEME:GetMetric("ScreenSelectMusic", "NewSongShowCommand" );
	 	NewHideCommand=THEME:GetMetric("ScreenSelectMusic", "NewSongHideCommand" );
		InitCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
	-- 		local pTargetProfile;
			local sSong;
			-- Start!
			if GAMESTATE:GetCurrentSong() then
				if PROFILEMAN:IsSongNew(GAMESTATE:GetCurrentSong()) then
					self:playcommand("NewShow");
				else
					self:playcommand("NewHide");
				end
			else
				self:playcommand("NewHide");
			end
		end;
	};
	t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");
	t[#t+1] = StandardDecorationFromFileOptional("CustomCDTitle","CDTitle");
end;

if GAMESTATE:IsCourseMode() then
	t[#t+1] = StandardDecorationFromFileOptional("NumCourseSongs","NumCourseSongs")..{
		InitCommand=cmd(horizalign,right);
		SetCommand=function(self)
			local curSelection= nil;
			local sAppend = "";
			if GAMESTATE:IsCourseMode() then
				curSelection = GAMESTATE:GetCurrentCourse();
				if curSelection then
					sAppend = (curSelection:GetEstimatedNumStages() == 1) and "Stage" or "Stages";
					self:visible(true);
					self:settext( curSelection:GetEstimatedNumStages() .. " " .. sAppend);
				else
					self:visible(false);
				end;
			else
				self:visible(false);
			end;
		end;
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
	};
end

--t[#t+1] = StandardDecorationFromFileOptional("DifficultyDisplay","DifficultyDisplay");
t[#t+1] = StandardDecorationFromFileOptional("SortOrderFrame","SortOrderFrame") .. {
--[[ 	BeginCommand=cmd(playcommand,"Set");
	SortOrderChangedMessageCommand=cmd(playcommand,"Set";);
	SetCommand=function(self)
		local s = SortOrderToLocalizedString( GAMESTATE:GetSortOrder() );
		self:settext( s );
		self:playcommand("Sort");
	end; --]]
};
t[#t+1] = StandardDecorationFromFileOptional("SortOrder","SortOrderText") .. {
	BeginCommand=cmd(playcommand,"Set");
	SortOrderChangedMessageCommand=cmd(playcommand,"Set";);
	SetCommand=function(self)
		local s = SortOrderToLocalizedString( GAMESTATE:GetSortOrder() );
		self:settext( s );
		self:playcommand("Sort");
	end;
};
--[[
t[#t+1] = StandardDecorationFromFileOptional("SongOptionsFrame","SongOptionsFrame") .. {
	ShowPressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsFrameShowCommand");
	ShowEnteringOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsFrameEnterCommand");
	HidePressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsFrameHideCommand");
};
t[#t+1] = StandardDecorationFromFileOptional("SongOptions","SongOptionsText") .. {
	ShowPressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsShowCommand");
	ShowEnteringOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsEnterCommand");
	HidePressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsHideCommand");
};
--]]

if not GAMESTATE:IsCourseMode() then
-- [ja] Select+▲を押してねメッセージ 
	t[#t+1] = LoadActor(THEME:GetPathG("ScreenSelectMusic","BannerFrame/exfolder")) .. {
	 	EXFolderShowCommand=cmd(linear,0.15;zoomx,1;zoomy,1;);
	 	EXFolderHideCommand=cmd(linear,0.15;zoomx,2;zoomy,0;);
		InitCommand=cmd(zoomx,2;zoomy,0;blend,"BlendMode_Add";visible,true;);
		BeginCommand=function(self)
			if SCREEN_HEIGHT/SCREEN_WIDTH>=0.65 then
				self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-100+30);
			else
				self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-100);
			end;
			self:glowblink();
			self:effectperiod(0.20);
			(cmd(x,SCREEN_CENTER_X+185;draworder,-5;))(self);
			self:playcommand("Set");
		end;
		SetCommand=function(self)
			self:finishtweening();
			if ISChallEXFolder() then
				self:playcommand("EXFolderShow");
			else
				self:playcommand("EXFolderHide");
			end;
		end;
		OffCommand=cmd(playcommand,"EXFolderHide";);
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CodeMessageCommand = function(self, params)
			if params.Name=="ExFolder" and ISChallEXFolder() then
				self:visible(false);
				self:playcommand("Off");
			end;
		end;
	};
end;


if not GAMESTATE:IsCourseMode() then
	-- Score List
	t[#t+1] = Def.ActorFrame {
		LoadActor("scorelist") .. {
			InitCommand=cmd(x,SCREEN_CENTER_X;y,THEME:GetMetric("ScreenSelectMusic","MusicWheelY")+135);
			CodeMessageCommand = function(self, params)
				if params.Name=="ExFolder" and ISChallEXFolder() then
					self:zoomx(1);
					self:linear(0.15);
					self:zoomx(0);
				end;
			end;
		};
	};

	-- GrooveRadar
	t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP1", "GrooveRadarP1" );
	t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP2", "GrooveRadarP2" );

	t[#t+1] = StandardDecorationFromFileOptional("PaneDisplayTextP1","PaneDisplayTextP1");
	t[#t+1] = StandardDecorationFromFileOptional("PaneDisplayTextP2","PaneDisplayTextP2");

	-- [ja]決定後のエフェクト 
	local bgs = GetUserPref_Theme("UserBGScale");
	if not bgs then
		bgs = 'Fit';
	end;
	local haishin=GetUserPref_Theme("UserHaishin");
	if not haishin then
		haishin="Off";
	end;
	t[#t+1] = Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;Center;diffuse,0,0,0,0);
			OffCommand=cmd(sleep,0.2;linear,0.3;diffusealpha,1);
		};
		Def.Sprite{
			InitCommand=cmd(Center;diffusealpha,0);
			OffCommand=function(self)
				local song=_SONG();
				if song then
					local loaded;
					if song:HasBackground() then
						self:LoadBackground(song:GetBackgroundPath());
						loaded=1;
					elseif song:HasJacket() then
						self:LoadBackground(song:GetJacketPath());
						loaded=2;
					elseif song:HasBanner() then
						self:LoadBackground(song:GetBannerPath());
						loaded=3;
					else
						loaded=0;
					end;
					self:zoomtowidth(SCREEN_WIDTH);
					self:zoomtoheight(self:GetHeight()*SCREEN_WIDTH/self:GetWidth());
					self:sleep(0.2);
					self:blend("BlendMode_Add");
					(cmd(x,SCREEN_LEFT;y,SCREEN_TOP+200;cropleft,0.5;cropright,0;croptop,0.5;cropbottom,0;diffusealpha,0.8;linear,0.1;
							diffusealpha,0;x,SCREEN_LEFT;y,SCREEN_TOP+200;cropleft,0.5;croptop,0.5;sleep,0.05;
						x,SCREEN_RIGHT;y,SCREEN_CENTER_Y-50;cropleft,0;cropright,0.5;croptop,0;cropbottom,0.5;diffusealpha,0.8;linear,0.1;
							diffusealpha,0;x,SCREEN_RIGHT;y,SCREEN_CENTER_Y-50;cropright,0.5;croptop,0;cropbottom,0.5;sleep,0.05;
						x,SCREEN_CENTER_X-30;y,SCREEN_BOTTOM-50;cropleft,0.25;cropright,0.25;croptop,0.25;cropbottom,0.25;diffusealpha,0.8;linear,0.1;
							diffusealpha,0))(self);
				end;
			end;
		};
		Def.Sprite{
			InitCommand=cmd(Center;diffusealpha,0);
			OffCommand=function(self)
				local song=_SONG();
				if song then
					if song:HasBackground() then
						self:LoadBackground(song:GetBackgroundPath());
					else
						self:Load(THEME:GetPathG("Common","fallback background"));
					end;
					self:zoomtowidth(SCREEN_WIDTH*2);
					self:zoomtoheight(self:GetHeight()*SCREEN_WIDTH/self:GetWidth()*2);
					self:sleep(0.55);
					(cmd(Center;diffusealpha,0.1;decelerate,0.3;
					diffusealpha,PREFSMAN:GetPreference("BGBrightness")/2;))(self);
					local ratio=GetSMParameter(song,"bgaspectratio");
					if ratio=="" then ratio="1.333333" end;
					if (bgs == 'Cover' and haishin=="Off") or
						(math.abs(PREFSMAN:GetPreference("DisplayAspectRatio")-tonumber(ratio))<= 0.01 and haishin=="Off") then
						self:scaletocover( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
					else
						self:scaletofit( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
					end;
					self:linear(0.1);
					self:diffusealpha(PREFSMAN:GetPreference("BGBrightness"));
				end;
			end;
		};
	};
	LoadActor("hiscore");
	--[ja] 難易度で変わるジャケット 
	--[[
	local scoredetails=0;
	t[#t+1]=Def.ActorFrame{
		Def.Quad{
			MouseInputMessageCommand=function(self)
				scoredetails=1-scoredetails;
				self:playcommand("Set");
			end;
				
			BeginCommand=cmd(playcommand,"Set");
			--CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			--CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
			--InitCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				local song=GAMESTATE:GetCurrentSong();
				self:diffuse(0,0,0,0.8);
				self:zoomto(600,160);
				self:Center();
				if song then
					if scoredetails==1 then
						self:diffusealpha(0.5);
					else
						self:diffusealpha(0);
					end;
				else
					self:diffusealpha(0);
				end;
			end;	
			MouseInputMessageCommand=function(self,param)
				if param.Input == "Left" then
					local song=GAMESTATE:GetCurrentSong();
					self:diffuse(0,0,0,0.5);
					self:zoomto(600,160);
					self:Center();
					self:stoptweening();
					scoredetails=1-scoredetails;
					local mx = InputFilter:GetMouseX();
					local my = InputFilter:GetMouseY();
					if song then
						if scoredetails then
							diffusealpha(0);
							self:linear(0.3);
							diffusealpha(0.5);
						else
							diffusealpha(0.5);
							self:linear(0.3);
							diffusealpha(0);
						end;
					else
						diffusealpha(0.5);
						self:linear(0.3);
						diffusealpha(0);
					end;
				end;
			end;
		};
	};
					--]]

	t[#t+1]=Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(Center;visible,false;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;blend,"BlendMode_Add";diffuse,Color("Blue"););
			CodeMessageCommand = function(self, params)
				if params.Name=="ExFolder" and ISChallEXFolder() then
					self:visible(true);
					(cmd(diffusealpha,0;
						linear,0.25;diffusealpha,1;linear,0.75;diffusealpha,0;))(self);
				end;
			end;
		};
		LoadActor(THEME:GetPathG("_Ready","Background"))..{
			InitCommand=cmd(Center;visible,false);
			CodeMessageCommand = function(self, params)
				if params.Name=="ExFolder" and ISChallEXFolder() then
					self:visible(true);
					(cmd(diffusealpha,0;zoom,3;Center;
						linear,0.25;diffusealpha,1;zoomy,1.5;zoomtowidth,SCREEN_WIDTH;
						sleep,1.0;linear,0.25;zoomy,0;sleep,0.25;diffusealpha,0;))(self);
				end;
			end;
		};
		LoadActor(THEME:GetPathG("ScreenStageInformation","Goodluck"))..{
			InitCommand=cmd(Center;visible,false;blend,"BlendMode_Add");
			CodeMessageCommand = function(self, params)
				if params.Name=="ExFolder" and ISChallEXFolder() then
					self:visible(true);
					(cmd(zoom,2;diffusealpha,0;
						linear,0.25;zoom,1;diffusealpha,1;sleep,1.0;
						linear,0.25;diffusealpha,0))(self);
				end;
			end;
		};
		LoadActor(THEME:GetPathG("ScreenStageInformation","Goodluck"))..{
			InitCommand=cmd(Center;visible,false;blend,"BlendMode_Add");
			CodeMessageCommand = function(self, params)
				if params.Name=="ExFolder" and ISChallEXFolder() then
					self:visible(true);
					(cmd(zoom,1;diffusealpha,0;
						sleep,0.25;zoom,1;diffusealpha,1;
						linear,0.25;zoom,1.3;diffusealpha,0))(self);
				end;
			end;
		};
	};

	-- [ja] システム的なもの 
	t[#t+1]=Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(Center;visible,false);
			CodeMessageCommand = function(self, params)
				if params.Name=="ExFolder" and ISChallEXFolder() then
					SCREENMAN:GetTopScreen():lockinput(1.55);
					SetUserPref_Theme("ExGroupName",""..GetActiveGroupName())
					self:sleep(1.5);
					self:queuecommand("ExScreen");
				end;
			end;
			ExScreenCommand=function(self)
				SCREENMAN:SetNewScreen("ScreenSelectExMusic");
			end;
		};
	};
end;

if GAMESTATE:IsCourseMode() then
	t[#t+1]=LoadActor("course");
end;

-- Sounds
t[#t+1] = Def.ActorFrame {
	LoadActor(THEME:GetPathS("_switch","up")) .. {
		SelectMenuOpenedMessageCommand=cmd(stop;play);
	};
	LoadActor(THEME:GetPathS("_switch","down")) .. {
		SelectMenuClosedMessageCommand=cmd(stop;play);
	};
	LoadActor(THEME:GetPathS("Common","Start")) .. {
		CodeMessageCommand = function(self, params)
			if params.Name=="ExFolder" and ISChallEXFolder() then
				self:stop();
				self:play();
			end;
		end;
	};
};

return t