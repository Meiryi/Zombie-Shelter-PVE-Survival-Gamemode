AddCSLuaFile("shared.lua")
include('shared.lua')

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Model = {"models/cso_zbs/monsters/boomer_zombi_host.mdl"}
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_GROUND

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackDistance = 32
ENT.MeleeAttackDamageDistance = 85
ENT.MeleeAttackDamageAngleRadius = 100
ENT.MeleeAttackDamage = 10
ENT.FootStepTimeWalk = 0.5
ENT.HasDeathRagdoll = false
ENT.HasDeathAnimation = false
ENT.HasExtraMeleeAttackSounds = true
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
ENT.DeathAnimationTime = 0.1
ENT.GibOnDeathDamagesTable = {"All"}
ENT.NextMeleeAttackTime = 1


	-- ====== Control Variables ====== --
ENT.FindEnemy_UseSphere = false
ENT.FindEnemy_CanSeeThroughWalls = false

	-- ====== Bleed & Blood Variables ====== --
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "Red"
ENT.HasBloodParticle = true
ENT.HasBloodDecal = false
ENT.HasBloodPool = true
ENT.BloodPoolSize = "Normal"

	-- ====== Movement & Idle Variables ====== --
ENT.AnimTbl_IdleStand = {ACT_IDLE}
ENT.AnimTbl_Walk = {ACT_WALK}
ENT.AnimTbl_Run = {ACT_RUN}

	-- ====== Run Away On Unknown Damage Variables ====== --
ENT.RunAwayOnUnknownDamage = true
ENT.NextRunAwayOnDamageTime = 0

	-- ====== Sound File Paths ====== --
ENT.SoundTbl_MeleeAttackExtra = {"zshelter/zombies/hit1.wav","zshelter/zombies/hit2.wav","zshelter/zombies/hit3.wav"}
ENT.SoundTbl_Death = {"zshelter/zombies/zbs_death_1.wav"}

ENT.FootStepSoundLevel = 75
ENT.DeathSoundPitch1 = 100
ENT.IsRun = false
ENT.IsWalk = false

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()

	self:SetCollisionBounds(Vector(12, 12, 65), Vector(-12, -12, 0))
end

function ENT:CustomOnThink()
	if self.AnimTbl_Run then
		self.IsRun = true
	elseif self.AnimTbl_Walk then
		self.IsWalk = true
	end
end

function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	--util.BlastDamage(self, self, self:GetPos(), 170, 90)
	local dmg = 45 * (1 + ((GetConVar("zshelter_difficulty"):GetInt() - 1) * 0.055))
	local spos, up = self:GetPos(), Vector(0, 0, 10)
	local silenced = self:GetNWFloat("SilencedTime", 0) > CurTime()
	if(!silenced) then
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 170)) do
			if(v:IsPlayer()) then
				local vel = ((v:GetPos() + up) - spos)
				vel:Normalize()
				vel.z = math.min(vel.z, 0.25)
				v:SetVelocity(vel * 900)
				v:TakeDamage(30, self, self)
				continue
			end
			if(!v.IsBuilding) then continue end
			if(v.IsTrap) then
				ZShelter.ApplyDamageFast(v, 8, true, true)
			else
				ZShelter.ApplyDamageFast(v, dmg, true)
			end
		end
	end
	self:DropEf(silenced)
end

function ENT:DropEf(silenced)
	if self:IsValid() == true then 
		local ef = ents.Create("ef_zbs_boomer")
			ef:SetPos(self:GetPos())
			ef:SetAngles(self:GetAngles())
			ef:Spawn()
			ef:Activate()
		if(silenced) then return end
		local ef2 = ents.Create("obj_boomer_sprite")
			ef2:SetPos(self:GetPos())
			ef2:Spawn()
	end
end

function ENT:MultipleMeleeAttacks()
	if self.AnimTbl_Run[1] == ACT_RUN then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
	else
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2}
	end
	self.TimeUntilMeleeAttackDamage = 0.1
end