return Def.ActorFrame{
	LoadActor("cube bg")..{
		InitCommand=cmd(rotationx,90;x,0;y,240;blend,'BlendMode_Add';);
		OnCommand=cmd(playcommand,"Loop");
		LoopCommand=cmd(rotationz,0;sleep,1.5;spring,0.5;rotationz,90;sleep,1.5;spring,0.5;rotationz,180;queuecommand,"Loop";);
		OffCommand=cmd(finishtweening);
	};
	LoadActor("cube bg")..{
		InitCommand=cmd(rotationx,-90;x,0;y,-240;blend,'BlendMode_Add';);
		OnCommand=cmd(playcommand,"Loop");
		LoopCommand=cmd(rotationz,0;sleep,1.5;spring,0.5;rotationz,90;sleep,1.5;spring,0.5;rotationz,180;queuecommand,"Loop";);
		OffCommand=cmd(finishtweening);
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