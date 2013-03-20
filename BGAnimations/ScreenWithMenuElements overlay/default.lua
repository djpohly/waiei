local name=GetThemeVersionInformation("Name");
local version=GetThemeVersionInformation("Version");
local vertype=GetThemeVersionInformation("Type");

local t;
if vertype~="" then
	t=Def.ActorFrame{
		LoadFont("Common normal")..{
			InitCommand=cmd(blend,"BlendMode_Add";horizalign,center;
				x,SCREEN_WIDTH-70;y,65;
				strokecolor,Color("Outline");zoom,0.5;skewx,-0.13;diffuse,Color("Blue");
				settextf,"THEME:%s",name);
		};
		--[[
		LoadActor(THEME:GetPathG("_ScreenWithMenuElements","info"))..{
			InitCommand=cmd(blend,"BlendMode_Add";horizalign,right;
				x,SCREEN_WIDTH-70;y,80;diffuse,Color("Blue"););
		};
		--]]
		LoadFont("Common normal")..{
			InitCommand=function(self)
				(cmd(blend,"BlendMode_Add";horizalign,center;
					x,SCREEN_WIDTH-70;y,78;
					strokecolor,Color("Outline");zoom,0.75;skewx,-0.13;diffuse,Color("Blue");))(self);
				self:settextf("ver,%s %s",version,vertype);
			end;
		};
	};
else
	t=Def.ActorFrame{};
end;
return t;

