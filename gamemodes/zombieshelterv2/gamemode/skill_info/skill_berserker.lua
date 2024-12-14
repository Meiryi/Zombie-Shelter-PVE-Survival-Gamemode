--[[
	EN :
	Zombie Shelter v2.0 by Meiryi / Meika / Shiro / Shigure
	You SHOULD NOT edit / modify / reupload the codes, it includes editing gamemode's name
	If you have any problems, feel free to contact me on steam, thank you for reading this

	VI:
	Zombie Shelter v2.0 của Meiryi / Meika / Shiro / Shigure
	BẠN KHÔNG NÊN chỉnh sửa / sửa đổi / tải lại các mã, bao gồm cả việc chỉnh sửa tên chế độ chơi. 
	Nếu bạn có bất kỳ vấn đề nào, hãy liên hệ với tôi trên steam, cảm ơn bạn đã đọc điều này

	ZH-TW :
	夜襲生存戰 v2.0 by Meiryi  / Meika / Shiro / Shigure
	任何的修改是不被允許的 (包括模式的名稱)，有問題請在Steam上聯絡我, 謝謝!
	
	ZH-CN :
	昼夜求生 v2.0 by Meiryi  / Meika / Shiro / Shigure
	任何形式的编辑是不被允许的 (包括模式的名称), 若有问题请在Steam上联络我
	
	FR :
	Zombie Shelter v2.0 par Meiryi / Meika / Shiro / Shigure
	Vous NE DEVEZ PAS éditer / modifier / reposter le code du jeu, cela inclut aussi le nom du mode de jeu.
	Si vous avez le moindre problème, n'hésitez pas à me contacter sur Steam, merci d'avoir lu

	TR :
	Meiryi / Meika / Shiro / Shigure tarafından Zombie Shelter v2.0
	Oyun modunun ismini ve kodunu ASLA değiştirip düzenleyip yeniden yükleyemezsiniz.
	Eğer bir problemle karşılaşırsanız, benimle Steam üzerinden iletişime geçebilirsiniz. Bu metni okuduğunuz için teşekkürler.

	BG :
	Zombie Shelter v2.0 от Meiryi / Meika / Shiro / Shigure
	Вие НЕ ТРЯБВА да редактирате / модифицирате / качвате кодовете, включащи генерирането на игровия режим
	Ако имате проблеми, можете да ми се обадите в стийм, благодаря че прочетохте това съобщение
]]

ZShelter.AddInfo("Blazing Slash", {
	title = {
		["en"] = "Blazing Slash",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "熾焰斬擊",
		["zh-CN"] = "炽焰斩击",
		["ru"] = "",
	},
	desc = {
		["en"] = "Attacking with melee weapon will summon flaming blade that dealing 1200 damage to all nearby enemies\nEffect can stack up to 3 times\nHold both left and right mouse button to active the skill",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "使用近戰武器攻擊將召喚火焰對附近敵人造成1200點傷害\n效果最多可疊加3次\n同時按住左右鍵使用技能",
		["zh-CN"] = "使用近战武器攻击将召唤火焰对附近敌人造成1200点伤害\n效果最多可叠加3次\n同时按住左右键使用技能",
		["ru"] = "",
	}
})

ZShelter.AddInfo("Godmode", {
	title = {
		["en"] = "Godmode",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "無敵",
		["zh-CN"] = "无敌",
		["ru"] = "",
	},
	desc = {
		["en"] = "Gain 15 seconds godmode, reflecting 1000% damage to attacker",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "獲得15秒無敵, 反彈1000%傷害給攻擊者",
		["zh-CN"] = "获得15秒无敌, 反弹1000%伤害给攻击者",
		["ru"] = "",
	}
})

ZShelter.AddInfo("SanityRegen", {
	title = {
		["en"] = "Sanity Recovering",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "理智回復",
		["zh-CN"] = "理智回复",
		["ru"] = "",
	},
	desc = {
		["en"] = "Recovers sanity when killing enemies, +1.5 per upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "殺死敵人時回復理智, 每升級一次增加 1.5",
		["zh-CN"] = "杀死敌人时回复理智, 每升级一次增加 1.5",
		["ru"] = "",
	}
})

ZShelter.AddInfo("Melee Damage Boost1x", {
	title = {
		["en"] = "Melee Damage Boost",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "提升近戰武器傷害",
		["zh-CN"] = "提升近战武器伤害",
		["ru"] = "",
	},
	desc = {
		["en"] = "Increase melee weapon damage, +30% per upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "提升近戰武器傷害, 每升級一次增加 30%",
		["zh-CN"] = "提升近战武器伤害，每升级一次增加 30%",
		["ru"] = "",
	}
})

