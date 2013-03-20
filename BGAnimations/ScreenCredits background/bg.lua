local t = Def.ActorFrame {};
local haishin=GetUserPref_Theme("UserHaishin");

t[#t+1] = Def.ActorFrame {
  FOV=60;
  InitCommand=cmd(Center;z,0);
  OnCommand=function(self)
	self:sleep(22.1);
	self:linear(0.5);
	self:addx(-100);
	self:addy(200);
	self:addz(SCREEN_HEIGHT);
	self:sleep(2.2);
	self:sleep(0.5);
	self:sleep(2.2);
	self:sleep(0.5);
	self:sleep(2.2);
	self:sleep(0.5);
	self:sleep(2.2);
	self:sleep(0.5);
	self:sleep(2.2);
	self:sleep(0.5);
	self:sleep(2.1);
	self:sleep(0.5);
	self:sleep(2.1);
	self:sleep(0.5);
	self:sleep(2.1);
	self:sleep(0.5);
	self:linear(75);
	self:addz(-SCREEN_HEIGHT);
	self:addx(100);
	self:addy(-200);
end;
--[[	LoadActor("../ScreenWithMenuElements background/line") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT*2;diffuse,ColorLightTone(color("#000080"));rotationy,-20;customtexturerect,0,0,SCREEN_WIDTH*1.5/48,SCREEN_HEIGHT*1.5/96);
		OnCommand=cmd(texcoordvelocity,(haishin=="Off") and 2 or 0,(haishin=="Off") and -0.2 or 0;
			diffuserightedge,0,0.4,0.8,0.2;bob;effectmagnitude,0.5,0,15;effectperiod,4);
		--bob;effectmagnitude,50,0,35;
	};--]]
	LoadActor("../ScreenWithMenuElements background/panel") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT*2;diffuse,ColorLightTone(color("#004080"));y,20;rotationy,-20;customtexturerect,0,0,SCREEN_WIDTH*1.5/480,SCREEN_HEIGHT*1.5/480);
		OnCommand=cmd(texcoordvelocity,(haishin=="Off") and 1 or 0,(haishin=="Off") and -0.05 or 0;diffuserightedge,0,0.15,0.3,0.5;);
		--bob;effectmagnitude,50,0,35;
	};
	LoadActor(THEME:GetPathG("information/information","Cube1")) .. {
		InitCommand=cmd(x,SCREEN_WIDTH;y,-200;zoom,200/SCREEN_HEIGHT;rotationy,30;
			diffuse,ColorLightTone(Color("Blue"));blend,'BlendMode_Add');
		OnCommand=function(self)
			self:linear(22.1);
			self:x(100);
			self:z(-SCREEN_HEIGHT);
			self:linear(0.5);
			self:zoom(300/SCREEN_HEIGHT);
			self:x(100);
			self:y(-200);
			self:rotationx(-20);
			self:rotationy(90-40);
			self:sleep(2.2);
			self:sleep(0.5);
			self:sleep(2.2);
			self:spring(0.5);
			self:rotationy(180-40);
			self:sleep(2.2);
			self:sleep(0.5);
			self:sleep(2.1);
			self:spring(0.5);
			self:rotationy(270-40);
			self:sleep(2.2);
			self:sleep(0.5);
			self:sleep(2.2);
			self:spring(0.5);
			self:rotationy(360-40);
			self:sleep(2.1);
			self:sleep(0.5);
			self:sleep(2.1);
			self:linear(0.5);
			self:y(-800);
			self:rotationx(60);
			self:linear(0.5);
		end;
		--bob;effectmagnitude,50,0,35;
	};
	LoadActor(THEME:GetPathG("_credits/credits","C-Cube")) .. {
		InitCommand=cmd(x,SCREEN_WIDTH;y,-200;zoom,200/SCREEN_HEIGHT;rotationy,30;);
		OnCommand=function(self)
			self:linear(22.1);
			self:x(100);
			self:z(-SCREEN_HEIGHT);
			self:linear(0.5);
			self:zoom(300/SCREEN_HEIGHT);
			self:x(100);
			self:y(-200);
			self:rotationx(-20);
			self:rotationy(90-40);
			self:sleep(2.2);
			self:sleep(0.5);
			self:sleep(2.2);
			self:spring(0.5);
			self:rotationy(180-40);
			self:sleep(2.2);
			self:sleep(0.5);
			self:sleep(2.1);
			self:spring(0.5);
			self:rotationy(270-40);
			self:sleep(2.2);
			self:sleep(0.5);
			self:sleep(2.2);
			self:spring(0.5);
			self:rotationy(360-40);
			self:sleep(2.1);
			self:sleep(0.5);
			self:sleep(2.1);
			self:linear(0.5);
			self:y(-800);
			self:rotationx(60);
			self:linear(0.5);
		end;
	};
	LoadActor(THEME:GetPathG("information/information","Circle1")) .. {
		InitCommand=cmd(x,-SCREEN_WIDTH;y,400;zoom,200/SCREEN_HEIGHT;rotationx,30;rotationy,30;
			diffuse,ColorLightTone(Color("Blue"));blend,'BlendMode_Add');
		OnCommand=function(self)
			self:linear(22.1);
			self:x(100);
			self:z(0);
			self:y(100);
			self:linear(0.5);
			self:zoom(300/SCREEN_HEIGHT);
			self:x(100);
			self:y(400);
			self:sleep(2.2);
			self:sleep(0.5);
			self:sleep(2.2);
			self:sleep(0.5);
			self:sleep(2.2);
			self:sleep(0.5);
			self:sleep(2.2);
			self:sleep(0.5);
			self:z(-SCREEN_HEIGHT);
			self:sleep(2.2);
			self:sleep(0.5);
			self:sleep(2.1);
			self:sleep(0.5);
			self:sleep(2.1);
			self:sleep(0.5);
			self:sleep(2.1);
			self:linear(0.5);
			self:y(-200);
			self:linear(85);
			self:rotationx(30+360*12);
			self:rotationx(30+360*12);
			self:addz(SCREEN_HEIGHT);
			self:x(0);
			self:y(-60);
		end;
		--bob;effectmagnitude,50,0,35;
	};
	LoadActor("../ScreenWithMenuElements background/fan_1") .. {
		InitCommand=cmd(y,120;zoom,1.5;rotationx,90;diffuse,ColorLightTone(color("#0064FF"));spin;effectmagnitude,0,0,20;blend,'BlendMode_Add');
	};
	LoadActor("../ScreenWithMenuElements background/_particleLoader") .. {
		InitCommand=cmd(x,-SCREEN_CENTER_X;y,-SCREEN_CENTER_Y);
		OnCommand=function(self)
			self:sleep(22.1);
			self:linear(0.5);
			self:addx(100);
			self:addy(-200);
			self:addz(-SCREEN_HEIGHT);
			self:sleep(22.6);
			self:linear(75);
			self:addx(-100);
			self:addy(200);
			self:addz(SCREEN_HEIGHT);
		end;
	};
	--[[
	LoadActor("../../../Default/BGAnimations/ScreenWithMenuElements background/_bg top") .. {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH+1,SCREEN_HEIGHT);
	};
	--]]
};

return t;
