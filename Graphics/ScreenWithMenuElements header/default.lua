local t = Def.ActorFrame {};

t[#t+1]=Def.Quad{
	InitCommand=cmd(vertalign,top;zoomto,SCREEN_WIDTH+1,42;diffuse,0,0,0,0.7);
};
t[#t+1]=Def.Quad{
	InitCommand=cmd(zoomto,SCREEN_WIDTH+1,1;vertalign,top;y,42;diffuse,Color("Blue");fadeleft,0.3;faderight,0.3;);
};
t[#t+1] = LoadFont("Common Normal") .. {
	Name="HeaderText";
	Text=Screen.String("HeaderText");
	InitCommand=cmd(x,-SCREEN_CENTER_X+24;y,24;zoom,1;horizalign,left;shadowlength,0;maxwidth,200);
	OnCommand=cmd(skewx,-0.125;strokecolor,Color("Outline");diffusebottomedge,color("0.875,0.875,0.875"));
	UpdateScreenHeaderMessageCommand=function(self,param)
		self:settext(param.Header);
	end;
};


return t