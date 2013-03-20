local t = Def.ActorFrame {};
local function UpdateTime(self)
	local c = self:GetChildren();
	for pn in ivalues(PlayerNumber) do
		local vStats = STATSMAN:GetCurStageStats():GetPlayerStageStats( pn );
		local vTime;
		local obj = self:GetChild( string.format("RemainingTime" .. PlayerNumberToString(pn) ) );
		if vStats and obj then
			vTime = vStats:GetLifeRemainingSeconds()
			obj:settext( SecondsToMMSSMsMs( vTime ) );
		end;
	end;
end
if GAMESTATE:GetCurrentCourse() then
	if GAMESTATE:GetCurrentCourse():GetCourseType() == "CourseType_Survival" then
		-- RemainingTime
		for pn in ivalues(PlayerNumber) do
			local MetricsName = "RemainingTime" .. PlayerNumberToString(pn);
			t[#t+1] = LoadActor( THEME:GetPathG( Var "LoadingScreen", "RemainingTime"), pn ) .. {
				InitCommand=function(self) 
					self:player(pn); 
					self:name(MetricsName); 
					ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen"); 
				end;
			};
		end
		for pn in ivalues(PlayerNumber) do
			local MetricsName = "DeltaSeconds" .. PlayerNumberToString(pn);
			t[#t+1] = LoadActor( THEME:GetPathG( Var "LoadingScreen", "DeltaSeconds"), pn ) .. {
				InitCommand=function(self) 
					self:player(pn); 
					self:name(MetricsName); 
					ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen"); 
				end;
			};
		end
	end;
end;
t.InitCommand=cmd(SetUpdateFunction,UpdateTime);

local lifeWidth=SCREEN_WIDTH/4;

