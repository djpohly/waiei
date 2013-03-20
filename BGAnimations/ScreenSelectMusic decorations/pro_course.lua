local t=Def.ActorFrame{};
t[#t+1]=Def.ActorFrame{
	LoadActor("list_bottom")..{
		InitCommand=cmd(vertalign,top;y,65);
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
	};
};
for pn in ivalues(PlayerNumber) do
t[#t+1]=Def.ActorFrame{
	LoadActor("list_dif")..{
		InitCommand=function(self)
			self:vertalign(top);
			self:y(65);
			self:horizalign(right);
			if pn=='PlayerNumber_P2' then
				self:rotationy(180);
			end;
		end;
		SetCommand=function(self)
			self:player(pn);
			local course = GAMESTATE:GetCurrentCourse();
			if course then
				local st=GAMESTATE:GetCurrentTrail(pn);
				local diff=st:GetDifficulty();
				self:diffuse(CustomDifficultyToColor(diff));
			else
				self:diffuse(CustomDifficultyToColor("Difficulty_Edit"));
			end;
		end;
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
		PlayerJoinedMessageCommand=cmd(playcommand,"Set");
	};
	LoadFont("Common normal")..{
		InitCommand=function(self)
			self:vertalign(top);
			self:y(78);
			self:zoom(1);
			if pn=='PlayerNumber_P1' then
				self:horizalign(left);
				self:x(-275);
			else
				self:horizalign(right);
				self:x(275);
			end;
		end;
		SetCommand=function(self)
			local course = GAMESTATE:GetCurrentCourse();
			if course then
				local st=GAMESTATE:GetCurrentTrail(pn);
				local diff=st:GetDifficulty();
				self:diffuse(ColorLightTone2(CustomDifficultyToColor(diff)));
				self:strokecolor(ColorDarkTone(CustomDifficultyToColor(diff)));
				self:settextf("%s",string.upper(ToEnumShortString(diff)));
			else
				self:diffuse(CustomDifficultyToLightColor("Difficulty_Edit"));
				self:strokecolor(CustomDifficultyToDarkColor("Difficulty_Edit"));
				self:settext("FOLDER");
			end;
		end;
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
		PlayerJoinedMessageCommand=cmd(playcommand,"Set");
	};
	--[[
	LoadFont("Common normal")..{
		InitCommand=function(self)
			self:vertalign(top);
			self:y(74);
			self:maxwidth(24);
			if pn=='PlayerNumber_P1' then
				self:horizalign(right);
				self:x(-260);
			else
				self:horizalign(right);
				self:x(260+22);
			end;
		end;
		SetCommand=function(self)
			self:player(pn);
			local song = GAMESTATE:GetCurrentSong();
			if song then
				local st=GAMESTATE:GetCurrentSteps(pn);
				local dif=st:GetDifficulty();
				self:diffuse(CustomDifficultyToLightColor(""..dif));
				self:strokecolor(CustomDifficultyToDarkColor(""..dif));
				self:settextf("%d",st:GetMeter());
			else
				self:diffuse(CustomDifficultyToLightColor("Difficulty_Edit"));
				self:strokecolor(CustomDifficultyToDarkColor("Difficulty_Edit"));
				self:settext("--");
			end;
		end;
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
		PlayerJoinedMessageCommand=cmd(playcommand,"Set");
	};
	--]]
};
end;
return t;
