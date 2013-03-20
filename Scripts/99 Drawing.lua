-- [ja] 図形 

-- [ja] 円 
-- [ja] rot...開始角度（0～31） 
-- [ja] ang...描画角度（0～32） 
function DrawCircle32(type,col,rot,ang)
	if ang<=0 then
		return;
	end;
	if col=="" then
		col=Color("White");
	end;
	rot=rot%32;
	ang=(ang-1)%32;
	local t=Def.ActorFrame{};
	for i=rot,rot+ang do
	t[#t+1]=Def.ActorFrame{
		LoadActor(THEME:GetPathG("_objects/_circle32",""..type))..{
			InitCommand=cmd(vertalign,bottom;
				diffuse,col;rotationz,11.25*i);
		};
	};
	end;
	return t;
end;

function DrawCircle64(type,col,rot,ang)
	if ang<=0 then
		return;
	end;
	if col=="" then
		col=Color("White");
	end;
	rot=rot%64;
	ang=(ang-1)%64;
	local t=Def.ActorFrame{};
	for i=rot,rot+ang do
	t[#t+1]=Def.ActorFrame{
		OnCommand=cmd(zoom,0;sleep,0.005*i;linear,0.2;zoom,1);
		LoadActor(THEME:GetPathG("_objects/_circle64",""..type))..{
			InitCommand=cmd(vertalign,bottom;
				diffuse,col;rotationz,5.625*i);
		};
	};
	end;
	return t;
end;

