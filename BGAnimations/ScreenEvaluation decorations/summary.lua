local MinCombo_=GetUserPref_Theme("UserMinCombo");
local MinCombo=(MinCombo_=='TapNoteScore_W3') and 3 or ((MinCombo_=='TapNoteScore_W1') and 1 or ((MinCombo_=='TapNoteScore_W2') and 2 or 4));
local wheelmode=GetUserPref_Theme("UserWheelMode");

local st_index=1;
local songs=STATSMAN:GetAccumPlayedStageStats():GetPlayedSongs();
local st_max=#songs
if not songs then
	songs={GAMESTATE:GetCurrentSong()};
	st_max=1;
end;
local function SetIndex(sindex,add)
	sindex=sindex+add;
	if sindex<1 then sindex=st_max; end;
	if sindex>st_max then sindex=1; end;
	return sindex;
end;

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

-- [ja] W1～Missの数を返す(通常用) 
local function GetSongJud(pn,_index,_max)
	local pss=STATSMAN:GetPlayedStageStats(_max-(_index-1)):GetPlayerStageStats(pn);
--		local st=GAMESTATE:GetCurrentSteps(pn);
--		local ngcount = st:GetRadarValues(pn):GetValue('RadarCategory_Holds')+st:GetRadarValues(pn):GetValue('RadarCategory_Rolls');
	local okcount = pss:GetHoldNoteScores('HoldNoteScore_Held');
	local mscount = pss:GetTapNoteScores('TapNoteScore_Miss');
	local w5count = pss:GetTapNoteScores('TapNoteScore_W5');
	local w4count = pss:GetTapNoteScores('TapNoteScore_W4');
	local w3count = pss:GetTapNoteScores('TapNoteScore_W3');
	local w2count = pss:GetTapNoteScores('TapNoteScore_W2');
	local w1count = pss:GetTapNoteScores('TapNoteScore_W1');
--		ngcount = ngcount-okcount;
	local eva_jud={w1count,w2count,w3count,w4count,w5count,mscount};
	return eva_jud;
end;

local function ComboGraph( pn )
	local t = Def.ActorFrame {
		Def.ComboGraph {
			InitCommand=cmd(Load,"ComboGraph";);
			BeginCommand=function(self)
				local ss = SCREENMAN:GetTopScreen():GetStageStats();
				self:Set( ss, ss:GetPlayerStageStats(pn) );
				self:player( pn );
			end
		};
	};
	return t;
end

local function PercentScore( pn)
	local t = Def.ActorFrame{
		CodeCommand=function(self, params)
			if params.Name=="PrevSong" then
				self:playcommand("PrevSong");
			elseif params.Name=="NextSong" then
				self:playcommand("NextSong");
			end;
		end;
		LoadActor(THEME:GetPathB("ScreenSelectMusic","decorations/list_bottom"))..{
			InitCommand=function(self)
				(cmd(zoomto,100,20;diffuse,Color("Black");y,-34;rotationx,180))(self);
				if pn=='PlayerNumber_P1' then
					self:horizalign(right);
					self:fadeleft(1.0);
					self:faderight(0.0);
					(cmd(x,-100;linear,0.2;x,71))(self);
				else
					self:horizalign(left);
					self:faderight(1.0);
					self:fadeleft(0.0);
					(cmd(x,244;linear,0.3;x,-71))(self);
				end;
			end;
		};
		LoadFont("Combo Numbers")..{
			InitCommand=cmd(zoom,0.7;y,-2;shadowlength,1;);
			BeginCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				local steps=STATSMAN:GetAccumPlayedStageStats():GetPlayerStageStats(pn):GetPlayedSteps();
				local st = steps[st_index]:GetStepsType();
				local dif=steps[st_index]:GetDifficulty();
				self:diffuse(_DifficultyLightCOLOR(dif));
				self:strokecolor(ColorDarkTone(_DifficultyCOLOR(dif)));

				local pss=STATSMAN:GetPlayedStageStats(st_max-(st_index-1)):GetPlayerStageStats(pn);
				if pss then
					local pct = pss:GetPercentDancePoints();
					if pct == 1 then
						self:settext("100%");
					else
						self:settext(FormatPercentScore(pct));
					end;
				end;
			end;
			NextSongCommand=cmd(playcommand,"Set");
			PrevSongCommand=cmd(playcommand,"Set");
		};
		LoadFont("Common normal")..{
			InitCommand=cmd(zoom,0.8;y,-35;shadowlength,1);
			BeginCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				if pn=='PlayerNumber_P1' then
					(cmd(horizalign,right;x,60;))(self);
				else
					(cmd(horizalign,left;x,-60;))(self);
				end;
				local pss=STATSMAN:GetAccumPlayedStageStats():GetPlayerStageStats(pn);
				local steps=pss:GetPlayedSteps();
				local st = steps[st_index]:GetStepsType();
				local dif=steps[st_index]:GetDifficulty();
				self:diffuse(_DifficultyLightCOLOR(dif));
				self:strokecolor(ColorDarkTone(_DifficultyCOLOR(dif)));
				self:settextf("%s",string.upper(_DifficultyNAME(dif)));
			end;
			NextSongCommand=cmd(playcommand,"Set");
			PrevSongCommand=cmd(playcommand,"Set");
		};
		-- [ja] スコア 
		LoadFont("Common normal")..{
			BeginCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				if pn=='PlayerNumber_P1' then
					(cmd(diffuse,PlayerColor(PLAYER_1);horizalign,left;x,-195;
						diffusetopedge,BoostColor(PlayerColor(PLAYER_1),1.5);
						strokecolor,ColorDarkTone( PlayerColor(PLAYER_1) );
						shadowlength,1;zoom,0.8))(self);
				else
					(cmd(diffuse,PlayerColor(PLAYER_2);horizalign,right;x,195;
						diffusetopedge,BoostColor(PlayerColor(PLAYER_2),1.5);
						strokecolor,ColorDarkTone( PlayerColor(PLAYER_2) );
						shadowlength,1;zoom,0.8))(self);
				end;
				local pss=STATSMAN:GetPlayedStageStats(st_max-(st_index-1)):GetPlayerStageStats(pn);
				local scoreFull=pss:GetScore();
				local scoreTop3=math.floor(scoreFull/1000000);
				local scoreMid3=math.floor((scoreFull%1000000)/1000);
				local scoreBot3=math.floor(scoreFull%1000);
				self:settextf("%03d,%03d,%03d",scoreTop3,scoreMid3,scoreBot3);
			end;
			NextSongCommand=cmd(playcommand,"Set");
			PrevSongCommand=cmd(playcommand,"Set");
		};
	};
	return t;
