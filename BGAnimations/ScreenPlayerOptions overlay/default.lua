local t = Def.ActorFrame{}

t.InitCommand = cmd(xy,2*SCREEN_WIDTH/3,20)

t[#t+1] = LoadActor(THEME:GetPathS("Common", "Cancel")) .. {
	CancelAllP1MessageCommand = cmd(stop;play),
	CancelAllP2MessageCommand = cmd(stop;play),
}

t[#t+1] = LoadActor("fan_1") .. {
	InitCommand = cmd(zoomto,60,60;diffusecolor,PlayerColor(PLAYER_1);diffusealpha,0),
	CancelAllP1MessageCommand = cmd(finishtweening;
		x,-10;rotationz,0;diffusealpha,1;
		linear,0.7;
		addx,-35;rotationz,-180;
		linear,0.5;
		diffusealpha,0),
}

t[#t+1] = LoadActor("fan_1") .. {
	InitCommand = cmd(zoomto,60,60;diffusecolor,PlayerColor(PLAYER_2);diffusealpha,0),
	CancelAllP2MessageCommand = cmd(finishtweening;
		x,10;rotationz,0;diffusealpha,1;
		linear,0.7;
		addx,35;rotationz,-180;
		linear,0.5;
		diffusealpha,0),
}

t[#t+1] = LoadFont() .. {
	Text = "RESET",
	InitCommand = cmd(zoom,0.7;diffusealpha,0),
	CancelAllP1MessageCommand = cmd(finishtweening;
		diffusealpha,1;sleep,0.7;
		linear,0.5;diffusealpha,0),
	CancelAllP2MessageCommand = cmd(finishtweening;
		diffusealpha,1;sleep,0.7;
		linear,0.5;diffusealpha,0),
}

return t
