local t = Def.ActorFrame {}

t[#t+1] = Def.Quad {
	InitCommand = cmd(FullScreen;diffuse,Color.Black;diffusealpha,0.5),
}

t[#t+1] = Def.Quad {
	InitCommand = cmd(zoomto,200,150;Center;diffuse,Color.Black;diffusealpha,0.85),
}

return t
