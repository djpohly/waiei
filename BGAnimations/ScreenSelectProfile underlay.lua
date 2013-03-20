local t = Def.ActorFrame {FOV=60;};
--[[
t[#t+1] = Def.ActorFrame {
  FOV=60;
	LoadActor(THEME:GetPathG("infomation/Infomation","Cube1")) .. {
		InitCommand=cmd(diffuse,ColorLightTone(color("#0064FF")););
		OnCommand=cmd(Center;zoom,SCREEN_HEIGHT/600;rotationy,-90;bounceend,0.5;rotationy,0;);
	};
};
--]]
return t