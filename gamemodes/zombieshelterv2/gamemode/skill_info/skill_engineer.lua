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
]]

ZShelter.AddInfo("Basic Engineering", {
	title = {
		["en"] = "Basic Engineering",
		["fr"] = "Ingénierie de Base",
		["tr"] = "Temel Mühendislik",
		["vi"] = "Kỹ Sư Cơ Bản",
		["zh-TW"] = "基礎工程學",
		["zh-CN"] = "基础工程学",
		["ru"] = "Инженер начального уровня",
	},
	desc = {
		["en"] = "Allows you to build advanced turrets",
		["fr"] = "Permet de construire des tourelles avancées",
		["tr"] = "Gelişmiş taretler üretmenize olanak sağlar",
		["vi"] = "Cho phép bạn xây dựng tháp pháo tiên tiến",
		["zh-TW"] = "可建造進階槍塔",
		["zh-CN"] = "可建造进阶炮塔",
		["ru"] = "Позволяет строить более продвинутые турели",
	}
})
ZShelter.AddInfo("Build Speed Boost", {
	title = {
		["en"] = "Build Speed Boost",
		["fr"] = "Vitesse de Construction Améliorée",
		["tr"] = "İnşa Hızı",
		["vi"] = "Tăng Tốc Độ Xây Dựng",
		["zh-TW"] = "增加建造速度",
		["zh-CN"] = "增加建造速度",
		["ru"] = "Увеличение скорости сборки",
	},
	desc = {
		["en"] = "Increases build speed +35% per upgrade",
		["fr"] = "Augmente la vitesse de construction de +35% par amélioration",
		["tr"] = "İnşa hızını yükseltme başına +%35 artırır",
		["vi"] = "Tăng tốc độ xây dựng +35% mỗi cấp",
		["zh-TW"] = "加快建造速度,每升級一次增加 35%",
		["zh-CN"] = "加快建造速度, 每升一级增加 35%",
		["ru"] = "Увеличивает скорость строительства на +35% за улучшение",
	}
})
ZShelter.AddInfo("Improved Blueprint", {
	title = {
		["en"] = "Improved Blueprint",
		["fr"] = "Schéma Amélioré",
		["tr"] = "Gelişmiş Plan",
		["vi"] = "Bản Học Cải Tiến",
		["zh-TW"] = "藍圖改進",
		["zh-CN"] = "蓝图改进",
		["ru"] = "Улучшение проекта",
	},
	desc = {
		["en"] = "Decreases resource cost, -10% per upgrade",
		["fr"] = "Réduit le nombre de ressources nécessaires, -10% par amélioration",
		["tr"] = "Kaynak maliyetini azaltır, yükseltme başına -%10",
		["vi"] = "Giảm chi phí tài nguyên, -10% mỗi cấp",
		["zh-TW"] = "減少資源消耗, 每升級一次減少 10%",
		["zh-CN"] = "减少资源消耗, 每升一级减少 10%",
		["ru"] = "Уменьшает затраты ресурсов, -10% за улучшение",
	}
})
ZShelter.AddInfo("Electrical Engineering", {
	title = {
		["en"] = "Electrical Engineering",
		["fr"] = "Ingénierie Électrique",
		["tr"] = "Elektrik Mühendisliği",
		["vi"] = "Kỹ Sư Điện",
		["zh-TW"] = "電機工程學",
		["zh-CN"] = "电气工程学",
		["ru"] = "Инженер-электрик",
	},
	desc = {
		["en"] = "Decreases power usage, -10% per upgrade",
		["fr"] = "Réduit la consommation d'énergie, -10% par amélioration",
		["tr"] = "Güç kullanımını azaltır, yükseltme başına -%10",
		["vi"] = "Giảm tiêu thụ điện, -10% mỗi cấp",
		["zh-TW"] = "減少電力消耗, 每升級一次減少 15%",
		["zh-CN"] = "减少电力消耗, 每升一级减少 15%",
		["ru"] = "Уменьшает потребление энергии, -15% за улучшение",
	}
})
ZShelter.AddInfo("Turret Damage Boost", {
	title = {
		["en"] = "Turret Damage Boost",
		["fr"] = "Dégâts des Tourelles Améliorée",
		["tr"] = "Taret Hasar Yükseltmesi",
		["vi"] = "Tăng Sát Thương Tháp Pháo",
		["zh-TW"] = "提升槍塔傷害",
		["zh-CN"] = "炮塔伤害提升",
		["ru"] = "Усиление урона турели",
	},
	desc = {
		["en"] = "Increases turret's damage, +10% per upgrade",
		["fr"] = "Augmente les dégâts des tourelles, +10% par amélioration",
		["tr"] = "Taretin hasarını artırır, yükseltme başına +%10",
		["vi"] = "Tăng sát thương của tháp pháo, +10% mỗi cấp",
		["zh-TW"] = "增加槍塔造成的傷害, 每升級一次增加 10%",
		["zh-CN"] = "增加炮塔造成的伤害, 每升一级增加 10%",
		["ru"] = "Увеличивает урон турелей, +10% за улучшение",
	}
})
ZShelter.AddInfo("Advanced Engineering", {
	title = {
		["en"] = "Advanced Engineering",
		["fr"] = "Ingénierie de Pointe",
		["tr"] = "Gelişmiş Mühendislik",
		["vi"] = "Kỹ Sư Nâng Cao",
		["zh-TW"] = "進階工程學",
		["zh-CN"] = "进阶工程学",
		["ru"] = "Продвинутое проектирование",
	},
	desc = {
		["en"] = "Allows you to build special buildings",
		["fr"] = "Vous permet de construire des bâtiments spéciaux",
		["tr"] = "Özel yapılar inşa etmenize olanak sağlar",
		["vi"] = "Cho phép bạn xây dựng các công trình đặc biệt",
		["zh-TW"] = "可建造特殊建築物",
		["zh-CN"] = "可建造特殊建筑物",
		["ru"] = "Позволяет строить особые строения",
	}
})
ZShelter.AddInfo("Repair Speed Boost", {
	title = {
		["en"] = "Repair Speed Boost",
		["fr"] = "Réparation Accélérée",
		["tr"] = "Tamir Hızı",
		["vi"] = "Tăng Tốc Độ Sửa Chữa",
		["zh-TW"] = "增加修復速度",
		["zh-CN"] = "增加修复速度",
		["ru"] = "Увеличение скорости ремонта",
	},
	desc = {
		["en"] = "Increases repair speed, +15% per upgrade",
		["fr"] = "Augmente la vitesse de réparation, +15% par amélioration",
		["tr"] = "Tamir hızını artırır, yükseltme başına +%15",
		["vi"] = "Tăng tốc độ sửa chữa, +15% mỗi cấp",
		["zh-TW"] = "增加建築修補速度, 每升級一次增加 15%",
		["zh-CN"] = "增加建筑修复速度, 每升一级增加 15%",
		["ru"] = "Увеличивает скорость ремонта, +15% за улучшение",
	}
})
ZShelter.AddInfo("Auto Repair", {
	title = {
		["en"] = "Auto Repair",
		["fr"] = "Réparation Automatique",
		["tr"] = "Otomatik Tamir",
		["vi"] = "Tự Động Sửa Chữa",
		["zh-TW"] = "自動修復",
		["zh-CN"] = "自动修复",
		["ru"] = "Авторемонт",
	},
	desc = {
		["en"] = "Auto repairs nearby buildings, +256 unit radius and 20% repair speed per upgrade",
		["fr"] = "Réparation automatique des bâtiments proches, +256 de rayon d'action et 20% de vitesse de réparation par amélioration",
		["tr"] = "Yakındaki yapıları otomatik olarak tamir eder, yükseltme başına +256 birim alan ve %20 tamir hızı",
		["vi"] = "Tự động sửa chữa các công trình gần đó, +256 đơn vị bán kính và 20% tốc độ sửa chữa mỗi cấp",
		["zh-TW"] = "自動修復附近建築, 每升級一次增加 256 修復半徑 和 20% 修復速度",
		["zh-CN"] = "自动修复附近建筑, 每升一级增加 256 修复半径 和 20% 修复速度",
		["ru"] = "Автоматически чинит ближайшие строения.\nРадиус +256 единиц и +20% к скорости ремонта за улучшение",
	}
})
ZShelter.AddInfo("Clawhammer Upgrade", {
	title = {
		["en"] = "Clawhammer Upgrade",
		["fr"] = "Marteau",
		["tr"] = "Pençe Çekiç",
		["vi"] = "Nâng Cấp Búa Nhổ Đinh",
		["zh-TW"] = "尖頭槌",
		["zh-CN"] = "尖头锤",
		["ru"] = "Переход на молоток",
	},
	desc = {
		["en"] = "Upgrades your melee weapon to clawhammer (+50% build and repair speed)",
		["fr"] = "Améliore votre arme de mêlée en marteau (+50% de vitesse de construction et de réparation)",
		["tr"] = "Yakın dövüş silahınızı pençe çekice yükseltir (+%50 inşa ve tamir hızı)",
		["vi"] = "Nâng cấp vũ khí cận chiến của bạn thành búa nhổ đinh (+50% tốc độ xây dựng và sửa chữa)",
		["zh-TW"] = "將近戰武器替換成尖頭槌 (+50% 建造和修復速度)",
		["zh-CN"] = "将近战武器替换为尖头锤 (+50% 建造和修复速度)",
		["ru"] = "Переделать оружие ближнего боя в столярный молоток (+50% к скорости строительства и ремонта)",
	}
})
ZShelter.AddInfo("Building Health Boost", {
	title = {
		["en"] = "Building Health Boost",
		["fr"] = "Renforcement des Constructions",
		["tr"] = "Yapı Sağlık Yükseltmesi",
		["vi"] = "Tăng Máu Công Trình",
		["zh-TW"] = "增加建築物耐久",
		["zh-CN"] = "增加建筑物耐久",
		["ru"] = "Укрепление прочности строений",
	},
	desc = {
		["en"] = "Increases building's health, +10% per upgrade",
		["fr"] = "Augmente la santé des bâtiments, +10% par amélioration",
		["tr"] = "Yapının sağlığını artırır, yükseltme başına +%10",
		["vi"] = "Tăng máu của công trình, +10% mỗi cấp",
		["zh-TW"] = "增加建築物的最大耐久, 每升級一次增加 10%",
		["zh-CN"] = "增加建筑物的最大耐久, 每升一级增加 10%",
		["ru"] = "Увеличивает прочность строений, +10% за улучшение",
	}
})
ZShelter.AddInfo("Expert Engineering", {
	title = {
		["en"] = "Expert Engineering",
		["fr"] = "Expert en Ingénierie",
		["tr"] = "Uzman Mühendislik",
		["vi"] = "Kỹ Sư Chuyên Nghiệp",
		["zh-TW"] = "高階工程學",
		["zh-CN"] = "高阶工程学",
		["ru"] = "Проектирование эксперта",
	},
	desc = {
		["en"] = "Allows you to build advanced buildings",
		["fr"] = "Permet de construire des bâtiments avancés",
		["tr"] = "Gelişmiş yapılar inşa etmenizi sağlar",
		["vi"] = "Cho phép bạn xây dựng các công trình tiên tiến",
		["zh-TW"] = "可建造進階建築物",
		["zh-CN"] = "可建造进阶建筑物",
		["ru"] = "Позволяет строить более продвинутые строения",
	}
})
ZShelter.AddInfo("Chain Repair", {
	title = {
		["en"] = "Chain Repair",
		["fr"] = "Réparation à la Chaîne",
		["tr"] = "Zincirleme Tamir",
		["vi"] = "Sửa Chữa Mắt Xích",
		["zh-TW"] = "連鎖修復",
		["zh-CN"] = "连锁修复",
		["ru"] = "Цепной ремонт",
	},
	desc = {
		["en"] = "Repairs all nearby buildings, +64 unit radius and 20% repair speed per upgrade",
		["fr"] = "Répare tous les bâtiments proches, +64 de rayon d'action et 20% de vitesse de réparation par amélioration",
		["tr"] = "Yakındaki tüm yapıları tamir eder, yükseltme başına +64 birim alan ve %20 tamir hızı",
		["vi"] = "Sửa chữa tất cả các công trình gần đó, +64 đơn vị bán kính và 20% tốc độ sửa chữa mỗi cấp",
		["zh-TW"] = "修復附近的所有建築, 每升級一次增加 64 修復半徑 和 20% 修復速度",
		["zh-CN"] = "修复附近的所有建筑, 每升一级增加 64 维修半径 和 20% 修复速度",
		["ru"] = "Ремонтирует все ближайшие строения.\nРадиус +64 единицы и +20% к скорости ремонта за улучшение",
	}
})
ZShelter.AddInfo("Overheal", {
	title = {
		["en"] = "Overheal",
		["fr"] = "Rénovation",
		["tr"] = "Gelişmiş İyileştirme",
		["vi"] = "Hồi Phục Quá Mức",
		["zh-TW"] = "超量修復",
		["zh-CN"] = "超量修复",
		["ru"] = "Сверхпрочность",
	},
	desc = {
		["en"] = "Temporary increases building's maximum health, +25% health per upgrade\nOverhealed building won't be stunned\n*Only work when repairing manually*",
		["fr"] = "Augmente temporairement la santé maximale des bâtiments, +25% de santé par amélioration\nLes bâtiments rénover ne sont pas étourdis\n*Cela ne fonctionne que pour les réparations manuelles*",
		["tr"] = "Geçici olarak yapının maksimum sağlığını artırır, yükseltme başına +%25\nGelişmiş İyileştirme kullanılan yapı sersemlemez",
		["vi"] = "Tăng tạm thời máu tối đa của công trình, +25% máu mỗi cấp\nCông trình hồi phục sẽ không bị choáng\n*Chỉ hoạt động khi sửa chữa thủ công*",
		["zh-TW"] = "暫時提升建築物的最高耐久, 每升級一次增加 25%\n超量修復後不受暈眩效果影響\n*只在手動修復時有效*",
		["zh-CN"] = "暂时提升建筑物的耐久上限, 每升一级增加 25%\n超量修复后不受晕眩效果影响\n*只在手动修复时有效*",
		["ru"] = "Временно увеличивает макс. запас прочности строений, +25% прочности за улучшение\nСтроение со сверхпрочностью не будет оглушено",
	}
})
ZShelter.AddInfo("Recycle", {
	title = {
		["en"] = "Recycle",
		["fr"] = "Recyclage",
		["tr"] = "Geri Dönüşüm",
		["vi"] = "Tái Chế",
		["zh-TW"] = "資源回收",
		["zh-CN"] = "资源回收",
		["ru"] = "Переработка",
	},
	desc = {
		["en"] = "Returns resources when building got destroyed, +20% per upgrade",
		["fr"] = "Restitue une partie des ressources lorsqu'un bâtiment a été détruit, +20% par amélioration",
		["tr"] = "Yapı yok edildiğinde kaynakları geri döndürür, yükseltme başına +%20",
		["vi"] = "Trả lại tài nguyên khi công trình bị phá hủy, +20% mỗi cấp",
		["zh-TW"] = "建築被摧毀時退回部分資源, 每升級一次增加 20%",
		["zh-CN"] = "建筑被摧毁时返还部分资源, 每升一级增加 20%",
		["ru"] = "Возвращает ресурсы за разрушенное строение, +20% за улучшение",
	}
})
ZShelter.AddInfo("Self Destruction", {
	title = {
		["en"] = "Self Destruction",
		["fr"] = "Autodestruction",
		["tr"] = "Kendini İmha Etme",
		["vi"] = "Tự Hủy",
		["zh-TW"] = "自我毀滅",
		["zh-CN"] = "自我毁灭",
		["ru"] = "Самоуничтожение",
	},
	desc = {
		["en"] = "When a turret gets destroyed, it'll damage all nearby enemy",
		["fr"] = "Lorsqu'une tourelle est détruite, elle explose et inflige des dégâts à tous les ennemis proches",
		["tr"] = "Bir kule yok edildiğinde yakındaki tüm düşmanlara hasar verir",
		["vi"] = "Khi một tháp pháo bị phá hủy, nó sẽ gây sát thương cho tất cả kẻ địch ở gần",
		["zh-TW"] = "槍塔被摧毀時會傷害到附近所有敵人",
		["zh-CN"] = "炮塔被摧毁时会伤害附近所有敌人",
		["ru"] = "Турель при разрушении наносит урон всем ближайшим врагам",
	}
})
ZShelter.AddInfo("Transporting Drone", {
	title = {
		["en"] = "Transporting Drone",
		["fr"] = "Drone de Transport",
		["tr"] = "Aktarım Dronu",
		["vi"] = "Vận Chuyển Bằng Drone",
		["zh-TW"] = "運輸無人機",
		["zh-CN"] = "运输无人机",
		["ru"] = "Дрон-транспортировщик",
	},
	desc = {
		["en"] = "Allows you to use resources directly from storage to build",
		["fr"] = "Permet d'utiliser directement les ressources du stockage pour construire",
		["tr"] = "Depodan kaynakları doğrudan inşa etmek için kullanabilmeni sağlar",
		["vi"] = "Cho phép bạn sử dụng tài nguyên trực tiếp từ kho để xây dựng",
		["zh-TW"] = "可直接使用倉庫中的資源進行建造",
		["zh-CN"] = "可直接使用仓库中的资源进行建造",
		["ru"] = "Позволяет использовать ресурсы прямо со склада для строительства",
	}
})
ZShelter.AddInfo("C4", {
	title = {
		["en"] = "C4",
		["fr"] = "C4",
		["tr"] = "C4",
		["vi"] = "C4",
		["zh-TW"] = "C4",
		["zh-CN"] = "C4",
		["ru"] = "Взрывчатка C4",
	},
	desc = {
		["en"] = "A C4 can be used to destroy obstacles",
		["fr"] = "Les C4 peuvent être utilisés pour détruire des obstacles",
		["tr"] = "Engelleri yok etmek için C4 kullanılabilir",
		["vi"] = "C4 có thể được sử dụng để phá hủy chướng ngại vật",
		["zh-TW"] = "可用於破壞路障的C4",
		["zh-CN"] = "可用于破坏路障的C4",
		["ru"] = "Взрывчатку C4 можно использовать для уничтожения препятствий",
	}
})
ZShelter.AddInfo("Repair Aura", {
	title = {
		["en"] = "Repair Aura",
		["fr"] = "Aura de Réparation",
		["tr"] = "Tamir Aurası",
		["vi"] = "Hào Quang Sửa Chữa",
		["zh-TW"] = "維修光環",
		["zh-CN"] = "维修光环",
		["ru"] = "Аура ремонта",
	},
	desc = {
		["en"] = "Auto repairs all nearby buildings with 300% speed",
		["fr"] = "Réparation automatique de tous les bâtiments proches à une vitesse de 300%",
		["tr"] = "Yakındaki tüm yapıları %300 hızla otomatik olarak onarır",
		["vi"] = "Tự động sửa chữa tất cả các công trình gần đó với tốc độ 300%",
		["zh-TW"] = "使用自身300%的建造速度修復鄰近建築物",
		["zh-CN"] = "使用自身300%的建造速度修复附近建筑物",
		["ru"] = "Автоматически чинит все ближайшие строения со скоростью 300%",
	}
})
ZShelter.AddInfo("Damage Reflection", {
    title = {
        ["en"] = "Damage Reflection",
		["fr"] = "Réflexion des Dégâts",
        ["tr"] = "Hasar Yansıtma",
		["vi"] = "Phản Xạ Sát Thương",
        ["zh-TW"] = "傷害反彈",
        ["zh-CN"] = "伤害反弹",
        ["ru"] = "",
    },
    desc = {
        ["en"] = "Reflects damage when turret is being attacked\n+25% Damage to attacker per upgrade\n+5 Damage to all nearby enemies per upgrade",
		["fr"] = "Les tourelles renvoie les dégâts lorsqu'elles sont attaquées\n+25 % de dégâts à l'attaquant par amélioration\n+5 dégâts à tous les ennemis proches par amélioration",
        ["tr"] = "",
		["vi"] = "Phản xạ sát thương khi tháp pháo bị tấn công\n+25% Sát thương cho kẻ tấn công mỗi cấp\n+5 Sát thương cho tất cả kẻ địch gần đó mỗi cấp",
        ["zh-TW"] = "槍塔會反彈傷害至攻擊者\n每升級一次增加 25%對攻擊者的傷害",
        ["zh-CN"] = "枪塔会反弹伤害至攻击者\n每升级一次增加 25%对攻击者的伤害",
        ["ru"] = "",
    }
})