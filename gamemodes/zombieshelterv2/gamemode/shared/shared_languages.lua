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

ZShelter.Lang = {}

function ZShelter.AddTranslate(index, tab)
	ZShelter.Lang[index] = tab
end

--[[
ZShelter.AddTranslate("#",{
	["en"] = "",
	["tr"] = "",
	["ru"] = "",
	["zh-TW"] = "",
	["zh-CN"] = "",
})
]]
ZShelter.AddTranslate("#SkillPTS", {
	["en"] = "Skill menu - [N] | Remaining points : ",
	["tr"] = "Yetenek menüsü - [N] | Kalan puan : ",
	["ru"] = "Меню навыков - [N] | Осталось очков : ",
	["zh-TW"] = "技能樹 - [N] | 剩餘點數 : ",
	["zh-CN"] = "技能树 - [N] | 剩余点数: ",
})

ZShelter.AddTranslate("#GameStartAfter", {
	["en"] = "Game will start after <VAR> seconds",
	["tr"] = "Oyun <VAR> saniye sonra başlayacak",
	["ru"] = "Игра начнётся через <VAR> сек.",
	["zh-TW"] = "遊戲將在 <VAR> 秒後開始",
	["zh-CN"] = "游戏将在 <VAR> 秒后开始",
})

ZShelter.AddTranslate("#RespawnAfter", {
	["en"] = "Respawn after <VAR> seconds",
	["tr"] = "<VAR> saniye sonra yeniden canlanılacak",
	["ru"] = "Возрождение через <VAR> сек.",
	["zh-TW"] = "在 <VAR> 秒後重生",
	["zh-CN"] = "将在 <VAR> 秒后重生",
})

ZShelter.AddTranslate("#BuildingHint", {
	["en"] = "[Left Click] Build   |  [R] Rotate  |   [Right Click] Cancel",
	["tr"] = "[Sol Tık] İnşa Et   |  [R] Döndür  |   [Sağ Tık] İptal",
	["ru"] = "[ЛКМ] Построить   |  [R] Вращать  |   [ПКМ] Отмена",
	["zh-TW"] = "[左鍵] 建造  |  [R] 旋轉  |  [右鍵] 取消",
	["zh-CN"] = "[左键] 建造  |  [R] 旋转  |  [右键] 取消",
})

ZShelter.AddTranslate("#BuildHints", {
	["en"] = "[B] Build Menu  |  [F2] Game Menu  |  [F6] Config Menu",
	["tr"] = "[B] İnşa Menüsü  |  [F2] Oyun Menüsü  |  [F6] Konfigürasyon Menüsü",
	["ru"] = "[B] Постройки  |  [F2] Меню игры  |  [F6] Конфигурация",
	["zh-TW"] = "[B] 建造清單  |  [F2] 遊戲介面 |  [F6] 設定介面",
	["zh-CN"] = "[B] 建造菜单  |  [F2] 模式菜单 |  [F6] 设置菜单",
})

ZShelter.AddTranslate("#Shelter", {
	["en"] = "Shelter",
	["tr"] = "Sığınak",
	["ru"] = "Убежище",
	["zh-TW"] = "避難所",
	["zh-CN"] = "避难所",
})

ZShelter.AddTranslate("#Barricade", {
	["en"] = "Barricade",
	["tr"] = "Barikat",
	["ru"] = "Баррикады",
	["zh-TW"] = "障礙物",
	["zh-CN"] = "障碍物",
})

ZShelter.AddTranslate("#Trap", {
	["en"] = "Trap",
	["tr"] = "Tuzak",
	["ru"] = "Ловушки",
	["zh-TW"] = "陷阱",
	["zh-CN"] = "陷阱",
})

ZShelter.AddTranslate("#Turret", {
	["en"] = "Turret",
	["tr"] = "Taret",
	["ru"] = "Турели",
	["zh-TW"] = "砲塔",
	["zh-CN"] = "炮塔",
})

ZShelter.AddTranslate("#Generator", {
	["en"] = "Generator",
	["tr"] = "Jeneratör",
	["ru"] = "Генератор",
	["zh-TW"] = "發電機",
	["zh-CN"] = "发电机",
})

ZShelter.AddTranslate("#Recovery", {
	["en"] = "Recovery",
	["tr"] = "İyileşme",
	["ru"] = "Восстановление",
	["zh-TW"] = "恢復設施",
	["zh-CN"] = "回复设施",
})

ZShelter.AddTranslate("#Storage", {
	["en"] = "Storage",
	["tr"] = "Depo",
	["ru"] = "Склад",
	["zh-TW"] = "倉庫",
	["zh-CN"] = "仓库",
})

ZShelter.AddTranslate("#Public Construction", {
	["en"] = "Public Construction",
	["tr"] = "Herkese Açık İnşaat",
	["ru"] = "Общ. строительство",
	["zh-TW"] = "公共建設",
	["zh-CN"] = "公共设施",
})

ZShelter.AddTranslate("#Wooden Wall", {
	["en"] = "Wooden Wall",
	["tr"] = "Ahşap Duvar",
	["ru"] = "Деревянная стена",
	["zh-TW"] = "木製牆壁",
	["zh-CN"] = "木制墙壁",
})

ZShelter.AddTranslate("#Wooden Spike Wall", {
	["en"] = "Wooden Spike Wall",
	["ru"] = "Деревянная стена с колышками",
	["tr"] = "Dikenli Ahşap Duvar",
	["zh-TW"] = "木製尖刺",
	["zh-CN"] = "木制尖刺",
})

