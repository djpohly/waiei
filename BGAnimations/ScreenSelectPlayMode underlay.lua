local t = Def.ActorFrame {};
t[#t+1] = Def.ActorFrame {
  FOV=60;
	LoadActor(THEME:GetPathG("information/Information","Cube1")) .. {
		InitCommand=cmd(diffuse,ColorLightTone(color("#0064FF")););
		OnCommand=cmd(Center;zoom,SCREEN_HEIGHT/600;rotationy,-90;bounceend,0.5;rotationy,0;);
		OffCommand=cmd(bounceend,0.5;y,SCREEN_BOTTOM+100;zoom,0;rotationx,-45;);
	};
};
--t[#t+1] = StandardDecorationFromFileOptional("BackgroundFrame","BackgroundFrame");
return t;