local gc = Var("GameCommand");
local t = Def.ActorFrame {};
if not IsGame("techno") then
t[#t+1] = Def.ActorFrame { 
  GainFocusCommand=THEME:GetMetric(Var "LoadingScreen","IconGainFocusCommand");
  LoseFocusCommand=THEME:GetMetric(Var "LoadingScreen","IconLoseFocusCommand");
	LoadActor(THEME:GetPathG("_SelectIcon",gc:GetName() )) .. {
		DisabledCommand=cmd(diffuse,color("0.5,0.5,0.5,1"));
		EnabledCommand=cmd(diffuse,color("1,1,1,1"));
	};
};
else
t[#t+1] = Def.ActorFrame { 
  GainFocusCommand=THEME:GetMetric(Var "LoadingScreen","IconGainFocusCommand");
  LoseFocusCommand=THEME:GetMetric(Var "LoadingScreen","IconLoseFocusCommand");
	LoadActor(THEME:GetPathG("_SelectIcon_tcn",gc:GetName() )) .. {
		DisabledCommand=cmd(diffuse,color("0.5,0.5,0.5,1"));
		EnabledCommand=cmd(diffuse,color("1,1,1,1"));
	};
};
end;
return t