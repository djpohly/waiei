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

local function GetTrailSong(tr,no)
	local e = tr:GetTrailEntries();
	if #e<=0 then
		return nil;
	else
		return e[((no-1)%(#e))+1]:GetSong();
	end;
end;
local function GetTrailSteps(tr,no)
	local e = tr:GetTrailEntries();
	if #e<=0 then
		return nil;
	else
		return e[((no-1)%(#e))+1]:GetSteps();
	end;
end;

function ListBG(self)
	local t=Def.ActorFrame{};
	t[#t+1]=Def.ActorFrame{
		LoadActor("pro_course");
		LoadActor("list_bg")..{
			InitCommand=cmd(x,-310+50;diffuse,Color("White"););
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		};
		LoadActor("list_bg")..{
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
return t;
end;

local t=Def.ActorFrame{};
local trail;
local tr_max=0;
local st=GAMESTATE:GetCurrentStyle():GetStepsType();
local mt=GetUserPref_Theme("UserMeterType");
local index=1;
t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,THEME:GetMetric("ScreenSelectMusic","MusicWheelY")+135);
	ListBG();
};

for i=1,5 do
	t[#t+1]=Def.ActorFrame{
		FOV=60;
		ChgTrailCommand=cmd(vanishpoint,SCREEN_CENTER_X,SCREEN_CENTER_Y;);
		LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame under"))..{
			InitCommand=cmd(zoom,0.52);
			ChgTrailCommand=function(self)
				self:finishtweening();
				trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				tr_max = #(trail:GetTrailEntries());
				if i>tr_max or trail==0 then
					self:visible(false);
				else
					self:visible(true);
					self:x(SCREEN_CENTER_X);
					self:y(SCREEN_CENTER_Y+95);
					self:diffusealpha(0);
					self:linear(0.3);
					self:diffusealpha(1);
					if tr_max==1 then
						self:x(SCREEN_CENTER_X);
					elseif tr_max==2 then
						self:x(SCREEN_CENTER_X-100+200*(i-1));
					elseif tr_max==3 then
						self:x(SCREEN_CENTER_X-150+150*(i-1));
					elseif tr_max==4 then
						self:x(SCREEN_CENTER_X-200+133.3*(i-1));
					else
						self:x(SCREEN_CENTER_X-250+125*(i-1));
					end;
				end;
			end;
			OnCommand=cmd(playcommand,"ChgTrail");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"ChgTrail");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"ChgTrail");
			OffCommand=cmd(finishtweening;linear,0.3;diffusealpha,0;x,SCREEN_CENTER_X);
		};
		Def.Banner {
			Name="SongBanner";
			InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+160);
			ChgTrailCommand=function(self)
				self:finishtweening();
				index=0;
				trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				tr_max = #(trail:GetTrailEntries());
				if i>tr_max then
					self:visible(false);
				else
					self:visible(true);
					local song=GetTrailSong(trail,i);
					self:diffusealpha(0);
					self:sleep(0.3);
					self:y(SCREEN_CENTER_Y+95);
					self:queuecommand("NextSong");
				end;
			end;
			NextSongCommand=function(self)
				trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				tr_max = #(trail:GetTrailEntries());
				self:stoptweening();
				local song=GetTrailSong(trail,i+index);
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
				self:LoadBackground(g);
				self:scaletofit(0,0,100,100);
				self:y(SCREEN_CENTER_Y+95);
				if tr_max==1 then
					self:x(SCREEN_CENTER_X);
				elseif tr_max==2 then
					self:x(SCREEN_CENTER_X-100+200*(i-1));
				elseif tr_max==3 then
					self:x(SCREEN_CENTER_X-150+150*(i-1));
				elseif tr_max==4 then
					self:x(SCREEN_CENTER_X-200+133.3*(i-1));
				else
					self:x(SCREEN_CENTER_X-250+125*(i-1));
				end;
				self:addx(40);
				self:linear(0.2);
				self:addx(-40);
				self:diffusealpha(1);
				if tr_max>5 then
					self:sleep(1.6);
					self:linear(0.2);
					self:addx(-40);
					self:diffusealpha(0);
					self:queuecommand("NextSong");
				end;
			end;
			OnCommand=cmd(playcommand,"ChgTrail");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"ChgTrail");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"ChgTrail");
			OffCommand=cmd(finishtweening;linear,0.3;diffusealpha,0;x,SCREEN_CENTER_X);
		};
		Def.Quad{
			InitCommand=cmd(zoomto,100,100;diffuse,0,0,0,0;);
			ChgTrailCommand=function(self)
				self:finishtweening();
				trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				tr_max = #(trail:GetTrailEntries());
				if i>tr_max then
					self:visible(false);
				else
					self:diffuselowerright(_DifficultyCOLOR(GetTrailSteps(trail,i):GetDifficulty()));
					self:visible(true);
					local song=GetTrailSong(trail,i);
					self:diffusealpha(0);
					self:y(SCREEN_CENTER_Y+95);
					self:linear(0.3);
					self:queuecommand("NextSong");
				end;
			end;
			NextSongCommand=function(self)
				trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				tr_max = #(trail:GetTrailEntries());
				self:stoptweening();
				self:diffuselowerright(_DifficultyCOLOR(GetTrailSteps(trail,i+index):GetDifficulty()));
				self:scaletofit(0,0,100,100);
				self:y(SCREEN_CENTER_Y+95);
				if tr_max==1 then
					self:x(SCREEN_CENTER_X);
				elseif tr_max==2 then
					self:x(SCREEN_CENTER_X-100+200*(i-1));
				elseif tr_max==3 then
					self:x(SCREEN_CENTER_X-150+150*(i-1));
				elseif tr_max==4 then
					self:x(SCREEN_CENTER_X-200+133.3*(i-1));
				else
					self:x(SCREEN_CENTER_X-250+125*(i-1));
				end;
				self:linear(0.2);
				self:diffuselowerright(_DifficultyCOLOR(GetTrailSteps(trail,i+index):GetDifficulty()));
				if tr_max>5 then
					self:sleep(1.3);
					self:linear(0.5);
					self:diffusealpha(0);
					self:diffuselowerright(_DifficultyCOLOR(GetTrailSteps(trail,i+index):GetDifficulty()));
					self:queuecommand("NextSong");
				end;
			end;
			OnCommand=cmd(playcommand,"ChgTrail");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"ChgTrail");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"ChgTrail");
			OffCommand=cmd(finishtweening;linear,0.3;diffusealpha,0;x,SCREEN_CENTER_X);
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(horizalign,left;vartalign,top;zoom,0.8);
			ChgTrailCommand=function(self)
				self:finishtweening();
				trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				tr_max = #(trail:GetTrailEntries());
				if i>tr_max then
					self:visible(false);
				else
					self:visible(true);
					self:diffusealpha(0);
					self:y(SCREEN_CENTER_Y+95);
					self:linear(0.3);
					self:queuecommand("NextSong");
				end;
			end;
			NextSongCommand=function(self)
				trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				tr_max = #(trail:GetTrailEntries());
				self:stoptweening();
				self:diffusealpha(1);
				self:zoom(0.6);
				self:y(SCREEN_CENTER_Y+95-38);
				if tr_max==1 then
					self:x(SCREEN_CENTER_X);
				elseif tr_max==2 then
					self:x(SCREEN_CENTER_X-100+200*(i-1)-45);
				elseif tr_max==3 then
					self:x(SCREEN_CENTER_X-150+150*(i-1)-45);
				elseif tr_max==4 then
					self:x(SCREEN_CENTER_X-200+133.3*(i-1)-45);
				else
					self:x(SCREEN_CENTER_X-250+125*(i-1)-45);
				end;
				self:diffuse(Color("White"));
				self:strokecolor(Color("Outline"));
				self:shadowlength(2);
				self:settextf("Stage %d",(((i+index-1)%tr_max)+1));
				self:linear(0.2);
				if tr_max>5 then
					self:sleep(1.3);
					self:linear(0.5);
					self:diffusealpha(0);
					self:queuecommand("NextSong");
				end;
			end;
			OnCommand=cmd(playcommand,"ChgTrail");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"ChgTrail");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"ChgTrail");
			OffCommand=cmd(finishtweening;linear,0.3;diffusealpha,0;x,SCREEN_CENTER_X);
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(horizalign,right;vartalign,bottom;);
			ChgTrailCommand=function(self)
				self:finishtweening();
				trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				tr_max = #(trail:GetTrailEntries());
				if i>tr_max then
					self:visible(false);
				else
					self:visible(true);
					self:diffusealpha(0);
					self:y(SCREEN_CENTER_Y+95);
					self:linear(0.3);
					self:queuecommand("NextSong");
				end;
			end;
			NextSongCommand=function(self)
				trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				tr_max = #(trail:GetTrailEntries());
				self:stoptweening();
				self:diffusealpha(1);
				self:y(SCREEN_CENTER_Y+95+38);
				if tr_max==1 then
					self:x(SCREEN_CENTER_X);
				elseif tr_max==2 then
					self:x(SCREEN_CENTER_X-100+200*(i-1)+48);
				elseif tr_max==3 then
					self:x(SCREEN_CENTER_X-150+150*(i-1)+48);
				elseif tr_max==4 then
					self:x(SCREEN_CENTER_X-200+133.3*(i-1)+48);
				else
					self:x(SCREEN_CENTER_X-250+125*(i-1)+48);
				end;
				local song=GetTrailSong(trail,i+index);
				local dif=GetTrailSteps(trail,i+index):GetDifficulty();
				local meter=GetConvertDifficulty(song,st,dif,GetSMParameter(song,"metertype"),mt);
				self:diffuse(_DifficultyCOLOR(dif));
				self:strokecolor(Color("Outline"));
				self:settextf("%d",meter);
				self:linear(0.2);
	if i==5 then index=index+1; end;
	if index>tr_max then index=1 end;
				if tr_max>5 then
					self:sleep(1.3);
					self:linear(0.5);
					self:diffusealpha(0);
					self:queuecommand("NextSong");
				end;
			end;
			OnCommand=cmd(playcommand,"ChgTrail");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"ChgTrail");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"ChgTrail");
			OffCommand=cmd(finishtweening;linear,0.3;diffusealpha,0;x,SCREEN_CENTER_X);
		};
		LoadActor(THEME:GetPathG("_MusicWheel","BannerFrame color"))..{
			InitCommand=cmd(zoom,0.52);
			ChgTrailCommand=function(self)
				self:finishtweening();
				trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				tr_max = #(trail:GetTrailEntries());
				if i>tr_max then
					self:visible(false);
				else
					self:visible(true);
					self:x(SCREEN_CENTER_X);
					self:y(SCREEN_CENTER_Y+95);
					self:diffusealpha(0);
					self:linear(0.3);
					self:diffusealpha(1);
					if tr_max==1 then
						self:x(SCREEN_CENTER_X);
					elseif tr_max==2 then
						self:x(SCREEN_CENTER_X-100+200*(i-1));
					elseif tr_max==3 then
						self:x(SCREEN_CENTER_X-150+150*(i-1));
					elseif tr_max==4 then
						self:x(SCREEN_CENTER_X-200+133.3*(i-1));
					else
						self:x(SCREEN_CENTER_X-250+125*(i-1));
					end;
				end;
			end;
			OnCommand=cmd(playcommand,"ChgTrail");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"ChgTrail");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"ChgTrail");
			OffCommand=cmd(finishtweening;linear,0.3;diffusealpha,0;x,SCREEN_CENTER_X);
		};
	};
