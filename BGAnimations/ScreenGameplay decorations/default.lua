local t=Def.ActorFrame{};-- = LoadFallbackB()
t[#t+1]=EXF_ScreenGameplay();

local customscore=GetCustomScoreMode();
local cscore;
if GetUserPref_Theme("UserCustomScore") ~= nil then
	cscore = GetUserPref_Theme("UserCustomScore");
else
	cscore = 'Off';
end;

local haishin;
if GetUserPref_Theme("UserHaishin") ~= nil then
	haishin = GetUserPref_Theme("UserHaishin");
else
	haishin = 'Off';
end;
local target;
if GetUserPref_Theme("UserTarget") ~= nil then
	target = GetUserPref_Theme("UserTarget");
else
	target = 'Off';
end;
local scoreType=GetUserPref("UserPrefScoringMode");

t[#t+1] = StandardDecorationFromFileOptional("ScoreFrameP1","ScoreFrameP1");
t[#t+1] = StandardDecorationFromFileOptional("ScoreFrameP2","ScoreFrameP2");

for pn in ivalues(PlayerNumber) do
	local songMeterDisplay = Def.ActorFrame{
		InitCommand=function(self) 
			self:y(SCREEN_CENTER_Y); 
			self:x((pn==PLAYER_1) and (SCREEN_LEFT+5) or (SCREEN_RIGHT-5));
			self:player(pn); 
			self:rotationz(-90); 
		end;
		Def.Quad {
			InitCommand=cmd(zoomto,THEME:GetMetric("SongMeterDisplay","StreamWidth")+2,12);
			OnCommand=cmd(diffuse,Color("Black");fadetop,0.2;fadebottom,0.2;diffusealpha,0.5);
			OffCommand=cmd(linear,0.5;zoomy,0);
		};
		Def.Quad {
			InitCommand=cmd(zoomto,THEME:GetMetric("SongMeterDisplay","StreamWidth"),4);
			OnCommand=cmd(diffuse,color("#C0C0C0");diffusealpha,0.5);
			OffCommand=cmd(linear,0.5;zoomy,0);
		};
		Def.Quad {
			InitCommand=cmd(zoomto,THEME:GetMetric("SongMeterDisplay","StreamWidth")-2,2);
			OnCommand=cmd(diffuse,Color("White");diffusealpha,0.5);
			OffCommand=cmd(linear,0.5;zoomy,0);
		};
		LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'Container ' .. PlayerNumberToString(pn) ) ) .. {
			OnCommand=cmd(diffusealpha,1);
			OffCommand=cmd(linear,0.5;zoomy,0);
		};
	};
	t[#t+1] = songMeterDisplay
end;

-- [ja] スピード、スクロール切り替え
local speed_cs={"",""};
local speed_ce={"",""};
local speed_cnt={0,0};
local scroll={false,false};
local scroll_per={0,0};
local scroll_cnt={0,0};
fn=""..PROFILEMAN:GetProfileDir('ProfileSlot_Machine').."SpeedMods.txt";
local l="";
if FILEMAN:DoesFileExist(fn) then
	local f=RageFileUtil.CreateRageFile();
	f:Open(fn,1);
	l=f:GetLine();
	f:Close();
	f:destroy();
end;
local speeds="";
if l==nil or l=="" then
	speeds="1x";
else
	speeds=split(",",l);
end;
local now_speed_t={1,1};
local now_speed_s={"nil","nil"};
local bpm_h={1,1};
for pn in ivalues(PlayerNumber) do
	t[#t+1] = Def.Quad{
		InitCommand=function(self)
			self:visible(false);
			local p=((pn=="PlayerNumber_P1") and 1 or 2);
			for i=1,#speeds do
				local modstr=GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Preferred");
				if string.find(modstr,speeds[i],0,true) then
					now_speed_t[p]=i;
					now_speed_s[p]=speeds[i];
					break;
				end;
			end;
			if now_speed_s[p]=="nil" then
				for i=1,#speeds do
					if speeds[i]=="1x" then
						now_speed_t[p]=i;
						now_speed_s[p]=speeds[i];
					end;
				end;
			end;
			local _st=GAMESTATE:GetCurrentSteps(pn);
			local _td=_st:GetTimingData();
			local bpms=_td:GetBPMs();
			bpm_h[p]=bpms[1];
			for i=1,#bpms do
				if bpms[i]>bpm_h[p] then bpm_h[p]=bpms[i]; end;
			end;
		end;
	};
end;

speedscroll = Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(visible,false);
		CodeMessageCommand=function(self,params)
			local pn = params.PlayerNumber;
			local p=((pn=="PlayerNumber_P1") and 1 or 2);
			local ps = GAMESTATE:GetPlayerState(pn);
			local po = ps:GetPlayerOptions("ModsLevel_Preferred");
			local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred");
			if string.find(modstr,"^.*Reverse.*") and (not scroll[p]) then
				scroll[p]=true;
				scroll_per[p]=100;
			end;
			if params.Name == "ScrollNomal" then
				scroll_cnt[p]=25;
				scroll[p]=false;
			elseif params.Name == "ScrollReverse" then
				scroll_cnt[p]=25;
				scroll[p]=true;
			elseif params.Name == "HiSpeedUp" then
				speed_cnt[p]=25;
				now_speed_t[p]=now_speed_t[p]+1;
				if now_speed_t[p]>#speeds then now_speed_t[p]=1; end;
				local ctmp=split("C",speeds[now_speed_t[p]]);
				if #ctmp==2 then
					modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", C1";
					ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
				end;
				local mtmp=split("m",speeds[now_speed_t[p]]);
				if #mtmp==2 then
					modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", "..tonumber(mtmp[2])/bpm_h[1].."x, m"..mtmp[2];
				else
					modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", "..speeds[now_speed_t[p]];
				end;
				ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
			elseif params.Name == "HiSpeedDown" then
				speed_cnt[p]=25;
				now_speed_t[p]=now_speed_t[p]-1;
				if now_speed_t[p]<1 then now_speed_t[p]=#speeds; end;
				local ctmp=split("C",speeds[now_speed_t[p]]);
				if #ctmp==2 then
					modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", C1";
					ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
				end;
				local mtmp=split("m",speeds[now_speed_t[p]]);
				if #mtmp==2 then
					modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", "..tonumber(mtmp[2])/bpm_h[1].."x, m"..mtmp[2];
				else
					modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", "..speeds[now_speed_t[p]];
				end;
				ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
			end;
		end;
	};
};
local function spsc_update(self)
	for p=1,2 do
		local pn="PlayerNumber_P"..p;
		if GAMESTATE:IsPlayerEnabled(pn) then
			local ps = GAMESTATE:GetPlayerState(pn);
			local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred");
			if scroll_cnt[p]>0 then
				if scroll[p]==true then
					scroll_per[p]=scroll_per[p]+(100-scroll_per[p])/scroll_cnt[p];
				else
					scroll_per[p]=scroll_per[p]-scroll_per[p]/scroll_cnt[p];
				end;
				modstr = modstr .. ", " .. scroll_per[p] .. "% reverse";
				ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
				scroll_cnt[p]=scroll_cnt[p]-1;
			end;
		end;
	end;
