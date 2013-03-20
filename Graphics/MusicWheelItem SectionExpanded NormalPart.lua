local t = Def.ActorFrame{
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder open under"))..{
		InitCommand=cmd(x,0);
	};
	Def.Banner {
		Name="SongBanner";
		--InitCommand=cmd(scaletoclipped,128,40;);
		--[ja] ジャケット表示
		InitCommand=cmd(x,-96;y,-96);
		SetMessageCommand=function(self,params)
			local gra="";
			local jk={"png","lua","avi","flv","mp4","mpg","mpeg","jpg","jpeg","gif","bmp"};
			local group = params.Text;
			for i=1,#jk do
				if FILEMAN:DoesFileExist("/Songs/"..group.."/jacket."..jk[i]) then
					gra="/Songs/"..group.."/jacket."..jk[i];
					break;
				end;
			end;
			if gra=="" then
				for i=1,#jk do
					if FILEMAN:DoesFileExist("/AdditionalSongs/"..group.."/jacket."..jk[i]) then
						gra="/AdditionalSongs/"..group.."/jacket."..jk[i];
						break;
					end;
				end;
			end;
			if gra~="" then
				self:Load(gra);
				self:diffuseupperleft(1,1,1,0);
			elseif SONGMAN:DoesSongGroupExist(group) then
				self:LoadFromSongGroup(group);
				self:diffuseupperleft(1,1,1,1);
			else
				-- call fallback
				gpath=THEME:GetCurrentThemeDirectory().."Jackets/_group.png";
				for i=1,#jk do
					local wlabelfile=params.Text
					if wlabelfile==THEME:GetString("Sort","NotAvailable") then
						wlabelfile="NotAvailable";
					elseif wlabelfile==THEME:GetString("Sort","Other") then
						wlabelfile="Other";
					else
						wlabelfile=string.gsub(wlabelfile,"/","_");
						wlabelfile=string.gsub(wlabelfile,"?","_");
					end;
					if FILEMAN:DoesFileExist(THEME:GetCurrentThemeDirectory().."Jackets/"..wlabelfile.."."..jk[i]) then
						gpath=THEME:GetCurrentThemeDirectory().."Jackets/"..wlabelfile.."."..jk[i];
						break;
					end;
				end;
				self:Load(gpath);
				self:diffuseupperleft(1,1,1,0);
			end;
			self:scaletofit(0,0,188,188);
			self:x(0);
			self:y(0);
			--self:z(params.DrawIndex);

		end;
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder img over"))..{
		InitCommand=cmd(x,0;);
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder open color"))..{
		InitCommand=cmd(x,0);
		SetMessageCommand=function(self,params)
			self:diffuse(Color("Blue"));
		end;
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder over"))..{
		InitCommand=cmd(x,0);
	};
	Def.Quad{
		InitCommand=cmd(diffuse,0,0,0,1;zoomto,192,50;y,96-25);
		SetMessageCommand=function(self,params)
			self:x(0);
			self:diffuseleftedge(0,0,0,0.1);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;maxwidth,230);
		SetMessageCommand=function(self,params)
			local name=GetGroupParameter(params.Text,"name");
			if name=="" then name=params.Text; end;
			self:settextf("%s",name);
			self:y(83-25);
			self:diffuse(BoostColor(Color("Blue"),1.25));
			self:strokecolor(Color("Outline"));
			self:zoom(0.8);
			self:x(92);
			self:shadowlength(1);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;);
		SetMessageCommand=function(self,params)
			self:settext("Songs");
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
	--[[
	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;maxwidth,360);
		SetMessageCommand=function(self,params)
			self:settextf("%s\n ",params.Song:GetDisplaySubTitle());
			if params.Song:GetDisplaySubTitle() == "" then
				self:y(100-25);
			else
				self:y(105-25);
			end;
			self:diffuse(params.Color);
			self:strokecolor(Color("Outline"));
			if params.HasFocus then
				self:zoom(0.5);
				self:x(90-1);
			else
				self:zoom(0);
			end;
			self:shadowlength(1);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;maxwidth,360);
		SetMessageCommand=function(self,params)
			self:settextf("\n%s",params.Song:GetDisplayArtist());
			if params.Song:GetDisplaySubTitle() == "" then
				self:y(100-25);
			else
				self:y(105-25);
			end;
			self:diffuse(params.Color);
			self:strokecolor(Color("Outline"));
			if params.HasFocus then
				self:zoom(0.5);
				self:x(90-1);
			else
				self:zoom(0);
			end;
			self:shadowlength(1);
		end;
	};
	--]]

};
return t;