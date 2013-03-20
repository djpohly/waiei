local size=THEME:GetMetric("SongMeterDisplay","StreamWidth")-14;
local song = nil;
local maxbeat=1;
local nowbeat=0;
local firstsec=0;
local maxsec=1;
local nowsec=0;
local t;
t=Def.ActorFrame{
	LoadActor("SongMeterDisplay Points")..{
		Name="_SEC_";
		InitCommand=cmd(animate,false;setstate,0;diffusealpha,0;zoom,2;blend,"BlendMode_Add";x,-size/2);
		OnCommand=function(self)
			(cmd(diffusealpha,0;sleep,1;bounceend,0.5;zoom,1;diffusealpha,1))(self);
		end;
	};
	LoadActor("SongMeterDisplay Points")..{
		Name="_BEAT_";
		InitCommand=cmd(animate,false;setstate,1;diffusealpha,0;zoom,2;blend,"BlendMode_Add";x,-size/2);
		OnCommand=function(self)
			(cmd(diffusealpha,0;sleep,1;bounceend,0.5;zoom,1;diffusealpha,1))(self);
		end;
	};
	--[[
	LoadFont("Common Normal")..{
		Name="_DEBUG_";
		InitCommand=cmd(diffuse,Color("White");socketcolor,Color("Blank"));
		OnCommand=function(self)
			(cmd(diffusealpha,0;sleep,1;bounceend,0.5;zoom,1;diffusealpha,1;settext,"DEBUG"))(self);
		end;
	};
	--]]
};
local function update(self)
	if (not song) or (song ~= GAMESTATE:GetCurrentSong()) then
		song = GAMESTATE:GetCurrentSong();
		firstsec=song:GetFirstSecond();
		maxsec=math.max(1,song:GetLastSecond()-firstsec);
		maxbeat=math.max(1,Sec2PlayerBeat(PLAYER_2,song:GetLastSecond()));
	end;
	if not song then
		return;
	end;
	local beat = self:GetChild("_BEAT_");
	local sec = self:GetChild("_SEC_");
	local musicsec=_MUSICSECOND()
	nowsec=math.min(math.max(0,musicsec-firstsec),maxsec);
	nowbeat=math.min(math.max(0,GetPlayerSongBeat2(PLAYER_2,musicsec)),maxbeat);
	beat:x(-size/2+size*nowbeat/maxbeat);
	sec:x(-size/2+size*nowsec/maxsec);
--	local dbg = self:GetChild("_DEBUG_");
--	dbg:settextf("%f",nowbeat);
end;
t.InitCommand=cmd(SetUpdateFunction,update;);
return t;