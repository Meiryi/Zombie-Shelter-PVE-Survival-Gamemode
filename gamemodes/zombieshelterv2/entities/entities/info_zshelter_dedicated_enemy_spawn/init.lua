ENT.Type = "point"

function ENT:Initialize()
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if(key == "day") then
		self.day = tonumber(value)
	end
	if(key == "speed") then
		self.pvel = tonumber(value)
	end
end