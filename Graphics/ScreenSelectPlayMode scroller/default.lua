local gc = Var "GameCommand";
local colors = {
	Easy		= color("#00C0ff"),
	Normal		= color("#00C0ff"),
	Hard		= color("#00C0ff"),
	Rave		= color("#64C000"),
	Nonstop		= color("#ffff00"),
	Extended	= color("#ffff00"),
	Oni			= color("#ff8000"),
	Endless		= color("#ff0000"),
};
local t = Def.ActorFrame {};
-- Background!
t[#t+1] = Def.ActorFrame {
-- 	GainFocusCommand=cmd(visible,true);
-- 	LoseFocusCommand=cmd(visible,false);
 	LoadActor("_HighlightFrame") .. {
		InitCommand=cmd(diffuse,colors[gc:GetName()];diffusealpha,0;fadeleft,0.5;faderight,0.5);
		GainFocusCommand=cmd(stoptweening;linear,0.125;diffusealpha,0.5);
		LoseFocusCommand=cmd(stoptweening;linear,0.125;diffusealpha,0);
		OffFocusedCommand=cmd(finishtweening;glow,Color("White");decelerate,1.5;glow,Color("Invisible"));
	};
 	LoadActor("_HighlightFrame") .. {
		InitCommand=cmd(diffuse,colors[gc:GetName()];diffusealpha,0;fadeleft,1;faderight,1;blend,"BlendMode_Add");
		GainFocusCommand=cmd(stoptweening;linear,0.125;diffusealpha,1);
		LoseFocusCommand=cmd(stoptweening;linear,0.125;diffusealpha,0);
		OffFocusedCommand=cmd(finishtweening;glow,Color("White");decelerate,1.5;glow,Color("Invisible"));
	};
};
-- Text Frame
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,-140;y,-10);
	Def.Quad {
		InitCommand=cmd(horizalign,left;y,20;zoomto,320,2;diffuse,colors[gc:GetName()];diffusealpha,0;fadeleft,0.35;faderight,0.35);
		GainFocusCommand=cmd(stoptweening;linear,0.2;diffusealpha,1);
		LoseFocusCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
	};
	LoadFont("common normal")..{
		Text=gc:GetName();
		InitCommand=cmd(horizalign,left;diffuse,color("White");strokecolor,ColorDarkTone(colors[gc:GetName()]);shadowlength,2;diffusealpha,0;skewx,-0.125);
		GainFocusCommand=cmd(stoptweening;y,-16;decelerate,0.25;diffusealpha,1;y,0);
		LoseFocusCommand=cmd(stoptweening;y,0;accelerate,0.25;diffusealpha,0;y,16;diffusealpha,0);
	};
	LoadFont("frutiger 24px")..{
		Text=THEME:GetString(Var "LoadingScreen", gc:GetName() .. "Explanation");
		InitCommand=cmd(horizalign,right;x,320;y,40;shadowlength,1;diffusealpha,0;skewx,-0.125;zoom,0.5);
		GainFocusCommand=cmd(stoptweening;y,40-16;decelerate,0.25;diffusealpha,1;y,40;maxheight,60;);
		LoseFocusCommand=cmd(stoptweening;y,40;accelerate,0.25;diffusealpha,0;y,40+16;diffusealpha,0);
	};
};
-- t.GainFocusCommand=cmd(visible,true);
-- t.LoseFocusCommand=cmd(visible,false);
return t