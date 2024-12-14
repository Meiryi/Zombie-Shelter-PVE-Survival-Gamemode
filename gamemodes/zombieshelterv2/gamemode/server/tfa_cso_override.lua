-- Exact copy of original code, did some changes to make it less overpowered
-- But jesus christ, this is a mess

CSO_DualswordTable = CSO_DualswordTable || {}
CSO_Dualsword_Effect_Poke = {}
CSO_Dualsword_Effect_Swing = {}
CSO_Dualsword_Effect_Start = {}
CSO_Dualsword_Effect_End = {}

function ShouldAddToTable(ply)
	for k,v in next, CSO_DualswordTable do
		if(v["ply"] == ply) then return end
	end
	table.insert(CSO_DualswordTable, {
		["ply"] = ply,
		["last.swordtype"] = 0,
		["skill.started"] = false,
		["skill.wtype"] = 0,
		["skill.delay"] = 0,
		["skill.interval"] = 0,
		["skill.swing.interval"] = 0,
		["skill.nextsequence"] = false,
		["skill.cached.seq"] = 0,
		["skill.state"] = 0,
		["skill.length"] = 0,
		["skill.cachedwep"] = nil,
		["skill.attackinterval"] = 0,
	})
end

function IsHoldingDualSword(ply)
	local pWep = ply:GetActiveWeapon()
	if(!IsValid(pWep)) then return false end
	local wList = {
		["tfa_cso_budgetsword"] = true,
		["tfa_cso_dualsword"] = true,
		["tfa_zsh_cso_dualsword"] = true,
		["tfa_cso_dualsword_rb"] = true,
	}
	return wList[pWep:GetClass()]
end

function GetSwordType(ply)
	local pWep = ply:GetActiveWeapon()
	if(!IsValid(pWep)) then return false end
	local wList = {
		["tfa_cso_budgetsword"] = 0,
		["tfa_cso_dualsword"] = 1,
		["tfa_zsh_cso_dualsword"] = 1,
		["tfa_cso_dualsword_rb"] = 2,
	}
	return wList[pWep:GetClass()]
end

function GetSkillLength(ply)
	local pWep = ply:GetActiveWeapon()
	if(!IsValid(pWep)) then return false end
    local wList = {
        ["tfa_cso_budgetsword"] = 8.3,
        ["tfa_cso_dualsword"] = 12.55,
        ["tfa_zsh_cso_dualsword"] = 12.55,
        ["tfa_cso_dualsword_rb"] = 12.55,
    }
	return wList[pWep:GetClass()]
end

function GetSwordDamage(ply)
	local pWep = ply:GetActiveWeapon()
	if(!IsValid(pWep)) then return false end
	local wList = {
		["tfa_cso_budgetsword"] = GetConVar("sv_tfa_cso_budgetsword_skill_damage"):GetInt(),
		["tfa_cso_dualsword"] = GetConVar("sv_tfa_cso_dualsword_skill_damage"):GetInt(),
		["tfa_zsh_cso_dualsword"] = 40,
		["tfa_cso_dualsword_rb"] = GetConVar("sv_tfa_cso_dualsword_rb_skill_damage"):GetInt(),
	}
	return wList[pWep:GetClass()]
end

function GetSwordModel__(ply)
	local pWep = ply:GetActiveWeapon()
	if(!IsValid(pWep)) then return false end
	local wList = {
		["tfa_cso_budgetsword"] = "models/effects/tfa_cso/dualswordm_skill.mdl",
		["tfa_cso_dualsword"] = "models/effects/tfa_cso/dualsword_skill.mdl",
		["tfa_zsh_cso_dualsword"] = "models/effects/tfa_cso/dualsword_skill.mdl",
		["tfa_cso_dualsword_rb"] = "models/effects/tfa_cso/dualswordpaintgs18_skill.mdl",
	}
	return wList[pWep:GetClass()]
end

