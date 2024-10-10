AddCSLuaFile()
CSO = {}

--[[
    <Player> p - Player entity
    <Int> seq - target sequence
    <Float> scl - time percentage, 0.5 means 50% of vm's animation length
    Used to compare is player's current vm sequence and sequence time
]]
function CSO:CompareVMSeqTimeScale(p, seq, scl)
    local vm = p:GetViewModel()
    local dur = vm:SequenceDuration(seq)
    return (vm:GetSequence() == seq && vm:GetCycle() * dur > dur * scl)
end

function CSO:CompareVMSeqTimeScaleRev(p, seq, scl)
    local vm = p:GetViewModel()
    local dur = vm:SequenceDuration(seq)
    return (vm:GetSequence() == seq && vm:GetCycle() * dur < dur * scl)
end

--[[
    <Player> p - Player entity
    <Int> seq - target sequence
    <Float> t - time
    Used to compare is player's current vm sequence and sequence time
]]
function CSO:CompareVMSeqTime(p, seq, t)
    local vm = p:GetViewModel()
    return (vm:GetSequence() == seq && vm:GetCycle() * vm:SequenceDuration(vm:GetSequence()) > t)
end

--[[
    <Player> p - Player entity
    <Int> seq - target sequence
    Used to compare is player's current sequence
]]

function CSO:SetNextActionTime(s, t)
    s:SetNextPrimaryFire(CurTime() + t)
    s:SetStatusEnd(CurTime() + t)
end

function CSO:GetVMCycle(s)
    return s.Owner:GetViewModel():GetCycle()
end

function CSO:SetNextActionTimeIdle(s, t)
    s:SetNextPrimaryFire(CurTime() + t)
    s:SetStatusEnd(CurTime() + t)
    s:SetNextIdleAnim(CurTime() + t)
end

function CSO:CompareVMSeq(p, seq)
    return p:GetViewModel():GetSequence() == seq
end

function CSO:GetCurrentVMTime(p)
    local vm = p:GetViewModel()
    return vm:GetCycle() * vm:SequenceDuration(vm:GetSequence())
end

function CSO:GetVMSequence(p)
    return p:GetViewModel():GetSequence()
end

function CSO:CompareNextStatusTime(sel)
    if(CSO:IsDrawing(sel)) then return false end
    return (sel:GetStatusEnd() > CurTime())
end

function CSO:IsTogglingSilencer(sel)
    local st = sel:GetStatus()
    return (st == TFA.GetStatus("silencer_toggle"))
end

function CSO:IsIdling(sel)
    local st = sel:GetStatus()
    return (st == TFA.GetStatus("idle"))
end

function CSO:IsDrawing(sel)
    local st = sel:GetStatus()
    return (st == TFA.GetStatus("draw"))
end

function CSO:IsReloading(sel)
    local st = sel:GetStatus()
    return (st == TFA.GetStatus("reloading") || st == TFA.GetStatus("reloading_wait"))
end

function CSO:BlockExtraAction(sel)
    local st = sel:GetStatus()
    return (st == TFA.GetStatus("reloading") || st == TFA.GetStatus("reloading_wait") || st == TFA.GetStatus("silencer_toggle") || st == TFA.GetStatus("draw") || sel:GetSprinting())
end

function CSO:BlockExtraActionTime(sel)
    local st = sel:GetStatus()
    return (st == TFA.GetStatus("reloading") || st == TFA.GetStatus("reloading_wait") || st == TFA.GetStatus("draw") || st == TFA.GetStatus("silencer_toggle") || sel:GetSprinting() || (sel:GetStatusEnd() != math.huge && sel:GetStatusEnd() > CurTime()) || sel:GetNextPrimaryFire() > CurTime())
end

function CSO:SequenceNoOverride(sel, seq)
    local ply = sel:GetOwner()
    if(!ply) then return end
    local vm = ply:GetViewModel()
    vm:SetSequence(seq)
end

function CSO:ForceVMSequenceNoStatus(sel, seq)
    local ply = sel:GetOwner()
    if(!ply) then return end
    local vm = ply:GetViewModel()
    vm:SendViewModelMatchingSequence(seq)
