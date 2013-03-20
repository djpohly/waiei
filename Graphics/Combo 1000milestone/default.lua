local ShowFlashyCombo = GetUserPrefB("UserPrefFlashyCombo")
return Def.ActorFrame {
	LoadActor("explosion") .. {
		InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';hide_if,not ShowFlashyCombo);
		MilestoneCommand=cmd(zoomx,0;zoomy,1;diffusealpha,1;linear,0.5;zoomx,3;zoomy,0;diffusealpha,0);
	};
	LoadActor("explosion") .. {
		InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';hide_if,not ShowFlashyCombo);
		MilestoneCommand=cmd(zoomx,1;zoomy,0;diffusealpha,1;linear,0.5;zoomx,1;zoomy,1;diffusealpha,0);
	};
};