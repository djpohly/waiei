local wlabels={
	"Portal",
	"Random",
	"Roulette",
	"Empty",

	"ArtistText",
	"BpmText",
	"ChallengeMeterText",
	"DoubleEasyMeterText",
	"DoubleMediumMeterText",
	"DoubleHardMeterText",
	"DoubleChallengeMeterText",
	"EasyMeterText",
	"GenreText",
	"GroupText",
	"HardMeterText",
	"LengthText",
	"MediumMeterText",
	"PopularityText",
	"PreferredText",
	"TitleText",
	"RecentText",
	"TopGradesText",

	"CoursesText",
	"AllCoursesText",
	"NonstopText",
	"OniText",
	"EndlessText",
	"SurvivalText",

	"NormalModeText",
	"BattleModeText"
};
local jk={"png","avi","flv","mp4","mpg","mpeg","jpg","jpeg","gif","bmp"};

local t = Def.ActorFrame{
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame under"))..{
		InitCommand=cmd(x,0;);
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder mode"))..{
		InitCommand=cmd(x,0;);
	};
	Def.Banner{
		SetMessageCommand=function(self,params)
			local wlabeltext=nil;
			local wlabelfile=nil;
			for i=1,#wlabels do
				if params.Label==THEME:GetString("MusicWheel",wlabels[i]) then
					wlabeltext=wlabels[i];
					break;
				end;
			end;
			if wlabeltext then
				for i=1,#jk do
					if FILEMAN:DoesFileExist(THEME:GetCurrentThemeDirectory().."Jackets/"..wlabeltext.."."..jk[i]) then
						wlabelfile=THEME:GetCurrentThemeDirectory().."Jackets/"..wlabeltext.."."..jk[i];
						break;
					end;
				end;
				if wlabelfile then
					self:Load( wlabelfile );
				else
				self:Load( THEME:GetCurrentThemeDirectory().."Jackets/_fallback.png" );
				end;
			else
				self:Load( THEME:GetCurrentThemeDirectory().."Jackets/_fallback.png" );
			end;
			self:diffuseupperleft(1,1,1,0);
			self:scaletofit(0,0,188,188);
			self:x(0);
			self:y(0);
			--_SYS(params.Label.."/"..params.Text);
		end;
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder color"))..{
		InitCommand=cmd(x,0;);
		SetMessageCommand=function(self,params)
			self:diffuse(params.Color);
		end;
	};
	Def.Quad{
		InitCommand=cmd(x,0;diffuse,0,0,0,1;zoomto,192,50;y,96-25);
		SetMessageCommand=function(self,params)
			self:diffuseleftedge(0,0,0,0.1);
		end;
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame folder over"))..{
		InitCommand=cmd(x,0;);
	};
};
return t;