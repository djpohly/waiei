local summary=THEME:GetMetric( Var "LoadingScreen","Summary" );
local t=Def.ActorFrame{};
if summary then
	t[#t+1]=LoadActor("summary");
else
	t[#t+1]=LoadActor("normal");
end;

return t;