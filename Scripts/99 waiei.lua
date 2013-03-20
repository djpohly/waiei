--[ja] 最初、追加命令の先頭に ya をつけるつもりだったけどめんどくさくなったの図 

function yaGetKeyMode(song)
	local keymode=0;
	if song then
		local path=song:GetSongDir();
			keymode=(FILEMAN:DoesFileExist(path.."../yubi.fumen") or
				FILEMAN:DoesFileExist(path.."yubi.fumen") or
				FILEMAN:DoesFileExist(path.."../key.mode") or
				FILEMAN:DoesFileExist(path.."key.mode"));
	end;
	return keymode;
end;

function yaGetRD(player,prm)
	return GAMESTATE:GetCurrentSteps(player):GetRadarValues(player):GetValue(prm);
end;

function yaGetRadarVal(song,player,prm,keymode)
	local ret=0.0;
	--local keymode=yaGetKeyMode(song);
	if song then
		local r_mlr  =yaGetRD(player,'RadarCategory_Mines')/16+yaGetRD(player,'RadarCategory_Lifts')/1.5+yaGetRD(player,'RadarCategory_Rolls');
		local r_total=yaGetRD(player,'RadarCategory_TapsAndHolds')
		if prm=="Stream" then
			if not keymode then
				ret=yaGetRD( player, 'RadarCategory_Stream')+(r_mlr/r_total);
			else
				ret=((yaGetRD( player, 'RadarCategory_TapsAndHolds' )+r_mlr*1.5+yaGetRD( player, 'RadarCategory_Jumps' ))/song:MusicLengthSeconds())/(666/60);
			end;
		elseif prm=="Voltage" then
			if not keymode then
				ret=yaGetRD( player, 'RadarCategory_Voltage')+(r_mlr*0.003);
			else
				local bpmAvg=(song:GetLastBeat()-song:GetFirstBeat())/(song:GetLastSecond()-song:GetFirstSecond())*60;
				ret=((yaGetRD( player, 'RadarCategory_TapsAndHolds' )+r_mlr+yaGetRD( player, 'RadarCategory_Jumps' ))/song:GetLastBeat())/573*bpmAvg;
			end;
		elseif prm=="Air" then
			if not keymode then
				ret=yaGetRD( player, 'RadarCategory_Air')+yaGetRD(player,'RadarCategory_Mines')/555;
			else
				ret=(yaGetRD( player, 'RadarCategory_Jumps' )/song:MusicLengthSeconds())/(200/60)+yaGetRD(player,'RadarCategory_Mines')/1800;
			end;
		elseif prm=="Freeze" then
			if not keymode then
				ret=yaGetRD( player, 'RadarCategory_Freeze');
			else
				if song:MusicLengthSeconds()>0 then
					ret=(yaGetRD( player, 'RadarCategory_Holds' )/song:MusicLengthSeconds())/(100/60);
				else
					ret=(yaGetRD( player, 'RadarCategory_Holds' )/(100/60));
				end;
			end;
		elseif prm=="Chaos" then
			if not keymode then
				ret=yaGetRD( player, 'RadarCategory_Chaos')+yaGetRD(player,'RadarCategory_Mines')/1000;
			else
				ret=((((yaGetRD( player, 'RadarCategory_TapsAndHolds' )-50)/math.max(song:GetLastBeat(),1))/3)+(yaGetRD( player, 'RadarCategory_Chaos')))/2;
				if ret<0 then ret=0.0; end;
				ret=math.cos((ret+2)*math.pi*2/4)+1.0;
			end;
		else
			ret=0.0;
		end;
	end;
	if ret<0 then
		ret=0.0;
	end;
	return math.min(ret*95,95)+5;
--	return ret*95+5;
end;

-- [ja]ステップゾーンの位置 
function GetStepZonePosX(pn)
	local r=SCREEN_CENTER_X;
	local p=((pn==PLAYER_1) and 1 or 2);
	local st=GAMESTATE:GetCurrentStyle():GetStyleType();
	if GAMESTATE:GetNumPlayersEnabled()==1 and Center1Player() then
		r=SCREEN_CENTER_X;
	else
		r=THEME:GetMetric("ScreenGameplay","PlayerP"..p..ToEnumShortString(st).."X");
	end;
	return r;
end;

function GetJacketPath_a1(song)
	local f={};
	local ret="";
	f=FILEMAN:GetDirListing(song:GetSongDir());
	for i=1,#f do
		if string.find(f[i],".*jacket%.[png$jpeg$jpg$gif$bmp$avi$mpg$mpeg]") then
			if FILEMAN:DoesFileExist(song:GetSongDir().."/"..f[i]) then
				ret=song:GetSongDir().."/"..f[i];
				return ret;
			else
				ret="";
			end;
		end;
	end;
	return ret;
