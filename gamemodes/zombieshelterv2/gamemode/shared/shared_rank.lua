ZShelter.RankLevel = 5

local math_floor = math.floor
function ZShelter.CalculateRankEXP(rank, level)
	local lv = 1 + level
	local exp = (100 * (level ^ (level * 0.35))) + ((1 + (rank * 0.1)) * (50 ^ (1 + (lv * 0.05))))
	return math_floor(exp)
end

function ZShelter.CalculateRank(exp)
	local st = SysTime()
	local currentLevel = 0
	local currentRank = 0
	local targetLevel = 0
	local targetRank = 1
	local exp_requirement = ZShelter.CalculateRankEXP(targetRank, targetLevel)
	local breaklooptime = SysTime() + 1
	while(exp > exp_requirement && breaklooptime > SysTime()) do
		exp_requirement = ZShelter.CalculateRankEXP(targetRank, targetLevel)
		if(exp > exp_requirement) then
			exp = exp - exp_requirement
			currentRank = currentRank + 1
			targetRank = targetRank + 1
			if(currentRank > 5 && currentLevel < 10) then
				currentRank = 0
				currentLevel = currentLevel + 1
			end
			if(targetRank > 5 && currentLevel < 10) then
				targetRank = 0
				targetLevel = targetLevel + 1
			end
		else
			break
		end
	end
	return currentRank, currentLevel, exp, exp_requirement
end

ZShelter.LevelColors = {
	[0] = Color(255, 255, 255),
	[1] = Color(50, 230, 77),
	[2] = Color(50, 230, 227),
	[3] = Color(50, 59, 230),
	[4] = Color(215, 230, 50),
	[5] = Color(230, 143, 50),
	[6] = Color(230, 71, 50),
	[7] = Color(255, 0, 0),
	[8] = Color(230, 50, 119),
	[9] = Color(143, 50, 230),
	[10] = Color(0, 0, 0),
}
function ZShelter.GetLevelColor(level)
	return ZShelter.LevelColors[math.Clamp(level, 0, 10)]
end

ZShelter.LevelTitles = {
	[0] = "Beginner",
	[1] = "Rookie",
	[2] = "Novice",
	[3] = "Apprentice",
	[4] = "Adept",
	[5] = "Skilled",
	[6] = "Expert",
	[7] = "Specialist",
	[8] = "Elite",
	[9] = "Veteran",
	[10] = "Master",
}
function ZShelter.GetLevelTitle(level)
	return ZShelter.LevelTitles[math.Clamp(level, 0, 10)]
end