ZShelter.AddTranslate("#Wire Fence", {
	["en"] = "Wire Fence",
	["tr"] = "Tel Çit",
	["ru"] = "Проволочный забор",
	["zh-TW"] = "鐵絲網",
	["zh-CN"] = "铁丝网",
})

ZShelter.AddTranslate("#Metal Wall", {
	["en"] = "Metal Wall",
	["tr"] = "Metal Duvar",
	["ru"] = "Металлическая стена",
	["zh-TW"] = "鐵製牆壁",
	["zh-CN"] = "铁制墙壁",
})

ZShelter.AddTranslate("#Reinforced Wire Fence", {
	["en"] = "Reinforced Wire Fence",
	["tr"] = "Güçlendirilmiş Tel Çit",
	["ru"] = "Армированный проволочный забор",
	["zh-TW"] = "強化鐵絲網",
	["zh-CN"] = "强化铁丝网",
})

ZShelter.AddTranslate("#Metal Gate", {
	["en"] = "Metal Gate",
	["tr"] = "Metal Geçit",
	["ru"] = "Металлические ворота",
	["zh-TW"] = "鐵絲門",
	["zh-CN"] = "铁丝门",
})

ZShelter.AddTranslate("#Metal Barricade", {
	["en"] = "Metal Barricade",
	["tr"] = "Metal Barikat",
	["ru"] = "Металлическая баррикада",
	["zh-TW"] = "鐵製路障",
	["zh-CN"] = "铁制路障",
})

ZShelter.AddTranslate("#Concrete Wall", {
	["en"] = "Concrete Wall",
	["tr"] = "Beton Duvar",
	["ru"] = "Бетонная стена",
	["zh-TW"] = "水泥牆",
	["zh-CN"] = "水泥墙",
})

ZShelter.AddTranslate("#Concrete Gate", {
	["en"] = "Concrete Gate",
	["tr"] = "Beton Geçit",
	["ru"] = "Бетонные ворота",
	["zh-TW"] = "鋼製鐵門",
	["zh-CN"] = "钢制铁门",
})

ZShelter.AddTranslate("#Reinforced Concrete Wall", {
	["en"] = "Reinforced Concrete Wall",
	["tr"] = "Güçlendirilmiş Beton Duvar",
	["ru"] = "Железобетонная стена",
	["zh-TW"] = "強化水泥牆",
	["zh-CN"] = "强化水泥墙",
})

ZShelter.AddTranslate("#Concrete Barricade", {
	["en"] = "Concrete Barricade",
	["tr"] = "Beton Barikat",
	["ru"] = "Бетонная баррикада",
	["zh-TW"] = "水泥路障",
	["zh-CN"] = "水泥路障",
})

ZShelter.AddTranslate("#Landmine", {
	["en"] = "Landmine",
	["tr"] = "Mayın",
	["ru"] = "Фугас",
	["zh-TW"] = "地雷",
	["zh-CN"] = "地雷",
})

ZShelter.AddTranslate("#Razorwire", {
	["en"] = "Razorwire",
	["tr"] = "Dikenli Tel",
	["ru"] = "Колючая проволока",
	["zh-TW"] = "鐵絲網",
	["zh-CN"] = "铁丝网",
})

ZShelter.AddTranslate("#Claymore", {
	["en"] = "Claymore",
	["tr"] = "Kılıç",
	["ru"] = "Противопехотная мина",
	["zh-TW"] = "闊刀地雷",
	["zh-CN"] = "阔剑地雷",
})

ZShelter.AddTranslate("#Freeze Bomb", {
	["en"] = "Freeze Bomb",
	["tr"] = "Dondurucu Bomba",
	["ru"] = "Замораживающая бомба",
	["zh-TW"] = "冷凍炸彈",
	["zh-CN"] = "冷冻炸弹",
})

ZShelter.AddTranslate("#Spike Trap", {
	["en"] = "Spike Trap",
	["tr"] = "Dikenli Tuzak",
	["ru"] = "Шипастая ловушка",
	["zh-TW"] = "尖刺陷阱",
	["zh-CN"] = "尖刺陷阱",
})

ZShelter.AddTranslate("#Propeller Trap", {
	["en"] = "Propeller Trap",
	["tr"] = "Pervane Tuzağı",
	["ru"] = "Пропеллерная ловушка",
	["zh-TW"] = "鋸刀陷阱",
	["zh-CN"] = "锯刃陷阱",
})

ZShelter.AddTranslate("#Flame Trap", {
	["en"] = "Flame Trap",
	["tr"] = "",
	["ru"] = "Огненная ловушка",
	["zh-TW"] = "火焰陷阱",
	["zh-CN"] = "喷火陷阱",
})

ZShelter.AddTranslate("#CMB Trap", {
	["en"] = "Cyro Mine",
	["tr"] = "",
	["ru"] = "",
	["zh-TW"] = "凍結地雷",
	["zh-CN"] = "冻结地雷",
})

ZShelter.AddTranslate("Laser Trap", {
	["en"] = "Laser Trap",
	["tr"] = "",
	["ru"] = "",
	["zh-TW"] = "雷射陷阱",
	["zh-CN"] = "雷射陷阱",
})

ZShelter.AddTranslate("#Basic Turret", {
	["en"] = "Basic Turret",
	["tr"] = "Temel Taret",
	["ru"] = "Основная турель",
	["zh-TW"] = "槍塔",
	["zh-CN"] = "炮塔",
})

