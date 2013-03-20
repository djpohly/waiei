local t = Def.ActorFrame {};
local tcol=GetUserPref_Theme("UserColorPath");
t[#t+1] = Def.ActorFrame {
--[[
	LoadActor(THEME:GetPathB("ScreenWithMenuElements","background/_grid")).. {
		InitCommand=cmd(customtexturerect,0,0,(SCREEN_WIDTH+1)/4,SCREEN_HEIGHT/4;SetTextureFiltering,true);
		OnCommand=cmd(zoomto,SCREEN_WIDTH+1,SCREEN_HEIGHT;diffuse,Color("Black");diffuseshift;effecttiming,(1/8)*4,0,(7/8)*4,0;effectclock,'beatnooffset';
		effectcolor2,Color("Black");effectcolor1,Colors.Alpha(Color("Black"),0.45);fadebottom,0.25;fadetop,0.25;croptop,48/480;cropbottom,48/480;diffusealpha,0.345);
	}; --]]
	LoadActor(THEME:GetPathB("ScreenWithMenuElements","background/"..tcol.."_bg top")) .. {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH+1,SCREEN_HEIGHT;Center);
		OffCommand=cmd(diffusealpha,1;linear,0.5;diffusealpha,0);
	};

};

return t