local t=Def.ActorFrame{};
local dn={
	'Difficulty_Beginner',
	'Difficulty_Easy',
	'Difficulty_Medium',
	'Difficulty_Hard',
	'Difficulty_Challenge',
	'Difficulty_Edit'
};
local sdn={
	'Beginner',
	'Easy',
	'Medium',
	'Hard',
	'Challenge',
	'Edit'
};

local song=nil;
local songlen=1;
local metertype="ddr"
local difname=GetUserPref_Theme("UserDifficultyName");
local difcolor=GetUserPref_Theme("UserDifficultyColor");
local judlabel=GetUserPref_Theme("UserJudgementLabel");
local smscoremode=GetUserPref_Theme("UserScoreMode");
local mt=GetUserPref_Theme("UserMeterType");
t[#t+1]=Def.ActorFrame{
	Def.Quad{
		SetCommand=function(self)
			self:visible(0);
			song=GAMESTATE:GetCurrentSong();
			if not song then
				song=nil;
				songlen=1
				metertype="ddr"
			else
				songlen=math.max(song:GetLastSecond(),1);
				metertype=string.lower(GetSMParameter(song,"metertype"))
			end;
		end;
		BeginCommand=cmd(playcommand,"Set");
		InitCommand=cmd(playcommand,"Set");
		OnCommand=cmd(playcommand,"Set");
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	};
};