end

function CSO:ForceVMSequence(sel, seq, t, auto)
    local ply = sel:GetOwner()
    if(!ply) then return end
    local vm = ply:GetViewModel()
    vm:SendViewModelMatchingSequence(seq)
    if(auto) then
        t = vm:SequenceDuration(seq)
    end
    sel:SetStatusEnd(CurTime() + t)
    sel:SetNextPrimaryFire(CurTime() + t)
    sel:SetNextIdleAnim(CurTime() + t)
end

function CSO:ForceVMSequenceEvent(sel, seq, t, server, auto, func)
    local ply = sel:GetOwner()
    if(!ply) then return end
    local vm = ply:GetViewModel()
    vm:SendViewModelMatchingSequence(seq)
    if(auto) then
        t = vm:SequenceDuration(seq)
    end
    sel:SetStatusEnd(CurTime() + t + 0.1)
    sel:SetNextPrimaryFire(CurTime() + t + 0.1)
    sel:SetNextIdleAnim(CurTime() + t + 0.1)
    if(server && CLIENT) then return end
    timer.Simple(t, function() func() end)
end

function CSO:GetAmmoCount(sel, type)
    if(!sel.Owner:IsPlayer()) then return 0 end
    if(type == 1) then
        return sel.Owner:GetAmmoCount(sel:GetPrimaryAmmoType())
    else
        return sel.Owner:GetAmmoCount(sel:GetSecondaryAmmoType())
    end
end

function CSO:ValidateEntity(ent)
    return ((ent:IsPlayer() && ent:Alive()) || ent:IsNPC() || ent:IsNextBot())
end

function CSO:IsValidTarget(target, owner)
    if not IsValid(target) then return false end -- invalid target
	if target == owner then return false end -- owner

	if engine.ActiveGamemode() == "zombiesurvival" then
		if target:IsPlayer() and target:Team() == TEAM_UNDEAD and target:Alive() and not target:IsFrozen() then
			return true
		end
	else
		if (target:IsPlayer() and target:Alive() and not target:IsFrozen()) or target:IsNPC() or target:IsNextBot() then
			return true
		end
	end
	return false
end

function CSO:GetInflictor(ply)
    if(!ply:IsPlayer()) then
        return ply
    end
    local w = ply:GetActiveWeapon()
    if(!IsValid(w)) then return ply end
    return w
end

function CSO:DMGInfo(attacker, inflictor, dmg, force, type, pos)
    local dmginfo = DamageInfo()
        dmginfo:SetAttacker(attacker)
        dmginfo:SetInflictor(inflictor)
        dmginfo:SetDamage(dmg)
        dmginfo:SetDamageForce(force)
        dmginfo:SetDamageType(type)
        dmginfo:SetDamagePosition(pos)
    return dmginfo
end

function CSO:DoRadiusAttack(wep, dmginfo, radius, knockback, force, dmgscale, override, vec, dmgfalloff, stun, time, strength, ignoreOwner)
    if(!IsValid(wep)) then return end
    local owner = wep:GetOwner()
    local dmg = dmginfo:GetDamage()
    if(!IsValid(owner)) then return end
    local ori = owner:GetPos()
    if override then
        ori = vec
    end
    for k,v in pairs(ents.FindInSphere(ori, radius)) do
        if(v == owner && ignoreOwner) then continue end
        if CSO:IsValidTarget(v, owner) then
            if knockback then
                local f = ((v:GetPos() - ori):Angle():Forward() * force) + Vector(0, 0, 250)
                v:SetVelocity(v:GetVelocity() + f)
                dmginfo:SetDamageForce(f)
            end
            if dmgfalloff then
                local dst = v:GetPos():Distance(ori)
                dmginfo:SetDamage(dmg *  (1.1 - (dst / radius))) -- use 1.1 to make sure we still have a 10% base damage
            end
            if(stun) then
                CSO:ApplyStun(v, time, strength)
            end
            dmginfo:SetDamagePosition(v:GetPos() + v:OBBCenter())
            dmginfo:ScaleDamage(dmgscale)
            v:TakeDamageInfo(dmginfo)
        end
    end