end;

function GetHarderDiffculty()
	if GAMESTATE:IsPlayerEnabled(PLAYER_1) and not GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		return GAMESTATE:GetCurrentSteps(PLAYER_1):GetDifficulty();
	elseif not GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		return GAMESTATE:GetCurrentSteps(PLAYER_2):GetDifficulty();
	elseif not GAMESTATE:IsPlayerEnabled(PLAYER_1) and not GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		return 'Difficulty_Edit';
	else
		local pd={0,0};
		for i=1,2 do
			if GAMESTATE:GetCurrentSteps("PlayerNumber_P"..i):GetDifficulty()=='Difficulty_Beginner' then
				pd[i]=1;
			elseif GAMESTATE:GetCurrentSteps("PlayerNumber_P"..i):GetDifficulty()=='Difficulty_Easy' then
				pd[i]=2;
			elseif GAMESTATE:GetCurrentSteps("PlayerNumber_P"..i):GetDifficulty()=='Difficulty_Medium' then
				pd[i]=3;
			elseif GAMESTATE:GetCurrentSteps("PlayerNumber_P"..i):GetDifficulty()=='Difficulty_Hard' then
				pd[i]=4;
			elseif GAMESTATE:GetCurrentSteps("PlayerNumber_P"..i):GetDifficulty()=='Difficulty_Challenge' then
				pd[i]=5;
			else
				pd[i]=0;
			end;
		end;
		if pd[1]>=pd[2] then
			return GAMESTATE:GetCurrentSteps(PLAYER_1):GetDifficulty();
		else
			return GAMESTATE:GetCurrentSteps(PLAYER_2):GetDifficulty();
		end;
	end;
	return 'Difficulty_Edit';
end;

--[ja] SDVXみたいに難易度で変わるジャケット 
--     ホイールだと更新タイミングがよくわからず、 
--     なおかつGetJacketPath使用時に誤認識されるので没 
function GetJacketPath_Dif(song)
	local f={};
	local ret="";
	f=FILEMAN:GetDirListing(song:GetSongDir());
	for i=1,#f do
		local test=string.lower(ToEnumShortString(GetHarderDiffculty()));
		if string.find(f[i],".*jacket.*%("..test.."%)%.[png$jpeg$jpg$gif$bmp$avi$mpg$mpeg]") then
			if FILEMAN:DoesFileExist(song:GetSongDir().."/"..f[i]) then
				ret=song:GetSongDir().."/"..f[i];
				return ret;
			else
				ret="";
			end;
		end;
	end;
	return GetJacketPath_a1(song);
end;

function HasJacket_a1(song)
	local f={};
	local ret="";
	f=FILEMAN:GetDirListing(song:GetSongDir());
	for i=1,#f do
		if string.find(f[i],".*jacket.*[png$jpeg$jpg$gif$bmp$avi$mpg$mpeg]") then
			if FILEMAN:DoesFileExist(song:GetSongDir().."/"..f[i]) then
				return true;
			end;
		end;
	end;
	return false;
end;

function GetCDImagePath_a1(song)
	local f={};
	local ret="";
	f=FILEMAN:GetDirListing(song:GetSongDir());
	for i=1,#f do
		if string.find(f[i],".+cd.?[png$jpeg$jpg$gif$bmp$avi$mpg$mpeg]") then
			if FILEMAN:DoesFileExist(song:GetSongDir().."/"..f[i]) then
				ret=song:GetSongDir().."/"..f[i];
				return ret;
			else
				ret="";
			end;
		end;
	end;
	return ret;
end;

function HasCDImage_a1(song)
	local f={};
	local ret="";
	f=FILEMAN:GetDirListing(song:GetSongDir());
	for i=1,#f do
		if string.find(f[i],".+cd.?[png$jpeg$jpg$gif$bmp$avi$mpg$mpeg]") then
			if FILEMAN:DoesFileExist(song:GetSongDir().."/"..f[i]) then
				return true;
			end;
		end;
	end;
	return false;
end;