-- [ja] ﾊｯ、自分でDifficultyList作ればいいんじゃね！？
function DrawExDifList(pn,diff)
	local t=Def.ActorFrame {};
	t[#t+1]=Def.ActorFrame {
		Def.Quad {
			InitCommand=cmd(zoomto,160,18;diffuse,PlayerColor(pn);diffusealpha,0;);
			--OnCommand=cmd(diffuse,PlayerColor(pn);diffusealpha,0;linear,0.35;diffusealpha,0.5);
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			OnCommand=cmd(playcommand,"Set");
			BeginCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				self:player(pn);
				local st=GAMESTATE:GetCurrentStyle():GetStepsType();
				if song:HasStepsTypeAndDifficulty(st,dn[diff]) and dn[diff]==GAMESTATE:GetCurrentSteps(pn):GetDifficulty() then
					self:diffusealpha(1.0);
				--	self:glowshift();
					self:y((diff-3)*20-10);
					if pn==PLAYER_1 then
						self:x(-80);
						self:diffuserightedge(0,0,0,0.3);
					else
						self:x(80);
						self:diffuseleftedge(0,0,0,0.3);
					end;
				else
				--	self:stopeffect();
					self:diffusealpha(0);
				end;
			end;
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
			PlayerJoinedMessageCommand=cmd(playcommand,"Set");
		};
		Def.Quad {
			InitCommand=cmd(diffuse,PlayerColor(pn);diffusealpha,0;);
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			BeginCommand=cmd(playcommand,"Set");
			OnCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				self:player(pn);
				self:Load(THEME:GetPathG("_ScoreList","player"));
				local st=GAMESTATE:GetCurrentStyle():GetStepsType();
				if song:HasStepsTypeAndDifficulty(st,dn[diff]) and dn[diff]==GAMESTATE:GetCurrentSteps(pn):GetDifficulty() then
					self:diffusealpha(1.0);
					self:y((diff-3)*20-10);
					if pn==PLAYER_1 then
						self:x(-166);
					else
						self:x(165);
						self:rotationy(180);
					end;
				else
					self:diffusealpha(0);
				end;
			end;
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
			PlayerJoinedMessageCommand=cmd(playcommand,"Set");
		};
		LoadFont("Common Normal").. {
			InitCommand=cmd(diffuse,Color("White");diffusealpha,0;shadowlength,1;zoom,0.6;strokecolor,Color("Outline"););
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			BeginCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				self:player(pn);
				local st=GAMESTATE:GetCurrentStyle():GetStepsType();
				if song:HasStepsTypeAndDifficulty(st,dn[diff]) and dn[diff]==GAMESTATE:GetCurrentSteps(pn):GetDifficulty() then
					self:diffusealpha(1.0);
					self:y((diff-3)*20-10);
					self:rotationz(10);
					if pn==PLAYER_1 then
						self:x(-167);
						self:settext("1");
					else
						self:x(166);
						self:settext("2");
					end;
				else
					self:diffusealpha(0);
				end;
			end;
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
			PlayerJoinedMessageCommand=cmd(playcommand,"Set");
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(shadowlength,1;zoom,0.6;diffusealpha,0;maxwidth,128;);
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			BeginCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				if pn==PLAYER_1 then
					self:x(-120);
				else
					self:x(119);
				end;
				self:y((diff-3)*20-10);
				self:player(pn);
				local st=GAMESTATE:GetCurrentStyle():GetStepsType();
				if song then
					if song:HasStepsTypeAndDifficulty(st,dn[diff]) then
						local steps = song:GetOneSteps( st, dn[diff] );
						if PROFILEMAN:IsPersistentProfile(pn) then
							-- player profile
							profile = PROFILEMAN:GetProfile(pn);
						else
							-- machine profile
							profile = PROFILEMAN:GetMachineProfile();
						end;
						scorelist = profile:GetHighScoreList(song,steps);
						assert(scorelist);
						local scores = scorelist:GetHighScores();
						assert(scores);
						local topscore=0;
						if scores[1] then
							if smscoremode=="DDR SuperNOVA2" then
								topscore=GetSN2Score(pn,steps,GetScoreData(scores,"hiscore"));
							elseif smscoremode=="DancePoints" then
								topscore=GetScoreData(scores,"dp")*100;
							else
								topscore=GetScoreData(scores,"score");
							end;
						end;
						assert(topscore);
						if dn[diff]==GAMESTATE:GetCurrentSteps(pn):GetDifficulty() then
							self:diffuse(_DifficultyLightCOLOR2(difcolor,dn[diff]));
							self:strokecolor(ColorDarkTone(_DifficultyCOLOR2(difcolor,dn[diff])));
						else
							self:diffuse(0.75,0.75,0.75,1.0);
							self:strokecolor(Color("Outline"));
						end;
						self:diffusealpha(0.8);
						if smscoremode=="DDR SuperNOVA2" then
							self:settextf("%07d",topscore);
						elseif smscoremode=="DancePoints" then
							if topscore<100 then
								self:settextf("%4.2f%%",topscore);
							else
								self:settext("100%");
							end;
						else
							self:settextf("%09d",topscore);
						end;
					else
						self:settext("");
					end;
				else
					self:diffusealpha(0.3);
					if smscoremode=="DDR SuperNOVA2" then
						self:settext("0000000");
					elseif smscoremode=="DancePoints" then
						self:settext("0.00%");
					else
						self:settext("000000000");
					end;
				end;
			end;
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
			PlayerJoinedMessageCommand=cmd(playcommand,"Set");
		};
		Def.Quad{
			InitCommand=cmd(shadowlength,1;zoom,0.2;diffusealpha,0;);
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			BeginCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				if pn==PLAYER_1 then
					self:x(-65);
				else
					self:x(65);
				end;
				self:y((diff-3)*20-9);
				self:player(pn);
				local st=GAMESTATE:GetCurrentStyle():GetStepsType();
				if song then
					if song:HasStepsTypeAndDifficulty(st,dn[diff]) then
						local steps = song:GetOneSteps( st, dn[diff] );
						if PROFILEMAN:IsPersistentProfile(pn) then
							-- player profile
							profile = PROFILEMAN:GetProfile(pn);
						else
							-- machine profile
							profile = PROFILEMAN:GetMachineProfile();
						end;
						scorelist = profile:GetHighScoreList(song,steps);
						assert(scorelist);
						local scores = scorelist:GetHighScores();
						assert(scores);
						local topgrade;
						if scores[1] then
							topgrade=GetScoreData(scores,"grade");
							assert(topgrade);
							if scores[1]:GetScore()>0 then
								self:LoadBackground(THEME:GetPathG("GradeDisplayEval",ToEnumShortString(topgrade)));
								self:diffusealpha(1);
							else
								self:diffusealpha(0);
							end;
						else
							self:diffusealpha(0);
						end;
					else
						self:diffusealpha(0);
					end;
				else
					self:diffusealpha(0);
				end;
			end;
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
			PlayerJoinedMessageCommand=cmd(playcommand,"Set");
		};
		LoadActor(THEME:GetPathG("Player","Badge FullCombo"))..{
			InitCommand=cmd(shadowlength,1;diffusealpha,0;);
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			BeginCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				if pn==PLAYER_1 then
					self:x(-65+16);
				else
					self:x(50);
				end;
				self:player(pn);
				local st=GAMESTATE:GetCurrentStyle():GetStepsType();
				self:y((diff-3)*20-7);
				if song then
					if song:HasStepsTypeAndDifficulty(st,dn[diff]) then
						local steps = song:GetOneSteps( st, dn[diff] );
						if PROFILEMAN:IsPersistentProfile(pn) then
							-- player profile
							profile = PROFILEMAN:GetProfile(pn);
						else
							-- machine profile
							profile = PROFILEMAN:GetMachineProfile();
						end;
						scorelist = profile:GetHighScoreList(song,steps);
						assert(scorelist);
						local scores = scorelist:GetHighScores();
						assert(scores);
						local topscore;
						local topcombo;
						if scores[1] then
							topscore = GetScoreData(scores,"score");
							topcombo=GetScoreData(scores,"combo");
							assert(topscore);
							if topscore>0 then
								if topcombo=="JudgmentLine_W1" then
									self:diffuse(GameColor.Judgment["JudgmentLine_W1"]);
									self:glowblink();
									self:effectperiod(0.20);
									self:zoom(1.0);
									self:diffusealpha(0.8);
								elseif topcombo=="JudgmentLine_W2" then
									self:diffuse(GameColor.Judgment["JudgmentLine_W2"]);
									self:glowshift();
									self:zoom(0.75);
									self:diffusealpha(0.8);
								elseif topcombo=="JudgmentLine_W3" then
									self:diffuse(GameColor.Judgment["JudgmentLine_W3"]);
									self:stopeffect();
									self:zoom(0.6);
									self:diffusealpha(0.8);
								else
									self:diffusealpha(0);
								end;
							else 
								self:diffusealpha(0);
							end;
						else
							self:diffusealpha(0);
						end;
					else
						self:diffusealpha(0);
					end;
				else
					self:diffusealpha(0);
				end;
			end;
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
			PlayerJoinedMessageCommand=cmd(playcommand,"Set");
		};
	};
	
	--[ja] 難易度名のところは1回描画すればいいので 
	if pn==PLAYER_2 or not GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		t[#t+1]=Def.ActorFrame{
			OffCommand=cmd(zoomx,1;diffusealpha,1;linear,0.2;zoomx,3;diffusealpha,0);
			LoadFont("Common Normal")..{
				InitCommand=cmd(shadowlength,1;zoom,0.6;maxwidth,100;);
				OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
				BeginCommand=cmd(playcommand,"Set");
				SetCommand=function(self)
					local st=GAMESTATE:GetCurrentStyle():GetStepsType();
				--	GetDifListX(self,pn,10,0);
					self:diffuse(_DifficultyLightCOLOR2(difcolor,dn[diff]));
					self:strokecolor(ColorDarkTone(_DifficultyCOLOR2(difcolor,dn[diff])));
					self:horizalign(left);
					self:x(-40);
					self:y((diff-3)*20-10);
					if song then
						if song:HasStepsTypeAndDifficulty(st,dn[diff]) then
							self:settextf("%s",string.upper(_DifficultyNAME2(difname,dn[diff])));
						else
							self:settext("");
						end;
					else
						self:settextf("%s",string.upper(_DifficultyNAME2(difname,dn[diff])));
						self:diffusealpha(0.3);
					end;
				end;
				CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			};
			LoadFont("Common Normal")..{
				InitCommand=cmd(shadowlength,1;zoom,0.6;);
				OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
				BeginCommand=cmd(playcommand,"Set");
				SetCommand=function(self)
					local st=GAMESTATE:GetCurrentStyle():GetStepsType();
				--	GetDifListX(self,pn,10,0);
					self:diffuse(_DifficultyLightCOLOR2(difcolor,dn[diff]));
					self:strokecolor(ColorDarkTone(_DifficultyCOLOR2(difcolor,dn[diff])));
					self:horizalign(right);
					self:x(40);
					self:maxwidth(30);
					self:y((diff-3)*20-10);
					if song then
						if song:HasStepsTypeAndDifficulty(st,dn[diff]) then
							local meter=GetConvertDifficulty(song,st,dn[diff],metertype,mt);
							self:settextf("%d",meter);
						else
							self:settext("");
						end;
					else
						self:settext("-");
						self:diffusealpha(0.3);
					end;
				end;
				CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			};
		};
	end;

	return t;
