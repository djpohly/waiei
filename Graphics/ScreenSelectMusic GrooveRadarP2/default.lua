local t=Def.ActorFrame{};

local r_str_x=0;
local r_str_y=0;
local r_vol_x=0;
local r_vol_y=0;
local r_cha_x=0;
local r_cha_y=0;
local r_frz_x=0;
local r_frz_y=0;
local r_air_x=0;
local r_air_y=0;
local radar_x={0,0,0,0,0,0,0,0,0,0};
local radar_y={0,0,0,0,0,0,0,0,0,0};
local keymode=false;

t[#t+1]=Def.ActorFrame{
	LoadActor("../_GrooveRadar base")..{
	--	InitCommand=cmd(diffuse,ColorDarkTone(PlayerColor(PLAYER_2)));
		InitCommand=cmd(diffuse,PlayerColor(PLAYER_2));
		OnCommand=function(self)
			self:player(PLAYER_2);
			self:diffusealpha(0);
			self:zoom(0);
			self:sleep(0.583);
			self:decelerate(0.150);
			self:diffusealpha(0.8);
			self:zoom(1);
		end;
		JoinedCommand=function(self)
			self:player(PLAYER_2);
			self:diffusealpha(0);
			self:zoom(0);
			self:decelerate(0.150);
			self:diffusealpha(0.8);
			self:zoom(1);
		end;
		PlayerJoinedMessageCommand=cmd(playcommand,"Joined");
		OffCommand=cmd(sleep,0.183;decelerate,0.167;zoom,0);
	};
	LoadActor("../_GrooveRadar over")..{
		OnCommand=function(self)
			self:player(PLAYER_2);
			self:diffusealpha(0);
			self:zoom(0);
			self:sleep(0.583);
			self:decelerate(0.150);
			self:diffusealpha(0.3);
			self:zoom(1);
		end;
		JoinedCommand=function(self)
			self:player(PLAYER_2);
			self:diffusealpha(0);
			self:zoom(0);
			self:decelerate(0.150);
			self:diffusealpha(0.3);
			self:zoom(1);
		end;
		PlayerJoinedMessageCommand=cmd(playcommand,"Joined");
		OffCommand=cmd(sleep,0.183;decelerate,0.167;zoom,0);
	};
	Name="Radar";
	Def.GrooveRadar {
		OnCommand=cmd(zoom,0;sleep,0.583;decelerate,0.150;zoom,1.2);
		OffCommand=cmd(sleep,0.183;decelerate,0.167;zoom,0);
		ChangedCommand=function(self)
			local song=GAMESTATE:GetCurrentSong();
			self:player(PLAYER_2);
			--radarSet(self, PLAYER_2);
			if song then
				local dif=GAMESTATE:GetCurrentSteps(PLAYER_2):GetDifficulty();
				local smexp_gr=GetSMParameter(song,"GR"..ToEnumShortString(dif));
				local RadarPrm={"Stream","Chaos","Freeze","Air","Voltage"};
				local l=0.80;
				for i=1,5 do
					if smexp_gr=="" then
						radar_x[i]=yaGetRadarVal(song,PLAYER_2,RadarPrm[i],false) *l*math.sin(2*math.pi*(i-1)/5);
						radar_y[i]=yaGetRadarVal(song,PLAYER_2,RadarPrm[i],false) *l*math.cos(2*math.pi*(i-1)/5)*(-1);
					else
						-- [ja] 不正ファイルの対策していないので非公開機能 
						local smexp_gr_s=tonumber(split(',',smexp_gr)[i]);
						if smexp_gr_s>=0 then
							radar_x[i]=math.max(smexp_gr_s*100,5) *l*math.sin(2*math.pi*(i-1)/5);
							radar_y[i]=math.max(smexp_gr_s*100,5) *l*math.cos(2*math.pi*(i-1)/5)*(-1);
						else
							radar_x[i]=yaGetRadarVal(song,PLAYER_2,RadarPrm[i],false) *l*math.sin(2*math.pi*(i-1)/5);
							radar_y[i]=yaGetRadarVal(song,PLAYER_2,RadarPrm[i],false) *l*math.cos(2*math.pi*(i-1)/5)*(-1);
						end;
					end;
				end;
				for i=1,5 do
				radar_x[i+5]= yaGetRadarVal(song,PLAYER_2,RadarPrm[i],true) *l*math.sin(2*math.pi*(i-1)/5);
				radar_y[i+5]= yaGetRadarVal(song,PLAYER_2,RadarPrm[i],true) *l*math.cos(2*math.pi*(i-1)/5)*(-1);
				end;
				keymode=yaGetKeyMode(song);
			else
				for i=1,10 do
					radar_x[i]=0;
					radar_y[i]=0;
				end;
				keymode=false;
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Changed");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Changed");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Changed");
		PlayerJoinedMessageCommand=cmd(playcommand,"Changed");
	};

};

