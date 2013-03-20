local t = LoadFallbackB();
local keylock=true;

-- [ja] chk_XXX … group.iniに定義されている曲用 
local chk_folders={};
local chk_songs={};

-- [ja] load_XXX … 実際に選曲できる曲用 
local load_folders={};
local load_songs={};
local load_cnt=0;
local load_jackets={};
local load_songtitle={};
local load_songartist={};

local dif_list={
	'Difficulty_Beginner',
	'Difficulty_Easy',
	'Difficulty_Medium',
	'Difficulty_Hard',
	'Difficulty_Challenge',
	'Difficulty_Edit'
};
local sys_group="";
local sys_dif={4,4};
-- [ja] 指定難易度が存在しないときに、 
-- 上の難易度を選択するか下の難易度を選択するか記憶用変数 
-- (移動前の番号) 
local sys_dif_old={4,4};
-- [ja] ホイール移動量 
local sys_wheel=0.0;
local sys_focus=0;
-- [ja] システム的にキー操作を受け付けるタイミング 
local sys_keyok=false;

-- [ja] 対象グループ 
sys_group=GetUserPref_Theme("ExGroupName");

local exstage=GetEXFolderStage();

-- [ja] 選曲式か、強制確定か 
local sys_extype=GetGroupParameter(sys_group,"Extra"..exstage.."Type");
sys_extype=string.lower(sys_extype);

-- [ja] 楽曲情報文字列（#ExtraXSongsの中身）
local sys_songunlock=split(":",string.lower(GetGroupParameter(sys_group,"Extra"..exstage.."Songs")));
local sys_songunlockU=split(":",GetGroupParameter(sys_group,"Extra"..exstage.."Songs"));
-- [ja] 難易度別条件取得（曲切り替えのたびに代入） 
local sys_songunlock_prm1;
local sys_songunlock_prm1U;
-- [ja] 取得した難易度別条件をさらにパラメータごとに分割 
local sys_songunlock_prm2;
local sys_songunlock_prm2U;

-- [ja] 難易度別解禁（曲を切り替えるたびに呼び出し）
local sys_difunlock={true,true,true,true,true,true};

-- [ja] 楽曲確定フラグ（決定後カーソル移動させないように 
local selectedflag=false;

-- [ja] ゲージの状態を指定（この時点では定義だけで、実際には反映されない） 
local exlife=GetGroupParameter(sys_group,"Extra"..exstage.."LifeLevel");
if string.lower(exlife)=="hard" then
	SetUserPref_Theme("ExLifeLevel","Hard");
elseif string.lower(exlife)=="1" then
	SetUserPref_Theme("ExLifeLevel","1");
elseif string.lower(exlife)=="2" then
	SetUserPref_Theme("ExLifeLevel","2");
elseif string.lower(exlife)=="3" then
	SetUserPref_Theme("ExLifeLevel","3");
elseif string.lower(exlife)=="4" then
	SetUserPref_Theme("ExLifeLevel","4");
elseif string.lower(exlife)=="5" then
	SetUserPref_Theme("ExLifeLevel","5");
elseif string.lower(exlife)=="6" then
	SetUserPref_Theme("ExLifeLevel","6");
elseif string.lower(exlife)=="7" then
	SetUserPref_Theme("ExLifeLevel","7");
elseif string.lower(exlife)=="8" then
	SetUserPref_Theme("ExLifeLevel","8");
elseif string.lower(exlife)=="9" then
	SetUserPref_Theme("ExLifeLevel","9");
elseif string.lower(exlife)=="10" then
	SetUserPref_Theme("ExLifeLevel","10");
elseif string.lower(exlife)=="pfc" or string.lower(exlife)=="w2fc" then
	SetUserPref_Theme("ExLifeLevel","PFC");
elseif string.lower(exlife)=="mfc" or string.lower(exlife)=="w1fc" then
	SetUserPref_Theme("ExLifeLevel","MFC");
elseif string.lower(exlife)=="hardnorecover" or string.lower(exlife)=="hex1" then
	SetUserPref_Theme("ExLifeLevel","HardNoRecover");
elseif string.lower(exlife)=="norecover" or string.lower(exlife)=="ex1" then
	SetUserPref_Theme("ExLifeLevel","NoRecover");
elseif string.lower(exlife)=="suddendeath" or string.lower(exlife)=="ex2" then
	SetUserPref_Theme("ExLifeLevel","Suddendeath");
else
	SetUserPref_Theme("ExLifeLevel","Normal");
end;

local rnd_base=math.round(GetStageState("PDP", "Last", "+")*10000);
local rnd_folder="";
local rnd_song;
local sp_songtitle="";
local sp_songartist="";
local sp_songjacket={"",""};
local sp_songbanner={"",""};

