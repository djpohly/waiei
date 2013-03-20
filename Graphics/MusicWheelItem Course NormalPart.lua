local col_t={0.8,0.3,1.0,1};
local wheeltext="";
if GetUserPref_Theme("UserWheelText") == 'Default' then
	wheeltext = "default"
elseif GetUserPref_Theme("UserWheelText") == 'All' then
	wheeltext = "all"
elseif GetUserPref_Theme("UserWheelText") == 'None' then
	wheeltext = "none"
else
	wheeltext = "default"
end;
local jk={"png","avi","flv","mp4","mpg","mpeg","jpg","jpeg","gif","bmp"};

local t = Def.ActorFrame{
	SetMessageCommand=function(self,params)
		local cc=params.Course;
		if cc:IsEndless() then
			col_t={1.0,0.1,0.1,0.7};
		elseif cc:IsNonstop() then
			col_t={0.9,1.0,0.1,1};
		elseif cc:IsOni() then
			col_t={0.8,0.3,1.0,1};
		else
			col_t={0.8,0.3,1.0,1};
		end;
	end;
	Def.Sprite {
		InitCommand=cmd(x,0;);
		SetMessageCommand=function(self,params)
			local song = params.Song;
			local course = params.Course;
			if course then
				self:Load( THEME:GetPathG("_MusicWheel","BannerFrame under") );
			elseif course and not song then
				self:Load( THEME:GetPathG("_MusicWheel","BannerFrame folder mode") );
			else
				self:Load( THEME:GetPathG("_MusicWheel","BannerFrame folder close") );
			end;
		end;
	};
	Def.Banner {
		Name="Banner";
		--InitCommand=cmd(scaletoclipped,128,40;);
		--[ja] ジャケット表示
		InitCommand=cmd(x,-96;y,-96);
		BeginCommand=cmd(playcommand,"Set");
		SetMessageCommand=function(self,params)
			local course = params.Course;
			if course then
				-- this is where we do all song-specific stuff
				local gpath=GetCourseGPath(params.Course);
				--[[
				if gpath==THEME:GetPathG("Common fallback","banner") then
					for i=1,#jk do
						local wlabelfile=string.gsub(params.Text,"/","_")
						if FILEMAN:DoesFileExist(THEME:GetCurrentThemeDirectory().."Jackets/"..wlabelfile.."."..jk[i]) then
							gpath=THEME:GetCurrentThemeDirectory().."Jackets/"..wlabelfile.."."..jk[i];
							break;
						end;
					end;
				end;
				--]]
				if params.HasFocus then
					self:Load(gpath);
					self:stoptweening();
					self:rate(0.5);
					self:position(0);
				else
					self:Load(gpath);
					self:rate(1.0);
				end;
			elseif course and not song then
				-- this is where we do all course-specific stuff
				self:LoadFromCourse(params.Course);
			else
				-- call fallback
				self:Load( THEME:GetPathG("Common fallback","banner") );
			end;
			self:stoptweening();
			self:scaletofit(0,0,188,188);
			self:x(0);
			self:y(0);
		end;
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame color")).. {
		--InitCommand=cmd(x,-2;);
		InitCommand=cmd(playcommand,"Set");
		SetMessageCommand=function(self,params)
			self:x(0);
			--self:Load( THEME:GetPathG("_MusicWheel","BannerFrame color"));
			if col~="" then
				self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
			else
				if params.HasFocus then
					self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
				else
					self:diffuse(Color("White"));
				end;
			end;
		end;
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame over"))..{
	};
	Def.Quad{
		InitCommand=cmd(diffuse,0,0,0,1;zoomto,192,50;y,96-25);
		SetMessageCommand=function(self,params)
			if (params.HasFocus and wheeltext~="none") or wheeltext=="all" then
				self:diffusealpha(1.0);
				self:diffuseleftedge(0,0,0,0.25);
			else
				self:diffusealpha(0);
			end;
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;maxwidth,230);
		SetMessageCommand=function(self,params)
			self:y(83-25);
			--if GetSMParameter(params.Song,"metertype") == "DDR X" and then
			if col~="" then
				self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
			else
				if params.HasFocus then
					self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
				else
					self:diffuse(Color("White"));
				end;
			end;
			self:settextf("%s",params.Course:GetDisplayFullTitle());
			self:strokecolor(Color("Outline"));
			if (params.HasFocus and wheeltext~="none") or wheeltext=="all" then
				self:zoom(0.8);
				self:x(92);
			else
				self:zoom(0);
			end;
			self:shadowlength(1);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;);
		SetMessageCommand=function(self,params)
			local entry=params.Course:GetCourseEntries();
			self:settextf("%d",#entry);
			self:x(41);
			self:y(105-25);
			self:diffuse(Color("White"));
			self:strokecolor(Color("Outline"));
			self:zoom(0.5);
			if (params.HasFocus and wheeltext~="none") or wheeltext=="all" then
				self:visible(true);
			else
				self:visible(false);
			end;
			self:shadowlength(1);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;);
		SetMessageCommand=function(self,params)
			self:settext("Stages");
			self:x(91);
			self:y(105-25);
			self:diffuse(Color("White"));
			self:strokecolor(Color("Outline"));
			self:zoom(0.5);
			if (params.HasFocus and wheeltext~="none") or wheeltext=="all" then
				self:visible(true);
			else
				self:visible(false);
			end;
			self:shadowlength(1);
		end;
	};
};
return t;