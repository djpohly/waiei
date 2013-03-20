local t = Def.ActorFrame{};
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(Center);
	Def.Quad {
		InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;
			diffuse,color("1,1,1,1");diffusebottomedge,color("0.8,0.9,1.0,1"));
	};
	LoadActor("waiei")..{
		InitCommand=cmd(x,-50;diffusealpha,0;);
		OnCommand=cmd(linear,0.3;x,0;diffusealpha,1;
			sleep,2;linear,0.3;x,50;diffusealpha,0;);
	};
	LoadActor("../../../_fallback/BGAnimations/ScreenInit background/ssc")..{
		InitCommand=cmd(x,-50;diffusealpha,0;);
		OnCommand=cmd(sleep,2.3;linear,0.3;diffusealpha,1;x,0;
			sleep,2;linear,0.3;x,50;diffusealpha,0;);
	};
	LoadActor("caution")..{
		InitCommand=cmd(x,-50;diffusealpha,0;);
		OnCommand=cmd(sleep,5.6;linear,0.3;diffusealpha,1;x,0;);
	};
};
t[#t+1] = LoadActor( THEME:GetPathB("_Arcade","decorations") );
return t