end

function CSO:DoRadiusAttack_WeaponLess(attacker, dmginfo, radius, knockback, force, dmgscale, override, vec, dmgfalloff, stun, time, strength, ignoreOwner)
    if(!IsValid(attacker)) then return end
    local ori = attacker:GetPos()
    local dmg = dmginfo:GetDamage()
    if(override) then
        ori = vec
    end
    for k,v in pairs(ents.FindInSphere(ori, radius)) do
        if(v == attacker && ignoreOwner) then continue end
        if(knockback) then
            local f = (v:GetPos() - ori):Angle():Forward() * force
            v:SetVelocity(v:GetVelocity() + f)
            dmginfo:SetDamageForce(f)
        end
        if(dmgfalloff) then
            local dst = v:GetPos():Distance(ori)
            dmginfo:SetDamage(dmg *  (1.1 - (dst / radius)))
        end
        if(stun) then
            CSO:ApplyStun(v, time, strength)
        end
        dmginfo:SetDamagePosition(v:GetPos())
        dmginfo:ScaleDamage(dmgscale)
        v:TakeDamageInfo(dmginfo)
    end
end

function CSO:GetHitCount(w)
    return w:GetNWInt("CSO_HitsNum", 0)
end

function CSO:AddHitCount(w, n, e)
    w:SetNWInt("CSO_HitsNum", w:GetNWInt("CSO_HitsNum", 0) + n)
    CSO:StartHitEvent(w, e)
end

function CSO:AddHitCount_NoEvent(w, n)
    w:SetNWInt("CSO_HitsNum", w:GetNWInt("CSO_HitsNum", 0) + n)
end

function CSO:ResetHitCount(w, n)
    w:SetNWInt("CSO_HitsNum", 0)
end

function CSO:ScreenCenter()
    return ScrW() / 2, ScrH() / 2
end

function CSO:DrawFilledCircle(x, y, radius, scl)
    local cir = {}
    local seg = 30
    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    for i = 0, seg do
        local a = math.rad( ( i / seg ) * (-360 * scl))
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end
    surface.DrawPoly( cir )
end

function CSO:QuickTracerEffect(ply, target, t)
    local e = EffectData()
        e:SetStart(ply:EyePos())
        e:SetEntity(target)
        e:SetAttachment(1)
        util.Effect(t, e)
end

function CSO:GetDistance(ply, target)
    return ply:GetPos():Distance(target:GetPos())
end

function CSO:GetDistanceNoZAxis(ply, target)
    local p, t = ply:GetPos(), target:GetPos()
    return Vector(p.x, p.y, 0):Distance(Vector(t.x, t.y, 0))
end

function CSO:GetDistanceVecNoZAxis(vec, target)
    local t = target:GetPos()
    vec.z = 0
    return vec:Distance(Vector(t.x, t.y, 0))
end

function CSO:IsVisible(ply, target)
    local p1, p2 = ply:EyePos(), target:EyePos()
    local tr = {
        start = p1,
        endpos = p2,
        filter = {ply, target},
        mask = 16395,
    }
    local ret = util.TraceLine(tr)
    if(ret.Fraction != 1) then return false end
    return true
end

function CSO:IsValidEntity(ent)
    return (ent:IsNPC() || ent:IsPlayer() || ent:IsNextBot())
end

function CSO:IsVisibleAngle(ply, target, maxAngle)
    local p1, p2 = ply:EyePos(), target:EyePos()
    local tr = {
        start = p1,
        endpos = p2,
        filter = {ply, target},
        mask = MASK_SHOT,
    }
    if(util.TraceLine(tr).Fraction != 1) then return false end
    local a = (p2 - p1):Angle()
    a:Normalize()
    if(math.abs(math.abs(a.y) - math.abs(ply:EyeAngles().y)) > maxAngle / 2) then return false end
    return true
end

