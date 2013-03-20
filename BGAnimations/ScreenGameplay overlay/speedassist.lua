local speed_assist;

local song = _SONG();
local pAssist={
	(GetUserPref_Theme("UserSpeedAssistP1")=='On'),
	(GetUserPref_Theme("UserSpeedAssistP2")=='On')};
local pStepZoneX={GetStepZonePosX(PLAYER_1),GetStepZonePosX(PLAYER_2)};
local pStepZoneY={SCREEN_CENTER_Y,SCREEN_CENTER_Y};
local now = 0.0;

local stopPosListP1;
local stopSecListP1;
local stopPosListP2;
local stopSecListP2;
local stopNowCnt;
local function setStopList(pn)
	if pn==PLAYER_1 and not GAMESTATE:IsPlayerEnabled(PLAYER_1) then
		stopPosListP1={-1};
		return;
	end;
	if pn==PLAYER_2 and not GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		stopPosListP2={-1};
		return;
	end;
	local st=GAMESTATE:GetCurrentSteps(pn);
	local td=st:GetTimingData();
	if td:HasStops() then
		local strStops=td:GetStops();
		for i=1,#strStops do
			local stopData=split("=",strStops[i]);
			if pn==PLAYER_1 then
				stopPosListP1[i]=tonumber(stopData[1]);
				stopSecListP1[i]=tonumber(stopData[2]);
			else
				stopPosListP2[i]=tonumber(stopData[1]);
				stopSecListP2[i]=tonumber(stopData[2]);
			end;
		end;
	else
		if (pn==PLAYER_1) then
			stopPosListP1={-1};
		else
			stopPosListP2={-1};
		end;
	end;
end;

speed_assist=Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:visible(false);
			stopPosListP1={0};
			stopSecListP1={0};
			stopPosListP2={0};
			stopSecListP2={0};
			stopNowCnt={1,1};
			setStopList(PLAYER_1);
			setStopList(PLAYER_2);
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
	};
	LoadActor(THEME:GetPathG("_objects/_circle","glow100px"))..{
		Name="P1Glow";
		InitCommand=cmd(diffuse,Color("Red");blend,"BlendMode_Add";
			x,pStepZoneX[1];y,pStepZoneY[1];diffusealpha,0;visible,pAssist[1];);
		OnCommand=cmd(diffusealpha,0;);
	};
	LoadActor(THEME:GetPathG("_objects/_circle","100px"))..{
		Name="P1Circle";
		InitCommand=cmd(diffuse,Color("Red");blend,"BlendMode_Add";
			x,pStepZoneX[1];y,pStepZoneY[1];diffusealpha,0;visible,pAssist[1];);
		OnCommand=cmd(diffusealpha,0;);
	};
	LoadActor(THEME:GetPathG("_objects/_circle","glow100px"))..{
		Name="P2Glow";
		InitCommand=cmd(diffuse,Color("Red");blend,"BlendMode_Add";
			x,pStepZoneX[2];y,pStepZoneY[2];diffusealpha,0;visible,pAssist[2];);
		OnCommand=cmd(diffusealpha,0;);
	};
	LoadActor(THEME:GetPathG("_objects/_circle","100px"))..{
		Name="P2Circle";
		InitCommand=cmd(diffuse,Color("Red");blend,"BlendMode_Add";
			x,pStepZoneX[2];y,pStepZoneY[2];diffusealpha,0;visible,pAssist[2];);
		OnCommand=cmd(diffusealpha,0;);
	};
};

