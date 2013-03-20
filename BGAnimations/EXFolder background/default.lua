local t = Def.ActorFrame {};
local haishin=GetUserPref_Theme("UserHaishin");
local tcol=GetUserPref_Theme("UserColorPath");

t[#t+1] = Def.ActorFrame {
	LoadActor(tcol.."bg",haishin);
};

return t;
