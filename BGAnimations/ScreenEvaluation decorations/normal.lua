EXF_ScreenEvaluation_Begin();

local MinCombo_=GetUserPref_Theme("UserMinCombo");
local MinCombo=(MinCombo_=='TapNoteScore_W3') and 3 or ((MinCombo_=='TapNoteScore_W1') and 1 or ((MinCombo_=='TapNoteScore_W2') and 2 or 4));

local eva_w1=0;
local eva_w2=0;
local eva_w3=0;
local eva_w4=0;
local eva_w5=0;
local eva_ms=0;
local eva_ok=0;
local eva_ng=0;
local eva_tt=0;
local eva_hr=0;	-- [ja] ロングノートの数 

-- [ja] W1～Missの数を返す(通常用) 
local function GetSongJud(pn)
	local ss = STATSMAN:GetCurStageStats();
	local pss = ss:GetPlayerStageStats(pn);
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

-- [ja] W1～Missの数を返す(ネット対戦用) 
local function GetNetJud(pn)
	local p=((pn=='PlayerNumber_P1') and 1 or 2);
	eva_w1=tonumber(SCREENMAN:GetTopScreen():GetChild("W1NumberP"..p):GetText());
	eva_w2=tonumber(SCREENMAN:GetTopScreen():GetChild("W2NumberP"..p):GetText());
	eva_w3=tonumber(SCREENMAN:GetTopScreen():GetChild("W3NumberP"..p):GetText());
	eva_w4=tonumber(SCREENMAN:GetTopScreen():GetChild("W4NumberP"..p):GetText());
	eva_w5=tonumber(SCREENMAN:GetTopScreen():GetChild("W5NumberP"..p):GetText());
	eva_ms=tonumber(SCREENMAN:GetTopScreen():GetChild("MissNumberP"..p):GetText());
	eva_ok=tonumber(SCREENMAN:GetTopScreen():GetChild("HeldNumberP"..p):GetText());
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