end;

speedscroll.InitCommand=cmd(SetUpdateFunction,spsc_update;);
t[#t+1] = speedscroll;

-- [ja] 倍速表示 
for pn in ivalues(PlayerNumber) do
	if GAMESTATE:IsPlayerEnabled(pn) then
		t[#t+1]=Def.ActorFrame{
			CodeMessageCommand=function(self,params)
				local pn = params.PlayerNumber;
				if params.PlayerNumber==pn
					and (params.Name == "HiSpeedUp" or params.Name == "HiSpeedDown") then
					self:playcommand("Set");
				end;
			end;
			Def.Quad{
				InitCommand=cmd(zoomto,256,80;x,GetStepZonePosX(pn);y,SCREEN_CENTER_Y;
					diffuse,Color("Black");fadeleft,0.5;faderight,0.5;diffusealpha,0;);
				SetCommand=function(self)
					self:finishtweening();
					if not IsReverse(pn) then
						self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYStandard")+80);
					else
						self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYReverse")-80);
					end;
					(cmd(finishtweening;diffusealpha,1;sleep,2.0;linear,0.5;diffusealpha,0))(self);
				end;
			};
			LoadFont("Common Normal")..{
				InitCommand=cmd(x,GetStepZonePosX(pn);
					diffuse,Color("White");socketcolor,Color("Outline");diffusealpha,0;);
				SetCommand=function(self)
					local p=((pn=="PlayerNumber_P1") and 1 or 2);
					self:finishtweening();
					if not IsReverse(pn) then
						self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYStandard")+80);
					else
						self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYReverse")-80);
					end;
					self:settext(speeds[now_speed_t[p]]);
					(cmd(diffusealpha,1;sleep,2.0;linear,0.5;diffusealpha,0))(self);
				end;
			};
		};
	end;
end;

-- [ja] ターゲットスコア 
local target_sx=256;
local target_cnt={0,0};
local target_hi={};
local target_total={0,0};
local target_hidp={};
local target_dp={};
local target_per={};
local target_rev={};
if target=="On" then
	for pn in ivalues(PlayerNumber) do
		if GAMESTATE:IsPlayerEnabled(pn) and PROFILEMAN:IsPersistentProfile(pn) then
			t[#t+1]=Def.ActorFrame{
				CodeMessageCommand=function(self,params)
					local pn = params.PlayerNumber;
					if params.Name == "ScrollNomal" then
						target_rev[pn]=false;
						self:playcommand("Set");
					elseif params.Name == "ScrollReverse" then
						target_rev[pn]=true;
						self:playcommand("Set");
					end;
				end;
				-- [ja] 毎回呼ぶと重いのでグローバル変数に記録 
				BeginCommand=function(self)
					local p=((pn=="PlayerNumber_P1") and 1 or 2);
					if not GAMESTATE:IsCourseMode() then
						target_hi[p]=PROFILEMAN:GetProfile(pn):GetHighScoreList(_SONG(),GAMESTATE:GetCurrentSteps(pn)):GetHighScores();
						target_total[p]=yaGetRD(pn,'RadarCategory_TapsAndHolds')+yaGetRD(pn,'RadarCategory_Holds')+yaGetRD(pn,'RadarCategory_Rolls');
					else
						local trail = GAMESTATE:GetCurrentTrail(pn);
						local tr_ent = trail:GetTrailEntries()
						local tr_max = #tr_ent;
						target_hi[p]=PROFILEMAN:GetProfile(pn):GetHighScoreList(GAMESTATE:GetCurrentCourse(),trail):GetHighScores();
						for i=1,tr_max do
							local rv=tr_ent[i]:GetSteps():GetRadarValues(pn);
							target_total[p]=target_total[p]+rv:GetValue('RadarCategory_TapsAndHolds')+rv:GetValue('RadarCategory_Holds')+rv:GetValue('RadarCategory_Rolls');
						end;
					end;
					target_hidp[p]=GetScoreData(target_hi[p],"dp");
				end;
				JudgmentMessageCommand = function(self, params)
					if params.Player==pn and params.TapNoteScore and
					   params.TapNoteScore ~= 'TapNoteScore_Invalid' and
					   params.TapNoteScore ~= 'TapNoteScore_AvoidMine' and
					   params.TapNoteScore ~= 'TapNoteScore_HitMine' and
					   params.TapNoteScore ~= 'TapNoteScore_None' then
						self:stoptweening();
						self:sleep(0.02);
						local p=((pn=="PlayerNumber_P1") and 1 or 2);
						target_cnt[p]=target_cnt[p]+1;
						local pss=STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
						local w1=pss:GetTapNoteScores('TapNoteScore_W1');
						local w2=pss:GetTapNoteScores('TapNoteScore_W2');
						local w3=pss:GetTapNoteScores('TapNoteScore_W3');
						local hd=pss:GetHoldNoteScores('HoldNoteScore_Held');
						if (GAMESTATE:GetPlayerState(pn):GetPlayerController()~='PlayerController_Autoplay') then
							if params.HoldNoteScore=='HoldNoteScore_Held' then
								hd=hd+1;
							elseif params.TapNoteScore=='TapNoteScore_W1' then
								w1=w1+1;
							elseif params.TapNoteScore=='TapNoteScore_W2' then
								w2=w2+1;
							elseif params.TapNoteScore=='TapNoteScore_W3' then
								w3=w3+1;
							end;
						end;
						target_dp[p]=(w1*3+w2*2+w3+hd*3)/(target_total[p]*3);
						target_per[p]=(target_dp[p]-(target_hidp[p]*target_cnt[p]/target_total[p]))*100;
						self:queuecommand("TargetScore");
					end;
				end;
				InitCommand=cmd(x,GetStepZonePosX(pn));
				OnCommand=function(self)
					self:zoomy(0);
					target_rev[PLAYER_1]=IsReverse(PLAYER_1);
					target_rev[PLAYER_2]=IsReverse(PLAYER_2);
					if not target_rev[pn] then
						self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYStandard")+55);
					else
						self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYReverse")-55);
					end;
					self:sleep(0.5);
					self:linear(0.3);
					self:zoomy(1);
				end;
				SetCommand=function(self)
					self:finishtweening();
					self:zoomy(1);
					self:linear(0.1);
					if not target_rev[pn] then
						self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYStandard")+55);
					else
						self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYReverse")-55);
					end;
				end;
				
				Def.Quad{
					InitCommand=cmd(zoomto,target_sx+2,20;horizalign,left;x,-target_sx/2-1;diffuse,0,0,0,0.5;);
				};
				Def.Quad{
					InitCommand=cmd(zoomto,target_sx,18;horizalign,left;x,-target_sx/2;diffuse,1,1,1,0.5;);
					OnCommand=function(self)
						self:zoomx(0);
						self:zoomy(18);
					end;
					TargetScoreCommand = function(self)
						self:stoptweening();
						local p=((pn=="PlayerNumber_P1") and 1 or 2);
						self:zoomx(target_sx*(target_hidp[p]*target_cnt[p]/target_total[p]));
						self:zoomy(18);
					end;
					OffCommand=function(self)
						local p=((pn=="PlayerNumber_P1") and 1 or 2);
						self:zoomx(target_sx*(target_hidp[p]*target_cnt[p]/target_total[p]));
						self:zoomy(18);
					end;
				};
				Def.Quad{
					InitCommand=cmd(zoomto,0,18;horizalign,left;x,-target_sx/2;diffuse,PlayerColor(pn););
					TargetScoreCommand = function(self, param)
						self:stoptweening();
						local p=((pn=="PlayerNumber_P1") and 1 or 2);
						self:zoomx(target_sx*target_dp[p]);
						self:zoomy(18);
						self:diffusealpha(0.5);
					end;
				};
				LoadFont("Common Normal")..{
					InitCommand=function(self)
						(cmd(zoom,0.8;x,target_sx/2-42;y,-1;
							diffuse,0.8,0.8,0.8,1;strokecolor,Color("Outline");))(self);
							self:settextf("%4.2f%%",0);
					end;
					TargetScoreCommand = function(self)
						self:stoptweening();
						local add_ch="";
						local p=((pn=="PlayerNumber_P1") and 1 or 2);
						if target_per[p]<-0.005 then
							self:diffuse(ColorLightTone(Color("Red")));
							add_ch="";
						elseif target_per[p]>0.005 then
							self:diffuse(ColorLightTone(Color("Blue")));
							add_ch="+";
						else
							self:diffuse(0.8,0.8,0.8,1);
							add_ch=" ";
						end;
						self:settextf("%s%4.2f%%",add_ch,target_per[p]);
						self:zoom(1.0);
						self:linear(0.02);
						self:zoom(0.8);
					end;
				};
			};
		end;
	end;
end;
--[[
for pn in ivalues(PlayerNumber) do
	local MetricsName = "ToastyDisplay" .. PlayerNumberToString(pn);
	t[#t+1] = LoadActor( THEME:GetPathG("Player", 'toasty'), pn ) .. {
		InitCommand=function(self) 
			self:player(pn); 
			self:name(MetricsName); 
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen"); 
		end;
	};
end;
--]]

--[[
-- [ja] 遊び 
t[#t+1]=Def.ActorFrame{
	FOV=60;
	InitCommand=cmd(rotationz,20;rotationx,20;zoom,0.3;x,SCREEN_CENTER_X;y,100;queuecommand,"Loop");
	LoopCommand=cmd(rotationy,0;linear,10;rotationy,360;queuecommand,"Loop");
	Def.ActorProxy{
		BeginCommand=function(self)
			-- the key here is to 1) find something you want to proxy
			local banner = SCREENMAN:GetTopScreen():GetChild('SongBackground');
			-- then 2) set the ActorProxy's target to said something.
			self:SetTarget(banner);
		end;
	};
	Def.ActorProxy{
		BeginCommand=function(self)
			if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				-- the key here is to 1) find something you want to proxy
				local banner = SCREENMAN:GetTopScreen():GetChild('PlayerP1');
				-- then 2) set the ActorProxy's target to said something.
				self:SetTarget(banner);
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	};
	Def.ActorProxy{
		BeginCommand=function(self)
			if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
				-- the key here is to 1) find something you want to proxy
				local banner = SCREENMAN:GetTopScreen():GetChild('PlayerP2');
				-- then 2) set the ActorProxy's target to said something.
				self:SetTarget(banner);
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	};
};
--]]