--[ja] もっともふさわしい画像のパスを返す（ジャケット→バナー） 
function GetSongGPath_JBN(song)
	local gpath;
	if song then
		if ProductVersion()=="v5.0 alpha 1" then
			--[ja] ジャケット
			if HasJacket_a1(song) then
				gpath=GetJacketPath_a1(song);
			-- [ja] CD
			elseif HasCDImage_a1(song) then
				gpath=GetCDImagePath_a1(song);
			-- [ja] バナー
			elseif song:HasBanner() then
				gpath=song:GetBannerPath();
			-- [ja] BG 
			elseif song:HasBackground() then
				gpath=song:GetBackgroundPath();
			-- [ja] fallback 
			else
				gpath=THEME:GetPathG("Common fallback","background");
			end;
		else
			--[ja] ジャケット
			if song:HasJacket() and song:GetJacketPath()~=song:GetCDTitlePath() then
				gpath=song:GetJacketPath();
			-- [ja] CD
			elseif song:HasCDImage() and song:GetCDImagePath()~=song:GetCDTitlePath() then
				gpath=song:GetCDImagePath();
			-- [ja] バナー
			elseif song:HasBanner() then
				gpath=song:GetBannerPath();
			-- [ja] BG 
			elseif song:HasBackground() then
				gpath=song:GetBackgroundPath();
			-- [ja] fallback 
			else
				gpath=THEME:GetPathG("Common fallback","banner");
			end;
		end;
	else
		gpath=THEME:GetPathG("Common fallback","banner");
	end;
	return gpath;
end;

--[ja] もっともふさわしい画像のタイプを返す（ジャケット→バナー） 
function GetSongGType_JBN(song)
	local gtype;
	if song then
		if ProductVersion()=="v5.0 alpha 1" then
			--[ja] ジャケット
			--if song:HasJacket() then
			--elseif song:HasCDImage() then
			if HasJacket_a1(song) then
				gtype=3;
			-- [ja] CD
			elseif HasCDImage_a1(song) then
				gtype=4;
			-- [ja] バナー
			elseif song:HasBanner() then
				gtype=1;
			-- [ja] BG 
			elseif song:HasBackground() then
				gtype=2;
			-- [ja] fallback 
			else
				gtype=0;
			end;
		else
			--[ja] ジャケット
			if song:HasJacket() then
				gtype=3;
			-- [ja] CD
			elseif song:HasCDImage() then
				gtype=4;
			-- [ja] バナー
			elseif song:HasBanner() then
				gtype=1;
			-- [ja] BG 
			elseif song:HasBackground() then
				gtype=2;
			-- [ja] fallback 
			else
				gtype=0;
			end;
		end;
	else
		gtype=0;
	end;
	return gtype;
end;

--[ja] もっともふさわしい画像のパスを返す（ジャケット→背景） 
function GetSongGPath_JBG(song)
	local gpath;
	if song then
		--[ja] ジャケット
		if song:HasJacket() and song:GetJacketPath()~=song:GetCDTitlePath() then
			gpath=song:GetJacketPath();
		-- [ja] CD
		elseif song:HasCDImage() and song:GetCDImagePath()~=song:GetCDTitlePath() then
			gpath=song:GetCDImagePath();
		-- [ja] BG 
		elseif song:HasBackground() then
			gpath=song:GetBackgroundPath();
		-- [ja] バナー
		elseif song:HasBanner() then
			gpath=song:GetBannerPath();
		-- [ja] fallback 
		else
			gpath=THEME:GetPathG("Common fallback","banner");
		end;
	else
		gpath=THEME:GetPathG("Common fallback","banner");
	end;
	return gpath;
end;

--[ja] もっともふさわしい画像のタイプを返す（ジャケット→バナー） 
function GetSongGType_JBG(song)
	local gtype;
	if song then
		--[ja] ジャケット
		if song:HasJacket() then
			gtype=3;
		-- [ja] CD
		elseif song:HasCDImage() then
			gtype=4;
		-- [ja] BG 
		elseif song:HasBackground() then
			gtype=2;
		-- [ja] バナー
		elseif song:HasBanner() then
			gtype=1;
		-- [ja] fallback 
		else
			gtype=0;
		end;
	else
		gtype=0;
	end;
	return gtype;
end;

--[ja] もっともふさわしい画像のパスを返す（バナー→ジャケット） 
function GetSongGPath_BNJ(song)
	local gpath;
	if song then
		-- [ja] バナー
		if song:HasBanner() then
			gpath=song:GetBannerPath();
		--[ja] ジャケット
		elseif song:HasJacket() and song:GetJacketPath()~=song:GetCDTitlePath() then
			gpath=song:GetJacketPath();
		-- [ja] CD
		elseif song:HasCDImage() and song:GetCDImagePath()~=song:GetCDTitlePath() then
			gpath=song:GetCDImagePath();
		-- [ja] BG 
		elseif song:HasBackground() then
			gpath=song:GetBackgroundPath();
		-- [ja] fallback 
		else
			gpath=THEME:GetPathG("Common fallback","banner");
		end;
	else
		gpath=THEME:GetPathG("Common fallback","banner");
	end;
	return gpath;
