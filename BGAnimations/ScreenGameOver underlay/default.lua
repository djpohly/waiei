return Def.ActorFrame {
	InitCommand=cmd(Center);
	LoadActor(THEME:GetPathG("_Ready","Background")) .. {
		Name="BG";
		InitCommand=cmd(diffusealpha,0;zoomtowidth,SCREEN_WIDTH;zoomy,0;linear,0.5;diffusealpha,1;zoomy,1.5;);
	};
	LoadActor(THEME:GetPathG("_gameover","text"))..{
		OnCommand=cmd(zoom,1;diffusealpha,0;cropbottom,1;addy,55;linear,0.5;diffusealpha,1;cropbottom,0;addy,-55;
			fadeleft,0.2;faderight,0.2;sleep,1;linear,0.5;zoom,0.75;addy,-15);
	};
	LoadActor(THEME:GetPathG("_gameover","text"))..{
		OnCommand=cmd(blend,"BlendMode_Add";diffusealpha,0;sleep,0.5;diffusealpha,1;linear,1;diffusealpha,0);
	};
	LoadFont("Common Normal")..{
		Text="Thank you for playing";
		OnCommand=cmd(y,30;diffusealpha,0;sleep,1.5;zoomy,0;linear,0.5;zoomy,1;diffusealpha,1;);
	};
};