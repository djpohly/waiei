return Def.ActorFrame{
	LoadActor("circle bg")..{
		InitCommand=cmd(rotationx,90;blend,'BlendMode_Add';);
	};
	LoadActor("circle bg")..{
		InitCommand=cmd(rotationy,90;blend,'BlendMode_Add';);
	};
	LoadActor("circle bg")..{
		InitCommand=cmd(rotationz,90;blend,'BlendMode_Add';);
	};
};