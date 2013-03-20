local gc = Var("GameCommand");
local t = Def.ActorFrame {};
t[#t+1] = Def.ActorFrame { 
  GainFocusCommand=THEME:GetMetric(Var "LoadingScreen","IconGainFocusCommand");
  LoseFocusCommand=THEME:GetMetric(Var "LoadingScreen","IconLoseFocusCommand");
--	IconGainFocusCommand=cmd(stoptweening;glowshift;decelerate,0.125;zoom,1);
--	IconLoseFocusCommand=cmd(stoptweening;stopeffect;decelerate,0.125;zoom,fZoom);

	--[[
	LoadActor("_background base")..{
		InitCommand=cmd(diffuse,ModeIconColors[gc:GetName()]);
	};
	LoadActor("_background effect");
	LoadActor("_gloss");
	LoadActor("_stroke");
	LoadActor("_cutout");
	--]]
	LoadActor("_base")..{
		InitCommand=cmd(diffuse,ModeIconColors[gc:GetName()];faderight,0.5);
		OffCommand=cmd(linear,0.2;diffusealpha,0);
	};

	-- todo: generate a better font for these.
	LoadFont("Common Normal")..{
		InitCommand=cmd(zoom,1.8;diffuse,color("#FFFFFF");diffusealpha,0.8;
			uppercase,true;settext,gc:GetName();blend,"BlendMode_Add");
		OffCommand=cmd(linear,0.2;diffusealpha,0);
	};
	LoadActor("_base")..{
		DisabledCommand=cmd(diffuse,color("0,0,0,0.5"));
		EnabledCommand=cmd(diffuse,color("1,1,1,0"));
		OffCommand=cmd(linear,0.2;diffusealpha,0);
	};
	--[[
	LoadActor(THEME:GetPathG("_SelectIcon",gc:GetName() )) .. {
		DisabledCommand=cmd(diffuse,color("0.5,0.5,0.5,1"));
		EnabledCommand=cmd(diffuse,color("1,1,1,1"));
	};
	--]]
};
return t