ZShelter.AddTranslate("#Mounted Machine Gun", {
	["en"] = "Mounted Machine Gun",
	["tr"] = "Monteli Makineli Tüfek",
	["ru"] = "Станковый пулемёт",
	["zh-TW"] = "固定式機槍塔",
	["zh-CN"] = "固定式炮塔",
})

ZShelter.AddTranslate("#Freeze Turret", {
	["en"] = "Freeze Turret",
	["tr"] = "Dondurucu Taret",
	["ru"] = "Замораживающая турель",
	["zh-TW"] = "冷凍槍塔",
	["zh-CN"] = "冷冻炮塔",
})

ZShelter.AddTranslate("#Mending Tower", {
	["en"] = "Mending Tower",
	["tr"] = "Tamir Kulesi",
	["ru"] = "Ремонтная башня",
	["zh-TW"] = "建築修復器",
	["zh-CN"] = "建筑修复器",
})

ZShelter.AddTranslate("#Flame Turret", {
	["en"] = "Flame Turret",
	["tr"] = "Alev Tareti",
	["ru"] = "Огнемётная турель",
	["zh-TW"] = "火焰槍塔",
	["zh-CN"] = "喷火炮塔",
})

ZShelter.AddTranslate("#Blast Turret", {
	["en"] = "Blast Turret",
	["tr"] = "Bomba Tareti",
	["ru"] = "Взрывная турель",
	["zh-TW"] = "爆破槍塔",
	["zh-CN"] = "爆破炮塔",
})

ZShelter.AddTranslate("#Enemy Scanner", {
	["en"] = "Enemy Scanner",
	["tr"] = "Düşman Tarayıcı",
	["ru"] = "Сканер",
	["zh-TW"] = "掃描器",
	["zh-CN"] = "扫描器",
})

ZShelter.AddTranslate("#Minigun Turret", {
	["en"] = "Minigun Turret",
	["tr"] = "Minigun Tareti",
	["ru"] = "Турель-миниган",
	["zh-TW"] = "超級機槍塔",
	["zh-CN"] = "机关枪炮塔",
})

ZShelter.AddTranslate("#Pusher Tower", {
	["en"] = "Pusher Tower",
	["tr"] = "İtici Kule",
	["ru"] = "Толкающая башня",
	["zh-TW"] = "位移塔",
	["zh-CN"] = "位移炮塔",
})

ZShelter.AddTranslate("#Railgun Cannon", {
	["en"] = "Railgun Cannon",
	["tr"] = "Elektromanyetik Top",
	["ru"] = "Рельсотронное орудие",
	["zh-TW"] = "電磁炮",
	["zh-CN"] = "电磁炮",
})

ZShelter.AddTranslate("#Electric Defense Tower", {
	["en"] = "Electric Defense Tower",
	["tr"] = "Elektrikli Savunma Kulesi",
	["ru"] = "Электронная башня",
	["zh-TW"] = "電磁網塔",
	["zh-CN"] = "电磁防御塔",
})

ZShelter.AddTranslate("#Mortar Cannon", {
	["en"] = "Mortar Cannon",
	["tr"] = "Havan Topu",
	["ru"] = "Миномёт",
	["zh-TW"] = "迫擊砲",
	["zh-CN"] = "迫击炮",
})

ZShelter.AddTranslate("#Plasma Turret", {
	["en"] = "Plasma Turret",
	["tr"] = "Plazma Tareti",
	["ru"] = "Плазменная турель",
	["zh-TW"] = "幽能離子塔",
	["zh-CN"] = "等离子体炮塔",
})

ZShelter.AddTranslate("#Laser Turret", {
	["en"] = "Laser Turret",
	["tr"] = "",
	["ru"] = "",
	["zh-TW"] = "雷射砲塔",
	["zh-CN"] = "雷射炮塔",
})

ZShelter.AddTranslate("#Combine Mortar Cannon", {
	["en"] = "Combine Mortar Cannon",
	["tr"] = "Combine Havan Topu",
	["ru"] = "Миномёт комбайнов",
	["zh-TW"] = "聯合軍迫擊砲",
	["zh-CN"] = "联合军迫击炮",
})

ZShelter.AddTranslate("#Basic Generator", {
	["en"] = "Basic Generator",
	["tr"] = "Temel Seviye Jeneratör",
	["ru"] = "Основной генератор",
	["zh-TW"] = "發電機",
	["zh-CN"] = "小型发电机",
})

ZShelter.AddTranslate("#Medium Generator", {
	["en"] = "Medium Generator",
	["tr"] = "Orta Seviye Jeneratör",
	["ru"] = "Средний генератор",
	["zh-TW"] = "中型發電機",
	["zh-CN"] = "中型发电机",
})

ZShelter.AddTranslate("#Large Generator", {
	["en"] = "Large Generator",
	["tr"] = "Gelişmiş Jeneratör",
	["ru"] = "Большой генератор",
	["zh-TW"] = "大型發電機",
	["zh-CN"] = "大型发电机",
})

ZShelter.AddTranslate("#Mega Generator", {
	["en"] = "Mega Generator",
	["tr"] = "Mega Jeneratör",
	["ru"] = "Мегагенератор",
	["zh-TW"] = "超大型發電機",
	["zh-CN"] = "超大型发电机",
})

ZShelter.AddTranslate("#Resource Generator", {
	["en"] = "Resource Generator",
	["tr"] = "Kaynak Jeneratörü",
	["ru"] = "Генератор ресурсов",
	["zh-TW"] = "資源生成器",
	["zh-CN"] = "资源生成器",
})

ZShelter.AddTranslate("#Healing Station", {
	["en"] = "Healing Station",
	["tr"] = "Sağlık İstasyonu",
	["ru"] = "Медпункт",
	["zh-TW"] = "醫療站",
	["zh-CN"] = "医疗站",
})

