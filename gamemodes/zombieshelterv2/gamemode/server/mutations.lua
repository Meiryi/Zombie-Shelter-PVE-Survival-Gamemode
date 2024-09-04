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

ZShelter.Mutations = {}
ZShelter.MutationList = {}

function ZShelter.RegisterMutation(mutation)
	ZShelter.Mutations[mutation.Name] = mutation

	table.insert(ZShelter.MutationList, mutation.Name)
end

function ZShelter.ApplyMutationIndex(index, mutation)
	ZShelter.ApplyMutation(Entity(index), mutation)
end

function ZShelter.ApplyMutation(ent, mutation)
	local m = ZShelter.Mutations[mutation]
	local e = ent
	if(!m) then return end

	if(m.Color) then
		e:SetRenderMode(RENDERMODE_TRANSCOLOR)
		e:SetColor(m.Color)
	end
	if(m.Variables) then
		for k,v in pairs(m.Variables) do
			e[k] = v
		end
	end
	if(m.Callbacks) then
		if(m.Callbacks.OnApplyMutation) then
			if(m.Callbacks.OnApplyMutation(e)) then return end
		end
		for k,v in pairs(m.Callbacks) do
			local o = e[k]
			e["o"..k] = o
			e[k] = v
		end
	end

	ent.HasMutation = true
end

hook.Add("OnEntityCreated", "ZShelter-CreationCheck", function(ent)
	if(ent.IsVJBaseSNPC && !ent.IsBuilding && !ent.IsDefaultBase) then
		ent.StuckTimer = 0
    	ent.OverrideMove = function(self, finv)
			if(ent.StuckTimer < CurTime()) then
				if(!self:IsMoving()) then
					local tr = {
						start = ent:GetPos(),
						endpos = ent:GetPos(),
						mins = ent:OBBMins(),
						maxs = ent:OBBMaxs(),
						filter = ent,
					}
					local ret = util.TraceHull(tr).Entity
					if(IsValid(ret.Entity) && !ret.Entity.IsBuilding) then
						ent:SetAngles(Angle(0, math.random(-180, 180), 0))
						ent:SetLocalVelocity(ent:GetMoveVelocity() + ent:GetAngles():Forward() * 1500)
						ent:VJ_ACT_PLAYACTIVITY(ent.AnimTbl_Run, true, 0.25, false, 0)
						ent.LastStuckTime = CurTime() + 3
						ent.NextChaseTime = CurTime() + 0.55
					end
				end
				ent.StuckTimer = CurTime() + 1
	    	end
	    end
    end
	ent.DeathCorpseCollisionType = 0
	ent.AllowPrintingInChat = false -- Disable following crap
end)

function ZShelter.LoadMutations()
	ZShelter.Mutations = {}
	local fn = file.Find(ZShelter.BasePath.."mutations/*", "LUA")

	for k,v in pairs(fn) do
		include(ZShelter.BasePath.."mutations/"..v)
	end
end

ZShelter.LoadMutations()

concommand.Add("zshelter_debug_reload_mutations", function(ply, cmd, args)
	ZShelter.Mutations = {}
	ZShelter.MutationList = {}
	ZShelter.LoadMutations()
end)