-- [ja] 出現条件を満たしている難易度を返す 
local function SetDifficultyFlag(groupname,foldername)
	local sdif_list={
		'$',
		'%-beginner$',
		'%-easy$',
		'%-medium$',
		'%-hard$',
		'%-challenge$',
		'%-edit$'
	};
	-- [ja] 全譜面選択可能状態 
	local diflock={true,true,true,true,true,true}
	local expath=GetExFolderPath(sys_group);
	rnd_folder="";
	sp_songtitle="";
	sp_songartist="";
	sp_songjacket={"",""};
	sp_songbanner={"",""};
	-- [ja] group.iniに記載されている条件を満たさない譜面のフラグをfalseにする
	for k=1,#sys_songunlock do 
		if string.find(sys_songunlock[k],""..string.lower(foldername).."|",1,true) then  
			sys_songunlock_prm1=split("|",sys_songunlock[k]);
			sys_songunlock_prm1U=split("|",sys_songunlockU[k]);
			if #sys_songunlock_prm1>=2 then	-- [ja] 曲フォルダ名,条件1...となるのでパラメータが2つ異常ないと不正 
				for l=2,#sys_songunlock_prm1 do
					sys_songunlock_prm2=split(">",sys_songunlock_prm1[l]);
					sys_songunlock_prm2U=split(">",sys_songunlock_prm1U[l]);
					if #sys_songunlock_prm2>1 then	-- [ja] パラメータが2つ以上ない場合は不正な書式として無視する 
						if sys_songunlock_prm2[1]=="random" then
							rnd_folder=sys_songunlock_prm2[(rnd_base%(#sys_songunlock_prm2-1))+2];
							rnd_song=GetFolder2Song(groupname,rnd_folder);
						elseif sys_songunlock_prm2[1]=="banner" then
							if FILEMAN:DoesFileExist(expath..""..sys_songunlock_prm2[2]) then
								sp_songbanner[0]=GetFolder2Song(groupname,foldername):GetSongDir();
								sp_songbanner[1]=expath..""..sys_songunlock_prm2[2];
								if load_jackets[""..foldername]==nil then
									load_jackets[""..foldername]=sp_songbanner[1];
								end;
							end;
						elseif sys_songunlock_prm2[1]=="jacket" then
							if FILEMAN:DoesFileExist(expath..""..sys_songunlock_prm2[2]) then
								sp_songjacket[0]=GetFolder2Song(groupname,foldername):GetSongDir();
								sp_songjacket[1]=expath..""..sys_songunlock_prm2[2];
								load_jackets[""..foldername]=sp_songjacket[1];
							end;
						elseif sys_songunlock_prm2[1]=="title" then
							sp_songtitle=sys_songunlock_prm2U[2];
							load_songtitle[""..foldername]=sp_songtitle;
						elseif sys_songunlock_prm2[1]=="artist" then
							sp_songartist=sys_songunlock_prm2U[2];
							load_songartist[""..foldername]=sp_songartist;
						elseif #sys_songunlock_prm2==3 then
							local chk_mode;
							if string.find(sys_songunlock_prm2[1],"^last.*") then
								chk_mode="last";
							elseif string.find(sys_songunlock_prm2[1],"^max.*") then
								chk_mode="max";
							elseif string.find(sys_songunlock_prm2[1],"^min.*") then
								chk_mode="min";
							elseif string.find(sys_songunlock_prm2[1],"^played.*") then
								chk_mode="played";
							else
								chk_mode="avg";
							end;
							-- [ja] めんどいんで数値以外を条件にした場合無視 
							local break_flag=false;
							if tonumber(sys_songunlock_prm2[2]) then
								-- [ja] 難易度別 
								for dif=1,7 do
									if not break_flag then
										local ret=-9999999999;
										if string.find(sys_songunlock_prm2[1],"^.*grade"..sdif_list[dif]) then
											ret=GetStageState("grade", chk_mode, sys_songunlock_prm2[3]);
										elseif string.find(sys_songunlock_prm2[1],"^.*pdp"..sdif_list[dif]) 
											or string.find(sys_songunlock_prm2[1],"^.*perdancepoints"..sdif_list[dif]) then	--[ja] DPより先にPDPを書いておかないと条件を満たしてしまう 
											ret=GetStageState("pdp", chk_mode, sys_songunlock_prm2[3])*100;
										elseif string.find(sys_songunlock_prm2[1],"^.*dp"..sdif_list[dif]) 
											or string.find(sys_songunlock_prm2[1],"^.*dancepoints"..sdif_list[dif]) then
											ret=GetStageState("dp", chk_mode, sys_songunlock_prm2[3]);
										elseif string.find(sys_songunlock_prm2[1],"^.*combo"..sdif_list[dif]) 
											or string.find(sys_songunlock_prm2[1],"^.*maxcombo"..sdif_list[dif]) then
											ret=GetStageState("combo", chk_mode, sys_songunlock_prm2[3]);
										elseif string.find(sys_songunlock_prm2[1],"^.*meter"..sdif_list[dif]) then
											ret=GetStageState("meter", chk_mode, sys_songunlock_prm2[3]);
										else
											ret=-9999999999;
										end;
										if ret>-9999999999 then
											if sys_songunlock_prm2[3]=="+" or sys_songunlock_prm2[3]=="over" then
												if ret<tonumber(sys_songunlock_prm2[2]) then
													if dif==1 then
														diflock={false,false,false,false,false,false};
													else
														diflock[dif-1]=false;
													end;
												else
													diflock[dif-1]=true;
												end;
														break_flag=true;
											elseif sys_songunlock_prm2[3]=="-" or sys_songunlock_prm2[3]=="under" then
												if ret>tonumber(sys_songunlock_prm2[2]) then
													if dif==1 then
														diflock={false,false,false,false,false,false};
													else
														diflock[dif-1]=false;
													end;
												else
													diflock[dif-1]=true;
												end;
											end;
											break_flag=true;
										end;
									end;
								end;
							else
							-- [ja] その結果バージョン1.1で苦労したっていう 
								for dif=1,7 do
									if not break_flag then
										local ret=0;
										if string.find(sys_songunlock_prm2[1],"^.*song"..sdif_list[dif]) then
											ret=GetStageState("song", sys_songunlock_prm2[2], sys_songunlock_prm2[3]);
										end;
										if sys_songunlock_prm2[3]=="+" or sys_songunlock_prm2[3]=="over" then
											if (chk_mode=="played" and ret==0) or (chk_mode=="last" and ret<_MAXSTAGE()) then
												if dif==1 then
													diflock={false,false,false,false,false,false};
												else
													diflock[dif-1]=false;
												end;
											else
												diflock[dif-1]=true;
											end;
													break_flag=true;
										elseif sys_songunlock_prm2[3]=="-" or sys_songunlock_prm2[3]=="under" then
											if (chk_mode=="played" and ret>0) or (chk_mode=="last" and ret==_MAXSTAGE()) then
												if dif==1 then
													diflock={false,false,false,false,false,false};
												else
													diflock[dif-1]=false;
												end;
											else
												diflock[dif-1]=true;
											end;
										end;
										break_flag=true;
									end;
								end;
							end;
						end;
					end;
					if diflock[1]==false or diflock[2]==false or diflock[3]==false 
						or diflock[4]==false or diflock[5]==false or diflock[6]==false then
					--	break;
					end;
				end;
			end;
			break;
		end;
	end;
	return diflock;
end;

t[#t+1] = StandardDecorationFromFileOptional("AlternateHelpDisplay","AlternateHelpDisplay");

local function PercentScore(pn)
	local t = LoadFont("Common normal")..{
		InitCommand=cmd(zoom,0.625;shadowlength,1);
		BeginCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			local SongOrCourse, StepsOrTrail;
			if GAMESTATE:IsCourseMode() then
				SongOrCourse = GAMESTATE:GetCurrentCourse();
				StepsOrTrail = GAMESTATE:GetCurrentTrail(pn);
			else
				SongOrCourse = GAMESTATE:GetCurrentSong();
				StepsOrTrail = GAMESTATE:GetCurrentSteps(pn);
			end;

			local profile, scorelist;
			local text = "";
			if SongOrCourse and StepsOrTrail then
				local st = StepsOrTrail:GetStepsType();
				local diff = StepsOrTrail:GetDifficulty();
				local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
				local cd = GetCustomDifficulty(st, diff, courseType);
				self:diffuse(CustomDifficultyToColor(cd));
				self:shadowcolor(CustomDifficultyToDarkColor(cd));

				if PROFILEMAN:IsPersistentProfile(pn) then
					-- player profile
					profile = PROFILEMAN:GetProfile(pn);
				else
					-- machine profile
					profile = PROFILEMAN:GetMachineProfile();
				end;

				scorelist = profile:GetHighScoreList(SongOrCourse,StepsOrTrail);
				assert(scorelist)
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];
				if topscore then
					text = string.format("%.2f%%", topscore:GetPercentDP()*100.0);
					-- 100% hack
					if text == "100.00%" then
						text = "100%";
					end;
				else
					text = string.format("%.2f%%", 0);
				end;
			else
				text = "";
			end;
			self:settext(text);
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
		CodeMessageCommand = function(self, params)
			if sys_keyok and GAMESTATE:IsHumanPlayer(params.PlayerNumber) and sys_extype~="song" then
				if load_cnt>0 then
					if params.Name == 'Left' then
						self:queuecommand("Set");
					elseif params.Name == 'Right' then
						self:queuecommand("Set");
					end;
				end;
			end;
		end;
	};

	if pn == PLAYER_1 then
		t.CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
		t.CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
	else
		t.CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
		t.CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	end

	return t;
end

--[ja] バナーフレーム 
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,THEME:GetMetric("ScreenSelectMusic","BannerFrameX");y,THEME:GetMetric("ScreenSelectMusic","BannerFrameY"););
	OnCommand=THEME:GetMetric("ScreenSelectMusic","BannerFrameOnCommand");
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame under"))..{
		InitCommand=cmd(x,200-2;y,52);
		SetMessageCommand=function(self)
			self:stoptweening();
			if SCREEN_HEIGHT/SCREEN_WIDTH>0.7 then
				self:y(22);
			else
				self:y(52);
			end;
			self:diffusealpha(1);
			self:sleep(0.2);
			self:linear(0.2);
			self:diffusealpha(0);
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	};
	LoadActor(THEME:GetPathG("ScreenSelectMusic","BannerFrame/frame"));
	Def.Sprite{
		SetCommand=function(self)
			self:stoptweening();
			local song=_SONG();
			if sp_songbanner[1]~="" then
				self:diffusealpha(1);
					self:Load(sp_songbanner[1]);
			elseif song then
				self:diffusealpha(1);
				if song:HasBanner() then
					self:LoadBackground(song:GetBannerPath());
				else
					self:Load(THEME:GetPathG("Common fallback","banner"));
				end;
			else
				self:diffusealpha(0);
				self:Load(THEME:GetPathG("Common fallback","banner"));
			end;
			self:scaletofit(0,0,192*1.03,60*1.03);
			self:x(4);
			self:y(0);
			self:linear(0.2);
			self:scaletofit(0,0,192,60);
			self:x(4);
			self:y(0);
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	};
	Def.Quad{
		InitCommand=cmd(x,4;zoomto,192,60;diffuse,0,0,0,0.8;diffusebottomedge,0,0,0,0.5;);
	};
	LoadActor(THEME:GetPathG("ScreenSelectMusic","BannerFrame/split"))..{
		BeginCommand=cmd(visible,false;setanimate,false;);
		InitCommand=cmd(visible,false;setanimate,false;);
		OnCommand=cmd(playcommand,"Set");
		SetMessageCommand=function(self)
			if _SONG() then
				self:stoptweening();
				self:x(-36);
			--	self:blend("BlendMode_Add");
			--	if SCREEN_HEIGHT/SCREEN_WIDTH<=0.7 then
			--		self:y(-18);
			--	else
					self:y(12);
			--	end;
				local st=GAMESTATE:GetCurrentStyle():GetStepsType();
				local f=false;
				local song=_SONG();
				for i=1,6 do
					if song:HasStepsTypeAndDifficulty(st,Difficulty[i]) then
						if song:IsStepsUsingDifferentTiming(song:GetOneSteps(st,Difficulty[i])) then
							f=true;
							break;
						end;
					end;
				end;
				if f then
					self:visible(true);
				else
					self:visible(false);
				end;
			else
				self:visible(false);
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	};
	LoadActor(THEME:GetPathG("ScreenSelectMusic","BannerFrame/long_marathon"))..{
		BeginCommand=cmd(visible,false;setanimate,false;);
		InitCommand=cmd(visible,false;setanimate,false;);
		OnCommand=cmd(playcommand,"Set");
		SetMessageCommand=function(self)
			local song=_SONG();
			if song then
				self:stoptweening();
				self:x(63);
				self:animate(false);
			--	self:blend("BlendMode_Add");
			--	if SCREEN_HEIGHT/SCREEN_WIDTH<=0.7 then
			--		self:y(-18);
			--	else
					self:y(12);
			--	end;
				if song:IsLong() then
					self:setstate(0);
					self:visible(true);
				elseif song:IsMarathon() then
					self:setstate(1);
					self:visible(true);
				else
					self:visible(false);
				end;
			else
				self:visible(false);
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	};
	LoadActor(THEME:GetPathG("ScreenSelectMusic","BannerFrame/over"));
};