ZShelter.AddTranslate("#Armor Box", {
	["en"] = "Armor Box",
	["tr"] = "Zırh Kutusu",
	["ru"] = "Ящик брони",
	["zh-TW"] = "護甲箱",
	["zh-CN"] = "护甲箱",
})

ZShelter.AddTranslate("#Campfire", {
	["en"] = "Campfire",
	["tr"] = "Kamp Ateşi",
	["ru"] = "Костёр",
	["zh-TW"] = "營火",
	["zh-CN"] = "营火",
})

ZShelter.AddTranslate("#Basic Storage", {
	["en"] = "Basic Storage",
	["tr"] = "Temel Seviye Depo",
	["ru"] = "Основной склад",
	["zh-TW"] = "小倉庫",
	["zh-CN"] = "小型仓库",
})

ZShelter.AddTranslate("#Medium Storage", {
	["en"] = "Medium Storage",
	["tr"] = "Orta Seviye Depo",
	["ru"] = "Средний склад",
	["zh-TW"] = "中型倉庫",
	["zh-CN"] = "中型仓库",
})

ZShelter.AddTranslate("#Large Storage", {
	["en"] = "Large Storage",
	["tr"] = "Gelişmiş Depo",
	["ru"] = "Большой склад",
	["zh-TW"] = "大型倉庫",
	["zh-CN"] = "大型仓库",
})

ZShelter.AddTranslate("#Worktable", {
	["en"] = "Worktable",
	["tr"] = "Çalışma Masası",
	["ru"] = "Верстак",
	["zh-TW"] = "工作站",
	["zh-CN"] = "工作台",
})

ZShelter.AddTranslate("#Ammo Supply Crate", {
	["en"] = "Ammo Supply Crate",
	["tr"] = "Cephane İkmal Sandığı",
	["ru"] = "Ящик с боеприпасами",
	["zh-TW"] = "彈藥補給箱",
	["zh-CN"] = "弹药补给箱",
})

ZShelter.AddTranslate("#Cement Mixer", {
	["en"] = "Cement Mixer",
	["tr"] = "Beton Karıştırıcı",
	["ru"] = "Бетонный завод",
	["zh-TW"] = "水泥煉製廠",
	["zh-CN"] = "水泥搅拌机",
})

ZShelter.AddTranslate("#Comm Tower", {
	["en"] = "Comm Tower",
	["tr"] = "İletişim Kulesi",
	["ru"] = "Радиобашня",
	["zh-TW"] = "通訊塔",
	["zh-CN"] = "通讯塔",
})

ZShelter.AddTranslate("#Ready", {
	["en"] = "Ready",
	["tr"] = "Hazır",
	["ru"] = "Готово",
	["zh-TW"] = "準備",
	["zh-CN"] = "准备",
})

ZShelter.AddTranslate("#Not Ready", {
	["en"] = "Not Ready",
	["tr"] = "Hazır Değil",
	["ru"] = "Не готово",
	["zh-TW"] = "未準備",
	["zh-CN"] = "未准备",
})

ZShelter.AddTranslate("#ReadyHint", {
	["en"] = "Press F4 to ready",
	["tr"] = "Hazır olmak için F4'e basın",
	["ru"] = "F4 - готовность",
	["zh-TW"] = "F4 - 準備",
	["zh-CN"] = "F4 - 准备",
})

ZShelter.AddTranslate("#Map", {
	["en"] = "Map",
	["tr"] = "Harita",
	["ru"] = "Карта",
	["zh-TW"] = "地圖",
	["zh-CN"] = "地图",
})

ZShelter.AddTranslate("#Dif1", {
	["en"] = "Easy",
	["tr"] = "Kolay",
	["ru"] = "Новичок",
	["zh-TW"] = "簡單",
	["zh-CN"] = "简单",
})

ZShelter.AddTranslate("#Dif2", {
	["en"] = "Normal",
	["tr"] = "Normal",
	["ru"] = "Выживший",
	["zh-TW"] = "普通",
	["zh-CN"] = "普通",
})

ZShelter.AddTranslate("#Dif3", {
	["en"] = "Hard",
	["tr"] = "Zor",
	["ru"] = "Ветеран",
	["zh-TW"] = "困難",
	["zh-CN"] = "困难",
})

ZShelter.AddTranslate("#Dif4", {
	["en"] = "Expert",
	["tr"] = "Uzman",
	["ru"] = "Эксперт",
	["zh-TW"] = "專家",
	["zh-CN"] = "专家",
})

ZShelter.AddTranslate("#Dif5", {
	["en"] = "Insane",
	["tr"] = "Deli",
	["ru"] = "Безумие",
	["zh-TW"] = "瘋狂",
	["zh-CN"] = "疯狂",
})

ZShelter.AddTranslate("#Dif6", {
	["en"] = "Nightmare",
	["tr"] = "Kâbus",
	["ru"] = "Кошмар",
	["zh-TW"] = "惡夢",
	["zh-CN"] = "噩梦",
})

ZShelter.AddTranslate("#Dif7", {
	["en"] = "Apocalypse",
	["tr"] = "Kıyamet",
	["ru"] = "Апокалипсис",
	["zh-TW"] = "天啟",
	["zh-CN"] = "天启",
})

ZShelter.AddTranslate("#Dif8", {
	["en"] = "Apocalypse+",
	["tr"] = "Kıyamet+",
	["ru"] = "Апокалипсис+",
	["zh-TW"] = "天啟+",
	["zh-CN"] = "天启+",
})

