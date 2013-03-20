-- [ja] 画面の切り替えや効果音関係をこっちにまとめた 

local t = Def.ActorFrame{};
-- [ja] 対象グループ 
local sys_group=GetUserPref_Theme("ExGroupName");
local exstage=GetEXFolderStage();
-- [ja] 選曲式か、強制確定か 
local sys_extype=GetGroupParameter(sys_group,"Extra"..exstage.."Type");
sys_extype=string.lower(sys_extype);

-- [ja] 選択可能な曲数 
local load_cnt=GetEXFolder_SongCnt(sys_group,exstage)

-- [ja] システム的にキー操作を受け付けるタイミング 
local sys_keyok=false;

local key_selected=((sys_extype=="song") and 1 or 0);

-- Sounds
-- [ja] フラグ管理より上に書かないと一部音が鳴らなかったりするんです 
if sys_extype~="song" then
	t[#t+1] = Def.ActorFrame {
		CodeCommand=function(self,params)
			if sys_keyok and GAMESTATE:IsHumanPlayer(params.PlayerNumber) and sys_extype~="song" then
				if params.Name == 'Back' then
					if key_selected<1 then
						self:queuecommand("Back");
					end;
				elseif params.Name=="Start" then
					if load_cnt>0 then
						if key_selected<2 then
							self:queuecommand("Start");
						end;
					else
						self:queuecommand("Back");
					end;
				elseif (params.Name == 'Left' or params.Name == 'Left2') then
					if key_selected<1 then
						self:queuecommand("Left");
					end;
				elseif (params.Name == 'Right' or params.Name == 'Right2') then
					if key_selected<1 then
						self:queuecommand("Right");
					end;
				elseif (params.Name == 'Up' or params.Name == 'Up2') then
					if key_selected<1 then
						self:queuecommand("Up");
					end;
				elseif (params.Name == 'Down' or params.Name == 'Down2') then
					if key_selected<1 then
						self:queuecommand("Down");
					end;
				end;
			end;
		end;
		-- BGM 
		Def.Sound {
			InitCommand=function(self)
				local bgm=GetGroupParameter(sys_group,"Extra"..GetEXFolderStage().."SelectBGM");
				if bgm~="" and FILEMAN:DoesFileExist("/Songs/"..sys_group.."/"..bgm)  then
					self:load("/Songs/"..sys_group.."/"..bgm);
				elseif bgm~="" and FILEMAN:DoesFileExist("/AdditionalSongs/"..sys_group.."/"..bgm) then
					self:load("/AdditionalSongs/"..sys_group.."/"..bgm);
				else
					self:load(THEME:GetPathS("ScreenSelectMusic","loop music"));
				end;
				self:stop();
				self:sleep(0.5);
				self:queuecommand("Play");
			end;
			PlayCommand=cmd(play);
		};
		-- [ja] 難易度切り替え（↑） 
		LoadActor(THEME:GetPathS("_switch","up")) .. {
			SelectMenuOpenedMessageCommand=cmd(stop;play);
		};
		-- [ja] 難易度切り替え（↓）
		LoadActor(THEME:GetPathS("_switch","down")) .. {
			SelectMenuClosedMessageCommand=cmd(stop;play);
		};
		-- [ja] 決定 
		LoadActor(THEME:GetPathS("Common","start")) .. {
			StartCommand = function(self)
				self:stop();
				self:play();
				self:sleep(1);
				if ScreenOptionFlag then
					keylock=true;
					sys_keyok=false;
				end;
			end;
			SelectedCommand=function(self)
				self:stop();
				self:play();
				self:sleep(1);
				if ScreenOptionFlag then
					keylock=true;
					sys_keyok=false;
				end;
			end;
		};
		LoadActor(THEME:GetPathS("Common","value")) .. {
			UpCommand = function(self)
				self:stop();
				self:play();
			end;
			DownCommand = function(self)
				self:stop();
				self:play();
			end;
		};
		LoadActor(THEME:GetPathS("Common","Cancel")) .. {
			BackCommand = function(self)
				self:stop();
				self:play();
			end;
		};
		LoadActor(THEME:GetPathS("MusicWheel","change")) .. {
			LeftCommand = function(self)
				self:stop();
				self:play();
			end;
			RightCommand = function(self)
				self:stop();
				self:play();
			end;
		};
	};
