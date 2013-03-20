local t = Def.ActorFrame {};

t[#t+1] = Def.ActorFrame {
	LoadActor("_ScrollBar Tick").. {
		InitCommand=cmd(blend,"BlendMode_Add";x,1);
	};
};

return t