-- [ja] ボスフォルダ用 
--	*****************************************************************************************************************************************************
-- [ja] グローバル変数と混ざっててアレな関数 
local function GetExFolderSongList()
	local txt_folders=GetGroupParameter(sys_group,"Extra"..exstage.."List");
	chk_folders=split(":",txt_folders);
	-- [ja] 選択可能な曲を取得 
	local str="";
	for j=1,#chk_folders do
		local gsong=GetFolder2Song(sys_group,chk_folders[j])
		if gsong then
			-- [ja] ここで選択可能な難易度をチェックして、全難易度選択不可能なら登録しない 
			sys_difunlock=SetDifficultyFlag(sys_group,chk_folders[j]);
			-- [ja] フラグfalse or 譜面自体が存在しない場合選択不可能に設定   
			local unlock_chk=0;
			for k=1,6 do
				if ((not gsong:HasStepsTypeAndDifficulty(GAMESTATE:GetCurrentStyle():GetStepsType(),dif_list[k])) or sys_difunlock[k]==false) then
					-- [ja] ここではあくまでも曲の登録をするかの問題なので、フラグ自体をいじらない 
					unlock_chk=unlock_chk+1;
				end;
			end;
			if unlock_chk<6 then 
				load_cnt=load_cnt+1;
				load_songs[load_cnt]=gsong;
				load_folders[load_cnt]=chk_folders[j];
			end;
		end;
	end;
