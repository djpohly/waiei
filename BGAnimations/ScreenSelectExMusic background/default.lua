local t = Def.ActorFrame{};

local sys_group=GetUserPref_Theme("ExGroupName");
local bg=GetGroupParameter(sys_group,"Extra"..GetEXFolderStage().."BackGround");
local fn=split("%.",bg);

if bg~="" and FILEMAN:DoesFileExist("/Songs/"..sys_group.."/"..bg)  then
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			if string.lower(fn[#fn])~="lua" then self:Center(); end;
		end;
		LoadActor("/Songs/"..sys_group.."/"..bg);
	};
elseif bg~="" and FILEMAN:DoesFileExist("/AdditionalSongs/"..sys_group.."/"..bg) then
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			if string.lower(fn[#fn])~="lua" then self:Center(); end;
		end;
		LoadActor("/AdditionalSongs/"..sys_group.."/"..bg);
	};
else
	t[#t+1] = Def.ActorFrame{
		LoadActor(THEME:GetPathB("EXFolder","background"));
	};
end;

return t;