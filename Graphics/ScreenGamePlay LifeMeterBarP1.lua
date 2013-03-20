local t=Def.ActorFrame{};
local song = _SONG();

local life;
local life_d=0.0;
local songoptions=GAMESTATE:GetSongOptionsString();
local lifelives=0;
local l_songoptions=string.lower(songoptions);
local isbattery_s;
local isbattery_e;
isbattery_s,isbattery_e=string.find(l_songoptions,"%d+lives");
if isbattery_s then
	lifelives=tonumber(string.sub(l_songoptions,isbattery_s,isbattery_e-5));
else
	lifelives=0;
end;
local glm;
local tcol=GetUserPref_Theme("UserColorPath");
if not FILEMAN:DoesFileExist(THEME:GetCurrentThemeDirectory().."Graphics/"..tcol.."Theme Colors.ini") then
	tcol="";
end;
local col_ln={};
local col_lh={};
local col_ld={};
local col_lb={};
local f=OpenFile(THEME:GetCurrentThemeDirectory().."Graphics/"..tcol.."Theme Colors.ini");
if GetSMParameter_f(f,"lifenormal")~="" then
	col_ln=Str2Color(GetSMParameter_f(f,"lifenormal"));
else
	col_ln={0.0,0.68,0.93,1.0};
end;
if GetSMParameter_f(f,"lifehot")~="" then
	col_lh=Str2Color(GetSMParameter_f(f,"lifehot"));
else
	col_lh={0.0,0.68,0.93,1.0};
end;
if GetSMParameter_f(f,"lifedanger")~="" then
	col_ld=Str2Color(GetSMParameter_f(f,"lifedanger"));
else
	col_ld={0.93,0.1,0.14,1.0};
end;
if GetSMParameter_f(f,"lifebar")~="" then
	col_lb=Str2Color(GetSMParameter_f(f,"lifebar"));
else
	col_lb={0.0,0.68,0.93,1.0};
end;
CloseFile(f);

local lifegmode=GetUserPref_Theme("UserLife");

local lifeWidth=SCREEN_WIDTH/4;
--[[
if lifeWidth>=200 then
	lifeWidth=200;
end;
--]]
local lifeWidth_2=lifeWidth/2;
local haishin=GetUserPref_Theme("UserHaishin");

