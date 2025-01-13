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

ZShelter.AddInfo("Health Boost", {
	title = {
		["en"] = "Health Boost",
		["bg"] = "Увеличаване на здравето",
		["fr"] = "Vitalité Croissante",
		["tr"] = "Sağlık",
		["vi"] = "Tăng Máu",
		["zh-TW"] = "體力提升",
		["zh-CN"] = "体力提升",
		["ru"] = "Укрепление здоровья",
		["de"] = "Gesundheitsschub",
	},
	desc = {
		["en"] = "Increases your maximum health everyday, +10 per upgrade",
		["bg"] = "Увеличава максималното ви здраве всеки ден, +10 на ъпгрейд",
		["fr"] = "Augmente votre santé maximale tous les jours, +10 par amélioration",
		["tr"] = "Her gün maksimum sağlığınızı artırır, yükseltme başına +10",
		["vi"] = "Tăng máu tối đa mỗi ngày, +10 máu mỗi lần nâng cấp",
		["zh-TW"] = "每日提升最大體力, 每升級一次增加 10",
		["zh-CN"] = "每天提升最大体力, 每升一级增加 10",
		["ru"] = "Увеличивает макс. запас здоровья каждый день, +10 ед. за улучшение",
		["de"] = "Erhöht deine maximale Gesundheit jeden Tag, +10 pro Upgrade",
	}
})

ZShelter.AddInfo("Damage Boost", {
	title = {
		["en"] = "Damage Boost",
		["bg"] = "Увеличаване на щетите",
		["fr"] = " Dégât Amélioré",
		["tr"] = "Hasar",
		["vi"] = "Tăng Sát Thương",
		["zh-TW"] = "傷害提升",
		["zh-CN"] = "伤害提升",
		["ru"] = "Усиление урона",
		["de"] = "Schadenssteigerung",
	},
	desc = {
		["en"] = "Increases your damage to enemies (excluding buildings), +10% per upgrade",
		["bg"] = "Увеличава щетите ви към врагове (с изключение на сгради), +10% на ъпгрейд",
		["fr"] = "Augmente les dégâts infligés aux ennemis ( sauf les bâtiments), +10% par amélioration",
		["tr"] = "Düşmanlara verilen hasarı artırır (yapılar hariç), yükseltme başına +%10",
		["vi"] = "Tăng sát thương cho kẻ thù (ngoại trừ các công trình), +10% mỗi lần nâng cấp",
		["zh-TW"] = "增加對敵人的傷害,每升級一次增加 10%",
		["zh-CN"] = "增加对敌人的伤害, 每升一级增加 10%",
		["ru"] = "Увеличивает урон по врагам (кроме строений), +10% за улучшение",
		["de"] = "Erhöht deinen Schaden gegenüber Gegnern (ausgenommen Gebäude), +10% pro Upgrade",
	}
})

ZShelter.AddInfo("Damage Boostx1", {
	title = {
		["en"] = "Damage Boost",
		["bg"] = "Увеличаване на щетите",
		["fr"] = "Dégât Amélioré",
		["tr"] = "Hasar",
		["vi"] = "Tăng Sát Thương",
		["zh-TW"] = "傷害提升",
		["zh-CN"] = "伤害提升",
		["ru"] = "Усиление урона",
		["de"] = "Schadenssteigerung",
	},
	desc = {
		["en"] = "Increases your damage to enemies (excluding buildings), +15% per upgrade",
		["bg"] = "Увеличава щетите ви към врагове (с изключение на сгради), +15% на ъпгрейд",
		["fr"] = "Augmente les dégâts infligés aux ennemis ( sauf les bâtiments), +15% par amélioration.",
		["tr"] = "Düşmanlara verilen hasarı artırır (yapılar hariç), yükseltme başına +%15",
		["vi"] = "Tăng sát thương cho kẻ thù (ngoại trừ các công trình), +15% mỗi lần nâng cấp",
		["zh-TW"] = "增加對敵人的傷害,每升級一次增加 15%",
		["zh-CN"] = "增加对敌人的伤害, 每升一级增加 15%",
		["ru"] = "Увеличивает урон по врагам (кроме строений), +15% за улучшение",
		["de"] = "Erhöht deinen Schaden gegenüber Gegnern (ausgenommen Gebäude), +15% pro Upgrade",
	}
})

