--[[
	EN :
	Zombie Shelter v2.0 by Meiryi / Meika / Shiro / Shigure
	You SHOULD NOT edit / modify / reupload the codes, it includes editing gamemode's name
	If you have any problems, feel free to contact me on steam, thank you for reading this

	VI :
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

ZShelter.Lang = {}

function ZShelter.L(index, tab)
	ZShelter.Lang[index] = tab
end

--[[
ZShelter.L("#",{
	["bg"] = "",
	["cs"] = "",
	["da"] = "",
	["de"] = "",
	["el"] = "",
	["en"] = "",
	["en-PT"] = "",
	["es-ES"] = "",
	["et"] = "",
	["fi"] = "",
	["fr"] = "",
	["he"] = "",
	["hr"] = "",
	["hu"] = "",
	["it"] = "",
	["ja"] = "",
	["ko"] = "",
	["lt"] = "",
	["nl"] = "",
	["no"] = "",
	["pt-BR"] = "",
	["pt-PT"] = "",
	["ru"] = "",
	["sk"] = "",
	["sv-SE"] = "",
	["th"] = "",
	["tr"] = "",
	["uk"] = "",
	["vi"] = "",
	["zh-CN"] = "",
	["zh-TW"] = "",	
})
]]

ZShelter.L("#SkillPTS", {
	["en"] = "Skill menu - [N] | Remaining points : ",
	["bg"] = "Меню за умения - [N] | Оставащи точки: ",
	["de"] = "Skill menü - [N] | Verbleibende Skillpunkte : ",
	["fr"] = "Compétences - [N] | Points restants : ",
	["tr"] = "Yetenek menüsü - [N] | Kalan puan : ",
	["ru"] = "Меню навыков - [N] | Осталось очков : ",
	["vi"] = "Menu kỹ năng - [N] | Điểm còn lại : ",
	["zh-TW"] = "技能樹 - [N] | 剩餘點數 : ",
	["zh-CN"] = "技能树 - [N] | 剩余点数: ",
})

ZShelter.L("#GameStartAfter", {
	["en"] = "Game will start after <VAR> seconds",
	["bg"] = "Играта ще започне след <VAR> секунди",
	["de"] = "Das Spiel wird in <VAR> Sekunden starten",
	["fr"] = "La partie commence dans <VAR> secondes",
	["tr"] = "Oyun <VAR> saniye sonra başlayacak",
	["ru"] = "Игра начнётся через <VAR> сек.",
	["vi"] = "Trò chơi sẽ bắt đầu sau <VAR> giây",
	["zh-TW"] = "遊戲將在 <VAR> 秒後開始",
	["zh-CN"] = "游戏将在 <VAR> 秒后开始",
})

ZShelter.L("#RespawnAfter", {
	["en"] = "Respawn after <VAR> seconds",
	["bg"] = "Раждане след <VAR> секунди",
	["de"] = "Respawn verfügbar in <VAR> Sekunden",
	["fr"] = "Réapparition dans <VAR> secondes",
	["tr"] = "<VAR> saniye sonra yeniden canlanılacak",
	["ru"] = "Возрождение через <VAR> сек.",
	["vi"] = "Hồi sinh sau <VAR> giây",
	["zh-TW"] = "在 <VAR> 秒後重生",
	["zh-CN"] = "将在 <VAR> 秒后重生",
})

ZShelter.L("#BuildingHint", {
	["en"] = "[Left Click] Build   |  [R] Rotate  |   [Right Click] Cancel",
	["bg"] = "[Ляв бутон] Строеж   |  [R] Завъртане  |   [Десен бутон] Отказ",
	["de"] = "[Linksklick] Bauen   |  [R] Drehen  |   [Rechtsklick] Abbrechen",
	["fr"] = "[Clic Gauche] Construire | [R] Pivoter | [Clic Droit] Annuler",
	["tr"] = "[Sol Tık] İnşa Et   |  [R] Döndür  |   [Sağ Tık] İptal",
	["ru"] = "[ЛКМ] Построить   |  [R] Вращать  |   [ПКМ] Отмена",
	["vi"] = "[Nhấn Chuột Trái] Xây Dựng   |  [R] Xoay  |   [Nhấn Chuột Phải] Hủy",
	["zh-TW"] = "[左鍵] 建造  |  [R] 旋轉  |  [右鍵] 取消",
	["zh-CN"] = "[左键] 建造  |  [R] 旋转  |  [右键] 取消",
})

ZShelter.L("#BuildHints", {
	["en"] = "[B] Build Menu  |  [F2] Game Menu  |  [F6] Config Menu",
	["bg"] = "[B] Меню за строеж  |  [F2] Меню на играта  |  [F6] Меню за настройки",
	["de"] = "[B] Baumenü  |  [F2] Spielmenü  |  [F6] Konfigmenü",
	["fr"] = "[B] Menu de Construction | [F2] Menu du Jeu | [F6] Menu de Configuration",
	["tr"] = "[B] Yapı Menüsü  |  [F2] Oyun Menüsü  |  [F6] Konfig Menüsü",
	["ru"] = "[B] Постройки  |  [F2] Меню игры  |  [F6] Конфигурация",
	["vi"] = "[B] Menu Xây Dựng  |  [F2] Menu Trò Chơi  |  [F6] Menu Cấu Hình",
	["zh-TW"] = "[B] 建造清單  |  [F2] 遊戲介面 |  [F6] 設定介面",
	["zh-CN"] = "[B] 建造菜单  |  [F2] 模式菜单 |  [F6] 设置菜单",
})

ZShelter.L("#Shelter", {
	["en"] = "Shelter",
	["bg"] = "Приют",
	["de"] = "Unterschlupf",
	["fr"] = "Abri",
	["tr"] = "Sığınak",
	["ru"] = "Убежище",
	["vi"] = "Nơi Trú Ẩn",
	["zh-TW"] = "避難所",
	["zh-CN"] = "避难所",
})

ZShelter.L("#Barricade", {
	["en"] = "Barricade",
	["bg"] = "Барикада",
	["de"] = "Barrikade",
	["fr"] = "Barricade",
	["tr"] = "Barikat",
	["ru"] = "Баррикады",
	["vi"] = "Rào Chắn",
	["zh-TW"] = "障礙物",
	["zh-CN"] = "障碍物",
})

ZShelter.L("#Trap", {
	["en"] = "Trap",
	["bg"] = "Капан",
	["de"] = "Falle",
	["fr"] = "Piège",
	["tr"] = "Tuzak",
	["ru"] = "Ловушки",
	["vi"] = "Bẫy",
	["zh-TW"] = "陷阱",
	["zh-CN"] = "陷阱",
})

ZShelter.L("#Turret", {
	["en"] = "Turret",
	["bg"] = "Кула",
	["de"] = "Geschützturm",
	["fr"] = "Tourelle",
	["tr"] = "Taret",
	["ru"] = "Турели",
	["vi"] = "Tháp Pháo",
	["zh-TW"] = "砲塔",
	["zh-CN"] = "炮塔",
})

ZShelter.L("#Generator", {
	["en"] = "Generator",
	["bg"] = "Генератор",
	["de"] = "Generator",
	["fr"] = "Générateur",
	["tr"] = "Jeneratör",
	["ru"] = "Генератор",
	["vi"] = "Máy Phát Điện",
	["zh-TW"] = "發電機",
	["zh-CN"] = "发电机",
})

ZShelter.L("#Recovery", {
	["en"] = "Recovery",
	["bg"] = "Възстановяване",
	["de"] = "Erholung",
	["fr"] = "Ravitaillement",
	["tr"] = "İyileşme",
	["ru"] = "Восстановление",
	["vi"] = "Hồi Phục",
	["zh-TW"] = "恢復設施",
	["zh-CN"] = "回复设施",
})

ZShelter.L("#Storage", {
	["en"] = "Storage",
	["bg"] = "Склад",
	["de"] = "Lager",
	["fr"] = "Stockage",
	["tr"] = "Depo",
	["ru"] = "Склад",
	["vi"] = "Kho Chứa",
	["zh-TW"] = "倉庫",
	["zh-CN"] = "仓库",
})

ZShelter.L("#Public Construction", {
	["en"] = "Public Construction",
	["bg"] = "Обществена конструкция",
	["de"] = "Öffentliche Bauvorhaben",
	["fr"] = "Construction Public",
	["tr"] = "Ortak Yapı",
	["ru"] = "Общ. строительство",
	["vi"] = "Công Trình Công Cộng",
	["zh-TW"] = "公共建設",
	["zh-CN"] = "公共设施",
})

ZShelter.L("#Wooden Wall", {
	["en"] = "Wooden Wall",
	["bg"] = "Дървена стена",
	["de"] = "Holzwand",
	["fr"] = "Mur en Bois",
	["tr"] = "Ahşap Duvar",
	["ru"] = "Деревянная стена",
	["vi"] = "Tường Gỗ",
	["zh-TW"] = "木製牆壁",
	["zh-CN"] = "木制墙壁",
})

ZShelter.L("#Wooden Spike Wall", {
	["en"] = "Wooden Spike Wall",
	["bg"] = "Дървена стена с шипове",
	["de"] = "Holzwand mit Spitzen",
	["fr"] = "Mur en Bois à Pointes",
	["ru"] = "Деревянная стена с колышками",
	["tr"] = "Dikenli Ahşap Duvar",
	["vi"] = "Tường Gỗ Chông Gai",
	["zh-TW"] = "木製尖刺",
	["zh-CN"] = "木制尖刺",
})

ZShelter.L("#Wire Fence", {
	["en"] = "Wire Fence",
	["bg"] = "Оградна мрежа",
	["de"] = "Drahtzaun",
	["fr"] = "Clôture en Fil de Fer",
	["tr"] = "Tel Çit",
	["ru"] = "Проволочный забор",
	["vi"] = "Hàng Rào Dây",
	["zh-TW"] = "鐵絲網",
	["zh-CN"] = "铁丝网",
})

ZShelter.L("#Light", {
	["en"] = "Light",
	["bg"] = "",
	["de"] = "",
	["fr"] = "",
	["tr"] = "",
	["ru"] = "",
	["vi"] = "",
	["zh-TW"] = "照明燈",
	["zh-CN"] = "照明灯",
})

ZShelter.L("#Metal Wall", {
	["en"] = "Metal Wall",
	["bg"] = "Метална стена",
	["de"] = "Metallwand",
	["fr"] = "Mur en Métal",
	["tr"] = "Metal Duvar",
	["ru"] = "Металлическая стена",
	["vi"] = "Tường Kim Loại",
	["zh-TW"] = "鐵製牆壁",
	["zh-CN"] = "铁制墙壁",
})

ZShelter.L("#Reinforced Wire Fence", {
	["en"] = "Reinforced Wire Fence",
	["bg"] = "Подсилена оградна мрежа",
	["de"] = "Verstärkter Drahtzaun",
	["fr"] = "Clôture en Fil de Fer Renforcé",
	["tr"] = "Güçlendirilmiş Tel Çit",
	["ru"] = "Армированный проволочный забор",
	["vi"] = "Hàng Rào Dây Cốt Thép",
	["zh-TW"] = "強化鐵絲網",
	["zh-CN"] = "强化铁丝网",
})

ZShelter.L("#Metal Gate", {
	["en"] = "Metal Gate",
	["bg"] = "Метална врата",
	["de"] = "Metalltor",
	["fr"] = "Portail en Métal",
	["tr"] = "Metal Geçit",
	["ru"] = "Металлические ворота",
	["vi"] = "Cổng Kim Loại",
	["zh-TW"] = "鐵絲門",
	["zh-CN"] = "铁丝门",
})

ZShelter.L("#Metal Barricade", {
	["en"] = "Metal Barricade",
	["bg"] = "Метална барикада",
	["de"] = "Metallbarrikade",
	["fr"] = "Barricade en Métal",
	["tr"] = "Metal Barikat",
	["ru"] = "Металлическая баррикада",
	["vi"] = "Rào Chắn Kim Loại",
	["zh-TW"] = "鐵製路障",
	["zh-CN"] = "铁制路障",
})

ZShelter.L("#Concrete Wall", {
	["en"] = "Concrete Wall",
	["bg"] = "Бетонна стена",
	["de"] = "Betonwand",
	["fr"] = "Mur en Béton",
	["tr"] = "Beton Duvar",
	["ru"] = "Бетонная стена",
	["vi"] = "Tường Bê Tông",
	["zh-TW"] = "水泥牆",
	["zh-CN"] = "水泥墙",
})

ZShelter.L("#Concrete Gate", {
	["en"] = "Concrete Gate",
	["bg"] = "Бетонна врата",
	["de"] = "Betontor",
	["fr"] = "Portail en Béton",
	["tr"] = "Beton Geçit",
	["ru"] = "Бетонные ворота",
	["vi"] = "Cổng Bê Tông",
	["zh-TW"] = "鋼製鐵門",
	["zh-CN"] = "钢制铁门",
})

ZShelter.L("#Reinforced Concrete Wall", {
	["en"] = "Reinforced Concrete Wall",
	["bg"] = "Подсилена бетонна стена",
	["de"] = "Verstärkte Betonwand",
	["fr"] = "Mur en Béton Armé",
	["tr"] = "Güçlendirilmiş Beton Duvar",
	["ru"] = "Железобетонная стена",
	["vi"] = "Tường Bê Tông Cốt Thép",
	["zh-TW"] = "強化水泥牆",
	["zh-CN"] = "强化水泥墙",
})

ZShelter.L("#Concrete Barricade", {
	["en"] = "Concrete Barricade",
	["bg"] = "Бетонна барикада",
	["de"] = "Betonbarrikade",
	["fr"] = "Barricade en Béton",
	["tr"] = "Beton Barikat",
	["ru"] = "Бетонная баррикада",
	["vi"] = "Rào Chắn Bê Tông",
	["zh-TW"] = "水泥路障",
	["zh-CN"] = "水泥路障",
})

ZShelter.L("#Landmine", {
	["en"] = "Landmine",
	["bg"] = "Мина",
	["de"] = "Landmine",
	["fr"] = "Mine",
	["tr"] = "Mayın",
	["ru"] = "Фугас",
	["vi"] = "Mìn Đất",
	["zh-TW"] = "地雷",
	["zh-CN"] = "地雷",
})

ZShelter.L("#Razorwire", {
	["en"] = "Razorwire",
	["bg"] = "Бръснарска тел",
	["de"] = "Stacheldraht",
	["fr"] = "Barbelé",
	["tr"] = "Dikenli Tel",
	["ru"] = "Колючая проволока",
	["vi"] = "Dây Thép Gai",
	["zh-TW"] = "鐵絲網",
	["zh-CN"] = "铁丝网",
})

ZShelter.L("#Claymore", {
	["en"] = "Claymore",
	["bg"] = "Клеймор",
	["de"] = "Claymore",
	["fr"] = "Claymore",
	["tr"] = "AP Mayını",
	["ru"] = "Противопехотная мина",
	["vi"] = "Mìn Claymore",
	["zh-TW"] = "闊刀地雷",
	["zh-CN"] = "阔剑地雷",
})

ZShelter.L("#Freeze Bomb", {
	["en"] = "Freeze Bomb",
	["bg"] = "Замразяваща бомба",
	["de"] = "Einfrierende Bombe",
	["fr"] = "Bombe Givrante",
	["tr"] = "Dondurucu Bomba",
	["ru"] = "Замораживающая бомба",
	["vi"] = "Bom Đóng Băng",
	["zh-TW"] = "冷凍炸彈",
	["zh-CN"] = "冷冻炸弹",
})

ZShelter.L("#Spike Trap", {
	["en"] = "Spike Trap",
	["bg"] = "Капан с шипове",
	["de"] = "Stachelfalle",
	["fr"] = "Piège à Pointes",
	["tr"] = "Dikenli Tuzak",
	["ru"] = "Шипастая ловушка",
	["vi"] = "Bẫy chông gai",
	["zh-TW"] = "尖刺陷阱",
	["zh-CN"] = "尖刺陷阱",
})

ZShelter.L("#Propeller Trap", {
	["en"] = "Propeller Trap",
	["bg"] = "Капан с перка",
	["de"] = "Propellerfalle",
	["fr"] = "Piège à Hélice",
	["tr"] = "Pervane Tuzağı",
	["ru"] = "Пропеллерная ловушка",
	["vi"] = "Bẫy Cánh Quạt",
	["zh-TW"] = "鋸刀陷阱",
	["zh-CN"] = "锯刃陷阱",
})

ZShelter.L("#Flame Trap", {
	["en"] = "Flame Trap",
	["bg"] = "Огнен капан",
	["de"] = "Flammenfalle",
	["fr"] = "Mine Incendiaire",
	["tr"] = "Alev Tuzağı",
	["ru"] = "Огненная ловушка",
	["vi"] = "Bẫy Lửa",
	["zh-TW"] = "火焰陷阱",
	["zh-CN"] = "喷火陷阱",
})

ZShelter.L("#CMB Trap", {
	["en"] = "Cryo Mine",
	["bg"] = "Крио мина",
	["de"] = "Cryo-Mine",
	["fr"] = "Mine Cryogénique",
	["tr"] = "Dondurucu Mayın",
	["ru"] = "",
	["vi"] = "Mìn Đông Lạnh",
	["zh-TW"] = "凍結地雷",
	["zh-CN"] = "冻结地雷",
})

ZShelter.L("#Gravity Mine", {
	["en"] = "Gravity Mine",
	["bg"] = "Гравитационна мина",
	["de"] = "Schwerkraft-Mine",
	["fr"] = "Mine Magnétique",
	["tr"] = "Yer Çekimi Mayını",
	["ru"] = "",
	["vi"] = "Mìn Trọng Lực",
	["zh-TW"] = "引力地雷",
	["zh-CN"] = "引力地雷",
})

ZShelter.L("Laser Trap", {
	["en"] = "Laser Trap",
	["bg"] = "Лазерен капан",
	["de"] = "Laserfalle",
	["fr"] = "Piège Laser",
	["tr"] = "Lazer Tuzağı",
	["ru"] = "",
	["vi"] = "Bẫy Laser",
	["zh-TW"] = "雷射陷阱",
	["zh-CN"] = "雷射陷阱",
})

ZShelter.L("#Basic Turret", {
	["en"] = "Basic Turret",
	["bg"] = "Основна кула",
	["de"] = "Gewöhnliches Geschützturm",
	["fr"] = "Tourelle Basique",
	["tr"] = "Temel Taret",
	["ru"] = "Основная турель",
	["vi"] = "Tháp Pháo Cơ Bản",
	["zh-TW"] = "槍塔",
	["zh-CN"] = "炮塔",
})

ZShelter.L("#Mounted Machine Gun", {
	["en"] = "Mounted Machine Gun",
	["bg"] = "Монтирана картечница",
	["de"] = "Montiertes Maschinengewehr",
	["fr"] = "Mitrailleuse Montée",
	["tr"] = "Monteli Makineli Tüfek",
	["ru"] = "Станковый пулемёт",
	["vi"] = "Súng Máy Gắn Cố Định",
	["zh-TW"] = "固定式機槍塔",
	["zh-CN"] = "固定式炮塔",
})

ZShelter.L("#Freeze Turret", {
	["en"] = "Freeze Turret",
	["bg"] = "Замразяваща кула",
	["de"] = "Gefrierturm",
	["fr"] = "Tourelle Givrante",
	["tr"] = "Dondurucu Taret",
	["ru"] = "Замораживающая турель",
	["vi"] = "Pháo đóng băng",
	["zh-TW"] = "冷凍槍塔",
	["zh-CN"] = "冷冻炮塔",
})

ZShelter.L("#Mending Tower", {
	["en"] = "Mending Tower",
	["bg"] = "Кула за възстановяване",
	["de"] = "Reparaturturm",
	["fr"] = "Tour de Réparation",
	["tr"] = "Tamir Kulesi",
	["ru"] = "Ремонтная башня",
	["vi"] = "Tháp Sửa Chữa",
	["zh-TW"] = "建築修復器",
	["zh-CN"] = "建筑修复器",
})

ZShelter.L("#Camouflage Tower", {
	["en"] = "Camouflage Tower",
	["bg"] = "",
	["de"] = "",
	["fr"] = "",
	["tr"] = "",
	["ru"] = "",
	["vi"] = "",
	["zh-TW"] = "隱身塔",
	["zh-CN"] = "隐身塔",
})

ZShelter.L("#Flame Turret", {
	["en"] = "Flame Turret",
	["bg"] = "Огнена кула",
	["de"] = "Flammenwerfer Geschützturm",
	["fr"] = "Tourelle Lance-Flamme",
	["tr"] = "Alev Tareti",
	["ru"] = "Огнемётная турель",
	["vi"] = "Tháp Pháo Lửa",
	["zh-TW"] = "火焰槍塔",
	["zh-CN"] = "喷火炮塔",
})

ZShelter.L("#Blast Turret", {
	["en"] = "Blast Turret",
	["bg"] = "Взривна кула",
	["de"] = "Sprengturm",
	["fr"] = "Tourelle Explosive",
	["tr"] = "Bomba Tareti",
	["ru"] = "Взрывная турель",
	["vi"] = "Tháp Pháo Nổ",
	["zh-TW"] = "爆破槍塔",
	["zh-CN"] = "爆破炮塔",
})

ZShelter.L("#Burst Shotgun Turret", {
	["en"] = "Burst Shotgun Turret",
	["bg"] = "Кула с изстрелваща пушка",
	["de"] = "Schrotflintengeschützturm",
	["fr"] = "Tourelle à Rafales",
	["tr"] = "Pompalı Taret",
	["ru"] = "",
	["vi"] = "Tháp Pháo Súng Sục",
	["zh-TW"] = "連發霰彈槍塔",
	["zh-CN"] = "连发霰弹炮塔",
})

ZShelter.L("#Enemy Scanner", {
	["en"] = "Enemy Scanner",
	["bg"] = "Скенер за врагове",
	["de"] = "Feindenscanner",
	["fr"] = "Scanner d'Ennemis",
	["tr"] = "Düşman Tarayıcı",
	["ru"] = "Сканер",
	["vi"] = "Máy Quét Kẻ Thù",
	["zh-TW"] = "掃描器",
	["zh-CN"] = "扫描器",
})

ZShelter.L("#Minigun Turret", {
	["en"] = "Minigun Turret",
	["bg"] = "Миниган кула",
	["de"] = "Minigun Geschützturm",
	["fr"] = "Tourelle Minigun",
	["tr"] = "Minigun Tareti",
	["ru"] = "Турель-миниган",
	["vi"] = "Tháp Pháo 6 Nòng",
	["zh-TW"] = "超級機槍塔",
	["zh-CN"] = "机关枪炮塔",
})

ZShelter.L("#Pusher Tower", {
	["en"] = "Pusher Tower",
	["bg"] = "Кула за отблъскване",
	["de"] = "",
	["fr"] = "Tourelle Répulsive",
	["tr"] = "İtici Kule",
	["ru"] = "Толкающая башня",
	["vi"] = "Tháp Đẩy",
	["zh-TW"] = "位移塔",
	["zh-CN"] = "位移炮塔",
})

ZShelter.L("#Railgun Cannon", {
	["en"] = "Railgun Cannon",
	["bg"] = "Рейлган оръдие",
	["de"] = "Railgun",
	["fr"] = "Canon Électromagnétique",
	["tr"] = "Elektromanyetik Top",
	["ru"] = "Рельсотронное орудие",
	["vi"] = "Đại Bác Điện Từ",
	["zh-TW"] = "電磁炮",
	["zh-CN"] = "电磁炮",
})

ZShelter.L("#Electric Defense Tower", {
	["en"] = "Electric Defense Tower",
	["bg"] = "Електрическа защитна кула",
	["de"] = "Elektrischer Verteidigungsturm",
	["fr"] = "Tour Tesla",
	["tr"] = "Elektrikli Savunma Kulesi",
	["ru"] = "Электронная башня",
	["vi"] = "Tháp Phòng Thủ Điện",
	["zh-TW"] = "電磁網塔",
	["zh-CN"] = "电磁防御塔",
})

ZShelter.L("#Mortar Cannon", {
	["en"] = "Mortar Cannon",
	["bg"] = "Минометно оръдие",
	["de"] = "Minenwerfer",
	["fr"] = "Mortier",
	["tr"] = "Havan Topu",
	["ru"] = "Миномёт",
	["vi"] = "Đại Bác Cối",
	["zh-TW"] = "迫擊砲",
	["zh-CN"] = "迫击炮",
})

ZShelter.L("#Plasma Turret", {
	["en"] = "Plasma Turret",
	["bg"] = "Плазмена кула",
	["de"] = "Plasmageschützturm",
	["fr"] = "Tourelle Plasma",
	["tr"] = "Plazma Tareti",
	["ru"] = "Плазменная турель",
	["vi"] = "Tháp Pháo Plasma",
	["zh-TW"] = "幽能離子塔",
	["zh-CN"] = "等离子体炮塔",
})

ZShelter.L("#Laser Turret", {
	["en"] = "Laser Turret",
	["bg"] = "Лазерна кула",
	["de"] = "Lasergeschützturm",
	["fr"] = "Tourelle Laser",
	["tr"] = "Lazer Tareti",
	["ru"] = "",
	["vi"] = "Tháp Pháo Laser",
	["zh-TW"] = "雷射砲塔",
	["zh-CN"] = "雷射炮塔",
})

ZShelter.L("#Gauss Turret", {
	["en"] = "Gauss Turret",
	["bg"] = "Гаусова кула",
	["de"] = "",
	["fr"] = "Tourelle Gauss",
	["tr"] = "Gaus Tareti",
	["ru"] = "",
	["vi"] = "Tháp Pháo Gauss",
	["zh-TW"] = "高斯炮",
	["zh-CN"] = "高斯炮",
})

ZShelter.L("#Laser Minigun Turret", {
	["en"] = "Laser Minigun Turret",
	["bg"] = "Лазерна миниган кула",
	["de"] = "Geschützturm mit einem Laserminigun",
	["fr"] = "Tourelle Minigun Laser",
	["tr"] = "Lazer Minigun Taret",
	["ru"] = "",
	["vi"] = "Tháp Pháo 6 Nòng Laser",
	["zh-TW"] = "雷射機槍塔",
	["zh-CN"] = "雷射机枪炮塔",
})

ZShelter.L("#Combine Mortar Cannon", {
	["en"] = "Combine Mortar Cannon",
	["bg"] = "Комбинирано минометно оръдие",
	["de"] = "Combine Minenwerfer",
	["fr"] = "Mortier du Cartel",
	["tr"] = "Combine Havan Topu",
	["ru"] = "Миномёт комбайнов",
	["vi"] = "Đại Bác Cối Hợp Nhất",
	["zh-TW"] = "聯合軍迫擊砲",
	["zh-CN"] = "联合军迫击炮",
})

ZShelter.L("#Basic Generator", {
	["en"] = "Basic Generator",
	["bg"] = "Основен генератор",
	["de"] = "Gewöhnlicher Generator",
	["fr"] = "Générateur Basique",
	["tr"] = "Temel Seviye Jeneratör",
	["ru"] = "Основной генератор",
	["vi"] = "Máy Phát Điện Cơ Bản",
	["zh-TW"] = "發電機",
	["zh-CN"] = "小型发电机",
})

ZShelter.L("#Medium Generator", {
	["en"] = "Medium Generator",
	["bg"] = "Среден генератор",
	["de"] = "Mittlerer Generator",
	["fr"] = "Générateur Moyen",
	["tr"] = "Orta Seviye Jeneratör",
	["ru"] = "Средний генератор",
	["vi"] = "Máy Phát Điện Vừa",
	["zh-TW"] = "中型發電機",
	["zh-CN"] = "中型发电机",
})

ZShelter.L("#Large Generator", {
	["en"] = "Large Generator",
	["bg"] = "Голям генератор",
	["de"] = "Großer Generator",
	["fr"] = "Grand Générateur",
	["tr"] = "Gelişmiş Jeneratör",
	["ru"] = "Большой генератор",
	["vi"] = "Máy Phát Điện Lớn",
	["zh-TW"] = "大型發電機",
	["zh-CN"] = "大型发电机",
})

ZShelter.L("#Mega Generator", {
	["en"] = "Mega Generator",
	["bg"] = "Мега генератор",
	["de"] = "Mega Generator",
	["fr"] = "Méga Générateur",
	["tr"] = "Mega Jeneratör",
	["ru"] = "Мегагенератор",
	["vi"] = "Máy Phát Điện Khổng Lồ",
	["zh-TW"] = "超大型發電機",
	["zh-CN"] = "超大型发电机",
})

ZShelter.L("#Resource Generator", {
	["en"] = "Resource Generator",
	["bg"] = "Генератор на ресурси",
	["de"] = "Ressourcengenerator",
	["fr"] = "Générateur de Ressources",
	["tr"] = "Kaynak Jeneratörü",
	["ru"] = "Генератор ресурсов",
	["vi"] = "Máy Phát Tài Nguyên",
	["zh-TW"] = "資源生成器",
	["zh-CN"] = "资源生成器",
})

ZShelter.L("#Healing Station", {
	["en"] = "Healing Station",
	["bg"] = "Станция за лечение",
	["de"] = "Heilstation",
	["fr"] = "Station de Soins",
	["tr"] = "Sağlık İstasyonu",
	["ru"] = "Медпункт",
	["vi"] = "Trạm Chữa Trị",
	["zh-TW"] = "醫療站",
	["zh-CN"] = "医疗站",
})

ZShelter.L("#Armor Box", {
	["en"] = "Armor Box",
	["bg"] = "Кутия за броня",
	["de"] = "Rüstungskiste",
	["fr"] = "Boîte d'Armure",
	["tr"] = "Zırh Kutusu",
	["ru"] = "Ящик брони",
	["vi"] = "Rương Giáp",
	["zh-TW"] = "護甲箱",
	["zh-CN"] = "护甲箱",
})

ZShelter.L("#Campfire", {
	["en"] = "Campfire",
	["bg"] = "Къмпинг огън",
	["de"] = "Lagerfeuer",
	["fr"] = "Feu de Camp",
	["tr"] = "Kamp Ateşi",
	["ru"] = "Костёр",
	["vi"] = "Lửa Trại",
	["zh-TW"] = "營火",
	["zh-CN"] = "营火",
})

ZShelter.L("#Basic Storage", {
	["en"] = "Basic Storage",
	["bg"] = "Основен склад",
	["de"] = "Gewöhnlicher Lager",
	["fr"] = "Stockage Basique",
	["tr"] = "Temel Seviye Depo",
	["ru"] = "Основной склад",
	["vi"] = "Kho Chứa Cơ Bản",
	["zh-TW"] = "小倉庫",
	["zh-CN"] = "小型仓库",
})

ZShelter.L("#Medium Storage", {
	["en"] = "Medium Storage",
	["bg"] = "Среден склад",
	["de"] = "Mittlerer Lager",
	["fr"] = "Stockage Moyen",
	["tr"] = "Orta Seviye Depo",
	["ru"] = "Средний склад",
	["vi"] = "Kho Chứa Vừa",
	["zh-TW"] = "中型倉庫",
	["zh-CN"] = "中型仓库",
})

ZShelter.L("#Large Storage", {
	["en"] = "Large Storage",
	["bg"] = "Голям склад",
	["de"] = "Großer Lager",
	["fr"] = "Grand Stockage",
	["tr"] = "Gelişmiş Depo",
	["ru"] = "Большой склад",
	["vi"] = "Kho Chứa Lớn",
	["zh-TW"] = "大型倉庫",
	["zh-CN"] = "大型仓库",
})

ZShelter.L("#Worktable", {
	["en"] = "Worktable",
	["bg"] = "Работна маса",
	["de"] = "Werkbank",
	["fr"] = "Établi",
	["tr"] = "Çalışma Masası",
	["ru"] = "Верстак",
	["vi"] = "Bàn Làm Việc",
	["zh-TW"] = "工作站",
	["zh-CN"] = "工作台",
})

ZShelter.L("#Ammo Supply Crate", {
	["en"] = "Ammo Supply Crate",
	["bg"] = "Кутия за боеприпаси",
	["de"] = "Munitionsvorratskiste",
	["fr"] = "Caisse de Munitions",
	["tr"] = "Cephane İkmal Sandığı",
	["ru"] = "Ящик с боеприпасами",
	["vi"] = "Thùng Đạn Tiếp Tế",
	["zh-TW"] = "彈藥補給箱",
	["zh-CN"] = "弹药补给箱",
})

ZShelter.L("#Cement Mixer", {
	["en"] = "Cement Mixer",
	["bg"] = "Циментов миксер",
	["de"] = "Betonmixer",
	["fr"] = "Centrale à Béton",
	["tr"] = "Beton Karıştırıcı",
	["ru"] = "Бетонный завод",
	["vi"] = "Máy Trộn Bê Tông",
	["zh-TW"] = "水泥煉製廠",
	["zh-CN"] = "水泥搅拌机",
})

ZShelter.L("#Comm Tower", {
	["en"] = "Comm Tower",
	["bg"] = "Кула за комуникации",
	["de"] = "Funkturm",
	["fr"] = "Tour Radio",
	["tr"] = "İletişim Kulesi",
	["ru"] = "Радиобашня",
	["vi"] = "Tháp Liên Lạc",
	["zh-TW"] = "通訊塔",
	["zh-CN"] = "通讯塔",
})

ZShelter.L("#Ready", {
	["en"] = "Ready",
	["bg"] = "Готов",
	["de"] = "Bereit",
	["fr"] = "Prêt",
	["tr"] = "Hazır",
	["ru"] = "Готово",
	["vi"] = "Sẵn Sàng",
	["zh-TW"] = "準備",
	["zh-CN"] = "准备",
})

ZShelter.L("#Not Ready", {
	["en"] = "Not Ready",
	["bg"] = "Не готов",
	["de"] = "Nicht Bereit",
	["fr"] = "En Attente",
	["tr"] = "Hazır Değil",
	["ru"] = "Не готово",
	["vi"] = "Chưa Sẵn Sàng",
	["zh-TW"] = "未準備",
	["zh-CN"] = "未准备",
})

ZShelter.L("#ReadyHint", {
	["en"] = "Press F4 to ready",
	["bg"] = "Натисни F4 за готовност",
	["de"] = "F4 drücken, um sich als bereit zu erklären",
	["fr"] = "Appuyez sur F4 pour vous mettre prêt",
	["tr"] = "Hazır olmak için F4'e basın",
	["ru"] = "F4 - готовность",
	["vi"] = "Nhấn F4 để sẵn sàng",
	["zh-TW"] = "F4 - 準備",
	["zh-CN"] = "F4 - 准备",
})

ZShelter.L("#Map", {
	["en"] = "Map",
	["bg"] = "Карта",
	["de"] = "Karte",
	["fr"] = "Carte",
	["tr"] = "Harita",
	["ru"] = "Карта",
	["vi"] = "Bản Đồ",
	["zh-TW"] = "地圖",
	["zh-CN"] = "地图",
})

ZShelter.L("#Dif1", {
	["en"] = "Easy",
	["bg"] = "Лесно",
	["de"] = "Leicht",
	["fr"] = "Facile",
	["tr"] = "Kolay",
	["ru"] = "Новичок",
	["vi"] = "Dễ",
	["zh-TW"] = "簡單",
	["zh-CN"] = "简单",
})

ZShelter.L("#Dif2", {
	["en"] = "Normal",
	["bg"] = "Нормално",
	["de"] = "Normal",
	["fr"] = "Normale",
	["tr"] = "Normal",
	["ru"] = "Выживший",
	["vi"] = "Trung Bình",
	["zh-TW"] = "普通",
	["zh-CN"] = "普通",
})

ZShelter.L("#Dif3", {
	["en"] = "Hard",
	["bg"] = "Трудно",
	["de"] = "Schwer",
	["fr"] = "Difficile",
	["tr"] = "Zor",
	["ru"] = "Ветеран",
	["vi"] = "Khó",
	["zh-TW"] = "困難",
	["zh-CN"] = "困难",
})

ZShelter.L("#Dif4", {
	["en"] = "Expert",
	["bg"] = "Експерт",
	["de"] = "Expert",
	["fr"] = "Expert",
	["tr"] = "Uzman",
	["ru"] = "Эксперт",
	["vi"] = "Chuyên Gia",
	["zh-TW"] = "專家",
	["zh-CN"] = "专家",
})

ZShelter.L("#Dif5", {
	["en"] = "Insane",
	["bg"] = "Невъзможно",
	["de"] = "Tödlich",
	["fr"] = "Extrême",
	["tr"] = "Deli",
	["ru"] = "Безумие",
	["vi"] = "Điên Cuồng",
	["zh-TW"] = "瘋狂",
	["zh-CN"] = "疯狂",
})

ZShelter.L("#Dif6", {
	["en"] = "Nightmare",
	["bg"] = "Кошмар",
	["de"] = "Alptraum",
	["fr"] = "Cauchemar",
	["tr"] = "Kâbus",
	["ru"] = "Кошмар",
	["vi"] = "Ác Mộng",
	["zh-TW"] = "惡夢",
	["zh-CN"] = "噩梦",
})

ZShelter.L("#Dif7", {
	["en"] = "Apocalypse",
	["bg"] = "Апокалипсис",
	["de"] = "Apocalypse",
	["fr"] = "Apocalypse",
	["tr"] = "Kıyamet",
	["ru"] = "Апокалипсис",
	["vi"] = "Tận Thế",
	["zh-TW"] = "天啟",
	["zh-CN"] = "天启",
})

ZShelter.L("#Dif8", {
	["en"] = "Apocalypse+",
	["bg"] = "Апокалипсис+",
	["de"] = "Fiebertraum",
	["fr"] = "Apocalypse+",
	["tr"] = "Kıyamet+",
	["ru"] = "Апокалипсис+",
	["vi"] = "Tận Thế+",
	["zh-TW"] = "天啟+",
	["zh-CN"] = "天启+",
})

ZShelter.L("#Dif9", {
	["en"] = "Hell",
	["bg"] = "Ад",
	["de"] = "Hölle",
	["fr"] = "Enfer",
	["tr"] = "Cehennem",
	["ru"] = "Ад",
	["vi"] = "Địa Ngục",
	["zh-TW"] = "地獄",
	["zh-CN"] = "地狱",
})

ZShelter.L("#Uncraft Weapons", {
	["en"] = "Uncraft Weapons",
	["bg"] = "Разглоби оръжия",
	["de"] = "Waffen zerlegen",
	["fr"] = "Démonter les Armes",
	["tr"] = "Silahları Parçala",
	["ru"] = "Разобрать оружие",
	["vi"] = "Phân Rã Vũ Khí",
	["zh-TW"] = "拆解武器",
	["zh-CN"] = "拆解武器",
})

ZShelter.L("#Woods", {
	["en"] = "Woods",
	["bg"] = "Гори",
	["de"] = "Holz",
	["fr"] = "Bois",
	["tr"] = "Ahşap",
	["ru"] = "Дерево",
	["vi"] = "Gỗ",
	["zh-TW"] = "木材",
	["zh-CN"] = "木材",
})

ZShelter.L("#Irons", {
	["en"] = "Irons",
	["bg"] = "Железни находища",
	["de"] = "Eisen",
	["fr"] = "Fers",
	["tr"] = "Demir",
	["ru"] = "Сталь",
	["vi"] = "Sắt",
	["zh-TW"] = "鐵材",
	["zh-CN"] = "钢材",
})

ZShelter.L("#Contribute", {
	["en"] = "Contribute",
	["bg"] = "Допринасяй",
	["de"] = "Beitragen",
	["fr"] = "Contribution",
	["tr"] = "Katkı",
	["ru"] = "Вклад",
	["vi"] = "Đóng Góp",
	["zh-TW"] = "貢獻度",
	["zh-CN"] = "贡献度",
})

ZShelter.L("#Deaths", {
	["en"] = "Deaths",
	["bg"] = "Смърти",
	["de"] = "Töde",
	["fr"] = "Morts",
	["tr"] = "Ölüm",
	["ru"] = "Смерти",
	["vi"] = "Chết",
	["zh-TW"] = "死亡",
	["zh-CN"] = "死亡",
})

ZShelter.L("#Name", {
	["en"] = "Name",
	["bg"] = "Име",
	["de"] = "Name",
	["fr"] = "Nom",
	["tr"] = "Ad",
	["ru"] = "Имя",
	["vi"] = "Tên",
	["zh-TW"] = "名稱",
	["zh-CN"] = "名称",
})

ZShelter.L("#TK", {
	["en"] = "TK",
	["bg"] = "TK",
	["de"] = "TK",
	["fr"] = "TK",
	["tr"] = "TÖ",
	["ru"] = "ОГПС",
	["vi"] = "TK",
	["zh-TW"] = "誤傷",
	["zh-CN"] = "误伤",
})

ZShelter.L("#CommHint", {
	["en"] = "Comm Tower can be used now!",
	["bg"] = "Кула за комуникации може да бъде използвана сега!",
	["de"] = "Der Funkturm kann jetzt verwendet werden!",
	["fr"] = "La Tour Radio peut être utilisée maintenant !",
	["tr"] = "İletişim kulesi şimdi kullanılabilir!",
	["ru"] = "Радиобашню можно использовать уже сейчас!",
	["vi"] = "Tháp liên lạc có thể sử dụng ngay bây giờ!",
	["zh-TW"] = "可以使用通訊塔了!",
	["zh-CN"] = "可以使用通讯塔了!",
})

ZShelter.L("#SummeryStats", {
	["en"] = "Stats",
	["bg"] = "Статистика",
	["de"] = "Statistik",
	["fr"] = "Statistiques",
	["tr"] = "İstatistik",
	["ru"] = "Статистика",
	["vi"] = "Thống Kê",
	["zh-TW"] = "總結",
	["zh-CN"] = "总结",
})

ZShelter.L("#TotalPlayTime", {
	["en"] = "Total Playtime : <VAR>",
	["bg"] = "Общо игрово време: <VAR>",
	["de"] = "Gesamte Spielzeit : <VAR>",
	["fr"] = "Durée de la partie : <VAR>",
	["tr"] = "Toplam Oynama Süresi: <VAR>",
	["ru"] = "Общее время игры : <VAR>",
	["vi"] = "Thời gian chơi tổng cộng: <VAR>",
	["zh-TW"] = "總遊玩時間 : <VAR>",
	["zh-CN"] = "总游玩时间: <VAR>",
})

ZShelter.L("#TotalKills", {
	["en"] = "Total Enemy Killed",
	["bg"] = "Общо убити врагове",
	["de"] = "Gesamtzahl der getöteten Feinde",
	["fr"] = "Ennemis Tués",
	["tr"] = "Toplam Öldürülen Düşman",
	["ru"] = "Всего врагов убито",
	["vi"] = "Tổng Kẻ Thù Bị Giết",
	["zh-TW"] = "總殺敵數",
	["zh-CN"] = "总击杀数",
})

ZShelter.L("#TotalWoods", {
	["en"] = "Total Woods Gathered",
	["bg"] = "Общо събрани дървета",
	["de"] = "Gesamtzahl des gesammelten Holzes",
	["fr"] = "Bois collectés",
	["tr"] = "Toplam Biriktirilen Ahşap",
	["ru"] = "Всего собрано дерева",
	["vi"] = "Tổng Gỗ Thu Thập",
	["zh-TW"] = "總木材採集數",
	["zh-CN"] = "总木材采集数",
})

ZShelter.L("#TotalIrons", {
	["en"] = "Total Irons Gathered",
	["bg"] = "Общо събрани желязо",
	["de"] = "Gesamtzahl des gesammelten Eisens",
	["fr"] = "Fers collectés",
	["tr"] = "Toplam Biriktirilen Demir",
	["ru"] = "Всего собрано стали",
	["vi"] = "Tổng Sắt Thu Thập",
	["zh-TW"] = "總鐵材採集數",
	["zh-CN"] = "总钢材采集数",
})

ZShelter.L("#TotalBuilds", {
	["en"] = "Total Structure Built",
	["bg"] = "Общо построени структури",
	["de"] = "Gesamtzahl der errichteten Strukturen",
	["fr"] = "Structure Construite",
	["tr"] = "Toplam İnşa Edilen Yapı",
	["ru"] = "Всего строений",
	["vi"] = "Tổng Số Công Trình Xây Dựng",
	["zh-TW"] = "總建造數",
	["zh-CN"] = "总建造数",
})

ZShelter.L("#PublicStorageHint", {
	["en"] = "Resources in storage",
	["bg"] = "Ресурси в склада",
	["de"] = "Ressourcen im Lager",
	["fr"] = "Ressources en Stock",
	["tr"] = "Kaynaklar deponda",
	["ru"] = "Ресурсов на складе",
	["vi"] = "Tài nguyên trong kho chứa",
	["zh-TW"] = "倉庫資源",
	["zh-CN"] = "仓库资源",
})

ZShelter.L("#PersonalStorageHint", {
	["en"] = "Resources in backpack",
	["bg"] = "Ресурси в раницата",
	["de"] = "Ressourcen im Rucksack",
	["fr"] = "Ressources dans le sac à dos",
	["tr"] = "Kaynaklar sırt çantanda",
	["ru"] = "Ресурсов в рюкзаке",
	["vi"] = "Tài nguyên trong ba lô",
	["zh-TW"] = "背包資源",
	["zh-CN"] = "背包资源",
})

ZShelter.L("#UpgradeHint", {
	["en"] = "Hold E to upgrade",
	["bg"] = "Задръж E за ъпгрейд",
	["de"] = "Taste E halten, um zu verbessern",
	["fr"] = "Restez appuyé sur E pour améliorer",
	["tr"] = "Geliştirmek için E'ye basılı tut",
	["ru"] = "Удерживайте E для улучшения",
	["vi"] = "Giữ E để nâng cấp",
	["zh-TW"] = "按住使用鍵升級",
	["zh-CN"] = "按住使用键升级",
})

ZShelter.L("#Combat", {
	["en"] = "Combat",
	["bg"] = "Бой",
	["de"] = "Kampf",
	["fr"] = "Combat",
	["tr"] = "Savaş",
	["ru"] = "Бой",
	["vi"] = "Chiến Đấu",
	["zh-TW"] = "戰鬥",
	["zh-CN"] = "战斗",
})

ZShelter.L("#Survival", {
	["en"] = "Survival",
	["bg"] = "Оцеляване",
	["de"] = "Überleben",
	["fr"] = "Survie",
	["tr"] = "Hayatta Kalma",
	["ru"] = "Выживание",
	["vi"] = "Sống Sót",
	["zh-TW"] = "生存",
	["zh-CN"] = "生存",
})

ZShelter.L("#Engineer", {
	["en"] = "Engineer",
	["bg"] = "Инженер",
	["de"] = "Ingenieur",
	["fr"] = "Ingénierie",
	["tr"] = "Mühendislik",
	["ru"] = "Инженерия",
	["vi"] = "Kỹ Sư",
	["zh-TW"] = "工程師",
	["zh-CN"] = "工程师",
})

ZShelter.L("#Berserker", {
	["en"] = "Berserker",
	["bg"] = "",
	["de"] = "",
	["fr"] = "",
	["tr"] = "",
	["ru"] = "",
	["vi"] = "",
	["zh-TW"] = "狂戰士",
	["zh-CN"] = "狂战士",
})

ZShelter.L("#Pistol", {
	["en"] = "Pistol",
	["bg"] = "Пистолет",
	["de"] = "Pistole",
	["fr"] = "Pistolet",
	["tr"] = "Tabanca",
	["ru"] = "Пистолеты",
	["vi"] = "Súng Lục",
	["zh-TW"] = "手槍",
	["zh-CN"] = "手枪",
})

ZShelter.L("#SMG", {
	["en"] = "SMG",
	["bg"] = "Пистолет-пулемет",
	["de"] = "SMG",
	["fr"] = "SMG",
	["tr"] = "SMG",
	["ru"] = "Пистолеты-пулемёты",
	["vi"] = "SMG",
	["zh-TW"] = "衝鋒槍",
	["zh-CN"] = "冲锋枪",
})

ZShelter.L("#Shotgun", {
	["en"] = "Shotgun",
	["bg"] = "Дробовик",
	["de"] = "Schrotflinte",
	["fr"] = "Fusil à Pompe",
	["tr"] = "Pompalı Tüfek",
	["ru"] = "Дробовики",
	["vi"] = "Súng Sục",
	["zh-TW"] = "霰彈槍",
	["zh-CN"] = "霰弹枪",
})

ZShelter.L("#Rifle", {
	["en"] = "Rifle",
	["bg"] = "Винтовка",
	["de"] = "Scharfschützengewehr",
	["fr"] = "Fusil",
	["tr"] = "Tüfek",
	["ru"] = "Винтовки",
	["vi"] = "Súng Trường",
	["zh-TW"] = "步槍",
	["zh-CN"] = "步枪",
})

ZShelter.L("#Heavy", {
	["en"] = "Heavy",
	["bg"] = "Тежко",
	["de"] = "schwer",
	["fr"] = "Arme Lourde",
	["tr"] = "Ağır",
	["ru"] = "Тяжёлое",
	["vi"] = "Nặng",
	["zh-TW"] = "重型武器",
	["zh-CN"] = "重型武器",
})

ZShelter.L("#Sniper Rifle", {
	["en"] = "Sniper Rifle",
	["bg"] = "Снайперска пушка",
	["de"] = "Scharfschützengewehr",
	["fr"] = "Fusil de Sniper",
	["tr"] = "Keskin Nişancı Tüfeği",
	["ru"] = "Снайперские винтовки",
	["vi"] = "Súng Bắn Tỉa",
	["zh-TW"] = "狙擊步槍",
	["zh-CN"] = "狙击步枪",
})


ZShelter.L("#Explosive", {
	["en"] = "Explosive",
	["bg"] = "Експлозив",
	["de"] = "Explosiv",
	["fr"] = "Explosif",
	["tr"] = "Patlayıcı",
	["ru"] = "Взрывчатка",
	["vi"] = "Nổ",
	["zh-TW"] = "爆炸物",
	["zh-CN"] = "爆炸物",
})

ZShelter.L("#Close", {
	["en"] = "Close",
	["bg"] = "Затвори",
	["de"] = "Schließen",
	["fr"] = "Fermer",
	["tr"] = "Kapat",
	["ru"] = "Закрыть",
	["vi"] = "Đóng",
	["zh-TW"] = "關閉",
	["zh-CN"] = "关闭",
})

ZShelter.L("#ShelterNick", {
	["en"] = "Tier <VAR> Shelter",
	["bg"] = "Приют ниво <VAR>",
	["de"] = "Stufe <VAR> Unterschlupf",
	["fr"] = "Abri Niveau <VAR>",
	["tr"] = "Seviye <VAR> Sığınak",
	["ru"] = "Убежище <VAR>-го ур.",
	["vi"] = "Nơi Trú Ẩn Cấp <VAR>",
	["zh-TW"] = "<VAR> 級避難所",
	["zh-CN"] = "<VAR> 级避难所",
})

ZShelter.L("#ShelterPos", {
	["en"] = "Shelter Spawn Point",
	["bg"] = "Точка за появяване на приют",
	["de"] = "Unterschlupf-Spawnpunkt",
	["fr"] = "Point d'Apparitions de l'Abri",
	["tr"] = "Sığınak Canlanma Noktası",
	["ru"] = "Точка появления убежища",
	["vi"] = "Vị Trí Trú Ẩn",
	["zh-TW"] = "避難所生成點",
	["zh-CN"] = "避难所生成点",
})

ZShelter.L("#ShelterDesc", {
	["en"] = "Position for shelter to spawn, require at least one to make the game playable",
	["bg"] = "Позиция за появяване на приют, изисква поне една за игра",
	["de"] = "Position für den Unterschlupf zum Erscheinen, mindestens einer ist erforderlich, um das Spiel spielbar zu machen",
	["fr"] = "Emplacement pour la création de l'abri, il est nécessaire d'en avoir un pour que le jeu soit jouable.",
	["tr"] = "Canlanmak için sığınak pozisyonu, oyunun oynanabilmesi için en az bir tane gerekli",
	["ru"] = "Размещение точки для появления убежища, требуется хотя бы одна для игры",
	["vi"] = "Vị trí để chỗ trú ẩn xuất hiện, yêu cầu ít nhất một cái để có thể chơi",
	["zh-TW"] = "避難所的生成點, 至少需要一個遊戲才可進行",
	["zh-CN"] = "至少需要有一个避难所生成点才可进行游玩",
})

ZShelter.L("#BarricadePos", {
	["en"] = "Barricades",
	["bg"] = "Барикади",
	["de"] = "Barrikaden",
	["fr"] = "Barricades",
	["tr"] = "Barikatlar",
	["ru"] = "Баррикады",
	["vi"] = "Hàng Rào",
	["zh-TW"] = "障礙物",
	["zh-CN"] = "障碍物",
})

ZShelter.L("#BarricadeDesc", {
	["en"] = "A big container used to block player's path",
	["bg"] = "Голям контейнер, използван за блокиране на пътя на играча",
	["de"] = "Ein großer Container, der den Weg des Spielers blockiert",
	["fr"] = "Un grand conteneur utilisé pour bloquer le passage des joueurs",
	["tr"] = "Oyuncuyu engellemek için büyük bir konteyner",
	["ru"] = "Красный контейнер на пути, используется, чтобы преградить путь игроку",
	["vi"] = "Một thùng chứa lớn được sử dụng để chặn đường của người chơi",
	["zh-TW"] = "可以擋住玩家路線的紅色集裝箱",
	["zh-CN"] = "用于拦截玩家路线的红色集装箱",
})

ZShelter.L("#TreasurePos", {
	["en"] = "Treasure Area",
	["bg"] = "Съкровищна зона",
	["de"] = "Schatzbereich",
	["fr"] = "Zone de Trésor",
	["tr"] = "Hazine Alanı",
	["ru"] = "Область сокровищ",
	["vi"] = "Khu Vực Báu Vật",
	["zh-TW"] = "資源集中區",
	["zh-CN"] = "资源集中区",
})

ZShelter.L("#TreasureDesc", {
	["en"] = "Area that spawns a boss and alot of resources everyday",
	["bg"] = "Зона, която ражда бос и много ресурси всеки ден",
	["de"] = "Bereich, in dem jeden Tag ein Boss und viele Ressourcen erscheinen",
	["fr"] = "Une zone qui fait apparaître un boss et beaucoup de ressources tous les jours",
	["tr"] = "Her gün patron oluşturan ve birçok kaynak üreten bir alan",
	["ru"] = "Область, в которой каждый день появляется босс и много ресурсов",
	["vi"] = "Khu vực xuất hiện một quái lớn và rất nhiều tài nguyên mỗi ngày",
	["zh-TW"] = "每天生成Boss和較多資源的區域",
	["zh-CN"] = "一个资源较集中的区域, 每天会生成一个BOSS",
})

ZShelter.L("#BonusPos", {
	["en"] = "Resource Bonus Area",
	["bg"] = "Зона с бонус ресурси",
	["de"] = "Bonusressourcenbereich",
	["fr"] = "Zone de Ressources Bonus",
	["tr"] = "Kaynak Bonusu Alanı",
	["ru"] = "Область дополнительных ресурсов",
	["vi"] = "Khu Vực Tài Nguyên Bổ Sung",
	["zh-TW"] = "獎勵資源區",
	["zh-CN"] = "奖励资源区",
})

ZShelter.L("#BonusDesc", {
	["en"] = "An area that spawns extra resources without bosses",
	["bg"] = "Зона, която ражда допълнителни ресурси без босове",
	["de"] = "Bereich, in dem zusätzliche Ressourcen ohne Bosse erscheinen",
	["fr"] = "Une zone qui fait apparaître des ressources supplémentaires sans boss.",
	["tr"] = "Patron oluşturmadan fazladan kaynak üreten bir alan",
	["ru"] = "Область, в которой появляются дополнительные ресурсы без боссов",
	["vi"] = "Một khu vực xuất hiện tài nguyên bổ sung mà không có quái lớn",
	["zh-TW"] = "會生成較多資源的區域",
	["zh-CN"] = "会生成较多资源的区域",
})

ZShelter.L("#FinishSettings", {
	["en"] = "Save map config",
	["bg"] = "Запази конфигурацията на картата",
	["de"] = "Kartenkonfiguration speichern",
	["fr"] = "Sauvegarder la configuration de la carte",
	["tr"] = "Harita konfigürasyonunu kaydet",
	["ru"] = "Сохранить конфигурацию карты",
	["vi"] = "Lưu cấu hình bản đồ",
	["zh-TW"] = "保存地圖設定",
	["zh-CN"] = "保存地图设置",
})

ZShelter.L("#UnsupportedMap1", {
	["en"] = "Unsupported Map!",
	["bg"] = "Неподдържана карта!",
	["de"] = "Nicht unterstützte Karte!",
	["fr"] = "Carte non supportée !",
	["tr"] = "Desteklenmeyen Harita!",
	["ru"] = "Карта не поддерживается!",
	["vi"] = "Bản Đồ Không Được Hỗ Trợ!",
	["zh-TW"] = "不支援的地圖!",
	["zh-CN"] = "不支持的地图!",
})

ZShelter.L("#UnsupportedMapEditMode", {
	["en"] = "Press F3 to enter edit mode!",
	["bg"] = "Натисни F3 за влизане в режим на редактиране!",
	["de"] = "F3 drücken, um in den Bearbeitungsmodus zu wechseln!",
	["fr"] = "Appuyez sur F3 pour passer en mode édition !",
	["tr"] = "Düzenleme moduna girmek için F3'e bas!",
	["ru"] = "Нажмите F3 для входа в режим редактора!",
	["vi"] = "Nhấn F3 để vào chế độ chỉnh sửa!",
	["zh-TW"] = "按下F3進入地圖編輯模式",
	["zh-CN"] = "按下F3进入地图编辑模式",
})

ZShelter.L("#EditModeHint", {
	["en"] = "Press G to open settings menu",
	["bg"] = "Натисни G за отваряне на менюто за настройки",
	["de"] = "G drücken, um das Einstellungsmenü zu öffnen",
	["fr"] = "Appuyez sur G pour ouvrir le menu des paramètres",
	["tr"] = "Ayarlar menüsünü açmak için G'ye bas",
	["ru"] = "Нажмите G для открытия меню настроек",
	["vi"] = "Nhấn G để mở menu cài đặt",
	["zh-TW"] = "按下G打開設定選單",
	["zh-CN"] = "按下G打开设定菜单",
})

ZShelter.L("#EditModeHintPlace", {
	["en"] = "Left Click - Continue | Right Click - Cancel | R - Rotate",
	["bg"] = "Ляв бутон - Продължи | Десен бутон - Отказ | R - Завърти",
	["de"] = "Linksklick - Fortfahren | Rechtsklick - Abbrechen | R - Drehen",
	["fr"] = "Clic gauche - Continuer | Clic droit - Annuler | R -  Pivoter",
	["tr"] = "Sol Tık - Devam | Sağ Tık - İptal | R - Döndür",
	["ru"] = "ЛКМ - Продолжить | ПКМ - Отмена | [R] Вращать",
	["vi"] = "Nhấn Chuột Trái - Tiếp Tục | Nhấn Chuột Phải - Hủy | R - Xoay",
	["zh-TW"] = "左鍵 - 確認 | 右鍵 - 取消 | R - 旋轉",
	["zh-CN"] = "左键 - 确定 | 右键 - 取消 | R - 旋转",
})

ZShelter.L("#EditModeHintAim", {
	["en"] = "Right Click - Remove",
	["bg"] = "Десен бутон - Премахване",
	["de"] = "Rechtsklick - Entfernen",
	["fr"] = "Clic droit - Supprimer",
	["tr"] = "Sağ Tık - Kaldır",
	["ru"] = "ПКМ - Удалить",
	["vi"] = "Nhấn Chuột Phải - Xóa",
	["zh-TW"] = "右鍵 - 移除",
	["zh-CN"] = "右鍵 - 移除",
})

ZShelter.L("#AvgFail", {
	["en"] = "Average fail on <VAR> difficulty",
	["bg"] = "Средно неуспех при <VAR> трудност",
	["de"] = "Durchschnittlicher Fehlschlag auf Schwierigkeitsgrad <VAR>",
	["fr"] = "Moyenne d'échecs en difficulté <VAR>.",
	["tr"] = "<VAR> zorluğunda ortalama başarısızlık",
	["ru"] = "Ср. проигрышей на сложности «<VAR>»",
	["vi"] = "Tỷ lệ thất bại trung bình ở độ khó <VAR>",
	["zh-TW"] = "在<VAR>難度上的平均失敗點",
	["zh-CN"] = "在<VAR>难度上的平均失败点",
})

ZShelter.L("#TotalPlayed", {
	["en"] = "<VAR> Plays recorded",
	["bg"] = "<VAR> Изиграни записи",
	["de"] = "<VAR> aufgezeichnete Spiele",
	["fr"] = "Joueurs enregistrés: <VAR>",
	["tr"] = "Toplam Oynanma: <VAR>",
	["ru"] = "Записано игр: <VAR>",
	["vi"] = "Đã ghi lại <VAR> lần chơi",
	["zh-TW"] = "<VAR> 已記錄的遊玩紀錄",
	["zh-CN"] = "<VAR> 已记录的游玩记录",
})

ZShelter.L("#TotalFailed", {
	["en"] = "<VAR> Failed",
	["bg"] = "<VAR> Провали",
	["de"] = "<VAR> Fehlgeschlagen",
	["fr"] = "<VAR> Échec",
	["tr"] = "<VAR> Başarısız Oldu",
	["ru"] = "из которых <VAR> проиграны",
	["vi"] = "<VAR> Thất Bại",
	["zh-TW"] = "<VAR> 失敗",
	["zh-CN"] = "<VAR> 失败",
})

ZShelter.L("#WinFailRatio", {
	["en"] = "Win/Fail Ratio : <VAR>",
	["bg"] = "Съотношение успех/провал: <VAR>",
	["de"] = "Gewinn-/Misserfolgsverhältnis: <VAR>",
	["fr"] = "Taux de victoire/échec : <VAR>",
	["tr"] = "Kazanma/Yenilgi Oranı: <VAR>",
	["ru"] = "Соотн. побед/поражений: <VAR>",
	["vi"] = "Tỷ Lệ Thắng/Thất Bại : <VAR>",
	["zh-TW"] = "勝利/失敗比例 : <VAR>",
	["zh-CN"] = "输赢比 : <VAR>",
})

ZShelter.L("#OnlinePlayers", {
	["en"] = "Online Players : <VAR>",
	["bg"] = "Онлайн играчи: <VAR>",
	["de"] = "Spieler online: <VAR>",
	["fr"] = "Joueurs en ligne: <VAR>",
	["tr"] = "Çevrim İçi Oyuncu: <VAR>",
	["ru"] = "Игроков в игре : <VAR>",
	["vi"] = "Người Chơi Trực Tuyến : <VAR>",
	["zh-TW"] = "在線玩家 : <VAR>",
	["zh-CN"] = "在线玩家 : <VAR>",
})

ZShelter.L("#Fetching", {
	["en"] = "Fetching..",
	["bg"] = "Изтегляне..",
	["de"] = "Abrufen..",
	["fr"] = "Récupération..",
	["tr"] = "Getiriliyor..",
	["ru"] = "Поиск..",
	["vi"] = "Đang Lấy..",
	["zh-TW"] = "載入中..",
	["zh-CN"] = "载入中..",
})

ZShelter.L("#FindOtherPlayer", {
	["en"] = "Look for other players to play with!",
	["bg"] = "Търсене на други играчи!",
	["de"] = "Suche nach anderen Spielern, mit denen man spielen kann!",
	["fr"] = "Trouvez d'autres joueurs avec qui jouer !",
	["tr"] = "Oynamak için oyuncu ara!",
	["ru"] = "Найдите других игроков для игры!",
	["vi"] = "Tìm người chơi khác để chơi cùng!",
	["zh-TW"] = "尋找其他玩家一起進行遊戲!",
	["zh-CN"] = "寻找其他玩家一起游玩!",
})

ZShelter.L("#NDay", {
	["en"] = "Day <VAR>",
	["bg"] = "Ден <VAR>",
	["de"] = "Tag <VAR>",
	["fr"] = "Jour <VAR>",
	["tr"] = "Gün <VAR>",
	["ru"] = "День <VAR>",
	["vi"] = "Ngày <VAR>",
	["zh-TW"] = "第<VAR>天",
	["zh-CN"] = "第<VAR>天",
})

ZShelter.L("#ConnectionHint", {
	["en"] = "Connection might take a while, please be patient",
	["bg"] = "Връзката може да отнеме известно време, моля, бъдете търпеливи",
	["de"] = "Die Verbindung kann eine Weile dauern, bitte Geduld haben..",
	["fr"] = "La connexion peut prendre un certain temps, veuillez patienter",
	["tr"] = "Bağlanmak biraz sürebilir, lütfen sabırlı olun",
	["ru"] = "Подключение может занять время, будьте терпеливы",
	["vi"] = "Kết nối có thể mất một thời gian, hãy kiên nhẫn",
	["zh-TW"] = "連線需要一段時間, 請耐心等待",
	["zh-CN"] = "连接需要一些时间, 请耐心等候",
})

ZShelter.L("#Updates", {
	["en"] = "Updates",
	["bg"] = "Актуализации",
	["de"] = "Aktualisierungen",
	["fr"] = "Mises à Jour",
	["tr"] = "Güncellemeler",
	["ru"] = "Обновления",
	["vi"] = "Cập Nhật",
	["zh-TW"] = "內容更新",
	["zh-CN"] = "内容更新",
})

ZShelter.L("#Statistics", {
	["en"] = "Statistics",
	["bg"] = "Статистика",
	["de"] = "Statistiken",
	["fr"] = "Statistiques",
	["tr"] = "İstatistik",
	["ru"] = "Статистика",
	["vi"] = "Thống Kê",
	["zh-TW"] = "統計",
	["zh-CN"] = "统计",
})

ZShelter.L("#Looking2play", {
	["en"] = "Looking to play",
	["bg"] = "Търсене на игра",
	["de"] = "Spielsuche",
	["fr"] = "Joueurs",
	["tr"] = "Oyun oynamak istiyor",
	["ru"] = "Поиск игры",
	["vi"] = "Tìm người chơi",
	["zh-TW"] = "尋找遊戲",
	["zh-CN"] = "寻找游戏",
})

ZShelter.L("#LocalSv", {
	["en"] = "Local Server",
	["bg"] = "Локален сървър",
	["de"] = "Lokaler Server",
	["fr"] = "Serveur Local",
	["tr"] = "Yerel Sunucu",
	["ru"] = "Локальный сервер",
	["vi"] = "Máy Chủ Cục Bộ",
	["zh-TW"] = "本地端伺服器",
	["zh-CN"] = "本地服务器",
})

ZShelter.L("#Summery", {
	["en"] = "Summary",
	["bg"] = "Обобщение",
	["de"] = "Zusammenfassung",
	["fr"] = "Sommaire",
	["tr"] = "Özet",
	["ru"] = "Итоги",
	["vi"] = "Tóm Tắt",
	["zh-TW"] = "總結",
	["zh-CN"] = "总结",
})

ZShelter.L("#MapVote", {
	["en"] = "Map Vote",
	["bg"] = "Гласуване за карта",
	["de"] = "Kartenabstimmung",
	["fr"] = "Vote de la Carte",
	["tr"] = "Harita Oylama",
	["ru"] = "Голосование за карту",
	["vi"] = "Bình Chọn Bản Đồ",
	["zh-TW"] = "地圖投票",
	["zh-CN"] = "地图投票",
})

ZShelter.L("#Defeat", {
	["en"] = "Defeat!",
	["bg"] = "Поражение!",
	["de"] = "Verlust!",
	["fr"] = "Défaite !",
	["tr"] = "Mağlubiyet!",
	["ru"] = "Поражение!",
	["vi"] = "Thất Bại!",
	["zh-TW"] = "失敗!",
	["zh-CN"] = "失败!",
})

ZShelter.L("#ShelterDestroyed", {
	["en"] = "Shelter has been destroyed!",
	["bg"] = "Приютът беше унищожен!",
	["de"] = "Der Unterschlupf wurde zerstört!",
	["fr"] = "L'Abri a été détruit !",
	["tr"] = "Sığınak yok edildi!",
	["ru"] = "Убежище уничтожено!",
	["vi"] = "Nơi trú ẩn đã bị phá hủy!",
	["zh-TW"] = "避難所被摧毀了!",
	["zh-CN"] = "避难所被摧毁了!",
})

ZShelter.L("#Victory", {
	["en"] = "Victory!",
	["bg"] = "Победа!",
	["de"] = "Sieg!",
	["fr"] = "Victoire !",
	["tr"] = "Galibiyet!",
	["ru"] = "Победа!",
	["vi"] = "Chiến Thắng!",
	["zh-TW"] = "勝利!",
	["zh-CN"] = "胜利!",
})

ZShelter.L("#Survived30Day", {
	["en"] = "Successfully survived to day 30",
	["bg"] = "Успешно оцеля до ден 30",
	["de"] = "Erfolgreich bis Tag 30 überlebt",
	["fr"] = "Vous avez survécu jusqu'au 30ème jour",
	["tr"] = "Başarıyla 30. güne kadar hayatta kalındı",
	["ru"] = "Удалось дожить до 30-го дня",
	["vi"] = "Thành công sống sót đến ngày thứ 30",
	["zh-TW"] = "成功生存到第30天",
	["zh-CN"] = "成功生存到第30天",
})

ZShelter.L("#Survived15Day", {
	["en"] = "Successfully survived to day 15",
	["bg"] = "Успешно оцеля до ден 15",
	["de"] = "Erfolgreich bis Tag 15 überlebt",
	["fr"] = "Vous avez survécu jusqu'au 15ème jour",
	["tr"] = "Başarıyla 15. güne kadar hayatta kalındı",
	["ru"] = "Удалось дожить до 15-го дня",
	["vi"] = "Thành công sống sót đến ngày thứ 15",
	["zh-TW"] = "成功生存到第15天",
	["zh-CN"] = "成功生存到第15天",
})

ZShelter.L("#PTS", {
	["en"] = "<VAR> pts",
	["bg"] = "<VAR> точки",
	["de"] = "<VAR> Pkt.",
	["fr"] = "<VAR> points",
	["tr"] = "<VAR> puan",
	["ru"] = "<VAR> очк.",
	["vi"] = "<VAR> điểm",
	["zh-TW"] = "<VAR> 貢獻點",
	["zh-CN"] = "<VAR> 贡献点",
})

ZShelter.L("#MVP", {
	["en"] = "[MVP] <VAR>",
	["bg"] = "[MVP] <VAR>",
	["de"] = "[MVP] <VAR>",
	["fr"] = "[MJ] <VAR>",
	["tr"] = "[EDO] <VAR>",
	["ru"] = "[СЦИ] <VAR>",
	["vi"] = "[MVP] <VAR>",
	["zh-TW"] = "[MVP] <VAR>",
	["zh-CN"] = "[MVP] <VAR>",
})

ZShelter.L("#ServerList", {
	["en"] = "Server List",
	["bg"] = "Списък със сървъри",
	["de"] = "Serverliste",
	["fr"] = "Serveurs",
	["tr"] = "Sunucu Listesi",
	["ru"] = "",
	["vi"] = "Danh Sách Máy Chủ",
	["zh-TW"] = "伺服器列表",
	["zh-CN"] = "服务器列表",
})

ZShelter.L("#ServerListHint", {
	["en"] = "Servers on this list are running Zombie Shelter v2",
	["bg"] = "Сървърите в този списък работят с Zombie Shelter v2",
	["de"] = "Auf den Servern dieser Liste laufen Zombie Shelter v2.0",
	["fr"] = "Les serveurs de cette liste hébergent la v2 de Zombie Shelter.",
	["tr"] = "Bu listedeki sunucular Zombie Shelter v2 çalıştırıyor",
	["ru"] = "",
	["vi"] = "Các máy chủ trên danh sách này đang chạy Zombie Shelter v2",
	["zh-TW"] = "在此列表上的伺服器都在運行 Zombie Shelter v2",
	["zh-CN"] = "在此列表上的服务器都在运行 Zombie Shelter v2",
})

ZShelter.L("#ServerListAddr", {
	["en"] = "Address : <VAR>",
	["bg"] = "IP Адрес: <VAR>",
	["de"] = "IP Addresse : <VAR>",
	["fr"] = "Adresse IP: <VAR>",
	["tr"] = "IP Adresi : <VAR>",
	["ru"] = "",
	["vi"] = "Địa Chỉ : <VAR>",
	["zh-TW"] = "伺服器IP : <VAR>",
	["zh-CN"] = "服务器IP : <VAR>",
})

ZShelter.L("#ServerListClick", {
	["en"] = "Click to join",
	["bg"] = "Кликни за присъединяване",
	["de"] = "Klicken, um beizutreten",
	["fr"] = "Cliquez pour rejoindre",
	["tr"] = "Katılmak için tıkla",
	["ru"] = "",
	["vi"] = "Nhấn để tham gia",
	["zh-TW"] = "點擊加入",
	["zh-CN"] = "点击加入",
})

ZShelter.L("#SpawnPointExtra", {
	["en"] = "Enemy Spawn Point",
	["bg"] = "Точка за появяване на врагове",
	["de"] = "Feindlicher Spawnpunkt",
	["fr"] = "Point d'Apparition des Ennemis",
	["tr"] = "Düşman Doğma Noktası",
	["ru"] = "",
	["vi"] = "Điểm Xuất Hiện Kẻ Thù",
	["zh-TW"] = "敵人生成點",
	["zh-CN"] = "敌人生成点",
})

ZShelter.L("#SpawnPointExtraDesc", {
	["en"] = "An extra spawn point for enemy to spawn",
	["bg"] = "Допълнителна точка за появяване на врагове",
	["de"] = "Ein zusätzlicher Spawnpunkt für den Gegner",
	["fr"] = "Point d'apparition supplémentaire pour les ennemis",
	["tr"] = "Düşmanın doğması için fazladan bir doğma noktası",
	["ru"] = "",
	["vi"] = "Một điểm hồi sinh bổ sung cho kẻ thù xuất hiện",
	["zh-TW"] = "敵人重生點",
	["zh-CN"] = "敌人重生点",
})

ZShelter.L("#SpawnPointDedicated", {
	["en"] = "Dedicated Enemy Spawn Point",
	["bg"] = "Специална точка за появяване на врагове",
	["de"] = "Dedizierter Spawnpunkt für Feinde",
	["fr"] = "Point d'Apparitions Dédié aux Ennemis",
	["tr"] = "Özel Düşman Doğma Noktası",
	["ru"] = "",
	["vi"] = "Điểm Hồi Sinh Kẻ Thù Dành Riêng",
	["zh-TW"] = "固定敵人生成點",
	["zh-CN"] = "固定敌人生成点",
})

ZShelter.L("#SpawnPointDedicatedDesc", {
	["en"] = "An DEDICATED spawn point, if you placed any of this enemy will be spawn at this fixed position",
	["bg"] = "Фиксирана точка за появяване, ако поставите това, враговете ще се появят на това място",
	["de"] = "Ein DEDIZIERTER Spawnpunkt, falls einer dieser platziert wurde, werden Feinde an dieser festen Position erscheinen.",
	["fr"] = "Point d'apparition DÉDIÉ, si vous en placez un les ennemis apparaîtront à cette position fixe.",
	["tr"] = "ÖZEL bir doğma noktası, eğer bu düşmandan herhangi birini yerleştirirsen, bu sabit konumda doğacak",
	["ru"] = "",
	["vi"] = "Một điểm hồi sinh DÀNH RIÊNG, nếu bạn đặt bất kỳ kẻ thù nào ở đây, chúng sẽ xuất hiện ở vị trí cố định này",
	["zh-TW"] = "放置後敵人會被生成在這個固定的位置",
	["zh-CN"] = "放置后敌人会被生成在这个固定的位置",
})

ZShelter.L("#ManualControl", {
	["en"] = "Press middle mouse to control",
	["bg"] = "Натисни средния бутон на мишката за управление",
	["de"] = "Mittlere Maustaste drücken, um zu steuern",
	["fr"] = "Appuyer sur la molette de la souris pour contrôler",
	["tr"] = "Kontrol etmek için fare tekerleğini kullanın",
	["ru"] = "",
	["vi"] = "Nhấn giữ chuột giữa để điều khiển",
	["zh-TW"] = "點擊滑鼠中鍵控制",
	["zh-CN"] = "点击滑鼠中键控制",
})

ZShelter.L("#EnemyList", {
	["en"] = "Enemies",
	["bg"] = "Врагове",
	["de"] = "Gegner",
	["fr"] = "Ennemis",
	["tr"] = "Düşmanlar",
	["ru"] = "",
	["vi"] = "Kẻ thù",
	["zh-TW"] = "敵人列表",
	["zh-CN"] = "敌人列表",
})

ZShelter.L("#EnemyListTitle", {
	["en"] = "Enemies on <VAR> difficulty",
	["bg"] = "Врагове на <VAR> трудност",
	["de"] = "Feinde auf Schwierigkeitsgrad <VAR>",
	["fr"] = "Ennemis en difficulté <VAR>",
	["tr"] = "<VAR> zorluğunda düşmanlar",
	["ru"] = "",
	["vi"] = "Kẻ thù ở độ khó <VAR>",
	["zh-TW"] = "會出現在<VAR>難度的敵人",
	["zh-CN"] = "会出现在<VAR>难度的敌人",
})

ZShelter.L("#EnemyListHPBoost", {
	["en"] = "[Day x <VAR>]",
	["bg"] = "[Ден x <VAR>]",
	["de"] = "[Tag x <VAR>]",
	["fr"] = "[Jour x <VAR>]",
	["tr"] = "[Gün Sayısı x <VAR>]",
	["ru"] = "",
	["vi"] = "[Ngày x <VAR>]",
	["zh-TW"] = "[天數 x <VAR>]",
	["zh-CN"] = "[天数 x <VAR>]",
})

local TemporaryUnsupportedLanguage = {

}

function ZShelter_GetTranslate_Var(input, int)
	local language = GetConVar("gmod_language"):GetString()
	if(!ZShelter.Lang[input]) then return string.Replace(input, "#", "") end
	if(!ZShelter.Lang[input][language] || TemporaryUnsupportedLanguage[language]) then
		language = "en"
		if(!ZShelter.Lang[input][language]) then return string.Replace(input, "#", "") end
	end
	local str = ZShelter.Lang[input][language]
	return string.Replace(str, "<VAR>", int)
end

function ZShelter_ShouldTranslate(str)
	if str[1] == "#" then
		return ZShelter_GetTranslate(str)
	else
		return str
	end
end

function ZShelter_GetTranslate(input)
	local language = GetConVar("gmod_language"):GetString()
	if(!ZShelter.Lang[input]) then return string.Replace(input, "#", "") end
	if(!ZShelter.Lang[input][language] || TemporaryUnsupportedLanguage[language]) then
		language = "en"
		if(!ZShelter.Lang[input][language]) then return string.Replace(input, "#", "") end
	end
	local ret = ZShelter.Lang[input][language]
	if(ret == "") then return ZShelter.Lang[input]["en"] end
	return ret
end
