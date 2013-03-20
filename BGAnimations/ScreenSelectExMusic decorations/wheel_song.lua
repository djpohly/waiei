local i,load_jackets,load_songs,foldername,load_cnt,load_songtitle,load_songartist = ...;
local t = Def.ActorFrame{};

local wheelmode="";
if GetUserPref_Theme("UserWheelMode") == 'Jacket->Banner' then
	wheelmode = "JBN"
elseif GetUserPref_Theme("UserWheelMode") == 'Jacket->BG' then
	wheelmode = "JBG"
elseif GetUserPref_Theme("UserWheelMode") == 'Banner->Jacket' then
	wheelmode = "BNJ"
else
	wheelmode = "JBN"
end;
local wheeltext="";
if GetUserPref_Theme("UserWheelText") == 'Default' then
	wheeltext = "default"
elseif GetUserPref_Theme("UserWheelText") == 'All' then
	wheeltext = "all"
elseif GetUserPref_Theme("UserWheelText") == 'None' then
	wheeltext = "none"
else
	wheeltext = "default"
end;

-- [ja] 対象グループ 
local sys_group=GetUserPref_Theme("ExGroupName");
local exstage=GetEXFolderStage();
-- [ja] 選曲式か、強制確定か 
local sys_extype=GetGroupParameter(sys_group,"Extra"..exstage.."Type");
sys_extype=string.lower(sys_extype);
-- [ja] システム的にキー操作を受け付けるタイミング 
local sys_keyok=false;
--	*****************************************************************************************************************************************************
--[ja] ファイルから読み取る情報。何度も呼ぶと重いのでローカル変数で作っておく 
local col="";
local col_t={};
local mettype="";
local fsubtitle=0;
local ssubtitle="";
local stitle="";
local sys_focus=0;
local song;
local foldername;

