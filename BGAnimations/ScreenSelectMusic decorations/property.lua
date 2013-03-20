local t=Def.ActorFrame{};
t[#t+1]=Def.ActorFrame{
	LoadActor("list_bottom")..{
		InitCommand=cmd(vertalign,top;y,65);
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
	};
	Def.Quad{
		InitCommand=cmd(zoomto,1,24;diffuse,Color("White");
			vertalign,top;y,76;diffusealpha,0.5;rotationz,20;
			visible,GAMESTATE:GetNumPlayersEnabled()>1);
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		PlayerJoinedMessageCommand=cmd(playcommand,"Init");
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
			local song = GAMESTATE:GetCurrentSong();
			if song then
				local dif=GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
				self:diffuse(_DifficultyCOLOR(dif));
			else
				self:diffuse(CustomDifficultyToColor("Difficulty_Edit"));
			end;
		end;
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
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
	LoadFont("Common normal")..{
		InitCommand=function(self)
			self:vertalign(top);
			self:y(75);
			self:zoom(0.6);
			self:maxwidth(120);
			if pn=='PlayerNumber_P1' then
				self:horizalign(center);
				self:x(-245);
			else
				self:horizalign(center);
				self:x(245);
			end;
		end;
		SetCommand=function(self)
			self:player(pn);
			local song = GAMESTATE:GetCurrentSong();
			if song then
				local st=GAMESTATE:GetCurrentSteps(pn);
				local dif=st:GetDifficulty();
				self:diffuse(_DifficultyLightCOLOR(dif));
				self:strokecolor(ColorDarkTone(_DifficultyCOLOR(dif)));
				self:settextf("%s",string.upper(_DifficultyNAME(dif)));
			else
				self:diffuse(CustomDifficultyToLightColor("Difficulty_Edit"));
				self:strokecolor(CustomDifficultyToDarkColor("Difficulty_Edit"));
				self:settext("FOLDER");
			end;
		end;
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
		PlayerJoinedMessageCommand=cmd(playcommand,"Set");
	};
	LoadFont("Common normal")..{
		InitCommand=function(self)
			self:vertalign(top);
			self:y(75);
			self:zoom(0.6);
			if pn=='PlayerNumber_P1' then
				self:horizalign(center);
				self:x(-245);
			else
				self:horizalign(center);
				self:x(245);
			end;
		end;
		SetCommand=function(self)
			self:player(pn);
			local song = GAMESTATE:GetCurrentSong();
			local pdp=0.0;
			if song then
				local st=GAMESTATE:GetCurrentSteps(pn);
				local sty=GAMESTATE:GetCurrentStyle():GetStepsType();
				local dif=st:GetDifficulty();
				if song:HasStepsTypeAndDifficulty(sty,dif) then
					local steps = song:GetOneSteps( sty, dif );
					if PROFILEMAN:IsPersistentProfile(pn) then
						-- player profile
						profile = PROFILEMAN:GetProfile(pn);
					else
						-- machine profile
						profile = PROFILEMAN:GetMachineProfile();
					end;
					local scorelist = profile:GetHighScoreList(song,steps);
					local scores = scorelist:GetHighScores();
					if scores[1] then
						pdp=GetScoreData(scores,"dp");
					end;
				end;
				self:diffuse(_DifficultyLightCOLOR(dif));
				self:strokecolor(ColorDarkTone(_DifficultyCOLOR(dif)));
			else
				self:diffuse(CustomDifficultyToLightColor("Difficulty_Edit"));
				self:strokecolor(CustomDifficultyToDarkColor("Difficulty_Edit"));
			end;
			self:settextf("\n%3.2f%%",pdp*100);
		end;
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
		PlayerJoinedMessageCommand=cmd(playcommand,"Set");
	};
};
end;
return t;
