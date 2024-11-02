SWEP.Base = "tfa_zsh_melee_base"
SWEP.Category = "TFA CS:O Melees"
SWEP.PrintName = "Dual Wakizashi"
SWEP.Author	= "Kamikaze" --Author Tooltip
SWEP.Type	= "Melee weapon"
SWEP.ViewModel = "models/weapons/tfa_cso/c_dualkatana.mdl"
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
SWEP.NZPaPName				= "Tiendo No Kamikaze"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualsword"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.
SWEP.PaPMats			= {}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1
SWEP.BuildSpeed = 30
SWEP.OldStyleHit = true

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
	['name'] = "DualKatana.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dualkatana/draw.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualKatana.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dualkatana/slash1.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualKatana.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dualkatana/slash2.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualKatana.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dualkatana/stab.wav"},
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
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 120, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-100,0,-10), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 75, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.2,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.35, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "DualKatana.HitFleshSlash2",
		['hitworld'] = "DualKatana.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 120, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-100,0,-10), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 125, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.02, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.2,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.7, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "DualKatana.HitFleshSlash2",
		['hitworld'] = "DualKatana.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_PULLBACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 120, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(100,0,45), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 75, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.04, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.2,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.275, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "DualKatana.HitFleshSlash2",
		['hitworld'] = "DualKatana.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 120, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-100,0,-45), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 125, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.04, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.2,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.5, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "DualKatana.HitFleshSlash2",
		['hitworld'] = "DualKatana.HitWall",
		['maxhits'] = 25
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 250, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,80), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 350, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.3, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.4,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.3, --time before next attack
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

function SWEP:PreGatheringResource(res)
	if(self.Melee2Attack) then
		return true
	else
		local lastattack = self:GetLastPrimaryAttackChoice()
		return (lastattack == 1 || lastattack == 3)
	end
end

SWEP.EnemyHit = {}
function SWEP:OnTargetHit(melee2, target, attk)
	if(CLIENT) then return end
	if(!target.UniqueID) then
		target.UniqueID = math.random(0, 32767)
	end
	self.EnemyHit[target.UniqueID] = (self.EnemyHit[target.UniqueID] || 1) + 0.15
	target:TakeDamage(attk.dmg * self.EnemyHit[target.UniqueID], self.Owner, self)
end

function SWEP:OnComboBreak() -- Preventing player from spamming attacks
	self:SetNextPrimaryFire(CurTime() + 0.55)
	self:SetNextSecondaryFire(CurTime() + 0.55)
end