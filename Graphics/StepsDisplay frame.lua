return Def.ActorFrame{
	LoadActor("ScreenTitleMenu PreferenceFrame")..{
		InitCommand=cmd(y,2;blend,"BlendMode_Add";fadetop,1;fadebottom,1);
	};
};

