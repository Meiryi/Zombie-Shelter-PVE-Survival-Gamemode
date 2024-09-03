ENT.Type = "point"

function ENT:Initialize()
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if(key == "health") then
		self.iHealth = value
	end
end