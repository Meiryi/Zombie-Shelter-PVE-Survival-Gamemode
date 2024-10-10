hook.Add("CreateMove", "ZShelter_CreateMove", function(cmd)
	local ply = LocalPlayer()
	if(ply.Callbacks && ply.Callbacks.CreateMove) then
		for k,v in pairs(ply.Callbacks.CreateMove) do
			v(ply, cmd)
		end
	end
end)