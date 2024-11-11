
-- Copyright (c) 2018 TFA Base Devs

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	local mdl = self:GetModel()

	if not mdl or mdl == "" or string.find(mdl, "error") then
		self:SetModel("models/weapons/tfa_cso/w_tknifeex2.mdl")
	end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	util.SpriteTrail(self, 0, Color(255,255,255), false, 3, 0.1, 0.3, 0.125, "trails/smoke.vmt")
	local phys = self:GetPhysicsObject()
	self:NextThink(CurTime() + 1)

	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(1)
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
	end

	self.DestroyTime = CurTime() + 3
end

function ENT:Think()
	if CurTime() > self.DestroyTime then
		self:Remove()
	end
end

ENT.NextSound = 0
ENT.CollideCount = false
ENT.LastHitTick = 0
function ENT:PhysicsCollide(data, phys)
	local ent = data.HitEntity
	local hitnormal = data.HitNormal
	local phys = self:GetPhysicsObject()
	if(IsValid(ent) && ent:GetClass() != "zsh_tacticalknife_ex2") then
		if(engine.TickCount() != self.LastHitTick) then -- Prevent double hits
			local dmgboost = 1
			local dmg = 50
			if(IsValid(self.Owner)) then
				local dmginfo = DamageInfo()
					dmginfo:SetDamage(dmg)
					dmginfo:SetAttacker(self.Owner)
					dmginfo:SetInflictor(self.Owner)
					if(self.Owner.Callbacks && self.Owner.Callbacks.OnMeleeDamage) then
						for k,v in pairs(self.Owner.Callbacks.OnMeleeDamage) do
							v(self.Owner, ent, dmginfo, false)
						end
					end
				if(!self.Owner.NextKnifeRegen || self.Owner.NextKnifeRegen < CurTime()) then
					self.Owner:GiveAmmo(1, "pistol", true)
					self.Owner.NextKnifeRegen = CurTime() + 0.5
				end
			end
			ent:TakeDamage(dmg, self.Owner, self.Owner)
			sound.Play("weapons/tfa_cso/kujang/hit"..math.random(1, 2)..".wav", ent:GetPos(), 100, 100, 1)
			self:Remove()
			self.LastHitTick = engine.TickCount()
		end
	else
		if(self.NextSound < CurTime()) then
			self:EmitSound("weapons/tfa_cso/tknife/hitwall.wav", 100, 100, 1)
			self.NextSound = CurTime() + 0.05
		end
		local forward = self:GetVelocity():GetNormalized()
		local dot = hitnormal:Dot(-forward)
		if(dot >= 0.6) then
			self:SetPos(data.HitPos)
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			self:CollisionRulesChanged()
			if(IsValid(phys)) then
				phys:EnableMotion(false)
			end
		else
			if(self.FirstCollide) then
				phys:SetVelocity(phys:GetVelocity() * 0.1)
			end
			self.FirstCollide = true
		end
	end
end