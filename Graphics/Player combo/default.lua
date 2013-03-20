local c;
local cf;
local haishin=GetUserPref_Theme("UserHaishin");
local canAnimate = false;
local player = Var "Player";
local lsatWorstJudge={0,0};
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt");
local MinCombo_=GetUserPref_Theme("UserMinCombo");
local MinCombo=(MinCombo_=='TapNoteScore_W3') and 3 or ((MinCombo_=='TapNoteScore_W1') and 1 or ((MinCombo_=='TapNoteScore_W2') and 2 or 4));
local Pulse = ((haishin=="Off") and THEME:GetMetric("Combo", "PulseCommand") or THEME:GetMetric("HaishinCombo", "PulseCommand"));
local PulseLabel = ((haishin=="Off") and THEME:GetMetric("Combo", "PulseLabelCommand") or THEME:GetMetric("HaishinCombo", "PulseLabelCommand"));

local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom");
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom");
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt");

local LabelMinZoom = THEME:GetMetric("Combo", "LabelMinZoom");
local LabelMaxZoom = THEME:GetMetric("Combo", "LabelMaxZoom");

local ShowFlashyCombo = GetUserPrefB("UserPrefFlashyCombo")

local p=((player=='PlayerNumber_P1') and 1 or 2);

local t = Def.ActorFrame {}
local comboCBS={0,0};
local comboSAVE={0,0};
-- cbsfdir = ComboContinuesBetweenSongsFlagDir
local cbsfdir={
	""..(PROFILEMAN:GetProfileDir('ProfileSlot_Player1')).."ComboContinuesBetweenSongs.cfg",
	""..(PROFILEMAN:GetProfileDir('ProfileSlot_Player2')).."ComboContinuesBetweenSongs.cfg"};

