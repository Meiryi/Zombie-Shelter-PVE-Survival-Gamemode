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
	self:SetCollisionBounds(Vector(-16, -16, 0), Vector(16, 16, 16))

	self.PathTester = true
	self.ForceNoCollide = true
	self.NoCollide = true
	self.IgnoreCollision = true
	self.NoShelterCollide = true
	self.OnlyCollideToBarricade = true

	self:SetMoveInterval(0.1)
	self.KillTime = CurTime() + 10
end

local schedule = ai_schedule.New("PathFinder")
	schedule:EngTask("TASK_RUN_PATH", 0)
	schedule:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedule:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)

ENT.MovementFailed = false
function ENT:Think()
	if(self.KillTime <= CurTime()) then
		self:Remove()
	end
	local sh = ZShelter.Shelter
	if(IsValid(sh)) then
		local shPos = sh:GetPos()
		local sePos = self:GetPos()
		local waPos = self:GetCurWaypointPos()
		self:SetLastPosition(shPos)
		if(waPos != Vector(0, 0, 0)) then
			local mins, maxs = self:GetCollisionBounds()
			local tr = {
				start = self:GetPos(),
				endpos = waPos,
				mask = MASK_SHOT,
				filter = self,
			}
			local ret = util.TraceEntityHull(tr, self)
			if(ret.Fraction == 1) then
				self:SetPos(waPos)
			else
				local vel = (waPos - sePos)
				vel:Normalize()
				vel.z = 0
				self:SetMoveVelocity(self:GetMoveVelocity() + vel * 32)
				self:SetLocalVelocity(self:GetMoveVelocity() + vel * 86)
			end
		end
		if(sePos:Distance(shPos) < 128) then
			self:Remove()
		end
	end
	self:NextThink(CurTime() + 0.05)
	return true
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

function ENT:OnTaskFailed(ERRCODE, REASON)
	if(ERRCODE == 11) then -- This should only happen when all paths are blocked
		ZShelter.ShelterUnreachable()
	end
end

function ENT:SelectSchedule()
	self:StartSchedule(schedule)
end