end;
GetExFolderSongList();
local function GetSongBanner(song)
	if song then
		local path = song:GetBannerPath()
		if path then return path end
	end
	return THEME:GetPathG("Common","fallback background")
end
local function WheelOffsetX(itemIndex)
	local offsetFromCenter=itemIndex-sys_wheel;
	local ret;
	if SCREEN_HEIGHT/SCREEN_WIDTH<0.65 then
		if offsetFromCenter<=-1 then
			ret=1.0*offsetFromCenter*110-50;
		elseif offsetFromCenter>=1 then
			ret=1.0*offsetFromCenter*110+50;
		else
			ret=1.0*offsetFromCenter*160;
		end;
	else
		if offsetFromCenter<=-1 then
			ret=1.0*offsetFromCenter*85-60;
		elseif offsetFromCenter>=1 then
			ret=1.0*offsetFromCenter*85+60;
		else
			ret=1.0*offsetFromCenter*145;
		end;
	end;
	return ret;
end;
local function WheelOffsetY(itemIndex)
	local offsetFromCenter=itemIndex-sys_wheel;
	local ret;
	if SCREEN_HEIGHT/SCREEN_WIDTH<0.65 then
		if offsetFromCenter<=-1 then
			ret=0;
		elseif offsetFromCenter>=1 then
			ret=0;
		else
			ret=-48+(math.abs(offsetFromCenter)*48);
		end;
	else
		if offsetFromCenter<=-1 then
			ret=12;
		elseif offsetFromCenter>=1 then
			ret=12;
		else
			ret=-48+(math.abs(offsetFromCenter)*48)+math.abs(offsetFromCenter)*12;
		end;
	end;
	return ret;
