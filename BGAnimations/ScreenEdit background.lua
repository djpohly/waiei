local t = Def.ActorFrame {
   InitCommand=cmd(fov,90);
};
t[#t+1] = Def.ActorFrame {
  InitCommand=cmd(Center);
	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT);
		OnCommand=cmd(diffuse,color("#000000"));
	};
	LoadActor( THEME:GetPathB("ScreenWithMenuElements","background/_bg top") ) .. {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT);
	};
	Def.Quad{
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,color("0.2,0.2,0.2,0"));
		OnCommand=function(self)
			local topScreen = SCREENMAN:GetTopScreen()
			if topScreen then
				local screenName = topScreen:GetName()
				if screenName == "ScreenEdit" or screenName == "ScreenPractice" then
					self:diffusealpha(0.325)
				else
					self:diffusealpha(0)
				end;
			end;
		end;
		EditorShowMessageCommand=cmd(stoptweening;linear,0.5;diffusealpha,0.75);
		EditorHideMessageCommand=cmd(stoptweening;linear,0.5;diffusealpha,0.325);
	};
};

return t;
