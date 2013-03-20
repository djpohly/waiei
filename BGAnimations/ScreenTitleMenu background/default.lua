local t=Def.ActorFrame{};

t[#t+1]=EXF_ScreenTitleMenu();

t[#t+1]=Def.ActorFrame{
  FOV=90;
  InitCommand=cmd(Center);
	LoadActor("_bg") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH+256,SCREEN_HEIGHT);
	};
	LoadActor("../ScreenWithMenuElements background/line") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT*2;diffuse,ColorLightTone(color("#000080"));rotationy,-20;customtexturerect,0,0,SCREEN_WIDTH*1.5/48,SCREEN_HEIGHT*1.5/96);
		OnCommand=cmd(texcoordvelocity,2,-0.2;diffuserightedge,0,0.4,0.8,0.2;bob;effectmagnitude,0.5,0,15;effectperiod,4);
		--bob;effectmagnitude,50,0,35;
	};
};

return t;