ZShelter.AddTranslate("#Dif9", {
	["en"] = "Hell",
	["tr"] = "Cehennem",
	["ru"] = "Ад",
	["zh-TW"] = "地獄",
	["zh-CN"] = "地狱",
})

ZShelter.AddTranslate("#Woods", {
	["en"] = "Woods",
	["tr"] = "Ahşap",
	["ru"] = "Дерево",
	["zh-TW"] = "木材",
	["zh-CN"] = "木材",
})

ZShelter.AddTranslate("#Irons", {
	["en"] = "Irons",
	["tr"] = "Demir",
	["ru"] = "Сталь",
	["zh-TW"] = "鐵材",
	["zh-CN"] = "钢材",
})

ZShelter.AddTranslate("#Contribute", {
	["en"] = "Contribute",
	["tr"] = "Katkı",
	["ru"] = "Вклад",
	["zh-TW"] = "貢獻度",
	["zh-CN"] = "贡献度",
})

ZShelter.AddTranslate("#Deaths", {
	["en"] = "Deaths",
	["tr"] = "Ölüm",
	["ru"] = "Смерти",
	["zh-TW"] = "死亡",
	["zh-CN"] = "死亡",
})

ZShelter.AddTranslate("#Name", {
	["en"] = "Name",
	["tr"] = "Ad",
	["ru"] = "Имя",
	["zh-TW"] = "名稱",
	["zh-CN"] = "名称",
})

ZShelter.AddTranslate("#TK", {
	["en"] = "TK",
	["tr"] = "TÖ",
	["ru"] = "ОГПС",
	["zh-TW"] = "誤傷",
	["zh-CN"] = "误伤",
})

ZShelter.AddTranslate("#CommHint", {
	["en"] = "Comm Tower can be used now!",
	["tr"] = "İletişim kulesi şimdi kullanılabilir!",
	["ru"] = "Радиобашню можно использовать уже сейчас!",
	["zh-TW"] = "可以使用通訊塔了!",
	["zh-CN"] = "可以使用通讯塔了!",
})

ZShelter.AddTranslate("#SummeryStats", {
	["en"] = "Stats",
	["tr"] = "İstatistik",
	["ru"] = "Статистика",
	["zh-TW"] = "總結",
	["zh-CN"] = "总结",
})

ZShelter.AddTranslate("#TotalPlayTime", {
	["en"] = "Total Playtime : <VAR>",
	["tr"] = "Toplam Oynama Süresi: <VAR>",
	["ru"] = "Общее время игры : <VAR>",
	["zh-TW"] = "總遊玩時間 : <VAR>",
	["zh-CN"] = "总游玩时间: <VAR>",
})

ZShelter.AddTranslate("#TotalKills", {
	["en"] = "Total Enemy Killed",
	["tr"] = "Toplam Öldürülen Düşman",
	["ru"] = "Всего врагов убито",
	["zh-TW"] = "總殺敵數",
	["zh-CN"] = "总击杀数",
})

ZShelter.AddTranslate("#TotalWoods", {
	["en"] = "Total Woods Gathered",
	["tr"] = "Toplam Biriktirilen Ahşap",
	["ru"] = "Всего собрано дерева",
	["zh-TW"] = "總木材採集數",
	["zh-CN"] = "总木材采集数",
})

ZShelter.AddTranslate("#TotalIrons", {
	["en"] = "Total Irons Gathered",
	["tr"] = "Toplam Biriktirilen Demir",
	["ru"] = "Всего собрано стали",
	["zh-TW"] = "總鐵材採集數",
	["zh-CN"] = "总钢材采集数",
})

ZShelter.AddTranslate("#TotalBuilds", {
	["en"] = "Total Structure Built",
	["tr"] = "Toplam İnşa Edilen Yapı",
	["ru"] = "Всего строений",
	["zh-TW"] = "總建造數",
	["zh-CN"] = "总建造数",
})

ZShelter.AddTranslate("#PublicStorageHint", {
	["en"] = "Resources in storage",
	["tr"] = "Kaynaklar deponda",
	["ru"] = "Ресурсов на складе",
	["zh-TW"] = "倉庫資源",
	["zh-CN"] = "仓库资源",
})

ZShelter.AddTranslate("#PersonalStorageHint", {
	["en"] = "Resources in backpack",
	["tr"] = "Kaynaklar sırt çantanda",
	["ru"] = "Ресурсов в рюкзаке",
	["zh-TW"] = "背包資源",
	["zh-CN"] = "背包资源",
})

ZShelter.AddTranslate("#UpgradeHint", {
	["en"] = "Hold E to upgrade",
	["tr"] = "Geliştirmek için E'ye basılı tut",
	["ru"] = "Удерживайте E для улучшения",
	["zh-TW"] = "按住使用鍵升級",
	["zh-CN"] = "按住使用键升级",
})

ZShelter.AddTranslate("#Combat", {
	["en"] = "Combat",
	["tr"] = "Savaş",
	["ru"] = "Бой",
	["zh-TW"] = "戰鬥",
	["zh-CN"] = "战斗",
})

ZShelter.AddTranslate("#Survival", {
	["en"] = "Survival",
	["tr"] = "Hayatta Kalma",
	["ru"] = "Выживание",
	["zh-TW"] = "生存",
	["zh-CN"] = "生存",
})

ZShelter.AddTranslate("#Engineer", {
	["en"] = "Engineer",
	["tr"] = "Mühendislik",
	["ru"] = "Инженерия",
	["zh-TW"] = "工程師",
	["zh-CN"] = "工程师",
})

