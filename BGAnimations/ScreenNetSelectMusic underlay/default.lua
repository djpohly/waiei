local haishin=GetUserPref_Theme("UserHaishin");
local circle=((haishin=="Off") and "Circle2" or "Circle1");

return Def.ActorFrame {
  FOV=60;
	--[[
	-- [ja] 選択中曲の背景を表示 
	-- [ja] 個人的にあまり好きじゃないのでコメント化 
	Def.Sprite{
		InitCommand=cmd(Center;diffusealpha,0);
		SetCommand=function(self)
			self:finishtweening();
			self:diffusealpha(0);
			self:sleep(0.3);
			self:queuecommand("Load");
		end;
		LoadCommand=function(self)
			local song=_SONG();
			if song then
				self:LoadBackground(GetSongBGPath(song));
				self:diffusealpha(0);
				self:scaletocover(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
				self:linear(0.2);
				self:diffusealpha(1);
				self:fadeleft(1.0);
				self:faderight(1.0);
				self:blend("BlendMode_Add");
			else
				self:diffusealpha(0);
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		BeginCommand=cmd(queuecommand,"Set");
		OnCommand=cmd(queuecommand,"Set");
	};
	--]]
	LoadActor(THEME:GetPathG("information/Information",""..circle)) .. {
		InitCommand=cmd(y,SCREEN_CENTER_Y-50;rotationx,-45;
		diffuse,ColorLightTone(color("#0064FF"));spin;effectmagnitude,0,20,0;);
		OnCommand=cmd(x,SCREEN_RIGHT;zoom,0;decelerate,1.0;x,SCREEN_CENTER_X-220;zoom,SCREEN_HEIGHT/600;)
	};
};
