local tcol=GetUserPref_Theme("UserColorPath");
return Def.ActorFrame{
	LoadActor(""..tcol.."ScoreFrame")..{
		InitCommand=cmd(diffuseupperleft,0,0,0,0;);
	};
};