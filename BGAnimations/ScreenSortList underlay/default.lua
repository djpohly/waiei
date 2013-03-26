local t = Def.ActorFrame {}

t[#t+1] = Def.Quad {
	InitCommand = cmd(FullScreen;diffuse,Color.Black;diffusealpha,0.5),
}

t[#t+1] = Def.Quad {
	InitCommand = cmd(Center;zoomto,200,150;diffuse,Color.Black),
}

t[#t+1] = Border(200, 150, 2) .. {
	InitCommand = cmd(Center),
}

return t
