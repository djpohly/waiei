local tcol,haishin,basezoom=...;

if not GAMESTATE:IsCourseMode() then return Def.ActorFrame{} end; -- short circuit
local course = GAMESTATE:GetCurrentCourse()

local t = Def.ActorFrame{
	-- background
	Def.Sprite {
		InitCommand=cmd(Center);
		BeginCommand=cmd(LoadFromCurrentSongBackground);
		OnCommand=function(self)
			self:diffusealpha(PREFSMAN:GetPreference("BGBrightness"));
			self:scale_or_crop_background();
		end;
	};
};

return t;