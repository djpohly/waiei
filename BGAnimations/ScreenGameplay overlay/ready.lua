function GetSongBanner(song)
	if song then
		local path = song:GetBannerPath()
		if path then return path end
	end
	return THEME:GetPathG("Common","fallback banner")
end

local ready_func;
local song;
local start=0.0;
local jacketmode=0;
local now = 0.0;

ready_func=Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(visible,false);
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			song = GAMESTATE:GetCurrentSong();
			if song then
				start = song:GetFirstBeat();
			end;
		end;
	};
	LoadActor(THEME:GetPathG("_Ready","Background")) .. {
		Name="BG";
		InitCommand=cmd(Center;);
	};
	LoadActor(THEME:GetPathG("_Ready","Light L")) .. {
		Name="RLIGHTL";
		InitCommand=cmd(playcommand,"Set");
		SetCommand=cmd(finishtweening;zoomtowidth,SCREEN_WIDTH;Center;
			diffuse,_DifficultyCOLOR(GAMESTATE:GetCurrentSteps(GetSidePlayer(PLAYER_1)):GetDifficulty());
			blend,'BlendMode_Add';playcommand,"On";);
		OnCommand=cmd(linear,2.0;diffusealpha,0);
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
	};
	LoadActor(THEME:GetPathG("_Ready","Light R")) .. {
		Name="RLIGHTR";
		InitCommand=cmd(playcommand,"Set");
		SetCommand=cmd(finishtweening;zoomtowidth,SCREEN_WIDTH;Center;
			diffuse,_DifficultyCOLOR(GAMESTATE:GetCurrentSteps(GetSidePlayer(PLAYER_2)):GetDifficulty());
			blend,'BlendMode_Add';playcommand,"On";);
		OnCommand=cmd(linear,2.0;diffusealpha,0);
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
	};
	Def.Quad{
		Name="PICTG";
		InitCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			song=_SONG();
			self:LoadBackground(GetSongBanner(song));
			jacketmode=0;
			self:scaletofit(0,0,192,60);
			self:y(SCREEN_CENTER_Y);
			self:x(SCREEN_CENTER_X-210);
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
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
		--	end;
		--	self:fov(60);
		--	self:rotationx(10);
		--	self:rotationy(45);
			self:x(SCREEN_CENTER_X-210);
		end;
		--InitCommand=cmd(zoomtowidth,SCREEN_WIDTH;Center;diffuse,Color("Blue");blend,'BlendMode_Add';);
--		OnCommand=cmd(diffusealpha,1;sleep,2.5;linear,0.5;diffusealpha,0;x,SCREEN_WIDTH;);
--		OnCommand=cmd(diffusealpha,1;sleep,2.5;cropright,0;diffuseleftedge,1,1,1,1;linear,0.5;diffusealpha,0;x,SCREEN_WIDTH;cropright,1;diffuseleftedge,1,1,1,0;);
	};
	LoadActor(THEME:GetPathG("_Ready","Text Ready")) .. {
		Name="READY";
	--	InitCommand=cmd(Center;diffuse,Color("Blue");blend,'BlendMode_Add';);
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-2;);
	};
	LoadActor(THEME:GetPathG("_Ready","Text Go")) .. {
		Name="GO";
	--	InitCommand=cmd(Center;diffuse,Color("Blue");blend,'BlendMode_Add';);
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-2;);
	};
	LoadFont("Common normal") .. {
		Name="STITLE";
		InitCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			song=_SONG();
			self:horizalign(left);
			self:x(SCREEN_CENTER_X-102);
			self:y(SCREEN_CENTER_Y-14);
			self:maxwidth(410/1.2);
			self:zoom(1.2);
			self:settextf("%s",song:GetDisplayFullTitle());
			self:strokecolor(Color("Outline"));
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
	};
	LoadFont("Common normal") .. {
		Name="SARTIST";
		InitCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			song=_SONG();
			self:horizalign(left);
			self:x(SCREEN_CENTER_X-100);
			self:y(SCREEN_CENTER_Y+16);
			self:maxwidth(410);
			self:settextf("%s",song:GetDisplayArtist());
			self:strokecolor(Color("Outline"));
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
	};
};

