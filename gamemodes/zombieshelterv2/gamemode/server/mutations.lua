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
	if(ent.IsVJBaseSNPC) then
    	ent.PriorToKilled = VJ_PriorToKilled
    	ent.LastValidTime = 0
    	--[[
    	ent.OverrideMove = function(self, finv)
    		if(ent.IsBuilding) then return end
    		if(self:Health() <= 0) then return end
    		if(self:GetGoalPos() == Vector(0, 0, 0) && IsValid(self:GetEnemy()) && (self.LastValidTime && (CurTime() - self.LastValidTime) > 0.33) && IsValid(ZShelter.Shelter)) then
    			self:SetEnemy(ZShelter.Shelter)
    			self:NavSetGoalPos(ZShelter.Shelter:GetPos())
    			self.LastValidTime = CurTime() + 3
    		else
    			if(self.LastValidTime < CurTime()) then
    				self.LastValidTime = CurTime()
    			end
    		end
    		if(self:GetMoveVelocity():Length2D() <= 0) then
    			if(self.UnStuckTime && self.UnStuckTime < CurTime()) then
	    			local vel = Angle(0, math.random(-180, 180), 0):Forward()
	    			self:SetMoveVelocity(vel * 64)
	    			self:SetLocalVelocity(vel * 550)
    				self.UnStuckTime = CurTime() + 0.5
    			end
    		else
    			self.UnStuckTime = CurTime() + 0.25
    		end
    		if((self.NextCheckStuckTime && self.NextCheckStuckTime > CurTime()) || (self.LastStuckTime && self.LastStuckTime > CurTime())) then return end
    		local mins, maxs = self:GetCollisionBounds()
    		local tr = {
    			start = self:GetPos(),
    			endpos = self:GetPos(),
    			filter = self,
    			mins = mins,
    			maxs = maxs,
    			mask = MASK_SHOT,
    		}
    		local ret = util.TraceHull(tr)
    		if(IsValid(ret.Entity)) then
    			if(ret.Entity.IsBuilding && !ret.Entity.IsTurret && !ret.Entity.IsTrap && !ret.Entity:GetNWBool("IsResource", false) && !ret.Entity.IgnoreCollision) then
    				ret.Entity:SetCollisionGroup(0) -- Fuck VJ Base again
    			end
    			self.LastStuckTime = CurTime() + 5
    		end
    		self.NextCheckStuckTime = CurTime() + 0.33
    	end
    	]]
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