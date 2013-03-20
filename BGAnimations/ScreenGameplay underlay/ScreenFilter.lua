local t;

local filter1;
local filter2;
if GetUserPref_Theme("UserScreenFilterP1") ~= nil then
	filter1 = GetUserPref_Theme("UserScreenFilterP1");
else
	filter1 = 'Off';
end;
if GetUserPref_Theme("UserScreenFilterP2") ~= nil then
	filter2 = GetUserPref_Theme("UserScreenFilterP2");
else
	filter2 = 'Off';
end;

local song = GAMESTATE:GetCurrentSong();
local start;
local last;
if song then
	start = song:GetFirstBeat();
	last = song:GetLastBeat();
end;

local now = 0.0;
local function GetFilterSizeX(pn)
	local r=0;
	local one=THEME:GetMetric("ArrowEffects","ArrowSpacing");
	local stt=GAMESTATE:GetCurrentSteps(pn):GetStepsType();
	if stt=='StepsType_Dance_Single' then
		r=one*4;
	elseif stt=='StepsType_Dance_Double' then
		r=one*8;
	elseif stt=='StepsType_Dance_Couple' then
		r=one*4;
	elseif stt=='StepsType_Dance_Solo' then
		r=one*6;
	elseif stt=='StepsType_Dance_Threepanel' then
		r=one*3;
	else
		r=SCREEN_WIDTH;
	end;
	return r;
end;

t=Def.ActorFrame{
	Def.Quad{
		Name="FilterP1";
		InitCommand=cmd(y,SCREEN_CENTER_Y;diffuse,Color("Black"););
		OnCommand=function(self)
			self:x(GetStepZonePosX(PLAYER_1));
			self:zoomto(GetFilterSizeX(PLAYER_1)+20,SCREEN_HEIGHT);
			self:fadeleft(1/32);
			self:faderight(1/32);
			if filter1 == 'Off' then
				self:diffusealpha(0);
			elseif filter1 == '25%' then
				self:diffusealpha(0.25);
			elseif filter1 == '50%' then
				self:diffusealpha(0.5);
			elseif filter1 == '75%' then
				self:diffusealpha(0.75);
			else
				self:diffusealpha(1);
			end;
		end;
	};
	Def.Quad{
		Name="FilterP2";
		InitCommand=cmd(y,SCREEN_CENTER_Y;diffuse,Color("Black"););
		OnCommand=function(self)
			self:x(GetStepZonePosX(PLAYER_2));
			self:zoomto(GetFilterSizeX(PLAYER_2)+20,SCREEN_HEIGHT);
			self:fadeleft(1/32);
			self:faderight(1/32);
			if filter2 == 'Off' then
				self:diffusealpha(0);
			elseif filter2 == '25%' then
				self:diffusealpha(0.25);
			elseif filter2 == '50%' then
				self:diffusealpha(0.5);
			elseif filter2 == '75%' then
				self:diffusealpha(0.75);
			else
				self:diffusealpha(1);
			end;
		end;
	};
};

local function FilterUpdate(self)
	if (not song) or (song ~= GAMESTATE:GetCurrentSong()) then
		song = GAMESTATE:GetCurrentSong();
		if song then
			start = song:GetFirstBeat();
			last = song:GetLastBeat();
		end;
	end;
	if song then
		local fil1 = self:GetChild("FilterP1");
		local fil2 = self:GetChild("FilterP2");
		now = GAMESTATE:GetSongBeat();
		if (now >= start-8.0) and (now <= last) then
			if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				fil1:visible(1);
			else
				fil1:visible(0);
			end;
			if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
				fil2:visible(1);
			else
				fil2:visible(0);
			end;
		else
			fil1:visible(0);
			fil2:visible(0);
		end;
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,FilterUpdate);

return t;
