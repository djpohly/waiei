local detailsFlag=0;
local song;
local det_topgrade;
local det_score=0;
local det_taps=0;
local det_holds=0;
local det_w1=0;
local det_w2=0;
local det_w3=0;
local det_wo=0;
local detAlpha=0.0;
local details=Def.ActorFrame{
	InitCommand=cmd(Center;);
	Def.Quad{
		Name="detBg";
		CodeMessageCommand = function(self, params)
			if params.Name=="ViewScore" then
				detailsFlag=1-detailsFlag;
			end;
		end;
		InitCommand=cmd(player,PLAYER_1;x,SCREEN_LEFT;y,SCREEN_CENTER_Y;
							zoomto,280,300;horizalign,left;diffuse,0,0,0,0;);
		SetCommand=function(self)
			self:finishtweening();
			self:sleep(0.5);
			self:queuecommand("Load");
		end;
		LoadCommand=function(self)
			det_score=0;
			det_taps=0;
			det_holds=0;
			det_w1=0;
			det_w2=0;
			det_w3=0;
			det_wo=0;
			song=GAMESTATE:GetCurrentSong();
			local st=GAMESTATE:GetCurrentStyle():GetStepsType();
			local diff=GAMESTATE:GetCurrentSteps(PLAYER_1):GetDifficulty();
			if song then
				if song:HasStepsTypeAndDifficulty(st,diff) then
					local steps = song:GetOneSteps( st, diff );
					if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
						-- player profile
						profile = PROFILEMAN:GetProfile(PLAYER_1);
					else
						-- machine profile
						profile = PROFILEMAN:GetMachineProfile();
					end;
					scorelist = profile:GetHighScoreList(song,steps);
					local scores = scorelist:GetHighScores();
					assert(scores);
					if scores[1] then
						det_topgrade = scores[1]:GetGrade();
						det_score=scores[1]:GetScore();
						det_w1=scores[1]:GetTapNoteScore('TapNoteScore_W1');
						det_w2=scores[1]:GetTapNoteScore('TapNoteScore_W2');
						det_w3=scores[1]:GetTapNoteScore('TapNoteScore_W3');
						det_wo=scores[1]:GetHoldNoteScore('HoldNoteScore_Held');
						det_taps=GAMESTATE:GetCurrentSteps(PLAYER_1):GetRadarValues(PLAYER_1):GetValue('RadarCategory_TapsAndHolds');
						det_holds=GAMESTATE:GetCurrentSteps(PLAYER_1):GetRadarValues(PLAYER_1):GetValue('RadarCategory_Holds')
							+GAMESTATE:GetCurrentSteps(PLAYER_1):GetRadarValues(PLAYER_1):GetValue('RadarCategory_Rolls');
					end;
				end;
			end;
			if det_taps<=0 then
				det_taps=1;
			end;
			if det_holds<=0 then
				det_holds=1;
			end;
			self:visible((detAlpha>0.0) and 1 or 0);
		end;
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	};
	LoadFont("common normal")..{
		Name="labelW1";
		InitCommand=cmd(player,PLAYER_1;x,SCREEN_LEFT+10;y,SCREEN_CENTER_Y-100;
			diffuse,GameColor.Judgment["JudgmentLine_W1"];horizalign,left;
			strokecolor,Color("Outline"););
		SetCommand=function(self)
			self:finishtweening();
			self:diffusealpha(0);
			self:sleep(0.5);
			self:queuecommand("Load");
		end;
		LoadCommand=function(self)
			self:settextf("%s\n %4d (%2.1f%%)",
				string.upper(_JudgementLabel('JudgmentLine_W1')),
				det_w1,100.0*det_w1/det_taps);
			self:visible((detAlpha>0.0) and 1 or 0);
		end;
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	};
	LoadFont("common normal")..{
		Name="labelW2";
		InitCommand=cmd(player,PLAYER_1;x,SCREEN_LEFT+10;y,SCREEN_CENTER_Y-40;
			diffuse,GameColor.Judgment["JudgmentLine_W2"];horizalign,left;
			strokecolor,Color("Outline"););
		SetCommand=function(self)
			self:finishtweening();
			self:diffusealpha(0);
			self:sleep(0.5);
			self:queuecommand("Load");
		end;
		LoadCommand=function(self)
			self:settextf("%s\n %4d (%2.1f%%)",
				string.upper(_JudgementLabel('JudgmentLine_W2')),
				det_w2,100.0*det_w2/det_taps);
			self:visible((detAlpha>0.0) and 1 or 0);
		end;
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	};
	LoadFont("common normal")..{
		Name="labelW3";
		InitCommand=cmd(player,PLAYER_1;x,SCREEN_LEFT+10;y,SCREEN_CENTER_Y+20;
			diffuse,GameColor.Judgment["JudgmentLine_W3"];horizalign,left;
			strokecolor,Color("Outline"););
		SetCommand=function(self)
			self:finishtweening();
			self:diffusealpha(0);
			self:sleep(0.5);
			self:queuecommand("Load");
		end;
		LoadCommand=function(self)
			self:settextf("%s\n %4d (%2.1f%%)",
				string.upper(_JudgementLabel('JudgmentLine_W3')),
				det_w3,100.0*det_w3/det_taps);
			self:visible((detAlpha>0.0) and 1 or 0);
		end;
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	};
	LoadFont("common normal")..{
		Name="labelWO";
		InitCommand=cmd(player,PLAYER_1;x,SCREEN_LEFT+10;y,SCREEN_CENTER_Y+80;
			diffuse,GameColor.Judgment["JudgmentLine_Held"];horizalign,left;
			strokecolor,Color("Outline"););
		SetCommand=function(self)
			self:finishtweening();
			self:diffusealpha(0);
			self:sleep(0.5);
			self:queuecommand("Load");
		end;
		LoadCommand=function(self)
			self:settextf("OK\n %4d (%2.1f%%)",det_wo,100.0*det_wo/det_holds);
			self:visible((detAlpha>0.0) and 1 or 0);
		end;
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	};
}
local function detailsUpdate(self)
	local mY=INPUTFILTER:GetMouseY();
	local detbg=self:GetChild("detBg");
	local detw1=self:GetChild("labelW1");
	local detw2=self:GetChild("labelW2");
	local detw3=self:GetChild("labelW3");
	local detwo=self:GetChild("labelWO");
	if detailsFlag==1 then
		if detAlpha<1.0 then
			detAlpha=detAlpha+0.05;
		end;
	else
		if detAlpha>0.0 then
			detAlpha=detAlpha-0.05;
		end;
	end;
	if detAlpha>0 then
		detbg:visible(1);
		detbg:diffuse(0,0,0,detAlpha*4/5);
		detbg:diffuserightedge(0,0,0,0);
		detw1:visible(1);
		detw1:diffusealpha(detAlpha);
		detw2:visible(1);
		detw2:diffusealpha(detAlpha);
		detw3:visible(1);
		detw3:diffusealpha(detAlpha);
		detwo:visible(1);
		detwo:diffusealpha(detAlpha);
	else
		detbg:visible(0);
		detw1:visible(0);
		detw2:visible(0);
		detw3:visible(0);
		detwo:visible(0);
	end;
end;
details.InitCommand=cmd(SetUpdateFunction,detailsUpdate);
--[[

local mou = Def.ActorFrame{
	LoadFont("common normal")..{
		Name="Coords";
		InitCommand=cmd(align,0,0;x,SCREEN_LEFT+8;y,SCREEN_BOTTOM-48);
	};
};
local function UpdateMouse(self)
	local coords = self:GetChild("Coords")
	local mouseX = INPUTFILTER:GetMouseX()
	local mouseY = INPUTFILTER:GetMouseY()
	local mouseW = INPUTFILTER:GetMouseWheel()
	local text = "[Mouse] X: ".. mouseX .." Y: ".. mouseY .." W: ".. mouseW;
	--coords:settext(text);
end
mou.InitCommand=cmd(SetUpdateFunc
--]]
return details;