end;

--[ja] もっともふさわしい画像のタイプを返す（バナー→ジャケット） 
function GetSongGType_BNJ(song)
	local gtype;
	if song then
		-- [ja] バナー
		if song:HasBanner() then
			gtype=1;
		--[ja] ジャケット
		elseif song:HasJacket() then
			gtype=3;
		-- [ja] CD
		elseif song:HasCDImage() then
			gtype=4;
		-- [ja] BG 
		elseif song:HasBackground() then
			gtype=2;
		-- [ja] fallback 
		else
			gtype=0;
		end;
	else
		gtype=0;
	end;
	return gtype;
end;

--[ja] もっともふさわしい画像のパスを返す（コース） 
function GetCourseGPath(course)
	local gpath;
	if course then
		local gra="";
		local jk={"png","avi","flv","mp4","mpg","mpeg","jpg","jpeg","gif","bmp"};
		local file;
		for i=1,#jk do
			file=string.gsub(course:GetCourseDir(),"%.crs","-jacket%."..jk[1]);
			if FILEMAN:DoesFileExist(file) then
				gra=""..file;
				break;
			end;
		end;
		--[ja] ジャケット
		if gra~="" then
			gpath=gra;
		-- [ja] CD
		elseif course:HasBanner() then
			gpath=course:GetBannerPath();
		-- [ja] BG 
		elseif course:HasBackground() then
			gpath=course:GetBackgroundPath();
		-- [ja] fallback 
		else
			gpath=THEME:GetPathG("Common fallback","banner");
		end;
	else
		gpath=THEME:GetPathG("Common fallback","banner");
	end;
	return gpath;
end;

-- [ja] バナーを返す（コース） 
-- [ja] 自動生成コースの画像が取れないため没 
function GetCourseBPath(course)
	local gpath;
	if course then
		if course:GetCourseDir() then
			local gra="";
			local jk={"png","avi","flv","mp4","mpg","mpeg","jpg","jpeg","gif","bmp"};
			local file;
			for i=1,#jk do
				file=string.gsub(course:GetCourseDir(),"%.crs","%."..jk[1]);
				if FILEMAN:DoesFileExist(file) then
					gpath=""..file;
					break;
				end;
			end;
			if gpath=="" then
				gpath=THEME:GetPathG("Common fallback","banner");
			end;
		else
			gpath=THEME:GetPathG("Common fallback","banner");
		end;
	else
		gpath=THEME:GetPathG("Common fallback","banner");
	end;
	return gpath;
end;

--[ja] 背景画像かfallbackのパスを返す 
function GetSongBGPath(song)
	local gpath;
	if song then
		if song:HasBackground() then
			gpath=song:GetBackgroundPath();
		-- [ja] fallback 
		else
			gpath=THEME:GetPathG("Common fallback","background");
		end;
	else
		gpath=THEME:GetPathG("Common fallback","background");
	end;
	return gpath;
end;

--[ja] バナーかfallbackのパスを返す 
function GetSongOrCourseBannerPath(s_or_c)
	local gpath;
	if s_or_c then
		if s_or_c:HasBanner() then
			gpath=s_or_c:GetBannerPath();
		-- [ja] fallback 
		else
			gpath=THEME:GetPathG("Common fallback","banner");
		end;
	else
		gpath=THEME:GetPathG("Common fallback","banner");
	end;
	return gpath;
end;

--[ja] もっともふさわしい画像のキャッシュファイルパスを返す 
--     理想としてはこのファイルを読み込んでから0.1秒後に本来の画像を読むことで
--     高速化を図ろうとしたが
--     ホイールの画像にsleepやlinear使うと動きがおかしくなるので没 
function GetSongCachePath(song,gtype)
	if song then
		if gtype==3 or string.lower(gtype)=="jacket" then
			if FILEMAN:DoesFileExist(song:GetSongDir().."/cache-jk.bmp") then
				return song:GetSongDir().."/cache-jk.bmp";
			end;
			if ProductVersion()=="v5.0 alpha 1" then
				if HasJacket_a1(song) then
					return GetJacketPath_a1(song);
				else
				end;
			else
				return song:GetJacketPath();
			end;
		end;
	end;
	return "";
end;

