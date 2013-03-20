--[ja] ボスフォルダ関係の命令 

--[ja] 平均等取得用 
grade={
	Grade_Tier01=0,
	Grade_Tier02=1,
	Grade_Tier03=2,
	Grade_Tier04=3,
	Grade_Tier05=4,
	Grade_Tier06=5,
	Grade_Tier07=6,
	Grade_Tier08=7,
	Grade_Tier09=8,
	Grade_Tier10=9,
	Grade_Tier11=10,
	Grade_Tier12=11,
	Grade_Tier13=12,
	Grade_Tier14=13,
	Grade_Tier15=14,
	Grade_Tier16=15,
	Grade_Tier17=16,
	Grade_Tier18=17,
	Grade_Tier19=18,
	Grade_Tier20=19,
	Grade_Failed=20
};
local dif_list={
	'Difficulty_Beginner',
	'Difficulty_Easy',
	'Difficulty_Medium',
	'Difficulty_Hard',
	'Difficulty_Challenge',
	'Difficulty_Edit'
};

-- [ja] EXFolderに移ってから操作可能になるまでの時間 
function EXF_BEGIN_WAIT()
	return 0.5;
end;

--[ja] 現在開いているグループフォルダ名を取得 
function GetActiveGroupName()
	local group="";
	if _SONG() then
		group=_SONG():GetGroupName();
	elseif GAMESTATE:GetExpandedSectionName()~="" then
		group=GAMESTATE:GetExpandedSectionName();
	end;
	return group;
end;

--[ja] フォルダパス(グループ名) 
function GetExFolderPath(group)
	if FILEMAN:DoesFileExist("/Songs/"..group.."/group.ini") then
		return "/Songs/"..group.."/";
	elseif FILEMAN:DoesFileExist("/AdditionalSongs/"..group.."/group.ini") then
		return "/AdditionalSongs/"..group.."/";
	else
		return false;
	end;
end;

--[ja] group.iniを持っているか(グループ名) 
function HasGroupIni(group)
	local ret=false;
	if FILEMAN:DoesFileExist("/Songs/"..group.."/group.ini") 
		or FILEMAN:DoesFileExist("/AdditionalSongs/"..group.."/group.ini") then
		ret=true;
	else
		ret=false;
	end;
	return ret;
end;

-- [ja] EXFolderに移動できる条件がそろっているか 
function ISChallEXFolder()
-- [ja] いいか、このコメントは有効にすると死んでしまう危険なスクリプトだ。 
-- 　　 絶対に触るんじゃないぞ…！テスト用に作った、
-- 　　 無条件でEXFolderが選択できるようになるとかそんなんじゃないからな…！
--[[
if true then
	return true;
end;
--]]
	if _SONG() then
		if HasGroupIni(GetActiveGroupName())
			and GAMESTATE:GetCurrentStageIndex()>=_MAXSTAGE() then
			local best_grade=GetStageState("Grade","Last","-");
			if best_grade<=2 then
			-- [ja] 下の4箇所のコメントを解除すると判定がより精密になる
			-- 　　（全曲出現条件を満たしていない場合はfalseになる　もちろん無茶苦茶重い）
			--	if GetEXFolder_SongCnt(GetActiveGroupName(),1)>0 then
					return true;
			--	else
			--		return false;
			--	end;
			else
				return false;
			end;
		else
			return false;
		end;
	end;
	return false
end;

-- [ja] 現在開いているグループはEXFolderに移動できる条件がそろっているか 
function ISChallEXFolder_NowOpen()
	if HasGroupIni(GetActiveGroupName())
		and GAMESTATE:GetCurrentStageIndex()>=_MAXSTAGE() then
		local best_grade=GetStageState("Grade","Last","-");
		if best_grade<=2 then
		-- [ja] 下の4箇所のコメントを解除すると判定がより精密になる
		-- 　　（全曲出現条件を満たしていない場合はfalseになる　もちろん無茶苦茶重い）
		--	if GetEXFolder_SongCnt(GetActiveGroupName(),1)>0 then
				return true;
		--	else
		--		return false;
		--	end;
		else
			return false;
		end;
	else
		return false;
	end;
end;