local function PercentScore( pn )
	local t = Def.ActorFrame{
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
				-- todo: color by difficulty
				local SongOrCourse, StepsOrTrail;
				if GAMESTATE:IsCourseMode() then
					SongOrCourse = GAMESTATE:GetCurrentCourse()
					StepsOrTrail = GAMESTATE:GetCurrentTrail(pn)
				else
					SongOrCourse = GAMESTATE:GetCurrentSong()
					StepsOrTrail = GAMESTATE:GetCurrentSteps(pn)
				end;
				if SongOrCourse and StepsOrTrail then
					local st = StepsOrTrail:GetStepsType();
					local diff = StepsOrTrail:GetDifficulty();
					local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
					local cd = GetCustomDifficulty(st, diff, courseType);
					if GAMESTATE:IsCourseMode() then
						self:diffuse(ColorLightTone2(CustomDifficultyToColor(diff)));
						self:strokecolor(ColorDarkTone(CustomDifficultyToColor(diff)));
					else
						self:diffuse(_DifficultyLightCOLOR(diff));
						self:strokecolor(ColorDarkTone(_DifficultyCOLOR(diff)));
					end;
				end

				local pss = STATSMAN:GetPlayedStageStats(1):GetPlayerStageStats(pn);
				if pss then
					local tStats = {
						W1			= pss:GetTapNoteScores('TapNoteScore_W1');
						W2			= pss:GetTapNoteScores('TapNoteScore_W2');
						W3			= pss:GetTapNoteScores('TapNoteScore_W3');
						W4			= pss:GetTapNoteScores('TapNoteScore_W4');
						W5			= pss:GetTapNoteScores('TapNoteScore_W5');
						Miss		= pss:GetTapNoteScores('TapNoteScore_Miss');
						HitMine		= pss:GetTapNoteScores('TapNoteScore_HitMine');
						AvoidMine	= pss:GetTapNoteScores('TapNoteScore_AvoidMine');
						Held		= pss:GetHoldNoteScores('HoldNoteScore_Held');
						LetGo		= pss:GetHoldNoteScores('HoldNoteScore_LetGo');
						Total		= 1;
						HoldsAndRolls = 0;
						Seconds		= pss:GetCurrentLife();
					};
					
					local itg = ( tStats["W1"]*7 + tStats["W2"]*6 + tStats["W3"]*5 + tStats["W4"]*4 + tStats["W5"]*2 + tStats["Held"]*7 );
					
					-- itg_max is problematic if the players hold down START to exit prematurely...
					local itg_max = ( tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"] + tStats["Held"] + tStats["LetGo"] )*7;
					local itg_score = itg/itg_max * 100;
					
					local function round(num, decimals)
						local mult = 10^(decimals or 0)
						return math.floor(num * mult + 0.5) / mult
					end
					
					local itg_score_rounded = round(itg_score, 2);
					
					if pct == 1 then
						self:settext("100%");
					else
						-- This doesn't format quite the way I want it to
						-- for example, it will drop the trailing 0 from
						-- a 99.30% so that it prints as 99.3%
						self:settext(itg_score_rounded.."%");
					end;
				end;
			end;
			UpdateNetEvalStatsMessageCommand=function(self,params)
				self:diffuse(_DifficultyLightCOLOR(params.Difficulty));
				self:strokecolor(ColorDarkTone(_DifficultyCOLOR(params.Difficulty)));
				local st=params.Steps;
				eva_hr=st:GetRadarValues(pn):GetValue('RadarCategory_Holds')+st:GetRadarValues(pn):GetValue('RadarCategory_Rolls');
				eva_tt=math.max(st:GetRadarValues(pn):GetValue('RadarCategory_TapsAndHolds'),1);
				eva_ng=eva_hr-eva_ok;
				self:sleep(0.01);
				self:queuecommand("NetPercent")
			end;
			NetPercentCommand=function(self)
				GetNetJud(pn)
				local pct=(eva_w1*3+eva_w2*2+eva_w3+eva_ok*3)/((eva_tt+eva_hr)*3);
				if pct == 1 then
					self:settext("100%");
				else
					self:settextf("%4.2f%%",math.floor(pct*10000)*0.01);
				end;
			end;
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
				local SongOrCourse, StepsOrTrail;
				if GAMESTATE:IsCourseMode() then
					SongOrCourse = GAMESTATE:GetCurrentCourse()
					StepsOrTrail = GAMESTATE:GetCurrentTrail(pn)
				else
					SongOrCourse = GAMESTATE:GetCurrentSong()
					StepsOrTrail = GAMESTATE:GetCurrentSteps(pn)
				end;
				if SongOrCourse and StepsOrTrail then
					local st = StepsOrTrail:GetStepsType();
					local diff = StepsOrTrail:GetDifficulty();
					local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
					local cd = GetCustomDifficulty(st, diff, courseType);
					if GAMESTATE:IsCourseMode() then
						self:diffuse(ColorLightTone2(CustomDifficultyToColor(diff)));
						self:strokecolor(ColorDarkTone(CustomDifficultyToColor(diff)));
						self:settextf("%s",string.upper(ToEnumShortString(diff)));
					else
						self:diffuse(_DifficultyLightCOLOR(diff));
						self:strokecolor(ColorDarkTone(_DifficultyCOLOR(diff)));
						self:settextf("%s",string.upper(_DifficultyNAME(diff)));
					end;
				end
			end;
			UpdateNetEvalStatsMessageCommand=function(self,params)
				if pn=='PlayerNumber_P1' then
					(cmd(horizalign,right;x,60;))(self);
				else
					(cmd(horizalign,left;x,-60;))(self);
				end;
				self:diffuse(_DifficultyLightCOLOR(params.Difficulty));
				self:strokecolor(ColorDarkTone(_DifficultyCOLOR(params.Difficulty)));
				self:settextf("%s",string.upper(_DifficultyNAME(params.Difficulty)));
			end;
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

-- [ja] 難易度 
for pn in ivalues(PlayerNumber) do
	if GAMESTATE:IsPlayerEnabled(pn) then
		t[#t+1]=Def.ActorFrame{
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
					local song = _SONG();
					local course = GAMESTATE:GetCurrentCourse();
					if course then
						self:diffuse(CustomDifficultyToColor(GAMESTATE:GetCurrentTrail(pn):GetDifficulty()));
					elseif song then
						local dif=GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
						self:diffuse(_DifficultyCOLOR(dif));
					else
						self:diffuse(CustomDifficultyToColor("Difficulty_Edit"));
					end;
				end;
				OffCommand=cmd(linear,0.3;diffusealpha,0);
				UpdateNetEvalStatsMessageCommand=function(self,params)
					self:horizalign(right);
					if pn=='PlayerNumber_P1' then
						self:rotationy(180);
					end;
					self:diffuse(_DifficultyCOLOR(params.Difficulty));
				end;
			};
		};
	end;
end;

-- [ja] グレード 
for pn in ivalues(PlayerNumber) do
	if GAMESTATE:IsPlayerEnabled(pn) then
		--
		t[#t+1]=Def.ActorFrame{
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
				OnCommand=function(self)
					local ss = STATSMAN:GetCurStageStats();
					local pss = ss:GetPlayerStageStats(pn);
					self:visible(true);
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
					(cmd(blend,"BlendMode_Add";zoom,0;spring,0.64;zoom,2.3))(self);
				end;
				UpdateNetEvalStatsMessageCommand=function(self,params)
					self:stoptweening();
					self:sleep(0.01);
					self:queuecommand("Set");
				end;
				SetCommand=function(self)
					GetNetJud(pn);
					if eva_ng<=0 and eva_ms<=0 and eva_w5<=0 
						and (eva_w4>0 or eva_w3>0 or eva_w2>0 or eva_w1>0) then
						self:visible(true);
						if eva_w4<=0 and eva_w3<=0 and eva_w2<=0 then
							self:diffuse(GameColor.Judgment["JudgmentLine_W1"]);
						elseif eva_w4<=0 and eva_w3<=0 and MinCombo>=2 then
							self:diffuse(GameColor.Judgment["JudgmentLine_W2"]);
						elseif eva_w4<=0 and MinCombo>=3 then
							self:diffuse(GameColor.Judgment["JudgmentLine_W3"]);
						elseif MinCombo>=4 then
							self:diffuse(BoostColor(GameColor.Judgment["JudgmentLine_W4"],1.2));
						else
							self:visible(false);
						end;
					else
						self:visible(false);
					end;
					(cmd(blend,"BlendMode_Add";zoom,0;linear,0.2;zoom,2.3))(self);
				end;
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
						local eva_jud=GetSongJud(pn);
						local jud_per=Jud2Per(pn,eva_jud,GAMESTATE:GetCurrentSteps(GetSidePlayer(pn)):GetRadarValues(GetSidePlayer(pn)):GetValue('RadarCategory_TapsAndHolds'));
						local w1_per=jud_per[1];
						local w2_per=jud_per[2];
						local w3_per=jud_per[3];
						local w4_per=jud_per[4];
						local w5_per=jud_per[5];
						local ms_per=jud_per[6];
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
					UpdateNetEvalStatsMessageCommand=function(self,params)
					--	eva_tt=params.Steps:GetRadarValues(GetSidePlayer(pn)):GetValue('RadarCategory_TapsAndHolds');
						self:sleep(0.011);
						self:queuecommand("NetPercent");
					end;
					NetPercentCommand=function(self)
						GetNetJud(pn);
						eva_jud={eva_w1,eva_w2,eva_w3,eva_w4,eva_w5,eva_ms};
						local jud_per=Jud2Per(pn,eva_jud,eva_tt);
						local w1_per=jud_per[1];
						local w2_per=jud_per[2];
						local w3_per=jud_per[3];
						local w4_per=jud_per[4];
						local w5_per=jud_per[5];
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
				};
			};
		end;
	end;
