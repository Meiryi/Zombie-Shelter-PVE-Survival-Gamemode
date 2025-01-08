--[[
ZShelter.Keybinds = {
	["BuildMenu"] = 12,
	["SkillMenu"] = 24,
	["ConfigMenu"] = 97,
	["Ready"] = 95,
	["GameUI"] = 93,
	["Skill"] = 91,
}
]]

function ZShelter.WriteKeybind(func, key)
	ZShelter.Keybinds[func] = key
	file.Write("zombie shelter v2/keybinds.txt", util.TableToJSON(ZShelter.Keybinds))
end

function ZShelter.ReadKeybinds()
	local version = file.Read("zombie shelter v2/keyversion.txt", "DATA")
	local keybinds = file.Read("zombie shelter v2/keybinds.txt", "DATA")
	if(!version || version != ZShelter.KeybindVersion) then
		print("Outdated keybind version, writing new keybinds")
		ZShelter.WriteDefaultKeybinds()
		file.Write("zombie shelter v2/keyversion.txt", ZShelter.KeybindVersion)
	end

	if(keybinds) then
		ZShelter.Keybinds = util.JSONToTable(keybinds)
	else
		ZShelter.WriteDefaultKeybinds()
	end
end

function ZShelter.WriteDefaultKeybinds()
	file.Write("zombie shelter v2/keybinds.txt", util.TableToJSON({
		["BuildMenu"] = 12,
		["SkillMenu"] = 24,
		["ConfigMenu"] = 97,
		["DropGun"] = 17,
		["Ready"] = 95,
		["GameUI"] = 93,
		["Skill"] = 92,
	}))
end

ZShelter.ReadKeybinds()