t[#t+1]=Def.ActorFrame{
	-- [ja] キー操作許可管理 
	OnCommand=function(self)
		if sys_extype~="song" then
			sys_keyok=false;
			self:sleep(EXF_BEGIN_WAIT());
			self:queuecommand("KeyUnlock");
		end;
	end;
	KeyUnlockCommand=function(self) sys_keyok=true; end;
	-- [ja] キー操作用 
	CodeMessageCommand = function(self, params)
		if sys_keyok and GAMESTATE:IsHumanPlayer(params.PlayerNumber) and sys_extype~="song" then
			if params.Name == 'Back' then
				self:queuecommand("Back");
			elseif params.Name=="Start" then
				if key_selected<2 then
					self:queuecommand("Start");
				end;
			elseif (params.Name == 'Left' or params.Name == 'Left2') then
				self:queuecommand("Left");
			elseif (params.Name == 'Right' or params.Name == 'Right2') then
				self:queuecommand("Right");
			elseif (params.Name == 'Up' or params.Name == 'Up2') then
				self:queuecommand("Up");
			elseif (params.Name == 'Down' or params.Name == 'Down2') then
				self:queuecommand("Down");
			end;
		end;
	end;
	
-- [ja] 改造するならこれより下の部分 -------------------------------------------------------------------------------------------------------------------- 
--[[
	load_cnt		曲数 

	load_songs[i]			song型 
	※iの値は以下の範囲
	　1 <= i <= load_cnt

	foldername			選択中曲フォルダ名※
	
	※スクリーン遷移後、最初の曲フォルダ名が設定されているだけなので、 
	　曲切り替え後は自分で取得する必要あり 
	local pathtmp=split("/",song:GetSongDir());
	foldername=pathtmp[#pathtmp-1];
		↑
	例えば今選択中の曲が "A/BBB/CCC/song.sm" の場合、
	song:GetSongDir() で "A/BBB/CCC/song.sm" という文字を取得できる。
	次に split("/",song:GetSongDir()) で "/" で区切って pathtmp に代入される。
	つまり、この段階で pathtmp[1]="A" , pathtmp[2]="BBB" , pathtmp[3]="CCC" , pathtmp[4]="song.sm" となる。
	先頭に"#"をつけて、 #pathtmp とすると、pathtmp[X] のXの最大値が取得できるので、
	現在選択中の楽曲のフォルダ名は #pathtmp-1 となる。
	よって、foldername=pathtmp[#pathtmp-1]; とすれば良い。

	load_jackets[foldername]		ジャケット画像パス 
	load_songtitle[foldername]		曲名 
	load_songartist[foldername]		アーティスト名 
--]]	
	LeftCommand=function(self)
		self:queuecommand("ChangeSong");
		sys_focus=sys_focus-1;
		if sys_focus<0 then sys_focus=sys_focus+load_cnt end;
	end;
	RightCommand=function(self)
		self:queuecommand("ChangeSong");
		sys_focus=sys_focus+1;
		if sys_focus>=load_cnt then sys_focus=0 end;
	end;
	UpCommand=function(self)
	end;
	DownCommand=function(self)
	end;
	StartCommand=function(self)
	end;
	BackCommand=function(self)
	end;

	-- [ja] 曲データのMENUCOLORやタイトルなど情報取得 
	Def.Quad{
		InitCommand=cmd(visible,false;queuecommand,"ChangeSong");
		ChangeSongCommand=function(self)
			song=nil;
			if load_cnt>0 then
				song_number=sys_focus+i;
				while (song_number<0) do
					song_number=song_number+load_cnt;
				end;
				song_number=(song_number%load_cnt)+1;
				song = load_songs[song_number];

				song_number=sys_focus+i;
				while (song_number<0) do
					song_number=song_number+load_cnt;
				end;
				song_number=(song_number%load_cnt)+1;
				local song = load_songs[song_number];
				col="";
				fsubtitle=0;
				ssubtitle="";
				stitle="";
				if i==0 and song then
					local io_st=song:GetAllSteps();
					if #io_st>=1 then
						local io_t;
						io_t=io_st[1]:GetFilename();
						if FILEMAN:DoesFileExist(io_t) then
							--[ja] 形式ではじく 
							local io_lt=string.lower(io_t);
							if string.find(io_lt,".*%.sm") or string.find(io_lt,".*%.ssc") then
								local io_f=RageFileUtil.CreateRageFile();
								io_f:Open(io_t,1);
								col=GetSMParameter_f(io_f,"menucolor");
								if col=="" then
									col=GetExtendedParameter(song,"menucolor");
								end;
								mettype=string.lower(GetSMParameter_f(io_f,"METERTYPE"));
								if mettype=="" then
									mettype=GetExtendedParameter(song,"METERTYPE");
								end;
								io_f:Close();
								io_f:destroy();
							end;
							if col=="" then
								local c={1,1,1,1};
								if IsBossColor(song,mettype) then
									c=Color("Red");
								else
									c=Color("White");
								end;
								col=""..c[1]..","..c[2]..","..c[3]..","..c[4];
							end;
						end;
					end;
				else
					col="";
					mettype="ddr";
				end;
				col_t=Str2Color(col);
				self:visible(0);
				local pathtmp=split("/",song:GetSongDir());
				foldername=pathtmp[#pathtmp-1];
				if load_songtitle[""..foldername] then
					fsubtitle=0;
					stitle=load_songtitle[""..foldername];
					ssubtitle="";
				else
					if song:GetDisplaySubTitle()~="" then
						fsubtitle=1;
						stitle=song:GetDisplayMainTitle();
						ssubtitle=song:GetDisplaySubTitle();
					else
						local spl_title=SplitTitle(song:GetDisplayMainTitle());
						stitle=spl_title[1];
						ssubtitle=spl_title[2];
						if ssubtitle=="" then fsubtitle=0 else fsubtitle=1 end;
					end;
				end;
			else
				col="0,0.75,1,1";
				fsubtitle=0;
				stitle=THEME:GetString("ScreenSelectExMusic","NotFound");
				ssubtitle="";
				col_t=Str2Color(col);
			end;
		end;
	};
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame under"))..{
	};
	-- [ja] ジャケット（バナー） 
	Def.Banner {
		InitCommand=cmd(x,-96;y,-96;queuecommand,"ChangeSong");
		SetMessageCommand=function(self)
			if song then
				-- this is where we do all song-specific stuff
				local g;
				if wheelmode=="JBN" then
					g=GetSongGPath_JBN(song);
				elseif wheelmode=="JBG" then
					g=GetSongGPath_JBG(song);
				elseif wheelmode=="BNJ" then
					g=GetSongGPath_BNJ(song);
				else
					g=GetSongGPath_JBN(song);
				end;
				if i==0 then
					self:visible(true);
					if load_jackets[""..foldername]~=nil then
						self:Load(load_jackets[""..foldername]);
					else
						self:Load(g);
					end;
					self:rate(1.0);
				else
					if load_jackets[""..foldername]~=nil then
						self:Load(load_jackets[""..foldername]);
					elseif g==song:GetBannerPath() then
						self:LoadFromCachedBanner(g);
					else
						self:Load(g);
					end;
					self:rate(1.0);
				end;
			else
				-- call fallback
				self:Load( THEME:GetPathG("_MusicWheel","NotFound") );
			end;
			self:stoptweening();
			self:scaletofit(0,0,188,188);
			self:x(0);
			self:y(0);
		end;
		ChangeSongCommand=function(self)
			self:stoptweening();
			self:playcommand("Set");
		end;
	};
	-- [ja] #MENUCOLOR用 
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame color")).. {
		--InitCommand=cmd(x,-2;);
		InitCommand=cmd(queuecommand,"ChangeSong");
		ChangeSongCommand=function(self)
			--self:Load( THEME:GetPathG("_MusicWheel","BannerFrame color"));
			if col~="" then
				self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
			else
				if i==0 then
					self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
				else
					self:diffuse(Color("White"));
				end;
			end;
		end;
	};
	-- [ja] 光沢感 
	LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame over"))..{
	};
	-- [ja] タイトル背景 
	Def.Quad{
		InitCommand=cmd(diffuse,0,0,0,1;zoomto,192,50;y,96-25;queuecommand,"ChangeSong");
		ChangeSongCommand=function(self)
			if (i==0 and wheeltext~="none") or wheeltext=="all" then
				self:diffusealpha(1.0);
				self:diffuseleftedge(0,0,0,0.25);
			else
				self:diffusealpha(0);
			end;
		end;
	};
	-- [ja] タイトル 
	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;maxwidth,230;queuecommand,"ChangeSong");
		ChangeSongCommand=function(self)
			self:settextf("%s",stitle);
			if stitle==THEME:GetString("ScreenSelectExMusic","NotFound") then
				self:y(97-23);
			elseif fsubtitle==0 then
				self:y(90-23);
			else
				self:y(83-23);
			end;
			--if GetSMParameter(params.Song,"metertype") == "DDR X" and then
			if col~="" then
				self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
			else
				if i==0 then
					self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
				else
					self:diffuse(Color("White"));
				end;
			end;
			self:strokecolor(Color("Outline"));
			if (i==0 and wheeltext~="none") or wheeltext=="all" then
				self:zoom(0.8);
				self:x(92);
			else
				self:zoom(0);
			end;
			self:shadowlength(1);
		end;
	};
	-- [ja] サブタイトル 
	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;maxwidth,360;queuecommand,"ChangeSong");
		ChangeSongCommand=function(self)
			self:settextf("%s\n ",ssubtitle);
			if fsubtitle==0 then
				self:y(98-23);
			else
				self:y(103-23);
			end;
			if col~="" then
				self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
			else
				if i==0 then
					self:diffuse(col_t[1],col_t[2],col_t[3],col_t[4]);
				else
					self:diffuse(Color("White"));
				end;
			end;
			self:strokecolor(Color("Outline"));
			if (i==0 and wheeltext~="none") or wheeltext=="all" then
				self:zoom(0.5);
				self:x(91);
			else
				self:zoom(0);
			end;
			self:shadowlength(1);
		end;
	};
	-- [ja] アーティスト名 
	LoadFont("Common Normal")..{
		InitCommand=cmd(horizalign,right;maxwidth,360;queuecommand,"ChangeSong");
		ChangeSongCommand=function(self)
			if load_cnt>0 then
				if load_songartist[""..foldername] then
					self:settextf("\n%s",load_songartist[""..foldername]);
				else
					self:settextf("\n%s",_SONG():GetDisplayArtist());
				end;
			else
				self:settextf("");
			end;
			if fsubtitle==0 then
				self:y(100-23);
			else
				self:y(105-23);
			end;
			self:diffuse(Color("White"));
			self:strokecolor(Color("Outline"));
			if (i==0 and wheeltext~="none") or wheeltext=="all" then
				self:zoom(0.5);
				self:x(91);
			else
				self:zoom(0);
			end;
			self:shadowlength(1);
		end;
	};
};


return t;