local t = LoadFallbackB();

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

t[#t+1] = StandardDecorationFromFileOptional("BannerFrame","BannerFrame");
t[#t+1] = StandardDecorationFromFileOptional("DifficultyList","DifficultyList");
t[#t+1] = StandardDecorationFromFileOptional("CourseContentsList","CourseContentsList");
t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay")..{
	NetSetCommand=function(self)
		local st=GAMESTATE:GetCurrentStyle():GetStepsType();
		local f=0;
		local song=_SONG();
		if song then
			self:horizalign(left);
			for i=1,6 do
				if song:HasStepsTypeAndDifficulty(st,Difficulty[i]) then
					if song:IsStepsUsingDifferentTiming(song:GetOneSteps(st,Difficulty[i])) then
						f=10;
						break;
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
	CurrentSongChangedMessageCommand=cmd(playcommand,"NetSet");
};
t[#t+1] = StandardDecorationFromFileOptional("BPMLabel","BPMLabel")..{
	SetCommand=function(self)
		local st=GAMESTATE:GetCurrentStyle():GetStepsType();
		local f=0;
		local song=_SONG();
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
t[#t+1] = StandardDecorationFromFileOptional("SegmentDisplay","ShowStepsDisplayP1");
t[#t+1] = StandardDecorationFromFileOptional("SegmentDisplay","ShowStepsDisplayP2");
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
	-- 	ShowCommand=THEME:GetMetric(Var "LoadingScreen", "NewSongShowCommand" );
	-- 	HideCommand=THEME:GetMetric(Var "LoadingScreen", "NewSongHideCommand" );
		InitCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
	-- 		local pTargetProfile;
			local sSong;
			-- Start!
			if GAMESTATE:GetCurrentSong() then
				if PROFILEMAN:IsSongNew(GAMESTATE:GetCurrentSong()) then
					self:playcommand("Show");
				else
					self:playcommand("Hide");
				end
			else
				self:playcommand("Hide");
			end
		end;
	};
	t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");
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
-- Score List
t[#t+1] = Def.ActorFrame {
	LoadActor("../ScreenSelectMusic decorations/scorelist") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,THEME:GetMetric("ScreenSelectMusic","MusicWheelY")+135);
	};
};

-- GrooveRadar
t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP1", "GrooveRadarP1" )..{
	SetCommand=function(self)
		if GAMESTATE:IsPlayerEnabled('PlayerNumber_P1') then
			GAMESTATE:SetPreferredDifficulty('PlayerNumber_P1',
				GAMESTATE:GetCurrentSteps('PlayerNumber_P1'):GetDifficulty());
		end;
	end;
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
	};
t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP2", "GrooveRadarP2" )..{
	SetCommand=function(self)
		if GAMESTATE:IsPlayerEnabled('PlayerNumber_P2') then
			GAMESTATE:SetPreferredDifficulty('PlayerNumber_P2',
				GAMESTATE:GetCurrentSteps('PlayerNumber_P2'):GetDifficulty());
		end;
	end;
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	};

t[#t+1] = StandardDecorationFromFileOptional("PaneDisplayTextP1","PaneDisplayTextP1");
t[#t+1] = StandardDecorationFromFileOptional("PaneDisplayTextP2","PaneDisplayTextP2");

-- [ja]決定後のエフェクト 
t[#t+1] = 
Def.ActorFrame{
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
				local bgs;
				if GetUserPref_waiei("UserBGScale") ~= nil then
					bgs = GetUserPref_waiei("UserBGScale");
				else
					bgs = 'Fit';
				end;
				if bgs == 'Fit' then
					self:scaletofit( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
				else
					self:scaletocover( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
				end;
				self:linear(0.1);
				self:diffusealpha(PREFSMAN:GetPreference("BGBrightness"));
			end;
		end;
	};
};

return t;