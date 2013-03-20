local haishin = ...;
local t=Def.ActorFrame {
  FOV=90;
  InitCommand=cmd(Center);
	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH/3,SCREEN_HEIGHT;x,-SCREEN_WIDTH/3);
		OnCommand=cmd(diffuse,color("#000000");diffuserightedge,color("#003060"));
	};
	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH*2/3,SCREEN_HEIGHT;x,SCREEN_CENTER_X-(SCREEN_WIDTH/3));
		OnCommand=cmd(diffuse,color("#000000");diffuseleftedge,color("#003060"));
	};
	LoadActor("../line") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT*2;diffuse,color("#000000");rotationy,-20;customtexturerect,0,0,SCREEN_WIDTH*1.5/48,SCREEN_HEIGHT*1.5/96);
		OnCommand=cmd(texcoordvelocity,(haishin=="Off") and 2 or 0,(haishin=="Off") and -0.2 or 0;
			diffuserightedge,0.2,0.2,0.2,0.2;bob;effectmagnitude,0.5,0,15;effectperiod,4);
		--bob;effectmagnitude,50,0,35;
	};
	LoadActor("../panel") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT*2;diffuse,ColorLightTone(color("#FFFFFF"));blend,'BlendMode_Add';y,20;rotationy,-20;customtexturerect,0,0,SCREEN_WIDTH*1.5/480,SCREEN_HEIGHT*1.5/480);
		OnCommand=cmd(texcoordvelocity,(haishin=="Off") and 1 or 0,(haishin=="Off") and -0.05 or 0;diffuserightedge,0,0.15,0.3,0.5;);
		--bob;effectmagnitude,50,0,35;
	};
	LoadActor("../fan_1") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X-150;y,80;zoom,1.5;rotationy,75;rotationx,-25;diffuse,ColorLightTone(color("#0064FF"));spin;effectmagnitude,0,0,20;blend,'BlendMode_Add');
	};
	LoadActor("_particleLoader") .. {
		InitCommand=cmd(x,-SCREEN_CENTER_X;y,-SCREEN_CENTER_Y);
	};
};

return t;
