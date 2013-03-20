local t= LoadFallbackB();

local keylock=true;
local setup_page=0;
local setup_end=6;
local setup_choice=0;
local setup_select_preset={
THEME:GetString("ScreenWelcomewaiei","Later"),
THEME:GetString("ScreenWelcomewaiei","SM5Mode"),
THEME:GetString("ScreenWelcomewaiei","EXTMode"),
THEME:GetString("ScreenWelcomewaiei","DDRMode")
};

t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(fov,60);
	-- [ja] 実際には表示されないフラグ管理用のアイテム 
	Def.Quad{
		InitCommand=function(self)
			SetUserPref_Theme("waieiThemeVersion",GetThemeVersionInformation("Version"));
		end;
		OnCommand=function(self)
			self:sleep(0.7);
			self:queuecommand("KeyUnlock");
		end;
		KeyUnlockCommand=function(self) keylock=false; end;
		CodeCommand=function(self,params)
			if not keylock then
				if params.Name=="Start" or params.Name=="Center" then
					setup_page=setup_page+1;
					if setup_page>=setup_end then
						self:queuecommand("End");
					end;
				elseif setup_page==4 then
					if params.Name=="Up" or params.Name=="Up2" then
						setup_choice=setup_choice-1;
						if setup_choice<0 then setup_choice=#setup_select_preset-1 end;
					elseif params.Name=="Down" or params.Name=="Down2" then
						setup_choice=setup_choice+1;
						if setup_choice>#setup_select_preset-1 then setup_choice=0 end;
					end;
				end;
			end;
		end;
		--Page1to2Command=cmd();
		EndCommand=function(self)
			keylock=true;
			self:sleep(1);
			self:queuecommand("NextScreen");
		end;
		NextScreenCommand=function(self)
			SCREENMAN:SetNewScreen(Branch.AfterInit());
		end;
	};
	-- [ja] 画像 
	Def.Sprite{
		InitCommand=cmd(Center;diffusealpha,0;LoadBackground,THEME:GetPathG("ScreenTitleMenu","logo/_logo"));
		OnCommand=function(self)
			(cmd(sleep,0.4;zoom,1;linear,0.1;diffusealpha,1))(self);
			if SCREEN_HEIGHT/SCREEN_WIDTH<0.65 then
				self:zoom(0.8);
			else
				self:zoom(0.7);
			end;
		end;
		CodeCommand=function(self,params)
			if not keylock then
				if params.Name=="Start" or params.Name=="Center" then
					if setup_page>=setup_end then
						self:queuecommand("End");
					elseif setup_page==1 then
						self:queuecommand("Page1to2");
					elseif setup_page==2 then
						self:queuecommand("Page2to3");
					elseif setup_page==3 then
						self:queuecommand("Page3to4");
					elseif setup_page==4 then
						self:queuecommand("Page4to5");
					elseif setup_page==5 then
						self:queuecommand("Page5to6");
					end;
				elseif setup_page==4 and (params.Name=="Up" or params.Name=="Up2"
					or params.Name=="Down" or params.Name=="Down2") then
					self:stoptweening();
					self:diffusealpha(0);
					self:visible(true);
					self:LoadBackground(THEME:GetPathG("ScreenWelcomwaiei","Graphics/set_preset_"..setup_choice));
					self:linear(0.5);
					self:diffusealpha(1);
				end;
			end;
		end;
		Page1to2Command=cmd(diffusealpha,0;
			LoadBackground,THEME:GetPathG("ScreenWelcomwaiei","Graphics/about_waiei");
			linear,0.5;x,SCREEN_CENTER_X-150;
			y,SCREEN_CENTER_Y-30;rotationy,-35;rotationx,20;diffusealpha,1;);
		Page2to3Command=cmd(diffusealpha,0;
			LoadBackground,THEME:GetPathG("ScreenWelcomwaiei","Graphics/compatibility_waiei");
			linear,0.5;diffusealpha,1;);
		Page3to4Command=cmd(diffusealpha,0;
			LoadBackground,THEME:GetPathG("ScreenWelcomwaiei","Graphics/update_waiei");
			linear,0.5;diffusealpha,1;);
		Page4to5Command=cmd(diffusealpha,0;
			LoadBackground,THEME:GetPathG("ScreenWelcomwaiei","Graphics/set_preset_0");
			linear,0.5;diffusealpha,1;);
		Page5to6Command=cmd(diffusealpha,0;
			LoadBackground,THEME:GetPathB("ScreenInit","decorations/waiei");
			linear,0.5;diffusealpha,1;);
		EndCommand=function(self)
			self:linear(0.3);
			self:zoom(0);
		end;
	};
	-- [ja] 立方体 
	LoadActor(THEME:GetPathG("Information/Information","Cube2"))..{
		InitCommand=cmd(Center;diffuse,Color("Blue");
			blend,"BlendMode_Add";);
		OnCommand=function(self)
			(cmd(zoom,0;bounceend,0.5;))(self);
			if SCREEN_HEIGHT/SCREEN_WIDTH<0.65 then
				self:zoom(0.7);
			else
				self:zoom(0.6);
			end;
		end;
		CodeCommand=function(self,params)
			if not keylock then
				if params.Name=="Start" or params.Name=="Center" then
					if setup_page>=setup_end then
						self:queuecommand("End");
					elseif setup_page==1 then
						self:queuecommand("Page1to2");
					elseif setup_page==2 then
						self:queuecommand("Page2to3");
					elseif setup_page==3 then
						self:queuecommand("Page3to4");
					elseif setup_page==4 then
						self:queuecommand("Page4to5");
					elseif setup_page==5 then
						self:queuecommand("Page5to6");
					end;
				end;
			end;
		end;
		Page1to2Command=cmd(linear,0.5;x,SCREEN_CENTER_X-150;
			y,SCREEN_CENTER_Y-30;rotationy,-35;rotationx,20);
		Page2to3Command=cmd(spring,0.5;rotationy,-125);
		Page3to4Command=cmd(spring,0.5;rotationy,-215);
		Page4to5Command=cmd(spring,0.5;rotationy,-305);
		Page5to6Command=cmd(spring,0.5;rotationy,-395);
		EndCommand=function(self)
			self:linear(0.3);
			self:zoom(0);
			self:sleep(0.7);
		end;
	};
	-- [ja] 説明文背景 
	Def.Quad{
		InitCommand=cmd(Center;diffuse,Color("Black");
			diffusealpha,0;zoomto,300,380);
		CodeCommand=function(self,params)
			if not keylock then
				if params.Name=="Start" or params.Name=="Center" then
					if setup_page>=setup_end then
						self:queuecommand("End");
					elseif setup_page==1 then
						self:queuecommand("Page1to2");
					end;
				end;
			end;
		end;
		Page1to2Command=cmd(linear,0.5;x,SCREEN_CENTER_X+150;y,SCREEN_CENTER_Y;diffusealpha,0.5);
		EndCommand=function(self)
			self:linear(0.3);
			self:zoom(0);
			self:sleep(0.7);
		end;
	};
	-- [ja] 説明文タイトル 
	LoadFont("Common Normal")..{
		InitCommand=cmd(Center;diffuse,Color("White");strokecolor,Color("Outline");
			diffusealpha,0;horizalign,left;vertalign,top;zoom,1.2;
			x,SCREEN_CENTER_X+20;y,SCREEN_CENTER_Y-170;);
		CodeCommand=function(self,params)
			if not keylock then
				if params.Name=="Start" or params.Name=="Center" then
					if setup_page>=setup_end then
						self:queuecommand("End");
					elseif setup_page==1 then
						self:queuecommand("Page1to2");
					elseif setup_page==2 then
						self:queuecommand("Page2to3");
					elseif setup_page==3 then
						self:queuecommand("Page3to4");
					elseif setup_page==4 then
						self:queuecommand("Page4to5");
					elseif setup_page==5 then
						self:queuecommand("Page5to6");
					end;
				end;
			end;
		end;
		Page1to2Command=cmd(diffusealpha,2;addx,-100;linear,0.5;diffusealpha,1;addx,100;
			settext,THEME:GetString("ScreenWelcomewaiei","SetUpP1Title"));
		Page2to3Command=cmd(diffusealpha,2;addx,-100;linear,0.5;diffusealpha,1;addx,100;
			settext,THEME:GetString("ScreenWelcomewaiei","SetUpP2Title"));
		Page3to4Command=cmd(diffusealpha,2;addx,-100;linear,0.5;diffusealpha,1;addx,100;
			settext,THEME:GetString("ScreenWelcomewaiei","SetUpP3Title"));
		Page4to5Command=cmd(diffusealpha,2;addx,-100;linear,0.5;diffusealpha,1;addx,100;
			settext,THEME:GetString("ScreenWelcomewaiei","SetUpP4Title"));
		Page5to6Command=cmd(diffusealpha,2;addx,-100;linear,0.5;diffusealpha,1;addx,100;
			settext,THEME:GetString("ScreenWelcomewaiei","SetUpP5Title"));
		EndCommand=function(self)
			(cmd(linear,0.5;diffusealpha,0;addx,100;))(self);
			self:zoom(0);
		end;
	};
	-- [ja] タイトル下境界線 
	Def.Quad{
		InitCommand=cmd(Center;diffuse,Color("White");
			diffusealpha,0;x,SCREEN_CENTER_X+150;y,SCREEN_CENTER_Y-135;
			fadeleft,0.8;faderight,0.8;zoomto,290,2);
		CodeCommand=function(self,params)
			if not keylock then
				if params.Name=="Start" or params.Name=="Center" then
					if setup_page>=setup_end then
						self:queuecommand("End");
					elseif setup_page==1 then
						self:queuecommand("Page1to2");
					end;
				end;
			end;
		end;
		Page1to2Command=cmd(linear,0.5;diffusealpha,1);
		EndCommand=function(self)
			(cmd(linear,0.5;diffusealpha,0;))(self);
			self:zoom(0);
		end;
	};
	-- [ja] 説明文 
	LoadFont("Common Normal")..{
		InitCommand=cmd(Center;diffuse,Color("White");strokecolor,Color("Outline");
			diffusealpha,0;horizalign,left;vertalign,top;zoom,0.5;
			x,SCREEN_CENTER_X+20;y,SCREEN_CENTER_Y-120;);
		CodeCommand=function(self,params)
			if not keylock then
				if params.Name=="Start" or params.Name=="Center" then
					if setup_page>=setup_end then
						self:queuecommand("End");
					elseif setup_page==1 then
						self:queuecommand("Page1to2");
					elseif setup_page==2 then
						self:queuecommand("Page2to3");
					elseif setup_page==3 then
						self:queuecommand("Page3to4");
					elseif setup_page==4 then
						self:queuecommand("Page4to5");
					elseif setup_page==5 then
						self:queuecommand("Page5to6");
					end;
				end;
			end;
		end;
		Page1to2Command=cmd(addx,-100;linear,0.5;diffusealpha,1;addx,100;
			settext,THEME:GetString("ScreenWelcomewaiei","SetUpP1Text"));
		Page2to3Command=cmd(diffusealpha,2;addx,-100;linear,0.5;diffusealpha,1;addx,100;
			settext,THEME:GetString("ScreenWelcomewaiei","SetUpP2Text"));
		Page3to4Command=cmd(diffusealpha,2;addx,-100;linear,0.5;diffusealpha,1;addx,100;
			settext,THEME:GetString("ScreenWelcomewaiei","SetUpP3Text"));
		Page4to5Command=cmd(diffusealpha,2;addx,-100;linear,0.5;diffusealpha,1;addx,100;
			settext,THEME:GetString("ScreenWelcomewaiei","SetUpP4Text"));
		Page5to6Command=cmd(diffusealpha,2;addx,-100;linear,0.5;diffusealpha,1;addx,100;
			settext,THEME:GetString("ScreenWelcomewaiei","SetUpP5Text"));
		EndCommand=function(self)
			(cmd(linear,0.5;diffusealpha,0;addx,100;))(self);
			self:zoom(0);
		end;
	};
	-- [ja] 選択肢背景 
	Def.Quad{
		InitCommand=cmd(diffuse,Color("Blue");blend,"BlendMode_Add";faderight,1;
			x,SCREEN_CENTER_X+150;diffusealpha,1;zoomto,270,35);
		CodeCommand=function(self,params)
			if not keylock then
				if params.Name=="Start" or params.Name=="Center" then
					if setup_page==5 then
						self:queuecommand("End");
					elseif setup_page==4 then
						self:queuecommand("Choice");
					end;
				elseif setup_page==4 and (params.Name=="Up" or params.Name=="Up2"
					or params.Name=="Down" or params.Name=="Down2") then
						self:queuecommand("Choice");
				end;
			end;
		end;
		ChoiceCommand=function(self)
			self:stoptweening();
			self:y(SCREEN_CENTER_Y+40*setup_choice+2);
			(cmd(diffusealpha,0;linear,0.2;diffusealpha,1))(self);
		end;
		EndCommand=function(self)
			(cmd(diffusealpha,1;linear,0.5;diffusealpha,0))(self);
		end;
	};
	-- [ja] サウンド 
	LoadActor(THEME:GetPathS("Common","Start")) .. {
		CodeCommand = function(self, params)
			if not keylock then
				if params.Name=="Start" or params.Name=="Center" then
					self:stop();
					self:play();
				end;
			end;
		end;
	}; 
	LoadActor(THEME:GetPathS("Common","value")) .. {
		CodeCommand = function(self, params)
			if not keylock and setup_page==4 then
				if params.Name=="Up" or params.Name=="Up2"
					or params.Name=="Down" or params.Name=="Down2" then
					self:stop();
					self:play();
				end;
			end;
		end;
	};
};

