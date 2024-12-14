SWEP.Base = "tfa_zsh_melee_base"
SWEP.Category = "TFA CS:O Melees"
SWEP.PrintName = "Dual Sword Phantom Slayer"
SWEP.Author				= "Kamikaze, Meika, ★Bullet★" --Author Tooltip
SWEP.Purpose = "Slashing everything along it's path. For activating special attack = LMB > Hold RMB > Hold LMB > Hold RMB" --Purpose Tooltip
SWEP.ViewModel = "models/weapons/tfa_cso/c_dualphantomslayer.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_dualsword_thunder.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.HoldType = "melee"
SWEP.DrawCrosshair = true
SWEP.HasSkillTriggerFunc = true

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.DisableIdleAnimations = false

SWEP.Secondary.CanBash = false

-- nZombies Stuff
SWEP.NZWonderWeapon		= true	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Dancing Dragons"
SWEP.NZPaPReplacement 	= "tfa_cso_dualsword_rb"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.
SWEP.PaPMats			= {}

SWEP.ProceduralHolsterTime = 0
SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1
SWEP.MoveSpeed = 1.2 --Multiply the player's movespeed by this.
SWEP.BuildSpeed = 55
SWEP.OldStyleHit = true

SWEP.AOEDamage = true
SWEP.AOERange_Primary = 32
SWEP.AOERange_Secondary = 16

SWEP.WElements = {
	["fire_sword"] = { type = "Model", model = "models/weapons/tfa_cso/w_dualsword_fire.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.5, 0, 8.00), angle = Angle(10, -100, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Offset = {
		Pos = {
		Up = -8,
		Right = 1,
		Forward = 4,
		},
		Ang = {
		Up = 180,
		Right = 180,
		Forward = 0
		},
		Scale = 1
}

sound.Add({
	['name'] = "DualSword.Idle",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/idle.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.Start",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/start.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.End",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/end.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.SkillStart",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/skill_start.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.SkillEnd",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/skill_end.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.SlashEnd",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/swing_end.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.StabEnd",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/stab_end.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.Swing1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "shigure/slash1_41k.mp3" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.Swing2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "shigure/slash2_41k.mp3" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.Swing3",
	['channel'] = CHAN_STATIC,
	['sound'] = { "shigure/slash3_41k.mp3" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.Swing4",
	['channel'] = CHAN_STATIC,
	['sound'] = { "shigure/slash4_41k.mp3" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.Stab1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dual_sword/stab_1.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.Stab2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dual_sword/stab_2.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.HitFleshSlash1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/hit_1.wav" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "DualSword.HitFleshSlash2",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/hit_2.wav" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "DualSword.HitFleshSlash3",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/hit_3.wav" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "DualSword.HitFleshStab1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/stab_1_hit.wav" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "DualSword.HitFleshStab2",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/stab_2_hit.wav" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "DualSword.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/hit_wall.wav" },
	['pitch'] = {95,105}
})

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 130, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-180,0,15), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 150, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "weapons/tfa_cso/dual_sword/slash1.wav", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.130, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "DualSword.HitFleshSlash1",
		['hitworld'] = "weapons/tfa_cso/dual_sword/hit_wall.wav",
		['maxhits'] = 25 
	},
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 130, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(180,0,35), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 170, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.130, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "DualSword.HitFleshSlash2",
		['hitworld'] = "weapons/tfa_cso/dual_sword/hit_wall.wav",
		['maxhits'] = 25 
	},
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 130, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-180,0,-35), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 190, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.130, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "DualSword.HitFleshSlash3",
		['hitworld'] = "weapons/tfa_cso/dual_sword/hit_wall.wav",
		['maxhits'] = 25 
	},
	{
		['act'] = ACT_VM_PULLBACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 130, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(180,0,17.5), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 220, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.7, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "DualSword.HitFleshSlash1",
		['hitworld'] = "weapons/tfa_cso/dual_sword/hit_wall.wav",
		['maxhits'] = 25 
	},
}

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 200, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,90,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 180, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.035, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.4, --time before next attack
		['hull'] = 256, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "DualSword.HitFleshStab1",
		['hitworld'] = "weapons/tfa_cso/dual_sword/hit_wall.wav",
		['maxhits'] = 25 
	},
	{
		['act'] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 200, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,90,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 300, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.07, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.05,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.9, --time before next attack
		['hull'] = 256, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "DualSword.HitFleshStab2",
		['hitworld'] = "weapons/tfa_cso/dual_sword/hit_wall.wav",
		['maxhits'] = 25 
	}
}