function GetSwordModel_Class(str)
	local wList = {
		["tfa_cso_budgetsword"] = "models/effects/tfa_cso/dualswordm_skill.mdl",
		["tfa_cso_dualsword"] = "models/effects/tfa_cso/dualsword_skill.mdl",
		["tfa_zsh_cso_dualsword"] = "models/effects/tfa_cso/dualsword_skill.mdl",
		["tfa_cso_dualsword_rb"] = "models/effects/tfa_cso/dualswordpaintgs18_skill.mdl",
	}
	return wList[str]
end

function GetSwordModel(ply, stype)
	local pWep = ply:GetActiveWeapon()
	if(!IsValid(pWep)) then return false end
	local wList = {
		["tfa_cso_budgetsword"] = {
			[1] = "models/effects/tfa_cso/dualswordm_skillfx2.mdl",
			[2] = "models/effects/tfa_cso/dualswordm_skillfx1.mdl",
		},
		["tfa_cso_dualsword"] = {
			[1] = "models/effects/tfa_cso/dualsword_skillfx2.mdl",
			[2] = "models/effects/tfa_cso/dualsword_skillfx1.mdl",
		},
		["tfa_zsh_cso_dualsword"] = {
			[1] = "models/effects/tfa_cso/dualsword_skillfx2.mdl",
			[2] = "models/effects/tfa_cso/dualsword_skillfx1.mdl",
		},
		["tfa_cso_dualsword_rb"] = {
			[1] = "models/effects/tfa_cso/dualswordpaintgs18_skillfx2.mdl",
			[2] = "models/effects/tfa_cso/dualswordpaintgs18_skillfx1.mdl",
		},
	}
	return wList[pWep:GetClass()][stype]
end

function GetSwordModel_(idx, stype)
	local wList = {
		["tfa_cso_budgetsword"] = {
			[1] = "models/effects/tfa_cso/dualswordm_skillfx2.mdl",
			[2] = "models/effects/tfa_cso/dualswordm_skillfx1.mdl",
		},
		["tfa_cso_dualsword"] = {
			[1] = "models/effects/tfa_cso/dualsword_skillfx2.mdl",
			[2] = "models/effects/tfa_cso/dualsword_skillfx1.mdl",
		},
		["tfa_zsh_cso_dualsword"] = {
			[1] = "models/effects/tfa_cso/dualsword_skillfx2.mdl",
			[2] = "models/effects/tfa_cso/dualsword_skillfx1.mdl",
		},
		["tfa_cso_dualsword_rb"] = {
			[1] = "models/effects/tfa_cso/dualswordpaintgs18_skillfx2.mdl",
			[2] = "models/effects/tfa_cso/dualswordpaintgs18_skillfx1.mdl",
		},
	}
	return wList[idx][stype]
end

function GetSwordColor(ply, stype)
	local pWep = ply:GetActiveWeapon()
	if(!IsValid(pWep)) then return false end
	local wList = {
		["tfa_cso_budgetsword"] = {
			[1] = Color(133, 133, 133, 255),
			[2] = Color(133, 133, 133, 255),
		},
		["tfa_cso_dualsword"] = {
			[1] = Color(255, 226, 97, 255),
			[2] = Color(82, 183, 255, 255),
		},
		["tfa_cso_dualsword_rb"] = {
			[1] = Color(252, 97, 255, 255),
			[2] = Color(100, 97, 255, 255),
		},
	}
	return wList[pWep:GetClass()][stype]
end

