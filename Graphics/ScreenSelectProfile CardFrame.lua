local t = Def.ActorFrame {
	Def.Quad{
		InitCommand=cmd(zoomto,232,240;diffuse,0,0,0,0.9;fadeleft,0.3;faderight,0.3;);
	};
	Def.Quad{
		InitCommand=cmd(zoomto,20,240;diffuse,Color("Blue");blend,"BlendMode_Add";fadeleft,1;x,-106);
	};
	Def.Quad{
		InitCommand=cmd(zoomto,20,240;diffuse,Color("Blue");blend,"BlendMode_Add";faderight,1;x,106);
	};
};
return t