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

	TR :
	Meiryi / Meika / Shiro / Shigure tarafından Zombie Shelter v2.0
	Oyun modunun ismini ve kodunu ASLA değiştirip düzenleyip yeniden yükleyemezsiniz.
	Eğer bir problemle karşılaşırsanız, benimle Steam üzerinden iletişime geçebilirsiniz. Bu metni okuduğunuz için teşekkürler.
]]

ZShelter.AddInfo("Speed Boost", {
	title = {
		["en"] = "Speed Boost",
		["tr"] = "Hareket Hızı",
		["zh-TW"] = "提升移動速度",
		["zh-CN"] = "速度提升",
		["ru"] = "Увеличение скорости",
	},
	desc = {
		["en"] = "Increases movement speed, +20% per upgrade",
		["tr"] = "Hareket hızını artırır, yükseltme başına +%20",
		["zh-TW"] = "提升移動速度, 每升級一次增加 20%",
		["zh-CN"] = "提升移动速度, 每升一级增加 20%",
		["ru"] = "Увеличивает скорость передвижения, +20% за улучшение",
	}
})
ZShelter.AddInfo("Sanity Boost", {
	title = {
		["en"] = "Sanity Boost",
		["tr"] = "Akıl Sağlığı",
		["zh-TW"] = "增強理智",
		["zh-CN"] = "理智增强",
		["ru"] = "Укрепление рассудка",
	},
	desc = {
		["en"] = "Decreases sanity drain rate, -15% per upgrade",
		["tr"] = "Akıl sağlığı azalma oranını azaltır, yükseltme başına -%15",
		["zh-TW"] = "減少理智消耗, 每升級一次減少 15%",
		["zh-CN"] = "减少理智消耗, 每升一级减少 15%",
		["ru"] = "Уменьшает скорость потери рассудка, -15% за улучшение",
	}
})
ZShelter.AddInfo("Resource Rader", {
	title = {
		["en"] = "Resource Radar",
		["tr"] = "Kaynak Radarı",
		["zh-TW"] = "資源雷達",
		["zh-CN"] = "资源雷达",
		["ru"] = "Радар ресурсов",
	},
	desc = {
		["en"] = "Displays all nearby resources",
		["tr"] = "Yakındaki kaynakları gösterir",
		["zh-TW"] = "顯示附近所有資源的位置",
		["zh-CN"] = "显示附近所有资源的位置",
		["ru"] = "Отображает все ближайшие ресурсы",
	}
})
ZShelter.AddInfo("Crowbar Upgrade", {
	title = {
		["en"] = "Crowbar Upgrade",
		["tr"] = "Levye Yükseltmesi",
		["zh-TW"] = "鐵鍬",
		["zh-CN"] = "撬棍",
		["ru"] = "Переход на монтировку",
	},
	desc = {
		["en"] = "Upgrades your melee weapon to crowbar (+100% attack speed)",
		["tr"] = "Yakın dövüş silahınızı levyeye yükseltir (+%100 saldırı hızı)",
		["zh-TW"] = "將近戰武器替換成鐵鍬 (+100% 攻擊速度)",
		["zh-CN"] = "将近战武器替换为撬棍 (+10% 攻击速度)",
		["ru"] = "Переделать оружие ближнего боя в монтировку (+100% к скорости атаки)",
	}
})
ZShelter.AddInfo("Advanced Gathering", {
	title = {
		["en"] = "Advanced Gathering",
		["tr"] = "Gelişmiş Toplama",
		["zh-TW"] = "採集精通",
		["zh-CN"] = "采集精通",
		["ru"] = "Продвинутый сбор",
	},
	desc = {
		["en"] = "Small change to get double amount of resources, +7% per upgrade",
		["tr"] = "İki kat kaynak alabilmek için küçük bir değişiklik, yükseltme başına +%7",
		["zh-TW"] = "小機率獲得雙倍資源, 每升級一次增加 7%",
		["zh-CN"] = "小概率获得双倍资源, 每升一级增加 7%",
		["ru"] = "Небольшое изменение, позволяющее получать двойные ресурсы, +7% за улучшение",
	}
})
ZShelter.AddInfo("Chain Gathering", {
	title = {
		["en"] = "Chain Gathering",
		["tr"] = "Çoklu Toplama",
		["zh-TW"] = "連鎖採集",
		["zh-CN"] = "连锁采集",
		["ru"] = "Цепной сбор",
	},
	desc = {
		["en"] = "Gathering multiple resources at same time",
		["tr"] = "Aynı anda birden fazla kaynak toplama",
		["zh-TW"] = "可同時採幾多個資源",
		["zh-CN"] = "可同时采集多个资源",
		["ru"] = "Сбор множества ресурсов одновременно",
	}
})
ZShelter.AddInfo("Haste", {
	title = {
		["en"] = "Haste",
		["tr"] = "Çabukluk",
		["zh-TW"] = "快速採集",
		["zh-CN"] = "快速采集",
		["ru"] = "Спешка",
	},
	desc = {
		["en"] = "Double gathering speed",
		["tr"] = "İki kat toplama hızı",
		["zh-TW"] = "採集速度加倍",
		["zh-CN"] = "采集速度加倍",
		["ru"] = "Удвоенная скорость сбора",
	}
})
ZShelter.AddInfo("Resource Transporting", {
	title = {
		["en"] = "Resource Transporting",
		["tr"] = "Kaynak Aktarımı",
		["zh-TW"] = "資源運輸",
		["zh-CN"] = "资源运输",
		["ru"] = "Транспортировка ресурсов",
	},
	desc = {
		["en"] = "Resources will be send to storage when inventory is full",
		["tr"] = "Envanter dolu olduğunda kaynaklar depoya gönderilir",
		["zh-TW"] = "身上沒空間時把資源送往倉庫",
		["zh-CN"] = "背包没有空间时将资源送往仓库",
		["ru"] = "Ресурсы будут отправлены на склад, когда инвентарь будет переполнен",
	}
})
ZShelter.AddInfo("Stunwave", {
	title = {
		["en"] = "Stunwave",
		["tr"] = "Sersemletici Dalga",
		["zh-TW"] = "暈眩波",
		["zh-CN"] = "晕眩波",
		["ru"] = "Оглушительная волна",
	},
	desc = {
		["en"] = "Stuns all nearby enemies for 10 seconds",
		["tr"] = "Yakındaki tüm düşmanları 10 saniye boyunca sersemletir",
		["zh-TW"] = "暈眩附近的敵人10秒",
		["zh-CN"] = "晕眩附近的敌人10秒",
		["ru"] = "Оглушает всех врагов поблизости на 10 секунд",
	}
})
ZShelter.AddInfo("Cloaking", {
	title = {
		["en"] = "Cloaking",
		["tr"] = "Görünmezlik",
		["zh-TW"] = "隱身",
		["zh-CN"] = "隐身",
		["ru"] = "Маскировка",
	},
	desc = {
		["en"] = "Become invisible for 30 seconds, enemy cannot see you while you're invisible",
		["tr"] = "30 saniye boyunca görünmez olun, düşman seni görünmezken göremez",
		["zh-TW"] = "隱身30秒, 隱身時不會被敵人攻擊",
		["zh-CN"] = "隐身30秒, 隐身时不会被敌人攻击",
		["ru"] = "Становитесь невидимым на 30 секунд, враги не видят вас, пока вы невидимы",
	}
})
ZShelter.AddInfo("Claymore", {
	title = {
		["en"] = "Claymore",
		["tr"] = "Kılıç",
		["zh-TW"] = "闊刀地雷",
		["zh-CN"] = "阔剑地雷",
		["ru"] = "Противопехотная мина",
	},
	desc = {
		["en"] = "Allows you to build claymore",
		["tr"] = "Kılıç üretmenize olanak sağlar",
		["zh-TW"] = "可建造闊刀地雷",
		["zh-CN"] = "可建造阔剑地雷",
		["ru"] = "Позволяет строить противопехотную мину",
	}
})
ZShelter.AddInfo("Campfire", {
	title = {
		["en"] = "Campfire",
		["tr"] = "Kamp Ateşi",
		["zh-TW"] = "營火",
		["zh-CN"] = "营火",
		["ru"] = "Костёр",
	},
	desc = {
		["en"] = "Allows you to build campfire",
		["tr"] = "Kamp ateşi kurmanıza olanak sağlar",
		["zh-TW"] = "可建造營火",
		["zh-CN"] = "可建造营火",
		["ru"] = "Позволяет строить костёр",
	}
})
ZShelter.AddInfo("Trap Damage Boost", {
	title = {
		["en"] = "Trap Damage Boost",
		["tr"] = "Tuzak Hasar Yükseltmesi",
		["zh-TW"] = "提升陷阱傷害",
		["zh-CN"] = "提升陷阱伤害",
		["ru"] = "Увеличение урона ловушек",
	},
	desc = {
		["en"] = "Increase trap damage, +40% per upgrade",
		["tr"] = "Tuzak hasarını artırır, yükseltme başına +%40",
		["zh-TW"] = "提升陷阱造成的傷害, 每升級一次增加 40%",
		["zh-CN"] = "提升陷阱造成的伤害, 每升一级增加 40%",
		["ru"] = "Увеличивает урон от ловушек, +40% за улучшение",
	}
})
ZShelter.AddInfo("Temporary Turret", {
	title = {
		["en"] = "Temporary Turret",
		["tr"] = "Geçici Taret",
		["zh-TW"] = "暫時性砲塔",
		["zh-CN"] = "临时炮塔",
		["ru"] = "Временная турель",
	},
	desc = {
		["en"] = "Spawn a temporary turret, disappears after 15 seconds",
		["tr"] = "Geçici bir taret oluştur, 15 saniye sonra kaybolur",
		["zh-TW"] = "生成一個暫時性的防禦砲塔，15秒鐘後消失",
		["zh-CN"] = "生成一个临时性的防御炮塔, 15秒后消失",
		["ru"] = "Создаёт временную турель, исчезающую через 15 секунд",
	}
})
ZShelter.AddInfo("Increased Capacity", {
	title = {
		["en"] = "Increased Capacity",
		["tr"] = "Artırılmış Kapasite",
		["zh-TW"] = "背包容量提升",
		["zh-CN"] = "背包容量提升",
		["ru"] = "Увеличенная вместимость",
	},
	desc = {
		["en"] = "Increase your resource capacity by 30%",
		["tr"] = "Kaynak kapasiteni %30 artırır",
		["zh-TW"] = "提升背包容量，每升級一次增加30%",
		["zh-CN"] = "提升背包容量, 每升一级增加 30%",
		["ru"] = "Увеличивает вашу грузоподъёмность ресурсов на 30%",
	}
})
ZShelter.AddInfo("Demolitions Specialist", {
	title = {
		["en"] = "Demolitions Specialist",
		["tr"] = "Yıkım Uzmanı",
		["zh-TW"] = "爆破專家",
		["zh-CN"] = "爆破专家",
		["ru"] = "Подрывник-специалист",
	},
	desc = {
		["en"] = "+1 Mine detonate count per upgrade",
		["tr"] = "Yükseltme başına patlatılabilir Mayın sayısını +1 artırır",
		["zh-TW"] = "增加地雷的爆破次數, 每升級一次增加 1 次",
		["zh-CN"] = "增加地雷的爆破次数, 每升一级增加 1 次",
		["ru"] = "+1 взрыв мин за улучшение",
	}
})
ZShelter.AddInfo("Trap Health Boost", {
	title = {
		["en"] = "Trap Health Boost",
		["tr"] = "Tuzak Sağlığı Yükseltmesi",
		["zh-TW"] = "提升陷阱耐久",
		["zh-CN"] = "提升陷阱耐久",
		["ru"] = "",
	},
	desc = {
		["en"] = "Increase trap's health, +15% health per upgrade",
		["tr"] = "Tuzak sağlığını artırır, yükseltme başına +%15 sağlık",
		["zh-TW"] = "增加陷阱的耐久, 每升級一次增加 15%",
		["zh-CN"] = "增加陷阱的耐久, 每升一级增加 15%",
		["ru"] = "",
	}
})
ZShelter.AddInfo("Fast Deploy", {
	title = {
		["en"] = "Fast Deploy",
		["tr"] = "Hızlı Kurulum",
		["zh-TW"] = "快速佈署",
		["zh-CN"] = "快速部署",
		["ru"] = "Быстрая установка",
	},
	desc = {
		["en"] = "Traps takes less time to build, -50% per upgrade",
		["tr"] = "Tuzakları daha az zamanda kurmanızı sağlar, yükseltme başına -%50",
		["zh-TW"] = "建造陷阱所需的時間減少, 每升級一次減少 50%",
		["zh-CN"] = "建造陷阱所需的时间减少, 每升一级减少 50%",
		["ru"] = "Ловушки требуют меньше времени на строительство, -50% за улучшение",
	}
})
ZShelter.AddInfo("Reinforced Traps", {
	title = {
		["en"] = "Reinforced Traps",
		["tr"] = "Güçlendirilmiş Tuzaklar",
		["zh-TW"] = "陷阱加固",
		["zh-CN"] = "陷阱加固",
		["ru"] = "Укреплённые ловушки",
	},
	desc = {
		["en"] = "Increase trap's health, +35% health per upgrade",
		["tr"] = "Tuzağın sağlığını artırır, yükseltme başına +%35",
		["zh-TW"] = "增加陷阱的耐久, 每升級一次增加 35%",
		["zh-CN"] = "增加陷阱的耐久, 每升一级增加 35%",
		["ru"] = "Увеличивает прочность ловушек, +35% прочности за улучшение",
	}
})
ZShelter.AddInfo("Slick Repairing", {
	title = {
		["en"] = "Slick Repairing",
		["tr"] = "Seri Tamir",
		["zh-TW"] = "集體修補",
		["zh-CN"] = "集体修复",
		["ru"] = "Безупречный ремонт",
	},
	desc = {
		["en"] = "Repairs all nearby traps, +86 unit radius",
		["tr"] = "Yakındaki tüm tuzakları tamir eder, +86 birim alan",
		["zh-TW"] = "修復附近所有陷阱類建築物, 每升級一次增加 86 單位距離",
		["zh-CN"] = "修复附近所有陷阱类建筑物, 每升一级增加 86 单位距离",
		["ru"] = "Ремонтирует все ближайшие ловушки. Радиус +86 единиц",
	}
})
ZShelter.AddInfo("Fast Repair", {
	title = {
		["en"] = "Fast Repair",
		["tr"] = "Hızlı Tamir",
		["zh-TW"] = "快速修補",
		["zh-CN"] = "快速修复",
		["ru"] = "Быстрый ремонт",
	},
	desc = {
		["en"] = "Increase trap's repair speed, +25% per upgrade",
		["tr"] = "Tuzağın tamir hızını artırır, yükseltme başına +%25",
		["zh-TW"] = "增加陷阱的修補速度, 每升級一次增加 25%",
		["zh-CN"] = "提高陷阱的修复速度, 每升一级增加 25%",
		["ru"] = "Увеличивает скорость ремонта ловушек, +25% за улучшение",
	}
})
