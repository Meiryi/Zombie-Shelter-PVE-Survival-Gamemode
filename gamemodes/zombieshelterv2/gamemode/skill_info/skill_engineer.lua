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

	DE :
	Zombie Shelter v2.0 von Meiryi / Meika / Shiro / Shigure
	Sie sollten die Codes NICHT bearbeiten / ändern / erneut hochladen, dies beinhaltet die Bearbeitung des Namens des Spielmodus.
	Wenn irgendwelche Probleme auftreten, können Sie mich gerne über Steam kontaktieren. Vielen Dank fürs Lesen.
	
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

--[[
ZShelter.AddInfo("", {
	title = {
		["en"] = "",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "",
		["zh-CN"] = "",
		["ru"] = "",
	},
	desc = {
		["en"] = "",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "",
		["zh-CN"] = "",
		["ru"] = "",
	}
})
]]

ZShelter.AddInfo("Basic Engineering", {
	title = {
		["en"] = "Basic Engineering",
		["bg"] = "Основно инженерство",
		["de"] = "Grundlegendes Ingenieurswesen",
		["fr"] = "Ingénierie de Base",
		["tr"] = "Temel Mühendislik",
		["vi"] = "Kỹ Sư Cơ Bản",
		["zh-TW"] = "基礎工程學",
		["zh-CN"] = "基础工程学",
		["ru"] = "Инженер начального уровня",
	},
	desc = {
		["en"] = "Allows you to build advanced turrets",
		["bg"] = "Позволява ви да изграждате напреднали кули",
		["de"] = "Ermöglicht den Bau fortschrittlicher Geschütztürme",
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
		["bg"] = "Увеличаване на скоростта на строеж",
		["de"] = "Baugeschwindigkeitssteigerung",
		["fr"] = "Vitesse de Construction Améliorée",
		["tr"] = "İnşa Hızı",
		["vi"] = "Tăng Tốc Độ Xây Dựng",
		["zh-TW"] = "增加建造速度",
		["zh-CN"] = "增加建造速度",
		["ru"] = "Увеличение скорости сборки",
	},
	desc = {
		["en"] = "Increases build speed +35% per upgrade",
		["bg"] = "Увеличава скоростта на строеж с +35% на ъпгрейд",
		["de"] = "Erhöht die Baugeschwindigkeit um +35 % pro Upgrade",
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
		["bg"] = "Подобрено чертежно умение",
		["de"] = "Verbesserter Bauplan",
		["fr"] = "Schéma Amélioré",
		["tr"] = "Gelişmiş Plan",
		["vi"] = "Bản Học Cải Tiến",
		["zh-TW"] = "藍圖改進",
		["zh-CN"] = "蓝图改进",
		["ru"] = "Улучшение проекта",
	},
	desc = {
		["en"] = "Decreases resource cost, -10% per upgrade",
		["bg"] = "Намалява разхода на ресурси с -10% на ъпгрейд",
		["de"] = "Reduziert die Ressourcenkosten um -10 % pro Upgrade",
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
		["bg"] = "Електрическо инженерство",
		["de"] = "Elektrotechnik",
		["fr"] = "Ingénierie Électrique",
		["tr"] = "Elektrik Mühendisliği",
		["vi"] = "Kỹ Sư Điện",
		["zh-TW"] = "電機工程學",
		["zh-CN"] = "电气工程学",
		["ru"] = "Инженер-электрик",
	},
	desc = {
		["en"] = "Decreases power usage, -10% per upgrade",
		["bg"] = "Намалява използването на енергия с -10% на ъпгрейд",
		["de"] = "Reduziert den Stromverbrauch um -10 % pro Upgrade",
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
		["bg"] = "Увеличаване на щетите от кулите",
		["de"] = "Geschützturmschaden Boost",
		["fr"] = "Dégâts des Tourelles Améliorée",
		["tr"] = "Taret Hasar Yükseltmesi",
		["vi"] = "Tăng Sát Thương Tháp Pháo",
		["zh-TW"] = "提升槍塔傷害",
		["zh-CN"] = "炮塔伤害提升",
		["ru"] = "Усиление урона турели",
	},
	desc = {
		["en"] = "Increases turret's damage, +10% per upgrade",
		["bg"] = "Увеличава щетите на кулите с +10% на ъпгрейд",
		["de"] = "Erhöht den Schaden des Geschützturms um +10 % pro Upgrade.",
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
		["bg"] = "Напреднало инженерство",
		["de"] = "Fortschrittliches Ingenieurswesen",
		["fr"] = "Ingénierie de Pointe",
		["tr"] = "Gelişmiş Mühendislik",
		["vi"] = "Kỹ Sư Nâng Cao",
		["zh-TW"] = "進階工程學",
		["zh-CN"] = "进阶工程学",
		["ru"] = "Продвинутое проектирование",
	},
	desc = {
		["en"] = "Allows you to build special buildings",
		["bg"] = "Позволява ви да изграждате специални сгради",
		["de"] = "Ermöglicht den Bau spezieller Gebäude",
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
		["bg"] = "Увеличаване на скоростта на ремонт",
		["de"] = "Reparaturgeschwindigkeitssteigerung",
		["fr"] = "Réparation Accélérée",
		["tr"] = "Tamir Hızı",
		["vi"] = "Tăng Tốc Độ Sửa Chữa",
		["zh-TW"] = "增加修復速度",
		["zh-CN"] = "增加修复速度",
		["ru"] = "Увеличение скорости ремонта",
	},
	desc = {
		["en"] = "Increases repair speed, +15% per upgrade",
		["bg"] = "Увеличава скоростта на ремонт с +15% на ъпгрейд",
		["de"] = "Erhöht die Reparaturgeschwindigkeit um +15 % pro Upgrade",
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
		["bg"] = "Автоматичен ремонт",
		["de"] = "Automatische Reparatur",
		["fr"] = "Réparation Automatique",
		["tr"] = "Otomatik Tamir",
		["vi"] = "Tự Động Sửa Chữa",
		["zh-TW"] = "自動修復",
		["zh-CN"] = "自动修复",
		["ru"] = "Авторемонт",
	},
	desc = {
		["en"] = "Auto repairs nearby buildings, +256 unit radius and 20% repair speed per upgrade",
		["bg"] = "Автоматично ремонтира близките сгради, +256 единици радиус и 20% скорост на ремонт на ъпгрейд",
		["de"] = "Automatische Reparaturen nahegelegener Gebäude, +256 Einheitenradius und 20 % Reparaturgeschwindigkeit pro Upgrade",
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
		["bg"] = "Ъпгрейд на чук за строеж",
		["de"] = "Klauenhammer Upgrade",
		["fr"] = "Marteau",
		["tr"] = "Pençe Çekiç",
		["vi"] = "Nâng Cấp Búa Nhổ Đinh",
		["zh-TW"] = "尖頭槌",
		["zh-CN"] = "尖头锤",
		["ru"] = "Переход на молоток",
	},
	desc = {
		["en"] = "Upgrades your melee weapon to clawhammer (+50% build and repair speed)",
		["bg"] = "Подобрява оръжието ви за близък бой на чук (+50% скорост на строеж и ремонт)",
		["de"] = "Rüstet deine Nahkampfwaffe zum Klauenhammer auf (+50 % Bau- und Reparaturgeschwindigkeit)",
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
		["bg"] = "Увеличаване на здравето на сградите",
		["de"] = "Gebäuden-Gesundheitsboost",
		["fr"] = "Renforcement des Constructions",
		["tr"] = "Yapı Sağlık Yükseltmesi",
		["vi"] = "Tăng Máu Công Trình",
		["zh-TW"] = "增加建築物耐久",
		["zh-CN"] = "增加建筑物耐久",
		["ru"] = "Укрепление прочности строений",
	},
	desc = {
		["en"] = "Increases building's health, +10% per upgrade",
		["bg"] = "Увеличава здравето на сградите с +10% на ъпгрейд",
		["de"] = "Erhöht die Gesundheit des Gebäudes um +10 % pro Upgrade.",
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
		["bg"] = "Експертно инженерство",
		["de"] = "Kompetente Ingenieurstechnik",
		["fr"] = "Expert en Ingénierie",
		["tr"] = "Uzman Mühendislik",
		["vi"] = "Kỹ Sư Chuyên Nghiệp",
		["zh-TW"] = "高階工程學",
		["zh-CN"] = "高阶工程学",
		["ru"] = "Проектирование эксперта",
	},
	desc = {
		["en"] = "Allows you to build advanced buildings",
		["bg"] = "Позволява ви да изграждате напреднали сгради",
		["de"] = "Ermöglicht den Bau fortgeschrittener Gebäude",
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
		["bg"] = "Верижен ремонт",
		["de"] = "Kettenreparatur",
		["fr"] = "Réparation à la Chaîne",
		["tr"] = "Zincirleme Tamir",
		["vi"] = "Sửa Chữa Mắt Xích",
		["zh-TW"] = "連鎖修復",
		["zh-CN"] = "连锁修复",
		["ru"] = "Цепной ремонт",
	},
	desc = {
		["en"] = "Repairs all nearby buildings, +64 unit radius and 20% repair speed per upgrade",
		["bg"] = "Ремонтира всички близки сгради, +64 единици радиус и 20% скорост на ремонт на ъпгрейд",
		["de"] = "Repariert alle Gebäude in der Nähe, +64 Einheitenradius und 20 % Reparaturgeschwindigkeit pro Upgrade",
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
		["bg"] = "Прегряване",
		["de"] = "Overheal",
		["fr"] = "Rénovation",
		["tr"] = "Gelişmiş İyileştirme",
		["vi"] = "Hồi Phục Quá Mức",
		["zh-TW"] = "超量修復",
		["zh-CN"] = "超量修复",
		["ru"] = "Сверхпрочность",
	},
	desc = {
		["en"] = "Temporary increases building's maximum health, +25% health per upgrade\nOverhealed building won't be stunned\n*Only work when repairing manually*",
		["bg"] = "Временно увеличава максималното здраве на сградата с +25% на ъпгрейд\nПрегрятата сграда няма да бъде зашеметена\n*Работи само при ръчен ремонт*",
		["de"] = "Erhöht vorübergehend die maximale Gesundheit des Gebäudes, +25 % Gesundheit pro Upgrade\nÜberheilte Gebäude werden nicht betäubt\n*Funktioniert nur bei manueller Reparatur*",
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
		["bg"] = "Рециклиране",
		["de"] = "Recycling",
		["fr"] = "Recyclage",
		["tr"] = "Geri Dönüşüm",
		["vi"] = "Tái Chế",
		["zh-TW"] = "資源回收",
		["zh-CN"] = "资源回收",
		["ru"] = "Переработка",
	},
	desc = {
		["en"] = "Returns resources when building got destroyed, +20% per upgrade",
		["bg"] = "Връща ресурси при разрушаване на сграда, +20% на ъпгрейд",
		["de"] = "Gibt Ressourcen zurück, wenn ein Gebäude zerstört wurde, +20 % pro Upgrade",
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
		["bg"] = "Саморазрушение",
		["de"] = "Selbstdetonation",
		["fr"] = "Autodestruction",
		["tr"] = "Kendini İmha Etme",
		["vi"] = "Tự Hủy",
		["zh-TW"] = "自我毀滅",
		["zh-CN"] = "自我毁灭",
		["ru"] = "Самоуничтожение",
	},
	desc = {
		["en"] = "When a turret gets destroyed, it'll damage all nearby enemy",
		["bg"] = "Когато кула бъде разрушена, тя ще нанася щети на всички близки врагове",
		["de"] = "Wenn ein Geschützturm zerstört wird, fügt er allen Gegnern in der Nähe Schaden zu.",
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
		["bg"] = "Транспортиращ дрон",
		["de"] = "Transportdrohne",
		["fr"] = "Drone de Transport",
		["tr"] = "Aktarım Dronu",
		["vi"] = "Vận Chuyển Bằng Drone",
		["zh-TW"] = "運輸無人機",
		["zh-CN"] = "运输无人机",
		["ru"] = "Дрон-транспортировщик",
	},
	desc = {
		["en"] = "Allows you to use resources directly from storage to build",
		["bg"] = "Позволява ви да използвате ресурси директно от склада за строеж",
		["de"] = "Ermöglicht die Nutzung von Ressourcen direkt aus dem Speicher zum Erstellen",
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
		["bg"] = "C4",
		["de"] = "C4",
		["fr"] = "C4",
		["tr"] = "C4",
		["vi"] = "C4",
		["zh-TW"] = "C4",
		["zh-CN"] = "C4",
		["ru"] = "Взрывчатка C4",
	},
	desc = {
		["en"] = "A C4 can be used to destroy obstacles",
		["bg"] = "C4 може да бъде използвано за унищожаване на препятствия",
		["de"] = "Mit einem C4 können Hindernisse zerstört werden",
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
		["bg"] = "Аура на ремонт",
		["de"] = "Reparatur Aura",
		["fr"] = "Aura de Réparation",
		["tr"] = "Tamir Aurası",
		["vi"] = "Hào Quang Sửa Chữa",
		["zh-TW"] = "維修光環",
		["zh-CN"] = "维修光环",
		["ru"] = "Аура ремонта",
	},
	desc = {
		["en"] = "Auto repairs all nearby buildings with 300% speed",
		["bg"] = "Автоматично ремонтира всички близки сгради с 300% скорост",
		["de"] = "Repariert automatisch alle Gebäude in der Nähe mit 300 % Geschwindigkeit",
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
		["bg"] = "Отразяване на щетите",
		["de"] = "Schadensreflexion",
		["fr"] = "Réflexion des Dégâts",
		["tr"] = "Hasar Yansıtma",
		["vi"] = "Phản Xạ Sát Thương",
		["zh-TW"] = "傷害反彈",
		["zh-CN"] = "伤害反弹",
		["ru"] = "",
	},
	desc = {
		["en"] = "Reflects damage when turret is being attacked\n+25% Damage to attacker per upgrade\n+5 Damage to all nearby enemies per upgrade",
		["bg"] = "Отразява щети, когато кулата е атакувана\n+25% щети към нападателя на ъпгрейд\n+5 щети към всички близки врагове на ъпгрейд",
		["de"] = "Reflektiert Schaden, wenn der Turm angegriffen wird\n+25 % Schaden für den Angreifer pro Upgrade\n+5 Schaden für alle Gegner in der Nähe pro Upgrade",
		["fr"] = "Les tourelles renvoie les dégâts lorsqu'elles sont attaquées\n+25 % de dégâts à l'attaquant par amélioration\n+5 dégâts à tous les ennemis proches par amélioration",
		["tr"] = "",
		["vi"] = "Phản xạ sát thương khi tháp pháo bị tấn công\n+25% Sát thương cho kẻ tấn công mỗi cấp\n+5 Sát thương cho tất cả kẻ địch gần đó mỗi cấp",
		["zh-TW"] = "槍塔會反彈傷害至攻擊者\n每升級一次增加 25%對攻擊者的傷害",
		["zh-CN"] = "枪塔会反弹伤害至攻击者\n每升级一次增加 25%对攻击者的伤害",
		["ru"] = "",
	}
})