end;

t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-60);
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame under"));
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame color"))..{
		BeginCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				self:diffuse(Color("Purple"));
			else
				local song=_SONG();
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
	};
	Def.Sprite{
		InitCommand=cmd(diffusealpha,1;);
		OnCommand=function(self)
			if _COURSE() then
				local course=_COURSE();
				self:LoadBackground(GetCourseGPath(course));
			else
				local song=_SONG();
				local g="";
				if GetUserPref_Theme("UserWheelMode") == 'Jacket->Banner' then
					g=GetSongGPath_JBN(song);
				elseif GetUserPref_Theme("UserWheelMode") == 'Jacket->BG' then
					g=GetSongGPath_JBG(song);
				elseif GetUserPref_Theme("UserWheelMode") == 'Banner->Jacket' then
					g=GetSongGPath_BNJ(song);
				elseif GetUserPref_Theme("UserWheelMode") == 'Text' then
					g=GetSongGPath_JBN(song);
				else
					g=GetSongGPath_JBN(song);
				end;
				self:LoadBackground(g);
			end;
			self:rate(1.0);
			self:scaletofit(0,0,360,360);
			self:x(0);
			self:y(50);
			self:linear(0.2);
			self:scaletofit(0,0,192,192);
			self:x(0);
			self:y(0);
		end;
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame evaluation"))..{
		BeginCommand=function(self)
			(cmd(diffusealpha,0;linear,0.2;diffusealpha,1))(self);
		end;
	};
};

