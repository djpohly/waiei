local t = Def.ActorFrame{
	LoadActor("_logo")..{
		InitCommand=cmd(zoom,1.2);
	};
};

return t;