ZShelter.AddInfo("Damage Boostx2", {
	title = {
		["en"] = "Damage Boost",
		["bg"] = "Увеличаване на щетите",
		["fr"] = "Dégât Amélioré",
		["tr"] = "Hasar",
		["vi"] = "Tăng Sát Thương",
		["zh-TW"] = "傷害提升",
		["zh-CN"] = "伤害提升",
		["ru"] = "Усиление урона",
		["de"] = "Schadenssteigerung",
	},
	desc = {
		["en"] = "Increases your damage to enemies (excluding buildings), +25% per upgrade",
		["bg"] = "Увеличава щетите ви към врагове (с изключение на сгради), +25% на ъпгрейд",
		["fr"] = "Augmente les dégâts infligés aux ennemis ( sauf les bâtiments), +25% par amélioration",
		["tr"] = "Düşmanlara verilen hasarı artırır (yapılar hariç), yükseltme başına +%25",
		["vi"] = "Tăng sát thương cho kẻ thù (ngoại trừ các công trình), +25% mỗi lần nâng cấp",
		["zh-TW"] = "增加對敵人的傷害,每升級一次增加 25%",
		["zh-CN"] = "增加对敌人的伤害, 每升一级增加 25%",
		["ru"] = "Увеличивает урон по врагам (кроме строений), +25% за улучшение",
		["de"] = "Erhöht deinen Schaden gegenüber Gegnern (ausgenommen Gebäude), +25% pro Upgrade",
	}
})

ZShelter.AddInfo("Looting", {
	title = {
		["en"] = "Looting",
		["bg"] = "Грабеж",
		["fr"] = "Butin",
		["tr"] = "Yağma",
		["vi"] = "Lấy Đồ",
		["zh-TW"] = "掠奪",
		["zh-CN"] = "掠夺",
		["ru"] = "Добыча",
		["de"] = "Plündern",
	},
	desc = {
		["en"] = "Drops resource bag when killing an enemy, +10% chance per upgrade",
		["bg"] = "Пуска торба с ресурси при убиване на враг, +10% шанс на ъпгрейд",
		["fr"] = "Les ennemis peuvent faire tomber un sac de ressources lorsqu'ils sont tués, +10% de chances par amélioration",
		["tr"] = "Düşman öldürdüğünüzde kaynak düşürür, yükseltme başına +%10",
		["vi"] = "Khi giết kẻ địch, có cơ hội rơi ra túi tài nguyên, +10% mỗi lần nâng cấp",
		["zh-TW"] = "殺敵時有機率掉落資源, 每升級一次增加 10%",
		["zh-CN"] = "击杀敌人时有概率掉落资源, 每升一级增加 10%",
		["ru"] = "Выпадают ресурсы при убийстве врага, +10% к шансу за улучшение",
		["de"] = "Lässt Ressourcenbeutel fallen, wenn ein Feind getötet wird, +10% Chance pro Upgrade",
	}
})

ZShelter.AddInfo("Armor Boost", {
	title = {
		["en"] = "Armor Boost",
		["bg"] = "Увеличаване на бронята",
		["fr"] = "Armure Amélioré",
		["tr"] = "Zırh Takviyesi",
		["vi"] = "Tăng Giáp",
		["zh-TW"] = "護甲提升",
		["zh-CN"] = "护甲提升",
		["ru"] = "Укрепление брони",
		["de"] = "Rüstungsverstärkung",
	},
	desc = {
		["en"] = "Increases maximum armor, +50 per upgrade",
		["bg"] = "Увеличава максималната броня, +50 на ъпгрейд",
		["fr"] = "Augmente votre armure maximale, +50 par amélioration",
		["tr"] = "Maksimum zırhı artırır, yükseltme başına +50",
		["vi"] = "Tăng giáp tối đa, +50 mỗi lần nâng cấp",
		["zh-TW"] = "增加護甲最大值,每升級一次增加 50",
		["zh-CN"] = "提高护甲上限, 每升一级增加 50",
		["ru"] = "Увеличивает макс. запас брони, +50 ед. за улучшение",
		["de"] = "Erhöht maximale Rüstung, +50 pro Upgrade",
	}
})

ZShelter.AddInfo("Machete Upgrade", {
	title = {
		["en"] = "Machete Upgrade",
		["bg"] = "Ъпгрейд на мачетето",
		["fr"] = "Machette",
		["tr"] = "Pala Yükseltmesi",
		["vi"] = "Nâng Cấp Dao Rựa",
		["zh-TW"] = "柴刀",
		["zh-CN"] = "柴刀",
		["ru"] = "Переход на мачете",
		["de"] = "Macheten-Upgrade",
	},
	desc = {
		["en"] = "Upgrades your melee weapon to machete (+173% damage)",
		["bg"] = "Подобрява вашето оръжие за близък бой на мачете (+173% щети)",
		["fr"] = "Améliore votre arme de mêlée en machette (+173% de dégâts)",
		["tr"] = "Yakın dövüş silahınızı palaya yükseltir (+%173 hasar)",
		["vi"] = "Nâng cấp vũ khí cận chiến thành dao rựa (+173% sát thương)",
		["zh-TW"] = "將近戰武器替換成柴刀 (+173%傷害)",
		["zh-CN"] = "将近战武器替换为柴刀 (+173%伤害)",
		["ru"] = "Переделать оружие ближнего боя в мачете (+173% к урону)",
		["de"] = "Verbessert deine Nahkampfwaffe zu einer Machete (+173% Schaden)",
	}
})

