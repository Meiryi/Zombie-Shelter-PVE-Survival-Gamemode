AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/vj_hlr/hl1/osprey_blkops.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
	end
	self:AddEFlags(EFL_IN_SKYBOX)
	self:SetNoDraw(false)
end

ENT.NextPlaySD = 0
ENT.ReleasedAirdrop = false
function ENT:Think()
	if(self.NextPlaySD < CurTime()) then
		self:StopSound("npc/attack_helicopter/aheli_rotor_loop1.wav")
		self:EmitSound("npc/attack_helicopter/aheli_rotor_loop1.wav", SNDLVL_180dB, 100, 20)
		self.NextPlaySD = CurTime() + 0.5
	end
	local forward = self:GetAngles():Forward() * (768 * FrameTime())
	self:SetPos(self:GetPos() + forward)
	--[[
		ent.destination = destination
		ent.actualPosition = pos
	]]
	if(!self.ReleasedAirdrop && self:GetPos():Distance(self.destination) < 64) then
		local ent = ents.Create("obj_resource_airdrop")
		ent:SetPos(self.destination)
		ent:Spawn()
		ent.actualPosition = self.actualPosition - Vector(0, 0, 5)
		self.ReleasedAirdrop = true
	end
	if(!self:IsInWorld() && self.ReleasedAirdrop) then
		self:Remove()
	end
	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	self:StopSound("npc/attack_helicopter/aheli_rotor_loop1.wav")
end