t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(player,PLAYER_2;);
	PlayerJoinedMessageCommand=cmd(player,PLAYER_2;);
	LoadActor("../_GrooveRadar autogen")..{
		JoinedCommand=function(self)
			self:player(PLAYER_2);
			local step=GAMESTATE:GetCurrentSteps(PLAYER_2);
			if step then
				if step:IsAutogen() then
					self:stoptweening();
					self:x(42);
					self:y(-55);
					self:zoomy(1);
					self:blend("BlendMode_Add")
					self:diffuse(PlayerColor(PLAYER_2));
					self:glowblink();
					self:effectperiod(0.80);
					self:visible(1);
				else
					self:visible(0);
				end;
			else
				self:visible(0);
			end;
		end;
		PlayerJoinedMessageCommand=cmd(playcommand,"Joined");
		OnCommand=cmd(playcommand,"Joined";diffusealpha,0;zoomy,0;sleep,0.583;decelerate,0.150;diffusealpha,1;zoomy,1;);
		OffCommand=cmd(sleep,0.183;decelerate,0.167;zoom,0);
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Joined");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Joined");
		CurrentSongChangedMessageCommand=cmd(playcommand,"Joined");
	};
};

local radar_name={"STR","CHA","FRZ","AIR","VOL"};
for cnt=1,10 do
local i=(cnt-1)%5+1;
t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(player,PLAYER_2;);
	PlayerJoinedMessageCommand=cmd(player,PLAYER_2;);
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:player(PLAYER_2);
			self:stoptweening();
			self:x(55.0*math.sin(2*math.pi*(i-1)/5));
			self:y(55.0*math.cos(2*math.pi*(i-1)/5)*(-1));
			self:rotationz(360*(i-1)/5);
			self:diffuse(1,1,1,1);
			self:settextf("%s",radar_name[i]);
			self:diffusealpha(0);
			self:zoom(0);
			self:sleep(0.583);
			self:decelerate(0.150);
			self:diffusealpha(0.5);
			self:zoom(0.5);
		end;
		PlayerJoinedMessageCommand=cmd(playcommand,"Init");
		OnMessageCommand=cmd(playcommand,"Init");
		OffCommand=cmd(sleep,0.183;decelerate,0.167;zoom,0);
	};
};
end;
for i=1,10 do
t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(player,PLAYER_2;);
	PlayerJoinedMessageCommand=cmd(player,PLAYER_2;);
	Def.Quad{
		OnCommand=cmd(playcommand,"Changed");
		OffCommand=cmd(sleep,0.183;decelerate,0.167;zoom,0);
		ChangedCommand=function(self)
			if GAMESTATE:GetCurrentSong() then
				self:stoptweening();
				self:decelerate(0.150);
				local x;
				local y;
				if i<=5 then
					x=radar_x[i]-radar_x[i%5+1];
					y=radar_y[i]-radar_y[i%5+1];
				else
					x=radar_x[i]-radar_x[i%5+6];
					y=radar_y[i]-radar_y[i%5+6];
				end;
				local r=1.0*math.atan2(y,x)*180.0/math.pi;
				local l=math.sqrt(x*x+y*y);
				self:zoomto(l,1.8);
				self:blend('BlendMode_Add');
				if i<=5 then
					self:diffuse(PlayerColor(PLAYER_2));
					self:diffuseleftedge(0,0.5,1,1);
					self:diffusealpha(1);
					self:x((radar_x[i]+radar_x[i%5+1])/2);
					self:y((radar_y[i]+radar_y[i%5+1])/2);
				else
					self:diffuse(Color("White"));
					self:diffusealpha(0.33);
					self:x((radar_x[i]+radar_x[i%5+6])/2);
					self:y((radar_y[i]+radar_y[i%5+6])/2);
				end;
				self:rotationz(r);
				--[[
				if not keymode then
					self:diffuseleftedge(0,0.5,1,1);
				else
					self:diffuseleftedge(1,0.5,0.5,1);
				end;
				--]]
				self:visible(1);
			else
				self:visible(0);
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Changed");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Changed");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Changed");
		PlayerJoinedMessageCommand=cmd(playcommand,"Changed");
	};
};
end;

return t;