end;

-- [ja] W1～Missの割合を%で返す 
local function Jud2Per(pn,eva_jud,total)
	if eva_jud[1]+eva_jud[2]+eva_jud[3]+eva_jud[4]+eva_jud[5]+eva_jud[6]>total then
		total=eva_jud[1]+eva_jud[2]+eva_jud[3]+eva_jud[4]+eva_jud[5]+eva_jud[6];
	end;
	local toatl_per=0;
	local eva_per={};
	eva_per[1]=math.round(eva_jud[1]*64/total);
	eva_per[2]=math.round((eva_jud[1]+eva_jud[2])*64/total-eva_per[1]);
	eva_per[3]=math.round((eva_jud[1]+eva_jud[2]+eva_jud[3])*64/total-(eva_per[1]+eva_per[2]));
	eva_per[4]=math.round((eva_jud[1]+eva_jud[2]+eva_jud[3]+eva_jud[4])*64/total-(eva_per[1]+eva_per[2]+eva_per[3]));
	eva_per[5]=math.round((eva_jud[1]+eva_jud[2]+eva_jud[3]+eva_jud[4]+eva_jud[5])*64/total-(eva_per[1]+eva_per[2]+eva_per[3]+eva_per[4]));
	eva_per[6]=64-(eva_per[1]+eva_per[2]+eva_per[3]+eva_per[4]+eva_per[5]);
	-- [ja] カウント1以上、メモリ数0の場合は最低1メモリ表示させる 
	for i=1,#eva_jud do
		if eva_jud[i]>0 and eva_per[i]==0 then
			local max_jud=1;	-- [ja] 一番多い判定取得用変数（判定名） 
			local max_per=0;	-- [ja] 一番多い判定取得用変数（メモリ数） 
			for j=1,#eva_jud do
				if eva_per[j]>max_per then
					max_jud=j;
					max_per=eva_per[j];
				end;
			end;
			eva_per[i]=1;
			eva_per[max_jud]=eva_per[max_jud]-1;
		end;
	end;
	return eva_per;
end;

local t = LoadFallbackB();

t[#t+1]=LoadActor(THEME:GetPathG("information/information","Circle1"))..{
	InitCommand=cmd(fov,60;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;
		zoom,400/SCREEN_HEIGHT;blend,"BlendMode_Add";diffuse,Color("Blue");
		draworder,-25;spin;effectmagnitude,1.7,2.1,1.5;);
};
local song_x={SCREEN_CENTER_X-195,SCREEN_CENTER_X-95,
	SCREEN_CENTER_X+50,SCREEN_CENTER_X+155,SCREEN_CENTER_X+205};
local song_y={SCREEN_CENTER_Y-154,SCREEN_CENTER_Y-60,
	SCREEN_CENTER_Y-108,SCREEN_CENTER_Y-108,SCREEN_CENTER_Y-154};