--[ja] SMファイルで指定したパラメータの内容を読み取る  
function GetSMParameter(song,prm)
	local st=song:GetAllSteps();
	if #st<1 then
		return "";
	end;
	local t;
	t=st[1]:GetFilename();
	if not FILEMAN:DoesFileExist(t) then
		return "";
	end;
	--[ja] 形式ではじく 
	local lt=string.lower(t);
	if not string.find(lt,".*%.sm") and not string.find(lt,".*%.ssc") then
		return "";
	end;
	local f=RageFileUtil.CreateRageFile();
	f:Open(t,1);
	-- [ja] 複数行を考慮していったん別変数に代入する 
	local gl="";
	local pl=string.lower(prm);
	local l;
	while true do
		l=f:GetLine();
		local ll=string.lower(l);
		if string.find(ll,"#notes:.*") or f:AtEOF() then
			break;
		-- [ja] BOM考慮して .* を頭につける 
		elseif (string.find(ll,"^.*#"..pl..":.*") and (not string.find(ll,"^%/%/.*"))) or gl~="" then
			gl=gl..""..split("//",l)[1];
			if string.find(ll,".*;") then
				break;
			end;
		end;
	end;
	local tmp={};
	if gl=="" then
		tmp={""};
	else
		tmp=split(":",gl);
		if tmp[2]==";" then
			tmp[1]="";
		else
			if #tmp>2 then
				tmp[1]=tmp[2];
				for i=3,#tmp do
					tmp[1]=tmp[1]..":"..split(";",tmp[i])[1];
				end;
			else
				tmp[1]=split(";",tmp[2])[1];
			end;
		end;
	end;
	f:Close();
	f:destroy();
	if tmp[1]=="" then
		tmp[1]=GetExtendedParameter(song,prm);
	end;
	return tmp[1];
end;

-- [ja] ファイルを開く
--[[
	file=OpenFile(ファイルパス); 
																				--]]
-- [ja] 注意：fileは、必ずCloseFile等を使って閉じること 
function OpenFile(filePath)
	if not FILEMAN:DoesFileExist(filePath) then
		return nil;
	end;
	local f=RageFileUtil.CreateRageFile();
	f:Open(filePath,1);
	return f;
end;
-- [ja] songからSMファイルを開く
--[[
	file=OpenSMFile(song); 
																				--]]
-- [ja] 注意：fileは、必ずCloseFile等を使って閉じること 
function OpenSMFile(song)
	local st=song:GetAllSteps();
	if #st<1 then
		return nil;
	end;
	local t;
	t=st[1]:GetFilename();
	if not FILEMAN:DoesFileExist(t) then
		return nil;
	end;
	--[ja] 形式ではじく 
	local lt=string.lower(t);
	if not string.find(lt,".*%.sm") and not string.find(lt,".*%.ssc") then
		return nil;
	end;
	OpenFile(t);
	return f;
end;
--[ja] SMファイルと同じ書式のファイルで指定したパラメータの内容を読み取る（FILE型を直接指定） 
--[[
	内容=GetFileParameter(file,"パラメータ"); 
	
	#AAA:BBB; の場合、返り値=GetSMParameter_f(file,"AAA"); となり、"BBB"が返る
																				--]]
--[ja] あらかじめ OpenSMFile で開いておく必要があり、最後に f:Close() / f:destroy() をする必要がある 
--[ja] 解放忘れすると怖いんであんまり使わないほうがいい？ 
function GetFileParameter(f,prm)
	return GetSMParameter_f(f,prm);
end;
function GetSMParameter_f(f,prm)
	if not f then
		return "";
	end;
	f:Seek(0);
	local gl="";
	local pl=string.lower(prm);
	local l;
	while true do
		l=f:GetLine();
		local ll=string.lower(l);
		if string.find(ll,"#notes:.*") or f:AtEOF() then
			break;
		elseif (string.find(ll,"^.*#"..pl..":.*") and (not string.find(ll,"^%/%/.*"))) or gl~="" then
			gl=gl..""..split("//",l)[1];
			if string.find(ll,".*;") then
				break;
			end;
		end;
	end;
	local tmp={};
	if gl=="" then
		tmp={""};
	else
		tmp=split(":",gl);
		if tmp[2]==";" then
			tmp[1]="";
		else
			if #tmp>2 then
				tmp[1]=tmp[2];
				for i=3,#tmp do
					tmp[1]=tmp[1]..":"..split(";",tmp[i])[1];
				end;
			else
				tmp[1]=split(";",tmp[2])[1];
			end;
		end;
	end;
	return tmp[1];