if not GAMESTATE:IsDemonstration() then
	t[#t+1] = Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(diffuse,0,0,0,0;x,THEME:GetMetric("ScreenGameplay","SongTitleX");
								y,THEME:GetMetric("ScreenGameplay","SongTitleY"););
			OnCommand=cmd(horizalign,right;zoomto,480,0;diffusealpha,0;diffuseleftedge,0,0,0,0;
							sleep,0.5;linear,0.25;zoomto,280,16;diffusealpha,1;diffuseleftedge,0,0,0,0;);
			OffCommand=cmd(linear,0.25;zoomto,960,0;diffusealpha,0;);
		};
		Def.Quad{
			InitCommand=cmd(diffuse,0,0,0,0;x,THEME:GetMetric("ScreenGameplay","SongTitleX");
								y,THEME:GetMetric("ScreenGameplay","SongTitleY"););
			OnCommand=cmd(horizalign,left;zoomto,480,0;diffusealpha,0;diffuserightedge,0,0,0,0;
							sleep,0.5;linear,0.25;zoomto,280,16;diffusealpha,1;diffuserightedge,0,0,0,0;);
			OffCommand=cmd(linear,0.25;zoomto,960,0;diffusealpha,0;);
		};
	};
	t[#t+1] = StandardDecorationFromFileOptional("SongTitle","SongTitle");
end;

if not GAMESTATE:IsCourseMode() then
	t[#t+1] = LoadActor("speedassist");
end;

t[#t+1] = Def.ActorFrame{
	LoadActor("life");
	LoadActor("sidelight");
	LoadFont("Common normal")..{
		InitCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer('PlayerNumber_P1'));
			local song = GAMESTATE:GetCurrentSong();
			if song then
				local st=GAMESTATE:GetCurrentSteps('PlayerNumber_P1');
				local dif=st:GetDifficulty();
				self:diffuse(_DifficultyLightCOLOR(dif));
				self:strokecolor(ColorDarkTone(_DifficultyCOLOR(dif)));
				--text=string.upper(_DifficultyNAME(sdif));
				self:settextf("%s",string.upper(_DifficultyNAME(dif)));
			else
				self:diffuse(CustomDifficultyToLightColor("Difficulty_Edit"));
				self:strokecolor(CustomDifficultyToDarkColor("Difficulty_Edit"));
				self:settext("----");
			end;
			(cmd(horizalign,left;vertalign,bottom;
				x,SCREEN_CENTER_X-lifeWidth-lifeWidth/4-SCREEN_WIDTH/16-50;
				y,SCREEN_BOTTOM-48;zoom,0.55;maxwidth,90;))(self);
		end;
		OnCommand=cmd(diffusealpha,0;addx,100;sleep,0.5;linear,0.25;addx,-100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addx,100;diffusealpha,0);
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
	};
	LoadFont("Common normal")..{
		InitCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer('PlayerNumber_P1'));
			local song = GAMESTATE:GetCurrentSong();
			local course = GAMESTATE:GetCurrentCourse();
			local stt = GAMESTATE:GetCurrentStyle():GetStepsType();
			if song then
				local st=GAMESTATE:GetCurrentSteps('PlayerNumber_P1');
				local dif=st:GetDifficulty();
				self:diffuse(_DifficultyLightCOLOR(dif));
				self:strokecolor(ColorDarkTone(_DifficultyCOLOR(dif)));
				if song:HasStepsTypeAndDifficulty(stt,dif) then
					local metertype=string.lower(GetSMParameter(song,"metertype"));
					local mt=GetUserPref_Theme("UserMeterType");
					self:settextf("%d",GetConvertDifficulty(song,stt,dif,metertype,mt));
				else
					self:settext("--");
				end;
			else
				self:diffuse(CustomDifficultyToLightColor("Difficulty_Edit"));
				self:strokecolor(CustomDifficultyToDarkColor("Difficulty_Edit"));
				self:settext("--");
			end;
			(cmd(horizalign,right;vertalign,top;
				x,SCREEN_CENTER_X-lifeWidth-lifeWidth/4-SCREEN_WIDTH/16+28;
				y,SCREEN_BOTTOM-56;zoom,0.8;maxwidth,90;))(self);
		end;
		OnCommand=cmd(diffusealpha,0;addx,100;sleep,0.5;linear,0.25;addx,-100;diffusealpha,1;);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addx,100;diffusealpha,0);
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
	};

	LoadFont("Common normal")..{
		InitCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer('PlayerNumber_P2'));
			local song = GAMESTATE:GetCurrentSong();
			if song then
				local st=GAMESTATE:GetCurrentSteps('PlayerNumber_P2');
				local dif=st:GetDifficulty();
				self:diffuse(_DifficultyLightCOLOR(dif));
				self:strokecolor(ColorDarkTone(_DifficultyCOLOR(dif)));
				self:settextf("%s",string.upper(_DifficultyNAME(dif)));
			else
				self:diffuse(CustomDifficultyToLightColor("Difficulty_Edit"));
				self:strokecolor(CustomDifficultyToDarkColor("Difficulty_Edit"));
				self:settext("----");
			end;
			(cmd(horizalign,right;vertalign,bottom;
				x,SCREEN_CENTER_X+lifeWidth+lifeWidth/4+SCREEN_WIDTH/16+50;
				y,SCREEN_BOTTOM-48;zoom,0.55;maxwidth,90;))(self);
		end;
		OnCommand=cmd(diffusealpha,0;addx,-100;sleep,0.5;linear,0.25;addx,100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addx,-100;diffusealpha,0);
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
	};
	LoadFont("Common normal")..{
		InitCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer('PlayerNumber_P2'));
			local song = GAMESTATE:GetCurrentSong();
			local stt = GAMESTATE:GetCurrentStyle():GetStepsType();
			if song then
				local st=GAMESTATE:GetCurrentSteps('PlayerNumber_P2');
				local dif=st:GetDifficulty();
				self:diffuse(_DifficultyLightCOLOR(dif));
				self:strokecolor(ColorDarkTone(_DifficultyCOLOR(dif)));
				if song:HasStepsTypeAndDifficulty(stt,dif) then
					local metertype=string.lower(GetSMParameter(song,"metertype"));
					local mt=GetUserPref_Theme("UserMeterType");
					self:settextf("%d",GetConvertDifficulty(song,stt,dif,metertype,mt));
				else
					self:settext("--");
				end;
			else
				self:diffuse(CustomDifficultyToLightColor("Difficulty_Edit"));
				self:strokecolor(CustomDifficultyToDarkColor("Difficulty_Edit"));
				self:settext("--");
			end;
			(cmd(horizalign,left;vertalign,top;
				x,SCREEN_CENTER_X+lifeWidth+lifeWidth/4+SCREEN_WIDTH/16-28;
				y,SCREEN_BOTTOM-56;zoom,0.8;maxwidth,90;))(self);
		end;
		OnCommand=cmd(diffusealpha,0;addx,-100;sleep,0.5;linear,0.25;addx,100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addx,-100;diffusealpha,0);
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
	};
	Def.Quad{
		InitCommand=cmd(diffuse,0,0,0,1;zoomto,SCREEN_WIDTH,20;vertalign,bottom;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM);
		OnCommand=cmd(diffusealpha,0;addy,20;linear,0.25;addy,-20;diffusealpha,1;diffusetopedge,0,0,0,0.5);
	};
	Def.Quad{
	--	InitCommand=cmd(diffuse,0.02,0.16,0.54,0;zoomto,SCREEN_WIDTH,10;vertalign,top;x,SCREEN_CENTER_X;y,SCREEN_TOP);
		InitCommand=cmd(diffuse,0,0,0,0;zoomto,SCREEN_WIDTH,10;vertalign,top;x,SCREEN_CENTER_X;y,SCREEN_TOP);
		OnCommand=cmd(diffusealpha,0;addy,-20;linear,0.25;addy,20;diffusealpha,1);
	};
};
if GAMESTATE:IsDemonstration() then
	local title={};
	if _SONG():GetDisplaySubTitle()~="" then
		title={_SONG():GetDisplayMainTitle(),_SONG():GetDisplaySubTitle()};
	elseif SplitTitle(_SONG():GetDisplayMainTitle())[2]~="" then
		title=SplitTitle(_SONG():GetDisplayMainTitle());
	else
		title={_SONG():GetDisplayMainTitle()};
	end;
	t[#t+1]=Def.ActorFrame{
		InitCommand=cmd(zoomx,2;zoomy,0;x,SCREEN_LEFT+20;y,(not IsReverse(PLAYER_1)) and SCREEN_BOTTOM-120 or SCREEN_TOP+120);
		OnCommand=cmd(sleep,1;linear,0.3;zoomx,1;zoomy,1;);
		OffCommand=cmd(linear,0.3;zoomx,2;zoomy,0;);
		Def.Quad{
			InitCommand=cmd(diffuse,0,0,0,0.5;zoomto,SCREEN_WIDTH/2-40,100;horizalign,left;)
		};
		LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame under"))..{
			InitCommand=function(self)
				self:scaletofit( 0,0,88,88 );
				self:horizalign(left);
				self:x(6);
				self:y(0);
			end;
		};
		Def.Banner{
			InitCommand=function(self)
				local wmode=GetUserPref_Theme("UserWheelMode");
				local song=_SONG();
				local bn="";
				if wmode == 'Jacket->Banner' then
					bn=GetSongGPath_JBN(song);
				elseif wmode == 'Jacket->BG' then
					bn=GetSongGPath_JBG(song);
				elseif wmode == 'Banner->Jacket' then
					bn=GetSongGPath_BNJ(song);
				elseif wmode == 'Text' then
					bn=GetSongGPath_JBN(song);
				else
					bn=GetSongGPath_JBN(song);
				end;
				if FILEMAN:DoesFileExist(bn) then
					self:LoadBackground(bn);
				else
					self:Load(THEME:GetPathG("_MusicWheel","NotFound"));
				end;
				self:scaletofit( 0,0,80,80 );
				self:horizalign(left);
				self:x(10);
				self:y(0);
				if bn==_SONG():GetBannerPath() then
					self:rate(0.5);
				else
					self:rate(1.0);
				end;
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:x(100);
				self:y((#title==1) and -25 or -30);
				self:zoom(0.75);
				self:maxwidth((SCREEN_WIDTH/2-150)/0.75)
				self:diffuse(Color("Blue"));
				self:strokecolor(Color("Outline"));
				self:settext(_SONG():GetGroupName());
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:x(100);
				self:y((#title==1) and 23 or 30);
				self:zoom(0.75);
				self:maxwidth((SCREEN_WIDTH/2-150)/0.75)
				self:diffuse(Color("White"));
				self:strokecolor(Color("Outline"));
				self:settext("/ ".._SONG():GetDisplayArtist());
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:visible((#title==1) and false or true)
				self:x(100);
				self:y(13);
				self:zoom(0.75);
				self:maxwidth((SCREEN_WIDTH/2-150)/0.75)
				self:diffuse(Color("White"));
				self:strokecolor(Color("Outline"));
				self:settext(title[2]);
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:x(100);
				self:y((#title==1) and 2 or -8);
				self:maxwidth((SCREEN_WIDTH/2-150))
				self:diffuse(Color("White"));
				self:strokecolor(Color("Outline"));
				self:settext(title[1]);
			end;
		};
	};
end;

return t;