ZShelter.AddInfo("Defense Matrix", {
	title = {
		["en"] = "Defense Matrix",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "防禦矩陣",
		["zh-CN"] = "防御矩阵",
		["ru"] = "",
	},
	desc = {
		["en"] = "Increases turret's defense when you place them near each other\n+25% Maximum damage resistance per upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "",
		["zh-CN"] = "",
		["ru"] = "",
	}
})

ZShelter.AddInfo("Armor Repairing", {
	title = {
		["en"] = "Armor Repairing",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "護甲修復",
		["zh-CN"] = "护甲修复",
		["ru"] = "",
	},
	desc = {
		["en"] = "Allow you to repair teammate's armor by hitting them with melee\n+7.5 Armor per upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "可以使用近戰武器修復隊友的護甲\n每升級一次增加 7.5 護甲",
		["zh-CN"] = "可以使用近战武器修复队友的护甲\n每升级一次增加 7.5 护甲",
		["ru"] = "",
	}
})

ZShelter.AddInfo("Quick Deploy", {
	title = {
		["en"] = "Quick Deploy",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "快速部屬",
		["zh-CN"] = "快速部署",
		["ru"] = "",
	},
	desc = {
		["en"] = "Buildings will have some of it's health when being deployed\n+17.5% Health per upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "部署建築物時會有一部分的生命值\n每升級一次增加 17.5% 生命值",
		["zh-CN"] = "部署建筑物时会有一部分的生命值\n每升级一次增加 17.5% 生命值",
		["ru"] = "",
	}
})

ZShelter.AddInfo("Precision Suppression", {
	title = {
		["en"] = "Precision Suppression",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "精確壓制",
		["zh-CN"] = "精确压制",
		["ru"] = "",
	},
	desc = {
		["en"] = "Damage will gradually increase when shooting at the same target\n+25% Maximum damage per upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "對同一目標持續射擊時傷害會逐漸增加\n每升級一次增加 25% 最大傷害",
		["zh-CN"] = "对同一目标持续射击时伤害会逐渐增加\n每升级一次增加 25% 最大伤害",
		["ru"] = "",
	}
})