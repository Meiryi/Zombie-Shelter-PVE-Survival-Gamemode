ENT.Base = "base_ai" 
ENT.Type = "ai"

if(CLIENT) then
	function ENT:Initialize()
		self:SetModelScale(0.01, 0)
	end
	function ENT:RenderOverride()
		return
	end
end