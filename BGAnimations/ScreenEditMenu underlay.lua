local t = Def.ActorFrame {
   InitCommand=cmd(fov,90);
};
t[#t+1] = Def.ActorFrame {
  InitCommand=cmd(Center);
	LoadActor(THEME:GetPathG("ScreenOptions","page"));
};

return t;
