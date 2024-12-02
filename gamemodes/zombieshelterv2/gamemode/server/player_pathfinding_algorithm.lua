util.AddNetworkString("ZShelter_PathFinder_GetPath")
util.AddNetworkString("ZShelter_AFK_Sync")

local tracingfunc = function(a, b, ply)
	local ret = util.TraceEntity({
		start = a,
		endpos = b,
		filter = function(ent)
			return (ent.IsPlayerBarricade || ent.IsShelter || ent.IsBarricade)
		end,
	}, ply)
	return ret
end

local function get_side(a, b)

end

local bounds = Vector(4, 4, 4)
local angle_offset = Angle(0, 0, 0)
local navmesh_offset = Vector(0, 0, 8)
local offsetsize = 32
local tolerance = 16
local overlayLife = 0
function ZShelter.GetPath(player, start, goal)
	local startnav = navmesh.GetNearestNavArea(start)
	local goalnav = navmesh.GetNearestNavArea(goal)
	if(!startnav || !goalnav) then return false end

	if(startnav == goalnav) then
		return {startnav:GetClosestPointOnArea(start), goal}
	end

	local navs = {}
	local cameFrom = {}

	startnav:ClearSearchLists()
	startnav:AddToOpenList()
	startnav:SetCostSoFar(0)
	startnav:SetTotalCost(heuristic_cost_estimate(startnav, goalnav))
	startnav:UpdateOnOpenList()

	local first = true
	while(!startnav:IsOpenListEmpty()) do
		local current = startnav:PopOpenList()
		if(current == goalnav) then
			navs = reconstruct_path(cameFrom, current)
			break
		end

		current:AddToClosedList()

		local currentpos = current:GetCenter() + navmesh_offset
		if(current == startnav) then
			currentpos = startnav:GetClosestPointOnArea(player:GetPos())
		end
		for _, nav in ipairs(current:GetAdjacentAreas()) do

			local newcost = current:GetCostSoFar() + heuristic_cost_estimate(current, nav)

			if((nav:IsOpen() || nav:IsClosed()) && newcost >= nav:GetCostSoFar()) then
				continue
			end

			nav:SetCostSoFar(newcost)
			nav:SetTotalCost(newcost + heuristic_cost_estimate(nav, goalnav))
			if(nav:IsClosed()) then
				nav:RemoveFromClosedList()
			end

			if(nav:IsOpen()) then
				nav:UpdateOnOpenList()
			else
				nav:AddToOpenList()
			end

			cameFrom[nav:GetID()] = current:GetID()
		end
	end

	local prev = nil
	local ret = {}
	for _, nav in pairs(navs) do
		local vec = nav:GetCenter()
		if(prev) then
			debugoverlay.Line(prev, vec, overlayLife, Color(255, 255, 255), true)
		end
		table.insert(ret, vec)
		prev = vec
	end
	ret = table.Reverse(ret)
	table.insert(ret, goal)
	return ret
end

function heuristic_cost_estimate(start, goal)
	return start:GetCenter():Distance(goal:GetCenter())
end

function reconstruct_path(cameFrom, current)
	local total_path = {current}

	current = current:GetID()
	while(cameFrom[current]) do
		current = cameFrom[current]
		table.insert(total_path, navmesh.GetNavAreaByID(current))
	end
	return total_path
end

net.Receive("ZShelter_PathFinder_GetPath", function(len, ply)
	local goal = net.ReadVector()
	local path = ZShelter.GetPath(ply, ply:GetPos(), goal)
	if(isbool(path)) then return end
	if(!path) then return end

	local data, len = ZShelter.CompressTable(path)
	net.Start("ZShelter_PathFinder_GetPath")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.Send(ply)
end)

net.Receive("ZShelter_AFK_Sync", function(len, ply)
	local afk = net.ReadBool()
	ply:SetNWBool("ZShelter_AFK", afk)
	ply.AFKing = afk

	if(!afk) then
		ply:RemoveFlags(FL_NOTARGET)
	end
end)