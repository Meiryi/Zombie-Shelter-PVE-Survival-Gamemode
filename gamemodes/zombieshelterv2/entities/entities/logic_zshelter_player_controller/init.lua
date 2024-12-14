AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.IsPathTester = true
local vector000 = Vector(0, 0, 0)

function ENT:Initialize()
	self:SetModel("models/zombie/fast.mdl")
	self:SetModelScale(1)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetSolid(SOLID_BBOX)
	self:AddSolidFlags(FSOLID_NOT_STANDABLE)
	self:SetNavType(NAV_GROUND)
	self:SetMoveType(MOVETYPE_STEP)
	self:SetCollisionGroup(1)

	self:SetCustomCollisionCheck(true)
	self:SetMaxYawSpeed(2048)

	self:SetNPCState(NPC_STATE_ALERT)
	self:CapabilitiesAdd(CAP_MOVE_GROUND)

	self:DrawShadow(false)
	self:SetCollisionBounds(Vector(0, 0, 0), Vector(0, 0, 0))

	self.ForceNoCollide = true
	self.NoCollide = true
	self.IgnoreCollision = true
	self.NoShelterCollide = true
	self.OnlyCollideToBarricade = true
end

function ENT:Think()
	if(!IsValid(self:GetOwner())) then
		self:Remove()
	end
	local owner = self:GetOwner()
	if(!IsValid(owner)) then return end
	self:SetPos(owner:GetPos())
	local waypoint = self:GetCurWaypointPos()
	local goal = self:GetGoalPos()
	if(waypoint != self.LastWayPoint && waypoint != vector000 && goal != vector000) then
		ZShelter.SyncWaypoint(owner, waypoint)
		self.LastWayPoint = waypoint
	end

	self:NextThink(CurTime() + 0.15)
	return true
end

function ENT:SelectSchedule()
	return
end

function ENT:OverrideMove()
	local waypoint = self:GetCurWaypointPos()
	local owner = self:GetOwner()
	if(waypoint == vector000) then return end

end