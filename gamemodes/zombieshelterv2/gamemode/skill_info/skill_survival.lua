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
	
	FR :
	Zombie Shelter v2.0 par Meiryi / Meika / Shiro / Shigure
	Vous NE DEVEZ PAS éditer / modifier / reposter le code du jeu, cela inclut aussi le nom du mode de jeu.
	Si vous avez le moindre problème, n'hésitez pas à me contacter sur Steam, merci d'avoir lu

	TR :
	Meiryi / Meika / Shiro / Shigure tarafından Zombie Shelter v2.0
	Oyun modunun ismini ve kodunu ASLA değiştirip düzenleyip yeniden yükleyemezsiniz.
	Eğer bir problemle karşılaşırsanız, benimle Steam üzerinden iletişime geçebilirsiniz. Bu metni okuduğunuz için teşekkürler.
]]

ZShelter.AddInfo("Speed Boost", {
	title = {
		["en"] = "Speed Boost",
		["fr"] = "Sprint",
		["tr"] = "Hareket Hızı",
		["zh-TW"] = "提升移動速度",
		["zh-CN"] = "速度提升",
		["ru"] = "Увеличение скорости",
	},
	desc = {
		["en"] = "Increases movement speed, +20% per upgrade",
		["fr"] = "Augmente votre vitesse de déplacement, +20% par amélioration",
		["tr"] = "Hareket hızını artırır, yükseltme başına +%20",
		["zh-TW"] = "提升移動速度, 每升級一次增加 20%",
		["zh-CN"] = "提升移动速度, 每升一级增加 20%",
		["ru"] = "Увеличивает скорость передвижения, +20% за улучшение",
	}
})
ZShelter.AddInfo("Sanity Boost", {
	title = {
		["en"] = "Sanity Boost",
		["fr"] = "Santé Mentale Renforcée",
		["tr"] = "Akıl Sağlığı",
		["zh-TW"] = "增強理智",
		["zh-CN"] = "理智增强",
		["ru"] = "Укрепление рассудка",
	},
	desc = {
		["en"] = "Decreases sanity drain rate, -15% per upgrade",
		["fr"] = "Réduit la vitesse d'épuisement de votre santé mentale, -15% par amélioration",
		["tr"] = "Akıl sağlığı azalma oranını azaltır, yükseltme başına -%15",
		["zh-TW"] = "減少理智消耗, 每升級一次減少 15%",
		["zh-CN"] = "减少理智消耗, 每升一级减少 15%",
		["ru"] = "Уменьшает скорость потери рассудка, -15% за улучшение",
	}
})
ZShelter.AddInfo("Resource Rader", {
	title = {
		["en"] = "Resource Radar",
		["fr"] = "Radar à Ressources",
		["tr"] = "Kaynak Radarı",
		["zh-TW"] = "資源雷達",
		["zh-CN"] = "资源雷达",
		["ru"] = "Радар ресурсов",
	},
	desc = {
		["en"] = "Displays all nearby resources",
		["fr"] = "Affiche toutes les ressources à proximité",
		["tr"] = "Yakındaki kaynakları gösterir",
		["zh-TW"] = "顯示附近所有資源的位置",
		["zh-CN"] = "显示附近所有资源的位置",
		["ru"] = "Отображает все ближайшие ресурсы",
	}
})
ZShelter.AddInfo("Crowbar Upgrade", {
	title = {
		["en"] = "Crowbar Upgrade",
		["fr"] = "Pied de Biche",
		["tr"] = "Levye Yükseltmesi",
		["zh-TW"] = "鐵鍬",
		["zh-CN"] = "撬棍",
		["ru"] = "Переход на монтировку",
	},
	desc = {
		["en"] = "Upgrades your melee weapon to crowbar (+60% attack speed)",
		["fr"] = "Améliore votre arme de mêlée en pied de biche (+60% de vitesse d'attaque)",
		["tr"] = "Yakın dövüş silahınızı levyeye yükseltir (+%60 saldırı hızı)",
		["zh-TW"] = "將近戰武器替換成鐵鍬 (+60% 攻擊速度)",
		["zh-CN"] = "将近战武器替换为撬棍 (+60% 攻击速度)",
		["ru"] = "Переделать оружие ближнего боя в монтировку (+60% к скорости атаки)",
	}
})
ZShelter.AddInfo("Advanced Gathering", {
	title = {
		["en"] = "Advanced Gathering",
		["fr"] = "Collecte Améliorée",
		["tr"] = "Gelişmiş Toplama",
		["zh-TW"] = "採集精通",
		["zh-CN"] = "采集精通",
		["ru"] = "Продвинутый сбор",
	},
	desc = {
		["en"] = "Small chance to get double amount of resources, +10% per upgrade",
		["fr"] = "Petite chance d'obtenir le double de ressources, +10% par amélioration",
		["tr"] = "İki kat kaynak alabilmek için küçük bir değişiklik, yükseltme başına +%10",
		["zh-TW"] = "小機率獲得雙倍資源, 每升級一次增加 10%",
		["zh-CN"] = "小概率获得双倍资源, 每升一级增加 10%",
		["ru"] = "Небольшое изменение, позволяющее получать двойные ресурсы, +10% за улучшение",
	}
})
ZShelter.AddInfo("Chain Gathering", {
	title = {
		["en"] = "Chain Gathering",
		["fr"] = "Collecte à la Chaîne",
		["tr"] = "Zincirleme Toplama",
		["zh-TW"] = "連鎖採集",
		["zh-CN"] = "连锁采集",
		["ru"] = "Цепной сбор",
	},
	desc = {
		["en"] = "Gathering multiple resources at same time",
		["fr"] = "Collecte simultanément plusieurs ressources à la fois",
		["tr"] = "Aynı anda birden fazla kaynak toplama",
		["zh-TW"] = "可同時採幾多個資源",
		["zh-CN"] = "可同时采集多个资源",
		["ru"] = "Сбор множества ресурсов одновременно",
	}
})
ZShelter.AddInfo("Haste", {
	title = {
		["en"] = "Haste",
		["fr"] = "Célérité",
		["tr"] = "Çabukluk",
		["zh-TW"] = "快速採集",
		["zh-CN"] = "快速采集",
		["ru"] = "Спешка",
	},
	desc = {
		["en"] = "Get double amount of resources per hit",
		["fr"] = "Double le nombre de ressources par coup",
		["tr"] = "İki kat toplama hızı",
		["zh-TW"] = "採集速度加倍",
		["zh-CN"] = "采集速度加倍",
		["ru"] = "Удвоенная скорость сбора",
	}
})
ZShelter.AddInfo("Resource Transporting", {
	title = {
		["en"] = "Resource Transporting",
		["fr"] = "Transport de Ressources",
		["tr"] = "Kaynak Aktarımı",
		["zh-TW"] = "資源運輸",
		["zh-CN"] = "资源运输",
		["ru"] = "Транспортировка ресурсов",
	},
	desc = {
		["en"] = "Resources will be send to storage when inventory is full",
		["fr"] = "Les ressources sont envoyées au stockage lorsque votre inventaire est plein",
		["tr"] = "Envanter dolu olduğunda kaynaklar depoya gönderilir",
		["zh-TW"] = "身上沒空間時把資源送往倉庫",
		["zh-CN"] = "背包没有空间时将资源送往仓库",
		["ru"] = "Ресурсы будут отправлены на склад, когда инвентарь будет переполнен",
	}
})
ZShelter.AddInfo("Stunwave", {
	title = {
		["en"] = "Stunwave",
		["fr"] = "Onde Paralysante",
		["tr"] = "Sersemletici Dalga",
		["zh-TW"] = "暈眩波",
		["zh-CN"] = "晕眩波",
		["ru"] = "Оглушительная волна",
	},
	desc = {
		["en"] = "Stuns all nearby enemies for 25 seconds",
		["fr"] = "Étourdit tous les ennemis proches pendant 25 secondes",
		["tr"] = "Yakındaki tüm düşmanları 25 saniye boyunca sersemletir",
		["zh-TW"] = "暈眩附近的敵人25秒",
		["zh-CN"] = "晕眩附近的敌人25秒",
		["ru"] = "Оглушает всех врагов поблизости на 25 секунд",
	}
})
ZShelter.AddInfo("Cloaking", {
	title = {
		["en"] = "Cloaking",
		["fr"] = "Cape d'Invisibilité",
		["tr"] = "Görünmezlik",
		["zh-TW"] = "隱身",
		["zh-CN"] = "隐身",
		["ru"] = "Маскировка",
	},
	desc = {
		["en"] = "Become invisible for 30 seconds, enemy cannot see you while you're invisible",
		["fr"] = "Vous devenez invisible pendant 30 secondes, l'ennemi ne peut plus vous voir pendant que vous êtes invisible",
		["tr"] = "30 saniye boyunca görünmez ol, düşman seni görünmezken göremez",
		["zh-TW"] = "隱身30秒, 隱身時不會被敵人攻擊",
		["zh-CN"] = "隐身30秒, 隐身时不会被敌人攻击",
		["ru"] = "Становитесь невидимым на 30 секунд, враги не видят вас, пока вы невидимы",
	}
})
ZShelter.AddInfo("Claymore", {
	title = {
		["en"] = "Claymore",
		["fr"] = "Claymore",
		["tr"] = "AP Mayını",
		["zh-TW"] = "闊刀地雷",
		["zh-CN"] = "阔剑地雷",
		["ru"] = "Противопехотная мина",
	},
	desc = {
		["en"] = "Allows you to build claymore",
		["fr"] = "Vous permet de construire des claymore",
		["tr"] = "APM üretmenize olanak sağlar",
		["zh-TW"] = "可建造闊刀地雷",
		["zh-CN"] = "可建造阔剑地雷",
		["ru"] = "Позволяет строить противопехотную мину",
	}
})
ZShelter.AddInfo("Campfire", {
	title = {
		["en"] = "Campfire",
		["fr"] = "Feu de Camp",
		["tr"] = "Kamp Ateşi",
		["zh-TW"] = "營火",
		["zh-CN"] = "营火",
		["ru"] = "Костёр",
	},
	desc = {
		["en"] = "Allows you to build campfire",
		["fr"] = "Vous permet de faire des feux de camp",
		["tr"] = "Kamp ateşi kurmanıza olanak sağlar",
		["zh-TW"] = "可建造營火",
		["zh-CN"] = "可建造营火",
		["ru"] = "Позволяет строить костёр",
	}
})
ZShelter.AddInfo("Trap Damage Boost", {
	title = {
		["en"] = "Trap Damage Boost",
		["fr"] = "Pièges Améliorer",
		["tr"] = "Tuzak Hasar Yükseltmesi",
		["zh-TW"] = "提升陷阱傷害",
		["zh-CN"] = "提升陷阱伤害",
		["ru"] = "Увеличение урона ловушек",
	},
	desc = {
		["en"] = "Increase trap damage, +40% per upgrade",
		["fr"] = "Augmente les dégâts des pièges, +40% par amélioration",
		["tr"] = "Tuzak hasarını artırır, yükseltme başına +%40",
		["zh-TW"] = "提升陷阱造成的傷害, 每升級一次增加 40%",
		["zh-CN"] = "提升陷阱造成的伤害, 每升一级增加 40%",
		["ru"] = "Увеличивает урон от ловушек, +40% за улучшение",
	}
})
ZShelter.AddInfo("Temporary Turret", {
	title = {
		["en"] = "Temporary Turret",
		["fr"] = "Tourelle Temporaire",
		["tr"] = "Geçici Taret",
		["zh-TW"] = "暫時性砲塔",
		["zh-CN"] = "临时炮塔",
		["ru"] = "Временная турель",
	},
	desc = {
		["en"] = "Spawn a temporary turret, disappears after 15 seconds",
		["fr"] = "Apparition temporaire d'une tourelle , elle disparaît au bout de 15 secondes",
		["tr"] = "Geçici bir taret oluştur, 15 saniye sonra kaybolur",
		["zh-TW"] = "生成一個暫時性的防禦砲塔，15秒鐘後消失",
		["zh-CN"] = "生成一个临时性的防御炮塔, 15秒后消失",
		["ru"] = "Создаёт временную турель, исчезающую через 15 секунд",
	}
})
ZShelter.AddInfo("Increased Capacity", {
	title = {
		["en"] = "Increased Capacity",
		["fr"] = "Capacité Améliorée",
		["tr"] = "Artırılmış Kapasite",
		["zh-TW"] = "背包容量提升",
		["zh-CN"] = "背包容量提升",
		["ru"] = "Увеличенная вместимость",
	},
	desc = {
		["en"] = "Increase your resource capacity by 30%",
		["fr"] = "Augmente la capacité de votre Sac à dos de 30 %",
		["tr"] = "Kaynak kapasiteni %30 artırır",
		["zh-TW"] = "提升背包容量，每升級一次增加30%",
		["zh-CN"] = "提升背包容量, 每升一级增加 30%",
		["ru"] = "Увеличивает вашу грузоподъёмность ресурсов на 30%",
	}
})
ZShelter.AddInfo("Demolitions Specialist", {
	title = {
		["en"] = "Demolitions Specialist",
		["fr"] = "Spécialiste en Démolitions",
		["tr"] = "Yıkım Uzmanı",
		["zh-TW"] = "爆破專家",
		["zh-CN"] = "爆破专家",
		["ru"] = "Подрывник-специалист",
	},
	desc = {
		["en"] = "+1 Mine detonate count per upgrade",
		["fr"] = "Les mines explossent +1 fois par amélioration",
		["tr"] = "Yükseltme başına patlatılabilir Mayın sayısını +1 artırır",
		["zh-TW"] = "增加地雷的爆破次數, 每升級一次增加 1 次",
		["zh-CN"] = "增加地雷的爆破次数, 每升一级增加 1 次",
		["ru"] = "+1 взрыв мин за улучшение",
	}
})
ZShelter.AddInfo("Trap Health Boost", {
	title = {
		["en"] = "Trap Health Boost",
		["fr"] = "Renforcement des Pièges",
		["tr"] = "Tuzak Sağlığı Yükseltmesi",
		["zh-TW"] = "提升陷阱耐久",
		["zh-CN"] = "提升陷阱耐久",
		["ru"] = "",
	},
	desc = {
		["en"] = "Increase trap's health, +15% health per upgrade",
		["fr"] = "Augmente la vitesse de réparation des pièges, +100% par amélioration de la santé des pièges, +15% de santé par amélioration",
		["tr"] = "Tuzak sağlığını artırır, yükseltme başına +%15 sağlık",
		["zh-TW"] = "增加陷阱的耐久, 每升級一次增加 15%",
		["zh-CN"] = "增加陷阱的耐久, 每升一级增加 15%",
		["ru"] = "",
	}
})
ZShelter.AddInfo("Fast Deploy", {
	title = {
		["en"] = "Fast Deploy",
		["fr"] = "Déploiement Rapide",
		["tr"] = "Hızlı Kurulum",
		["zh-TW"] = "快速佈署",
		["zh-CN"] = "快速部署",
		["ru"] = "Быстрая установка",
	},
	desc = {
		["en"] = "Traps takes less time to build, -50% per upgrade",
		["fr"] = "Les pièges prennent moins de temps à être construits, -50% par amélioration",
		["tr"] = "Tuzakları daha az zamanda kurmanızı sağlar, yükseltme başına -%50",
		["zh-TW"] = "建造陷阱所需的時間減少, 每升級一次減少 50%",
		["zh-CN"] = "建造陷阱所需的时间减少, 每升一级减少 50%",
		["ru"] = "Ловушки требуют меньше времени на строительство, -50% за улучшение",
	}
})
ZShelter.AddInfo("Reinforced Traps", {
	title = {
		["en"] = "Reinforced Traps",
		["fr"] = "Pièges Renforcés",
		["tr"] = "Güçlendirilmiş Tuzaklar",
		["zh-TW"] = "陷阱加固",
		["zh-CN"] = "陷阱加固",
		["ru"] = "Укреплённые ловушки",
	},
	desc = {
		["en"] = "Increase trap's health, +35% health per upgrade",
		["fr"] = "Augmente la santé des pièges, +35% de santé par amélioration",
		["tr"] = "Tuzağın sağlığını artırır, yükseltme başına +%35",
		["zh-TW"] = "增加陷阱的耐久, 每升級一次增加 35%",
		["zh-CN"] = "增加陷阱的耐久, 每升一级增加 35%",
		["ru"] = "Увеличивает прочность ловушек, +35% прочности за улучшение",
	}
})
ZShelter.AddInfo("Slick Repairing", {
	title = {
		["en"] = "Slick Repairing",
		["fr"] = "Réparation en Série",
		["tr"] = "Seri Tamir",
		["zh-TW"] = "集體修補",
		["zh-CN"] = "集体修复",
		["ru"] = "Безупречный ремонт",
	},
	desc = {
		["en"] = "Repairing a trap also repairs nearby traps, +1.5 meters per upgrade",
		["fr"] = "La réparation d'un piège répare également les pièges à proximité, +1,5 mètre par amélioration",
		["tr"] = "Yakındaki tüm tuzakları tamir eder, +86 birim alan",
		["zh-TW"] = "修復附近所有陷阱類建築物, 每升級一次增加 86 單位距離",
		["zh-CN"] = "修复附近所有陷阱类建筑物, 每升一级增加 86 单位距离",
		["ru"] = "Ремонтирует все ближайшие ловушки. Радиус +86 единиц",
	}
})
ZShelter.AddInfo("Fast Repair", {
	title = {
		["en"] = "Fast Repair",
		["fr"] = "Réparation Rapide",
		["tr"] = "Hızlı Tamir",
		["zh-TW"] = "快速修補",
		["zh-CN"] = "快速修复",
		["ru"] = "Быстрый ремонт",
	},
	desc = {
		["en"] = "Increases trap's repair speed, +100% per upgrade",
		["fr"] = "Augmente la vitesse de réparation des pièges, +100% par amélioration",
		["tr"] = "Tuzağın tamir hızını artırır, yükseltme başına +%100",
		["zh-TW"] = "增加陷阱的修補速度, 每升級一次增加 100%",
		["zh-CN"] = "提高陷阱的修复速度, 每升一级增加 100%",
		["ru"] = "Увеличивает скорость ремонта ловушек, +100% за улучшение",
	}
})