end;

function ExListBG(self)
	local t=Def.ActorFrame{};
	t[#t+1]=Def.ActorFrame{
		LoadActor("../ScreenSelectMusic decorations/property")..{
		};
		--[[
		LoadActor("list_side")..{
			InitCommand=cmd(player,PLAYER_1;horizalign,right;x,-310;
								diffuse,ColorLightTone(PlayerColor(PLAYER_1)));
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			PlayerJoinedMessageCommand=cmd(playcommand,"Init");
		};
		LoadActor("list_side")..{
			InitCommand=cmd(player,PLAYER_2;horizalign,right;rotationy,180;x,310+1;
								diffuse,ColorLightTone(PlayerColor(PLAYER_2)));
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			PlayerJoinedMessageCommand=cmd(playcommand,"Init");
		};
		--]]
		LoadActor("../ScreenSelectMusic decorations/list_bg")..{
			InitCommand=cmd(x,-310+50;diffuse,Color("White"););
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		};
		LoadActor("../ScreenSelectMusic decorations/list_bg")..{
			InitCommand=cmd(rotationy,180;x,310-50+1;diffuse,Color("White"););
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		};
		Def.Quad {
			InitCommand=cmd(zoomto,620,130;);
			OnCommand=cmd(diffuse,Color("Black");diffusealpha,0;linear,0.35;diffusealpha,0.5);
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		};
		Def.Quad {
			InitCommand=cmd(zoomto,80,130;x,-201);
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			OnCommand=cmd(player,PLAYER_1;diffuse,PlayerColor(PLAYER_1);diffusealpha,0;linear,0.35;diffusealpha,0.5;diffuseleftedge,0,0,0,0;);
			PlayerJoinedMessageCommand=cmd(playcommand,"On");
		};
		Def.Quad {
			InitCommand=cmd(zoomto,40,130;x,-141);
			OnCommand=cmd(player,PLAYER_1;diffuse,PlayerColor(PLAYER_1);diffusealpha,0;linear,0.35;diffusealpha,0.5;diffuserightedge,0,0,0,0;);
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			PlayerJoinedMessageCommand=cmd(playcommand,"On");
		};
		Def.Quad {
			InitCommand=cmd(zoomto,80,130;x,200);
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			OnCommand=cmd(player,PLAYER_2;diffuse,PlayerColor(PLAYER_2);diffusealpha,0;linear,0.35;diffusealpha,0.8;diffuserightedge,0,0,0,0;);
			PlayerJoinedMessageCommand=cmd(playcommand,"On");
		};
		Def.Quad {
			InitCommand=cmd(zoomto,40,130;x,140);
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			OnCommand=cmd(player,PLAYER_2;diffuse,PlayerColor(PLAYER_2);diffusealpha,0;linear,0.35;diffusealpha,0.8;diffuseleftedge,0,0,0,0;);
			PlayerJoinedMessageCommand=cmd(playcommand,"On");
		};
	};
	for diff=0,6 do
	t[#t+1]=Def.ActorFrame{
		Def.Quad {
			InitCommand=function(self)
				self:zoomto(360,2);
				self:x(0);
				self:y((diff-3)*20);
				self:diffuse(Color("White"));
				self:diffusealpha(0.8);
				self:fadeleft(1);
				self:faderight(1);
			end;
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			OnCommand=cmd(playcommand,"Init");
			BeginCommand=cmd(playcommand,"Init");
		};
	};
	end;
return t;
end;

return t;