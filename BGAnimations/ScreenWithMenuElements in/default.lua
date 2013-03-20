local fSleepTime = THEME:GetMetric( Var "LoadingScreen","ScreenInDelay");

return Def.ActorFrame{
	Def.Quad{
		OnCommand=cmd(visible,0;sleep,fSleepTime);
	};
	Def.Quad{
		InitCommand=cmd(Center;zoomtowidth,SCREEN_WIDTH+2;diffuse,color("#2080FF");blend,'BlendMode_Add';);
		OnCommand=cmd(diffusealpha,1;zoomtoheight,0;linear,0.3;diffusealpha,0;zoomtoheight,SCREEN_HEIGHT+2;);
	};
};
