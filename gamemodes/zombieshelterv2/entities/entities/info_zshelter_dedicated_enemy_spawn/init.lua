ENT.Type = "point"
ENT.ShelterIndex = -1

function ENT:Initialize()
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if(key == "shelterindex") then
		self.ShelterIndex = tonumber(value)
	end
end