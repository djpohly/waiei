return Def.ActorFrame {
	LoadActor(THEME:GetPathG("ScreenTitleMenu","PreferenceFrame")) .. {
		InitCommand=cmd(diffuse,0.5,0.5,0.5,0.8);
	};
	LoadFont("Common Normal") .. {
		Text="StepMania";
		AltText="StepMania";
		InitCommand=cmd(y,-5;zoom,0.6);
		OnCommand=cmd(shadowlength,1);
	};
	LoadFont("Common Normal") .. {
		Text=ProductVersion() .. " (".. VersionDate() ..")";
		AltText="";
		InitCommand=cmd(y,8;zoom,0.45);
		OnCommand=cmd(shadowlength,1;skewx,-0.125);
	};
};