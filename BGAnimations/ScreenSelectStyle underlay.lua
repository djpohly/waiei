local t = Def.ActorFrame {};
t[#t+1] = Def.ActorFrame {
  FOV=60;
	LoadActor(THEME:GetPathG("information/Information","Cube1")) .. {
		InitCommand=cmd(diffuse,ColorLightTone(color("#0064FF")););
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM+100;rotationx,45;zoom,SCREEN_HEIGHT/1200;
			bounceend,0.5;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoom,SCREEN_HEIGHT/600;rotationx,0;);
	};
};
return t