DEFINE_BASECLASS(SWEP.Base)
function SWEP:Holster( ... )
    self:SetNextSecondaryFire(0)
    self:SetNextPrimaryFire(0)
	self:StopSound("DualSword.Idle")
	return BaseClass.Holster(self,...)
end
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_dualsword")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end

function SWEP:SetupDataTables(...)
    local retVal = BaseClass.SetupDataTables(self, ...)

    self:NetworkVarTFA("Int", "LastPrimaryAttackChoice") -- self:GetLastPrimaryAttackChoice() and self:SetLastPrimaryAttackChoice(number)
    self:NetworkVarTFA("Int", "LastSecondaryAttackChoice") -- self:GetLastSecondaryAttackChoice() and self:SetLastSecondaryAttackChoice(number)

    return retVal
end

SWEP.ShouldPlaySound = false
function SWEP:Think2(...)
	if(CLIENT) then
		local vm = self.Owner:GetViewModel()
		if(vm:GetSequence() == 4) then
			if(vm:GetCycle() >= 0.1) then
				if(self.ShouldPlaySound) then
					if(!self.Owner:KeyDown(IN_ATTACK2)) then
						self.Owner:EmitSound("shigure/wink.mp3")
					end
					self.ShouldPlaySound = false
				end
			end
		else
			self.ShouldPlaySound = true
		end
	end
	BaseClass.Think2(self, ...)
end

SWEP.LastAttackTime = 0
function SWEP:ChooseSecondaryAttack()
    local attacks = self:GetStatL("Secondary.Attacks") -- getting the SWEP.Primary.Attacks table

    local lastattack = self:GetLastSecondaryAttackChoice() -- default value is 0 so it'll start with 1 from next line

    local nextattack = lastattack + 1 -- choosing the next attack
    if nextattack > 4 or self:GetComboCount() <= 0 then -- use this if you want choice to start from 1 when leaving mouse key (combo reset), otherwise do self:SetLastPrimaryAttackChoice(0) either in SWEP:Deploy() or SWEP:Holster()
       nextattack = 1
	end
    if nextattack > 4 then -- reset the count if we're going beyond attacks count
        nextattack = 1
        self:SetComboCount(0)
    end

    if((CLIENT || game.SinglePlayer()) && IsFirstTimePredicted()) then
	    local e = EffectData()
	    	e:SetOrigin(self.Owner:EyePos())
	    	e:SetFlags(1)
	    	e:SetScale(nextattack)
	    util.Effect("tfa_cso_dualswordfx", e)
    end

    self:SetLastSecondaryAttackChoice(nextattack) -- remembering the current choice for next time
    return nextattack, attacks[nextattack] -- returning the key of SWEP.Primary.Attacks table and the chosen attack table itself
end

function SWEP:ChoosePrimaryAttack()
    local attacks = self:GetStatL("Primary.Attacks") -- getting the SWEP.Primary.Attacks table

    local lastattack = self:GetLastPrimaryAttackChoice() -- default value is 0 so it'll start with 1 from next line
    local nextattack = lastattack + 1 -- choosing the next attack
    if nextattack > 2 or self:GetComboCount() <= 0 then -- use this if you want choice to start from 1 when leaving mouse key (combo reset), otherwise do self:SetLastPrimaryAttackChoice(0) either in SWEP:Deploy() or SWEP:Holster()
       nextattack = 1
	end
    if nextattack > 2 then -- reset the count if we're going beyond attacks count
        nextattack = 1
    end
    self.LastAttackTime = CurTime()
    self:SetLastPrimaryAttackChoice(nextattack) -- remembering the current choice for next time
    return nextattack, attacks[nextattack] -- returning the key of SWEP.Primary.Attacks table and the chosen attack table itself
end

function SWEP:OnComboBreak() -- Preventing player from spamming attacks
	local t = CurTime() - self.LastAttackTime
	if(self:GetLastPrimaryAttackChoice() == 2 && t > 0.1 && t < 0.2) then
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:SetNextSecondaryFire(CurTime() + 0.2)
	else
		self:SetNextPrimaryFire(CurTime() + 0.45)
		self:SetNextSecondaryFire(CurTime() + 0.45)
	end
end

function SWEP:Deploy(...)
	BaseClass.Deploy(self, ...)
	self:SetNextPrimaryFire(CurTime() + 0.05)
	self:SetNextSecondaryFire(CurTime() + 0.05)
	self:SetStatusEnd(CurTime() + 0.05)
end

function SWEP:PreGatheringResource(res)
	if(self.Melee2Attack) then
		local lastattack = self:GetLastSecondaryAttackChoice()
		return lastattack % 2 == 0
	else
		return true
	end
end