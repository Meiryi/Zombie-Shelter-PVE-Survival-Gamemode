SWEP.Base = "arccw_base_melee"
SWEP.Spawnable = false
SWEP.Category = "ArcCW - Zombie Shelter"
SWEP.AdminOnly = false

SWEP.PrintName = "Shelter Axe"
SWEP.Trivia_Desc = [[
    
]]
SWEP.Trivia_Class = "Melee Weapon"
SWEP.Trivia_Manufacturer = "N/A"
SWEP.Trivia_Calibre = "N/A"
SWEP.Trivia_Mechanism = "Slashing"
SWEP.Trivia_Country = "NULL"
SWEP.Trivia_Year = 0
SWEP.BuildSpeed = 60

SWEP.Slot = 0

SWEP.NotForNPCs = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/tfa_cso/c_shelteraxe.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_shelteraxe.mdl"
SWEP.MirrorVMWM = false
SWEP.WorldModelOffset = {
    pos        =    Vector(-6.75, 4.25, 9),
    ang        =    Angle(-30, 0, 90),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale = 1.1,
}
SWEP.ViewModelFOV = 77

SWEP.ProceduralViewBobAttachment = 1
SWEP.CamAttachment = 1

SWEP.PrimaryBash = true
SWEP.CanBash = true
SWEP.ShootWhileSprint = TRUE

SWEP.MeleeSwingSound = ""
SWEP.MeleeMissSound = ""
SWEP.MeleeHitSound = "weapons/zsh/melees/wall.wav"
SWEP.MeleeHitNPCSound = "weapons/zsh/melees/hit1.wav"
SWEP.Melee2HitNPCSound = "weapons/zsh/melees/hit2.wav"

SWEP.MeleeDamage = 55
SWEP.MeleeRange = 50
SWEP.MeleeTime = 0.67
SWEP.MeleeAttackTime = 0.13
SWEP.DamageType = DMG_SLASH

SWEP.Melee2 = true
SWEP.Melee2Damage = 150
SWEP.Melee2Range = 50
SWEP.Melee2Time = 1.23
SWEP.Melee2AttackTime = 0.17

SWEP.NotForNPCs = false

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "Shelter Axe"
    },
}

SWEP.MeleeGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Melee2Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE

SWEP.HoldtypeActive = "knife"
SWEP.HoldtypeHolstered = "normal"

SWEP.Primary.ClipSize = -1

-- 0	=	reference
-- 1	=	seq_admire
-- 2	=	fists_draw
-- 3	=	fists_right
-- 4	=	fists_left
-- 5	=	fists_uppercut
-- 6	=	fists_holster
-- 7	=	fists_idle_01
-- 8	=	fists_idle_02


SWEP.Animations = {
    ["idle"] = {
        Source = {"idle"},
        Time = 1.5,
    },
    ["draw"] = {
        Source = "draw",
        Time = 0.94,
        SoundTable = {{s = "weapons/zsh/melees/draw.wav", t = 0}},
    },
    ["bash"] = {
        Source = {"slash1", "slash2"},
        Time = 1.20,
        SoundTable = {{s = "weapons/zsh/melees/slash.wav", t = 0}},
    },
    ["bash2"] = {
        Source = {"stab"},
        Time = 1.33,
        SoundTable = { {s = "weapons/zsh/melees/slash.wav", t = 0}},
    },
}


sound.Add({
    name = "Tomahawk.Draw",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/draw.wav"
})
sound.Add({
    name = "Tomahawk.Slash1",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/slash.wav"
})
sound.Add({
    name = "Tomahawk.Slash2",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/slash.wav"
})
sound.Add({
    name = "Tomahawk.Stab",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/slash.wav"
})
sound.Add({
    name = "Tomahawk.HitFleshSlash1",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/hit1.wav"
})
sound.Add({
    name = "Tomahawk.HitFleshSlash2",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/hit1.wav"
})
sound.Add({
    name = "Tomahawk.HitFleshSlash3",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/hit1.wav"
})
sound.Add({
    name = "Tomahawk.HitWall",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/wall.wav"
})

SWEP.IronSightStruct = false

