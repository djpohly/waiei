local t = Def.ActorFrame{};

t[#t+1] =Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,1,1,1,0;);
		OnCommand=cmd(sleep,0.5;linear,0.5;diffuse,1,1,1,1;linear,1.5;diffuse,0,0,0,1;);
	};
	LoadActor(THEME:GetPathG( "_failed/failed", "over1" ) ) .. {
		InitCommand=cmd(scaletocover,0,0,1280,480;Center;diffusealpha,0;zoom,2);
		OnCommand=cmd(sleep,0.4;linear,0.2;diffusealpha,1;zoom,1;
			sleep,0.5;linear,0.5;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG( "_failed/failed", "over2" ) ) .. {
		InitCommand=cmd(scaletocover,0,0,1280,480;Center;diffusealpha,0;zoom,2);
		OnCommand=cmd(sleep,0.5;linear,0.2;diffusealpha,1;zoom,1;
			sleep,0.4;linear,0.5;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG( "_failed/failed", "over3" ) ) .. {
		InitCommand=cmd(scaletocover,0,0,1280,480;Center;diffusealpha,0;zoom,2);
		OnCommand=cmd(sleep,0.6;linear,0.2;diffusealpha,1;zoom,1;
			sleep,0.3;linear,0.5;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG( "_failed/failed", "over4" ) ) .. {
		InitCommand=cmd(scaletocover,0,0,1280,480;Center;diffusealpha,0;zoom,2);
		OnCommand=cmd(sleep,0.7;linear,0.2;diffusealpha,1;zoom,1;
			linear,0.2;linear,0.5;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG( "_failed/failed", "over1" ) ) .. {
		InitCommand=cmd(scaletocover,0,0,1280,480;Center;diffusealpha,0;zoom,2;blend,"BlendMode_Add");
		OnCommand=cmd(sleep,0.1;spring,1.0;diffusealpha,0.5;zoom,1;
			linear,0.5;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG( "_failed/failed", "over2" ) ) .. {
		InitCommand=cmd(scaletocover,0,0,1280,480;Center;diffusealpha,0;zoom,2;blend,"BlendMode_Add");
		OnCommand=cmd(sleep,0.2;spring,1.0;diffusealpha,0.5;zoom,1;
			linear,0.5;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG( "_failed/failed", "over3" ) ) .. {
		InitCommand=cmd(scaletocover,0,0,1280,480;Center;diffusealpha,0;zoom,2;blend,"BlendMode_Add");
		OnCommand=cmd(sleep,0.3;spring,1.0;diffusealpha,0.5;zoom,1;
			linear,0.5;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG( "_failed/failed", "over4" ) ) .. {
		InitCommand=cmd(scaletocover,0,0,1280,480;Center;diffusealpha,0;zoom,2;blend,"BlendMode_Add");
		OnCommand=cmd(sleep,0.4;spring,1.0;diffusealpha,0.5;zoom,1;
			linear,0.5;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG( "_failed/failed", "over5" ) ) .. {
		InitCommand=cmd(scaletocover,0,0,1280,480;Center;diffusealpha,0;zoom,2);
		OnCommand=cmd(sleep,0.8;linear,0.2;diffusealpha,1;zoom,1;sleep,0.5;
			linear,1.5;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG( "_failed/failed", "over5" ) ) .. {
		InitCommand=cmd(scaletocover,0,0,1280,480;Center;diffusealpha,0;zoom,2;blend,"BlendMode_Add");
		OnCommand=cmd(sleep,0.8;linear,0.2;diffusealpha,1;zoom,1;
			linear,0.5;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG( "_failed/failed", "text" ) ) .. {
		InitCommand=cmd(scaletocover,0,0,1280,480;Center;diffusealpha,0;zoom,2;);
		OnCommand=cmd(sleep,0.5;linear,0.2;diffusealpha,1;zoom,1);
	};
	LoadActor(THEME:GetPathG( "_failed/failed", "text" ) ) .. {
		InitCommand=cmd(scaletocover,0,0,1280,480;Center;diffusealpha,0;zoom,1;blend,"BlendMode_Add");
		OnCommand=cmd(sleep,1.0;diffusealpha,1;linear,0.4;diffusealpha,0);
	};
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,0,0,0,0;);
		OnCommand=cmd(sleep,2.5;linear,0.5;diffusealpha,1;);
	};
	LoadActor(THEME:GetPathS( Var "LoadingScreen", "failed" ) ) .. {
		StartTransitioningCommand=cmd(sleep,0.5;play);
	};
};

return t;