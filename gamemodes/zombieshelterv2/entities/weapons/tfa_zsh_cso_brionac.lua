SWEP.Base = "tfa_melee_base"
SWEP.Category = "#zshelter.category.melee"
SWEP.PrintName = "#zshelter.weapon.brionac"
SWEP.Author	= "Kamikaze" --Author Tooltip
SWEP.Type	= "#zshelter.type.melee"
SWEP.ViewModel = "models/weapons/tfa_cso/c_brionac.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_katana.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 85
SWEP.UseHands = true
SWEP.HoldType = "melee"
SWEP.DrawCrosshair = true

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.DisableIdleAnimations = false
SWEP.ProceduralHolsterTime = 0
SWEP.Secondary.CanBash = false

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Godness of Spear"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualsword"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.
SWEP.PaPMats			= {}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.WElements = {
	["katana_a"] = { type = "Model", model = "models/weapons/tfa_cso/w_katana.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4, 0.5, 7.50), angle = Angle(0, -20, 175), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Offset = {
		Pos = {
		Up = -7.5,
		Right = 2.5,
		Forward = 4,
		},
		Ang = {
		Up = -150,
		Right = 0,
		Forward = 10
		},
		Scale = 1
}

sound.Add({
	['name'] = "Brionac.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/brionac/draw.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Brionac.Attack1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/brionac/attack1.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Brionac.Attack2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/brionac/attack2.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Brionac.Attack3",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/brionac/attack3.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Brionac.Attack4",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/brionac/attack4.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Brionac.Charging_Start",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/brionac/charging_start.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Brionac.Charging_End",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/brionac/charging_end.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Brionac.End_Shoot",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/brionac/end_shoot.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Brionac.Idle",
	['channel'] = CHAN_AUTO,
	['sound'] = { "weapons/tfa_cso/brionac/idle.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Brionac.Idle2",
	['channel'] = CHAN_AUTO,
	['sound'] = { "weapons/tfa_cso/brionac/idle2.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Brionac.Idle2_2",
	['channel'] = CHAN_AUTO,
	['sound'] = { "weapons/tfa_cso/brionac/idle2_2.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Brionac.Throw",
	['channel'] = CHAN_AUTO,
	['sound'] = { "weapons/tfa_cso/brionac/throw.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualKatana.HitFleshSlash1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dualkatana/hit1.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualKatana.HitFleshSlash2",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dualkatana/hit2.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualKatana.HitFleshStab",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dualkatana/stab_hit.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualKatana.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dualkatana/wall.wav" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 250, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 875, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.05, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Brionac.Attack1", -- Sound ID
		['snd_delay'] = 0,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.35, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "DualKatana.HitFleshSlash2",
		['hitworld'] = "DualKatana.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_PULLBACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 250, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 975, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.05, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Brionac.Attack2", -- Sound ID
		['snd_delay'] = 0,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.35, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "DualKatana.HitFleshSlash2",
		['hitworld'] = "DualKatana.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 250, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 1250, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.05, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Brionac.Attack3", -- Sound ID
		['snd_delay'] = 0,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.4, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "DualKatana.HitFleshSlash2",
		['hitworld'] = "DualKatana.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 250, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(100,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 2000, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.075, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Brionac.Attack4", -- Sound ID
		['snd_delay'] = 0,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.7, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "DualKatana.HitFleshSlash2",
		['hitworld'] = "DualKatana.HitWall",
		['maxhits'] = 25
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 250, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(120,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 1780, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.2, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Brionac.End_Shoot", -- Sound ID
		['snd_delay'] = 0.1,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.2, --time before next attack
		['hull'] = 64, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "DualKatana.HitFleshStab",
		['hitworld'] = "DualKatana.HitWall",
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
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_dualkatana")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:SetNextHoldTime(t)
	self.NextHoldTime = CurTime() + t
	self:SetNextPrimaryFire(CurTime() + t)
	self:SetNextIdleAnim(CurTime() + t)
end

SWEP._KeyDown = false
SWEP._KeyDown_L = false
SWEP.HoldTime = 0
SWEP.LastHoldTime = 0
SWEP.ClickedCount = 0
SWEP.NextHoldTime = 0
SWEP.VMDelayTime = 0
function SWEP:Think2(...)
	if(CLIENT && !IsFirstTimePredicted()) then return end
	local owner = self.Owner
	local vm = owner:GetViewModel()
	local sequence = vm:GetSequence()
	local keydown = owner:KeyDown(IN_ATTACK2)
	local keydown_l = owner:KeyDown(IN_ATTACK)
	local clicked = false

	if(keydown && self.NextHoldTime < CurTime() && self:GetStatus() != 1) then
		local hold_time = CurTime() - self.HoldTime
		local last_hold_time = CurTime() - self.LastHoldTime

		if(keydown_l && !self._KeyDown_L) then
			vm:SetSequence(9)
			self:SetNextHoldTime(1)
			self:EmitSound("weapons/tfa_cso/brionac/win1.wav")
			self.VMDelayTime = CurTime() + 0.5
			return
		end

		if(!clicked && !self._KeyDown) then
			self.ClickedCount = self.ClickedCount + 1
			if(self.ClickedCount >= 2) then
				vm:SetSequence(6)
				self:EmitSound("weapons/tfa_cso/brionac/end_shoot.wav")

				self:Strike({
					['act'] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
					['len'] = 250, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
					['dir'] = Vector(120,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
					['dmg'] = 1780, --Nope!! Not overpowered!!
					['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
					['delay'] = 0.2, --Delay
					['spr'] = true, --Allow attack while sprinting?
					['snd'] = "Brionac.End_Shoot", -- Sound ID
					['snd_delay'] = 0.1,
					["viewpunch"] = Angle(0,0,0), --viewpunch angle
					['end'] = 1.2, --time before next attack
					['hull'] = 64, --Hullsize
					['direction'] = "F", --Swing dir
					['hitflesh'] = "DualKatana.HitFleshStab",
					['hitworld'] = "DualKatana.HitWall",
					['maxhits'] = 25
				}, 12)

				self:SetNextHoldTime(1.5)
				return
			end
			clicked = true
		end

		if(hold_time > 2) then
			vm:SetSequence(11)
			self:EmitSound("weapons/tfa_cso/brionac/end_shoot.wav")
			if(SERVER) then

			end

			self:Strike({
				['act'] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
				['len'] = 250, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
				['dir'] = Vector(120,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
				['dmg'] = 1780, --Nope!! Not overpowered!!
				['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
				['delay'] = 0.2, --Delay
				['spr'] = true, --Allow attack while sprinting?
				['snd'] = "Brionac.End_Shoot", -- Sound ID
				['snd_delay'] = 0.1,
				["viewpunch"] = Angle(0,0,0), --viewpunch angle
				['end'] = 1.2, --time before next attack
				['hull'] = 64, --Hullsize
				['direction'] = "F", --Swing dir
				['hitflesh'] = "DualKatana.HitFleshStab",
				['hitworld'] = "DualKatana.HitWall",
				['maxhits'] = 25
			}, 12)

			self:SetNextHoldTime(0.5)
			return
		end

		vm:SetSequence(7)
		self:SetNextPrimaryFire(CurTime() + 0.33)
		self:SetNextIdleAnim(CurTime() + 0.33)
		self.LastHoldTime = CurTime()
	else
		if(CurTime() - self.LastHoldTime > 0.15) then
			self.ClickedCount = 0
		end
		if(sequence == 7) then
			vm:SetSequence(10)
			self:SetNextIdleAnim(CurTime() + 0.33)
		elseif(sequence == 9 && self.VMDelayTime < CurTime()) then
			vm:SetSequence(10)
			self:SetNextIdleAnim(CurTime() + 0.33)
		end
		self.HoldTime = CurTime()
	end

	self._KeyDown = keydown
	self._KeyDown_L = keydown_l

	BaseClass.Think2(self, ...)
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
    if nextattack > 4 or self:GetComboCount() <= 0 then -- use this if you want choice to start from 1 when leaving mouse key (combo reset), otherwise do self:SetLastPrimaryAttackChoice(0) either in SWEP:Deploy() or SWEP:Holster()
       nextattack = 1
	end
    if nextattack > 4 then -- reset the count if we're going beyond attacks count
        nextattack = 1
    end

    self:SetLastPrimaryAttackChoice(nextattack) -- remembering the current choice for next time
    return nextattack, attacks[nextattack] -- returning the key of SWEP.Primary.Attacks table and the chosen attack table itself
end