ZShelter.AddTranslate("#Pistol", {
	["en"] = "Pistol",
	["tr"] = "Tabanca",
	["ru"] = "Пистолеты",
	["zh-TW"] = "手槍",
	["zh-CN"] = "手枪",
})

ZShelter.AddTranslate("#SMG", {
	["en"] = "SMG",
	["tr"] = "SMG",
	["ru"] = "Пистолеты-пулемёты",
	["zh-TW"] = "衝鋒槍",
	["zh-CN"] = "冲锋枪",
})

ZShelter.AddTranslate("#Shotgun", {
	["en"] = "Shotgun",
	["tr"] = "Pompalı Tüfek",
	["ru"] = "Дробовики",
	["zh-TW"] = "霰彈槍",
	["zh-CN"] = "霰弹枪",
})

ZShelter.AddTranslate("#Rifle", {
	["en"] = "Rifle",
	["tr"] = "Tüfek",
	["ru"] = "Винтовки",
	["zh-TW"] = "步槍",
	["zh-CN"] = "步枪",
})

ZShelter.AddTranslate("#Heavy", {
	["en"] = "Heavy",
	["tr"] = "Ağır",
	["ru"] = "Тяжёлое",
	["zh-TW"] = "重型武器",
	["zh-CN"] = "重型武器",
})

ZShelter.AddTranslate("#Close", {
	["en"] = "Close",
	["tr"] = "Kapat",
	["ru"] = "Закрыть",
	["zh-TW"] = "關閉",
	["zh-CN"] = "关闭",
})

ZShelter.AddTranslate("#ShelterNick", {
	["en"] = "Tier <VAR> Shelter",
	["tr"] = "<VAR> Seviye Sığınak",
	["ru"] = "Убежище <VAR>-го ур.",
	["zh-TW"] = "<VAR> 級避難所",
	["zh-CN"] = "<VAR> 级避难所",
})

ZShelter.AddTranslate("#ShelterPos", {
	["en"] = "Shelter Spawn Point",
	["tr"] = "Sığınak Canlanma Noktası",
	["ru"] = "Точка появления убежища",
	["zh-TW"] = "避難所生成點",
	["zh-CN"] = "避难所生成点",
})

ZShelter.AddTranslate("#ShelterDesc", {
	["en"] = "Position for shelter to spawn, require at least one to make the game playable",
	["tr"] = "Canlanmak için sığınak pozisyonu, oyunun oynanabilmesi için en az bir tane gerekli",
	["ru"] = "Размещение точки для появления убежища, требуется хотя бы одна для игры",
	["zh-TW"] = "避難所的生成點, 至少需要一個遊戲才可進行",
	["zh-CN"] = "至少需要有一个避难所生成点才可进行游玩",
})

ZShelter.AddTranslate("#BarricadePos", {
	["en"] = "Barricades",
	["tr"] = "Barikatlar",
	["ru"] = "Баррикады",
	["zh-TW"] = "障礙物",
	["zh-CN"] = "障碍物",
})

ZShelter.AddTranslate("#BarricadeDesc", {
	["en"] = "A big container used to block player's path",
	["tr"] = "Oyuncuyu engellemek için büyük bir konteyner",
	["ru"] = "Красный контейнер на пути, используется, чтобы преградить путь игроку",
	["zh-TW"] = "可以擋住玩家路線的紅色集裝箱",
	["zh-CN"] = "用于拦截玩家路线的红色集装箱",
})

ZShelter.AddTranslate("#TreasurePos", {
	["en"] = "Treasure Area",
	["tr"] = "Hazine Alanı",
	["ru"] = "Область сокровищ",
	["zh-TW"] = "資源集中區",
	["zh-CN"] = "资源集中区",
})

ZShelter.AddTranslate("#TreasureDesc", {
	["en"] = "Area that spawns a boss and alot of resources everyday",
	["tr"] = "Her gün patron oluşturan ve birçok kaynak üreten bir alan",
	["ru"] = "Область, в которой каждый день появляется босс и много ресурсов",
	["zh-TW"] = "每天生成Boss和較多資源的區域",
	["zh-CN"] = "一个资源较集中的区域, 每天会生成一个BOSS",
})

ZShelter.AddTranslate("#BonusPos", {
	["en"] = "Resource Bonus Area",
	["tr"] = "Kaynak Bonusu Alanı",
	["ru"] = "Область дополнительных ресурсов",
	["zh-TW"] = "獎勵資源區",
	["zh-CN"] = "奖励资源区",
})

ZShelter.AddTranslate("#BonusDesc", {
	["en"] = "An area that spawns extra resources without bosses",
	["tr"] = "Patron oluşturmadan fazladan kaynak üreten bir alan",
	["ru"] = "Область, в которой появляются дополнительные ресурсы без боссов",
	["zh-TW"] = "會生成較多資源的區域",
	["zh-CN"] = "会生成较多资源的区域",
})

ZShelter.AddTranslate("#FinishSettings", {
	["en"] = "Save map config",
	["tr"] = "Harita konfigürasyonunu kaydet",
	["ru"] = "Сохранить конфигурацию карты",
	["zh-TW"] = "保存地圖設定",
	["zh-CN"] = "保存地图设置",
})

ZShelter.AddTranslate("#UnsupportedMap1", {
	["en"] = "Unsupported Map!",
	["tr"] = "Desteklenmeyen Harita!",
	["ru"] = "Карта не поддерживается!",
	["zh-TW"] = "不支援的地圖!",
	["zh-CN"] = "不支持的地图!",
})