local function update(self)
	now=_MUSICSECOND();
	local beat;
	if pAssist[1] then
		local st_glow = self:GetChild("P1Glow");
		local st_circ = self:GetChild("P1Circle");
		if stopPosListP1[1]~=-1 and stopNowCnt[1]<=#stopPosListP1 then
			beat=1.0*Sec2PlayerBeat(PLAYER_1,now);
			if 1.0*beat>=stopPosListP1[stopNowCnt[1]] then
				local stopBegin=PlayerBeat2Sec(PLAYER_1,stopPosListP1[stopNowCnt[1]]);
				local stopEnd=stopBegin+stopSecListP1[stopNowCnt[1]];
				if now>=stopEnd+0.1 then
					st_glow:diffusealpha(0);
					st_circ:diffusealpha(0);
					stopNowCnt[1]=stopNowCnt[1]+1;
				elseif now>=stopEnd then
					st_glow:diffusealpha(1.0-(now-stopEnd)*10);
					st_glow:zoom(1.0+(now-stopEnd)*10);
					st_circ:diffusealpha(1.0-(now-stopEnd)*10);
					st_circ:zoom(1.0+(now-stopEnd)*10);
				elseif now<stopBegin+0.1 then
					st_glow:diffusealpha(1.0-(stopBegin+0.1-now)*10);
					st_glow:zoom(1.0+(stopBegin+0.1-now)*10);
					st_circ:diffusealpha(1.0-(stopEnd-now)/stopSecListP1[stopNowCnt[1]]);
					st_circ:zoom(1.0-(stopEnd-now)/stopSecListP1[stopNowCnt[1]]);
				else
					st_glow:diffusealpha(1.0);
					st_glow:zoom(1.0);
					st_circ:diffusealpha(1.0-(stopEnd-now)/stopSecListP1[stopNowCnt[1]]);
					st_circ:zoom(1.0-(stopEnd-now)/stopSecListP1[stopNowCnt[1]]);
				end;
			else
					st_glow:diffusealpha(0);
					st_circ:diffusealpha(0);
			end;
		else
				st_glow:diffusealpha(0);
		end;
	end;
	if pAssist[2] then
		local st_glow = self:GetChild("P2Glow");
		local st_circ = self:GetChild("P2Circle");
		if stopPosListP2[1]~=-1 and stopNowCnt[2]<=#stopPosListP2 then
			beat=1.0*Sec2PlayerBeat(PLAYER_2,now);
			if 1.0*beat>=stopPosListP2[stopNowCnt[2]] then
				local stopBegin=PlayerBeat2Sec(PLAYER_2,stopPosListP2[stopNowCnt[2]]);
				local stopEnd=stopBegin+stopSecListP2[stopNowCnt[2]];
				if now>=stopEnd+0.1 then
					st_glow:diffusealpha(0);
					st_circ:diffusealpha(0);
					stopNowCnt[2]=stopNowCnt[2]+1;
				elseif now>=stopEnd then
					st_glow:diffusealpha(1.0-(now-stopEnd)*10);
					st_glow:zoom(1.0+(now-stopEnd)*10);
					st_circ:diffusealpha(1.0-(now-stopEnd)*10);
					st_circ:zoom(1.0+(now-stopEnd)*10);
				elseif now<stopBegin+0.1 then
					st_glow:diffusealpha(1.0-(stopBegin+0.1-now)*10);
					st_glow:zoom(1.0+(stopBegin+0.1-now)*10);
					st_circ:diffusealpha(1.0-(stopEnd-now)/stopSecListP2[stopNowCnt[2]]);
					st_circ:zoom(1.0-(stopEnd-now)/stopSecListP2[stopNowCnt[2]]);
				else
					st_glow:diffusealpha(1.0);
					st_glow:zoom(1.0);
					st_circ:diffusealpha(1.0-(stopEnd-now)/stopSecListP2[stopNowCnt[2]]);
					st_circ:zoom(1.0-(stopEnd-now)/stopSecListP2[stopNowCnt[2]]);
				end;
			else
					st_glow:diffusealpha(0);
					st_circ:diffusealpha(0);
			end;
		else
				st_glow:diffusealpha(0);
		end;
	end;
end;

speed_assist.InitCommand=cmd(SetUpdateFunction,update;);

return speed_assist;
