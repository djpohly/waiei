local t = Def.ActorFrame{
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder room under"))..{
		InitCommand=cmd(x,-2;);
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder create room"))..{
		InitCommand=cmd(x,-2;);
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(x,-2;);
		OnCommand=function(self)
			local wi=self:GetWheelItem(self:GetCurrentIndex());
			if wi then
				local t=wi:GetText();
				self:settext(t);
			else
				self:settext("ERR");
			end;
		end;
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder img over"))..{
		InitCommand=cmd(x,-2;);
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder open color"))..{
		InitCommand=cmd(x,-2;diffuse,0.0,0.9,0.25,1.0);
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder over"))..{
		InitCommand=cmd(x,-2;);
	};
	Def.Quad{
		InitCommand=cmd(diffuse,0,0,0,1;zoomto,192,50;y,96-25;diffuseleftedge,0,0,0,0.1);
	};

};
return t;