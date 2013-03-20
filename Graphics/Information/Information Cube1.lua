return Def.ActorFrame{
	LoadActor("cube bg")..{
		InitCommand=cmd(rotationx,90;x,0;y,240;blend,'BlendMode_Add';);
	};
	LoadActor("cube bg")..{
		InitCommand=cmd(rotationx,-90;x,0;y,-240;blend,'BlendMode_Add';);
	};
	LoadActor("cube bg")..{
		InitCommand=cmd(rotationy,90;x,-240;z,0;blend,'BlendMode_Add';);
	};
	LoadActor("cube bg")..{
		InitCommand=cmd(rotationy,-90;x,240;z,0;blend,'BlendMode_Add';);
	};
	LoadActor("cube bg")..{
		InitCommand=cmd(rotationy,0;x,0;z,-240;blend,'BlendMode_Add';);
	};
	LoadActor("cube bg")..{
		InitCommand=cmd(rotationy,180;x,0;z,240;blend,'BlendMode_Add';);
	};
};