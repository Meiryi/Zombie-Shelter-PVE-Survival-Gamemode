AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/cso_zbs/monsters/zombi_origin.mdl"
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
ENT.AnimTbl_IdleStand = {ACT_IDLE}
ENT.AnimTbl_Walk = {ACT_WALK}
ENT.AnimTbl_Run = {ACT_RUN}

ENT.Health = 150

ENT.SoundTbl_MeleeAttackExtra = {"zshelter/zombies/hit1.wav","zshelter/zombies/hit2.wav","zshelter/zombies/hit3.wav"}
ENT.SoundTbl_Death = {"zshelter/zombies/zbs_death_1.wav"}

ENT.Dead = false

ENT.Running = true
ENT.TargetEnemy = nil
ENT.NextFindEnemyTime = 0
ENT.DeathAnimationTime = 3

ENT.GetPathTime = 0

local schedule = ai_schedule.New("PathFinder")
	schedule:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	schedule:EngTask("TASK_RUN_PATH", 0)
	schedule:EngTask("TASK_FACE_TARGET", 0)

	schedule.CanBeInterrupted = true

local sch_findenemy = ai_schedule.New("GetPathToEnemy")
	sch_findenemy:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)

local sch_walktoenemy = ai_schedule.New("WalkPathToEnemy")
	sch_walktoenemy:EngTask("TASK_WALK_PATH", 0)

local sch_runtoenemy = ai_schedule.New("RunPathToEnemy")
	sch_runtoenemy:EngTask("TASK_RUN_PATH", 0)
	sch_runtoenemy:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)

local vec000 = Vector(0, 0, 0)
local function isenemy(ent)
	return !ent:IsPlayer() && !ent.IsTurret
end

function ENT:CustomOnInitialize() end

function ENT:RunSequence(act)
	local seq = self:SelectWeightedSequence(act)
	self:ResetSequence(seq)
	self:ResetSequenceInfo()
	self:SetCycle(0)
end

function ENT:FindEnemy()
	local dst = -1
	local pos = self:GetPos()
	local enemy = nil
	for _, ent in ipairs(ents.GetAll()) do
		if(isenemy(ent)) then continue end
		local _dst = ent:GetPos():Distance(pos)
		if(dst == -1) then
			dst = _dst
			enemy = ent
		else
			if(_dst < dst) then
				dst = _dst
				enemy = ent
			end
		end
	end
	if(IsValid(enemy)) then
		self:SetEnemy(enemy)
		self:SetLastPosition(enemy:GetPos())
	end
end

function ENT:PickElem(t)
	if(istable(t)) then
		return t[math.random(1, #t)]
	else
		return t
	end
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_STEP)
	self:SetNavType(NAV_GROUND)
	self:PhysicsInit(SOLID_BBOX)
	self:SetSolid(SOLID_BBOX)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetSolid(SOLID_BBOX)
	self:AddSolidFlags(FSOLID_NOT_STANDABLE)
	self:SetNavType(NAV_GROUND)
	self:SetMoveType(MOVETYPE_STEP)
	self:SetMaxYawSpeed(2048)
	self:SetNPCState(NPC_STATE_ALERT)
	self:CapabilitiesAdd(CAP_MOVE_GROUND)
	self:SetCollisionBounds(Vector(-16, -16, 0), Vector(16, 16, 76))
	self:CustomOnInitialize()
end

function ENT:SelectSchedule()
	if(self.Dead) then return end
	if(IsValid(self:GetEnemy())) then
		self:SetLastPosition(self:GetEnemy():GetPos())
	end
	self:StartSchedule(schedule)
--[[
	if(IsValid(self:GetEnemy())) then
		if(self.GetPathTime < CurTime()) then
			if(self:GetCurWaypointPos() == vec000) then
				
			else
				self:StartSchedule(sch_runtoenemy)
			end
			print(self:GetCurWaypointPos())
			self.GetPathTime = CurTime() + 1
		end
	end
]]
end

function ENT:Think()
	if(self.Dead) then return end
	if(self.NextFindEnemyTime < CurTime()) then
		self:FindEnemy()
		self.NextFindEnemyTime = CurTime() + 1.5
	end
end

function ENT:DoKilled()
	local anim = self:PickElem(self.AnimTbl_Death)
	self:SetCollisionGroup(10)
	self:SetHealth(-1)
	self:StopMoving()
	self.Dead = true
	if(anim) then
		self:RunSequence(anim)
	end
	VJ_EmitSound(self, self.SoundTbl_Death, 100, 100)
	timer.Simple(self.DeathAnimationTime || 1, function()
		if(!IsValid(self)) then return end
		self:Remove()
	end)
end

function ENT:OnTakeDamage(dmginfo)
	if(self.Dead) then return end
	local hp = self:Health()
	local damage = dmginfo:GetDamage()
	if(hp < damage) then
		self:DoKilled()
	else
		self:SetHealth(hp - damage)
	end
end