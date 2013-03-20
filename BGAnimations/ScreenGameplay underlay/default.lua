if GetUserPref_Theme("UserHaishin") ~= nil then
	haishin = GetUserPref_Theme("UserHaishin");
else
	haishin = 'Off';
end;
local tcol=GetUserPref_Theme("UserColorPath");

local t = Def.ActorFrame{};

if _SONG() and haishin=="On" then
local basezoom=0.42;
	t[#t+1]=Def.ActorFrame{
		FOV=60;
		InitCommand=cmd(Center);
		LoadActor(THEME:GetPathG("_Haishin","Mask"))..{
			BeginCommand=function(self)
				self:visible(true);
				local zx=basezoom*(0.75/(SCREEN_HEIGHT/SCREEN_WIDTH));
				if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
					self:x(SCREEN_WIDTH*basezoom/2-20*basezoom);
					self:rotationy(45);
				else
					self:x(-SCREEN_WIDTH*basezoom/2+20*basezoom);
					self:rotationy(-45);
				end;
				self:zoomx(zx);
				self:zoomy(basezoom);
			end;
		};
		Def.ActorProxy{
			BeginCommand=function(self)
				local bg = SCREENMAN:GetTopScreen():GetChild('SongBackground');
				self:SetTarget(bg);
				self:zoom(basezoom);
				self:halign(SCREEN_CENTER_X);
				self:valign(SCREEN_CENTER_Y);
				if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
					self:x(SCREEN_WIDTH*basezoom/2-20*basezoom);
					self:rotationy(45);
				else
					self:x(-SCREEN_WIDTH*basezoom/2+20*basezoom);
					self:rotationy(-45);
				end;
			end;
		};
		LoadActor(THEME:GetPathG("_Haishin","Mask"))..{
			BeginCommand=function(self)
				self:visible(true);
				local zx=basezoom*(0.75/(SCREEN_HEIGHT/SCREEN_WIDTH));
				if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
					self:x(SCREEN_WIDTH*basezoom/2-20*basezoom);
					self:rotationy(45);
				else
					self:x(-SCREEN_WIDTH*basezoom/2+20*basezoom);
					self:rotationy(-45);
				end;
				self:zoomx(zx);
				self:zoomy(basezoom);
				self:MaskSource();
			end;
		};
		Def.Quad{
			InitCommand=cmd(diffuse,Color("Black");zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;MaskDest;)
		};
		LoadActor(THEME:GetPathG(tcol.."_Haishin","Display"))..{
			BeginCommand=function(self)
				self:visible(true);
				local zx=basezoom*(0.75/(SCREEN_HEIGHT/SCREEN_WIDTH));
				if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
					self:x(SCREEN_WIDTH*basezoom/2-20*basezoom);
					self:rotationy(45);
				else
					self:x(-SCREEN_WIDTH*basezoom/2+20*basezoom);
					self:rotationy(-45);
				end;
				self:zoomx(zx);
				self:zoomy(basezoom);
			end;
		};
	};
end;

if _SONG() and haishin=="On" then
	t[#t+1]=Def.ActorFrame{
		Def.Sprite{
			InitCommand=function(self)
				local bn=SONGMAN:GetSongGroupBannerPath(_SONG():GetGroupName());
				if bn then
					self:Load(bn);
				end;
				self:scaletofit( 0,0,192,60 );
				self:y(SCREEN_HEIGHT*4/5-20);
				if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
					self:horizalign(left);
					self:x(SCREEN_WIDTH*3/5-70);
				else
					self:horizalign(right);
					self:x(SCREEN_WIDTH*2/5+70);
				end;
			end;
			OnCommand=function(self)
				self:diffusealpha(0);
				self:addy(10);
				self:linear(0.3);
				self:addy(-10);
				self:diffusealpha(1);
			end;
		};
	};
end;
t[#t+1]=Def.ActorFrame{
	LoadActor("ScreenFilter");
};

return t;