local song_s={0.0,1.0,0.5,0.5,0.0};
local song_z={0,0,-32,-32,-32};
local song_r={-30,-30,0,0,0};
for i=0,#song_x-1 do
t[#t+1]=Def.ActorFrame{
	FOV=60;
	OnCommand=cmd(playcommand,"Init");
	InitCommand=function(self)
		draw_index=(st_index-1+i);
		while (draw_index<1 or draw_index>st_max) do
			if draw_index<1 then draw_index=draw_index+st_max; end;
			if draw_index>st_max then draw_index=draw_index-st_max; end;
		end;
		(cmd(x,song_x[i+1];y,song_y[i+1];zoom,song_s[i+1];rotationy,song_r[i+1];
			z,song_z[i+1];draworder,-10;))(self);
	end;
	CodeCommand=function(self, params)
		if params.Name=="PrevSong" then
			self:playcommand("PrevSong");
		elseif params.Name=="NextSong" then
			self:playcommand("NextSong");
		end;
	end;
	NextSongCommand=function(self)
		if i==0 then st_index=SetIndex(st_index,1); end;
		draw_index=(st_index-1+i);
		while (draw_index<1 or draw_index>st_max) do
			if draw_index<1 then draw_index=draw_index+st_max; end;
			if draw_index>st_max then draw_index=draw_index-st_max; end;
		end;
		(cmd(stoptweening;x,song_x[math.min(i+2,5)];z,song_z[math.min(i+2,5)];
			y,song_y[math.min(i+2,5)];zoom,song_s[math.min(i+2,5)];rotationy,song_r[math.min(i+2,5)];
			linear,0.1;x,song_x[i+1];y,song_y[i+1];zoom,song_s[i+1];rotationy,song_r[i+1];
			z,song_z[i+1];draworder,-10;))(self);
	end;
	PrevSongCommand=function(self)
		if i==0 then st_index=SetIndex(st_index,-1); end;
		draw_index=(st_index-1+i);
		while (draw_index<1 or draw_index>st_max) do
			if draw_index<1 then draw_index=draw_index+st_max; end;
			if draw_index>st_max then draw_index=draw_index-st_max; end;
		end;
		(cmd(stoptweening;x,song_x[math.max(i,1)];z,song_z[math.max(i,1)];
			y,song_y[math.max(i,1)];zoom,song_s[math.max(i,1)];rotationy,song_r[math.max(i,1)];
			linear,0.1;x,song_x[i+1];y,song_y[i+1];zoom,song_s[i+1];rotationy,song_r[i+1];
			z,song_z[i+1];draworder,-10;))(self);
	end;
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame under"));
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame color"))..{
		SetCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				self:diffuse(Color("Purple"));
			else
				local song=songs[draw_index];
				if song then
					local col=GetSMParameter(song,"menucolor");
					if col=="" then
						local c={1,1,1,1};
						local mettype=GetSMParameter(song,"metertype");
						if IsBossColor(song,mettype) then
							c=Color("Red");
						else
							--c=Color("White");
							c=SONGMAN:GetSongGroupColor(song:GetGroupName());
						end;
						col=""..c[1]..","..c[2]..","..c[3]..","..c[4];
					end;
					self:diffuse(Str2Color(col));
					--self:diffuse(Color("Red"));
				end;
			end;
		end;
		OnCommand=cmd(playcommand,"Set");
		NextSongCommand=cmd(playcommand,"Set");
		PrevSongCommand=cmd(playcommand,"Set");
	};
	Def.Sprite{
		InitCommand=cmd(diffusealpha,1;);
		OnCommand=cmd(playcommand,"Set");
		NextSongCommand=cmd(playcommand,"Set");
		PrevSongCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:stoptweening();
			local song=songs[draw_index];
			local g="";
			if wheelmode == 'Jacket->Banner' then
				g=GetSongGPath_JBN(song);
			elseif wheelmode == 'Jacket->BG' then
				g=GetSongGPath_JBG(song);
			elseif wheelmode == 'Banner->Jacket' then
				g=GetSongGPath_BNJ(song);
			elseif wheelmode == 'Text' then
				g=GetSongGPath_JBN(song);
			else
				g=GetSongGPath_JBN(song);
			end;
			self:LoadBackground(g);
			-- [ja] 動画バナーが倍速再生されるのを防ぐ 
			local rate=0;
			for chk=0,4 do
				if (wheelmode == 'Jacket->Banner' and GetSongGPath_JBN(songs[((st_index+#songs-2)+chk)%#songs+1])==g)
					or (wheelmode == 'Jacket->BG' and GetSongGPath_JBG(songs[((st_index+#songs-2)+chk)%#songs+1])==g) 
					or (wheelmode == 'Banner->Jacket' and GetSongGPath_BNJ(songs[((st_index+#songs-2)+chk)%#songs+1])==g) 
					or (wheelmode == 'Text' and GetSongGPath_JBN(songs[((st_index+#songs-2)+chk)%#songs+1])==g) then
					rate=rate+1;
				end;
			end;
			self:rate(1.0/rate);
			self:scaletofit(0,0,192,192);
			self:x(0);
			self:y(0);
		end;
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame evaluation"))..{
		BeginCommand=function(self)
			(cmd(diffusealpha,0;linear,0.2;diffusealpha,1;))(self);
		end;
	};
};
end;
local st_name={"1st","2nd","3rd","4th","5th","6th","final","extra1","extra2"};
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,SCREEN_CENTER_X+105;y,SCREEN_CENTER_Y-2);
	CodeCommand=function(self, params)
		if params.Name=="PrevSong" then
			self:playcommand("PrevSong");
		elseif params.Name=="NextSong" then
			self:playcommand("NextSong");
		end;
	end;
	Def.Quad{
		InitCommand=cmd(diffuse,Color("Black");zoomto,220,90;
			fadeleft,0.5;faderight,0.5;);
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(diffusealpha,1;);
		OnCommand=cmd(playcommand,"Set");
		NextSongCommand=cmd(playcommand,"Set");
		PrevSongCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:stoptweening();
			self:diffuse(Color("White"));
			self:strokecolor(Color("Outline"));
			local song=songs[st_index];
			self:maxwidth(200);
			self:settextf("%s",song:GetDisplayFullTitle());
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(diffusealpha,1;);
		OnCommand=cmd(playcommand,"Set");
		NextSongCommand=cmd(playcommand,"Set");
		PrevSongCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:stoptweening();
			self:diffuse(Color("White"));
			self:strokecolor(Color("Outline"));
			local song=songs[st_index];
			self:zoom(0.8);
			self:maxwidth(200/0.8);
			self:y(25);
			self:settextf("%s",song:GetDisplayArtist());
		end;
	};
	Def.Sprite{
		InitCommand=cmd(diffusealpha,1;);
		OnCommand=cmd(playcommand,"Set");
		NextSongCommand=cmd(playcommand,"Set");
		PrevSongCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:stoptweening();
			if GAMESTATE:IsExtraStage() then
				if st_index==st_max then
					self:Load(THEME:GetPathG("ScreenStageInformation","summary_stage extra1"));
				elseif st_index==st_max-1 then
					self:Load(THEME:GetPathG("ScreenStageInformation","summary_stage final"));
				else
					self:Load(THEME:GetPathG("ScreenStageInformation","summary_stage "..st_name[st_index]));
				end;
			elseif GAMESTATE:IsExtraStage2() then
				if st_index==st_max then
					self:Load(THEME:GetPathG("ScreenStageInformation","summary_stage extra2"));
				elseif st_index==st_max-1 then
					self:Load(THEME:GetPathG("ScreenStageInformation","summary_stage extra1"));
				elseif st_index==st_max-2 then
					self:Load(THEME:GetPathG("ScreenStageInformation","summary_stage final"));
				else
					self:Load(THEME:GetPathG("ScreenStageInformation","summary_stage "..st_name[st_index]));
				end;
			else
				if st_index==st_max then
					self:Load(THEME:GetPathG("ScreenStageInformation","summary_stage final"));
				else
					self:Load(THEME:GetPathG("ScreenStageInformation","summary_stage "..st_name[st_index]));
				end;
			end;
			self:y(-25);
		end;
	};
};

-- [ja] 難易度 
for pn in ivalues(PlayerNumber) do
	if GAMESTATE:IsPlayerEnabled(pn) then
		t[#t+1]=Def.ActorFrame{
			CodeCommand=function(self, params)
				if params.Name=="PrevSong" then
					self:playcommand("PrevSong");
				elseif params.Name=="NextSong" then
					self:playcommand("NextSong");
				end;
			end;
			InitCommand=cmd(y,400);
			OnCommand=function(self)
				if pn=='PlayerNumber_P1' then
					(cmd(x,-300;linear,0.2;x,-20))(self);
				else
					(cmd(x,SCREEN_RIGHT+300;linear,0.3;x,SCREEN_RIGHT+20))(self);
				end;
			end;
			LoadActor(THEME:GetPathB("ScreenSelectMusic","decorations/list_bottom"))..{
				OffCommand=cmd(linear,0.3;diffusealpha,0);
			};
			LoadActor(THEME:GetPathB("ScreenSelectMusic","decorations/list_dif"))..{
				InitCommand=function(self)
					self:horizalign(right);
					if pn=='PlayerNumber_P1' then
						self:rotationy(180);
					end;
					self:playcommand("Set");
				end;
				SetCommand=function(self)
					local steps=STATSMAN:GetAccumPlayedStageStats():GetPlayerStageStats(pn):GetPlayedSteps();
					local dif=steps[st_index]:GetDifficulty();
					self:diffuse(_DifficultyCOLOR(dif));
				end;
				NextSongCommand=cmd(playcommand,"Set");
				PrevSongCommand=cmd(playcommand,"Set");
				OffCommand=cmd(linear,0.3;diffusealpha,0);
			};
		};
	end;
end;

-- [ja] グレード 
for pn in ivalues(PlayerNumber) do
	if GAMESTATE:IsPlayerEnabled(pn) then
		--
		t[#t+1]=Def.ActorFrame{
			CodeCommand=function(self, params)
				if params.Name=="PrevSong" then
					self:playcommand("PrevSong");
				elseif params.Name=="NextSong" then
					self:playcommand("NextSong");
				end;
			end;
			InitCommand=function(self)
				if SCREEN_HEIGHT/SCREEN_WIDTH<0.61 then
					self:x((pn==PLAYER_1) and 120 or SCREEN_RIGHT-120);
					self:zoom(0.7);
					self:y(290);
				elseif SCREEN_HEIGHT/SCREEN_WIDTH<0.65 then
					self:x((pn==PLAYER_1) and 90 or SCREEN_RIGHT-90);
					self:zoom(0.6);
					self:y(300);
				else
					self:x((pn==PLAYER_1) and 60 or SCREEN_RIGHT-60);
					self:zoom(0.5);
					self:y(310);
				end;
			end;
			LoadActor(THEME:GetPathG("_objects/_circle","glow100px"))..{
				OnCommand=cmd(playcommand,"Set";blend,"BlendMode_Add";zoom,0;spring,0.64;zoom,2.3;);
				SetCommand=function(self)
					self:finishtweening();
					local pss=STATSMAN:GetPlayedStageStats(st_max-(st_index-1)):GetPlayerStageStats(pn);
					if pss:FullComboOfScore('TapNoteScore_W4') then
						if pss:FullComboOfScore('TapNoteScore_W1') then
							self:diffuse(GameColor.Judgment["JudgmentLine_W1"]);
						elseif pss:FullComboOfScore('TapNoteScore_W2') and MinCombo>=2 then
							self:diffuse(GameColor.Judgment["JudgmentLine_W2"]);
						elseif pss:FullComboOfScore('TapNoteScore_W3') and MinCombo>=3 then
							self:diffuse(GameColor.Judgment["JudgmentLine_W3"]);
						elseif pss:FullComboOfScore('TapNoteScore_W4') and MinCombo>=4 then
							self:diffuse(BoostColor(GameColor.Judgment["JudgmentLine_W4"],1.2));
						else
							self:visible(false);
						end;
					else
						self:visible(false);
					end;
				end;
				NextSongCommand=cmd(finishtweening;playcommand,"Set";);
				PrevSongCommand=cmd(finishtweening;playcommand,"Set";);
			};
			LoadActor(THEME:GetPathG("_objects/_circle","100px"))..{
				OnCommand=cmd(diffuse,0,0,0,0.3;zoom,0;spring,0.64;zoom,2.3);
			};
			LoadActor(THEME:GetPathG("_objects/_circle","100px"))..{
				OnCommand=cmd(diffuse,1,1,1,0.5;zoom,0;spring,0.64;zoom,1.5);
			};
		};
		for i=1,64 do
			t[#t+1]=Def.ActorFrame{
				CodeCommand=function(self, params)
					if params.Name=="PrevSong" then
						self:playcommand("PrevSong");
					elseif params.Name=="NextSong" then
						self:playcommand("NextSong");
					end;
				end;
				InitCommand=function(self)
					if SCREEN_HEIGHT/SCREEN_WIDTH<0.61 then
						self:x((pn==PLAYER_1) and 120 or SCREEN_RIGHT-120);
						self:zoom(0.7);
						self:y(290);
					elseif SCREEN_HEIGHT/SCREEN_WIDTH<0.65 then
						self:x((pn==PLAYER_1) and 90 or SCREEN_RIGHT-90);
						self:zoom(0.6);
						self:y(300);
					else
						self:x((pn==PLAYER_1) and 60 or SCREEN_RIGHT-60);
						self:zoom(0.5);
						self:y(310);
					end;
				end;
				LoadActor(THEME:GetPathG("_objects/_circle64","5"))..{
					InitCommand=function(self)
						(cmd(vertalign,bottom;rotationz,5.625*(i-1)))(self);
						local eva_jud=GetSongJud(pn,st_index,st_max);
						local steps=STATSMAN:GetAccumPlayedStageStats():GetPlayerStageStats(pn):GetPlayedSteps();
						local step=steps[st_index];
						local jud_per=Jud2Per(pn,eva_jud,step:GetRadarValues(GetSidePlayer(pn)):GetValue('RadarCategory_TapsAndHolds'));
						w1_per=jud_per[1];
						w2_per=jud_per[2];
						w3_per=jud_per[3];
						w4_per=jud_per[4];
						w5_per=jud_per[5];
						ms_per=jud_per[6];
						if i<=w1_per then
							self:diffuse(GameColor.Judgment["JudgmentLine_W1"]);
						elseif i<=w1_per+w2_per then
							self:diffuse(GameColor.Judgment["JudgmentLine_W2"]);
						elseif i<=w1_per+w2_per+w3_per then
							self:diffuse(GameColor.Judgment["JudgmentLine_W3"]);
						elseif i<=w1_per+w2_per+w3_per+w4_per then
							self:diffuse(GameColor.Judgment["JudgmentLine_W4"]);
						elseif i<=w1_per+w2_per+w3_per+w4_per+w5_per then
							self:diffuse(GameColor.Judgment["JudgmentLine_W5"]);
						else
							self:diffuse(GameColor.Judgment["JudgmentLine_Miss"]);
						end;
					end;
					OnCommand=cmd(zoom,0;sleep,0.005*i;linear,0.2;zoom,1);
					NextSongCommand=cmd(finishtweening;playcommand,"Init";);
					PrevSongCommand=cmd(finishtweening;playcommand,"Init";);
				};
			};
		end;
		t[#t+1]=Def.ActorFrame{
			CodeCommand=function(self, params)
				if params.Name=="PrevSong" then
					self:playcommand("PrevSong");
				elseif params.Name=="NextSong" then
					self:playcommand("NextSong");
				end;
			end;
			Def.Sprite{
				InitCommand=cmd(playcommand,"Set");
				OnCommand=cmd(playcommand,"Set");
				NextSongCommand=cmd(playcommand,"Set");
				PrevSongCommand=cmd(playcommand,"Set");
				SetCommand=function(self)
					self:stoptweening();
					local pss=STATSMAN:GetPlayedStageStats(st_max-(st_index-1)):GetPlayerStageStats(pn);
					local itg=ItgScore(pss);
					local grade=GetGradeFromPercent(itg[1] / itg[2]);
					-- Reserve top tier for perfect performances
					if grade == "Grade_Tier01" and itg[1] < itg[2] then
						grade = "Grade_Tier02"
					end
					self:Load(THEME:GetPathG("GradeDisplayEval",ToEnumShortString(grade)));
					if SCREEN_HEIGHT/SCREEN_WIDTH<0.61 then
						self:x((pn==PLAYER_1) and 120 or SCREEN_RIGHT-120);
						self:zoom(1.0);
						self:y(295);
					elseif SCREEN_HEIGHT/SCREEN_WIDTH<0.65 then
						self:x((pn==PLAYER_1) and 90 or SCREEN_RIGHT-90);
						self:zoom(0.86);
						self:y(304);
					else
						self:x((pn==PLAYER_1) and 60 or SCREEN_RIGHT-60);
						self:zoom(0.72);
						self:y(313);
					end;
				end;
			};
		};
	end;
end;

t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");

for pn in ivalues(PlayerNumber) do
	if GAMESTATE:IsPlayerEnabled(pn) then
		--t[#t+1] = StandardDecorationFromTable( "PercentScore" .. ToEnumShortString(pn), PercentScore(pn) );
		t[#t+1]=Def.ActorFrame{
			CodeCommand=function(self, params)
				if params.Name=="PrevSong" then
					self:playcommand("PrevSong");
				elseif params.Name=="NextSong" then
					self:playcommand("NextSong");
				end;
			end;
			InitCommand=cmd(x,((pn==PLAYER_1) and SCREEN_LEFT+205 or SCREEN_RIGHT-205);y,SCREEN_TOP+402);
			PercentScore(pn);
		};
	end;
end

for pn in ivalues(PlayerNumber) do
	local MetricsName = "MachineRecord" .. PlayerNumberToString(pn);
	t[#t+1] = LoadActor( THEME:GetPathG(Var "LoadingScreen", "MachineRecord"), pn ) .. {
		InitCommand=function(self) 
			self:player(pn); 
			self:name(MetricsName); 
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen"); 
		end;
	};
end

for pn in ivalues(PlayerNumber) do
	local MetricsName = "PersonalRecord" .. PlayerNumberToString(pn);
	t[#t+1] = LoadActor( THEME:GetPathG(Var "LoadingScreen", "PersonalRecord"), pn ) .. {
		InitCommand=function(self) 
			self:player(pn); 
			self:name(MetricsName); 
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen"); 
		end;
	};
end

t[#t+1] = StandardDecorationFromFileOptional("LifeDifficulty","LifeDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("TimingDifficulty","TimingDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("GameType","GameType");

-- [ja] ここからoverlayのアレ local vStats = STATSMAN:GetCurStageStats();

local vStats = STATSMAN:GetCurStageStats();
local function CreateStats( pnPlayer )
	-- Actor Templates
	local aLabel = LoadFont("Common Normal") .. { InitCommand=cmd(zoom,0.5;shadowlength,1;horizalign,left); };
	local aText = LoadFont("Common Normal") .. { InitCommand=cmd(zoom,0.5;shadowlength,1;horizalign,left); };
	-- DA STATS, JIM!!
	local pnStageStats=STATSMAN:GetPlayedStageStats(st_max-(st_index-1)):GetPlayerStageStats(pnPlayer);
	-- Organized Stats.
	local tStats = {
		W1			= pnStageStats:GetTapNoteScores('TapNoteScore_W1');
		W2			= pnStageStats:GetTapNoteScores('TapNoteScore_W2');
		W3			= pnStageStats:GetTapNoteScores('TapNoteScore_W3');
		W4			= pnStageStats:GetTapNoteScores('TapNoteScore_W4');
		W5			= pnStageStats:GetTapNoteScores('TapNoteScore_W5');
		Miss		= pnStageStats:GetTapNoteScores('TapNoteScore_Miss');
		HitMine		= pnStageStats:GetTapNoteScores('TapNoteScore_HitMine');
		AvoidMine	= pnStageStats:GetTapNoteScores('TapNoteScore_AvoidMine');
		Held		= pnStageStats:GetHoldNoteScores('HoldNoteScore_Held');
		LetGo		= pnStageStats:GetHoldNoteScores('HoldNoteScore_LetGo');
		Total		= 1;
		HoldsAndRolls = 0;
		Seconds		= pnStageStats:GetCurrentLife();
	};
	if GAMESTATE:GetCurrentSteps(pnPlayer) then
		tStats["Total"]=yaGetRD(pnPlayer,'RadarCategory_TapsAndHolds')+yaGetRD(pnPlayer,'RadarCategory_Holds')+yaGetRD(pnPlayer,'RadarCategory_Rolls');
	elseif _COURSE() then
		local entry=_COURSE():GetCourseEntries();
		-- [ja] 仮置き 
		tStats["Total"]=(tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"] + tStats["Held"] + tStats["LetGo"]);
	end;
	-- Organized Equation Values
	local tValues = {
		-- marvcount*7 + perfcount*6 + greatcount*5 + goodcount*4 + boocount*2 + okcount*7
		ITG			= ( tStats["W1"]*7 + tStats["W2"]*6 + tStats["W3"]*5 + tStats["W4"]*4 + tStats["W5"]*2 + tStats["Held"]*7 ), 
		-- (marvcount + perfcount + greatcount + goodcount + boocount + misscount + okcount + ngcount)*7
		ITG_MAX		= ( tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"] + tStats["Held"] + tStats["LetGo"] )*7,
		-- marvcount*3 + perfcount*2 + greatcount*1 - boocount*4 - misscount*8 + okcount*6
		MIGS		= ( tStats["W1"]*3 + tStats["W2"]*2 + tStats["W3"] - tStats["W5"]*4 - tStats["Miss"]*8 + tStats["Held"]*6 ),
		-- (marvcount + perfcount + greatcount + goodcount + boocount + misscount)*3 + (okcount + ngcount)*6
		MIGS_MAX	= ( (tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"])*3 + (tStats["Held"] + tStats["LetGo"])*6 ),
		SN2	= (math.round( (tStats["W1"] + tStats["W2"] + tStats["W3"]/2+tStats["Held"])*100000/math.max(tStats["Total"],1)-(tStats["W2"] + tStats["W3"]))*10),
	};

	local t = Def.ActorFrame {};
	t[#t+1] = Def.ActorFrame {
		CodeCommand=function(self, params)
			if params.Name=="PrevSong" then
				self:playcommand("PrevSong");
			elseif params.Name=="NextSong" then
				self:playcommand("NextSong");
			end;
		end;
		InitCommand=cmd(y,5);
		Def.Quad{
			InitCommand=cmd(visible,false;playcommand,"Set";);
			SetCommand=function(self)
				local p=((pnPlayer=='PlayerNumber_P1') and 1 or 2);
				pnStageStats=STATSMAN:GetPlayedStageStats(st_max-(st_index-1)):GetPlayerStageStats(pnPlayer);
				local steps=STATSMAN:GetAccumPlayedStageStats():GetPlayerStageStats(pnPlayer):GetPlayedSteps();
				local st = steps[st_index];
				tStats["W1"]	= pnStageStats:GetTapNoteScores('TapNoteScore_W1');
				tStats["W2"]	= pnStageStats:GetTapNoteScores('TapNoteScore_W2');
				tStats["W3"]	= pnStageStats:GetTapNoteScores('TapNoteScore_W3');
				tStats["W4"]	= pnStageStats:GetTapNoteScores('TapNoteScore_W4');
				tStats["W5"]	= pnStageStats:GetTapNoteScores('TapNoteScore_W5');
				tStats["Miss"]	= pnStageStats:GetTapNoteScores('TapNoteScore_Miss');
				tStats["Held"]	= pnStageStats:GetHoldNoteScores('HoldNoteScore_Held');
				tStats["LetGo"]	= pnStageStats:GetHoldNoteScores('HoldNoteScore_LetGo');
				tStats["HoldsAndRolls"] = pnStageStats:GetHoldNoteScores('HoldNoteScore_Held');
				tStats["Total"]	= st:GetRadarValues(pnPlayer):GetValue('RadarCategory_TapsAndHolds')
								+st:GetRadarValues(pnPlayer):GetValue('RadarCategory_Holds')
								+st:GetRadarValues(pnPlayer):GetValue('RadarCategory_Rolls');
				tValues["ITG"]		= ( tStats["W1"]*7 + tStats["W2"]*6 + tStats["W3"]*5 + tStats["W4"]*4 + tStats["W5"]*2 + tStats["Held"]*7 );
				tValues["ITG_MAX"]	= ( tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"] + tStats["Held"] + tStats["LetGo"] )*7;
				tValues["MIGS"]		= ( tStats["W1"]*3 + tStats["W2"]*2 + tStats["W3"] - tStats["W5"]*4 - tStats["Miss"]*8 + tStats["Held"]*6 );
				tValues["MIGS_MAX"]	= ( (tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"])*3 + (tStats["Held"] + tStats["LetGo"])*6 );
				tValues["SN2"]		= (math.round( (tStats["W1"] + tStats["W2"] + tStats["W3"]/2+tStats["Held"])*100000/math.max(tStats["Total"],1)-(tStats["W2"] + tStats["W3"]))*10);
			end;
			NextSongCommand=cmd(finishtweening;playcommand,"Set";);
			PrevSongCommand=cmd(finishtweening;playcommand,"Set";);
		};
		Def.Quad{
			InitCommand=cmd(zoomto,120,130;diffuse,Color( "Black" ));
			OnCommand=function(self)
				if pnPlayer==PLAYER_1 then
					self:faderight(0.8);
				else
					self:fadeleft(0.8);
				end;
			end;
		};
	};
	t[#t+1] = Def.ActorFrame {
		CodeCommand=function(self, params)
			if params.Name=="PrevSong" then
				self:playcommand("PrevSong");
			elseif params.Name=="NextSong" then
				self:playcommand("NextSong");
			end;
		end;
		InitCommand=cmd(y,-34);
		Def.Quad{
			InitCommand=cmd(zoomto,116,30;diffuse,PlayerColor( pnPlayer ));
			OnCommand=function(self)
				if pnPlayer==PLAYER_1 then
					self:skewx(0.13);
					self:diffuselowerleft(0,0,0,0);
				else
					self:skewx(-0.13);
					self:diffuselowerright(0,0,0,0);
				end;
				self:blend("BlendMode_Add");
			end;
		};
		aLabel .. { Text="ITG DP:"; InitCommand=cmd(x,-52;y,-8;zoomy,0.4) };
		aText .. { InitCommand=cmd(x,-34;y,7;vertalign,bottom;zoom,0.6;settextf,"%04i",tValues["ITG"]);
					NextSongCommand=cmd(playcommand,"Set";);
					PrevSongCommand=cmd(playcommand,"Set";);
					SetCommand=cmd(settextf,"%04i",tValues["ITG"])};
		aText .. { InitCommand=cmd(x,7;y,7;vertalign,bottom;zoom,0.5;diffusealpha,0.5;settext,"/"); };
		aText .. { InitCommand=cmd(x,16;y,7;vertalign,bottom;zoom,0.5;settextf,"%04i",tValues["ITG_MAX"]);
					NextSongCommand=cmd(playcommand,"Set";);
					PrevSongCommand=cmd(playcommand,"Set";);
					SetCommand=cmd(settextf,"%04i",tValues["ITG_MAX"])};
	};
	t[#t+1] = Def.ActorFrame {
		CodeCommand=function(self, params)
			if params.Name=="PrevSong" then
				self:playcommand("PrevSong");
			elseif params.Name=="NextSong" then
				self:playcommand("NextSong");
			end;
		end;
		InitCommand=cmd(y,5);
		Def.Quad{
			InitCommand=cmd(zoomto,116,30;diffuse,PlayerColor( pnPlayer ));
			OnCommand=function(self)
				if pnPlayer==PLAYER_1 then
					self:skewx(0.13);
					self:diffuselowerleft(0,0,0,0);
				else
					self:skewx(-0.13);
					self:diffuselowerright(0,0,0,0);
				end;
				self:blend("BlendMode_Add");
			end;
		};
		aLabel .. { Text="MIGS DP:"; InitCommand=cmd(x,-52;y,-8;zoomy,0.4) };
		aText .. { InitCommand=cmd(x,-34;y,7;vertalign,bottom;zoom,0.6;settextf,"%04i",tValues["MIGS"]);
					NextSongCommand=cmd(playcommand,"Set";);
					PrevSongCommand=cmd(playcommand,"Set";);
					SetCommand=cmd(settextf,"%04i",tValues["MIGS"])};
		aText .. { InitCommand=cmd(x,7;y,7;vertalign,bottom;zoom,0.5;diffusealpha,0.7;settext,"/"); };
		aText .. { InitCommand=cmd(x,16;y,7;vertalign,bottom;zoom,0.5;settextf,"%04i",tValues["MIGS_MAX"]);
					NextSongCommand=cmd(playcommand,"Set";);
					PrevSongCommand=cmd(playcommand,"Set";);
					SetCommand=cmd(settextf,"%04i",tValues["MIGS_MAX"])};
	};
	t[#t+1] = Def.ActorFrame {
		CodeCommand=function(self, params)
			if params.Name=="PrevSong" then
				self:playcommand("PrevSong");
			elseif params.Name=="NextSong" then
				self:playcommand("NextSong");
			end;
		end;
		InitCommand=cmd(y,46);
		Def.Quad{
			InitCommand=cmd(zoomto,116,30;diffuse,PlayerColor( pnPlayer ));
			OnCommand=function(self)
				if pnPlayer==PLAYER_1 then
					self:skewx(0.13);
					self:diffuselowerleft(0,0,0,0);
				else
					self:skewx(-0.13);
					self:diffuselowerright(0,0,0,0);
				end;
				self:blend("BlendMode_Add");
			end;
		};
		aLabel .. { Text="SN2 SCORE:"; InitCommand=cmd(x,-52;y,-8;zoomy,0.4) };
		aText .. { InitCommand=cmd(x,50;y,7;horizalign,right;vertalign,bottom;zoom,0.6;settextf,"%7i",tValues["SN2"]);
					NextSongCommand=cmd(playcommand,"Set";);
					PrevSongCommand=cmd(playcommand,"Set";);
					SetCommand=cmd(settextf,"%7i",tValues["SN2"])};
	};
	return t
end;

GAMESTATE:IsPlayerEnabled(PLAYER_1)
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(hide_if,not GAMESTATE:IsPlayerEnabled(PLAYER_1);x,SCREEN_LEFT+55;y,SCREEN_TOP+120);
	CreateStats( PLAYER_1 );
};
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(hide_if,not GAMESTATE:IsPlayerEnabled(PLAYER_2);x,SCREEN_RIGHT-55;y,SCREEN_TOP+120);
	CreateStats( PLAYER_2 );
};
-- [ja] ここまで 

-- [ja] 以下、音 
t[#t+1] = Def.ActorFrame {
	CodeCommand=function(self, params)
		if params.Name=="PrevSong" then
			self:playcommand("PrevSong");
		elseif params.Name=="NextSong" then
			self:playcommand("NextSong");
		end;
	end;
	LoadActor(THEME:GetPathS("MusicWheel","change")) .. {
		SetCommand = function(self)
			self:stop();
			self:play();
		end;
		NextSongCommand=cmd(playcommand,"Set";);
		PrevSongCommand=cmd(playcommand,"Set";);
	};
};

return t
