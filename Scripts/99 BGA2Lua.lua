-- BGAnimation.ini ->  Lua 
-- [ja] BGAnimation.iniをdefault.luaに変換 
-- [ja] 指定した曲の中に3.9用のBGAnimation.iniしか見つからなかった場合変換 
-- [ja] ただし、タイルやコンディションは未実装 
local bga2lua_ver="1.10";
function BGAtoLUA(song)
	if (GetUserPref_Theme("UserBGAtoLua")=='Never') then return; end;
	local ret="";
	local bgadata=GetSMParameter(song,"bgchanges");
	if bgadata=="" then
		return
	end;
	local songdir=song:GetSongDir();
	local bgaprm={};
	bgaprm=split(",",bgadata);
	for i=1,#bgaprm do
		-- split("=",bgaprm[i])[2] ファイル名
		local tmp=split("=",bgaprm[i])[2];
		if FILEMAN:DoesFileExist(songdir.."/"..tmp.."/bganimation.ini") then
			if (GetUserPref_Theme("UserBGAtoLua")=='Always') or (not FILEMAN:DoesFileExist(songdir.."/"..tmp.."/default.lua")) then
				-- [ja] BGAnimation.iniがあってdefault.luaが無いBGA（3.9用BGA） 
				ret=ret..tmp.."\n"
				-- [ja] ここから変換処理 --
				local f_ini=RageFileUtil.CreateRageFile();
				local f_lua=RageFileUtil.CreateRageFile();
				f_ini:Open(songdir.."/"..tmp.."/bganimation.ini",1);
				f_lua:Open(songdir.."/"..tmp.."/default.lua",2);
				
				local file_lua="-- bga2lua "..bga2lua_ver.."\n\nlocal t=Def.ActorFrame{\n\n";
				local ini_file="<nil>";
				local ini_text="<nil>";
				local ini_type="0";		-- [ja] ストレッチ以外未実装 
				local ini_command="";
				while true do
					local l=f_ini:GetLine();
					local ll=string.lower(l);
					if f_ini:AtEOF() then
						if ini_file~="<nil>" then
							if ini_text=="<nil>" then
								-- [ja] 画像ファイル定義（バナー・背景の場合は読み取り） 
								if string.upper(ini_file)=="SONGBACKGROUND" then
									file_lua=file_lua.."  Def.Sprite{\n    InitCommand=cmd(LoadBackground,GetSongBackground());\n";
								elseif string.upper(ini_file)=="SONGBANNER" then
									file_lua=file_lua.."  Def.Sprite{\n    InitCommand=cmd(LoadBackground,GAMESTATE:GetCurrentSong():GetBannerPath());\n";
								else
									file_lua=file_lua.."  LoadActor(\""..ini_file.."\")..{\n";
								end;
							else
								-- [ja] テキスト定義 
								file_lua=file_lua.."  LoadFont(\""..ini_file.."\")..{\n";
								file_lua=file_lua.."    TEXT=\""..ini_text.."\";\n";
							end;
							-- [ja] コマンド定義 
							if ini_command~="" then
								file_lua=file_lua..""..ini_command;
							end;
							-- [ja] 閉じる（レイヤー単位）
							file_lua=file_lua.."  };\n"
						end;
						break;
						
					-- [ja] 変数 l がオリジナル 
					-- [ja] 変数 ll が小文字変換 

					-- [ja] 各項目取得
					elseif string.find(ll,"file=.*") and ini_file=="<nil>" then
						ini_file=split("=",l)[2];
						ini_file=split(";",ini_file)[1];
					elseif string.find(ll,"text=.*") and ini_text=="<nil>" then
						ini_text=split("=",l)[2];
						ini_text=split(";",ini_text)[1];
						ini_text=string.gsub(ini_text,"::","\\n");
					elseif string.find(ll,"type=.*") then
						ini_type=split("=",l)[2];
						ini_type=split(";",ini_type)[1];
					-- [ja] Command=XXXXXX の場合 
					elseif string.find(ll,"command=.*") then
						-- [ja] オリジナルのコマンドデータを取得 
						local tmp="="..split("=",l)[2];
						ini_command=ini_command.."    OnCommand=cmd(";
						-- [ja] 座標定義がない場合Center定義をする必要がある
						if (not string.find(tmp,";x,")) and (not string.find(tmp,"=x,")) and (not string.find(tmp," x,")) then
							ini_command=ini_command.."x,SCREEN_CENTER_X;";
						else
						-- [ja] BGAは4:3ベースで作られているため現在の画面サイズから値を計算してずらす
							l=string.gsub(l,";x,",";x,(SCREEN_WIDTH-640)/2+");
							l=string.gsub(l,"=x,","=x,(SCREEN_WIDTH-640)/2+");
							l=string.gsub(l," x,"," x,(SCREEN_WIDTH-640)/2+");
							-- [ja] .../2+-320... という記述になる可能性があるので +- を - に変換
							l=string.gsub(l,"%+%-","%-");
						end;
						if (not string.find(tmp,";y,")) and (not string.find(tmp,"=y,"))and (not string.find(tmp," y,")) then
							ini_command=ini_command.."y,SCREEN_CENTER_Y;";
						else
							l=string.gsub(l,";y,",";y,(SCREEN_HEIGHT-480)/2+");
							l=string.gsub(l,"=y,","=y,(SCREEN_HEIGHT-480)/2+");
							l=string.gsub(l," y,"," y,(SCREEN_HEIGHT-480)/2+");
							l=string.gsub(l,"%+%-","%-");
						end;
						-- [ja] TYPE=1（ストレッチ）の場合、画面全体に拡大
						if ini_type=="1" then
							ini_command=ini_command.."zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;";
						end;
						-- [ja] コマンドの最後がSleepで大きめの値をとられている場合、正しく動作しないことを確認しているので取り外す 
						local tmp=split(";",l);
						if #tmp>1 then
							if tmp[#tmp]=="" then
								local ltmp=string.lower(tmp[#tmp-1])
								if string.find(ltmp,"sleep,.*") then
									l=string.gsub(l,";"..tmp[#tmp-1],"");
								end;
							else
								local ltmp=string.lower(tmp[#tmp])
								if string.find(ltmp,"sleep,.*") then
									l=string.gsub(l,";"..tmp[#tmp],"");
								end;
							end;
						end;
						ini_command=ini_command..split("=",l)[2]..");\n";
					-- [ja] xxCommand=XXXXXX の場合（例：OnCommand等） 
					elseif string.find(ll,"^.*command=.*") then
						ini_command=ini_command.."    "..split("=",l)[1].."=cmd(";
						if (not string.find(tmp,";x,")) and (not string.find(tmp,"=x,")) and (not string.find(tmp," x,")) then
							ini_command=ini_command.."x,SCREEN_CENTER_X;";
						else
							l=string.gsub(l,";x,",";x,(SCREEN_WIDTH-640)/2+");
							l=string.gsub(l,"=x,","=x,(SCREEN_WIDTH-640)/2+");
							l=string.gsub(l," x,"," x,(SCREEN_WIDTH-640)/2+");
							l=string.gsub(l,"%+%-","%-");
						end;
						if (not string.find(tmp,";y,")) and (not string.find(tmp,"=y,"))and (not string.find(tmp," y,")) then
							ini_command=ini_command.."y,SCREEN_CENTER_Y;";
						else
							l=string.gsub(l,";y,",";y,(SCREEN_HEIGHT-480)/2+");
							l=string.gsub(l,"=y,","=y,(SCREEN_HEIGHT-480)/2+");
							l=string.gsub(l," y,"," y,(SCREEN_HEIGHT-480)/2+");
							l=string.gsub(l,"%+%-","%-");
						end;
						if ini_type=="1" then
							ini_command=ini_command.."zoomto,640,480;";
						end;
						-- [ja] コマンドの最後がSleepで大きめの値をとられている場合、正しく動作しないことを確認しているので取り外す 
						local tmp=split(";",l);
						if #tmp>1 then
							if tmp[#tmp]=="" then
								local ltmp=string.lower(tmp[#tmp-1])
								if string.find(ltmp,"sleep,.*") then
									l=string.gsub(l,";"..tmp[#tmp-1],"");
								end;
							else
								local ltmp=string.lower(tmp[#tmp])
								if string.find(ltmp,"sleep,.*") then
									l=string.gsub(l,";"..tmp[#tmp],"");
								end;
							end;
						end;
						ini_command=ini_command..split("=",l)[2]..");\n";
					-- [ja] テキスト先頭の可能性があるので、BOM考慮して .* を頭につける 
					elseif string.find(ll,".*%[layer.*%]") then
						if ini_file~="<nil>" then
							if ini_text=="<nil>" then
								file_lua=file_lua.."  LoadActor(\""..ini_file.."\")..{\n";
							else
								file_lua=file_lua.."  LoadFont(\""..ini_file.."\")..{\n";
								file_lua=file_lua.."    TEXT=\""..ini_text.."\";\n";
							end;
							file_lua=file_lua..""..ini_command;
							file_lua=file_lua.."  };\n\n"
						end;
						ini_file="<nil>";	-- [ja] ファイル指定なし 
						ini_text="<nil>";	-- [ja] テキスト指定なし 
						ini_command="";		-- [ja] コマンド初期化 
						ini_type="0";		-- [ja] コマンド初期化 
					end;
				end;
				
				-- [ja] 両サイドに帯をつける 
				file_lua=file_lua.."\n  Def.Quad{\n    OnCommand=cmd(diffuse,0,0,0,1;x,SCREEN_LEFT;y,SCREEN_CENTER_Y;zoomto,(SCREEN_WIDTH-640)/2,SCREEN_HEIGHT;horizalign,left;)\n  };\n";
				file_lua=file_lua.."  Def.Quad{\n    OnCommand=cmd(diffuse,0,0,0,1;x,SCREEN_RIGHT;y,SCREEN_CENTER_Y;zoomto,(SCREEN_WIDTH-640)/2,SCREEN_HEIGHT;horizalign,right;)\n  };\n\n";
				-- [ja] 閉じる 
				file_lua=file_lua.."\n};\n\nreturn t;\n";
				
				f_lua:Write(file_lua);
				f_ini:Close();
				f_lua:Close();
				f_ini:destroy();
				f_lua:destroy();
				-- [ja] ここまで変換処理 --
			end;
		end;
	end;
	return;
end;
