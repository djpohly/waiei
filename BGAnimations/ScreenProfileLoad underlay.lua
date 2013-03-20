local t = Def.ActorFrame {};
t[#t+1] = Def.ActorFrame {
  FOV=60;
	LoadActor(THEME:GetPathG("information/Information","Cube1")) .. {
		InitCommand=cmd(diffuse,ColorLightTone(color("#0064FF")););
		OnCommand=cmd(Center;zoom,SCREEN_HEIGHT/600;rotationy,0;bounceend,0.5;rotationy,90;);
	};
};
return t