local Params = { 
	NumParticles = 25,
	VelocityXMin = 0,
	VelocityXMax = 0,
	VelocityYMin = -200,
	VelocityYMax = -100,
	VelocityZMin = 0,
	VelocityZMax = 0,
	BobRateZMin = 0.4,
	BobRateZMax = 0.7,
	ZoomMin = 0.5,
	ZoomMax = 1,
	SpinZ = 360,
	BobZ = 52,
	FMin = 1,
	FMax = 3,
	RZMin = 0,
	RZMax = 360,
	RXMin = 0,
	RXMax = 360,
	AMin = 50,
	AMax = 255,
};

local haishin=GetUserPref_Theme("UserHaishin");
local hideFancyElements = ((GetUserPrefB("UserPrefFancyUIBG") and GetUserPrefB("UserPrefFancyUIBG") or true) == false)
local t = Def.ActorFrame{};
if hideFancyElements then return t; end

local tParticleInfo = {}

for i=1,Params.NumParticles do
	tParticleInfo[i] = {
		X = Params.VelocityXMin ~= Params.VelocityXMax and math.random(Params.VelocityXMin, Params.VelocityXMax) or Params.VelocityXMin,
		Y = Params.VelocityYMin ~= Params.VelocityYMax and math.random(Params.VelocityYMin, Params.VelocityYMax) or Params.VelocityYMin,
		Z = Params.VelocityZMin ~= Params.VelocityZMax and math.random(Params.VelocityZMin, Params.VelocityZMax) or Params.VelocityZMin,
		Zoom = math.random(Params.ZoomMin*1000,Params.ZoomMax*1000) / 1000,
		BobZRate = math.random(Params.BobRateZMin*1000,Params.BobRateZMax*1000) / 1000,
		Age = 0,
		F = math.random(Params.FMin,Params.FMax),
		RX = math.random(Params.RXMin,Params.RXMax),
		RZ = math.random(Params.RZMin,Params.RZMax),
		A = math.random(Params.AMin,Params.AMax),
	};
	t[#t+1] = LoadActor( "ptc_"..tParticleInfo[i].F )..{
	Name="Particle"..i;
		InitCommand=function(self)
		self:basezoom(tParticleInfo[i].Zoom);
		self:x(math.random(SCREEN_LEFT+(self:GetWidth()/2),SCREEN_RIGHT-(self:GetWidth()/2)));
		self:y(math.random(SCREEN_TOP+(self:GetHeight()/2),SCREEN_BOTTOM-(self:GetHeight()/2)));
		self:rotationx(tParticleInfo[i].RX);
		self:rotationz(tParticleInfo[i].RZ);
		self:blend('BlendMode_Add');
	end;
		OnCommand=cmd(diffuse,ColorLightTone(color("#00C0FF"));diffusealpha,tParticleInfo[i].A/(206));
	};
end

local function UpdateParticles(self,DeltaTime)
	if haishin=="Off" then
		tParticles = self:GetChildren();
		for i=1, Params.NumParticles do
			local p = tParticles["Particle"..i];
			local vX = tParticleInfo[i].X;
			local vY = tParticleInfo[i].Y;
			local vZ = tParticleInfo[i].Z;
			tParticleInfo[i].Age = tParticleInfo[i].Age + DeltaTime;
			p:x(p:GetX() + (vX * DeltaTime));
			p:y(p:GetY() + (vY * DeltaTime));
			p:z(p:GetZ() + (vZ * DeltaTime));
	--		p:zoom( 1 + math.cos(
	--			(tParticleInfo[i].Age * math.pi*2) 
	--			)	* 0.125 );
			if p:GetX() > SCREEN_RIGHT + (p:GetWidth()/2 - p:GetZ()) then
				p:x(SCREEN_LEFT - (p:GetWidth()/2));
			elseif p:GetX() < SCREEN_LEFT - (p:GetWidth()/2 - p:GetZ()) then
				p:x(SCREEN_RIGHT + (p:GetWidth()/2));
			end
			if p:GetY() > SCREEN_BOTTOM + (p:GetHeight()/2 - p:GetZ()) then
				p:y(SCREEN_TOP - (p:GetHeight()/2));
			elseif p:GetY() < SCREEN_TOP - (p:GetHeight()/2 - p:GetZ()) then
				p:y(SCREEN_BOTTOM + (p:GetHeight()/2));
			end
		end;
	end;
end;

t.InitCommand = cmd(fov,90;SetUpdateFunction,UpdateParticles);

return t;