end;
local function WheelOffsetZoom(itemIndex)
	local offsetFromCenter=itemIndex-sys_wheel;
	local ret;
	if SCREEN_HEIGHT/SCREEN_WIDTH<0.65 then
		if offsetFromCenter<=-1 then
			ret=0.5;
		elseif offsetFromCenter>=1 then
			ret=0.5;
		else
			ret=0.5+(0.5-(math.abs(offsetFromCenter)*0.5));
		end;
	else
		if offsetFromCenter<=-1 then
			ret=0.4;
		elseif offsetFromCenter>=1 then
			ret=0.4;
		else
			ret=0.4+(0.6-(math.abs(offsetFromCenter)*0.6));
		end;
	end;
	return ret;
end;


--	*****************************************************************************************************************************************************
--[ja] ファイルから読み取る情報。何度も呼ぶと重いのでローカル変数で作っておく 
local col="";
local col_t={};
local mettype="";
local fsubtitle=0;
local ssubtitle="";
local stitle="";
local song_number=0;

local wheel_anime=0;

local key_selected=0;
t[#t+1]=Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(visible,false;queuecommand,"ChangeSong");
		CodeMessageCommand = function(self, params)
			if sys_keyok and GAMESTATE:IsHumanPlayer(params.PlayerNumber) and sys_extype~="song" then
				if (params.Name == 'Left' or params.Name == 'Left2') then
					if key_selected==0 then
						self:queuecommand("PrevSong");
						self:queuecommand("ChangeSong");
					end;
				elseif (params.Name == 'Right' or params.Name == 'Right2') then
					if key_selected==0 then
						self:queuecommand("NextSong");
						self:queuecommand("ChangeSong");
					end;
				elseif (params.Name == 'Up' or params.Name == 'Up2') then
					if key_selected==0 then
						local pn=((params.PlayerNumber==PLAYER_1) and 1 or 2);
						local sys_dif_tmp=sys_dif[pn];
						sys_dif[pn]=sys_dif[pn]-1;
						if sys_dif[pn]<1 then sys_dif[pn]=1 end;
						while (sys_dif[pn]>1 and (not song:HasStepsTypeAndDifficulty(GAMESTATE:GetCurrentStyle():GetStepsType(),dif_list[sys_dif[pn]]) or sys_difunlock[sys_dif[pn]]==false)) do
							sys_dif[pn]=sys_dif[pn]-1;
						end;
						if sys_dif[pn]<1 then sys_dif[pn]=sys_dif_tmp; end;
						sys_dif_old[pn]=sys_dif[pn];
						self:queuecommand("ChangeSong");
					end;
				elseif (params.Name == 'Down' or params.Name == 'Down2') then
					if key_selected==0 then
						local pn=((params.PlayerNumber==PLAYER_1) and 1 or 2);
						local sys_dif_tmp=sys_dif[pn];
						sys_dif[pn]=sys_dif[pn]+1;
						if sys_dif[pn]>#dif_list then sys_dif[pn]=#dif_list end;
						while (sys_dif[pn]<#dif_list and (not song:HasStepsTypeAndDifficulty(GAMESTATE:GetCurrentStyle():GetStepsType(),dif_list[sys_dif[pn]]) or sys_difunlock[sys_dif[pn]]==false)) do
							sys_dif[pn]=sys_dif[pn]+1;
						end;
						if sys_dif[pn]>#dif_list then sys_dif[pn]=sys_dif_tmp; end;
						sys_dif_old[pn]=sys_dif[pn];
						self:queuecommand("ChangeSong");
					end;
				elseif params.Name=="Start" then
					if load_cnt>0 then
						if key_selected==0 then
							self:queuecommand("Selected");
						end
						key_selected=key_selected+1;
					end;
				end;
			end;
		end;
		PrevSongCommand=function(self)
			wheel_anime=-1;
			sys_focus=sys_focus-1;
			if sys_focus<0 then sys_focus=sys_focus+load_cnt end;
		end;
		NextSongCommand=function(self)
			wheel_anime=1;
			sys_focus=sys_focus+1;
			if sys_focus>=load_cnt then sys_focus=0 end;
		end;
		ChangeSongCommand=function(self)
			if key_selected==0 then
				-- [ja] ここではじめて選択不可能な譜面のフラグを設定する 
				sys_difunlock=SetDifficultyFlag(sys_group,load_folders[sys_focus+1]);
				if rnd_folder~="" then
					song=rnd_song;
				else
					song=load_songs[sys_focus+1];
				end;
				GAMESTATE:SetCurrentSong(song);	--[ja] 強制曲設定 
				-- [ja] 選択可能難易度確認 
				for pn=1,2 do
					if GAMESTATE:IsHumanPlayer('PlayerNumber_P'..pn) then
						sys_dif[pn]=sys_dif_old[pn];
						while ((not song:HasStepsTypeAndDifficulty(GAMESTATE:GetCurrentStyle():GetStepsType(),dif_list[sys_dif[pn]])) or sys_difunlock[sys_dif[pn]]==false) do
							if sys_dif_old[pn]>3 then
								sys_dif[pn]=sys_dif[pn]-1;
								if sys_dif[pn]<1 then sys_dif[pn]=#dif_list end;
							else
								sys_dif[pn]=sys_dif[pn]+1;
								if sys_dif[pn]>#dif_list then sys_dif[pn]=1 end;
							end;
						end;
						GAMESTATE:SetCurrentSteps('PlayerNumber_P'..pn,
							song:GetOneSteps(GAMESTATE:GetCurrentStyle():GetStepsType(),dif_list[sys_dif[pn]]));
					end;
				end;
			end;
		end;
	};
};