end;
-- [ja] 1行読み取り （;を含んでいても読み取り可能） 
function GetSMOneline_f(f,prm)
	if not f then
		return "";
	end;
	f:Seek(0);
	local gl="";
	local pl=string.lower(prm);
	local l;
	while true do
		l=f:GetLine();
		local ll=string.lower(l);
		if string.find(ll,"#notes:.*") or f:AtEOF() then
			break;
		elseif (string.find(ll,"^.*#"..pl..":.*") and (not string.find(ll,"^%/%/.*"))) or gl~="" then
			gl=gl..""..l;
			break
		end;
	end;
	local tmp={};
	if gl=="" then
		tmp={""};
	else
		tmp=split(":",gl);
		if tmp[2]==";" then
			tmp[1]="";
		else
			if #tmp>2 then
				tmp[1]=tmp[2];
				for i=3,#tmp do
					tmp[1]=tmp[1]..":"..tmp[i];
				end;
			else
				tmp[1]=tmp[2];
			end;
		end;
	end;
	return tmp[1];
end;
--[ja] fileを閉じる 
--[[
	CloseFile(file); 
																				--]]
--[ja] OpenFile / OpenSMFile を使用した場合は必ず閉じてください 
function CloseFile(f)
	if f then
		f:Close();
		f:destroy();
		return true;
	else
		return false;
	end;
end;

function Str2Color(prm)
	local c={"1.0","1.0","1.0","1.0"};
	c=split(",",prm);
	if #c<4 then
		c={"1.0","1.0","1.0","1.0"};
	end;
	return c;
end;

function GetSongColor_MeterType(song)
	local st=GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber());
	local hm=song:HasStepsTypeAndDifficulty(st:GetStepsType(),'Difficulty_Hard');
	local dm=0;
	if hm then
		dm=song:GetOneSteps(st:GetStepsType(),'Difficulty_Hard'):GetMeter();
	else
		dm=0;
	end;
	if mettype=="" then
		c=SONGMAN:GetSongColor(song);
	elseif mettype=="ddr" and dm>=11 then
		c=Color("Red");
	elseif mettype=="ddr x" and dm>=17 then
		c=Color("Red");
	elseif mettype=="itg" and dm>=13 then
		c=Color("Red");
	else
		c=Color("White");
	end;
	return {c[1],c[2],c[3],c[4]};
end;

-- [ja] SM5非対応コマンドを保存する
--[[
	SetExtendedParameter(song,"パラメータ","内容"); 
	
	#AAA:BBB; → AAA;BBB.smexp 
																				--]]
-- [ja] 読み込み時に高速化を図るため、ファイル名にパラメータを保存する 
-- [ja] その為、あまり長いパラメータは保存しないほうがいい  
function SetExtendedParameter(song,prm,var)
	-- [ja] ファイル名で使用できない文字列がある場合は保存を行わない 
	if string.find(prm,".*[$<$>$%*$:$;$%?$\"$|$\\$/].*") then
		return "";
	end;
	--if string.find(var,".*[$<$>$%*$:$;$%?$\"$|$\\$/].*") then
	if string.find(var,".*[$<$>$%*$:$;$%?$\"$|$\\$/]") then
		return "";
	end;
	if not song then
		return "";
	end;
	local f_exp=RageFileUtil.CreateRageFile();
	f_exp:Open(song:GetSongDir().."/"..prm..";"..var..".smexp",2);
	f_exp:Write(" ");
	f_exp:Close();
	f_exp:destroy();
end;

-- [ja] SM5非対応コマンドを読み込む
--[[
	内容=GetExtendedParameter(song,"パラメータ"); 
																				--]] 
function GetExtendedParameter(song,prm)
	local f={};
	local ret={};
	local lprm=string.lower(prm)
	f=FILEMAN:GetDirListing(song:GetSongDir());
	for i=1,#f do
		if string.find(string.lower(f[i]),lprm..";.*%.smexp") then
			ret=split(";",f[i]);
			ret=split(".smexp",ret[2]);
			return ret[1];
		end;
	end;
	return "";
end;

-- [ja] 左側1P、右側2Pとする処理の場合そのプレイヤーが存在するかどうか 
-- [ja] もし存在しない場合は反対側のプレイヤーを返す 
function GetSidePlayer(player)
	if player==PLAYER_1 then
		if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
			return PLAYER_1;
		else
			return PLAYER_2;
		end;
	else
		if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
			return PLAYER_2;
		else
			return PLAYER_1;
		end;
	end;
	return PLAYER_1;
end;

-- [ja] 現在のビートを取得する（譜面で異なるものに対応） 
function GetPlayerSongBeat(player)
	local csteps=GAMESTATE:GetCurrentSteps(player);
	local timing=csteps:GetTimingData();
	return timing:GetBeatFromElapsedTime(GAMESTATE:GetSongPosition():GetMusicSeconds());
end;

-- [ja] 上記命令＋時間がわかっているとき（高速化） 
function GetPlayerSongBeat2(player,sec)
	local csteps=GAMESTATE:GetCurrentSteps(player);
	local timing=csteps:GetTimingData();
	return timing:GetBeatFromElapsedTime(sec);