function CSO:IsVisibleAllAngle(ply, target, maxAngle)
    local p1, p2 = ply:EyePos(), target:EyePos()
    local tr = {
        start = p1,
        endpos = p2,
        filter = {ply, target},
        mask = MASK_SHOT,
    }
    if(util.TraceLine(tr).Fraction != 1) then return false end
    local a = (p2 - p1):Angle()
    a:Normalize()
    if(math.abs(math.abs(a.y) - math.abs(ply:EyeAngles().y)) > maxAngle / 2 || math.abs(math.abs(a.p) - math.abs(ply:EyeAngles().p)) > maxAngle / 2) then return false end
    return true
end

function CSO:GetEntityCenter(ent)
    return ent:GetPos() + Vector(0, 0, ent:OBBMaxs().z / 2)
end

function CSO:RectTimerAnimation(x, y, w, h, color, bg, bgcolor, t, rev, crad)
    if(bg) then
        draw.RoundedBox(crad, x - w / 2, y - h / 2, w, h, bgcolor)
    end
    if(rev) then
        draw.RoundedBox(crad, x - w / 2, y - h / 2, w, h * t, color)
    else
        draw.RoundedBox(crad, x - w / 2, y - h / 2, w * t, h, color)
    end
end

function CSO:CircleTimerAnimation(x, y, radius, thickness, t, color)
    draw.NoTexture()
    surface.SetDrawColor(color.r, color.g, color.b, color.a) -- Don't use Color(), it's slow af, check wiki

    render.ClearStencil()

    render.SetStencilEnable(true)
    render.SetStencilTestMask(0xFF)
    render.SetStencilWriteMask(0xFF)
    render.SetStencilReferenceValue(0x01)

    render.SetStencilCompareFunction(STENCIL_NEVER)
    render.SetStencilFailOperation(STENCIL_REPLACE)
    render.SetStencilZFailOperation(STENCIL_REPLACE)
    CSO:DrawFilledCircle(x, y, radius - thickness, 1)
    render.SetStencilCompareFunction(STENCIL_GREATER)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    CSO:DrawFilledCircle(x, y, radius, t)
    render.SetStencilEnable(false)
end

hook.Add("EntityTakeDamage", "CSO_DamageProcessing", function(target, dmginfo)
    local attacker = dmginfo:GetAttacker()
    if(!IsValid(attacker)) then return end
    if(!attacker:IsPlayer()) then return end
    if(dmginfo:GetInflictor() == target) then return end
    local wep = attacker:GetActiveWeapon()
    if(wep.LastHitTime != nil && wep.LastHitTime > CurTime() || wep.NoHitCount) then return end
    wep.LastHitTime = CurTime() + 0.01 -- prevent shotguns to getting large amount of hits because of pellets
    if(!IsValid(wep)) then return end
    if(!target:IsPlayer() && !target:IsNPC()) then return end
    CSO:AddHitCount(wep, 1, target)
end)

