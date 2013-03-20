local scrolltime = 125;

local t = Def.ActorFrame {
	InitCommand=cmd(Center);
	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH/2,SCREEN_HEIGHT;x,-SCREEN_WIDTH/4);
		OnCommand=cmd(diffuse,color("#000000");diffuserightedge,color("#000040"));
	};
	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH/2,SCREEN_HEIGHT;x,SCREEN_CENTER_X-(SCREEN_WIDTH/4));
		OnCommand=cmd(diffuse,color("#000000");diffuseleftedge,color("#000040"));
	};
	LoadActor("bg")..{
		InitCommand=cmd(x,-SCREEN_CENTER_X;y,-SCREEN_CENTER_Y);
	--	OnCommand=cmd(rotationx,180;linear,120;rotationx,360)
	};
	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH+1,SCREEN_HEIGHT);
		OnCommand=cmd(diffuse,Color("Blue");diffusebottomedge,Color("Black");diffusealpha,0.45);
	};
	LoadActor("noise_exp_j").. {
		InitCommand=cmd(diffusealpha,0;zoom,2;);
		OnCommand=cmd(sleep,6.5;linear,0.2;diffusealpha,1;zoom,0.7;sleep,0.5;
			linear,0.2;x,-80;sleep,3;
			linear,0.2;x,-230;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathG("_MusicWheel BannerFrame","color")).. {
		InitCommand=cmd(diffusealpha,0;zoom,2;);
		OnCommand=cmd(sleep,6.5;linear,0.2;diffusealpha,1;zoom,0.92;sleep,0.5;
			linear,0.2;x,-80;sleep,3;
			linear,0.2;x,-230;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathG("_MusicWheel BannerFrame","Evaluation")).. {
		InitCommand=cmd(diffusealpha,0;zoom,2;);
		OnCommand=cmd(sleep,6.5;linear,0.2;diffusealpha,1;zoom,0.92;sleep,0.5;
			linear,0.2;x,-80;sleep,3;
			linear,0.2;x,-230;diffusealpha,0;);
	};
	LoadFont("Common Normal").. {
		InitCommand=cmd(zoom,2;DiffuseAndStroke,Color("White"),Color("Outline");
			horizalign,left;zoom,0.8;y,45;settext,"CREDITS BGM\n\nNoise expert\n/ A.C");
		OnCommand=cmd(diffusealpha,0;sleep,6.5;x,100;sleep,0.7;
			linear,0.2;x,30;diffusealpha,1;sleep,3;
			linear,0.2;x,-70;diffusealpha,0;);
	};
	Def.Quad {
		InitCommand=cmd(diffuse,Color("Blue");diffusealpha,0;zoomto,SCREEN_WIDTH+2,SCREEN_HEIGHT+2;blend,'BlendMode_Add';);
		OnCommand=cmd(sleep,120;linear,2;diffusealpha,1;);
	};
	Def.Quad {
		InitCommand=cmd(diffuse,1,1,1,0;zoomto,SCREEN_WIDTH+2,SCREEN_HEIGHT+2;blend,'BlendMode_Add';);
		OnCommand=cmd(sleep,120;linear,2;diffusealpha,1;);
	};
	LoadActor(THEME:GetPathG("ScreenTitleMenu","logo/_logo")).. {
		InitCommand=cmd(diffusealpha,0;zoom,1.1;);
		OnCommand=cmd(sleep,122;linear,0.7;zoom,1.0;diffusealpha,1;);
	};
	LoadActor(THEME:GetPathB("ScreenInit","decorations/waiei")).. {
		InitCommand=cmd(diffusealpha,0;zoom,0.5;horizalign,right;vertalign,bottom;x,SCREEN_CENTER_X-40;y,SCREEN_CENTER_Y-40);
		OnCommand=cmd(sleep,122;linear,0.7;diffusealpha,1;);
	};
	LoadActor(THEME:GetPathG("_credits/credits","stepmania")).. {
		InitCommand=cmd(diffusealpha,0;zoom,2;y,-30;);
		OnCommand=cmd(sleep,1.0;linear,0.2;diffusealpha,1;zoom,1;sleep,0.5;sleep,3.5;linear,0.2;diffusealpha,0;);
	};
	LoadFont("Common Normal").. {
		InitCommand=cmd(diffuse,0.5,0.75,1,0;strokecolor,Color("Outline");zoom,1;
			settext,""..ProductVersion().." / "..VersionDate().."\n\nTHEME : "..GetThemeVersionInformation("Name").." "..GetThemeVersionInformation("Version");y,30;);
		OnCommand=cmd(sleep,1.0;linear,0.2;diffusealpha,1;zoom,0.8;sleep,0.5;sleep,3.5;linear,0.2;diffusealpha,0;);
	};
};

return t;