local function update(self)
	if (not song) or (song ~= GAMESTATE:GetCurrentSong()) then
		song = GAMESTATE:GetCurrentSong();
		if song then
			start = song:GetFirstBeat();
		end;
	end;
	if song then
		now = GAMESTATE:GetSongBeat();
		if now<start then
			local bg = self:GetChild("BG");
			local ready = self:GetChild("READY");
			local go = self:GetChild("GO");
			local grp = self:GetChild("PICTG");
			local frm = self:GetChild("PICTF");
			local tit = self:GetChild("STITLE");
			local art = self:GetChild("SARTIST");
			now_s = GAMESTATE:GetSongPosition():GetMusicSeconds()*100%360;
			now_p = now_s%30;
			local beat=(10*now)%40;
			if (now < start-4.5) then
				bg:diffusealpha(1);
				bg:zoomtowidth(SCREEN_WIDTH);
				bg:zoomy(1);
			end;
			if (now < start-13.5) then
				tit:diffusealpha(1);
			--	tit:zoomx(1.2);
			--	tit:zoomy(1.2);
				art:diffusealpha(1);
			--	art:zoomx(1);
			--	art:zoomy(1);
				grp:diffusealpha(1);
				frm:diffusealpha(1);
			elseif (now >= start-13.5) and (now < start-12.0) then
				local tmp = 1.0-((now-(start-13.5))*2);
				tit:diffusealpha(tmp);
			--	tit:zoomx((2.0-tmp)*1.2);
			--	tit:zoomy(tmp*1.2);
				art:diffusealpha(tmp);
			--	art:zoomx(2.0-tmp);
			--	art:zoomy(tmp);
				grp:diffusealpha(tmp);
				frm:diffusealpha(tmp);
			else
				tit:diffusealpha(0);
			--	tit:zoomx(0);
			--	tit:zoomy(0);
				art:diffusealpha(0);
			--	art:zoomx(0);
			--	art:zoomy(0);
				grp:diffusealpha(0);
				frm:diffusealpha(0);
			end;
			if (now >= start-12.0) and (now < start-11.5) then
				go:diffusealpha(0);
				local tmp = (now-(start-12.0))*2;
				ready:diffusealpha(tmp);
				ready:zoomx(2.0-tmp);
				ready:zoomy(tmp);
			elseif (now >= start-11.5) and (now < start-8.5) then
				go:diffusealpha(0);
				ready:diffusealpha(1);
				ready:zoomx(1);
				ready:zoomy(1);
			elseif (now >= start-8.5) and (now < start-8.0) then
				go:diffusealpha(0);
				local tmp = 1.0-((now-(start-8.5))*2);
				ready:diffusealpha(tmp);
				ready:zoomx(2.0-tmp);
				ready:zoomy(tmp);
			elseif (now >= start-8.0) and (now < start-7.5) then
				ready:diffusealpha(0);
				local tmp = (now-(start-8.0))*2;
				go:diffusealpha(tmp);
				go:zoomx(2.0-tmp);
				go:zoomy(tmp);
			elseif (now >= start-7.5) and (now < start-4.5) then
				ready:diffusealpha(0);
				go:diffusealpha(1);
				go:zoomx(1);
				go:zoomy(1);
			elseif (now >= start-4.5) and (now < start-4.0) then
				ready:diffusealpha(0);
				local tmp = 1.0-((now-(start-4.5))*2);
				go:diffusealpha(tmp);
				go:zoomx(2.0-tmp);
				go:zoomy(tmp);
				bg:diffusealpha(tmp);
				bg:zoomy(tmp);
			else
				if (now >= start-4.0) then
					bg:diffusealpha(0);
					bg:zoomto(0,0);
				end;
				ready:diffusealpha(0);
				ready:zoomto(0,0);
				go:diffusealpha(0);
				go:zoomto(0,0);
				
			end;
		end;
	end;
end;

ready_func.InitCommand=cmd(SetUpdateFunction,update;);

return ready_func;
