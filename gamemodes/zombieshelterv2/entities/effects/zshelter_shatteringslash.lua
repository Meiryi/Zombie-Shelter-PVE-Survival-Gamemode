local materials = {
    Material("sprites/flamelet1"),
    Material("sprites/flamelet2"),
    Material("sprites/flamelet3"),
    Material("sprites/flamelet4"),
    Material("sprites/flamelet5")
}

function EFFECT:Init(effect_data)
    local pos = effect_data:GetOrigin()
    local ent = effect_data:GetEntity()

    self.Angle = angle_zero

    if(IsValid(ent)) then
        self.Angle = ent:EyeAngles()
    end

    self.Origin = pos + self.Angle:Forward() * 64

    self.Cycle = 0.2
    self.CycleTime = SysTime() + self.Cycle
    self.YawAngle = 60
    self.StartAngle = self.Angle.y + self.YawAngle / 2
end

local left = Angle(0, 90, 0)
function EFFECT:Think()

        local fraction = math.Clamp((self.CycleTime - SysTime()) / self.Cycle, 0, 1)
        local yaw = self.YawAngle * fraction

        local emitter = ParticleEmitter(self.Origin)
        local smoke
        local ang = Angle(self.Angle.x, self.StartAngle - yaw, self.Angle.z)

        local start = self.Origin + ang:Forward() * 80

        local normal = ang:Forward()
        local vel = (ang + left):Forward()
        local offset = normal * 600

        for i = 1, 12 do
            local vec = start + offset * math.Rand(0, 1)

            smoke = emitter:Add("effects/energysplash", start)
            smoke:SetPos(vec)
            smoke:SetVelocity(VectorRand() * 128)
            smoke:SetDieTime(math.Rand(0.1, 0.2))
            smoke:SetStartAlpha(255)
            smoke:SetEndAlpha(0)
            smoke:SetStartSize(10)
            smoke:SetEndSize(1)
            smoke:SetRoll(math.Rand(-180, 180))
            smoke:SetRollDelta(math.Rand(-0.2,0.2))
            smoke:SetColor(255, 90, 0)
            smoke:SetAirResistance(1000)
            smoke:SetBounce(0)

            smoke = emitter:Add(materials[math.random(1, 5)], start)
            smoke:SetPos(vec)
            smoke:SetVelocity(vel * math.random(256, 512))
            smoke:SetDieTime(math.Rand(0.25, 0.3))
            smoke:SetStartAlpha(255)
            smoke:SetEndAlpha(0)
            smoke:SetStartSize(math.random(8, 16))
            smoke:SetEndSize(1)
            smoke:SetRoll(math.Rand(-180, 180))
            smoke:SetRollDelta(math.Rand(-1.5, 1.5))
            smoke:SetColor(255, 255, 255)
            smoke:SetBounce(0)
        end

        emitter:Finish()

    return self.CycleTime > SysTime()
end

function EFFECT:Render()
    return
end