local label_frame={
	THEME:GetMetric("ScreenEvaluation","W1NumberP1Y"),
	THEME:GetMetric("ScreenEvaluation","W2NumberP1Y"),
	THEME:GetMetric("ScreenEvaluation","W3NumberP1Y"),
	THEME:GetMetric("ScreenEvaluation","W4NumberP1Y"),
	THEME:GetMetric("ScreenEvaluation","W5NumberP1Y"),
	THEME:GetMetric("ScreenEvaluation","MissNumberP1Y"),
	THEME:GetMetric("ScreenEvaluation","HeldNumberP1Y"),
	THEME:GetMetric("ScreenEvaluation","MaxComboNumberP1Y")
}
local label_name={
	"JudgmentLine_W1",
	"JudgmentLine_W2",
	"JudgmentLine_W3",
	"JudgmentLine_W4",
	"JudgmentLine_W5",
	"JudgmentLine_Miss",
	"JudgmentLine_Held",
	"JudgmentLine_MaxCombo"
};
for i=1,#label_frame do
t[#t+1]=LoadActor(THEME:GetPathG("_Evaluation","label_frame"))..{
	InitCommand=function(self)
		(cmd(x,SCREEN_CENTER_X;y,label_frame[i]+1;diffuse,GameColor.Judgment[label_name[i]]))(self);
		if GAMESTATE:IsPlayerEnabled('PlayerNumber_P1') and not GAMESTATE:IsPlayerEnabled('PlayerNumber_P2') then
			self:cropright(0.5);
			self:cropleft(0);
		elseif GAMESTATE:IsPlayerEnabled('PlayerNumber_P2') and not GAMESTATE:IsPlayerEnabled('PlayerNumber_P1') then
			self:cropleft(0.5);
			self:cropright(0);
		else
			self:cropleft(0);
			self:cropright(0);
		end;
	end;
};
t[#t+1]=LoadFont("Common Normal")..{
	InitCommand=function(self)
		if GAMESTATE:IsPlayerEnabled('PlayerNumber_P1') then
			(cmd(x,SCREEN_CENTER_X-198;zoom,0.5;horizalign,left;shadowlength,1;
				y,label_frame[i]-13;diffuse,ColorLightTone2(GameColor.Judgment[label_name[i]]);
				strokecolor,ColorDarkTone(GameColor.Judgment[label_name[i]])))(self);
			self:settext(string.upper(_JudgementLabel(label_name[i])));
		end;
	end;
};
t[#t+1]=LoadFont("Common Normal")..{
	InitCommand=function(self)
		if GAMESTATE:IsPlayerEnabled('PlayerNumber_P2') then
			(cmd(x,SCREEN_CENTER_X+198;zoom,0.5;horizalign,right;shadowlength,1;
				y,label_frame[i]-13;diffuse,ColorLightTone2(GameColor.Judgment[label_name[i]]);
				strokecolor,ColorDarkTone(GameColor.Judgment[label_name[i]])))(self);
			self:settext(string.upper(_JudgementLabel(label_name[i])));
		end;
	end;
};
end;