function CSO:AltBash(sel, maxTargets, force, area, func, angle, timescale)
    if(sel:GetNextPrimaryFire() > CurTime()) then return end
    if(CSO:BlockExtraAction(sel)) then return end
    if(maxTargets == nil) then
        maxTargets = 10
    end
    if(angle == nil) then angle = -15 end
    local Delay = sel.Secondary.BashDelay
    if(timescale) then
        Delay = Delay * timescale
    end


    local Damage = sel.Secondary.BashDamage
    local BashLength = sel.Secondary.BashLength

    local BashSound = sel.Secondary.BashSound
    local BashHitSound = sel.Secondary.BashHitSound
    local BashHitSound_Flesh = sel.Secondary.BashHitSound_Flesh

    local BashDamageType = sel.Secondary.BashDamageType
    sel:EmitSound(BashSound)
    local owner = sel:GetOwner()
    local vm = owner:GetViewModel()
    local act = vm:SelectWeightedSequence(ACT_VM_HITCENTER)
    CSO:ForceVMSequence(sel, act, -1, true)
    timer.Simple(Delay, function()
        if(!IsValid(sel) || !IsValid(owner)) then return end
        local w = owner:GetActiveWeapon()
        if(!IsValid(w) || w != sel) then return end
        local pos = owner:GetShootPos()
        local ang = owner:EyeAngles()
        local av = ang:Forward()
        local slash = {}
        slash.start = pos
        slash.endpos = pos + (av * BashLength)
        slash.filter = owner
        slash.mins = Vector(-area.x, -area.y, 0)
        slash.maxs = Vector(area.x, area.y, area.z)
        local slashtrace = util.TraceHull(slash)
        ang.p = angle
        av = ang:Forward()
        if(slashtrace.Hit) then
            sel:HandleDoor(slashtrace)
            if(SERVER) then
                sel:EmitSound((slashtrace.MatType == MAT_FLESH || slashtrace.MatType == MAT_ALIENFLESH) && BashHitSound_Flesh || BashHitSound)
            end
            local rad = slash.mins:Distance(slash.maxs)
            if(CLIENT) then return end
            local hpos = slashtrace.HitPos
            local count = 0
            for k,v in pairs(ents.FindInSphere(hpos, rad * 3)) do -- *3 because z axis check\
                if(count > maxTargets) then continue end
                if(!IsValid(v)) then continue end
                if(v:Health() <= 0) then continue end
                if(CSO:GetDistanceVecNoZAxis(hpos, v) > rad * 1.5) then continue end
                if(v == owner) then continue end
                local force = av * force
                local d = CSO:DMGInfo(owner, sel, Damage, force, BashDamageType, v:GetPos())
                v:SetVelocity(force)
                v:TakeDamageInfo(d)
                count = count + 1
            end
        end
    end)
end

