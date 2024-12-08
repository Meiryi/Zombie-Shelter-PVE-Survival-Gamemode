SWEP.Base = "tfa_zsh_melee_base"
SWEP.Category = "TFA CS:O Melees"
SWEP.PrintName = "Miracle Prism Sword"
SWEP.Author				= "Kamikaze" --Author Tooltip
SWEP.Type	= "Unique grade melee weapon"
SWEP.ViewModel = "models/weapons/tfa_cso/c_magicknife.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_magicknife.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 85
SWEP.UseHands = true
SWEP.HoldType = "melee2"
SWEP.DrawCrosshair = true
SWEP.Primary.Knockback = 0 

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

--[[INSPECTION]]--
SWEP.InspectPos = Vector(0, 0, 0)
SWEP.InspectAng = Vector(0, 0, 0)

SWEP.DisableIdleAnimations = false
SWEP.ProceduralHolsterTime = 0
SWEP.Secondary.CanBash = false

-- nZombies Stuff
SWEP.NZWonderWeapon		= true	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Magic Slayer"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualsword"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.
SWEP.PaPMats			= {}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.BuildSpeed = 30
SWEP.OldStyleHit = true

SWEP.AOEDamage = true
SWEP.AOERange_Primary = 24
SWEP.AOERange_Secondary = 48

SWEP.Offset = {
		Pos = {
		Up = -8,
		Right = 1,
		Forward = 5,
		},
		Ang = {
		Up = -20,
		Right = 190,
		Forward = -5
		},
		Scale = 1
}

sound.Add({
	['name'] = "PrismSword.Charge_Start",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/magicknife/charge_start.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "PrismSword.Charge_Idle1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/magicknife/charge_idle1.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "PrismSword.Charge_Idle2",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/magicknife/charge_idle2.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "PrismSword.Charge_Finish",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/magicknife/charge_finish.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "PrismSword.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/magicknife/draw.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "PrismSword.ChargeAttack2",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/magicknife/charge_attack2.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "PrismSword.SlashEnd",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/magicknife/slash_end.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "PrismSword.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/magicknife/slash1.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "PrismSword.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/magicknife/slash2.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "PrismSword.Slash3",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/magicknife/slash3.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "PrismSword.Slash4",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/magicknife/slash4.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "PrismSword.HitFleshSlash",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/magicknife/hit.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "PrismSword.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/magicknife/wall.wav" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PULLBACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 150, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-180,0,65), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 130, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.35, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "PrismSword.HitFleshSlash",
		['hitworld'] = "PrismSword.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 150, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(180,0,65), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 140, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.35, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "PrismSword.HitFleshSlash",
		['hitworld'] = "PrismSword.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 150, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-120,0,-130), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 150, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.35, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "PrismSword.HitFleshSlash",
		['hitworld'] = "PrismSword.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 150, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(100,0,-120), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 160, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.35, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "PrismSword.HitFleshSlash",
		['hitworld'] = "PrismSword.HitWall",
		['maxhits'] = 25
	},
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 26*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-180,0,55), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 3000, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 1.1, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 1.1,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 2.6, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "PrismSword.HitFleshSlash",
		['hitworld'] = "PrismSword.HitWall",
		['maxhits'] = 25
	}
}

SWEP.InspectionActions = {ACT_VM_RECOIL1}

DEFINE_BASECLASS(SWEP.Base)
function SWEP:Holster( ... )
	self:StopSound("Hellfire.Idle")
	return BaseClass.Holster(self,...)
end
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_magicknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end

function SWEP:SecondaryAttack()
	return
end

SWEP.NextSDTime = 0
SWEP.SlashDamage = 150
function SWEP:ChargedThink()
	if(CLIENT) then return end
	local hastarget = false
	local playsd = self.NextSDTime < CurTime()
	local index = self.Owner:EntIndex()
	for _, ent in ipairs(ents.FindInSphere(self.Owner:GetPos(), 400)) do
		if((!ent:IsNPC() && !ent:IsPlayer() && !ent:IsNextBot()) || ent:Health() <= 0 || ent == self.Owner) then continue end
		if(playsd) then
			sound.Play("weapons/tfa_cso/magicknife/magic_start.wav", ent:GetPos(), 70, 100, 1)
		end
		local k = index.."miracle_prism_exp"
		if(!IsValid(ent[k])) then
			local e = ents.Create("zsh_sprite_miracle_prism")
				e:Spawn()
				e:SetPos(ent:GetPos())
				e:SetOwner(ent)
				e.Creator = self.Owner
				e.Damage = self.SlashDamage
				e._Inflictor = self
				e.StartTime = CurTime()
				e.KillTime = CurTime() + 0.25
			ent[k] = e
		else
			local e = ent[k]
			if(e.KillAnim) then
				ent[k] = nil
				continue
			end
			e.KillTime = CurTime() + 0.25
		end
		hastarget = true
	end
	if(hastarget && self.NextSDTime < CurTime()) then
		self.NextSDTime = CurTime() + 1
	end
end

