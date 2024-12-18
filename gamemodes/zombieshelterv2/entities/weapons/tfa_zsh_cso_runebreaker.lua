SWEP.Base = "tfa_zsh_melee_base"
SWEP.Category = "TFA CS:O Melees"
SWEP.PrintName = "Runebreaker"

SWEP.ViewModel = "models/weapons/tfa_cso/c_runebreaker.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_runebreaker.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.HoldType = "melee2"
SWEP.DrawCrosshair = true

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.ProceduralHolsterTime = 0
SWEP.DisableIdleAnimations = false

SWEP.Secondary.CanBash = false

-- nZombies Stuff
SWEP.NZWonderWeapon		= true	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
--SWEP.NZPaPName				= "Soul Edge"
SWEP.NZPaPReplacement 	= "tfa_cso_runebreaker_expert"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.
SWEP.PaPMats			= {}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1
SWEP.BuildSpeed = 100
SWEP.OldStyleHit = true
SWEP.GatheringAmount = 2

SWEP.AOEDamage = true
SWEP.AOERange_Primary = 32
SWEP.AOERange_Secondary = 1

SWEP.Offset = {
		Pos = {
		Up = -12,
		Right = 2,
		Forward = 4,
		},
		Ang = {
		Up = 90,
		Right = 175,
		Forward = 5
		},
		Scale = 1
}

sound.Add({
	['name'] = "Runebreaker.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/runebreaker/draw.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Runebreaker.ChargeStart",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/runebreaker/charge_start.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Runebreaker.ChargeFinish",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/runebreaker/charge_finish.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Runebreaker.ChargeSlash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/runebreaker/charge_slash_1.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Runebreaker.ChargeSlash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/runebreaker/charge_slash_2.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Runebreaker.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/runebreaker/slash_1.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Runebreaker.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/runebreaker/slash_2.wav" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 170, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-180,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 300, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.015,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.1, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "Tomahawk.HitFleshSlash1",
		['hitworld'] = "weapons/tfa_cso/combatknife/wall.wav",
		['maxhits'] = 25
	},
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 150, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,130), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 225, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 1.2, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 1.2,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 2.5, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "Tomahawk.HitFleshSlash1",
		['hitworld'] = "weapons/tfa_cso/combatknife/wall.wav",
		['maxhits'] = 25
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_runebreaker")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end

DEFINE_BASECLASS(SWEP.Base)
function SWEP:SetupDataTables(...)
    local retVal = BaseClass.SetupDataTables(self, ...)

    self:NetworkVarTFA("Int", "LastPrimaryAttackChoice") -- self:GetLastPrimaryAttackChoice() and self:SetLastPrimaryAttackChoice(number)
    self:NetworkVarTFA("Int", "LastSecondaryAttackChoice") -- self:GetLastSecondaryAttackChoice() and self:SetLastSecondaryAttackChoice(number)

    return retVal
end

function SWEP:PostAttack()
	local melee2 = self.Melee2Attack
	if(!melee2) then return end
	self:EmitSoundNet("shigure/runebreaker-exp.wav")
	local ply = self.Owner
	local pos = ply:EyePos() + ply:EyeAngles():Forward() * 64
	local e = EffectData()
		e:SetOrigin(pos)
		util.Effect("exp_runebreaker", e)

	if(SERVER) then
		local tpos = util.TraceLine({
			start = ply:EyePos(),
			endpos = ply:EyePos() + ply:EyeAngles():Forward() * 256,
			filter = ply,
			mask = MASK_SOLID_BRUSHONLY,
		}).HitPos
		local gap = 64
		local step = math.max(math.floor(tpos:Distance(ply:GetPos()) / gap), 1)
		local offset = tpos - ply:EyePos()
		local entities = {}
		for i = 0, step do
			for _, ent in ipairs(ents.FindInSphere(ply:EyePos() + (offset * (i / step)), gap)) do
				if(!ZShelter.HurtableTarget(ent) || entities[ent:EntIndex()] || ent == ply) then continue end
				entities[ent:EntIndex()] = ent
			end
		end

		for _, ent in pairs(entities) do
			ent:TakeDamage(180, ply, self)
		    if(ply.Callbacks && ply.Callbacks.OnMeleeDamage) then
		    	local dmginfo = DamageInfo()
		    		dmginfo:SetDamage(180)
		    		dmginfo:SetAttacker(ply)
		    		dmginfo:SetInflictor(self)
		        for k,v in pairs(ply.Callbacks.OnMeleeDamage) do
		            v(ply, ent, dmginfo, true)
		        end
		    end
		end
	end
end