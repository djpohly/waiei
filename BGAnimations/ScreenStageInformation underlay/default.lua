local playMode = GAMESTATE:GetPlayMode()
if playMode ~= 'PlayMode_Regular' and playMode ~= 'PlayMode_Rave' and playMode ~= 'PlayMode_Battle' then
	curStage = playMode;
end;
local sStage = GAMESTATE:GetCurrentStage();
local tRemap = {
	Stage_1st		= 1,
	Stage_2nd		= 2,
	Stage_3rd		= 3,
	Stage_4th		= 4,
	Stage_5th		= 5,
	Stage_6th		= 6,
};

if tRemap[sStage] == PREFSMAN:GetPreference("SongsPerPlay") then
	sStage = "Stage_Final";
elseif GAMESTATE:IsCourseMode() then
	local course=GAMESTATE:GetCurrentCourse();
	if course:IsNonstop() then
		sStage = "Stage_Nonstop";
	elseif course:IsOni() then
		sStage = "Stage_Oni";
	elseif course:IsEndless() then
		sStage = "Stage_Endless";
	else
		sStage = sStage;
	end;
else
	sStage = sStage;
end;

local tcol=GetUserPref_Theme("UserColorPath");
local haishin=GetUserPref_Theme("UserHaishin");
local basezoom=0.42;
local t = Def.ActorFrame {FOV=60;};
t[#t+1] = Def.Quad {
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,Color("Black"));
};
if GAMESTATE:IsCourseMode() then
	t[#t+1] = LoadActor("CourseDisplay",tcol,haishin,basezoom);
else
	t[#t+1] = Def.Sprite {
		InitCommand=cmd(Center);
		BeginCommand=cmd(LoadFromCurrentSongBackground);
		OnCommand=function(self)
			self:diffusealpha(PREFSMAN:GetPreference("BGBrightness"));
			if haishin=="On" then
				local bgs = GetUserPref_Theme("UserBGScale");
				if not bgs then
					bgs = 'Fit';
				end;
				local bgr;
				if GetSMParameter(_SONG(),"bgaspectratio")=="" then
					bgr=1.333333;
				else
					bgr=tonumber(GetSMParameter(_SONG(),"bgaspectratio"));
				end;
				self:scaletofit( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
				self:sleep(1.7);
				self:linear(0.3);
				if bgs == 'Cover' or
					math.abs(PREFSMAN:GetPreference("DisplayAspectRatio")-bgr)<= 0.01 then
					self:scaletocover( 0,0,SCREEN_WIDTH*basezoom,SCREEN_HEIGHT*basezoom );
				else
					self:scaletofit( -SCREEN_CENTER_X*basezoom,-SCREEN_CENTER_Y*basezoom,SCREEN_CENTER_X*basezoom,SCREEN_CENTER_Y*basezoom );
				end;
				self:y(SCREEN_CENTER_Y);
				if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
					self:x(SCREEN_CENTER_X+SCREEN_WIDTH*basezoom/2-20*basezoom);
					self:rotationy(45);
				else
					self:x(SCREEN_CENTER_X-SCREEN_WIDTH*basezoom/2+20*basezoom);
					self:rotationy(-45);
				end;
			else
				self:scale_or_crop_background();
			end;
		end;
	};
	t[#t+1] = LoadActor(THEME:GetPathG("_Haishin","Mask")).. {
		InitCommand=cmd(Center;visible,(haishin=="On") and true or false;);
		OnCommand=function(self)
			local zx=basezoom*(0.75/(SCREEN_HEIGHT/SCREEN_WIDTH));
			self:sleep(1.7);
			self:linear(0.3);
			if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				self:x(SCREEN_CENTER_X+SCREEN_WIDTH*basezoom/2-20*basezoom);
				self:rotationy(45);
			else
				self:x(SCREEN_CENTER_X-SCREEN_WIDTH*basezoom/2+20*basezoom);
				self:rotationy(-45);
			end;
			self:zoomx(zx);
			self:zoomy(basezoom);
			self:MaskSource();
		end;
	};
	t[#t+1] = Def.Quad{
		InitCommand=cmd(Center;visible,(haishin=="On") and true or false;diffuse,Color("Black");zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;MaskDest;)
	};
	t[#t+1] = LoadActor(THEME:GetPathG(tcol.."_Haishin","Display")).. {
		InitCommand=cmd(Center;visible,(haishin=="On") and true or false;);
		OnCommand=function(self)
			local zx=basezoom*(0.75/(SCREEN_HEIGHT/SCREEN_WIDTH));
			self:diffusealpha(0);
			self:sleep(1.7);
			self:linear(0.3);
			self:diffusealpha(1);
			if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				self:x(SCREEN_CENTER_X+SCREEN_WIDTH*basezoom/2-20*basezoom);
				self:rotationy(45);
			else
				self:x(SCREEN_CENTER_X-SCREEN_WIDTH*basezoom/2+20*basezoom);
				self:rotationy(-45);
			end;
			self:zoomx(zx);
			self:zoomy(basezoom);
		end;
	};
end

t[#t+1] = LoadActor("songinfo");

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-15);
	
	LoadActor( THEME:GetPathG("ScreenStageInformation", "Stage " .. ToEnumShortString(sStage) ) ) .. {
		OnCommand=cmd(zoom,0.8;diffusealpha,0;addx,-60;linear,0.25;diffusealpha,1;addx,60;sleep,1.5;linear,0.25;addx,60;diffusealpha,0);
	};
};

t[#t+1] = Def.ActorFrame {
  InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+10);
  --[[
	LoadFont("Common Normal") .. {
		Text=GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse():GetDisplayFullTitle() or GAMESTATE:GetCurrentSong():GetDisplayFullTitle();
		InitCommand=cmd(strokecolor,Color("Outline");y,-20);
		OnCommand=cmd(diffusealpha,0;linear,0.5;diffusealpha,1;sleep,1.5;linear,0.5;diffusealpha,0);
	};
	LoadFont("Common Normal") .. {
		Text=GAMESTATE:IsCourseMode() and ToEnumShortString( GAMESTATE:GetCurrentCourse():GetCourseType() ) or GAMESTATE:GetCurrentSong():GetDisplayArtist();
		InitCommand=cmd(strokecolor,Color("Outline");zoom,0.75);
		OnCommand=cmd(diffusealpha,0;linear,0.5;diffusealpha,1;sleep,1.5;linear,0.5;diffusealpha,0);
	};
	--]]
	LoadFont("Common Normal") .. {
		InitCommand=cmd(strokecolor,Color("Outline");diffuse,Color("White");diffusebottomedge,Color("Blue");zoom,0.75;y,20);
		BeginCommand=function(self)
			local text = "";
			local SongOrCourse;
			if GAMESTATE:IsCourseMode() then
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				SongOrCourse = GAMESTATE:GetCurrentCourse();
				if SongOrCourse:GetEstimatedNumStages() == 1 then
					text = SongOrCourse:GetEstimatedNumStages() .." Stage / ".. SecondsToMSSMsMs( TrailUtil.GetTotalSeconds(trail) );
				else
					text = SongOrCourse:GetEstimatedNumStages() .." Stages / ".. SecondsToMSSMsMs( TrailUtil.GetTotalSeconds(trail) );
				end
			else
				SongOrCourse = GAMESTATE:GetCurrentSong();
				text = SecondsToMSSMsMs( SongOrCourse:MusicLengthSeconds() );
			end;
			self:settext(text);
		end;
		OnCommand=cmd(diffusealpha,0;addx,-60;linear,0.25;diffusealpha,1;addx,60;sleep,1.5;linear,0.25;addx,60;diffusealpha,0);
	};
};

return t