t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay");
t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");
--[[
-- [ja] Tosty気になって仕方がない 
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_RIGHT;y,SCREEN_BOTTOM;draworder,5);
	LoadActor("_whatsup") .. {
		InitCommand=cmd(horizalign,left;vertalign,top);
		ToastyMessageCommand=cmd(smooth,3;x,-256;y,-200;sleep,2;smooth,3;x,256;y,200)
	};
};
--]]

if( not GAMESTATE:IsCourseMode() and customscore~="non" ) then
local stepcnt={0,0}
t[#t+1] = Def.Actor{
	JudgmentMessageCommand = function(self, params)
		if params.TapNoteScore and
		   params.TapNoteScore ~= 'TapNoteScore_AvoidMine' and
		   params.TapNoteScore ~= 'TapNoteScore_HitMine' and
		   params.TapNoteScore ~= 'TapNoteScore_CheckpointMiss' and
		   params.TapNoteScore ~= 'TapNoteScore_CheckpointHit' and
		   params.TapNoteScore ~= 'TapNoteScore_None'
		then
			if customscore=="old" then
				Scoring[scoreType](params, 
					STATSMAN:GetCurStageStats():GetPlayerStageStats(params.Player))
			else
				local pn=((params.Player==PLAYER_1) and 1 or 2);
				stepcnt[pn]=stepcnt[pn]+1;
				CustomScore_SM5b1(params,cscore,GAMESTATE:GetCurrentSteps(params.Player),stepcnt[pn]);
			end;
		end
	end;
};
end;

--[[
do
	local pointLookup={
		['TapNoteScore_W1']=1,
		['TapNoteScore_W2']=1,
		['TapNoteScore_W3']=1,
		['TapNoteScore_W4']=1,
		['TapNoteScore_W5']=1,
		['TapNoteScore_HitMine']=-1}
	local ignorableTapNoteScores = {
		['TapNoteScore_HitMine']=true,
		['TapNoteScore_AvoidMine']=true,
		['TapNoteScore_CheckpointHit']=true,
		['TapNoteScore_CheckpointMiss']=true
	}
	setmetatable(pointLookup,{__index=0})
	t[#t+1] = {Class="Actor",
		JudgmentMessageCommand=function(self,params)
			local PSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(params.Player)
			local holdNoteInfo = params.HoldNoteScore == nil and nil or params.HoldNoteScore == 'HoldNoteScore_Held' and true or false
			PSS:SetScore(PSS:GetScore()+pointLookup[params.TapNoteScore]+(holdNoteInfo and 5 or 0))
			PSS:SetCurMaxScore(PSS:GetCurMaxScore()+(holdNoteInfo~=nil and 5 or 0)+(ignorableTapNoteScores[params.TapNoteScore] and 0 or 5))
		end
	}
end
--]]

return t;