local _i=(SCREEN_HEIGHT/SCREEN_WIDTH<0.55) and -5 or -4;
for i=_i,_i+((SCREEN_HEIGHT/SCREEN_WIDTH<0.55) and 10 or 8) do
	local song;

	t[#t+1]=Def.ActorFrame{
		CodeMessageCommand = function(self, params)
			if sys_keyok and GAMESTATE:IsHumanPlayer(params.PlayerNumber) and sys_extype~="song" then
				if (params.Name == 'Left' or params.Name == 'Left2') then
					self:queuecommand("ChangeSong");
				elseif (params.Name == 'Right' or params.Name == 'Right2') then
					self:queuecommand("ChangeSong");
				end;
			end;
		end;
		InitCommand=function(self)
			self:x(THEME:GetMetric("ScreenSelectMusic","MusicWheelX")+WheelOffsetX(i));
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")+WheelOffsetY(i));
			self:zoom(WheelOffsetZoom(i));
		end;
		ChangeSongCommand=function(self)
			if key_selected==0 then
				self:stoptweening();
				self:x(THEME:GetMetric("ScreenSelectMusic","MusicWheelX")+WheelOffsetX(wheel_anime+i));
				self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")+WheelOffsetY(wheel_anime+i));
				self:zoom(WheelOffsetZoom(wheel_anime+i));
				self:linear(0.1);
				self:playcommand("Init");
				if i==_i+10 then
					wheel_anime=0;
				end;
			end;
		end;
		LoadActor("wheel_song",i,load_jackets,load_songs,load_folders[sys_focus+1],load_cnt,load_songtitle,load_songartist);
	};
end;

-- Score List
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,THEME:GetMetric("ScreenSelectMusic","MusicWheelY")+135);
	LoadActor("scorelist") .. {
	};
	ExListBG();
};
for p=1,2 do
	local pn=((p==1) and PLAYER_1 or PLAYER_2);
	for diff=1,6 do
		t[#t+1] = Def.ActorFrame {
			InitCommand=cmd(x,SCREEN_CENTER_X;y,THEME:GetMetric("ScreenSelectMusic","MusicWheelY")+135);
			DrawExDifList(pn,diff)..{
				BeginCommand=cmd(playcommand,"Set");
				CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
				SetCommand=cmd(visible,sys_difunlock[diff]);
			};
		};
	end;
end;

-- GrooveRadar
t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP1", "GrooveRadarP1" );
t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP2", "GrooveRadarP2" );