SWEP.MinimumTimeRequired = 1
function SWEP:Slash(charged)
	if(!charged || CLIENT) then return end
	local owner = self.Owner
	timer.Simple(0.1, function()
		if(!IsValid(owner)) then return end
		for _, ent in ipairs(ents.FindByClass("zsh_sprite_miracle_prism")) do
			if(CurTime() - (ent.StartTime || CurTime()) < self.MinimumTimeRequired) then
				ent:End()
			else
				ent:Slash()
			end
		end
	end)
end

SWEP.__KeyDown = false
SWEP.StartChargeTime = 0
SWEP.NextChargeTime = 0
SWEP.NextSD = 0
SWEP.StartPlaySD = false
SWEP.FullyCharged = false
function SWEP:Think2(...)
	if(SERVER || ((CLIENT || game.SinglePlayer()) && IsFirstTimePredicted())) then
		local keydown = self.Owner:KeyDown(IN_ATTACK2)

		if(self.NextChargeTime > CurTime() || self:GetStatus() == 1) then
			keydown = false
		end
		local vm = self.Owner:GetViewModel()
		if(keydown) then
			self.Melee2Attack = true
			local t = CurTime() - self.StartChargeTime
			if(t <= 0.6) then
				vm:SetSequence(13)
			else
				if(!self.StartPlaySD) then
					self:EmitSound("weapons/tfa_cso/magicknife/charge_start.wav")
					self.StartPlaySD = true
				end
				if(t <= 2.25) then
					vm:SetSequence(9)
				else
					if(!self.FullyCharged) then
						self:EmitSound("weapons/tfa_cso/magicknife/charge_finish.wav")
						self.NextSD = CurTime() + 0.65
					end
					if(self.NextSD < CurTime()) then
						self:EmitSound("weapons/tfa_cso/magicknife/charge_idle1.wav")
						self.NextSD = CurTime() + 0.5
					end
					vm:SetSequence(10)
					self:ChargedThink()
					self.FullyCharged = true
				end
			end
			CSO:SetNextActionTimeIdle(self, 0.25)
		else
			if(self.__KeyDown) then
				self.NextChargeTime = CurTime() + 1.75
				CSO:SetNextActionTimeIdle(self, 1.75)
				if(self.FullyCharged) then
					vm:SetSequence(12)
					self:EmitSound("weapons/tfa_cso/magicknife/charge_attack2.wav")
				else
					vm:SetSequence(11)
					self:EmitSound("weapons/tfa_cso/magicknife/slash"..math.random(1, 4)..".wav")
				end
				self:Slash(self.FullyCharged)
				self:Strike({
					['act'] = ACT_VM_PULLBACK,
					['len'] = 180,
					['dir'] = Vector(-180,0,65),
					['dmg'] = 350,
					['force'] = 150,
					['dmgtype'] = DMG_SLASH,
					['delay'] = 0.03,
					['spr'] = true,
					['snd'] = "TFABaseMelee.Null",
					['snd_delay'] = 0.035,
					["viewpunch"] = Angle(0,0,0),
					['end'] = 0.35,
					['hull'] = 32,
					['direction'] = "F",
					['hitflesh'] = "PrismSword.HitFleshSlash",
					['hitworld'] = "PrismSword.HitWall",
					['maxhits'] = 25
				}, 12)
				self.Owner:SetAnimation(PLAYER_ATTACK1)
			end
			self.StartPlaySD = false
			self.FullyCharged = false
			self.StartChargeTime = CurTime()
		end

		self.__KeyDown = keydown

		BaseClass.Think2(self, ...)
	end
end

function SWEP:PostAttack()
	if(self.Melee2Attack) then
		self.NextChargeTime = CurTime() + 1.5
	else
		self.NextChargeTime = CurTime() + 1
	end
end

function SWEP:Holster(...)
	return true
end

function SWEP:Deploy(...)
	self.StartChargeTime = CurTime()
	BaseClass.Deploy(self, ...)
end

function SWEP:SetupDataTables(...)
    local retVal = BaseClass.SetupDataTables(self, ...)
    self:NetworkVarTFA("Int", "LastPrimaryAttackChoice") -- self:GetLastPrimaryAttackChoice() and self:SetLastPrimaryAttackChoice(number)
    self:NetworkVarTFA("Int", "LastSecondaryAttackChoice") -- self:GetLastSecondaryAttackChoice() and self:SetLastSecondaryAttackChoice(number)
    return retVal
end

function SWEP:ChoosePrimaryAttack()
    local attacks = self:GetStatL("Primary.Attacks") -- getting the SWEP.Primary.Attacks table

    local lastattack = self:GetLastPrimaryAttackChoice() -- default value is 0 so it'll start with 1 from next line

    local nextattack = lastattack + 1 -- choosing the next attack
    --if nextattack > 4 or self:GetComboCount() <= 0 then -- use this if you want choice to start from 1 when leaving mouse key (combo reset), otherwise do self:SetLastPrimaryAttackChoice(0) either in SWEP:Deploy() or SWEP:Holster()
    --   nextattack = 1
	--end
    if nextattack > 4 then -- reset the count if we're going beyond attacks count
        nextattack = 1
    end

    self:SetLastPrimaryAttackChoice(nextattack) -- remembering the current choice for next time
    return nextattack, attacks[nextattack] -- returning the key of SWEP.Primary.Attacks table and the chosen attack table itself
end