function CSO:PrimaryAttack_Melee(sel, maxTargets, force, area, func, angle, Yangle, acts)
    if(sel:GetNextPrimaryFire() > CurTime()) then return end
    if(CSO:BlockExtraActionTime(sel)) then return end
    if(maxTargets == nil) then
        maxTargets = 10
    end
    if(angle == nil) then angle = -15 end
    local _atks = sel.Primary.Attacks[math.random(1, #sel.Primary.Attacks)]
    local Delay = _atks.delay
    local Damage = _atks.dmg
    local BashLength = _atks.len_tr
    if(BashLength == nil) then BashLength = _atks.len end
    local BashHitSound = _atks.hitworld
    local BashHitSound_Flesh = _atks.hitflesh

    local BashDamageType = _atks.dmgtype

    local owner = sel:GetOwner()
    local vm = owner:GetViewModel()
    local act = vm:SelectWeightedSequence(ACT_VM_PRIMARYATTACK)
    if(acts != nil) then
        act = acts[math.random(1, #acts)]
    end
    CSO:ForceVMSequence(sel, act, -1, true)
    timer.Simple(Delay, function()
        if(!IsValid(sel) || !IsValid(owner)) then return end
        local w = owner:GetActiveWeapon()
        if(!IsValid(w) || w != sel) then return end
        local pos = owner:GetShootPos()
        local ang = owner:EyeAngles()
        local av = ang:Forward()
        local slash = {}
        slash.start = pos
        slash.endpos = pos + (av * BashLength)
        slash.filter = owner
        slash.mins = Vector(-area.x, -area.y, 0)
        slash.maxs = Vector(area.x, area.y, area.z)
        local slashtrace = util.TraceHull(slash)
        ang.p = angle
        av = ang:Forward()

        if(slashtrace.Hit) then
            sel:HandleDoor(slashtrace)
            if(SERVER) then
                sel:EmitSound((slashtrace.MatType == MAT_FLESH || slashtrace.MatType == MAT_ALIENFLESH) && BashHitSound_Flesh || BashHitSound)
            end
        end
        if(CLIENT) then return end
        local shouldplaySD = false
        local count = 0
        for k,v in pairs(ents.FindInCone(owner:GetPos(), owner:EyeAngles():Forward(), BashLength, math.cos(math.rad(Yangle)))) do
            if(count > maxTargets) then continue end
            if(!IsValid(v)) then continue end
            if(v:Health() <= 0) then continue end
            if(v == owner) then continue end
            if(!CSO:IsVisible(owner, v)) then continue end
            local force = av * force
            local d = CSO:DMGInfo(owner, sel, Damage, force, BashDamageType, v:GetPos())
            v:SetVelocity(force)
            v:TakeDamageInfo(d)
            shouldplaySD = true
            count = count + 1
        end
        if(shouldplaySD) then
            sound.Play(BashHitSound_Flesh, sel:GetPos(), 100, 100, 1)
        end
    end)
end

function CSO:QuickMeleeTrace(sel, maxTargets, area, force, dmg, len, sd, sdf)
    local owner = sel:GetOwner()
    local vm = owner:GetViewModel()
    local __act = ACT_VM_PRIMARYATTACK
    if(sel:GetSilenced()) then
        __act = ACT_VM_PRIMARYATTACK_SILENCED
    end
    local act = vm:SelectWeightedSequence(__act)
    local pos = owner:GetShootPos()
    local ang = owner:EyeAngles()
    local av = ang:Forward()
    local slash = {}
    slash.start = pos
    slash.endpos = pos + (av * len)
    slash.filter = owner
    slash.mins = Vector(-area.x, -area.y, 0)
    slash.maxs = Vector(area.x, area.y, area.z)
    local slashtrace = util.TraceHull(slash)

    if(slashtrace.Hit) then
        sel:HandleDoor(slashtrace)
        if(SERVER) then
            sound.Play((slashtrace.MatType == MAT_FLESH || slashtrace.MatType == MAT_ALIENFLESH) && sd || sdf, sel:GetPos(), 120, 100, 1)
        end
        if(CLIENT) then return end
        local hpos = slashtrace.HitPos
        local count = 0
        local rad = slash.mins:Distance(slash.maxs)
        local ent = slashtrace.Entity
        local hittarget = false
        local force = av * force
        for k,v in pairs(ents.FindInSphere(hpos, rad * 3)) do -- *3 because z axis check\
            if(count > maxTargets) then continue end
            if(!IsValid(v)) then continue end
            if(v:Health() <= 0) then continue end
            if(CSO:GetDistanceVecNoZAxis(hpos, v) > rad * 1.5) then continue end
            if(v == owner) then continue end
            local d = CSO:DMGInfo(owner, sel, dmg, force, DMG_SLASH, v:GetPos())
            v:SetVelocity(force)
            if(IsValid(v:GetPhysicsObject())) then
                v:GetPhysicsObject():SetVelocity(force)
            end
            v:TakeDamageInfo(d)
            if(v == ent) then
                hittarget = true
            end
            count = count + 1
        end
        if(IsValid(ent) && !hittarget) then
            ent:TakeDamageInfo(CSO:DMGInfo(owner, sel, dmg, force, DMG_SLASH, ent:GetPos()))
        end
    end
end

function CSO:CurveTracer(owner, origin, target, trName, sel, dirScale, upordown, uRand)
    local dirRand = math.random(0, 1)
    if(dirRand == 0) then dirRand = -1 end
    local dst = origin:Distance(target)
    local dst2x = dst / math.random(1.5, 3)

    local mAngle = (target - origin):Angle()
    local zRand = Vector(0, 0, dst2x * math.random(0.1, 0.2))

    if(upordown == "down") then
        zRand = zRand * -1
    elseif(upordown == "rand") then
        zRand = zRand * dirRand
    end

    local midPT = origin + (mAngle:Forward() * dst2x) + (mAngle + Angle(0, math.random(75, 105) * dirRand, 0)):Forward() * dst2x * dirScale + zRand

    local curveP1 = origin
    local curveP2 = midPT
    local curveP3 = target

    local e = EffectData()
        e:SetStart(curveP1)
        e:SetEntity(sel)
        e:SetOrigin(curveP2)
        e:SetAttachment(sel:GetMuzzleAttachment())
        util.Effect(trName, e)
        e:SetEntity(nil)
        e:SetStart(curveP2)
        e:SetOrigin(curveP3)
        util.Effect(trName, e)
end

if(SERVER) then
    util.AddNetworkString("CSO_WeaponHitEvent")
    function CSO:StartHitEvent(sel, ent)
        if(sel.CSO_OnHit == nil || !IsValid(sel.Owner) || !sel.Owner:IsPlayer()) then return end
        sel.CSO_OnHit(sel, ent)
        sel:CallOnClient("CSO_OnHit", ent:EntIndex())
    end

    local nodmg = {
        ["bouncer_pellets"] = true,
        ["needler_nails"] = true,
        ["drill_entity"] = true,
        ["cso_arrow"] = true,
    }
    hook.Add("EntityTakeDamage", "CSO_EntityTakeDamage", function(target, dmginfo)
        local attacker = dmginfo:GetAttacker()
        if(!IsValid(attacker)) then return end
        if(nodmg[attacker:GetClass()] == nil) then return end
        if(!IsValid(attacker:GetOwner()) || !IsValid(attacker:GetOwner():GetActiveWeapon()) || attacker.IgnoreDamage) then return end
        local d = dmginfo
            d:SetAttacker(attacker:GetOwner())
            d:SetInflictor(attacker:GetOwner():GetActiveWeapon())
            d:SetDamage(attacker.HitDamage)
            target:TakeDamageInfo(d)
        return true
    end)

    function CSO:ApplyStun(ent, time, strength)
        if(ent.CSO_ImmunityToStun) then return end
        ent.CSO_StunTime = CurTime() + time
        ent.CSO_TargetStunTime = time
        ent.CSO_StunStrength = strength
    end

    function CSO:ApplyStunVariables(v)
        if(!v:IsPlayer() && !v:IsNPC()) then
            v.CSO_ImmunityToStun = true
            return
        end
        v.CSO_Stunable = true
        v.CSO_StunTime = -1
        v.CSO_TargetStunTime = -1
        v.CSO_StunStrength = 1
    end

    hook.Add("Think", "CSO_StunAndKnockback", function()
        for k,v in pairs(ents.GetAll()) do
            if(!IsValid(v)) then continue end
            if(v.CSO_ImmunityToStun) then continue end
            if(v.CSO_Stunable == nil) then
                CSO:ApplyStunVariables(v)
                 continue
             end
            if(v.CSO_StunTime < CurTime()) then continue end
            local x = (v.CSO_StunTime - CurTime())
            if(x < 0) then continue end
            local stunScale = math.Clamp(v.CSO_StunStrength * (v.CSO_StunStrength / (v.CSO_TargetStunTime / x)), 0, 1.5) -- So velocity won't freak out
            local vel = v:GetVelocity()
            local nVel = Vector(vel.x, vel.y, 0)
            if(v:IsPlayer()) then
                v:SetVelocity(-(nVel * stunScale))
            else
                if(v:IsNPC()) then
                    local vel = v:GetMoveVelocity()
                    local nVel = Vector(vel.x, vel.y, 0)
                    v:SetMoveVelocity(-(nVel * stunScale * 0.1))
                end
            end
        end
    end)
end

if(CLIENT) then
    local keys = {
        NO_ATTACK = 1, -- This is pointless but im still adding it
        NO_JUMP = 2,
        NO_DUCK = 4,
        NO_FORWARD = 8,
        NO_BACK = 16,
        NO_USE = 32,
        NO_LEFT = 128,
        NO_RIGHT = 256,
        NO_MOVELEFT = 512,
        NO_MOVERIGHT = 1024,
        NO_ATTACK2 = 2048,
        NO_RUN = 4096,
        NO_RELOAD = 8192,
        NO_SPRINT = 131072,
    }
    hook.Add("CreateMove", "TFA_CSO_MovementModifier", function(cmd)
        local wep = LocalPlayer():GetActiveWeapon()
        if(!IsValid(wep)) then return end
        for k,v in pairs(keys) do
            if(wep[k]) then
                cmd:RemoveKey(v)
            end
        end
    end)
end