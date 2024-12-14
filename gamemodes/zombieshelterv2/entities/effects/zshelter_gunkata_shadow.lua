EFFECT.StayTime = 0.4
function EFFECT:Init(data)
	self.Owner = data:GetEntity()
	self.KillTime = 0
	if(!IsValid(self.Owner) || (self.Owner == LocalPlayer() && !LocalPlayer():ShouldDrawLocalPlayer())) then return end

	self.Origin = self.Owner:GetPos() + Vector(0, 0, 0)
	self:SetPos(self.Origin)
	self.VFXModel = ClientsideModel(self.Owner:GetModel(), RENDERGROUP_TRANSLUCENT)
	self.VFXModel:SetNoDraw(true)
	self.VFXModel:SetPos(self.Origin)
	self.VFXModel:SetMaterial("models/debug/debugwhite")
	self.VFXModel:SetColor(Color(0, 0, 0, 255))

	self.Cycle = self.Owner:GetCycle()
	self.Sequence = self.Owner:GetSequence()
	self.Angles = self.Owner:EyeAngles()
	self.Angle = Angle(0, self.Angles.y, 0)

	self.VFXModel:SetCycle(self.Cycle)

	self.VFXModel:SetSequence(self.Sequence)	
	self.VFXModel:SetAngles(self.Angle)

    for i = 0, self.Owner:GetNumPoseParameters() - 1 do
        local flMin, flMax = self.Owner:GetPoseParameterRange(i)
        local sPose = self.Owner:GetPoseParameterName(i)
        self.VFXModel:SetPoseParameter(sPose, math.Remap(self.Owner:GetPoseParameter(sPose), 0, 1, flMin, flMax))
    end

    self.VFXModel:SetPoseParameter("aim_yaw", 0)

	self.KillTime = CurTime() + self.StayTime
end

EFFECT.VFXModel = nil
function EFFECT:Think()
	local remove = self.KillTime > CurTime()
	if(!remove && IsValid(self.VFXModel)) then
		self.VFXModel:Remove()
	end
	return remove
end

function EFFECT:Render()
	if(!IsValid(self.Owner) || self.KillTime < CurTime()) then return end
	render.SetBlend((self.KillTime - CurTime()) / self.StayTime)
	render.SetColorModulation(0, 0, 0)

	self.VFXModel:DrawModel()

	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)
end