local frame;
frame=Def.ActorFrame{
	LoadActor("_LifeMeterBar/LifeMeterBar frame Left")..{
		OnCommand=cmd(x,-lifeWidth_2-12;diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
		OffCommand=cmd(stoptweening;diffusealpha,1;sleep,0.5;linear,0.25;diffusealpha,0);
	};
	LoadActor("_LifeMeterBar/LifeMeterBar frame Right")..{
		OnCommand=cmd(x,lifeWidth_2+12;diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
		OffCommand=cmd(stoptweening;diffusealpha,1;sleep,0.5;linear,0.25;diffusealpha,0);
	};
	LoadActor("_LifeMeterBar/LifeMeterBar frame Main")..{
		OnCommand=cmd(zoomtowidth,lifeWidth;diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
		OffCommand=cmd(stoptweening;diffusealpha,1;sleep,0.5;linear,0.25;diffusealpha,0);
	};
	LoadActor("_LifeMeterBar/LifeMeterBar light Left")..{
		Name="LIGHT_L";
		OnCommand=function(self)
			(cmd(x,-lifeWidth_2-12;diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1;blend,"BlendMode_Add";))(self);
			if haishin=="Off" then
				(cmd(diffuseramp;effectcolor1,0,0.68,0.93,0.8;effectcolor2,0,0.68,0.93,0.3;effectclock,'beat';))(self);
			else
				self:diffuse(0,0.68,0.93,0.8);
			end;
		end;
		OffCommand=cmd(stoptweening;diffusealpha,1;sleep,0.5;linear,0.25;diffusealpha,0);
	};
	LoadActor("_LifeMeterBar/LifeMeterBar light Right")..{
		Name="LIGHT_R";
		OnCommand=function(self)
			(cmd(x,lifeWidth_2+12;diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1;blend,"BlendMode_Add";))(self);
			if haishin=="Off" then
				(cmd(diffuseramp;effectcolor1,0,0.68,0.93,0.8;effectcolor2,0,0.68,0.93,0.3;effectclock,'beat';))(self);
			else
				self:diffuse(0,0.68,0.93,0.8);
			end;
		end;
		OffCommand=cmd(stoptweening;diffusealpha,1;sleep,0.5;linear,0.25;diffusealpha,0);
	};
	LoadActor("_LifeMeterBar/LifeMeterBar scrlight")..{
		Name="SCRLIGHT";
		OnCommand=cmd(stoptweening;zoomtowidth,lifeWidth*2;diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
	};
	Def.Quad{
		Name="LIFE";
		InitCommand=cmd(zoomto,lifeWidth-2,18;horizalign,left;x,-lifeWidth/2+1;blend,"BlendMode_Add";diffusetopedge,0,0.15,0.3,0.5;);
		OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
		OffCommand=function(self)
			if SCREENMAN:GetTopScreen():GetLifeMeter(PLAYER_1):GetLife()<=0 then
				(cmd(stoptweening;linear,0.25;zoomx,0))(self);
			else
				(cmd(stoptweening;diffusealpha,1;sleep,0.5;linear,0.25;diffusealpha,0))(self);
			end;
		end;
	};
	Def.Quad{
		Name="LIFELIGHT";
		InitCommand=cmd(zoomto,lifeWidth-2,8;horizalign,left;x,-lifeWidth/2+1;y,-3;diffuse,0.8,0.8,0.8,0.5;blend,"BlendMode_Add";diffusebottomedge,0.2,0.2,0.2,0;);
		OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
		OffCommand=function(self)
			if SCREENMAN:GetTopScreen():GetLifeMeter(PLAYER_1):GetLife()<=0 then
				(cmd(stoptweening;linear,0.25;zoomx,0))(self);
			else
				(cmd(stoptweening;diffusealpha,1;sleep,0.5;linear,0.25;diffusealpha,0))(self);
			end;
		end;
	};
	Def.Quad{
		Name="LIFESHADOW";
		InitCommand=cmd(visible,(lifegmode~="Beta");zoomto,lifeWidth-2,18;horizalign,left;x,-lifeWidth/2+1;diffuse,0,0,0,0;diffuseleftedge,0.0,0.0,0.0,0.3;);
		OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffuseleftedge,0.0,0.0,0.0,0.3;);
		OffCommand=function(self)
			if SCREENMAN:GetTopScreen():GetLifeMeter(PLAYER_1):GetLife()<=0 then
				(cmd(stoptweening;linear,0.25;zoomx,0))(self);
			else
				(cmd(stoptweening;sleep,0.5;linear,0.25;diffusealpha,0))(self);
			end;
		end;
	};
	LoadActor("_LifeMeterBar/LifeMeterBar into")..{
		Name="BETALIFE";
		InitCommand=cmd(visible,(lifegmode=="Beta"););
		OnCommand=cmd(stoptweening;zoomtowidth,lifeWidth*2;diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1;animate,false;setstate,0);
		OffCommand=function(self)
			if SCREENMAN:GetTopScreen():GetLifeMeter(PLAYER_1):GetLife()<=0 then
				(cmd(stoptweening;linear,0.25;zoomx,0))(self);
			else
				(cmd(stoptweening;sleep,0.5;linear,0.25;diffusealpha,0))(self);
			end;
		end;
	};
};


local function update(self)
	local fps=DISPLAY:GetFPS();
	if fps<=0 then fps=60 end;
	local lifestate;
	glm=SCREENMAN:GetTopScreen():GetLifeMeter(PLAYER_1);
	if GAMESTATE:GetPlayMode()=='PlayMode_Rave' then
		life=1.0;
		lifestate=-1;
	else
		life=glm:GetLife();
		if lifelives>0 then
			if glm:IsInDanger() or (glm:GetLivesLeft()==1) then
				lifestate=2;
			elseif life>=1.0 or (glm:GetLivesLeft()==glm:GetTotalLives()) then
				lifestate=1;
			else
				lifestate=0;
			end;
		else
			if glm:IsInDanger() then
				lifestate=2;
			elseif life>=1.0 then
				lifestate=1;
			else
				lifestate=0;
			end;
		end;
	end;
	local msec = _MUSICSECOND();
	local msec1 = msec*100%360;
	local beat = GetPlayerSongBeat2(PLAYER_1,msec);
		if haishin=="On" then
			beat=0.0001;
		end;
	local beat1 = 0.1*(beat*10%10);
	local beat2 = 0.1*(beat*10%20);
	local intosize=lifeWidth*life_d;
	local nlight_l = self:GetChild("LIGHT_L");
	local nlight_r = self:GetChild("LIGHT_R");
	local nscrlight = self:GetChild("SCRLIGHT");
	local nlife = self:GetChild("LIFE");
	local nlifel = self:GetChild("LIFELIGHT");
	local nlifes = self:GetChild("LIFESHADOW");
	local nbetalife = self:GetChild("BETALIFE");

	nscrlight:cropleft(0.5-(beat2/4));
	nscrlight:cropright(beat2/4);
	nscrlight:x((beat2/4)*(lifeWidth*2)-lifeWidth_2);
	nscrlight:blend("BlendMode_Add");
	nbetalife:zoomtowidth(intosize*2);
	nbetalife:cropright(0.5-(beat2/4));
	nbetalife:cropleft(beat2/4);
	nbetalife:x(-lifeWidth_2+intosize-(beat2/2)*intosize);
	nlifes:zoomtowidth(intosize);
	if lifestate==1 then
	-- Hot
		nlight_l:diffuse(col_lh[1],col_lh[2],col_lh[3],0.8*col_lh[4]);
		nlight_l:effectcolor1(col_lh[1],col_lh[2],col_lh[3],0.8*col_lh[4]);
		nlight_l:effectcolor2(col_lh[1],col_lh[2],col_lh[3],0.3*col_lh[4]);
		nlight_r:diffuse(col_lh[1],col_lh[2],col_lh[3],0.8*col_lh[4]);
		nlight_r:effectcolor1(col_lh[1],col_lh[2],col_lh[3],0.8*col_lh[4]);
		nlight_r:effectcolor2(col_lh[1],col_lh[2],col_lh[3],0.3*col_lh[4]);
		nscrlight:diffuse(ColorLightTone(HSV( msec1,1.0,1.0 )));
		nlife:diffuse(HSV( (msec1+350)%360,1.0,1.0-(beat1/2) ));
		nbetalife:setstate(1);
	elseif lifestate==2 then
	-- Danger
		nlight_l:diffuse(col_ld[1],col_ld[2],col_ld[3],0.8*col_ld[4]);
		nlight_l:effectcolor1(col_ld[1],col_ld[2],col_ld[3],0.8*col_ld[4]);
		nlight_l:effectcolor2(col_ld[1],col_ld[2],col_ld[3],0.3*col_ld[4]);
		nlight_r:diffuse(col_ld[1],col_ld[2],col_ld[3],0.8*col_ld[4]);
		nlight_r:effectcolor1(col_ld[1],col_ld[2],col_ld[3],0.8*col_ld[4]);
		nlight_r:effectcolor2(col_ld[1],col_ld[2],col_ld[3],0.3*col_ld[4]);
		nscrlight:diffuse(Color("Red"));
		nlife:diffuse(Color("Red"));
		nbetalife:setstate(0);
	elseif lifestate==-1 then
	-- Rave
		nlight_l:diffuse(col_lh[1],col_lh[2],col_lh[3],0.8*col_lh[4]);
		nlight_l:effectcolor1(col_lh[1],col_lh[2],col_lh[3],0.8*col_lh[4]);
		nlight_l:effectcolor2(col_lh[1],col_lh[2],col_lh[3],0.3*col_lh[4]);
		nlight_r:diffuse(col_lh[1],col_lh[2],col_lh[3],0.8*col_lh[4]);
		nlight_r:effectcolor1(col_lh[1],col_lh[2],col_lh[3],0.8*col_lh[4]);
		nlight_r:effectcolor2(col_lh[1],col_lh[2],col_lh[3],0.3*col_lh[4]);
		nscrlight:diffuse(ColorLightTone(HSV( msec1,1.0,1.0 )));
		nlife:diffuse(Color("Blue"));
		nbetalife:setstate(0);
	else
	-- Normal
		nlight_l:diffuse(col_ln[1],col_ln[2],col_ln[3],0.8*col_ln[4]);
		nlight_l:effectcolor1(col_ln[1],col_ln[2],col_ln[3],0.8*col_ln[4]);
		nlight_l:effectcolor2(col_ln[1],col_ln[2],col_ln[3],0.3*col_ln[4]);
		nlight_r:diffuse(col_ln[1],col_ln[2],col_ln[3],0.8*col_ln[4]);
		nlight_r:effectcolor1(col_ln[1],col_ln[2],col_ln[3],0.8*col_ln[4]);
		nlight_r:effectcolor2(col_ln[1],col_ln[2],col_ln[3],0.3*col_ln[4]);
		nscrlight:diffuse(col_lb[1],col_lb[2],col_lb[3],col_lb[4]);
		nlife:diffuse(col_lb[1],col_lb[2],col_lb[3],col_lb[4]);
		nbetalife:setstate(0);
	end;
	nlife:diffusetopedge(0,0.15,0.3,0.5);
	if beat>0 then
		if math.abs(life_d-life)<0.005 then
			life_d=life;
		elseif life_d<life then
			life_d=life_d+math.max((life-life_d)/(fps),0.3/fps);
		else
			if lifelives>0 then
				life_d=life;
			else
				life_d=life_d-math.max((life_d-life)/(fps/3),0.2/fps);
			end;
		end;
	end;
	nlife:cropright(1.0-life_d);
	nlifel:cropright(1.0-life_d);
	if lifestate==1 then
		nlifes:diffuseleftedge(0,0,0,0.2);
	else
		nlifes:diffuseleftedge(0,0,0,0.3);
	end;
end;

local function notupdate(self)
	local nscrlight = self:GetChild("SCRLIGHT");
	local msec = _MUSICSECOND();
	local beat = GetPlayerSongBeat2(PLAYER_1,msec);
	local last = song:GetLastSecond();
		if haishin=="On" then
			beat=0.0001;
		end;
	local beat1 = 0.1*(beat*10%10);
	local beat2 = 0.1*(beat*10%20);
	nscrlight:cropleft(0.5-(beat2/4));
	nscrlight:cropright(beat2/4);
	nscrlight:x((beat2/4)*(lifeWidth*2)-lifeWidth_2);
	if msec-last>=0.75 then
		nscrlight:diffusealpha(0);
	elseif msec-last>=0.5 then
		nscrlight:diffusealpha(1-((msec-last)-0.5)*2);
	end;
	local fps=DISPLAY:GetFPS();
	if fps<=0 then fps=60 end;
	if beat>0 then
		if math.abs(life_d-life)<0.005 then
			life_d=life;
		elseif life_d<life then
			life_d=life_d+math.max((life-life_d)/(fps),0.3/fps);
		else
			if lifelives>0 then
				life_d=life;
			else
				life_d=life_d-math.max((life_d-life)/(fps/2),0.5/fps);
			end;
		end;
	end;
	local nlife = self:GetChild("LIFE");
	local nlifel = self:GetChild("LIFELIGHT");
	nlife:cropright(1.0-life_d);
	nlifel:cropright(1.0-life_d);
end;

frame.InitCommand=cmd(SetUpdateFunction,update;);
frame.OffCommand=cmd(stoptweening;SetUpdateFunction,notupdate;);

t[#t+1]=frame;

if lifelives>1 and lifelives<=10 then
	for i=1,lifelives-1 do
		t[#t+1]=Def.ActorFrame{
			LoadActor("_LifeMeterBar/LifeMeterBar frame Border")..{
				InitCommand=function(self)
					(cmd(horizalign,left;))(self);
					self:x(-lifeWidth/2+lifeWidth*i/lifelives-2);
				end;
				OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
				OffCommand=cmd(stoptweening;diffusealpha,1;sleep,0.5;linear,0.25;diffusealpha,0);
			};
		};
	end;
end;

return t;