ZShelter.AddTranslate("#UnsupportedMapEditMode", {
	["en"] = "Press F3 to enter edit mode!",
	["tr"] = "Düzenleme moduna girmek için F3'e bas!",
	["ru"] = "Нажмите F3 для входа в режим редактора!",
	["zh-TW"] = "按下F3進入地圖編輯模式",
	["zh-CN"] = "按下F3进入地图编辑模式",
})

ZShelter.AddTranslate("#EditModeHint", {
	["en"] = "Press G to open settings menu",
	["tr"] = "Ayarlar menüsünü açmak için G'ye bas",
	["ru"] = "Нажмите G для открытия меню настроек",
	["zh-TW"] = "按下G打開設定選單",
	["zh-CN"] = "按下G打开设定菜单",
})

ZShelter.AddTranslate("#EditModeHintPlace", {
	["en"] = "Left Click - Continue | Right Click - Cancel | R - Rotate",
	["tr"] = "Sol Tık - Devam | Sağ Tık - İptal | R - Döndür",
	["ru"] = "ЛКМ - Продолжить | ПКМ - Отмена | [R] Вращать",
	["zh-TW"] = "左鍵 - 確認 | 右鍵 - 取消 | R - 旋轉",
	["zh-CN"] = "左键 - 确定 | 右键 - 取消 | R - 旋转",
})

ZShelter.AddTranslate("#EditModeHintAim", {
	["en"] = "Right Click - Remove",
	["tr"] = "Sağ Tık - Kaldır",
	["ru"] = "ПКМ - Удалить",
	["zh-TW"] = "右鍵 - 移除",
	["zh-CN"] = "右鍵 - 移除",
})

ZShelter.AddTranslate("#AvgFail", {
	["en"] = "Average fail on <VAR> difficulty",
	["tr"] = "<VAR> zorluğunda ortalama başarısızlık",
	["ru"] = "Ср. проигрышей на сложности «<VAR>»",
	["zh-TW"] = "在<VAR>難度上的平均失敗點",
	["zh-CN"] = "在<VAR>难度上的平均失败点",
})

ZShelter.AddTranslate("#TotalPlayed", {
	["en"] = "<VAR> Plays recorded",
	["tr"] = "Toplam Oynanma: <VAR>",
	["ru"] = "Записано игр: <VAR>",
	["zh-TW"] = "<VAR> 已記錄的遊玩紀錄",
	["zh-CN"] = "<VAR> 已记录的游玩记录",
})

ZShelter.AddTranslate("#TotalFailed", {
	["en"] = "<VAR> Failed",
	["tr"] = "<VAR> Başarısız Oldu",
	["ru"] = "из которых <VAR> проиграны",
	["zh-TW"] = "<VAR> 失敗",
	["zh-CN"] = "<VAR> 失败",
})

ZShelter.AddTranslate("#WinFailRatio", {
	["en"] = "Win/Fail Ratio : <VAR>",
	["tr"] = "Kazanma/Yenilgi Oranı: <VAR>",
	["ru"] = "Соотн. побед/поражений: <VAR>",
	["zh-TW"] = "勝利/失敗比例 : <VAR>",
	["zh-CN"] = "输赢比 : <VAR>",
})

ZShelter.AddTranslate("#OnlinePlayers", {
	["en"] = "Online Players : <VAR>",
	["tr"] = "Çevrim İçi Oyuncu: <VAR>",
	["ru"] = "Игроков в игре : <VAR>",
	["zh-TW"] = "在線玩家 : <VAR>",
	["zh-CN"] = "在线玩家 : <VAR>",
})

ZShelter.AddTranslate("#Fetching", {
	["en"] = "Fetching..",
	["tr"] = "Getiriliyor..",
	["ru"] = "Поиск..",
	["zh-TW"] = "載入中..",
	["zh-CN"] = "载入中..",
})

ZShelter.AddTranslate("#FindOtherPlayer", {
	["en"] = "Look for other players to play with!",
	["tr"] = "Oynamak için oyuncu ara!",
	["ru"] = "Найдите других игроков для игры!",
	["zh-TW"] = "尋找其他玩家一起進行遊戲!",
	["zh-CN"] = "寻找其他玩家一起游玩!",
})

ZShelter.AddTranslate("#NDay", {
	["en"] = "Day <VAR>",
	["tr"] = "Gün <VAR>",
	["ru"] = "День <VAR>",
	["zh-TW"] = "第<VAR>天",
	["zh-CN"] = "第<VAR>天",
})

ZShelter.AddTranslate("#ConnectionHint", {
	["en"] = "Connection might take a while, please be patient",
	["tr"] = "Bağlanmak biraz sürebilir, lütfen sabırlı olun",
	["ru"] = "Подключение может занять время, будьте терпеливы",
	["zh-TW"] = "連線需要一段時間, 請耐心等待",
	["zh-CN"] = "连接需要一些时间, 请耐心等候",
})

ZShelter.AddTranslate("#Updates", {
	["en"] = "Updates",
	["tr"] = "Güncellemeler",
	["ru"] = "Обновления",
	["zh-TW"] = "內容更新",
	["zh-CN"] = "内容更新",
})

ZShelter.AddTranslate("#Statistics", {
	["en"] = "Statistics",
	["tr"] = "İstatistik",
	["ru"] = "Статистика",
	["zh-TW"] = "統計",
	["zh-CN"] = "统计",
})

