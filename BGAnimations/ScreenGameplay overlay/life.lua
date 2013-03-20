local t=Def.ActorFrame{};

local tcol=GetUserPref_Theme("UserColorPath");

local lifeWidth=SCREEN_WIDTH/4;
--[[
if lifeWidth>=200 then
	lifeWidth=200;
end;
--]]

t[#t+1]=Def.ActorFrame{
	LoadActor(THEME:GetPathG("_LifeMeterBar/"..tcol.."LifeMeterBar","bottom"))..{
		InitCommand=cmd(vertalign,bottom;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;);
		OnCommand=cmd(diffusealpha,0;sleep,0.25;zoomx,2;zoomy,0;linear,0.25;zoomx,1;zoomy,1;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.5;linear,0.25;diffusealpha,0);
	};
};
t[#t+1]=Def.ActorFrame{
	LoadActor(THEME:GetPathG("_LifeMeterBar/"..tcol.."LifeMeterBar","under1"))..{
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X;y,10;);
		OnCommand=cmd(diffusealpha,0;sleep,0.25;addx,-100;linear,0.25;addx,100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.5;linear,0.25;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("_LifeMeterBar/LifeMeterBar","Difficulty"))..{
		InitCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:player(PLAYER_1);
			local song = GAMESTATE:GetCurrentSong();
			if song then
				local dif=GAMESTATE:GetCurrentSteps(PLAYER_1):GetDifficulty();
				self:diffuse(_DifficultyCOLOR(dif));
			else
				self:diffuse(CustomDifficultyToColor("Difficulty_Edit"));
			end;
			(cmd(horizalign,right;vertalign,bottom;
					x,SCREEN_CENTER_X-lifeWidth-lifeWidth/4-SCREEN_WIDTH/16+40;y,SCREEN_BOTTOM-46;))(self);
		end;
		OnCommand=cmd(diffusealpha,0;addx,-100;sleep,0.5;linear,0.25;addx,100;diffusealpha,1;);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addx,-100;diffusealpha,0);
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
	};
	LoadActor(THEME:GetPathG("_LifeMeterBar/"..tcol.."LifeMeterBar","under2"))..{
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X-lifeWidth-lifeWidth/4-SCREEN_WIDTH/16;y,10;);
		OnCommand=cmd(diffusealpha,0;addy,-100;sleep,0.5;linear,0.25;addy,100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addy,-100;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("_LifeMeterBar/"..tcol.."LifeMeterBar","under3"))..{
		InitCommand=cmd(horizalign,right;vertalign,bottom;x,SCREEN_CENTER_X-lifeWidth-lifeWidth/4-SCREEN_WIDTH/16;y,SCREEN_BOTTOM-10;);
		OnCommand=cmd(diffusealpha,0;addy,100;sleep,0.5;linear,0.25;addy,-100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addy,100;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("_LifeMeterBar/"..tcol.."LifeMeterBar","underL"))..{
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X;y,10;blend,"BlendMode_Add");
		OnCommand=cmd(diffusealpha,0;sleep,1.25;diffusealpha,1;linear,2;diffusealpha,0.5);
		OffCommand=cmd(diffusealpha,0.5;sleep,0.25;linear,0.25;diffusealpha,0);
	};
};
t[#t+1]=Def.ActorFrame{
	LoadActor(THEME:GetPathG("_LifeMeterBar/"..tcol.."LifeMeterBar","under1"))..{
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X;y,10;rotationy,180);
		OnCommand=cmd(diffusealpha,0;sleep,0.25;addx,100;linear,0.25;addx,-100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.5;linear,0.25;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("_LifeMeterBar/LifeMeterBar","Difficulty"))..{
		InitCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:player(PLAYER_2);
			local song = GAMESTATE:GetCurrentSong();
			if song then
				local dif=GAMESTATE:GetCurrentSteps(PLAYER_2):GetDifficulty();
				self:diffuse(_DifficultyCOLOR(dif));
			else
				self:diffuse(CustomDifficultyToColor("Difficulty_Edit"));
			end;
			(cmd(horizalign,right;vertalign,bottom;
					x,SCREEN_CENTER_X+lifeWidth+lifeWidth/4+SCREEN_WIDTH/16-40;y,SCREEN_BOTTOM-46;rotationy,180))(self);
		end;
		OnCommand=cmd(diffusealpha,0;addx,100;
						sleep,0.5;linear,0.25;addx,-100;diffusealpha,1;);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addx,100;diffusealpha,0);
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
	};
	LoadActor(THEME:GetPathG("_LifeMeterBar/"..tcol.."LifeMeterBar","under2"))..{
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X+lifeWidth+lifeWidth/4+SCREEN_WIDTH/16;y,10;rotationy,180);
		OnCommand=cmd(diffusealpha,0;addy,-100;sleep,0.5;linear,0.25;addy,100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addy,-100;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("_LifeMeterBar/"..tcol.."LifeMeterBar","under3"))..{
		InitCommand=cmd(horizalign,right;vertalign,bottom;x,SCREEN_CENTER_X+lifeWidth+lifeWidth/4+SCREEN_WIDTH/16;y,SCREEN_BOTTOM-10;rotationy,180);
		OnCommand=cmd(diffusealpha,0;addy,100;sleep,0.5;linear,0.25;addy,-100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addy,100;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("_LifeMeterBar/"..tcol.."LifeMeterBar","underL"))..{
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X;y,10;blend,"BlendMode_Add";rotationy,180);
		OnCommand=cmd(diffusealpha,0;sleep,1.25;diffusealpha,1;linear,2;diffusealpha,0.5);
		OffCommand=cmd(diffusealpha,0.5;sleep,0.25;linear,0.25;diffusealpha,0);
	};
};

t[#t+1] = LoadActor("ready");
--t[#t+1] = LoadActor(THEME:GetPathG("LifeMeter","BarP1"));
t[#t+1]=StandardDecorationFromFileOptional("LifeMeterBarP1","LifeMeterBarP1");
t[#t+1]=StandardDecorationFromFileOptional("LifeMeterBarP2","LifeMeterBarP2");

return t;