ZShelter.AddInfo("Damage Resistance", {
	title = {
		["en"] = "Damage Resistance",
		["bg"] = "Съпротива при щети",
		["fr"] = "Résistance aux Dégâts",
		["tr"] = "Hasar Direnci",
		["vi"] = "Kháng Sát Thương",
		["zh-TW"] = "提升防護",
		["zh-CN"] = "伤害吸收",
		["ru"] = "Сопротивление урону",
		["de"] = "Schadensresistenz",
	},
	desc = {
		["en"] = "Receives less damage from all sources, +15% per upgrade",
		["bg"] = "Получава по-малко щети от всички източници, +15% на ъпгрейд",
		["fr"] = "Réduit les dégâts de tout type, +15% par amélioration",
		["tr"] = "Bütün hasar kaynaklarından daha az hasar alırsınız, yükseltme başına +%15",
		["vi"] = "Nhận ít sát thương hơn từ tất cả các nguồn, +15% mỗi lần nâng cấp",
		["zh-TW"] = "減少受到的傷害,每升級一次減少 15%",
		["zh-CN"] = "减少收到的伤害, 每升一级减少 15%",
		["ru"] = "Получаете меньше урона от всех источников, +15% за улучшение",
		["de"] = "Erleidet weniger Schaden jeglichen Ursprungs, +15% pro Upgrade",
	}
})

ZShelter.AddInfo("Grenade Supply", {
	title = {
		["en"] = "Grenade Supply",
		["bg"] = "Доставяне на гранати",
		["fr"] = "Ravitaillement en Grenades",
		["tr"] = "El Bombası Tedariği",
		["vi"] = "Tiếp Tế Lựu Đạn",
		["zh-TW"] = "手榴彈補給",
		["zh-CN"] = "手榴弹补给",
		["ru"] = "Поставка гранат",
		["de"] = "Granatenvorrat",
	},
	desc = {
		["en"] = "Regenerates a grenade every 10 seconds",
		["bg"] = "Възстановява граната на всеки 10 секунди",
		["fr"] = "Vous obtenez une grenade toutes les 10 secondes",
		["tr"] = "10 saniyede bir el bombası üretir",
		["vi"] = "Tái tạo lựu đạn mỗi 10 giây",
		["zh-TW"] = "每10秒生成一顆手榴彈",
		["zh-CN"] = "每10秒生成一颗手榴弹",
		["ru"] = "Восстанавливает гранату каждые 10 секунд",
		["de"] = "Regeneriert eine Granate alle 10 Sekunden",
	}
})

ZShelter.AddInfo("Double Tap", {
	title = {
		["en"] = "Double Tap",
		["bg"] = "Двоен удар",
		["fr"] = "Double Coups",
		["tr"] = "İki Kat Hasar",
		["vi"] = "Nhấp Hai Lần",
		["zh-TW"] = "二次打擊",
		["zh-CN"] = "二次伤害",
		["ru"] = "Контрольный выстрел",
		["de"] = "Doppelte Schläge",
	},
	desc = {
		["en"] = "+10% chance to deal double damage every upgrade",
		["bg"] = "+10% шанс за нанасяне на двойни щети при всеки ъпгрейд",
		["fr"] = "+10% de chances d'infliger des dégâts double à chaque amélioration",
		["tr"] = "Her yükseltmede iki kat hasar verme şansınızı +%10 artırın",
		["vi"] = "+10% cơ hội gây sát thương gấp đôi mỗi lần nâng cấp",
		["zh-TW"] = "每升級一次增加 10% 機率造成雙倍傷害",
		["zh-CN"] = "每升级一次增加 10% 机率造成双倍伤害",
		["ru"] = "+10% шанс нанести двойной урон при каждом улучшении",
		["de"] = "+10% Chance, bei jedem Upgrade doppelten Schaden zu verursachen",
	}
})