end;

-- [ja] 時間からビートに変換（譜面で異なるものに対応） 
function Sec2PlayerBeat(player,sec)
local csteps=GAMESTATE:GetCurrentSteps(player);
local timing=csteps:GetTimingData();
	return timing:GetBeatFromElapsedTime(sec);
end;

-- [ja] ビートから時間に変換（譜面で異なるものに対応） 
function PlayerBeat2Sec(player,beat)
local csteps=GAMESTATE:GetCurrentSteps(player);
local timing=csteps:GetTimingData();
	return timing:GetElapsedTimeFromBeat(beat);
end;

-- [ja] 何故かGetReverseで0.000...しか返らないので 
function IsReverse(pn)
	local op=string.lower(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString('ModsLevel_Stage'));
	--if string.find(op,"[reverse$split$alternate$cross]") then
	if string.find(op,"reverse") then
		return true;
	else
		return false;
	end;
	return false;
end;

-- [ja] スコアの総調べを行い正しいパラメータを返す(hiscore,取得したい値) 
-- hiscore=xxx:GetHighScores()
local GradeVar = {
	Grade_Tier01 = 0;
	Grade_Tier02 = 1;
	Grade_Tier03 = 2;
	Grade_Tier04 = 3;
	Grade_Tier05 = 4;
	Grade_Tier06 = 5;
	Grade_Tier07 = 6;
	Grade_Tier08 = 7;
	Grade_Tier09 = 8;
	Grade_Tier10 = 9;
	Grade_Tier11 = 10;
	Grade_Tier12 = 11;
	Grade_Tier13 = 12;
	Grade_Tier14 = 13;
	Grade_Tier15 = 14;
	Grade_Tier16 = 15;
	Grade_Tier17 = 16;
	Grade_Tier18 = 17;
	Grade_Tier19 = 18;
	Grade_Tier20 = 19;
	Grade_Failed = 20;
};
local StageAwrdVar = {
	StageAward_80PercentW3   = 0;
	StageAward_90PercentW3   = 1;
	StageAward_100PercentW3  = 2;
	StageAward_FullComboW3   = 3;
	StageAward_SingleDigitW3 = 4;
	StageAward_OneW3         = 5;
	StageAward_FullComboW2   = 6;
	StageAward_SingleDigitW2 = 7;
	StageAward_OneW2         = 8;
	StageAward_FullComboW1   = 9;
};
function GetScoreData(hiscore,prm)
	lprm=string.lower(prm)
	if lprm=="grade" then	-- [ja] 最高グレード 
		local higrade=99;
		for i=1,#hiscore do
			if GradeVar[hiscore[i]:GetGrade()]<higrade then
				higrade=GradeVar[hiscore[i]:GetGrade()];
			end;
		end;
		return Grade[higrade+1];
	elseif lprm=="combo" then	-- [ja] 最高コンボ 
		local hicombo=-1;
		local hicombof=false;
		for i=1,#hiscore do
			if hiscore[i]:GetStageAward() then
				if StageAwrdVar[hiscore[i]:GetStageAward()]>hicombo then
					hicombo=StageAwrdVar[hiscore[i]:GetStageAward()];
				end;
			end;
		end;
		if hicombo>=0 and hicombo<6 then
			return "JudgmentLine_W3";
		elseif hicombo>=6 and hicombo<8 then
			return "JudgmentLine_W2";
		elseif hicombo==9 then
			return "JudgmentLine_W1";
		else
			return "";
		end;
	else	-- [ja] 最高DP/その時のスコア/アイテム番号 
		local hidp=0;
		local hi_i=1;
		for i=1,#hiscore do
			if hiscore[i]:GetPercentDP()>hidp then
				hidp=hiscore[i]:GetPercentDP();
				hi_i=i;
			end;
		end;
		if lprm=="score" then
			return hiscore[hi_i]:GetScore();
		elseif lprm=="dp" then
			return hidp;
		elseif lprm=="hiscore" then
			return hiscore[hi_i];
		else
			return hi_i;
		end;
	end;
end;
function GetSN2Score(player,steps,score)
	local radar=steps:GetRadarValues(player);
	local w1=score:GetTapNoteScore('TapNoteScore_W1');
	local w2=score:GetTapNoteScore('TapNoteScore_W2');
	local w3=score:GetTapNoteScore('TapNoteScore_W3');
	local wh=score:GetHoldNoteScore('HoldNoteScore_Held');
	local to=math.max(radar:GetValue('RadarCategory_TapsAndHolds')+radar:GetValue('RadarCategory_Holds')+radar:GetValue('RadarCategory_Rolls'),1);
	if PREFSMAN:GetPreference("AllowW1")~="AllowW1_Everywhere" then
		w1=w1+w2;
		w2=0;
	end;
	return (math.round( (w1 + w2 + w3/2+wh)*100000/to-(w2 + w3))*10);
