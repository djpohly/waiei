local t = Def.ActorFrame{
	MenuSelectionChangedCommand=cmd(queuecommand,"Set");
	PreferredSongGroupChangedCommand=cmd(queuecommand,"Set");
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder close"))..{
		InitCommand=cmd(x,0);
		SetMessageCommand=function(self,params)
			if ISChallEXFolder_NowOpen() then
				self:diffuse(Color("Red"));
			else
				self:diffuse(Color("Black"));
			end;
		end;
	};
	LoadActor(THEME:GetPathG("Banner","EXFolder"))..{
		InitCommand=cmd(scaletofit,-90,-90,90,90;y,-5;);
		SetMessageCommand=function(self,params)
			if ISChallEXFolder_NowOpen() then
				self:diffuse(Color("Red"));
				self:diffusealpha(1);
			else
				self:diffuse(Color("White"));
				self:diffusealpha(0.5);
			end;
		end;
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder img over"))..{
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder color"))..{
		InitCommand=cmd(x,0);
		SetMessageCommand=function(self,params)
			if ISChallEXFolder_NowOpen() then
				self:diffuse(Color("Red"));
			else
				self:diffuse(Color("White"));
			end;
		end;
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder over"))..{
		InitCommand=cmd(x,0);
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;maxwidth,230);
		SetMessageCommand=function(self,params)
			if ISChallEXFolder_NowOpen() then
				self:settextf("%s",GetActiveGroupName());
				self:diffuse(BoostColor(Color("Red"),1.25));
			else
				self:settext("Locked");
				self:diffuse(Color("White"));
			end;
			self:y(83-25);
			self:strokecolor(Color("Outline"));
			self:zoom(0.8);
			self:x(92);
			self:shadowlength(1);
		end;
	};

	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;);
		SetMessageCommand=function(self,params)
			self:settext("EXFolder");
			self:y(105-25);
			self:diffuse(Color("White"));
			self:strokecolor(Color("Outline"));
			self:zoom(0.5);
			if params.HasFocus then
				self:x(91);
			else
				self:x(90);
			end;
			self:shadowlength(1);
		end;
	};
};
return t;