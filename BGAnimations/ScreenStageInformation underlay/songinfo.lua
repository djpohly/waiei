function GetSongBanner(song)
	if song then
		local path = song:GetBannerPath()
		if path then return path end
	end
	return THEME:GetPathG("Common","fallback banner")
end

local t=Def.ActorFrame{};
local song = _SONG();
local jacketmode=0;
local course=GAMESTATE:GetCurrentCourse();
local steps={};
if song then
	-- [ja] こっそりBGA to Lua 
	BGAtoLUA(song);
	-- [ja] こっそりコンフィグ設定登録
	SetwaieiInfo("BGScale",GetUserPref_Theme("UserBGScale"));
	SetwaieiInfo("Haishin",GetUserPref_Theme("UserHaishin"));
	-- [ja] こっそりSM5非対応命令保存 
	local var;
	var=GetSMParameter(song,"menucolor");
	if var~="" then
		SetExtendedParameter(song,"menucolor",var);
	end;
	var=GetSMParameter(song,"metertype");
	if var~="" and var~="DDR" then	-- [ja] DDRはデフォルトなので保存する必要ない 
		SetExtendedParameter(song,"metertype",var);
	end;
	var=GetSMParameter(song,"bgaspectratio");
	if var~="" then 
		SetExtendedParameter(song,"BGAspectRatio",var);
	end;
	SetwaieiInfo("BGRatio",var);
	t[#t+1]=EXF_ScreenStageInformation();

end;

t[#t+1]=Def.ActorFrame{
	Def.Actor{
		InitCommand=function(self)
			steps={GAMESTATE:GetCurrentSteps(GetSidePlayer(PLAYER_1)),GAMESTATE:GetCurrentSteps(GetSidePlayer(PLAYER_2))};
			if (not song) and course then
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber())
				local e = trail:GetTrailEntries()
				if #e > 0 then
					song = e[1]:GetSong()
					steps={e[1]:GetSteps(),e[1]:GetSteps()};
				end;
			end;
		end;
	};
	LoadActor(THEME:GetPathG("_Ready","Background")) .. {
		Name="BG";
		InitCommand=cmd(diffusealpha,0;zoom,2;Center;linear,0.25;diffusealpha,1;zoomy,1.5;zoomtowidth,SCREEN_WIDTH;sleep,1.5;linear,0.25;zoomy,1;sleep,0.5);
	};
	LoadActor(THEME:GetPathG("_Ready","Light L")) .. {
		Name="RLIGHTL";
		InitCommand=cmd(zoomtowidth,SCREEN_WIDTH;Center;
			diffuse,_DifficultyCOLOR(steps[1]:GetDifficulty());
			blend,'BlendMode_Add';);
		OnCommand=cmd(addx,640;diffusealpha,0;
			sleep,0.5;linear,1.45;addx,-640;diffusealpha,0.8;sleep,0.05;diffusealpha,1;sleep,0.5);
	};
	LoadActor(THEME:GetPathG("_Ready","Light R")) .. {
		Name="RLIGHTR";
		InitCommand=cmd(zoomtowidth,SCREEN_WIDTH;Center;
			diffuse,_DifficultyCOLOR(steps[2]:GetDifficulty());
			blend,'BlendMode_Add';);
		OnCommand=cmd(addx,-640;diffusealpha,0;
			sleep,0.5;linear,1.45;addx,640;diffusealpha,0.8;sleep,0.05;diffusealpha,1;sleep,0.5);
	};
	Def.Quad{
		Name="PICTG";
		InitCommand=function(self)
			self:LoadBackground(GetSongBanner(song));
			jacketmode=0;
			self:rate(1.0);
			self:scaletofit(0,0,192,60);
			self:y(SCREEN_CENTER_Y);
			self:x(SCREEN_CENTER_X-210);
			self:diffusealpha(0);
			self:addx(-30);
			self:sleep(1.8);
			self:linear(0.2);
			self:addx(30);
			self:diffusealpha(1);
			self:sleep(0.5);
		end;
		--InitCommand=cmd(zoomtowidth,SCREEN_WIDTH;Center;diffuse,Color("Blue");blend,'BlendMode_Add';);
--		OnCommand=cmd(diffusealpha,1;sleep,2.5;linear,0.5;diffusealpha,0;x,SCREEN_WIDTH;);
--		OnCommand=cmd(diffusealpha,1;sleep,2.5;cropright,0;diffuseleftedge,1,1,1,1;linear,0.5;diffusealpha,0;x,SCREEN_WIDTH;cropright,1;diffuseleftedge,1,1,1,0;);
	};
	Def.Quad{
		Name="PICTF";
		InitCommand=function(self)
		--[[
			if jacketmode==1 then
				self:LoadBackground(THEME:GetPathG("_Frame","Jacket"));
				self:scaletofit(0,0,200,200);
				self:y(SCREEN_CENTER_Y-40);
			else
		--]]
			self:LoadBackground(THEME:GetPathG("_Frame","Banner"));
			self:scaletofit(0,0,200,200);
			self:y(SCREEN_CENTER_Y);
			self:x(SCREEN_CENTER_X-210);
			self:diffusealpha(0);
			self:addx(-30);
			self:sleep(1.8);
			self:linear(0.2);
			self:addx(30);
			self:diffusealpha(1);
			self:sleep(0.5);
		end;
		--InitCommand=cmd(zoomtowidth,SCREEN_WIDTH;Center;diffuse,Color("Blue");blend,'BlendMode_Add';);
--		OnCommand=cmd(diffusealpha,1;sleep,2.5;linear,0.5;diffusealpha,0;x,SCREEN_WIDTH;);
--		OnCommand=cmd(diffusealpha,1;sleep,2.5;cropright,0;diffuseleftedge,1,1,1,1;linear,0.5;diffusealpha,0;x,SCREEN_WIDTH;cropright,1;diffuseleftedge,1,1,1,0;);
	};
	LoadFont("Common normal") .. {
		Name="STITLE";
		InitCommand=function(self)
			self:horizalign(left);
			self:x(SCREEN_CENTER_X-102);
			self:y(SCREEN_CENTER_Y-14);
			self:maxwidth(410/1.2);
			self:zoom(1.2);
			self:settextf("%s",song:GetDisplayFullTitle());
			self:strokecolor(Color("Outline"));
			self:diffusealpha(0);
			self:addx(-90);
			self:sleep(1.8);
			self:linear(0.2);
			self:addx(90);
			self:diffusealpha(1);
			self:sleep(0.5);
		end;
	};
	LoadFont("Common normal") .. {
		Name="SARTIST";
		InitCommand=function(self)
			self:horizalign(left);
			self:x(SCREEN_CENTER_X-100);
			self:y(SCREEN_CENTER_Y+16);
			self:maxwidth(410);
			self:settextf("%s",song:GetDisplayArtist());
			self:strokecolor(Color("Outline"));
			self:diffusealpha(0);
			self:addx(-90);
			self:sleep(1.8);
			self:linear(0.2);
			self:addx(90);
			self:diffusealpha(1);
			self:sleep(0.5);
		end;
	};
};

return t;
