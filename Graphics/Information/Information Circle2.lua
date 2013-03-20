return Def.ActorFrame{
	LoadActor("circle bg")..{
		InitCommand=cmd(rotationx,90;blend,'BlendMode_Add';);
		OnCommand=cmd(playcommand,"Loop");
		LoopCommand=cmd(rotationx,90;sleep,1.5;linear,0.5;rotationx,270;sleep,3;linear,0.5;rotationx,450;sleep,1.5;queuecommand,"Loop";);
		OffCommand=cmd(finishtweening);
	};
	LoadActor("circle bg")..{
		InitCommand=cmd(rotationy,90;blend,'BlendMode_Add';);
		OnCommand=cmd(playcommand,"Loop");
		LoopCommand=cmd(rotationy,90;sleep,1.5;linear,0.5;rotationy,270;sleep,3;linear,0.5;rotationy,450;sleep,1.5;queuecommand,"Loop";);
		OffCommand=cmd(finishtweening);
	};
	LoadActor("circle bg")..{
		InitCommand=cmd(rotationz,90;blend,'BlendMode_Add';);
		OnCommand=cmd(playcommand,"Loop");
		LoopCommand=cmd(rotationz,90;sleep,1.5;linear,0.5;rotationz,270;sleep,3;linear,0.5;rotationz,450;sleep,1.5;queuecommand,"Loop";);
		OffCommand=cmd(finishtweening);
	};
};