end;
for i=1,5 do
t[#t+1]=Def.ActorFrame{
	LoadActor(THEME:GetPathG("EditMenu","Left"))..{
			InitCommand=cmd(zoom,1.1;rotationy,180;);
			ChgTrailCommand=function(self)
				self:finishtweening();
				trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				tr_max = #(trail:GetTrailEntries());
				if i>=tr_max or tr_max<=1 then
					self:visible(false);
				else
					self:visible(true);
					self:x(SCREEN_CENTER_X);
					self:y(SCREEN_CENTER_Y+95);
					self:diffusealpha(0);
					self:linear(0.3);
					self:diffusealpha(1);
					self:blend("BlendMode_Add");
					if tr_max==2 then
						self:x(SCREEN_CENTER_X-100+200*(i-1)+90);
					elseif tr_max==3 then
						self:x(SCREEN_CENTER_X-150+150*(i-1)+65);
					elseif tr_max==4 then
						self:x(SCREEN_CENTER_X-200+133.3*(i-1)+56.7);
					else
						self:x(SCREEN_CENTER_X-250+125*(i-1)+57.5);
					end;
				end;
			end;
			OnCommand=cmd(playcommand,"ChgTrail");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"ChgTrail");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"ChgTrail");
			OffCommand=cmd(finishtweening;linear,0.3;diffusealpha,0;x,SCREEN_CENTER_X);
	};
};
end;

return t;