ZShelter.AddInfo("Melee Stunning", {
	title = {
		["en"] = "Melee Stunning",
		["bg"] = "Зашеметяване с меле",
		["fr"] = "Coups Étourdissants",
		["tr"] = "Yakın Dövüş Sersemletmesi",
		["vi"] = "Cận Chiến Choáng",
		["zh-TW"] = "近戰暈眩",
		["zh-CN"] = "近战晕眩",
		["ru"] = "Оглушение в ближнем бою",
		["de"] = "Nahkampf-Betäubung",
	},
	desc = {
		["en"] = "Stun enemies for 0.75s when hitting enemies with battle axe's secondary attack",
		["bg"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "Оглушает врагов на 0,75 сек. при ударе дополнительной атакой боевым топором",
		["zh-TW"] = "使用戰斧的次要攻擊可暈眩敵人0.75秒",
		["zh-CN"] = "使用战斧的次要攻击可晕眩敌人0.75秒",
		["ru"] = "",
		["de"] = "",
	}
})

ZShelter.AddInfo("Airstrike", {
	title = {
		["en"] = "Airstrike",
		["bg"] = "Въздушен удар",
		["fr"] = "Frappe Aérienne",
		["tr"] = "Hava Saldırısı",
		["vi"] = "Không Kích",
		["zh-TW"] = "空襲",
		["zh-CN"] = "空袭",
		["ru"] = "Авиаудар",
		["de"] = "Luftschlag",
	},
	desc = {
		["en"] = "Launch a airstrike on the place you aiming at",
		["bg"] = "Извършва въздушен удар на мястото, към което целите",
		["fr"] = "Lance une frappe aérienne à l'endroit que vous visez",
		["tr"] = "Nişan aldığın yere hava saldırı başlat",
		["vi"] = "Không kích vào nơi bạn nhắm",
		["zh-TW"] = "對指定地點發動空襲",
		["zh-CN"] = "对选定地点发动空袭",
		["ru"] = "Наносит авиаудар по месту, на которое вы нацелились",
		["de"] = "Löse einen Luftschlag auf deinen anvisierten Ort aus",
	}
})

ZShelter.AddInfo("Combat Stimpack", {
	title = {
		["en"] = "Combat Stimpack",
		["bg"] = "Боен стимпак",
		["fr"] = "Stimulant de Combat",
		["tr"] = "Uyarıcı Savaş İlacı",
		["vi"] = "Thuốc Kích Thích Chiến Đấu",
		["zh-TW"] = "力量注射劑",
		["zh-CN"] = "力量药水",
		["ru"] = "Боевой стимулятор",
		["de"] = "Kampfstimulanz",
	},
	desc = {
		["en"] = "Temporary increases your damage by 500%",
		["bg"] = "Временно увеличава щетите ви с 500%",
		["fr"] = "Augmente temporairement vos dégâts de 500%",
		["tr"] = "Geçici olarak verdiğin hasarı %500 artırır",
		["vi"] = "Tăng sát thương tạm thời lên 500%",
		["zh-TW"] = "暫時提升500%傷害",
		["zh-CN"] = "暂时提升500%伤害",
		["ru"] = "Временно увеличивает наносимый урон на 500%",
		["de"] = "Erhöht deinen Schaden temporär um 500%",	
	}
})

ZShelter.AddInfo("Beginner Gun Mastery", {
	title = {
		["en"] = "Beginner Gun Mastery",
		["bg"] = "Майсторство на оръжия за начинаещи",
		["fr"] = "Maîtrise d'Armes Débutant",
		["tr"] = "Başlangıç ​​Seviyesi Silah Ustalığı",
		["vi"] = "Kỹ Năng Sử Dụng Súng Cơ Bản",
		["zh-TW"] = "基礎槍枝精通",
		["zh-CN"] = "基础枪支精通",
		["ru"] = "Мастер оружия начального уровня",
		["de"] = "Anfängerliche Waffenbeherrschung",
	},
	desc = {
		["en"] = "Allows you to craft SMG, Shotgun from workstation",
		["bg"] = "Позволява ви да изработвате пистолети-пулемети и дробовики от работната станция",
		["fr"] = "Permet de fabriquer des SMG et des fusils à pompe depuis un établi.",
		["tr"] = "İş istasyonundan SMG, Pompalı Tüfek üretmenize olanak sağlar",
		["vi"] = "Cho phép bạn chế tạo SMG, Súng Sục từ trạm làm việc",
		["zh-TW"] = "可從工作台製造衝鋒槍/霰彈槍",
		["zh-CN"] = "可从工作台制作冲锋枪/霰弹枪",
		["ru"] = "Позволяет создавать пистолеты-пулемёты и дробовики на верстаке",
		["de"] = "Ermöglicht dir das Herstellen von SMG und Schrotflinte an der Werkbank",
	}
})

ZShelter.AddInfo("Intermediate Gun Mastery", {
	title = {
		["en"] = "Intermediate Gun Mastery",
		["bg"] = "Майсторство на оръжия за напреднали",
		["fr"] = "Maîtrise d'Armes Intermédiaire",
		["tr"] = "Orta Seviye Silah Ustalığı",
		["vi"] = "Kỹ Năng Sử Dụng Súng Trung Cấp",
		["zh-TW"] = "中級槍枝精通",
		["zh-CN"] = "中级枪支精通",
		["ru"] = "Мастер оружия среднего уровня",
		["de"] = "Erweiterte Waffenbeherrschung",
	},
	desc = {
		["en"] = "Allows you to craft Rifle from workstation",
		["bg"] = "Позволява ви да изработвате винтовки от работната станция",
		["fr"] = "Permet de fabriquer des fusils depuis un établi",
		["tr"] = "İş istasyonundan Tüfek üretmenizi sağlar",
		["vi"] = "Cho phép bạn chế tạo Súng Trường từ trạm làm việc",
		["zh-TW"] = "可從工作台製造步槍",
		["zh-CN"] = "可从工作台制作步枪",
		["ru"] = "Позволяет создавать винтовки на верстаке",
		["de"] = "Ermöglicht dir die Herstellung des Gewehrs an der Werkbank",
	}
})

ZShelter.AddInfo("Advanced Gun Mastery", {
	title = {
		["en"] = "Advanced Gun Mastery",
		["bg"] = "Майсторство на оръжия за експерти",
		["fr"] = "Maîtrise d'Armes Avancée",
		["tr"] = "Gelişmiş Silah Ustalığı",
		["vi"] = "Kỹ Năng Sử Dụng Súng Nâng Cao",
		["zh-TW"] = "高級槍枝精通",
		["zh-CN"] = "高级枪支精通",
		["ru"] = "Мастер оружия продвинутого уровня",
		["de"] = "Fortgeschrittene Waffenbeherrschung",
	},
	desc = {
		["en"] = "Allows you to craft Machine gun / Explosives from workstation",
		["bg"] = "Позволява ви да изработвате картечници и експлозиви от работната станция",
		["fr"] = "Permet de fabriquer des armes lourdes et des explosifs depuis un établi",
		["tr"] = "İş istasyonundan Makineli Tüfek veya Patlayıcı üretmenizi sağlar",
		["vi"] = "Cho phép bạn chế tạo Súng Máy / Chất Nổ từ trạm làm việc",
		["zh-TW"] = "可從工作台製造機槍/爆裂物",
		["zh-CN"] = "可从工作台制造机枪/爆炸物",
		["ru"] = "Позволяет создавать пулемёты и взрывчатку на верстаке",
		["de"] = "Ermöglicht das Herstellen von Maschinengewehren und Sprengstoffen an der Werkbank",			
	}
})

ZShelter.AddInfo("Damage Amplifier", {
	title = {
		["en"] = "Damage Amplifier",
		["bg"] = "Усилвател на щетите",
		["fr"] = "Amplificateur de Dégâts",
		["tr"] = "Hasar Arttırıcı",
		["vi"] = "Khuếch Đại Sát Thương",
		["zh-TW"] = "群體傷害提升",
		["zh-CN"] = "群体伤害提升",
		["ru"] = "Усилитель урона",
		["de"] = "Schadensverstärker",
	},
	desc = {
		["en"] = "Increases all nearby player / turret's damage, +15% per upgrade",
		["bg"] = "Увеличава щетите на всички близки играчи/кули, +15% на ъпгрейд",
		["fr"] = "Augmente les dégâts de tous les joueurs/tourelles proches, +15% par amélioration",
		["tr"] = "Yakındaki tüm oyuncuların ve kulelerin hasarını artırır",
		["vi"] = "Tăng sát thương cho tất cả người chơi / tháp pháo gần đó, +15% mỗi lần nâng cấp",
		["zh-TW"] = "提升附近所有玩家/砲塔的傷害, 每升一级增加 15%",
		["zh-CN"] = "提升附近所有玩家/炮塔的伤害, 每升一级增加 15%",
		["ru"] = "Увеличивает урон всех ближайших игроков и турелей, +15% за улучшение",
		["de"] = "Erhöht den Schaden aller Spieler / Geschütztürme in der Nähe, +15% pro Upgrade",
	}
})

ZShelter.AddInfo("Vampire", {
	title = {
		["en"] = "Vampire",
		["bg"] = "Вампир",
		["fr"] = "Vampire",
		["tr"] = "Vampir",
		["vi"] = "Ma Cà Rồng",
		["zh-TW"] = "生命竊取",
		["zh-CN"] = "吸血鬼",
		["ru"] = "Вампир",
		["de"] = "Vampir",
	},
	desc = {
		["en"] = "Recovers health when damaging enemies with melee weapon, +10 HP per upgrade",
		["bg"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "使用近戰武器攻擊敵人時回復生命, 每升級一次回復 10 HP",
		["zh-CN"] = "使用近战武器攻击敌人时回复生命, 每升一级回复 10 HP",
		["ru"] = "Восстанавливает здоровье при нанесении урона врагам оружием ближнего боя,\n+10 ед. здоровья за обновление",
		["de"] = "",
	}
})

ZShelter.AddInfo("Self Recovering", {
	title = {
		["en"] = "Self Recovering",
		["bg"] = "Самовъзстановяване",
		["fr"] = "Régénération Continue",
		["tr"] = "Kendiliğinden İyileşme",
		["vi"] = "Tự Hồi Phục",
		["zh-TW"] = "生命回復",
		["zh-CN"] = "生命恢复",
		["ru"] = "Самовосстановление",
		["de"] = "Selbstheilung",
	},
	desc = {
		["en"] = "Recovers health every second, +2 HP recovery per upgrade",
		["bg"] = "Възстановява здраве всяка секунда, +2 HP на ъпгрейд",
		["fr"] = "Vous régénérez vos PV toutes les secondes, +2 PV par amélioration",
		["tr"] = "Her saniye sağlığı iyileştirir",
		["vi"] = "Hồi máu mỗi giây, +2 HP hồi phục mỗi lần nâng cấp",
		["zh-TW"] = "每秒鐘回復生命值",
		["zh-CN"] = "每秒钟回复一定生命值",
		["ru"] = "Восстанавливает здоровье ежесекундно, +2 ед. здоровья за улучшение",
		["de"] = "Regeneriert Gesundheit jede Sekunde, +2HP Regenerierung pro Upgrade",
	}
})

ZShelter.AddInfo("Double Trigger", {
	title = {
		["en"] = "Double Trigger",
		["bg"] = "Двоен спусък",
		["fr"] = "Double Détente",
		["tr"] = "Çift Tetikleyici",
		["vi"] = "Kích Hoạt Kép",
		["zh-TW"] = "雙擊板機",
		["zh-CN"] = "双重扳机",
		["ru"] = "Двойной выстрел",
		["de"] = "Doppelter Auslöser",
	},
	desc = {
		["en"] = "Attack additional targets when you shoot\n+1 Target per upgrade\n+10 Damage per upgrade (Base damage 25)",
		["bg"] = "Атакува допълнителни цели, когато стреляте\n+1 цел на ъпгрейд\n+10 щети на ъпгрейд (основни щети 25)",
		["fr"] = "Permet d'attaquer des cibles supplémentaires lorsque vous tirez\n+1 Cible par amélioration\n+10 Dégâts par amélioration (Dégâts de Base 25)",
		["tr"] = "Ateş ettiğinizde birçok hedefe saldırın\nYükseltme başına +1 hedef\nYükseltme başına +10 Hasar (Temel hasar 25)",
		["vi"] = "Tấn công mục tiêu bổ sung khi bắn\n+1 Mục tiêu mỗi lần nâng cấp\n+10 Sát thương mỗi lần nâng cấp (Sát thương cơ bản 25)",
		["zh-TW"] = "開火時額外多攻擊一個目標\n每升級一次多增加一個攻擊目標\n每升級一次多增加 10 傷害 (基礎傷害25)",
		["zh-CN"] = "开火时额外攻击一个目标\n每升一级增加一个攻击目标\n每升一级增加 10 伤害 (基础伤害为25)",
		["ru"] = "Атакуйте дополнительные цели, когда стреляете\n+1 цель за улучшение\n+10 ед. урона за улучшение (основной урон: 25 ед.)",
		["de"] = "Zusätzliche Ziele angreifen, wenn du schießt\n+1 Ziel pro Upgrade\n+10 Schaden pro Upgrade (Grundschaden 25)",
	}
})

ZShelter.AddInfo("Grenade Stunning", {
	title = {
		["en"] = "Grenade Stunning",
		["bg"] = "Зашеметяване с граната",
		["fr"] = "Grenade Étourdissante",
		["tr"] = "El Bombasıyla Sersemletme",
		["vi"] = "Lựu Đạn Choáng",
		["zh-TW"] = "暈眩彈",
		["zh-CN"] = "晕眩弹",
		["ru"] = "Оглушающая граната",
		["de"] = "Granatenbetäubung",
	},
	desc = {
		["en"] = "Grenade can stun enemies, +2.5s per upgrade",
		["bg"] = "Гранатата може да зашеметява врагове, +2.5 секунди на ъпгрейд",
		["fr"] = "Vos grenades peuvent étourdir les ennemis, +2.5s par amélioration",
		["tr"] = "El bombası düşmanları sersemletebilir, yükseltme başına +2.5 saniye",
		["vi"] = "Lựu đạn có thể làm choáng kẻ địch, +2.5s mỗi lần nâng cấp",
		["zh-TW"] = "手榴彈可以暈眩敵人, 每升級一次增加 2.5 秒",
		["zh-CN"] = "手榴弹可以晕眩敌人, 每升一级增加 2.5 秒",
		["ru"] = "Гранаты могут оглушать врагов, +2,5 сек. за улучшение",
		["de"] = "Granate kann Gegner betäuben, +2,5s pro Upgrade",
	}
})

ZShelter.AddInfo("Aim Assist", {
	title = {
		["en"] = "Aim Assist",
		["bg"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "輔助瞄準",
		["zh-CN"] = "辅助瞄准",
		["ru"] = "Помощь в прицеливании",
		["de"] = "",
	},
	desc = {
		["en"] = "Auto aims the enemy for you\nHold use key to active",
		["bg"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "自動瞄準敵人\n按住使用鍵啟動",
		["zh-CN"] = "自动瞄准敌人\n按住使用键激活",
		["ru"] = "Автоматическое наведение на врага\nУдерживайте клавишу использования для применения",
		["de"] = "",
	}
})

ZShelter.AddInfo("Armor Regenerate", {
	title = {
		["en"] = "Armor Regenerate",
		["bg"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "護甲修復",
		["zh-CN"] = "护甲修复",
		["ru"] = "Восстановление брони",
		["de"] = "",
	},
	desc = {
		["en"] = "Recovers armor every second, +1 per upgrade",
		["bg"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "每秒鐘恢復護甲, 每升級一次增加 1",
		["zh-CN"] = "每秒钟恢复护甲, 每升级一次增加 1",
		["ru"] = "Восстанавливает броню ежесекундно, +1 ед. брони за улучшение",
		["de"] = "",
	}
})

ZShelter.AddInfo("Battle Axe Upgrade", {
	title = {
		["en"] = "Battle Axe Upgrade",
		["bg"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "戰斧",
		["zh-CN"] = "战斧",
		["ru"] = "Переход на боевой топор",
		["de"] = "",
	},
	desc = {
		["en"] = "Upgrade melee weapon to battle axe, able to hit multiple enemies, can knockback enemies",
		["bg"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "將近戰武器替換成戰斧, 可以攻擊多個敵人, 並擊退敵人",
		["zh-CN"] = "将近战武器替换为战斧, 可以攻击多个敌人, 并击退敌人",
		["ru"] = "Переделать оружие ближнего боя в боевой топор, способный поражать нескольких врагов и\nотбрасывать врагов",
		["de"] = "",
	}
})

ZShelter.AddInfo("Firerate Boost", {
	title = {
		["en"] = "Firerate Boost",
		["bg"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "射速提升",
		["zh-CN"] = "射速提升",
		["ru"] = "Повышение скорострельности",
		["de"] = "",
	},
	desc = {
		["en"] = "Boost firerate on Hitscan based weapons, +10% firerate per upgrade",
		["bg"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "提升Hitscan武器的射速, 每升級一次增加 10%",
		["zh-CN"] = "提升Hitscan武器的射速, 每升级一次增加 10%",
		["ru"] = "Повышает скорострельность оружия с мгновенным попаданием,\n+10% к скорострельности за улучшение",
		["de"] = "",
	}
})

ZShelter.AddInfo("Damage Reflecting", {
	title = {
		["en"] = "Damage Reflecting",
		["bg"] = "Отразяване на щетите",
		["fr"] = "Réflexion des Dégâts",
		["tr"] = "Hasar Yansıtma",
		["vi"] = "Phản Sát Thương",
		["zh-TW"] = "傷害反彈",
		["zh-CN"] = "伤害反弹",
		["ru"] = "Отражение урона",
		["de"] = "Schadensablenkung",
	},
	desc = {
		["en"] = "Reflecting all incoming damage, +400% damage per upgrade",
		["bg"] = "Отразява всички входящи щети, +400% щети на ъпгрейд",
		["fr"] = "Renvoie tous les dégâts subis, +400% de dégâts par amélioration",
		["tr"] = "Alınan tüm hasarı yansıtır, yükseltme başına +%400 hasar",
		["vi"] = "Phản sát thương đến từ tất cả các nguồn, +400% sát thương mỗi lần nâng cấp",
		["zh-TW"] = "反彈所有受到的傷害, 每升級一次增加 400%",
		["zh-CN"] = "反弹所有受到的伤害, 每升级一次增加 400%",
		["ru"] = "Отражение всего получаемого урона, +400% урона за улучшение",
		["de"] = "Lenkt jeden eingehenden Schaden ab, +400% Schaden pro Upgrade",
	}
})

ZShelter.AddInfo("Layered Defense", {
	title = {
		["en"] = "Layered Defense",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "多層防禦",
		["zh-CN"] = "多层防御",
		["ru"] = "Многослойная защита",
	},
	desc = {
		["en"] = "Regenerates a shield every 8 seconds, shield breaks after taking any amount of damage\nWhen shield breaks, recover 7% of maximum health (Every layer provides extra 3% of health)\n+1 Layer per upgrade\n-1 second cooldown per melee kills",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "每 8 秒回復一層護盾, 受到任何傷害後護盾破碎\n當護盾破碎時, 回復 7% 最大生命值 (每層提供額外 3% 最大生命值)\n每升級一次增加 1 層\n每次近戰擊殺減少 1 秒冷卻時間",
		["zh-CN"] = "每 8 秒回复一层护盾, 受到任何伤害后护盾破碎\n当护盾破碎时, 回复 7% 最大生命值 (每层提供额外 3% 最大生命值)\n每升级一次增加 1 层\n每次近战击杀减少 1 秒冷却时间",
		["ru"] = "Восстанавливает щит каждые 8 секунд, щит разрушается при получении любого урона\nПри разрушении щита восстанавливается 7% от макс. запаса здоровья (каждый слой даёт доп. 3% здоровья)\n+1 слой за улучшение\n-1 сек. восстановления за каждое убийство в ближнем бою",
	}
})

ZShelter.AddInfo("Silencer", {
	title = {
		["en"] = "Silencer",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "消音器",
		["zh-CN"] = "消音器",
		["ru"] = "Глушитель",
	},
	desc = {
		["en"] = "Decrease noises from weapons, -10% per upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "減少武器噪音, 每升級一次減少 10%",
		["zh-CN"] = "减少武器噪音, 每升级一次减少 10%",
		["ru"] = "Уменьшает шум от оружия, -10% за улучшение",
	}
})

ZShelter.AddInfo("Bullet Saving", {
	title = {
		["en"] = "Bullet Saving",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "節省彈藥",
		["zh-CN"] = "节省弹药",
		["ru"] = "Экономия пуль",
	},
	desc = {
		["en"] = "Small chance to not consume ammo when shooting a hitscan weapon, +15% per upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "射擊 Hitscan 武器時有機率不消耗彈藥, 每升級一次增加 15%",
		["zh-CN"] = "射击 Hitscan 武器时有机率不消耗弹药, 每升级一次增加 15%",
		["ru"] = "Небольшой шанс не потратить патроны при стрельбе из оружия с мгновенным попаданием, +15% за улучшение",
	}
})

ZShelter.AddInfo("Ammo Capacity Boost", {
	title = {
		["en"] = "Ammo Capacity Boost",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "",
		["zh-CN"] = "",
		["ru"] = "Увеличение вместимости боеприпасов",
	},
	desc = {
		["en"] = "Increase ammo capacity, +100% per upgrade",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "增加攜彈量, 每升級一次增加 100%",
		["zh-CN"] = "增加携弹量, 每升级一次增加 100%",
		["ru"] = "Увеличивает боезапас, +100% за улучшение",
	}
})

ZShelter.AddInfo("Quick Reload", {
	title = {
		["en"] = "Quick Reload",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "快速裝填",
		["zh-CN"] = "快速装填",
		["ru"] = "Быстрая перезарядка",
	},
	desc = {
		["en"] = "Increase shotgun's reload speed, load two shells at once",
		["bg"] = "",
		["de"] = "",
		["fr"] = "",
		["tr"] = "",
		["vi"] = "",
		["zh-TW"] = "增加霰彈槍的裝彈速度, 一次裝兩發",
		["zh-CN"] = "增加霰弹枪的装弹速度, 一次装两发",
		["ru"] = "Увеличивает скорость перезарядки дробовиков, заряжает два патрона одновременно",
	}
})
