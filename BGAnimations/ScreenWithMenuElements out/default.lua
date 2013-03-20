local fSleepTime = THEME:GetMetric( Var "LoadingScreen","ScreenOutDelay");

return Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(diffuse,Color("Black");zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;Center);
		OnCommand=cmd(diffusealpha,0;sleep,fSleepTime;linear,0.1;diffusealpha,0);
	};
};
