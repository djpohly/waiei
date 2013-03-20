local t = Def.ActorFrame {
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH+1,30;vertalign,bottom;diffuse,0,0,0,0.7);
	};
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH+1,1;vertalign,bottom;y,-30;diffuse,Color("Blue");fadeleft,0.3;faderight,0.3;);
	};
};

return t