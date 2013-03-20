local light_func;

local song = _SONG();
local eff_st;
if song then
	eff_st = song:GetSampleStart();
end;
local now = 0.0;
local lifeWidth=SCREEN_WIDTH/4;

local lighteff=GetUserPref_Theme("UserLightEffect");
local haishin=GetUserPref_Theme("UserHaishin");

light_func=Def.ActorFrame{
	LoadActor(THEME:GetPathG("_LifeMeterBar/LifeMeterBar","Effect"))..{
		Name="BIG_TL";
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X-lifeWidth-lifeWidth/4-SCREEN_WIDTH/16+40;y,SCREEN_TOP-10;);
		OnCommand=cmd(diffusealpha,0;addy,-100;sleep,0.5;linear,0.25;addy,100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addy,-100;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("_LifeMeterBar/LifeMeterBar","Effect"))..{
		Name="BIG_TR";
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X+lifeWidth+lifeWidth/4+SCREEN_WIDTH/16-40;y,SCREEN_TOP-10;rotationy,180);
		OnCommand=cmd(diffusealpha,0;addy,-100;sleep,0.5;linear,0.25;addy,100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addy,-100;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("_LifeMeterBar/LifeMeterBar","Effect"))..{
		Name="BIG_BL";
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X-lifeWidth-lifeWidth/4-SCREEN_WIDTH/16+40;y,SCREEN_BOTTOM+10;rotationx,180;);
		OnCommand=cmd(diffusealpha,0;addy,100;sleep,0.5;linear,0.25;addy,-100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addy,100;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("_LifeMeterBar/LifeMeterBar","Effect"))..{
		Name="BIG_BR";
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X+lifeWidth+lifeWidth/4+SCREEN_WIDTH/16-40;y,SCREEN_BOTTOM+10;rotationx,180;rotationy,180);
		OnCommand=cmd(diffusealpha,0;addy,100;sleep,0.5;linear,0.25;addy,-100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addy,100;diffusealpha,0);
	};
};

local player_l=GetSidePlayer(PLAYER_1);
local player_r=GetSidePlayer(PLAYER_2);

local function update(self)
	if (not song) or (song ~= _SONG()) then
		song = _SONG();
		if song then
			start = song:GetFirstBeat();
		end;
	end;
	if song then
		local msec = _MUSICSECOND();
		now_l = GetPlayerSongBeat2(player_l,msec);
		local beat_l = 0.1*(now_l*10%10);
		now_r = GetPlayerSongBeat2(player_r,msec);
		local beat_r = 0.1*(now_r*10%10);
		if haishin=="On" then
			beat_l=0.0001;
			beat_r=0.0001;
		end;
		local sample = song:GetSampleStart();
		local sample_l=math.round(GetPlayerSongBeat2(player_l,sample));
		local sample_r=math.round(GetPlayerSongBeat2(player_r,sample));
		local msec1 = msec*100%360;
		local c_btl = self:GetChild("BIG_TL");
		local c_btr = self:GetChild("BIG_TR");
		local c_bbl = self:GetChild("BIG_BL");
		local c_bbr = self:GetChild("BIG_BR");
		c_btl:blend("BlendMode_Add");
		c_btr:blend("BlendMode_Add");
		c_bbl:blend("BlendMode_Add");
		c_bbr:blend("BlendMode_Add");
		if (now_l>=sample_l and (lighteff=='Auto')) or (lighteff=='Always') then
			c_btl:diffusealpha(1-beat_l);
			c_bbl:diffusealpha(1-beat_l);
		else
			c_btl:diffusealpha(0);
			c_bbl:diffusealpha(0);
		end;
		if (now_r>=sample_r and (lighteff=='Auto')) or (lighteff=='Always') then
			c_btr:diffusealpha(1-beat_r);
			c_bbr:diffusealpha(1-beat_r);
		else
			c_btr:diffusealpha(0);
			c_bbr:diffusealpha(0);
		end;
	end;
end;

light_func.InitCommand=cmd(SetUpdateFunction,update;);

return light_func;
