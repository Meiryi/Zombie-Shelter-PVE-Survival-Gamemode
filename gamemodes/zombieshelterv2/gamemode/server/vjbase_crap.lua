--[[
	EN :
	Zombie Shelter v2.0 by Meiryi / Meika / Shiro / Shigure
	You SHOULD NOT edit / modify / reupload the codes, it includes editing gamemode's name
	If you have any problems, feel free to contact me on steam, thank you for reading this

	ZH-TW :
	夜襲生存戰 v2.0 by Meiryi  / Meika / Shiro / Shigure
	任何的修改是不被允許的 (包括模式的名稱)，有問題請在Steam上聯絡我, 謝謝!
	
	ZH-CN :
	昼夜求生 v2.0 by Meiryi  / Meika / Shiro / Shigure
	任何形式的编辑是不被允许的 (包括模式的名称), 若有问题请在Steam上联络我
]]

VJ_ATTACK_STATE_NONE			= 0 -- No attack state is set | DEFAULT
VJ_ATTACK_STATE_DONE			= 1 -- Current attack has been executed completely and is marked as done
VJ_ATTACK_STATE_STARTED			= 2 -- Current attack has started and is expected to execute soon
VJ_ATTACK_STATE_EXECUTED		= 3 -- Current attack has been executed at least once
VJ_ATTACK_STATE_EXECUTED_HIT	= 4 -- Current attack has been executed at least once AND hit an entity at least once (Melee & Leap attacks)

function _VJPICK(values)
	if istable(values) then
		return values[math.random(1, #values)] or false
	end
	return values or false
end

local vecZ500 = Vector(0, 0, 500)
local vecZ4 = Vector(0, 0, 4)

function VJ_MeleeAttackCode(self, isPropAttack) -- Note : Remove ability to hit multiple enemies

end

function VJ_PriorToKilled(self, dmginfo, hitgroup) -- Remove dead body if they are inside of a prop, so they don't fuck with collision group
	self:CustomOnInitialKilled(dmginfo, hitgroup)
	local dmgInflictor = dmginfo:GetInflictor()
	local dmgAttacker = dmginfo:GetAttacker()

	local function DoKilled()
		if IsValid(self) then
			hook.Run("OnNPCKilled", self, dmgAttacker, dmgInflictor)
			if self.WaitBeforeDeathTime == 0 then
				self:OnKilled(dmginfo, hitgroup)
			else
				timer.Simple(self.WaitBeforeDeathTime, function()
					if IsValid(self) then
						self:OnKilled(dmginfo, hitgroup)
					end
				end)
			end
		end
	end

	self:SetHealth(0)

	self.Dead = true
	self:RemoveTimers()
	self.AttackType = VJ_ATTACK_TYPE_NONE
	self.MeleeAttacking = false
	self.RangeAttacking = false
	self.LeapAttacking = false
	self.HasMeleeAttack = false
	self.HasRangeAttack = false
	self.HasLeapAttack = false
	self:StopAllCommonSounds()

	self:CustomOnPriorToKilled(dmginfo, hitgroup)
	self:SetCollisionGroup(1)
	self:RunGibOnDeathCode(dmginfo, hitgroup)
	self:PlaySoundSystem("Death")

	local mins, maxs = self:GetCollisionBounds()
	local tr = {
		start = self:GetPos(),
		endpos = self:GetPos(),
		mask = MASK_SHOT,
		collisiongroup = COLLISION_GROUP_NPC_SCRIPTED,
		filter = self,
	}
	local ret = util.TraceHull(tr)
	if(IsValid(ret.Entity) && ZShelter_IsProp(ret.Entity:GetClass())) then
		DoKilled()
		return
	end

	if self.HasDeathAnimation == true && !dmginfo:IsDamageType(DMG_REMOVENORAGDOLL) && self:GetNavType() != NAV_CLIMB then
		if IsValid(dmgInflictor) && dmgInflictor:GetClass() == "prop_combine_ball" then DoKilled() return end
		if GetConVar("vj_npc_nodeathanimation"):GetInt() == 0 && !dmginfo:IsDamageType(DMG_DISSOLVE) then

			-- Fuck VJ Base

			self:SetCollisionGroup(10)
			local phys = self:GetPhysicsObject()
			if(IsValid(phys)) then
				phys:EnableCollisions(false)
			end

			self:RemoveAllGestures()
			self:CustomDeathAnimationCode(dmginfo, hitgroup)
			local chosenAnim = _VJPICK(self.AnimTbl_Death)
			local animTime = self:DecideAnimationLength(chosenAnim, self.DeathAnimationTime) - self.DeathAnimationDecreaseLengthAmount
			self:VJ_ACT_PLAYACTIVITY(chosenAnim, true, animTime, false, 0, {PlayBackRateCalculated=true})
			self.DeathAnimationCodeRan = true
			timer.Simple(animTime, DoKilled)
		else
			DoKilled()
		end
	else
		DoKilled()
	end
end