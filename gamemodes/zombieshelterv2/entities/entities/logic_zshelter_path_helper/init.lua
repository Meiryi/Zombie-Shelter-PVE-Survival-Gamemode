AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.IsPathTester = true

function ENT:Initialize()
	self:SetModel("models/zombie/fast.mdl")
	self:SetModelScale(1)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetSolid(SOLID_BBOX)
	self:AddSolidFlags(FSOLID_NOT_STANDABLE)
	self:SetNavType(NAV_GROUND)
	self:SetMoveType(MOVETYPE_STEP)
	self:SetCollisionGroup(2)

	self:SetCustomCollisionCheck(true)
	self:SetMaxYawSpeed(2048)

	self:SetNPCState(NPC_STATE_ALERT)
	self:CapabilitiesAdd(CAP_MOVE_GROUND)

	self:DrawShadow(false)
	self:SetCollisionBounds(Vector(0, 0, 0), Vector(0, 0, 0))

	self.PathHelper = true

	self:SetMoveInterval(0.05)
end

local schedule = ai_schedule.New("PathFinder")
	schedule:EngTask("TASK_RUN_PATH", 0)
	schedule:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedule:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)

ENT.LastFollowTarget = 0
function ENT:TraceVisible(target)
	return util.TraceLine({
		start = self:GetPos() + self:OBBCenter(),
		endpos = target:GetPos() + target:OBBCenter(),
		filter = function(ent)
			if(ent == self || ent == target || ent == self:GetOwner()) then
				return false
			else
				if(ent.IsPlayerBarricade) then
					return true
				end
			end
		end,
		mask = MASK_SHOT
	}).Fraction == 1
end

ENT.LastFollowTarget = nil
function ENT:GoTo(pos, target)
	self:NavSetGoalPos(pos)
	self:StartSchedule(schedule)
	self:SetLastPosition(pos, target)
end

function ENT:Think()
	local owner = self:GetOwner()
	if(!IsValid(owner)) then
		self:Remove()
		return
	end
	self:NextThink(CurTime() + 0.05)
	return true
end

ENT.LastWaypoint = nil
ENT.WaitForOwner = false
local vec_zero = Vector(0, 0, 0)
function ENT:OverrideMove(interval)
	local owner = self:GetOwner()
	local waypoint = self:GetCurWaypointPos()
	if(!IsValid(owner) || waypoint == vec_zero) then return end
	if(!self.LastWaypoint || self.LastWaypoint != waypoint) then
		if(self.LastWaypoint != nil) then
			self.WaitForOwner = true
		end
		self.LastWaypoint = waypoint
	end
	local dst2 = self:GetPos():Distance(waypoint)
	self:SetPos(owner:GetPos())
	if(dst2 < 8) then
		self:SetPos(waypoint)
	end
end

--[[
	enum AI_BaseTaskFailureCodes_t
	{
		NO_TASK_FAILURE, 							// 0
		FAIL_NO_TARGET, 								// 1
		FAIL_WEAPON_OWNED, 					// 2
		FAIL_ITEM_NO_FIND, 						// 3
		FAIL_NO_HINT_NODE,						// 4
		FAIL_SCHEDULE_NOT_FOUND,		// 5
		FAIL_NO_ENEMY,		 						// 6
		FAIL_NO_BACKAWAY_NODE, 			// 7
		FAIL_NO_COVER,								// 8
		FAIL_NO_FLANK,									// 9
		FAIL_NO_SHOOT,								// 10
		FAIL_NO_ROUTE,								// 11
		FAIL_NO_ROUTE_GOAL,					// 12
		FAIL_NO_ROUTE_BLOCKED,			// 13
		FAIL_NO_ROUTE_ILLEGAL,				// 14
		FAIL_NO_WALK,									// 15
		FAIL_ALREADY_LOCKED,					// 16
		FAIL_NO_SOUND,								// 17
		FAIL_NO_SCENT,									// 18
		FAIL_BAD_ACTIVITY,							// 19
		FAIL_NO_GOAL,									// 20
		FAIL_NO_PLAYER,								// 21
		FAIL_NO_REACHABLE_NODE,			// 22
		FAIL_NO_AI_NETWORK,					// 23
		FAIL_BAD_POSITION,							// 24
		FAIL_BAD_PATH_GOAL,					// 25
		FAIL_STUCK_ONTOP,							// 26
		FAIL_ITEM_TAKEN,								// 27

		NUM_FAIL_CODES,								// 28?
	};
]]

function ENT:SelectSchedule()
	return
end