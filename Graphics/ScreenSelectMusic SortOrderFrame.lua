return Def.ActorFrame {
	LoadActor(THEME:GetPathG("OptionRowExit","frame")) .. {
		InitCommand=cmd(diffusebottomedge,Color("Yellow");x,8;);
	};
	--[[
	LoadActor(THEME:GetPathG("_icon","Sort")) .. {
		InitCommand=cmd(x,-60;shadowlength,1;diffuse,Color("Orange");diffusetopedge,Color("Yellow"));
	};
	--]]
};