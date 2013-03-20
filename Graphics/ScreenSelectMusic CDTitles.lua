return Def.Sprite {
	InitCommand=function(self)
		if _SONG() and _SONG():HasCDTitle() then
			self:LoadBackground(_SONG():GetCDTitlePath());
			self:zoom(0.75);
			local w=self:GetWidth()*0.75;
			local h=self:GetHeight()*0.75;
			local s=((w>h) and w or h);
			if s>186 then
				self:scaletofit(0,0,186,186);
			end;
			(cmd(horizalign,left;vertalign,top;draworder,0))(self);
			self:x(SCREEN_CENTER_X-93);
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-139);
			self:visible(true);
		else
			self:zoom(0);
			self:visible(false);
		end;
	end;
	OnCommand=cmd(playcommand,"Init");
	OffCommand=cmd(bouncebegin,0.15;zoomx,0);
	CodeMessageCommand =function(self, params)
		if params.Name=="ExFolder" and ISChallEXFolder() then
			self:playcommand("Off");
		end;
	end;
	CurrentSongChangedMessageCommand=cmd(playcommand,"Init");
};