local vStats = STATSMAN:GetCurStageStats();
local cscore;
if GetUserPref_Theme("UserCustomScore") ~= nil then
	cscore = GetUserPref_Theme("UserCustomScore");
else
	cscore = 'Off';
end;

local function CreateStats( pnPlayer )
	-- Actor Templates
	local aLabel = LoadFont("Common Normal") .. { InitCommand=cmd(zoom,0.5;shadowlength,1;horizalign,left); };
	local aText = LoadFont("Common Normal") .. { InitCommand=cmd(zoom,0.5;shadowlength,1;horizalign,left); };
	-- DA STATS, JIM!!
	local pnStageStats = vStats:GetPlayerStageStats( pnPlayer );
	-- Organized Stats.
	local tStats = {
		W1			= pnStageStats:GetTapNoteScores('TapNoteScore_W1');
		W2			= pnStageStats:GetTapNoteScores('TapNoteScore_W2');
		W3			= pnStageStats:GetTapNoteScores('TapNoteScore_W3');
		W4			= pnStageStats:GetTapNoteScores('TapNoteScore_W4');
		W5			= pnStageStats:GetTapNoteScores('TapNoteScore_W5');
		Miss		= pnStageStats:GetTapNoteScores('TapNoteScore_Miss');
		HitMine		= pnStageStats:GetTapNoteScores('TapNoteScore_HitMine');
		AvoidMine	= pnStageStats:GetTapNoteScores('TapNoteScore_AvoidMine');
		Held		= pnStageStats:GetHoldNoteScores('HoldNoteScore_Held');
		LetGo		= pnStageStats:GetHoldNoteScores('HoldNoteScore_LetGo');
		Total		= 1;
		HoldsAndRolls = 0;
		Seconds		= pnStageStats:GetCurrentLife();
	};
	if GAMESTATE:GetCurrentSteps(pnPlayer) then
		tStats["Total"]=yaGetRD(pnPlayer,'RadarCategory_TapsAndHolds')+yaGetRD(pnPlayer,'RadarCategory_Holds')+yaGetRD(pnPlayer,'RadarCategory_Rolls');
	elseif _COURSE() then
		local entry=_COURSE():GetCourseEntries();
		-- [ja] 仮置き 
		tStats["Total"]=(tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"] + tStats["Held"] + tStats["LetGo"]);
	end;
	-- Organized Equation Values
	local tValues = {
		-- marvcount*7 + perfcount*6 + greatcount*5 + goodcount*4 + boocount*2 + okcount*7
		ITG			= ( tStats["W1"]*7 + tStats["W2"]*6 + tStats["W3"]*5 + tStats["W4"]*4 + tStats["W5"]*2 + tStats["Held"]*7 ), 
		-- (marvcount + perfcount + greatcount + goodcount + boocount + misscount + okcount + ngcount)*7
		ITG_MAX		= ( tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"] + tStats["Held"] + tStats["LetGo"] )*7,
		-- marvcount*3 + perfcount*2 + greatcount*1 - boocount*4 - misscount*8 + okcount*6
		MIGS		= ( tStats["W1"]*3 + tStats["W2"]*2 + tStats["W3"] - tStats["W5"]*4 - tStats["Miss"]*8 + tStats["Held"]*6 ),
		-- (marvcount + perfcount + greatcount + goodcount + boocount + misscount)*3 + (okcount + ngcount)*6
		MIGS_MAX	= ( (tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"])*3 + (tStats["Held"] + tStats["LetGo"])*6 ),
		SN2	= (math.round( (tStats["W1"] + tStats["W2"] + tStats["W3"]/2+tStats["Held"])*100000/math.max(tStats["Total"],1)-(tStats["W2"] + tStats["W3"]))*10),
	};
	if cscore=="SuperNOVA2" then
		tValues["SN2"]		= (tStats["W1"]*5 + tStats["W2"]*4 + tStats["W3"]*3 + tStats["W4"]*2 + tStats["W5"] + tStats["Held"]*5);
	end;

	local t = Def.ActorFrame {};
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(y,5);
		Def.Quad{
			InitCommand=cmd(visible,false);
			UpdateNetEvalStatsMessageCommand=function(self,params)
				local st=params.Steps;
				tStats["HoldsAndRolls"] = st:GetRadarValues(pnPlayer):GetValue('RadarCategory_Holds')+st:GetRadarValues(pnPlayer):GetValue('RadarCategory_Rolls');
				tStats["Total"]	= math.max(st:GetRadarValues(pnPlayer):GetValue('RadarCategory_TapsAndHolds')+tStats["HoldsAndRolls"],1);
				self:sleep(0.01);
				self:queuecommand("NetScore")
			end;
			NetScoreCommand=function(self)
				local p=((pnPlayer=='PlayerNumber_P1') and 1 or 2);
				tStats["W1"]	= tonumber(SCREENMAN:GetTopScreen():GetChild("W1NumberP"..p):GetText());
				tStats["W2"]	= tonumber(SCREENMAN:GetTopScreen():GetChild("W2NumberP"..p):GetText());
				tStats["W3"]	= tonumber(SCREENMAN:GetTopScreen():GetChild("W3NumberP"..p):GetText());
				tStats["W4"]	= tonumber(SCREENMAN:GetTopScreen():GetChild("W4NumberP"..p):GetText());
				tStats["W5"]	= tonumber(SCREENMAN:GetTopScreen():GetChild("W5NumberP"..p):GetText());
				tStats["Miss"]	= tonumber(SCREENMAN:GetTopScreen():GetChild("MissNumberP"..p):GetText());
				tStats["Held"]	= tonumber(SCREENMAN:GetTopScreen():GetChild("HeldNumberP"..p):GetText());
				tStats["LetGo"]	= tStats["HoldsAndRolls"]-tStats["Held"];
				tValues["ITG"]		= ( tStats["W1"]*7 + tStats["W2"]*6 + tStats["W3"]*5 + tStats["W4"]*4 + tStats["W5"]*2 + tStats["Held"]*7 );
				tValues["ITG_MAX"]	= ( tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"] + tStats["Held"] + tStats["LetGo"] )*7;
				tValues["MIGS"]		= ( tStats["W1"]*3 + tStats["W2"]*2 + tStats["W3"] - tStats["W5"]*4 - tStats["Miss"]*8 + tStats["Held"]*6 );
				tValues["MIGS_MAX"]	= ( (tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"])*3 + (tStats["Held"] + tStats["LetGo"])*6 );
				if cscore~="SuperNOVA2" then
					tValues["SN2"]		= (math.round( (tStats["W1"] + tStats["W2"] + tStats["W3"]/2+tStats["Held"])*100000/math.max(tStats["Total"],1)-(tStats["W2"] + tStats["W3"]))*10);
				else
					tValues["SN2"]		= (tStats["W1"]*5 + tStats["W2"]*4 + tStats["W3"]*3 + tStats["W4"]*2 + tStats["W5"] + tStats["Held"]*5);
				end;
			end;
		};
		Def.Quad{
			InitCommand=cmd(zoomto,120,130;diffuse,Color( "Black" ));
			OnCommand=function(self)
				if pnPlayer==PLAYER_1 then
					self:faderight(0.8);
				else
					self:fadeleft(0.8);
				end;
			end;
		};
	};
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(y,-34);
		Def.Quad{
			InitCommand=cmd(zoomto,116,30;diffuse,PlayerColor( pnPlayer ));
			OnCommand=function(self)
				if pnPlayer==PLAYER_1 then
					self:skewx(0.13);
					self:diffuselowerleft(0,0,0,0);
				else
					self:skewx(-0.13);
					self:diffuselowerright(0,0,0,0);
				end;
				self:blend("BlendMode_Add");
			end;
		};
		aLabel .. { Text="ITG DP:"; InitCommand=cmd(x,-52;y,-8;zoomy,0.4) };
		aText .. { InitCommand=cmd(x,5;y,7;horizalign,right;vertalign,bottom;zoom,0.6;settextf,"%04i",tValues["ITG"]);
					UpdateNetEvalStatsMessageCommand=cmd(sleep,0.01;queuecommand,"NetScore";);
					NetScoreCommand=cmd(settextf,"%04i",tValues["ITG"])};
		aText .. { InitCommand=cmd(x,7;y,7;vertalign,bottom;zoom,0.5;diffusealpha,0.5;settext,"/"); };
		aText .. { InitCommand=cmd(x,16;y,7;horizalign,left;vertalign,bottom;zoom,0.5;settextf,"%04i",tValues["ITG_MAX"]);
					UpdateNetEvalStatsMessageCommand=cmd(sleep,0.01;queuecommand,"NetScore";);
					NetScoreCommand=cmd(settextf,"%04i",tValues["ITG_MAX"])};
	};
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(y,5);
		Def.Quad{
			InitCommand=cmd(zoomto,116,30;diffuse,PlayerColor( pnPlayer ));
			OnCommand=function(self)
				if pnPlayer==PLAYER_1 then
					self:skewx(0.13);
					self:diffuselowerleft(0,0,0,0);
				else
					self:skewx(-0.13);
					self:diffuselowerright(0,0,0,0);
				end;
				self:blend("BlendMode_Add");
			end;
		};
		aLabel .. { Text="MIGS DP:"; InitCommand=cmd(x,-52;y,-8;zoomy,0.4) };
		aText .. { InitCommand=cmd(x,5;y,7;horizalign,right;vertalign,bottom;zoom,0.6;settextf,"%04i",tValues["MIGS"]);
					UpdateNetEvalStatsMessageCommand=cmd(sleep,0.01;queuecommand,"NetScore";);
					NetScoreCommand=cmd(settextf,"%04i",tValues["MIGS"])};
		aText .. { InitCommand=cmd(x,7;y,7;vertalign,bottom;zoom,0.5;diffusealpha,0.7;settext,"/"); };
		aText .. { InitCommand=cmd(x,16;y,7;horizalign,left;vertalign,bottom;zoom,0.5;settextf,"%04i",tValues["MIGS_MAX"]);
					UpdateNetEvalStatsMessageCommand=cmd(sleep,0.01;queuecommand,"NetScore";);
					NetScoreCommand=cmd(settextf,"%04i",tValues["MIGS_MAX"])};
	};
	if GAMESTATE:IsCourseMode() then 
		t[#t+1] = Def.ActorFrame {
			InitCommand=cmd(y,46);
			Def.Quad{
				InitCommand=cmd(zoomto,116,30;diffuse,PlayerColor( pnPlayer ));
				OnCommand=function(self)
					if pnPlayer==PLAYER_1 then
						self:skewx(0.13);
						self:diffuselowerleft(0,0,0,0);
					else
						self:skewx(-0.13);
						self:diffuselowerright(0,0,0,0);
					end;
					self:blend("BlendMode_Add");
				end;
			};
			aLabel .. { Text="TotalSeconds:"; InitCommand=cmd(x,-52;y,-8;zoomy,0.4) };
			aText .. { InitCommand=cmd(x,50;y,7;horizalign,right;
				vertalign,bottom;zoom,0.6;settext,SecondsToMMSSMsMs(vStats:GetPlayerStageStats(pnPlayer):GetAliveSeconds()));};
		};
	else
		t[#t+1] = Def.ActorFrame {
			InitCommand=cmd(y,46);
			Def.Quad{
				InitCommand=cmd(zoomto,116,30;diffuse,PlayerColor( pnPlayer ));
				OnCommand=function(self)
					if pnPlayer==PLAYER_1 then
						self:skewx(0.13);
						self:diffuselowerleft(0,0,0,0);
					else
						self:skewx(-0.13);
						self:diffuselowerright(0,0,0,0);
					end;
					self:blend("BlendMode_Add");
				end;
			};
			aLabel .. { Text=((cscore~="SuperNOVA2") and "SN2 SCORE:" or "SM5 SCORE:"); InitCommand=cmd(x,-52;y,-8;zoomy,0.4) };
			aText .. { InitCommand=cmd(x,50;y,7;horizalign,right;vertalign,bottom;zoom,0.6;settextf,"%7i",tValues["SN2"]);
						UpdateNetEvalStatsMessageCommand=cmd(sleep,0.01;queuecommand,"NetScore";);
						NetScoreCommand=cmd(settextf,"%7i",tValues["SN2"])};
		};
	end;
	return t
end;

local t = Def.ActorFrame {};
if not THEME:GetMetric( Var "LoadingScreen","Summary" ) then
	GAMESTATE:IsPlayerEnabled(PLAYER_1)
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(hide_if,not GAMESTATE:IsPlayerEnabled(PLAYER_1);x,SCREEN_LEFT+55;y,SCREEN_TOP+120);
		CreateStats( PLAYER_1 );
	};
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(hide_if,not GAMESTATE:IsPlayerEnabled(PLAYER_2);x,SCREEN_RIGHT-55;y,SCREEN_TOP+120);
		CreateStats( PLAYER_2 );
	};
end;
return t