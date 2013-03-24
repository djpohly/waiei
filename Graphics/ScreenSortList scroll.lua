local gc = Var("GameCommand")

local t = Def.ActorFrame {}

t[#t+1] = LoadFont("Common Normal") .. {
	Text = gc:GetName(),
	GainFocusCommand = cmd(stoptweening;diffusealpha,1;linear,0.125;zoom,1.1),
	LoseFocusCommand = cmd(stoptweening;diffusealpha,0.5;linear,0.125;zoom,0.9),
}

return t
