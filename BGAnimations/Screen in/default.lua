--local fSleepTime = THEME:GetMetric( Var "LoadingScreen","ScreenInDelay");
return Def.ActorFrame {
	OnCommand=cmd(sleep,0.15);
	Def.Quad {
		InitCommand=cmd(Center;zoomto,SCREEN_WIDTH+1,SCREEN_HEIGHT);
		OnCommand=cmd(diffuse,color("0,0,0,1");linear,0.15;diffusealpha,0);
	};
};