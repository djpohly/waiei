return Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,color("0,0,0,1"));
		OnCommand=function(self)
			SetwaieiInfo("BGScale",GetUserPref_Theme("UserBGScale"));
			SetwaieiInfo("Haishin",GetUserPref_Theme("UserHaishin"));
			var=GetSMParameter(_SONG(),"bgaspectratio");
			SetwaieiInfo("BGRatio",var);
			(cmd(decelerate,0.5;diffusealpha,0))(self);
		end;
	};
};