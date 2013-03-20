function GetSongBanner(song)
	if song then
		local path = song:GetBannerPath()
		if path then return path end
	end
	return THEME:GetPathG("Common","fallback banner")
end

--[ja] ファイルから読み取る情報。何度も呼ぶと重いのでローカル変数で作っておく 
local col="";
local col_t={};
local mettype="";
local fsubtitle=0;
local ssubtitle="";
local stitle="";
local wheelmode="";
if GetUserPref_Theme("UserWheelMode") == 'Jacket->Banner' then
	wheelmode = "JBN"
elseif GetUserPref_Theme("UserWheelMode") == 'Jacket->BG' then
	wheelmode = "JBG"
elseif GetUserPref_Theme("UserWheelMode") == 'Banner->Jacket' then
	wheelmode = "BNJ"
else
	wheelmode = "JBN"
end;
local wheeltext="";
if GetUserPref_Theme("UserWheelText") == 'Default' then
	wheeltext = "default"
elseif GetUserPref_Theme("UserWheelText") == 'All' then
	wheeltext = "all"
elseif GetUserPref_Theme("UserWheelText") == 'None' then
	wheeltext = "none"
else
	wheeltext = "default"
end;

local t = Def.ActorFrame{
	Def.Quad{
		SetCommand=function(self,params)
			local song = params.Song;
			col="";
			fsubtitle=0;
			ssubtitle="";
			stitle="";
			if params.HasFocus then
				if song then
					local io_st=song:GetAllSteps();
					if #io_st>=1 then
						local io_t;
						io_t=io_st[1]:GetFilename();
						if FILEMAN:DoesFileExist(io_t) then
							--[ja] 形式ではじく 
							local io_lt=string.lower(io_t);
							if string.find(io_lt,".*%.sm") or string.find(io_lt,".*%.ssc") then
								local io_f=RageFileUtil.CreateRageFile();
								io_f:Open(io_t,1);
								col=GetSMParameter_f(io_f,"menucolor");
								if col=="" then
									col=GetExtendedParameter(song,"menucolor");
								end;
								mettype=string.lower(GetSMParameter_f(io_f,"METERTYPE"));
								if mettype=="" then
									mettype=GetExtendedParameter(song,"METERTYPE");
								end;
								io_f:Close();
								io_f:destroy();
							end;
							if col=="" then
								local c={1,1,1,1};
								if IsBossColor(song,mettype) then
									c=Color("Red");
								else
									--c=Color("White");
									c=SONGMAN:GetSongGroupColor(song:GetGroupName());
								end;
								col=""..c[1]..","..c[2]..","..c[3]..","..c[4];
							end;
						end;
					end;
				end;
			else
				col="";
				mettype="ddr";
			end;
			col_t=Str2Color(col);
			self:visible(0);
			if song:GetDisplaySubTitle()~="" then
				fsubtitle=1;
				stitle=song:GetDisplayMainTitle();
				ssubtitle=song:GetDisplaySubTitle();
			else
				local spl_title=SplitTitle(song:GetDisplayMainTitle());
				stitle=spl_title[1];
				ssubtitle=spl_title[2];
				if ssubtitle=="" then fsubtitle=0 else fsubtitle=1 end;
			end;
		end;
	};
--	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame under"))..{
	Def.Sprite {
		InitCommand=cmd(x,0);
		SetMessageCommand=function(self,params)
			local song = params.Song;
			local course = params.Course;
			if song and not course then
				self:Load( THEME:GetPathG("_MusicWheel","BannerFrame under") );
			elseif course and not song then
				self:Load( THEME:GetPathG("_MusicWheel","BannerFrame folder mode") );
			else
				self:Load( THEME:GetPathG("_MusicWheel","BannerFrame folder close") );
			end;
		end;
	};
	Def.Banner {
		Name="SongBanner";
		--InitCommand=cmd(scaletoclipped,128,40;);
		--[ja] ジャケット表示
		InitCommand=cmd(x,-96;y,-96;);
		BeginCommand=cmd(playcommand,"Set");
		SetMessageCommand=function(self,params)
			local song = params.Song;
			local course = params.Course;
			if song and not course then
				-- this is where we do all song-specific stuff
				local g;
				if wheelmode=="JBN" then
					g=GetSongGPath_JBN(params.Song);
				elseif wheelmode=="JBG" then
					g=GetSongGPath_JBG(params.Song);
				elseif wheelmode=="BNJ" then
					g=GetSongGPath_BNJ(params.Song);
				else
					g=GetSongGPath_JBN(params.Song);
				end;
				if params.HasFocus then
					self:visible(true);
					self:Load(g);
					self:stoptweening();
					self:rate(0.5);
					self:position(0);
				else
					if g==params.Song:GetBannerPath() then
						self:LoadFromCachedBanner(g);
					else
						self:Load(g);
					end;
					self:rate(1.0);
				end;
			elseif course and not song then
				-- this is where we do all course-specific stuff
				self:LoadFromCourse(params.Course);
			else
				-- call fallback
				self:Load( THEME:GetPathG("Common fallback","banner") );
			end;
			self:stoptweening();
			self:scaletofit(0,0,188,188);
			self:x(0);
			self:y(0);
		end;
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame color")).. {
		--InitCommand=cmd(x,-2;);
		InitCommand=cmd(playcommand,"Set");
		SetMessageCommand=function(self,params)
			--self:Load( THEME:GetPathG("_MusicWheel","BannerFrame color"));
			if col~="" then
				self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
			else
				if params.HasFocus then
					self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
				else
					self:diffuse(Color("White"));
				end;
			end;
		end;
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame over"));
	Def.Quad{
		InitCommand=cmd(diffuse,0,0,0,1;zoomto,192,50;y,96-25);
		SetMessageCommand=function(self,params)
			if (params.HasFocus and wheeltext~="none") or wheeltext=="all" then
				self:diffusealpha(1.0);
				self:diffuseleftedge(0,0,0,0.25);
			else
				self:diffusealpha(0);
			end;
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;maxwidth,230);
		SetMessageCommand=function(self,params)
			if GAMESTATE:IsCourseMode() then
				self:settextf("%s",params.Song:GetDisplayFullTitle());
			else
				self:settextf("%s",stitle);
			end;
			if fsubtitle==0 then
				self:y(90-23);
			else
				self:y(83-23);
			end;
			--if GetSMParameter(params.Song,"metertype") == "DDR X" and then
			if col~="" then
				self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
			else
				if params.HasFocus then
					self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
				else
					self:diffuse(Color("White"));
				end;
			end;
			self:strokecolor(Color("Outline"));
			if (params.HasFocus and wheeltext~="none") or wheeltext=="all" then
				self:zoom(0.8);
				self:x(92);
			else
				self:zoom(0);
			end;
			self:shadowlength(1);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;maxwidth,360);
		SetMessageCommand=function(self,params)
			self:settextf("%s\n ",ssubtitle);
			if fsubtitle==0 then
				self:y(98-23);
			else
				self:y(103-23);
			end;
			if col~="" then
				self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
			else
				if params.HasFocus then
					self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
				else
					self:diffuse(Color("White"));
				end;
			end;
			self:strokecolor(Color("Outline"));
			if (params.HasFocus and wheeltext~="none") or wheeltext=="all" then
				self:zoom(0.5);
				self:x(91);
			else
				self:zoom(0);
			end;
			self:shadowlength(1);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;maxwidth,360);
		SetMessageCommand=function(self,params)
			self:settextf("\n%s",params.Song:GetDisplayArtist());
			if fsubtitle==0 then
				self:y(100-23);
			else
				self:y(105-23);
			end;
			self:diffuse(Color("White"));
			self:strokecolor(Color("Outline"));
			if (params.HasFocus and wheeltext~="none") or wheeltext=="all" then
				self:zoom(0.5);
				self:x(91);
			else
				self:zoom(0);
			end;
			self:shadowlength(1);
		end;
	};
	--[[
	Def.Banner {
		--InitCommand=cmd(scaletoclipped,128,40;);
		--[ja] ジャケット表示
		InitCommand=cmd(diffusealpha,0.8;);
		SetCommand=function(self,params)
			local st=GAMESTATE:GetCurrentStyle():GetStepsType();
			local song = GAMESTATE:GetPreferredSong();
			local p=PLAYER_1;
			self:Load(THEME:GetPathG("_fullcombo","mark"));
			local diff=GAMESTATE:GetCurrentSteps(p):GetDifficulty();
			if song:HasStepsTypeAndDifficulty(st,diff) then
			--if 1==1 then
				local steps = song:GetOneSteps( st, diff );
				local profile;
				--self:diffuse(CustomDifficultyToLightColor(diff));
				if PROFILEMAN:IsPersistentProfile(p) then
					-- player profile
					profile = PROFILEMAN:GetProfile(p);
				else
					-- machine profile
					profile = PROFILEMAN:GetMachineProfile();
				end;
				local scorelist = profile:GetHighScoreList(song,steps);
				local scores = scorelist:GetHighScores();
				local topscore;
				if scores[1] then
					topscore = scores[1];
					local misses = topscore:GetTapNoteScore("TapNoteScore_Miss")+topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
					local boos = topscore:GetTapNoteScore("TapNoteScore_W5")
					local goods = topscore:GetTapNoteScore("TapNoteScore_W4")
					local greats = topscore:GetTapNoteScore("TapNoteScore_W3")
					local perfects = topscore:GetTapNoteScore("TapNoteScore_W2")
					if (misses+boos+goods) == 0 then
						if (greats+perfects) == 0 then
							self:diffuse(GameColor.Judgment["JudgmentLine_W1"]);
						elseif greats == 0 then
							self:diffuse(GameColor.Judgment["JudgmentLine_W2"]);
						else
							self:diffuse(GameColor.Judgment["JudgmentLine_W3"]);
						end;
						self:diffusealpha(0.8);
					else 
						self:diffusealpha(0);
					end;
				else
					self:diffusealpha(0);
				end;
			else
				self:diffusealpha(0);
			end;
			self:x(60);
			self:y(-50);
			--self:z(params.DrawIndex);

		end;
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set")
		--CurrentTrailP1ChangedMessageCommand=cmd(queuecommand,"Set")
	};
	--]]
};

return t;