-- [ja] EXFolderのライフ設定 
function EXFolderLifeSetting()
	if GetUserPref_Theme("ExGroupName")~="" then
		local so;
		local exll
		if GetUserPref_Theme("ExLifeLevel") then
			exll=GetUserPref_Theme("ExLifeLevel");
		else
			exll="Normal"
		end;
		if not GAMESTATE:IsEventMode() then
			if exll~="Normal" and exll~="Hard" and exll~="HardNoRecover" 
				and exll~="NoRecover" and exll~="Suddendeath" then
				if exll=="MFC" or exll=="PFC" then
					so="battery,faildefault,1 life";
				else
					if exll=="1" then
						so="battery,faildefault,1 life";
					else
						so="battery,faildefault,"..exll.." lives";
					end;
				end;
			elseif exll=="HardNoRecover" then
				so="bar,failimmediate,norecover";
				SetUserPref_Theme("ExLifeLevel","Hard");
			elseif exll=="NoRecover" then
				so="bar,failimmediate,norecover";
				SetUserPref_Theme("ExLifeLevel","Normal");
			elseif exll=="Suddendeath" then
				so="bar,failimmediate,suddendeath";
			else
				so="bar,failimmediate,normal-drain";
			end;
			GAMESTATE:SetSongOptions( "ModsLevel_Stage", so );
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
		else
		-- [ja] EVENT Modeはこっち 
			GAMESTATE:ApplyGameCommand("mod,failarcade");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			if exll~="Normal" and exll~="Hard" and exll~="HardNoRecover" 
				and exll~="NoRecover" and exll~="Suddendeath" then
				GAMESTATE:ApplyGameCommand( "mod,battery");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				if exll=="MFC" or exll=="PFC" then
					GAMESTATE:ApplyGameCommand( "mod,1lives");
					MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				else
					GAMESTATE:ApplyGameCommand( "mod,"..exll.."lives");
					MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				end;
			elseif exll=="HardNoRecover" then
				GAMESTATE:ApplyGameCommand( "mod,bar");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				GAMESTATE:ApplyGameCommand( "mod,norecover");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				SetUserPref_Theme("ExLifeLevel","Hard");
			elseif exll=="NoRecover" then
				GAMESTATE:ApplyGameCommand( "mod,bar");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				GAMESTATE:ApplyGameCommand( "mod,norecover");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				SetUserPref_Theme("ExLifeLevel","Normal");
			elseif exll=="Suddendeath" then
				GAMESTATE:ApplyGameCommand( "mod,bar");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				GAMESTATE:ApplyGameCommand( "mod,suddendeath");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			else
				GAMESTATE:ApplyGameCommand( "mod,bar");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				GAMESTATE:ApplyGameCommand( "mod,normal-drain");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			end;
		end;
	end;
end;

-- [ja] 現在のEXステージ数を返す（EXFolderモード専用） 
function GetEXFolderStage()
	local exstage=1;
	if GetUserPref_Theme("ExFolderFlag") then
		-- [ja] Ex2選曲 
		if GetUserPref_Theme("ExFolderFlag")=="Ex1Result" then
			SetUserPref_Theme("ExFolderFlag","Ex2SelectMusic");
			exstage=2;
		-- [ja] Ex2ゲーム中からバック 
		elseif GetUserPref_Theme("ExFolderFlag")=="Ex2GamePlay" then
			SetUserPref_Theme("ExFolderFlag","Ex2SelectMusic");
			exstage=2;
		-- [ja] Ex2選曲中から多重読み込み 
		elseif GetUserPref_Theme("ExFolderFlag")=="Ex2SelectMusic" then
			SetUserPref_Theme("ExFolderFlag","Ex2SelectMusic");
			exstage=2;
		-- [ja] Ex1ゲーム中からバック 
		elseif GetUserPref_Theme("ExFolderFlag")=="Ex1GamePlay" then
			SetUserPref_Theme("ExFolderFlag","Ex1SelectMusic");
			exstage=1;
		-- [ja] Ex1選曲中から多重読み込み 
		elseif GetUserPref_Theme("ExFolderFlag")=="Ex1SelectMusic" then
			SetUserPref_Theme("ExFolderFlag","Ex1SelectMusic");
			exstage=1;
		-- [ja] その他 
		else
			if GAMESTATE:IsExtraStage2() then
				SetUserPref_Theme("ExFolderFlag","Ex2SelectMusic");
				exstage=2;
			else
				SetUserPref_Theme("ExFolderFlag","Ex1SelectMusic");
				exstage=1;
			end;
		end;
	else
		if GAMESTATE:IsExtraStage2() then
			SetUserPref_Theme("ExFolderFlag","Ex2SelectMusic");
			exstage=2;
		else
			SetUserPref_Theme("ExFolderFlag","Ex1SelectMusic");
			exstage=1;
		end;
	end;
	return exstage;
end;