ZShelter.AddTranslate("#Looking2play", {
	["en"] = "Looking to play",
	["tr"] = "Oyun oynamak istiyor",
	["ru"] = "Поиск игры",
	["zh-TW"] = "尋找遊戲",
	["zh-CN"] = "寻找游戏",
})

ZShelter.AddTranslate("#LocalSv", {
	["en"] = "Local Server",
	["tr"] = "Yerel Sunucu",
	["ru"] = "Локальный сервер",
	["zh-TW"] = "本地端伺服器",
	["zh-CN"] = "本地服务器",
})

ZShelter.AddTranslate("#Summery", {
	["en"] = "Summary",
	["tr"] = "Özet",
	["ru"] = "Итоги",
	["zh-TW"] = "總結",
	["zh-CN"] = "总结",
})

ZShelter.AddTranslate("#MapVote", {
	["en"] = "Map Vote",
	["tr"] = "Harita Oylama",
	["ru"] = "Голосование за карту",
	["zh-TW"] = "地圖投票",
	["zh-CN"] = "地图投票",
})

ZShelter.AddTranslate("#Defeat", {
	["en"] = "Defeat!",
	["tr"] = "Mağlubiyet!",
	["ru"] = "Поражение!",
	["zh-TW"] = "失敗!",
	["zh-CN"] = "失败!",
})

ZShelter.AddTranslate("#ShelterDestroyed", {
	["en"] = "Shelter has been destroyed!",
	["tr"] = "Sığınak yok edildi!",
	["ru"] = "Убежище уничтожено!",
	["zh-TW"] = "避難所被摧毀了!",
	["zh-CN"] = "避难所被摧毁了!",
})

ZShelter.AddTranslate("#Victory", {
	["en"] = "Victory!",
	["tr"] = "Galibiyet!",
	["ru"] = "Победа!",
	["zh-TW"] = "勝利!",
	["zh-CN"] = "胜利!",
})

ZShelter.AddTranslate("#Survived30Day", {
	["en"] = "Successfully survived to day 30",
	["tr"] = "Başarıyla 30. güne kadar hayatta kalındı",
	["ru"] = "Удалось дожить до 30-го дня",
	["zh-TW"] = "成功生存到第30天",
	["zh-CN"] = "成功生存到第30天",
})

ZShelter.AddTranslate("#Survived15Day", {
	["en"] = "Successfully survived to day 15",
	["tr"] = "Başarıyla 15. güne kadar hayatta kalındı",
	["ru"] = "Удалось дожить до 15-го дня",
	["zh-TW"] = "成功生存到第15天",
	["zh-CN"] = "成功生存到第15天",
})

ZShelter.AddTranslate("#PTS", {
	["en"] = "<VAR> pts",
	["tr"] = "<VAR> puan",
	["ru"] = "<VAR> очк.",
	["zh-TW"] = "<VAR> 貢獻點",
	["zh-CN"] = "<VAR> 贡献点",
})

ZShelter.AddTranslate("#MVP", {
	["en"] = "[MVP] <VAR>",
	["tr"] = "[EDO] <VAR>",
	["ru"] = "[СЦИ] <VAR>",
	["zh-TW"] = "[MVP] <VAR>",
	["zh-CN"] = "[MVP] <VAR>",
})

ZShelter.AddTranslate("#ServerList", {
	["en"] = "Server List",
	["tr"] = "",
	["ru"] = "",
	["zh-TW"] = "伺服器列表",
	["zh-CN"] = "服务器列表",
})

ZShelter.AddTranslate("#ServerListHint", {
	["en"] = "Servers on this list are running Zombie Shelter v2",
	["tr"] = "",
	["ru"] = "",
	["zh-TW"] = "在此列表上的伺服器都在運行 Zombie Shelter v2",
	["zh-CN"] = "在此列表上的服务器都在运行 Zombie Shelter v2",
})

ZShelter.AddTranslate("#ServerListAddr", {
	["en"] = "Address : <VAR>",
	["tr"] = "",
	["ru"] = "",
	["zh-TW"] = "伺服器IP : <VAR>",
	["zh-CN"] = "服务器IP : <VAR>",
})

ZShelter.AddTranslate("#ServerListClick", {
	["en"] = "Click to join",
	["tr"] = "",
	["ru"] = "",
	["zh-TW"] = "點擊加入",
	["zh-CN"] = "点击加入",
})

ZShelter.AddTranslate("#SpawnPointExtra", {
	["en"] = "Enemy Spawn Point",
	["tr"] = "",
	["ru"] = "",
	["zh-TW"] = "敵人生成點",
	["zh-CN"] = "敌人生成点",
})

ZShelter.AddTranslate("#SpawnPointExtraDesc", {
	["en"] = "An extra spawn point for enemy to spawn",
	["tr"] = "",
	["ru"] = "",
	["zh-TW"] = "敵人重生點",
	["zh-CN"] = "敌人重生点",
})

ZShelter.AddTranslate("#SpawnPointDedicated", {
	["en"] = "Dedicated Enemy Spawn Point",
	["tr"] = "",
	["ru"] = "",
	["zh-TW"] = "固定敵人生成點",
	["zh-CN"] = "固定敌人生成点",
})

ZShelter.AddTranslate("#SpawnPointDedicatedDesc", {
	["en"] = "An DEDICATED spawn point, if you placed any of this enemy will be spawn at this fixed position",
	["tr"] = "",
	["ru"] = "",
	["zh-TW"] = "放置後敵人會被生成在這個固定的位置",
	["zh-CN"] = "放置后敌人会被生成在这个固定的位置",
})

local TemporaryUnsupportedLanguage = {

}

-- Bruh someone ran the formatted on this

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