t[#t+1]=Def.ActorFrame {
	Def.Quad{
		InitCommand=function(self)
			self:visible(false);
			if GetUserPref_Theme("UserComboContinuesBetweenSongs")
				and IsHumanPlayer(param.Player) then
				if FILEMAN:DoesFileExist(cbsfdir[p]) then
					local f=RageFileUtil.CreateRageFile();
					f:Open(cbsfdir[p],1);
					comboCBS[p]=f:Read();
					f:Close();
					f:destroy();
				else
					comboCBS[p]=0;
				end;
			else
				comboCBS[p]=0;
			end;
		end;
		ComboCommand=function(self, param)
			comboSAVE[p]=param.Combo;
		end;
		JudgmentMessageCommand = function(self, param)
			if (param.Player==PLAYER_1 and p==1) or (param.Player==PLAYER_2 and p==2) then
				if param.TapNoteScore=='TapNoteScore_CheckpointMiss' 
					or (param.TapNoteScore=='TapNoteScore_W2' and MinCombo<2) 
					or (param.TapNoteScore=='TapNoteScore_W3' and MinCombo<3) 
					or (param.TapNoteScore=='TapNoteScore_W4' and MinCombo<4) 
					or param.TapNoteScore=='TapNoteScore_W5' 
					or param.TapNoteScore=='TapNoteScore_Miss' then
					comboCBS[p]=0;
					comboSAVE[p]=0;
				end;
			end;
		end;
		OffCommand=function(self)
			if IsHumanPlayer(param.Player) then
				if STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetFailed() then
					comboCBS[p]=0;
					comboSAVE[p]=0;
				end;
				local f=RageFileUtil.CreateRageFile();
				f:Open(cbsfdir[p],2);
				f:Write(""..(comboCBS[p]+comboSAVE[p]));
				f:Close();
				f:destroy();
			end;
		end;
	};
};
t[#t+1]=Def.ActorFrame {
	InitCommand=cmd(vertalign,bottom);
	-- flashy combo elements:
 	LoadActor(THEME:GetPathG("Combo","100Milestone")) .. {
		Name="OneHundredMilestone";
		InitCommand=cmd(visible,ShowFlashyCombo);
		FiftyMilestoneCommand=cmd(playcommand,"Milestone");
	};
	LoadActor(THEME:GetPathG("Combo","1000Milestone")) .. {
		Name="OneThousandMilestone";
		InitCommand=cmd(visible,ShowFlashyCombo);
		ToastyAchievedMessageCommand=cmd(playcommand,"Milestone");
	};
	-- normal combo elements:
	Def.ActorFrame {
		Name="ComboFrame";
		LoadFont( "Combo", "numbers" ) .. {
			Name="Number";
			OnCommand = THEME:GetMetric("Combo", "NumberOnCommand");
		};
		LoadFont("Common Normal") .. {
			Name="Label";
			OnCommand = THEME:GetMetric("Combo", "LabelOnCommand");
		};
	};
	InitCommand = function(self)
		c = self:GetChildren();
		cf = c.ComboFrame:GetChildren();
		cf.Number:visible(false);
		cf.ComboLabel:visible(false)
		cf.MissLabel:visible(false)
		lsatWorstJudge[1]=0;
		lsatWorstJudge[2]=0;
	end;
	OffCommand=function(self)
		c = self:GetChildren();
		cf = c.ComboFrame:GetChildren();
		(cmd(stoptweening;sleep,0.3;linear,0.2;diffusealpha,0;))(cf.Number);
		(cmd(stoptweening;sleep,0.3;linear,0.2;diffusealpha,0;))(cf.Label);
	end;
	-- Milestones:
	-- 25,50,100,250,600 Multiples;
--[[ 		if (iCombo % 100) == 0 then
			c.OneHundredMilestone:playcommand("Milestone");
		elseif (iCombo % 250) == 0 then
			-- It should really be 1000 but thats slightly unattainable, since
			-- combo doesnt save over now.
			c.OneThousandMilestone:playcommand("Milestone");
		else
			return
 	TwentyFiveMilestoneCommand=function(self,parent)
		if ShowFlashyCombo then
			(cmd(finishtweening;addy,-4;bounceend,0.125;addy,4))(self);
		end;
	end;
	--]]
	--[[
	ToastyAchievedMessageCommand=function(self,params)
		if params.PlayerNumber == player then
			(cmd(thump,2;effectclock,'beat'))(c.ComboFrame);
		end;
	end;
	ToastyDroppedMessageCommand=function(self,params)
		if params.PlayerNumber == player then
			(cmd(stopeffect))(c.ComboFrame);
		end;
	end; --]]
	JudgmentMessageCommand = function(self, params)
		if not params.HoldNoteScore then
			if (params.Player==PLAYER_1 and p==1) or (params.Player==PLAYER_2 and p==2) then
				if params.FullComboW1 or (params.TapNoteScore=='TapNoteScore_W1' and lsatWorstJudge[p]<1) then
					lsatWorstJudge[p]=1;
				elseif (params.FullComboW2 or (params.TapNoteScore=='TapNoteScore_W2' and lsatWorstJudge[p]<2)) and MinCombo>=2 then
					lsatWorstJudge[p]=2;
				elseif (params.FullComboW3 or (params.TapNoteScore=='TapNoteScore_W3' and lsatWorstJudge[p]<3)) and MinCombo>=3 then
					lsatWorstJudge[p]=3;
				elseif (params.FullComboW4 or (params.TapNoteScore=='TapNoteScore_W4' and lsatWorstJudge[p]<4)) and MinCombo>=4 then
					lsatWorstJudge[p]=4;
				elseif params.TapNoteScore=='TapNoteScore_CheckpointMiss' 
					or (params.TapNoteScore=='TapNoteScore_W2' and MinCombo<2) 
					or (params.TapNoteScore=='TapNoteScore_W3' and MinCombo<3) 
					or (params.TapNoteScore=='TapNoteScore_W4' and MinCombo<4) 
					or params.TapNoteScore=='TapNoteScore_W5' 
					or params.TapNoteScore=='TapNoteScore_Miss' then
					lsatWorstJudge[p]=1;
				end;
			end;
		end;
	end;
	ComboCommand=function(self, param)
		local iCombo = param.Misses or param.Combo;
		if not iCombo or (iCombo+comboCBS[p]) < ShowComboAt then
			cf.Number:visible(false);
			cf.Label:visible(false)
			return;
		end

		local labeltext = "";
		if param.Combo then
			labeltext = "COMBO";
-- 			c.Number:playcommand("Reset");
			if param.FullComboW1 then
				cf.Label:diffuse( GameColor.Judgment["JudgmentLine_W1"]);
			elseif param.FullComboW2 and MinCombo>=2 then
				cf.Label:diffuse( GameColor.Judgment["JudgmentLine_W2"]);
			elseif param.FullComboW3 and MinCombo>=3 then
				cf.Label:diffuse( GameColor.Judgment["JudgmentLine_W3"]);
			elseif param.FullComboW4 and MinCombo>=4 then
				cf.Label:diffuse( BoostColor(GameColor.Judgment["JudgmentLine_W4"],1.25));
			elseif param.Combo then
				cf.Label:diffuse(Color("White"));
			else
				cf.Label:diffuse(color("#ff0000"));
			end
		else
			labeltext = "MISSES";
			cf.Label:diffuse(color("#ff0000"));
-- 			c.Number:playcommand("Miss");
		end
		cf.Label:settext( labeltext );
		cf.Label:visible(false);
		
		local DrawMaxZoom=((param.Combo<1000) and NumberMaxZoom or NumberMaxZoom*0.8);

		param.Zoom = scale( iCombo, 0, NumberMaxZoomAt, NumberMinZoom, DrawMaxZoom );
		param.Zoom = clamp( param.Zoom, NumberMinZoom, DrawMaxZoom );

		param.LabelZoom = scale( iCombo, 0, NumberMaxZoomAt, LabelMinZoom, LabelMaxZoom );
		param.LabelZoom = clamp( param.LabelZoom, LabelMinZoom, LabelMaxZoom );

		cf.Label:visible(true);

		cf.Number:finishtweening();
		cf.Number:visible(true);
		cf.Number:settext( string.format("%i", (iCombo+comboCBS[p])) );
		-- FullCombo Rewards
		if param.Combo and lsatWorstJudge[p]==1 then
			cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W1"] );
		elseif param.Combo and lsatWorstJudge[p]==2 then
			cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W2"] );
			cf.Number:glowshift();
		elseif param.Combo and lsatWorstJudge[p]==3 then
			cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W3"] );
			cf.Number:glowshift();
		elseif param.Combo and lsatWorstJudge[p]==4 then
			cf.Number:diffuse( BoostColor(GameColor.Judgment["JudgmentLine_W4"],1.25));
			cf.Number:glowshift();
		elseif param.Combo then
			cf.Number:diffuse(Color("White"));
			cf.Number:stopeffect();
		else
			cf.Number:diffuse(color("#ff0000"));
			cf.Number:stopeffect();
		end
		-- Pulse
		Pulse( cf.Number, param );
		PulseLabel( cf.Label, param );
		-- Milestone Logic
	end;
--[[ 	ScoreChangedMessageCommand=function(self,param)
		local iToastyCombo = param.ToastyCombo;
		if iToastyCombo and (iToastyCombo > 0) then
-- 			(cmd(thump;effectmagnitude,1,1.2,1;effectclock,'beat'))(c.Number)
-- 			(cmd(thump;effectmagnitude,1,1.2,1;effectclock,'beat'))(c.Number)
		else
-- 			c.Number:stopeffect();
		end;
	end; --]]
};

return t;