t[#t+1] = StandardDecorationFromFileOptional("PaneDisplayTextP1","PaneDisplayTextP1");
t[#t+1] = StandardDecorationFromFileOptional("PaneDisplayTextP2","PaneDisplayTextP2");

--	*****************************************************************************************************************************************************

t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay")..{
	SetCommand=function(self)
		local st=GAMESTATE:GetCurrentStyle():GetStepsType();
		local f=0;
		local song=_SONG();
		if tonumber(VersionDate())>=20120408 then
			if song then
				for i=1,6 do
					if song:HasStepsTypeAndDifficulty(st,Difficulty[i]) then
						if song:IsStepsUsingDifferentTiming(song:GetOneSteps(st,Difficulty[i])) then
							f=10;
							break;
						end;
					end;
				end;
			end;
		end;
		if SCREEN_HEIGHT/SCREEN_WIDTH>=0.65 then
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-100+30-f);
		else
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-100-f);
		end;
	end;
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	OnCommand=cmd(maxwidth,128;horizalign,left;strokecolor,Color("Outline");playcommand,"Set";decelerate,0.2;zoomx,1;);
	BeginCommand=cmd(zoomx,0;);
};
t[#t+1] = StandardDecorationFromFileOptional("BPMLabel","BPMLabel")..{
	SetCommand=function(self)
		local st=GAMESTATE:GetCurrentStyle():GetStepsType();
		local f=0;
		local song=_SONG();
		if tonumber(VersionDate())>=20120408 then
			if song then
				for i=1,6 do
					if song:HasStepsTypeAndDifficulty(st,Difficulty[i]) then
						if song:IsStepsUsingDifferentTiming(song:GetOneSteps(st,Difficulty[i])) then
							f=10;
							break;
						end;
					end;
				end;
			end;
		end;
		
		
		if SCREEN_HEIGHT/SCREEN_WIDTH>=0.65 then
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-100+30-f);
		else
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-100-f);
		end;
	end;
	CurrentSongChangedMessageCommand=cmd(finishtweening;linear,0.2;playcommand,"Set");
	OnCommand=cmd(finishtweening;playcommand,"Set";decelerate,0.2;addx,SCREEN_CENTER_X;zoomx,1;);
	BeginCommand=cmd(zoomx,0;addx,-SCREEN_CENTER_X;);
};

t[#t+1] = StandardDecorationFromFileOptional("SongTime","SongTime") .. {
	SetCommand=function(self)
		local curSelection = nil;
		local length = 0.0;
		self:x(SCREEN_CENTER_X-137);
		local f=0;
		if GAMESTATE:IsCourseMode() then
			curSelection = GAMESTATE:GetCurrentCourse();
			if curSelection then
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				if trail then
					length = TrailUtil.GetTotalSeconds(trail);
				else
					length = 0.0;
				end;
			else
				length = 0.0;
			end;
		else
			curSelection = _SONG();
			if curSelection then
				length = curSelection:MusicLengthSeconds();
				if curSelection:IsLong() then
					f=10;
				elseif curSelection:IsMarathon() then
					f=10;
				else
					f=0;
				end
			else
				length = 0.0;
			end;
		end;
		if SCREEN_HEIGHT/SCREEN_WIDTH>=0.65 then
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-100+30-f);
		else
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-100-f);
		end;
		(cmd(zoom,0.75;strokecolor,Color("Outline");shadowlength,1;))(self);
		self:settext( SecondsToMSS(length) );
	end;
	OnCommand=cmd(finishtweening;playcommand,"Set");
	CurrentSongChangedMessageCommand=cmd(finishtweening;linear,0.2;playcommand,"Set");
	CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
};

if not GAMESTATE:IsCourseMode() then
	t[#t+1] = StandardDecorationFromFileOptional("NewSong","NewSong") .. {
	 	NewShowCommand=THEME:GetMetric("ScreenSelectMusic", "NewSongShowCommand" );
	 	NewHideCommand=THEME:GetMetric("ScreenSelectMusic", "NewSongHideCommand" );
		InitCommand=cmd(playcommand,"Set");
		BeginCommand=cmd(playcommand,"Set");
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
	-- 		local pTargetProfile;
			local sSong;
			-- Start!
			if GAMESTATE:GetCurrentSong() then
				if PROFILEMAN:IsSongNew(GAMESTATE:GetCurrentSong()) then
					self:playcommand("NewShow");
				else
					self:playcommand("NewHide");
				end
			else
				self:playcommand("NewHide");
			end
		end;
		CodeMessageCommand = function(self, params)
			if not keylock and sys_keyok and GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				if params.Name=="Start" then
					if load_cnt>0 then
						self:queuecommand("NewHide");
					end;
				end;
			end;
		end;
	};
	t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");
end;

