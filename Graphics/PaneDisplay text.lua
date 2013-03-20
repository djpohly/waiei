local iPN = ...;
assert(iPN,"[Graphics/PaneDisplay text.lua] No PlayerNumber Provided.");

local t = Def.ActorFrame {};
local function GetRadarData( pnPlayer, rcRadarCategory )
	local tRadarValues;
	local StepsOrTrail;
	local fDesiredValue = 0;
	if GAMESTATE:GetCurrentSteps( pnPlayer ) then
		StepsOrTrail = GAMESTATE:GetCurrentSteps( pnPlayer );
		fDesiredValue = StepsOrTrail:GetRadarValues( pnPlayer ):GetValue( rcRadarCategory );
	elseif GAMESTATE:GetCurrentTrail( pnPlayer ) then
		StepsOrTrail = GAMESTATE:GetCurrentTrail( pnPlayer );
		fDesiredValue = StepsOrTrail:GetRadarValues( pnPlayer ):GetValue( rcRadarCategory );
	else
		StepsOrTrail = nil;
	end;
	return fDesiredValue;
end;

local function CreatePaneDisplayItem( _pnPlayer, _sLabel, _rcRadarCategory )
	return Def.ActorFrame {
		LoadFont("Common Normal") .. {
			Text=string.upper( THEME:GetString("PaneDisplay",_sLabel) );
			InitCommand=cmd(horizalign,left);
			OnCommand=cmd(zoom,0.5;diffuse,1,1,1,0.75;shadowlength,1);
		};
		LoadFont("Common Normal") .. {
			Text="000";
			InitCommand=cmd(x,32+8+8;horizalign,left);
			OnCommand=function(self)
				(cmd(zoom,0.5;shadowlength,1))(self);
				local song = GAMESTATE:GetCurrentSong()
				local course = GAMESTATE:GetCurrentCourse()
				if not song and not course then
					self:settext("000");
					self:diffusealpha(0.3);
				else
					self:settextf("%03i", GetRadarData( _pnPlayer, _rcRadarCategory ) );
					if GetRadarData( _pnPlayer, _rcRadarCategory )==0 then
						self:diffusealpha(0.3);
					else
						self:diffusealpha(1);
					end;
				end
			end;
			CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				local course = GAMESTATE:GetCurrentCourse()
				if not song and not course then
					self:settext("000");
					self:diffusealpha(0.3);
				else
					self:settextf("%03i", GetRadarData( _pnPlayer, _rcRadarCategory ) );
					if GetRadarData( _pnPlayer, _rcRadarCategory )==0 then
						self:diffusealpha(0.3);
					else
						self:diffusealpha(1);
					end;
				end
			end;
		};
	};
end;

--[[ Numbers ]]
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(zoom,0.8);
	-- Left 
	CreatePaneDisplayItem( iPN, "Taps", 'RadarCategory_TapsAndHolds' ) .. {
		InitCommand=cmd(x,-85;y,-12);
	};
	CreatePaneDisplayItem( iPN, "Jumps", 'RadarCategory_Jumps' ) .. {
		InitCommand=cmd(x,-85;y,0);
	};
	CreatePaneDisplayItem( iPN, "Holds", 'RadarCategory_Holds' ) .. {
		InitCommand=cmd(x,-85;y,12);
	};
	-- Center
	CreatePaneDisplayItem( iPN, "Mines", 'RadarCategory_Mines' ) .. {
		InitCommand=cmd(x,0;y,-12);
	};
	CreatePaneDisplayItem( iPN, "Rolls", 'RadarCategory_Rolls' ) .. {
		InitCommand=cmd(x,0;y,0);
	};
	CreatePaneDisplayItem( iPN, "Lifts", 'RadarCategory_Lifts' ) .. {
		InitCommand=cmd(x,0;y,12);
	};
	-- Right
	CreatePaneDisplayItem( iPN, "Hands", 'RadarCategory_Hands' ) .. {
		InitCommand=cmd(x,85;y,-12);
	};
	CreatePaneDisplayItem( iPN, "Fakes", 'RadarCategory_Fakes' ) .. {
		InitCommand=cmd(x,85;y,0);
	};
};
return t;