ZShelter.AddInfo("Melee Damage Boost2x", {
	title = {
		["en"] = "Melee Damage Boost",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "提升近戰武器傷害",
		["zh-CN"] = "提升近战武器伤害",
		["ru"] = "",
	},
	desc = {
		["en"] = "Increase melee weapon damage, +50% per upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "提升近戰武器傷害, 每升級一次增加 50%",
		["zh-CN"] = "提升近战武器伤害，每升级一次增加 50%",
		["ru"] = "",
	}
})

ZShelter.AddInfo("Melee Damage Boost3x", {
	title = {
		["en"] = "Melee Damage Boost",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "提升近戰武器傷害",
		["zh-CN"] = "提升近战武器伤害",
		["ru"] = "",
	},
	desc = {
		["en"] = "Increase melee weapon damage, +40% per upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "提升近戰武器傷害, 每升級一次增加 40%",
		["zh-CN"] = "提升近战武器伤害，每升级一次增加 40%",
		["ru"] = "",
	}
})

ZShelter.AddInfo("Battle Knife Upgrade", {
	title = {
		["en"] = "Battle Knife Upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "長刃",
		["zh-CN"] = "長刃",
		["ru"] = "",
	},
	desc = {
		["en"] = "Replace melee weapon with battle knife, able to hit multiple enemies",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "將近戰武器替換成長刃, 可同時攻擊多個敵人",
		["zh-CN"] = "将近战武器替换成长刃, 可同时攻击多个敌人",
		["ru"] = "",
	}
})

ZShelter.AddInfo("Damage Evasion", {
	title = {
		["en"] = "Damage Evasion",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "傷害閃避",
		["zh-CN"] = "伤害闪避",
		["ru"] = "",
	},
	desc = {
		["en"] = "Small chance to dodge a attack, +10% chance per upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "小機率閃躲攻擊, 每升級一次增加 10%",
		["zh-CN"] = "小机率闪躲攻击, 每升级一次增加 10%",
		["ru"] = "",
	}
})

ZShelter.AddInfo("Silence", {
	title = {
		["en"] = "Silence",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "沉默",
		["zh-CN"] = "沉默",
		["ru"] = "",
	},
	desc = {
		["en"] = "Silence every enemies you hit with melee weapon\nSilenced enemy cannot use special ability (Excluding bosses)\nApply a -25% attack damage debuff (Unstackable)\n+1s silence debuff per upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "被沉默的敵人無法使用特殊能力 (不包括Boss), 並加上一個 -25% 攻擊力 Debuff (不可疊加)\n每升級一次增加1秒的沉默",
		["zh-CN"] = "被沉默的敌人无法使用特殊能力 (不包括Boss), 并加上一个 -25% 攻击力 Debuff (不可叠加)\n每升級一次增加1秒的沉默",
		["ru"] = "",
	}
})

ZShelter.AddInfo("Parry", {
	title = {
		["en"] = "Parry",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "格擋",
		["zh-CN"] = "格挡",
		["ru"] = "",
	},
	desc = {
		["en"] = "Attacking with melee weapon gives a 0.25s parry effect\nparry effect disappears after taking any damage or timed out\n+0.15s Parry time per upgrade\n-0.25s Cooldown per upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "使用近戰武器攻擊可獲得0.25秒的格擋效果, 格擋效果在受到任何攻擊或者時效結束後消失\n每升級一次增加0.15秒的格擋時間\n每升級一次減少0.25秒冷卻",
		["zh-CN"] = "使用近战武器攻击可获得0.25秒的格挡效果, 格挡效果在受到任何攻击或者时效结束后消失\n每升级一次增加0.15秒的格挡时间\n每升级一次减少0.25秒冷却",
		["ru"] = "",
	}
})

ZShelter.AddInfo("Flash Slash", {
	title = {
		["en"] = "Flash Slash",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "閃現",
		["zh-CN"] = "闪现",
		["ru"] = "",
	},
	desc = {
		["en"] = "Teleport to the position player is aiming at and deal 1000 damage to all enemies on the path\nGain 3 seconds of invincibility after teleporting",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "閃現到瞄準的地方並對路徑上的敵人造成1000點傷害, 閃現後獲得3秒的無敵時間",
		["zh-CN"] = "閃現到瞄準的地方並對路徑上的敵人造成1000點傷害, 閃現後獲得3秒的無敵時間",
		["ru"] = "",
	}
})