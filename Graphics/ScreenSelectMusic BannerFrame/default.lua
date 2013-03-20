local t;
t=Def.ActorFrame{
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame under"))..{
		InitCommand=cmd(x,200-2;y,52);
		SetMessageCommand=function(self)
			self:stoptweening();
			if SCREEN_HEIGHT/SCREEN_WIDTH>0.7 then
				self:y(22);
			else
				self:y(52);
			end;
			self:diffusealpha(1);
			self:sleep(0.2);
			self:linear(0.2);
			self:diffusealpha(0);
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	};
	LoadActor("frame");
	Def.Sprite{
		SetCommand=function(self)
			self:stoptweening();
			local SongOrCourse;
			if _COURSE() then
				SongOrCourse=_COURSE();
			elseif _SONG() then
				SongOrCourse=_SONG()
			end;
			if SongOrCourse then
				self:diffusealpha(1);
				if not GAMESTATE:IsCourseMode() then
					if SongOrCourse:HasBanner() then
						self:LoadBackground(GetSongOrCourseBannerPath(SongOrCourse));
					else
						self:Load(THEME:GetPathG("Common fallback","banner"));
					end;
				else
					--self:LoadBackground(GetCourseBPath(SongOrCourse));
					-- [ja] 自動生成するコースの画像が取れないので表示させない 
					self:diffusealpha(0);
					self:Load(THEME:GetPathG("Common fallback","banner"));
				end;
			else
				self:diffusealpha(0);
				self:Load(THEME:GetPathG("Common fallback","banner"));
			end;
			self:scaletofit(0,0,192*1.03,60*1.03);
			self:x(4);
			self:y(0);
			self:linear(0.2);
			self:scaletofit(0,0,192,60);
			self:x(4);
			self:y(0);
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	};
	Def.Quad{
		InitCommand=cmd(x,4;zoomto,192,60;diffuse,0,0,0,0.8;diffusebottomedge,0,0,0,0.5;);
	};
	LoadActor(THEME:GetPathG("ScreenSelectMusic","BannerFrame/split"))..{
		BeginCommand=cmd(visible,false;setanimate,false;);
		InitCommand=cmd(visible,false;setanimate,false;);
		OnCommand=cmd(playcommand,"Set");
		SetMessageCommand=function(self)
			if _SONG() then
				self:stoptweening();
				self:x(-36);
			--	self:blend("BlendMode_Add");
			--	if SCREEN_HEIGHT/SCREEN_WIDTH<=0.7 then
			--		self:y(-18);
			--	else
					self:y(12);
			--	end;
				local st=GAMESTATE:GetCurrentStyle():GetStepsType();
				local f=false;
				local song=_SONG();
				for i=1,6 do
					if song:HasStepsTypeAndDifficulty(st,Difficulty[i]) then
						if song:IsStepsUsingDifferentTiming(song:GetOneSteps(st,Difficulty[i])) then
							f=true;
							break;
						end;
					end;
				end;
				if f then
					self:visible(true);
				else
					self:visible(false);
				end;
			else
				self:visible(false);
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	};
	LoadActor(THEME:GetPathG("ScreenSelectMusic","BannerFrame/long_marathon"))..{
		BeginCommand=cmd(visible,false;setanimate,false;);
		InitCommand=cmd(visible,false;setanimate,false;);
		OnCommand=cmd(playcommand,"Set");
		SetMessageCommand=function(self)
			local song=_SONG();
			if song then
				self:stoptweening();
				self:x(63);
				self:animate(false);
			--	self:blend("BlendMode_Add");
			--	if SCREEN_HEIGHT/SCREEN_WIDTH<=0.7 then
			--		self:y(-18);
			--	else
					self:y(12);
			--	end;
				if song:IsLong() then
					self:setstate(0);
					self:visible(true);
				elseif song:IsMarathon() then
					self:setstate(1);
					self:visible(true);
				else
					self:visible(false);
				end;
			else
				self:visible(false);
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	};
	LoadActor("over");
};
return t;