--t[#t+1] = StandardDecorationFromFileOptional("DifficultyDisplay","DifficultyDisplay");
t[#t+1] = StandardDecorationFromFileOptional("SortOrderFrame","SortOrderFrame") .. {
--[[ 	BeginCommand=cmd(playcommand,"Set");
	SortOrderChangedMessageCommand=cmd(playcommand,"Set";);
	SetCommand=function(self)
		local s = SortOrderToLocalizedString( GAMESTATE:GetSortOrder() );
		self:settext( s );
		self:playcommand("Sort");
	end; --]]
};
t[#t+1] = StandardDecorationFromFileOptional("SortOrder","SortOrderText") .. {
	BeginCommand=cmd(playcommand,"Set");
	SortOrderChangedMessageCommand=cmd(playcommand,"Set";);
	SetCommand=function(self)
		--local s = SortOrderToLocalizedString( GAMESTATE:GetSortOrder() );
		self:settext( "EXFOLDER" );
		self:playcommand("Sort");
	end;
};
--[[
t[#t+1] = StandardDecorationFromFileOptional("SongOptionsFrame","SongOptionsFrame") .. {
	ShowPressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsFrameShowCommand");
	ShowEnteringOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsFrameEnterCommand");
	HidePressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsFrameHideCommand");
};
t[#t+1] = StandardDecorationFromFileOptional("SongOptions","SongOptionsText") .. {
	ShowPressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsShowCommand");
	ShowEnteringOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsEnterCommand");
	HidePressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsHideCommand");
};
--]]

-- [ja]決定後のエフェクト 
local key_selected_effect=false;
t[#t+1] = Def.ActorFrame{
	CodeMessageCommand = function(self, params)
		if sys_keyok and GAMESTATE:IsHumanPlayer(params.PlayerNumber) and sys_extype~="song" then
			if params.Name=="Start" and not key_selected_effect and load_cnt>0 then
				key_selected_effect=true;
				self:queuecommand("Selected");
			end;
		end;
	end;
	OnCommand=function(self)
		if PREFSMAN:GetPreference("MenuTimer") then
			self:sleep(THEME:GetMetric("ScreenSelectExMusic","TimerSeconds"));
	--		self:queuecommand("Selected");
		end;
	end;
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;Center;diffuse,0,0,0,0);
		SelectedCommand=cmd(linear,0.3;diffusealpha,1);
	};
	Def.Sprite{
		InitCommand=cmd(Center;diffusealpha,0);
		SelectedCommand=function(self)
			local song=_SONG();
			if song then
				local loaded;
				if song:HasBackground() then
					self:LoadBackground(song:GetBackgroundPath());
					loaded=1;
				elseif song:HasJacket() then
					self:LoadBackground(song:GetJacketPath());
					loaded=2;
				elseif song:HasBanner() then
					self:LoadBackground(song:GetBannerPath());
					loaded=3;
				else
					loaded=0;
				end;
				self:zoomtowidth(SCREEN_WIDTH);
				self:zoomtoheight(self:GetHeight()*SCREEN_WIDTH/self:GetWidth());
				self:sleep(0.2);
				self:blend("BlendMode_Add");
				(cmd(x,SCREEN_LEFT;y,SCREEN_TOP+200;cropleft,0.5;cropright,0;croptop,0.5;cropbottom,0;diffusealpha,0.8;linear,0.1;
						diffusealpha,0;x,SCREEN_LEFT;y,SCREEN_TOP+200;cropleft,0.5;croptop,0.5;sleep,0.05;
					x,SCREEN_RIGHT;y,SCREEN_CENTER_Y-50;cropleft,0;cropright,0.5;croptop,0;cropbottom,0.5;diffusealpha,0.8;linear,0.1;
						diffusealpha,0;x,SCREEN_RIGHT;y,SCREEN_CENTER_Y-50;cropright,0.5;croptop,0;cropbottom,0.5;sleep,0.05;
					x,SCREEN_CENTER_X-30;y,SCREEN_BOTTOM-50;cropleft,0.25;cropright,0.25;croptop,0.25;cropbottom,0.25;diffusealpha,0.8;linear,0.1;
						diffusealpha,0))(self);
				self:sleep(1);
			end;
		end;
	};
	Def.Sprite{
		InitCommand=cmd(Center;diffusealpha,0);
		SelectedCommand=function(self)
			local song=_SONG();
			if song then
				if song:HasBackground() then
					self:LoadBackground(song:GetBackgroundPath());
				else
					self:Load(THEME:GetPathG("Common","fallback background"));
				end;
				self:zoomtowidth(SCREEN_WIDTH*2);
				self:zoomtoheight(self:GetHeight()*SCREEN_WIDTH/self:GetWidth()*2);
				self:sleep(0.55);
				(cmd(Center;diffusealpha,0.1;decelerate,0.3;
				diffusealpha,PREFSMAN:GetPreference("BGBrightness")/2;))(self); 
				local bgs = GetUserPref_Theme("UserBGScale");
				if not bgs then
					bgs = 'Fit';
				end;
				local haishin=GetUserPref_Theme("UserHaishin");
				if not haishin then
					haishin="Off";
				end;
				local ratio=GetSMParameter(song,"bgaspectratio");
				if ratio=="" then ratio="1.333333" end;
				if (bgs == 'Cover' and haishin=="Off") or
					(math.abs(PREFSMAN:GetPreference("DisplayAspectRatio")-tonumber(ratio))<= 0.01 and haishin=="Off") then
					self:scaletocover( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
				else
					self:scaletofit( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
				end;
				self:linear(0.1);
				self:diffusealpha(PREFSMAN:GetPreference("BGBrightness"));
				self:sleep(1);
			end;
		end;
	};
};

-- [ja] キー操作許可管理 
t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		if sys_extype~="song" then
			sys_keyok=false;
			self:sleep(EXF_BEGIN_WAIT());
			self:queuecommand("KeyUnlock");
		end;
	end;
	KeyUnlockCommand=function(self) sys_keyok=true; end;
};

return t;