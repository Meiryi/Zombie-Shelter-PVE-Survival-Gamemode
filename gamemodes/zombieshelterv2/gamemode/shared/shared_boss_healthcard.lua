ZShelter.BossHealthCards = {}
ZShelter.RegisteredBossClasses = {}
ZShelter.BlacklistClasses = {
	npc_vj_zshelter_heavy_boss = true,
}

function ZShelter.RegisterBossHealthCard(class, path)
	ZShelter.BossHealthCards[class] = Material(path, "noclamp smooth")
	if(!ZShelter.BlacklistClasses[class]) then
		ZShelter.RegisteredBossClasses[class] = true
	end
end

ZShelter.RegisterBossHealthCard("npc_vj_zshelter_heavy_boss", "zsh/healthbar/juggernaut_msg.png")
ZShelter.RegisterBossHealthCard("npc_vj_zshelter_boss_ampsuit", "zsh/healthbar/ampsuit_msg.png")
ZShelter.RegisterBossHealthCard("npc_vj_zshelter_boss_fallen_titan", "zsh/healthbar/fallen_titan_msg.png")
ZShelter.RegisterBossHealthCard("npc_vj_zshelter_boss_oberon", "zsh/healthbar/oberon_msg.png")
ZShelter.RegisterBossHealthCard("npc_vj_zshelter_boss_prototype_phobos", "zsh/healthbar/phobos_msg.png")
ZShelter.RegisterBossHealthCard("npc_vj_zshelter_boss_prototype_phobos_siege", "zsh/healthbar/seizetypephobos_msg.png")