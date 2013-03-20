local t=Def.ActorFrame{};
local song=_SONG();
if not song then
	return t;
end;
local hasJorC=true;--HasJacket_a1(song) or GetCDImagePath_a1(song);
local g="";
if GetUserPref_Theme("UserWheelMode") == 'Jacket->Banner' then
	g=GetSongGPath_JBN(song);
elseif GetUserPref_Theme("UserWheelMode") == 'Jacket->BG' then
	g=GetSongGPath_JBG(song);
elseif GetUserPref_Theme("UserWheelMode") == 'Banner->Jacket' then
	g=GetSongGPath_BNJ(song);
elseif GetUserPref_Theme("UserWheelMode") == 'Text' then
	g=GetSongGPath_JBN(song);
else
	g=GetSongGPath_JBN(song);
end;

if hasJorC then
	-- [ja]曲終了時のジャケット表示
	t[#t+1]=Def.ActorFrame{
		Def.Sprite{
			InitCommand=cmd(diffusealpha,0;);
			OnCommand=function(self)
				self:LoadBackground(g);
				self:rate(0.5);
				self:scaletofit(0,0,484,484);
				self:Center();
				self:diffuse(0,0,0,0);
				self:linear(0.8);
				self:scaletofit(0,0,364,364);
				self:Center();
				self:diffuse(0,0,0,0.5);
			end;
		};
		Def.Sprite{
			InitCommand=cmd(diffusealpha,0;);
			OnCommand=function(self)
				self:LoadBackground(g);
				self:rate(0.5);
				self:scaletofit(0,0,480,480);
				self:Center();
				self:diffusealpha(0);
				self:linear(0.5);
				self:scaletofit(0,0,360,360);
				self:Center();
				self:diffusealpha(1);
			end;
		};
	}
end;

return t;