SWEP.ActivePos = Vector(0, 2, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(0, 2, 0)
SWEP.CustomizeAng = Angle(0, 0, 0)

SWEP.BashPreparePos = Vector(0, 0, 0)
SWEP.BashPrepareAng = Angle(0, 0, 0)

SWEP.BashPos = Vector(0, 0, 0)
SWEP.BashAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(0, 0, 0)
SWEP.HolsterAng = Angle(0, 0, 0)

--[[
function SWEP:DrawHUD()
    return
end
]]

function SWEP:MeleeAttack(melee2)
    local reach = 32 + self:GetBuff_Add("Add_MeleeRange") + self.MeleeRange
    local dmg = self:GetBuff_Override("Override_MeleeDamage", self.MeleeDamage) or 20

    if melee2 then
        reach = 32 + self:GetBuff_Add("Add_MeleeRange") + self.Melee2Range
        dmg = self:GetBuff_Override("Override_MeleeDamage", self.Melee2Damage) or 20
    end

    dmg = dmg * self:GetBuff_Mult("Mult_MeleeDamage")

    self:GetOwner():LagCompensation(true)
    
    local filter = {self:GetOwner()}

    table.Add(filter, self.Shields)

    local tr = util.TraceLine({
        start = self:GetOwner():GetShootPos(),
        endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * reach,
        filter = filter,
        mask = MASK_SHOT_HULL
    })

    if (!IsValid(tr.Entity)) then
        tr = util.TraceHull({
            start = self:GetOwner():GetShootPos(),
            endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * reach,
            filter = filter,
            mins = Vector(-16, -16, -8),
            maxs = Vector(16, 16, 8),
            mask = MASK_SHOT_HULL
        })
    end

    -- Backstab damage if applicable
    local backstab = tr.Hit and self:CanBackstab(melee2, tr.Entity)
    if backstab then
        if melee2 then
            local bs_dmg = self:GetBuff_Override("Override_Melee2DamageBackstab", self.Melee2DamageBackstab)
            if bs_dmg then
                dmg = bs_dmg * self:GetBuff_Mult("Mult_MeleeDamage")
            else
                dmg = dmg * self:GetBuff("BackstabMultiplier") * self:GetBuff_Mult("Mult_MeleeDamage")
            end
        else
            local bs_dmg = self:GetBuff_Override("Override_MeleeDamageBackstab", self.MeleeDamageBackstab)
            if bs_dmg then
                dmg = bs_dmg * self:GetBuff_Mult("Mult_MeleeDamage")
            else
                dmg = dmg * self:GetBuff("BackstabMultiplier") * self:GetBuff_Mult("Mult_MeleeDamage")
            end
        end
    end

    -- We need the second part for single player because SWEP:Think is ran shared in SP
    if !(game.SinglePlayer() and CLIENT) then
        if tr.Hit then
            if (IsValid(tr.Entity)) then
                if (tr.Entity:GetNWBool("IsResource", false)) then
                    self:MyEmitSound(self.MeleeHitSound, 75, 100, 1, CHAN_USER_BASE + 2)
                    if(SERVER) then
                        ZShelter.GatheringSystem(self.Owner, tr.Entity) 
                    end
                    self:GetOwner():LagCompensation(false)
                    return
                end
                if (tr.Entity:GetNWBool("IsBuilding", false) && !tr.Entity.IsBarricade) then
                    if(SERVER) then
                        if(melee2) then
                            local dmginfo = DamageInfo()
                                dmginfo:SetAttacker(self.Owner)
                                dmginfo:SetInflictor(self)
                                dmginfo:SetDamage(self.BuildSpeed * 4)
                                dmginfo:SetDamageType(DMG_CLUB)
                            ZShelter.ApplyDamage(self.Owner, tr.Entity, dmginfo)
                        else
                            ZShelter.BuildSystem(self.Owner, tr.Entity, self.BuildSpeed)
                        end
                    end
                    self:MyEmitSound(self.MeleeHitSound, 75, 100, 1, CHAN_USER_BASE + 2)
                    self:GetOwner():LagCompensation(false)
                    return
                else
                    if(SERVER) then
                        if(self.Owner:IsPlayer()) then
                            local ply = self.Owner
                            local dmginfo = DamageInfo()
                            dmginfo:SetAttacker(ply)
                            local relspeed = (tr.Entity:GetVelocity() - self:GetOwner():GetAbsVelocity()):Length()
                            relspeed = relspeed / 225
                            relspeed = math.Clamp(relspeed, 1, 1.5)
                            dmginfo:SetInflictor(self)
                            dmginfo:SetDamage(dmg * relspeed)
                            dmginfo:SetDamageType(self:GetBuff_Override("Override_MeleeDamageType") or self.MeleeDamageType or DMG_CLUB)
                            dmginfo:SetDamagePosition(tr.HitPos)
                            dmginfo:SetDamageForce(self:GetOwner():GetRight() * -4912 + self:GetOwner():GetForward() * 9989)
                            if(ply.Callbacks && ply.Callbacks.OnMeleeDamage) then
                                for k,v in pairs(ply.Callbacks.OnMeleeDamage) do
                                    v(self.Owner, tr.Entity, dmginfo, melee2)
                                end
                            end
                        end
                    else
                        local ply = LocalPlayer()
                        if(ply.Callbacks && ply.Callbacks.OnMeleeDamage) then
                            local relspeed = (tr.Entity:GetVelocity() - self:GetOwner():GetAbsVelocity()):Length()
                            relspeed = relspeed / 225
                            relspeed = math.Clamp(relspeed, 1, 1.5)
                            local dmginfo = DamageInfo()
                            dmginfo:SetInflictor(self)
                            dmginfo:SetDamage(dmg * relspeed)
                            dmginfo:SetDamageType(self:GetBuff_Override("Override_MeleeDamageType") or self.MeleeDamageType or DMG_CLUB)
                            dmginfo:SetDamagePosition(tr.HitPos)
                            dmginfo:SetDamageForce(self:GetOwner():GetRight() * -4912 + self:GetOwner():GetForward() * 9989)
                            for k,v in pairs(ply.Callbacks.OnMeleeDamage) do
                                v(self.Owner, tr.Entity, dmginfo, melee2)
                             end
                        end
                    end
                end
            end
            if tr.Entity:IsNPC() or tr.Entity:IsNextBot() or tr.Entity:IsPlayer() then
                if (!tr.Entity:GetNWBool("IsBuilding", false)) then
                    if melee2 then
                        self:MyEmitSound(self.Melee2HitNPCSound, 75, 100, 1, CHAN_USER_BASE + 2)
                    else
                        self:MyEmitSound(self.MeleeHitNPCSound, 75, 100, 1, CHAN_USER_BASE + 2)
                    end
                else
                    self:MyEmitSound(self.MeleeHitSound, 75, 100, 1, CHAN_USER_BASE + 2)
                end
            else
                self:MyEmitSound(self.MeleeHitSound, 75, 100, 1, CHAN_USER_BASE + 2)
            end

            if tr.MatType == MAT_FLESH or tr.MatType == MAT_ALIENFLESH or tr.MatType == MAT_ANTLION or tr.MatType == MAT_BLOODYFLESH then
                local fx = EffectData()
                fx:SetOrigin(tr.HitPos)

                util.Effect("BloodImpact", fx)
            end
        else
            self:MyEmitSound(self.MeleeMissSound, 75, 100, 1, CHAN_USER_BASE + 3)
        end
    end

    if SERVER and IsValid(tr.Entity) and (tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:Health() > 0) then
        local dmginfo = DamageInfo()

        local attacker = self:GetOwner()
        if !IsValid(attacker) then attacker = self end
        dmginfo:SetAttacker(attacker)

        local relspeed = (tr.Entity:GetVelocity() - self:GetOwner():GetAbsVelocity()):Length()

        relspeed = relspeed / 225

        relspeed = math.Clamp(relspeed, 1, 1.5)

        dmginfo:SetInflictor(self)
        dmginfo:SetDamage(dmg * relspeed)
        dmginfo:SetDamageType(self:GetBuff_Override("Override_MeleeDamageType") or self.MeleeDamageType or DMG_CLUB)
        dmginfo:SetDamagePosition(tr.HitPos)
        dmginfo:SetDamageForce(self:GetOwner():GetRight() * -4912 + self:GetOwner():GetForward() * 9989)

        SuppressHostEvents(NULL)
        tr.Entity:TakeDamageInfo(dmginfo)
        SuppressHostEvents(self:GetOwner())

        if tr.Entity:GetClass() == "func_breakable_surf" then
            tr.Entity:Fire("Shatter", "0.5 0.5 256")
        end

    end

    if SERVER and IsValid(tr.Entity) then
        local phys = tr.Entity:GetPhysicsObject()
        if IsValid(phys) then
            phys:ApplyForceOffset(self:GetOwner():GetAimVector() * 80 * phys:GetMass(), tr.HitPos)
        end
    end

    self:GetBuff_Hook("Hook_PostBash", {tr = tr, dmg = dmg})

    self:GetOwner():LagCompensation(false)
end

SWEP.DisplayCTime = 0
SWEP.DisplayAlpha = 255
SWEP.DisplayString = "#BuildHints"
function SWEP:DrawHUDBackground()
    if(self.DisplayCTime < CurTime()) then
        self.DisplayString = ZShelter_GetTranslate("#BuildHints")
        self.DisplayCTime = CurTime() + 1
    end
    draw.DrawText(self.DisplayString, "ZShelter-HUDWeapon", ScrW() * 0.5, ScrH() * 0.935, color_white, TEXT_ALIGN_CENTER)
end