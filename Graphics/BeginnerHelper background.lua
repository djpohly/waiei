local t=Def.ActorFrame{};

t[#t+1] = Def.Sprite {
	InitCommand=cmd(LoadFromCurrentSongBackground;);
	OnCommand=cmd(scale_or_crop_background;x,0;y,0;);
};

for i=1,2 do
	local pl=((i==1) and PLAYER_1 or PLAYER_2);
	if GAMESTATE:IsHumanPlayer(pl) then
		t[#t+1]=Def.ActorFrame{
			FOV=60;
			InitCommand=cmd(x,THEME:GetMetric("BeginnerHelper","Player"..i.."X")+((i==1) and 5 or -5);
				y,THEME:GetMetric("BeginnerHelper","HelperY")+10;rotationx,-40;zoom,1.05);
			LoadActor("_beginner_panel");
		};
	end;
end;

return t;