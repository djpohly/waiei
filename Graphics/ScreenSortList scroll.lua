local gc = Var("GameCommand")

local t = Def.ActorFrame {}

t[#t+1] = LoadFont("Common Normal") .. {
	Text = gc:GetName(),
	GainFocusCommand = cmd(diffusealpha,1;zoom,1.1),
	LoseFocusCommand = cmd(diffusealpha,0.5;zoom,0.9),
}

return t