end;

-- [ja]画面切り替え時のエフェクト 
t[#t+1] = 
Def.ActorFrame{
	CodeMessageCommand = function(self, params)
		if sys_keyok and GAMESTATE:IsHumanPlayer(params.PlayerNumber) and sys_extype~="song" then
			if params.Name == 'Back' then
				self:queuecommand("Back");
			elseif params.Name=="Start" then
				if load_cnt>0 then
					if key_selected==0 then
						if sys_extype=="song" then
							self:queuecommand("SelectedS");
						else
							self:queuecommand("SelectedF");
							key_selected=1;
						end;
					elseif key_selected==1 then
						key_selected=2;
					end;
				else
					self:queuecommand("Back");
				end;
			end;
		end;
	end;
	OnCommand=function(self)
		if sys_extype=="song" then
			self:queuecommand("SelectedS");
		else
			sys_keyok=false;
			self:sleep(EXF_BEGIN_WAIT());
			self:queuecommand("KeyUnlock");
		end;
	end;
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;Center;diffuse,0,0,0,((sys_extype=="song") and 1 or 0));
		KeyUnlockCommand=function(self) sys_keyok=true; end;
		BackCommand=cmd(linear,0.3;diffusealpha,1;queuecommand,"PrevScreen");
		PrevScreenCommand=function(self)
			GAMESTATE:ApplyGameCommand( "mod,bar");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			SCREENMAN:SetNewScreen("ScreenSelectMusic");
		end;
		SelectedFCommand=cmd(stoptweening;linear,1.0;queuecommand,"NextScreen");
		SelectedSCommand=cmd(stoptweening;linear,0.1;queuecommand,"NextScreen");
		NextScreenCommand=function(self)
			-- [ja] 一旦難易度を保存して、オプションで変更されても元に戻せるようにする 
			for pn=1,2 do
				if GAMESTATE:IsHumanPlayer('PlayerNumber_P'..pn) then
					SetUserPref_Theme("ExDifficultyP"..pn,tostring(GAMESTATE:GetCurrentSteps('PlayerNumber_P1'):GetDifficulty()));
				end;
			end;
			-- ------------
			if sys_extype=="song" then
				SetUserPref_Theme("ExFolderFlag","Ex"..exstage.."GamePlay");
				SCREENMAN:SetNewScreen("ScreenStageInformation");
			else
				SetUserPref_Theme("ExFolderFlag","Ex"..exstage.."GamePlay");
				if key_selected==2 then
					SCREENMAN:SetNewScreen("ScreenPlayerOptions");
				else
					SCREENMAN:SetNewScreen("ScreenStageInformation");
				end;
			end;
		end;
	};
};

-- [ja]最初だけ背景どーんと表示 
local bg=GetGroupParameter(sys_group,"Extra"..GetEXFolderStage().."BackGround");
local fn=split("%.",bg);
if bg~="" and FILEMAN:DoesFileExist("/Songs/"..sys_group.."/"..bg)  then
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			if string.lower(fn[#fn])~="lua" then
				self:Center();
			else
				local f=OpenFile("/AdditionalSongs/"..sys_group.."/"..bg);
				local data=string.lower(f:Read());
				CloseFile(f);
				if string.find(data,"diffuse",1,true) then
					self:zoom(0);
				end;
			end;
		end;
		LoadActor("/Songs/"..sys_group.."/"..bg)..{
			OnCommand=cmd(sleep,0.5;diffusealpha,1;linear,0.3;diffusealpha,0;);
		};
	};
elseif bg~="" and FILEMAN:DoesFileExist("/AdditionalSongs/"..sys_group.."/"..bg) then
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			if string.lower(fn[#fn])~="lua" then
				self:Center();
			else
				local f=OpenFile("/AdditionalSongs/"..sys_group.."/"..bg);
				local data=string.lower(f:Read());
				CloseFile(f);
				if string.find(data,"diffuse",1,true) then
					self:zoom(0);
				end;
			end;
		end;
		LoadActor("/AdditionalSongs/"..sys_group.."/"..bg)..{
			OnCommand=cmd(sleep,0.5;diffusealpha,1;linear,0.3;diffusealpha,0;);
		};
	};
end;

return t;