for i=1,#setup_select_preset do
t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(fov,60);
	-- [ja] 選択肢 
	LoadFont("Common Normal")..{
		InitCommand=cmd(Center;diffuse,Color("White");strokecolor,Color("Outline");
			diffusealpha,0;horizalign,left;zoom,0.8;maxwidth,320;settext,setup_select_preset[i];
			x,SCREEN_CENTER_X+20;diffusealpha,0;);
		CodeCommand=function(self,params)
			if not keylock then
				if params.Name=="Start" or params.Name=="Center" then
					if setup_page==5 then
						self:queuecommand("End");
					elseif setup_page==4 then
						self:queuecommand("Draw");
					end;
				elseif setup_page==4 and (params.Name=="Up" or params.Name=="Up2"
					or params.Name=="Down" or params.Name=="Down2") then
						self:queuecommand("Choice");
				end;
			end;
		end;
		DrawCommand=function(self)
			self:stoptweening();
			self:y(SCREEN_CENTER_Y+40*(i-1));
			if i-1==setup_choice then
				self:diffuse(ColorLightTone2(Color("Blue")));
			else
				self:diffuse(ColorDarkTone(Color("Blue")));
			end;
			(cmd(diffusealpha,0;linear,0.2;diffusealpha,1))(self);
		end;
		ChoiceCommand=function(self)
			self:stoptweening();
			self:y(SCREEN_CENTER_Y+40*(i-1));
			if i-1==setup_choice then
				self:diffuse(ColorLightTone2(Color("Blue")));
			else
				self:diffuse(ColorDarkTone(Color("Blue")));
			end;
		end;
		EndCommand=function(self)
			(cmd(diffusealpha,1;linear,0.5;diffusealpha,0))(self);
			if setup_page==5 then
				if setup_choice==1 then
					SetUserPref_Theme("UserHoldJudgmentType", 'StepMania');
					SetUserPref_Theme("UserDifficultyName", 'StepMania');
					SetUserPref_Theme("UserDifficultyColor", 'StepMania');
					SetUserPref_Theme("UserJudgementLabel", 'StepMania');
					SetUserPref_Theme("UserMeterType", 'Default');
					SetUserPref_Theme("UserMineHitMiss", 'false');
					SetUserPref_Theme("UserScoreMode", 'DancePoints');
				elseif setup_choice==2 then
					SetUserPref_Theme("UserHoldJudgmentType", 'DDR');
					SetUserPref_Theme("UserDifficultyName", 'DDR EXTREME');
					SetUserPref_Theme("UserDifficultyColor", 'DDR');
					SetUserPref_Theme("UserJudgementLabel", 'DDR');
					SetUserPref_Theme("UserMeterType", 'Default');
					SetUserPref_Theme("UserMineHitMiss", 'false');
					SetUserPref_Theme("UserScoreMode", 'Default');
				elseif setup_choice==3 then
					SetUserPref_Theme("UserHoldJudgmentType", 'DDR');
					SetUserPref_Theme("UserDifficultyName", 'DDR SuperNOVA');
					SetUserPref_Theme("UserDifficultyColor", 'DDR');
					SetUserPref_Theme("UserJudgementLabel", 'DDR SuperNOVA');
					--SetUserPref_Theme("UserMeterType", 'DDR X');
					SetUserPref_Theme("UserMeterType", 'Default');
					SetUserPref_Theme("UserMineHitMiss", 'true');
					SetUserPref_Theme("UserScoreMode", 'DDR SuperNOVA2');
				end;
			end;
		end;
	};
};
end;

return t;