t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");

for pn in ivalues(PlayerNumber) do
	if GAMESTATE:IsPlayerEnabled(pn) then
		--t[#t+1] = StandardDecorationFromTable( "PercentScore" .. ToEnumShortString(pn), PercentScore(pn) );
		t[#t+1]=Def.ActorFrame{
			InitCommand=cmd(x,((pn==PLAYER_1) and SCREEN_LEFT+205 or SCREEN_RIGHT-205);y,SCREEN_TOP+402);
			PercentScore(pn);
		};
	end;
end

for pn in ivalues(PlayerNumber) do
	t[#t+1] = LoadFont("Common Normal") .. {
		InitCommand=function(self)
			self:player(pn);
			self:diffuse(Color("White"));
			self:x(((pn==PLAYER_1) and SCREEN_LEFT+10 or SCREEN_RIGHT-10));
			self:y(SCREEN_TOP+390);
			self:horizalign(((pn==PLAYER_1) and left or right));
			self:zoom(0.5);
			local pss = STATSMAN:GetPlayedStageStats(1):GetPlayerStageStats(pn);
			local pct = pss:GetPercentDancePoints();
			if PROFILEMAN:IsPersistentProfile(pn) then
				-- player profile
				profile = PROFILEMAN:GetProfile(pn);
			else
				-- machine profile
				profile = PROFILEMAN:GetMachineProfile();
			end;
			scorelist = profile:GetHighScoreList(_SONG(),GAMESTATE:GetCurrentSteps(pn));
			local scores = scorelist:GetHighScores();
			if pct>=GetScoreData(scores,"dp") then
				self:settext("NewRecord!!");
			else
				self:settext("");
			end;
		end;
	};
end

showtitleFlag=false;
t[#t+1] = Def.ActorFrame {
	CodeCommand=function(self, params)
		if params.Name=="SwitchSongTitle" then
			showtitleFlag=not showtitleFlag;
			self:playcommand("SwitchSongTitle");
		end;
	end;
	LoadActor(THEME:GetPathS("ScreenEvaluation","SwitchTitle")) .. {
		SwitchSongTitleCommand = function(self)
		--	if not GAMESTATE:IsCourseMode() then
				self:stop();
				self:play();
		--	end;
		end;
	};
	Def.Sprite{
		InitCommand=function(self)
			self:LoadBackground(_SONG():GetCDTitlePath());
			(cmd(horizalign,right;vertalign,bottom;))(self);
			self:visible(showtitleFlag);
		end;
		OnCommand=cmd(playcommand,"SwitchSongTitle");
		SwitchSongTitleCommand=function(self)
			if showtitleFlag then
				self:zoom(0.75);
				local w=self:GetWidth()*0.75;
				local h=self:GetHeight()*0.75;
				local s=((w>h) and w or h);
				if s>186 then
					self:scaletofit(0,0,186,186);
				end;
				self:x(SCREEN_CENTER_X+93);
				self:y(SCREEN_CENTER_Y+33);
				self:visible(true);
			else
				self:zoom(0);
				self:visible(false);
			end;
		end;
	};
	Def.Quad{
		BeginCommand=function(self)
			local SongOrCourse;
			if GAMESTATE:GetCurrentCourse() then
				SongOrCourse = GAMESTATE:GetCurrentCourse();
			elseif GAMESTATE:GetCurrentSong() then
				SongOrCourse = GAMESTATE:GetCurrentSong();
			else
				SongOrCourse = nil;
			end
			
			(cmd(zoomto,192,80;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-60;diffuse,Color("Black");fadeleft,0.6;faderight,0.6))(self);
			self:zoomto(0,0);
		end;
		SwitchSongTitleCommand=function(self)
			if showtitleFlag then
				self:zoomto(192,80);
			else
				self:zoomto(0,0);
			end;
		end;
	};

	StandardDecorationFromFileOptional("SongInformation","SongInformation") .. {
		BeginCommand=function(self)
			local SongOrCourse;
			if GAMESTATE:GetCurrentCourse() then
				SongOrCourse = GAMESTATE:GetCurrentCourse();
			elseif GAMESTATE:GetCurrentSong() then
				SongOrCourse = GAMESTATE:GetCurrentSong();
			else
				SongOrCourse = nil
			end
			self:zoom(0);
		end;
		SwitchSongTitleCommand=function(self)
			if showtitleFlag then
				self:zoom(1);
			else
				self:zoom(0);
			end;
		end;
		SetCommand=function(self)
			local c = self:GetChildren();
			local SongOrCourse;
			if GAMESTATE:GetCurrentCourse() then
				SongOrCourse = GAMESTATE:GetCurrentCourse();
				
				c.TextTitle:maxwidth( 200 );
				c.TextTitle:y(0);
				c.TextTitle:settext( SongOrCourse:GetDisplayFullTitle() or nil );
				c.TextTitle:strokecolor( Color("Outline") );
				c.TextSubtitle:strokecolor( Color("Outline") );
				c.TextArtist:strokecolor( Color("Outline") );
				c.TextSubtitle:settext( nil );
				c.TextSubtitle:visible(false);
				c.TextArtist:settext( nil );
				c.TextArtist:visible(false);
				
	-- 			self:playcommand("Tick");
			elseif GAMESTATE:GetCurrentSong() then
				SongOrCourse = GAMESTATE:GetCurrentSong();

				c.TextTitle:maxwidth( 200 );
				c.TextSubtitle:maxwidth( 340 );
				c.TextArtist:maxwidth( 200 );

				c.TextTitle:strokecolor( Color("Outline") );
				c.TextSubtitle:strokecolor( Color("Outline") );
				c.TextArtist:strokecolor( Color("Outline") );

				c.TextTitle:settext( SongOrCourse:GetDisplayMainTitle() or nil );
				c.TextSubtitle:settext( SongOrCourse:GetDisplaySubTitle() or nil );
				c.TextArtist:settext( SongOrCourse:GetDisplayArtist() or nil );

				if SongOrCourse:GetDisplaySubTitle() == "" then
					c.TextTitle:visible(true);
					c.TextTitle:y(-16.5/2);
					c.TextSubtitle:visible(false);
					c.TextSubtitle:y(0);
					c.TextArtist:visible(true);
					c.TextArtist:y(18/2);
				else
					c.TextTitle:visible(true);
					c.TextTitle:y(-16.5);
					c.TextSubtitle:visible(true);
					c.TextSubtitle:y(0);
					c.TextArtist:visible(true);
					c.TextArtist:y(18);
				end
	-- 			self:playcommand("Tick");
			else
				SongOrCourse = nil;
				
				c.TextTitle:settext("");
				c.TextSubtitle:settext("");
				c.TextArtist:settext("");
				
				self:playcommand("Hide")
			end
		end;
	-- 	OnCommand=cmd(playcommand,"Set");
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
		DisplayLanguageChangedMessageCommand=cmd(playcommand,"Set");
	};
};
t[#t+1] = StandardDecorationFromFileOptional("LifeDifficulty","LifeDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("TimingDifficulty","TimingDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("GameType","GameType");
t[#t+1] = Def.ActorFrame {
	Condition=GAMESTATE:HasEarnedExtraStage() and GAMESTATE:IsExtraStage() and not GAMESTATE:IsExtraStage2();
	InitCommand=cmd(draworder,105);
	LoadActor( THEME:GetPathS("ScreenEvaluation","try Extra1" ) ) .. {
		Condition=THEME:GetMetric( Var "LoadingScreen","Summary" ) == false;
		OnCommand=cmd(play);
	};
};
t[#t+1] = Def.ActorFrame {
	Condition=GAMESTATE:HasEarnedExtraStage() and not GAMESTATE:IsExtraStage() and GAMESTATE:IsExtraStage2();
	InitCommand=cmd(draworder,105);
	LoadActor( THEME:GetPathS("ScreenEvaluation","try Extra2" ) ) .. {
		Condition=THEME:GetMetric( Var "LoadingScreen","Summary" ) == false;
		OnCommand=cmd(play);
	};
};
return t
