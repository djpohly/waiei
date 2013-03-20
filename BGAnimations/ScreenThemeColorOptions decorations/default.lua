local t=Def.ActorFrame{};

local tclist={""};
local tcname={"Blue (Defalut)"};
local sel_cur=1;
local sel_max=1;
local tcol=GetUserPref_Theme("UserColor") and GetUserPref_Theme("UserColor") or "Blue (Defalut)";

local f_tclist={};
f_tclist=FILEMAN:GetDirListing(THEME:GetCurrentThemeDirectory().."ThemeColors/");

for i=1,#f_tclist do
	local f=OpenFile(THEME:GetCurrentThemeDirectory().."ThemeColors/"..f_tclist[i]);
	tcname[#tcname+1]=""..split(".cfg",f_tclist[i])[1];
	tclist[#tclist+1]=""..f:GetLine().."/";
	CloseFile(f);
	if tcol==tcname[#tcname] then
		sel_cur=#tcname;
	end;
	sel_max=#tcname;
end;

local key_lock=true;

t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(Center;);
	OnCommand=cmd(addx,-100;linear,0.5;addx,100;queuecommand,"KeyUnlock";);
	KeyUnlockCommand=function(self)
		key_lock=false;
	end;
	CodeCommand=function(self,params)
		if not key_lock then
			if params.Name=="Start" or params.Name=="Center" then
				self:queuecommand("Save");
			elseif params.Name=="Left" or params.Name=="Left2" then
				sel_cur=sel_cur-1;
				if sel_cur<=0 then
					sel_cur=sel_max;
				end;
				self:queuecommand("Change");
			elseif params.Name=="Right" or params.Name=="Right2" then
				sel_cur=sel_cur+1;
				if sel_cur>sel_max then
					sel_cur=1;
				end;
				self:queuecommand("Change");
			end;
		end;
	end;
	SaveCommand=function(self)
		key_lock=true;
		SetUserPref_Theme("UserColor",tcname[sel_cur]);
		SetUserPref_Theme("UserColorPath",tclist[sel_cur]);
		self:sleep(0.5);
		self:queuecommand("NextScreen");
	end;
	NextScreenCommand=function(self)
		SCREENMAN:SetNewScreen("ScreenInit");
	end;

	LoadActor(THEME:GetPathS("Common","start")) .. {
		SaveCommand = function(self)
			self:stop();
			self:play();
		end;
	};
	LoadActor(THEME:GetPathS("Common","value")) .. {
		ChangeCommand = function(self)
			self:stop();
			self:play();
		end;
	};

	LoadActor(THEME:GetPathG("ScreenOptions","page"))..{
		OnCommand=cmd(diffusealpha,0;linear,0.5;diffusealpha,1;);
	};
	LoadActor(THEME:GetPathG("ScreenOptions","line highlight"))..{
		OnCommand=cmd(y,100;x,50;zoom,0.7;diffusealpha,0;linear,0.5;diffusealpha,1;);
	};
	LoadFont("Common Normal")..{
		OnCommand=cmd(y,98;x,70;zoom,1.1;queuecommand,"Change";diffusealpha,0;linear,0.5;diffusealpha,1;);
		ChangeCommand=cmd(maxwidth,180;settext," "..tcname[sel_cur];);
	};
	LoadFont("Common Normal")..{
		OnCommand=cmd(horizalign,right;y,98;x,-20;queuecommand,"Change";diffusealpha,0;linear,0.5;diffusealpha,1;);
		ChangeCommand=cmd(settext,""..sel_cur.."/"..sel_max.." ");
	};
	LoadFont("Common Normal")..{
		OnCommand=cmd(settext,THEME:GetString("ScreenThemeColorOptions","HelpText");y,175;zoom,0.8;diffusealpha,0;linear,0.5;diffusealpha,1;);
	};
	LoadActor(THEME:GetPathG("EditMenu","Left"))..{
		OnCommand=cmd(y,100;x,-120;zoom,0.5;diffusealpha,0;linear,0.5;diffusealpha,1;);
		ChangeCommand=cmd(zoom,0.7;linear,0.2;zoom,0.5;);
	};
	LoadActor(THEME:GetPathG("EditMenu","Left"))..{
		OnCommand=cmd(y,100;x,220;rotationy,180;zoom,0.5;diffusealpha,0;linear,0.5;diffusealpha,1;);
		ChangeCommand=cmd(zoom,0.7;linear,0.2;zoom,0.5;);
	};
	LoadActor(THEME:GetPathG("Common fallback","background"))..{
		OnCommand=cmd(scaletocover,-160,-80,160,80;x,50;y,-40;diffusealpha,0;linear,0.5;diffusealpha,1;);
	};
	Def.Sprite{
		OnCommand=cmd(zoom,0;queuecommand,"Change";diffusealpha,0;linear,0.5;diffusealpha,1;);
		ChangeCommand=function(self)
			self:Load(THEME:GetPathB("ScreenWithMenuElements","background/"..tclist[sel_cur].."_bg top"));
			self:scaletocover(-160,-80,160,80);
			self:x(50);
			self:y(-40);
		end;
	};
	Def.Sprite{
		OnCommand=cmd(horizalign,right;y,-120;x,50;zoom,0.5;cropleft,0.5;queuecommand,"Change";diffusealpha,0;linear,0.5;diffusealpha,1;);
		ChangeCommand=function(self)
			self:Load(THEME:GetPathG("_LifeMeterBar/"..tclist[sel_cur].."LifeMeterBar","under1"));
		end;
	};
	Def.Sprite{
		OnCommand=cmd(horizalign,right;y,-120;x,50;zoom,0.5;cropleft,0.5;rotationy,180;queuecommand,"Change";diffusealpha,0;linear,0.5;diffusealpha,1;);
		ChangeCommand=function(self)
			self:Load(THEME:GetPathG("_LifeMeterBar/"..tclist[sel_cur].."LifeMeterBar","under1"));
		end;
	};
	Def.Sprite{
		OnCommand=cmd(y,40;x,50;zoom,0.5;cropleft,0.25;cropright,0.25;queuecommand,"Change";diffusealpha,0;linear,0.5;diffusealpha,1;);
		ChangeCommand=function(self)
			self:Load(THEME:GetPathG("_LifeMeterBar/"..tclist[sel_cur].."LifeMeterBar","bottom"));
		end;
	};
	Def.Sprite{
		OnCommand=cmd(horizalign,right;y,-115;x,-50;zoom,0.5;cropleft,0.25;queuecommand,"Change";diffusealpha,0;linear,0.5;diffusealpha,1;);
		ChangeCommand=function(self)
			self:Load(THEME:GetPathG("_LifeMeterBar/"..tclist[sel_cur].."LifeMeterBar","under2"));
		end;
	};
	Def.Sprite{
		OnCommand=cmd(horizalign,right;y,-115;x,150;zoom,0.5;cropleft,0.25;rotationy,180;queuecommand,"Change";diffusealpha,0;linear,0.5;diffusealpha,1;);
		ChangeCommand=function(self)
			self:Load(THEME:GetPathG("_LifeMeterBar/"..tclist[sel_cur].."LifeMeterBar","under2"));
		end;
	};
	Def.Sprite{
		OnCommand=cmd(horizalign,right;y,35;x,-50;zoom,0.5;cropleft,0.25;queuecommand,"Change";diffusealpha,0;linear,0.5;diffusealpha,1;);
		ChangeCommand=function(self)
			self:Load(THEME:GetPathG("_LifeMeterBar/"..tclist[sel_cur].."LifeMeterBar","under3"));
		end;
	};
	Def.Sprite{
		OnCommand=cmd(horizalign,right;y,35;x,150;zoom,0.5;cropleft,0.25;rotationy,180;queuecommand,"Change";diffusealpha,0;linear,0.5;diffusealpha,1;);
		ChangeCommand=function(self)
			self:Load(THEME:GetPathG("_LifeMeterBar/"..tclist[sel_cur].."LifeMeterBar","under3"));
		end;
	};
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;blend,"BlendMode_Add";diffusealpha,0;);
		SaveCommand=cmd(linear,0.5;diffusealpha,1;);
	};
};

return t;