end;

-- [ja] タイトル -サブタイトル- 書式からタイトル/サブタイトルを分割 
function SplitTitle(title)
	local t={"",""};
	local fsubtitle=0;
	local stitle=title;
	local ssubtitle="";
	local slen=string.len(stitle);
	local match_s=0;
	local match_e=0;
	match_s,match_e=string.find(stitle," %-.*%-");
	if match_s and match_e and match_s>2 and match_e==slen and fsubtitle==0 then
		ssubtitle=string.sub(stitle,match_s,match_e);
		stitle=string.sub(stitle,1,match_s-1);
		fsubtitle=1;
	end;
	match_s,match_e=string.find(stitle," ~.*~");
	if match_s and match_e and match_s>2 and match_e==slen and fsubtitle==0 then
		ssubtitle=string.sub(stitle,match_s,match_e);
		stitle=string.sub(stitle,1,match_s-1);
		fsubtitle=1;
	end;
	match_s,match_e=string.find(stitle," %(.*%)");
	if match_s and match_e and match_s>2 and match_e==slen and fsubtitle==0 then
		ssubtitle=string.sub(stitle,match_s,match_e);
		stitle=string.sub(stitle,1,match_s-1);
		fsubtitle=1;
	end;
	match_s,match_e=string.find(stitle," %[.*%]");
	if match_s and match_e and match_s>2 and match_e==slen and fsubtitle==0 then
		ssubtitle=string.sub(stitle,match_s,match_e);
		stitle=string.sub(stitle,1,match_s-1);
		fsubtitle=1;
	end;
	if fsubtitle==0 then match_s=0;match_e=0; end;
	t[1]=stitle;
	t[2]=ssubtitle;
	return t;
end;

-- [ja] ボス曲カラーかどうか 
function IsBossColor(song,metertype)
	local ret=false;
	local mettype=string.lower(metertype);
	local st=GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber());
	local hm=song:GetAllSteps();
	local dm=0;
	for i=1,#hm do
		if hm[i]:GetDifficulty()=='Difficulty_Hard' then
			dm=hm[i]:GetMeter();
			break;
		end;
	end;
	if mettype=="" and dm>=11 then
		ret=true;
	elseif mettype=="ddr" and dm>=11 then
		ret=true;
	elseif mettype=="ddr x" and dm>=17 then
		ret=true;
	elseif mettype=="itg" and dm>=13 then
		ret=true;
	else
		ret=false;
	end;
	return ret;
end;

--[ja] フォルダ名からSong型を返す 
function GetFolder2Song(group,folder)
	local gsongs=SONGMAN:GetSongsInGroup(group);
	for i=1,#gsongs do
		if string.find(string.lower(gsongs[i]:GetSongDir()),"/"..string.lower(folder).."",0,true) then
			return gsongs[i];
		end;
	end;
	return false;
end;

--[ja] 指定したグループフォルダ名と曲フォルダ名の曲を設定する 
function SetSong(group,folder)
local dif={
	Difficulty_Beginner=0,
	Difficulty_Easy=1,
	Difficulty_Medium=2,
	Difficulty_Hard=3,
	Difficulty_Challenge=4,
	Difficulty_Edit=5
};
	local song=GetFolder2Song(group,folder);
	if song then
		GAMESTATE:SetCurrentSong(song);
		for pn=1,2 do
			local now_dif=dif[GAMESTATE:GetCurrentSteps('PlayerNumber_P'..pn):GetDifficulty()];
			local chg_dif=now_dif;
			if GAMESTATE:IsHumanPlayer('PlayerNumber_P'..pn) then
				while (not song:HasStepsTypeAndDifficulty(GAMESTATE:GetCurrentStyle():GetStepsType(),Difficulty[now_dif+1])) do
					if now_dif[pn]>3 then
						chg_dif[pn]=chg_dif[pn]-1;
						if chg_dif[pn]<1 then chg_dif[pn]=#dif end;
					else
						sys_dif[pn]=sys_dif[pn]+1;
						if chg_dif[pn]>#dif then chg_dif[pn]=1 end;
					end;
				end;
				GAMESTATE:SetCurrentSteps('PlayerNumber_P'..pn,
					song:GetOneSteps(GAMESTATE:GetCurrentStyle():GetStepsType(),Difficulty[chg_dif+1]));
			end;
		end;
	end;
	return;
end;