--[ja] 平均ステータス 第2パラメータは取得する内容（平均/MAX/MIN/ラスト） 第3パラメータは以上/以下（and over/and under） 
--[[
	例：過去[MAXSTAGE]ステージの平均ダンスポイント（％）を求め、1P、2Pの高いほうを返す
	ret = GetStageState("pdp", "AVG", "+")

	例：過去[MAXSTAGE]ステージの最高コンボ数を求め、1P、2Pの低いほうを返す
	ret = GetStageState("Combo", "MAX", "-")

	例：最終ステージのグレードを求め、1P、2Pの低い（※グレードは低いほうが上位）ほうを返す
	ret = GetStageState("Grade", "Last", "-")
--]]
function GetStageState(prm,mode,overunder)
	--[ja] STAGE 1の時は取得不可能 
	if GAMESTATE:GetCurrentStageIndex()<1 then return 0 end;
	local chk_stat={0,0,"",""};	--[ja] 第二パラメータが数値の場合 
	local sprm=string.lower(prm);
	local smode=string.lower(mode);
	local chk_loop=((smode=="last") and 1 or _MAXSTAGE());
	if sprm=="grade" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local pss_grade=ss:GetPlayerStageStats(pn):GetGrade();
					local chk_var=grade[pss_grade];
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="dancepoints" or sprm=="dp" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local chk_var=ss:GetPlayerStageStats(pn):GetActualDancePoints();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="perdancepoints" or sprm=="pdp" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local chk_var=ss:GetPlayerStageStats(pn):GetPercentDancePoints();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="combo" or sprm=="maxcombo" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local chk_var=ss:GetPlayerStageStats(pn):MaxCombo();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="meter" then
	--[ja] Meterは#METERTYPEの値によって変わるのであまり使わないほうがいいかも 
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local steps=ss:GetPlayerStageStats(pn):GetPlayedSteps();
					local chk_var=steps[#steps]:GetMeter();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="combo" or sprm=="maxcombo" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local chk_var=ss:GetPlayerStageStats(pn):MaxCombo();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="song" then
	-- [ja] Last か Playのみ使用可能（未指定・不正の場合Play） 
	-- [ja] ステージ数 or 0を返す 
		local songs=STATSMAN:GetAccumPlayedStageStats():GetPlayedSongs();
		for i=#songs-_MAXSTAGE()+1,#songs do
			local ssong=string.lower(songs[i]:GetSongDir());
			if string.find(ssong,smode,0,true) then
				return i-(#songs-_MAXSTAGE());
			end;
		end;
		return 0;
	end;
	if not GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		return chk_stat[1];
	elseif not GAMESTATE:IsPlayerEnabled(PLAYER_1) then
		return chk_stat[2];
	elseif string.lower(overunder)=="over" or overunder=="+" then
		return ((chk_stat[1]>=chk_stat[2]) and chk_stat[1] or chk_stat[2]);
	elseif string.lower(overunder)=="under" or overunder=="-" then
		return ((chk_stat[1]<=chk_stat[2]) and chk_stat[1] or chk_stat[2]);
	else
		return (chk_stat[1]+chk_stat[2])/2;
	end;
end;

-- [ja] group.iniから任意の値を取得 (グループ名,パラメータ名) 
function GetGroupParameter(group,prm)
	local gpath;
	if FILEMAN:DoesFileExist("/Songs/"..group.."/group.ini")  then
		gpath="/Songs/"..group.."/group.ini";
	elseif FILEMAN:DoesFileExist("/AdditionalSongs/"..group.."/group.ini") then
		gpath="/AdditionalSongs/"..group.."/group.ini";
	else
		return "";
	end;
	local f=RageFileUtil.CreateRageFile();
	f:Open(gpath,1);
	local tmp=GetSMParameter_f(f,prm);
	f:Close();
	f:destroy();
	return tmp;
end;

-- [ja] 出現条件を満たしている曲数を返す 
function GetEXFolder_SongCnt(groupname,exstage)
	local load_cnt=0;
	-- [ja] 楽曲情報文字列（#ExtraXSongsの中身）
	local sys_songunlock=split(":",string.lower(GetGroupParameter(groupname,"Extra"..exstage.."Songs")));
	local sys_songunlockU=split(":",GetGroupParameter(groupname,"Extra"..exstage.."Songs"));
	-- [ja] 難易度別条件取得（曲切り替えのたびに代入） 
	local sys_songunlock_prm1;
	local sys_songunlock_prm1U;
	-- [ja] 取得した難易度別条件をさらにパラメータごとに分割 
	local sys_songunlock_prm2;
	local sys_songunlock_prm2U;
	local txt_folders=GetGroupParameter(groupname,"Extra"..exstage.."List");
	chk_folders=split(":",txt_folders);
	-- [ja] 選択可能な曲を取得 
	local str="";
	for j=1,#chk_folders do
		foldername=chk_folders[j];
		local gsong=GetFolder2Song(groupname,foldername)
		if gsong then

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
			local expath=GetExFolderPath(groupname);
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
								if #sys_songunlock_prm2==3 then
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
			
			-- [ja] フラグfalse or 譜面自体が存在しない場合選択不可能に設定   
			local unlock_chk=0;
			for k=1,6 do
				if ((not gsong:HasStepsTypeAndDifficulty(GAMESTATE:GetCurrentStyle():GetStepsType(),dif_list[k])) or diflock[k]==false) then
					-- [ja] ここではあくまでも曲の登録をするかの問題なので、フラグ自体をいじらない 
					unlock_chk=unlock_chk+1;
				end;
			end;
			if unlock_chk<6 then 
				load_cnt=load_cnt+1;
			end;
		end;
	end;
	return load_cnt;
end;