hook.Add( "Tick", "CSO_RunSkill", function(ply)

	for k,v in next, CSO_Dualsword_Effect_Start do
		if(v["killtime"] < CurTime()) then
			if(IsValid(v["sword_ent1"])) then v["sword_ent1"]:Remove() end
			table.remove(CSO_Dualsword_Effect_Start, k)
		end
		local pPos = v["ply"]:GetPos() + Vector(0, 0, 10)
		if(!v["spawned"]) then
			if(v["sword_ent1"] == nil) then
				v["sword_ent1"] = ents.Create("prop_dynamic")
					v["sword_ent1"]:SetPos(pPos)
					v["sword_ent1"]:SetAngles(Angle(0, 0, 0))
					v["sword_ent1"]:SetModel(GetSwordModel__(v["ply"]))
					v["sword_ent1"]:Spawn()
					v["sword_ent1"]:ResetSequenceInfo()
					v["sword_ent1"]:SetSequence( "exshot" )
					v["sword_ent1"]:SetPlaybackRate(1)
					if(GetSwordType(v["ply"]) == 0) then
						v["sword_ent1"]:SetPlaybackRate(1.5)
					end
			end
			v["spawned"] = true
		else
			if(IsValid(v["sword_ent1"])) then
				v["sword_ent1"]:SetPos(pPos)
			end
		end
	end

	for k,v in next, CSO_Dualsword_Effect_End do
		if(v["killtime"] < CurTime()) then
			if(IsValid(v["sword_ent1"])) then v["sword_ent1"]:Remove() end
			table.remove(CSO_Dualsword_Effect_End, k)
		end
		local pPos = v["ply"]:GetPos() + Vector(0, 0, 20)
		if(!v["spawned"]) then
			sound.Play("weapons/tfa_cso/dual_sword/end.wav", v["ply"]:GetPos(), 100, 100, 1)
			if(v["sword_ent1"] == nil) then
				v["sword_ent1"] = ents.Create("prop_dynamic")
				v["sword_ent1"]:SetPos(pPos)
				v["sword_ent1"]:SetAngles(Angle(0, 0, 0))
				if(!v["earlyend"]) then
					v["sword_ent1"]:SetModel(GetSwordModel__(v["ply"]))
				else
					v["sword_ent1"]:SetModel(GetSwordModel_Class(v["type"]))
				end
				v["sword_ent1"]:Spawn()
				v["sword_ent1"]:ResetSequenceInfo()
				v["sword_ent1"]:SetSequence( "exend" )
				v["sword_ent1"]:SetPlaybackRate(1)
					if(GetSwordType(v["ply"]) == 0) then
						v["sword_ent1"]:SetPlaybackRate(1.5)
					end
			end
			v["spawned"] = true
		else
			if(IsValid(v["sword_ent1"])) then
				v["sword_ent1"]:SetPos(pPos)
			end
		end
	end

	for k,v in next, CSO_Dualsword_Effect_Poke do
		if(v["killtime"] < CurTime()) then
			if(IsValid(v["sword_ent"])) then v["sword_ent"]:Remove() end
			table.remove(CSO_Dualsword_Effect_Poke, k)
		end
		if(!v["spawned"]) then
			if(v["sword_ent"] == nil) then
					v["rVec"] = Vector(math.random(-250, 200), math.random(-250, 250), math.random(0, 100))
					v["sword_ent"] = ents.Create("prop_dynamic")
					v["sword_ent"]:SetPos(v["ply"]:GetPos() + v["rVec"])
					v["sword_ent"]:SetAngles(Angle(math.random(-10, 10), math.random(-180, 180), 0))
					v["sword_ent"]:SetModel(GetSwordModel(v["ply"], 1))
					v["sword_ent"]:Spawn()
					v["sword_ent"]:ResetSequenceInfo()
					v["sword_ent"]:SetSequence("idle_skill")
			end
			v["spawned"] = true
		else
			local vPos = v["ply"]:GetPos() + v["rVec"]
			v["dst"] = v["dst"] + 30
			v["sword_ent"]:SetPos(vPos + Angle(v["sword_ent"]:GetAngles().x, v["sword_ent"]:GetAngles().y):Forward() * v["dst"])
		end
	end

	for k,v in next, CSO_Dualsword_Effect_Swing do
		if(v["killtime"] < CurTime()) then
			if(IsValid(v["sword_ent"])) then v["sword_ent"]:Remove() end
			table.remove(CSO_Dualsword_Effect_Swing, k)
		end
		if(!v["spawned"]) then
			if(v["dir"] == 0) then v["dir"] = -1 end
			if(v["sword_ent"] == nil) then
					v["rVec"] = Vector(math.random(-250, 250), math.random(-250, 250), math.random(0, 100))
					v["sword_ent"] = ents.Create("prop_dynamic")
					v["sword_ent"]:SetPos(v["ply"]:GetPos() + v["rVec"])
					v["sword_ent"]:SetAngles(Angle(math.random(-10, 10), math.random(-180, 180), 0))
					v["sword_ent"]:SetModel(GetSwordModel(v["ply"], 2))
					v["sword_ent"]:Spawn()
					v["sword_ent"]:ResetSequenceInfo()
					v["sword_ent"]:SetSequence("idle_skill"..math.random(1, 3))
					v["sword_ent"]:SetPlaybackRate(0.5)
			end
			v["spawned"] = true
		else
			local vPos = v["ply"]:GetPos() + v["rVec"]
			v["sword_ent"]:SetPos(vPos)
		end
	end

	for k,v in next, CSO_DualswordTable do
		if(!IsValid(v["ply"])) then table.remove(CSO_DualswordTable, k)
		else
			if(!v["ply"]:Alive()) then
				v["skill.started"] = false
				v["skill.wtype"] = 0
				v["skill.delay"] = 0
				v["skill.interval"] = 0
				v["skill.swing.interval"] = 0
				continue
			end

			if(!IsHoldingDualSword(v["ply"])) then
				if(v["skill.started"]) then
					table.insert(CSO_Dualsword_Effect_End, {
						["sword_ent1"] = nil,
						["ply"] = v["ply"],
						["spawned"] = false,
						["killtime"] = CurTime() + 1.5,
						["earlyend"] = true,
						["type"] = v["last.swordtype"] ,
					})
					v["skill.started"] = false
				end
				continue
			else
				v["skill.wtype"] = GetSwordType(v["ply"])
				local wep = v["ply"]:GetActiveWeapon()
				local vm = v["ply"]:GetViewModel(0)
				local seq = vm:GetSequence()
				if(!v["skill.started"]) then
					if(seq != 0) then
						if(seq != v["skill.cached.seq"] && v["skill.nextsequence"]) then -- this is where I spent most time to figure out
							if(v["skill.state"] == 10) then
								if(seq == 4) then
									wep.LastSkillTriggeredTime = CurTime() + 40
									wep:SetNWFloat("SkillTriggerTime", wep.LastSkillTriggeredTime)
									wep:SetNextPrimaryFire(CurTime() + 5)
									wep:SetNextSecondaryFire(CurTime() + 5)
									local extratime = 2.2
									if(wep:GetClass() == "tfa_cso_budgetsword") then extratime = 1.5 end
									wep:SetStatusEnd(CurTime() + GetSkillLength(v["ply"]) + extratime)
									timer.Simple(0.15, function()
										wep:SendWeaponAnim(ACT_VM_RECOIL1)
										v["last.swordtype"] = wep:GetClass()
										timer.Simple(0.13, function() sound.Play("weapons/tfa_cso/dual_sword/start.wav", v["ply"]:GetPos(), 100, 100, 1) end)
										v["skill.started"] = true
										v["skill.length"] = CurTime() + GetSkillLength(v["ply"])
										local delay = 1.3
										if(wep:GetClass() == "tfa_cso_budgetsword") then delay = 0.8 end
										v["skill.delay"] = CurTime() + 1.3
										v["skill.started"] = true
										v["skill.state"] = 0
										table.insert(CSO_Dualsword_Effect_Start, {
											["sword_ent1"] = nil,
											["ply"] = v["ply"],
											["spawned"] = false,
											["killtime"] = CurTime() + 1.5,
										})
									end)
								else
									v["skill.state"] = 0
								end
							end
							if(v["skill.state"] == 9) then
								if(seq == 3) then
									v["skill.state"] = 10
								else
									v["skill.state"] = 0
								end
							end
							if(v["skill.state"] == 8) then
								if(seq == 2) then
									v["skill.state"] = 9
								else
									v["skill.state"] = 0
								end
							end
							if(v["skill.state"] == 7) then
								if(seq == 1) then
									v["skill.state"] = 8
								else
									v["skill.state"] = 0
								end
							end
							if(v["skill.state"] == 6) then
								if(seq == 9) then
									v["skill.state"] = 7
								else
									v["skill.state"] = 0
								end
							end
							if(v["skill.state"] == 5) then
								if(seq == 8) then
									v["skill.state"] = 6
								else
									v["skill.state"] = 0
								end
							end
							if(v["skill.state"] == 4) then
								if(seq == 4) then
									v["skill.state"] = 5
								else
									v["skill.state"] = 0
								end
							end
							if(v["skill.state"] == 3) then
								if(seq == 3) then
									v["skill.state"] = 4
								else
									v["skill.state"] = 0
								end
							end
							if(v["skill.state"] == 2) then
								if(seq == 2) then
									v["skill.state"] = 3
								else
									v["skill.state"] = 0
								end
							end
							if(v["skill.state"] == 1) then
								if(seq == 1) then
									v["skill.state"] = 2
								else
									v["skill.state"] = 0
								end
							end
							if(v["skill.state"] == 0) then
								if(seq == 8) then
									v["skill.state"] = 1
								end
							end
							v["skill.nextsequence"] = false
							v["skill.cached.seq"] = seq
						else
							v["skill.nextsequence"] = true
						end
					end
				else
					if(v["skill.delay"] < CurTime()) then
						if(v["skill.length"] > CurTime()) then
							if(v["skill.cachedwep"] != wep) then
								v["skill.started"] = false
								table.insert(CSO_Dualsword_Effect_End, {
									["sword_ent1"] = nil,
									["ply"] = v["ply"],
									["spawned"] = false,
									["killtime"] = CurTime() + 1.5,
									["earlyend"] = true,
									["type"] = v["last.swordtype"] ,
								})
							end
							if(v["skill.interval"] < CurTime()) then
								sound.Play("weapons/tfa_cso/dual_sword/swing_"..math.random(1, 5)..".wav", v["ply"]:GetPos(), 100, 100, 1)
								if(v["skill.attackinterval"] < CurTime()) then
									for x,y in pairs(ents.FindInSphere(v["ply"]:GetPos(), 250)) do
										if(!IsValid(y)) then continue end
										if(y == v["ply"]) then continue end
										if(y:IsRagdoll()) then continue end
										if(y:Health() <= 0) then continue end
										if(y:IsPlayer() && !y:Alive()) then continue end
											local d = DamageInfo()
											d:SetDamage(GetSwordDamage(v["ply"]))
											d:SetDamagePosition(y:GetPos() + Vector(math.random(-16, 16), math.random(-16, 16), math.random(0, 16)))
											d:SetDamageType(4)
											d:SetAttacker(v["ply"])
											d:SetInflictor(v["ply"])
										y:TakeDamageInfo(d)
									end
									v["skill.attackinterval"] = CurTime() + 0.1
								end
								if(v["skill.swing.interval"] < CurTime()) then
									table.insert(CSO_Dualsword_Effect_Swing, {
										["sword_ent"] = nil,
										["spawned"] = false,
										["ply"] = v["ply"],
										["dst"] = 0,
										["yaw"] = 0,
										["dir"] = math.random(0, 1),
										["rVec"] = Vector(0, 0, 0),
										["swingtime"] = CurTime() + 0.2,
										["killtime"] = CurTime() + 0.5,
									})
									v["skill.swing.interval"] = CurTime() + 0.4
								end
								table.insert(CSO_Dualsword_Effect_Poke, {
									["sword_ent"] = nil,
									["spawned"] = false,
									["ply"] = v["ply"],
									["dst"] = 0,
									["rVec"] = Vector(0, 0, 0),
									["killtime"] = CurTime() + 0.45,
								})
								v["skill.interval"] = CurTime() + 0.06
							end
						else
							table.insert(CSO_Dualsword_Effect_End, {
								["sword_ent1"] = nil,
								["ply"] = v["ply"],
								["spawned"] = false,
								["killtime"] = CurTime() + 1.5,
								["earlyend"] = false
							})
							v["skill.started"] = false
						end
					end
				end
				v["skill.cachedwep"] = wep
			end
		end
	end
end)

hook.Add( "PlayerSpawn", "CSO_ApplyTable", function(ply)
	if(!IsValid(ply)) then return end
	ShouldAddToTable(ply)
end)