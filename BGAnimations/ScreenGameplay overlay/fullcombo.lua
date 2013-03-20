local MinCombo_=GetUserPref_Theme("UserMinCombo");
local MinCombo=(MinCombo_=='TapNoteScore_W3') and 3 or ((MinCombo_=='TapNoteScore_W1') and 1 or ((MinCombo_=='TapNoteScore_W2') and 2 or 4));

local t=Def.ActorFrame{};
-- [ja]フルコンボエフェクト
local function GetFullComboEffectPosX(pn)
	local r=SCREEN_CENTER_X;
	local p;
	local st=GAMESTATE:GetCurrentStyle():GetStyleType();
	if GAMESTATE:GetNumPlayersEnabled()==1 and Center1Player() then
		r=SCREEN_CENTER_X;
	else
		if pn==PLAYER_1 then
			p="1";
		else
			p="2";
		end;
		r=THEME:GetMetric("ScreenGameplay","PlayerP"..p..ToEnumShortString(st).."X");
	end;
	return r;
end;
local function GetFullComboEffectSizeX(pn)
	local r=0;
	local one=THEME:GetMetric("ArrowEffects","ArrowSpacing");
	local stt=GAMESTATE:GetCurrentSteps(pn):GetStepsType();
	if stt=='StepsType_Dance_Single' then
		r=one*4;
	elseif stt=='StepsType_Dance_Double' then
		r=one*8;
	elseif stt=='StepsType_Dance_Couple' then
		r=one*4;
	elseif stt=='StepsType_Dance_Solo' then
		r=one*6;
	elseif stt=='StepsType_Dance_Threepanel' then
		r=one*3;
	else
		r=SCREEN_WIDTH;
	end;
	return r;
end;
local function GetFullComboEffectColor(pss)
	local r;
		if pss:FullComboOfScore('TapNoteScore_W1') then
			r=GameColor.Judgment["JudgmentLine_W1"];
		elseif pss:FullComboOfScore('TapNoteScore_W2') and MinCombo>=2 then
			r=GameColor.Judgment["JudgmentLine_W2"];
		elseif pss:FullComboOfScore('TapNoteScore_W3') and MinCombo>=3 then
			r=GameColor.Judgment["JudgmentLine_W3"];
		elseif pss:FullComboOfScore('TapNoteScore_W4') and MinCombo>=4 then
			r=GameColor.Judgment["JudgmentLine_W4"];
		end;
	return r;
end;

for pn in ivalues(PlayerNumber) do
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(y,SCREEN_CENTER_Y);
		LoadActor( THEME:GetPathG("_Effect", "Fullcombo under"))..{
			InitCommand = cmd(player,pn;diffusealpha,0);
			OffCommand = function(self)
				local ss = STATSMAN:GetCurStageStats();
				local pss = ss:GetPlayerStageStats(pn);
				self:diffuse(GetFullComboEffectColor(pss));
				if pss:FullComboOfScore('TapNoteScore_W'..MinCombo) then
					if _SONG():GetDisplayMainTitle()=="朱色黄色" then
						self:diffuse(Color("Red"));
					end;
					self:x(GetFullComboEffectPosX(pn));
					self:blend('BlendMode_Add');
					self:zoomtowidth(GetFullComboEffectSizeX(pn)*2);
					self:zoomy(0);
					self:diffusealpha(0);
					self:sleep(1);
					self:linear(0.3);
					self:zoomtowidth(GetFullComboEffectSizeX(pn));
					self:zoomy(0.5);
					self:diffusealpha(1);
					self:linear(1.2);
					self:diffusealpha(0);
				else
					self:diffusealpha(0);
				end;
			end;
		};
		LoadActor( THEME:GetPathG("_Effect", "Fullcombo under"))..{
			InitCommand = cmd(player,pn;diffusealpha,0);
			OffCommand = function(self)
				local ss = STATSMAN:GetCurStageStats();
				local pss = ss:GetPlayerStageStats(pn);
				self:diffuse(GetFullComboEffectColor(pss));
				if pss:FullComboOfScore('TapNoteScore_W'..MinCombo) then
					if _SONG():GetDisplayMainTitle()=="朱色黄色" then
						self:diffuse(Color("Red"));
					end;
					self:x(GetFullComboEffectPosX(pn));
					if not IsReverse(pn) then
						self:y(SCREEN_CENTER_Y);
					else
						self:y(-SCREEN_CENTER_Y);
					end;
					self:blend('BlendMode_Add');
					self:zoomtowidth(GetFullComboEffectSizeX(pn)*1.5);
					self:zoomy(0);
					self:diffusealpha(0);
					self:sleep(1);
					self:linear(0.5);
					self:zoomtowidth(GetFullComboEffectSizeX(pn)*1.5);
					self:zoomy(1);
					self:diffusealpha(1);
					self:linear(1.0);
					self:diffusealpha(0);
				else
					self:diffusealpha(0);
				end;
			end;
		};
		LoadActor("fan_1")..{
			InitCommand = cmd(player,pn;diffusealpha,0);
			OffCommand = function(self)
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
				self:diffuse(GetFullComboEffectColor(pss));
				if pss:FullComboOfScore('TapNoteScore_W'..MinCombo) then
					if _SONG():GetDisplayMainTitle()=="朱色黄色" then
						self:diffuse(Color("Orange"));
					end;
					self:x(GetFullComboEffectPosX(pn));
					self:blend('BlendMode_Add');
					self:zoom(2);
					self:diffusealpha(0);
					self:sleep(1.5);
					self:linear(0.3);
					self:zoom(1);
					self:diffusealpha(1);
					self:linear(0.7);
					self:diffusealpha(0);
				else
					self:diffusealpha(0);
				end;
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand = cmd(player,pn;diffusealpha,0;);
			OffCommand = function(self)
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
				self:diffuse(GetFullComboEffectColor(pss));
				if pss:FullComboOfScore('TapNoteScore_W'..MinCombo) then
					if _SONG():GetDisplayMainTitle()=="Tohoku EVOLVED" then
						self:settext("Pray for All");
					elseif pss:FullComboOfScore('TapNoteScore_W1') then
						self:settext("".._JudgementLabel("TapNoteScore_W1").." Full Combo!");
					elseif pss:FullComboOfScore('TapNoteScore_W2') then
						self:settext("".._JudgementLabel("TapNoteScore_W2").." Full Combo!");
					elseif pss:FullComboOfScore('TapNoteScore_W3') then
						self:settext("Full Combo!");
					elseif pss:FullComboOfScore('TapNoteScore_W4') then
						self:settext("".._JudgementLabel("TapNoteScore_W4").." Full Combo!");
					else
						self:settext("Full Combo!");
					end;
					self:strokecolor(Color("Outline"));
					self:maxwidth(200);
					self:rotationz(-15);
					self:x(GetFullComboEffectPosX(pn));
					if not IsReverse(pn) then
						self:y(80);
					else
						self:y(-80);
					end;
					self:zoom(8);
					self:diffusealpha(0);
					self:sleep(1.2);
					self:bounceend(0.3);
					self:zoom(1.5);
					self:diffusealpha(1);
					self:sleep(0.5);
					self:linear(1.0);
					self:diffusealpha(0);
				else
					self:diffusealpha(0);
				end;
			end;
		};
	};
end;

return t;