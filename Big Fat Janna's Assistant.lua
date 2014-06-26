if myHero.charName ~= "Janna" then return end
	
local version = "0.05"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL-Releases/master/Big Fat Janna's Assistant.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Big Fat Janna's Assistant.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#64f879\">Big Fat Janna's Assistant:</font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL-Releases/master/versions/Big Fat Janna's Assistant1.version")
if ServerData then
ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
if ServerVersion then
if tonumber(version) < ServerVersion then
AutoupdaterMsg("New version available"..ServerVersion)
AutoupdaterMsg("Updating, please don't press F9")
DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
else
AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
end
end
else
AutoupdaterMsg("Error downloading version info")
end
end

local QRangeMin, QSpeed, QDelay, QWidth = 1025, 910, 0, 200 
local RRange = 700
local WRange = 600
local ERange = 800
local onHowlingGale = false 
local secondqcheck = false

ComboKey = 32
LastHitKey = string.byte("X")
LaneClearKey = string.byte("V")

--[MMA & SAC Information]--
local starttick = 0
local checkedMMASAC = false
local is_MMA = false
local is_REVAMP = false
local is_REBORN = false
local is_SAC = false
local itsme = false


local	SpellsTOInterrupt_Antigaplose = {}
local	SpellsDBInterrupt_Antigaplose = 
{
	-- Interrupter
	{charName = "FiddleSticks", spellName = "Drain", endposcast = false, useult = "no", cap = 0, spellSlot = "W"},
	{charName = "FiddleSticks", spellName = "Crowstorm", endposcast = false, useult = "yes", cap = 0, spellSlot = "R"},
    {charName = "MissFortune", spellName = "MissFortuneBulletTime", endposcast = false, useult = "yes", cap = 0, spellSlot = "R"},
	{charName = "Caitlyn", spellName = "CaitlynAceintheHole", endposcast = false, useult = "no", cap = 0, spellSlot = "R"},
    {charName = "Katarina", spellName = "KatarinaR", endposcast = false, useult = "yes", cap = 0, spellSlot = "R"},
	{charName = "Karthus", spellName = "FallenOne", endposcast = false, useult = "yes", cap = 0, spellSlot = "R"},
	{charName = "Malzahar", spellName = "AlZaharNetherGrasp", endposcast = false, useult = "yes", cap = 0, spellSlot = "R"},
	{charName = "Galio", spellName = "GalioIdolOfDurand", endposcast = false, useult = "yes", cap = 0, spellSlot = "R"},
	{charName = "Lucian", spellName = "LucianR", endposcast = false, useult = "no", cap = 0, spellSlot = "R"},	
	{charName = "Shen",  spellName = "ShenStandUnited", endposcast = false, useult = "no", cap = 0, spellSlot = "R"},
	{charName = "Urgot",  spellName = "UrgotSwap2", endposcast = false, useult = "no", cap = 0, spellSlot = "R"},
	{charName = "Pantheon",  spellName = "PantheonRJump", endposcast = false, useult = "no", cap = 0, spellSlot = "R"},
	{charName = "Warwick",  spellName = "InfiniteDuress", endposcast = false, useult = "yes", cap = 0, spellSlot = "R"},
	{charName = "Xerath",  spellName = "XerathLocusOfPower2", endposcast = false, useult = "yes", cap = 0, spellSlot = "R"},
	{charName = "Velkoz",  spellName = "VelkozR", endposcast = false, useult = "no", cap = 0, spellSlot = "R"},
	{charName = "Zac",  spellName = "ZacE", endposcast = false, useult = "no", cap = 0, spellSlot = "E"},
	{charName = "Twitch",  spellName = "HideInShadows", endposcast = false, useult = "no", cap = 0, spellSlot = "Q"},
	{charName = "Xerath",  spellName = "XerathArcanopulseChargeUp", endposcast = false, useult = "no", cap = 0, spellSlot = "Q"},
	-- Antigaploser
	{charName = "Aatrox", spellName = "AatroxQ", endposcast = true, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "Corki", spellName = "CarpetBomb", endposcast = false, useult = "no", cap = 1, spellSlot = "W"},
	{charName = "Diana", spellName = "DianaTeleport", endposcast = true, useult = "no", cap = 1, spellSlot = "R"},
	{charName = "LeeSin", spellName = "blindmonkqtwo", endposcast = false, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "Shaco",  spellName = "Deceive", endposcast = true, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "JarvanIV", spellName = "JarvanIVDragonStrike", endposcast = false, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "Fiora", spellName = "FioraQ", endposcast = true, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "Leblanc", spellName = "LeblancSlide", endposcast = true, useult = "no", cap = 1, spellSlot = "W"},
	{charName = "Leblanc", spellName = "leblacslidereturn", endposcast = true, useult = "no", cap = 1, spellSlot = "W"},
	{charName = "Fizz", spellName = "FizzPiercingStrike", endposcast = true, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "Amumu", spellName = "BandageToss", endposcast = false, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "Gragas", spellName = "GragasE", endposcast = false, useult = "no", cap = 1, spellSlot = "E"},
	{charName = "Irelia", spellName = "IreliaGatotsu", endposcast = true, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "Jax", spellName = "JaxLeapStrike", endposcast = false, useult = "no", cap = 1, spellSlot = "Q"},
    {charName = "Khazix", spellName = "KhazixE", endposcast = false, useult = "no", cap = 1, spellSlot = "E"},
    {charName = "Khazix", spellName = "khazixelong", endposcast = false, useult = "no", cap = 1, spellSlot = "E"},
	{charName = "Braum", spellName = "BraumW", endposcast = true, useult = "no", cap = 1, spellSlot = "W"},
	{charName = "Thresh", spellName = "threshqleap", endposcast = false, useult = "no", cap = 1, spellSlot = "Q 2"},
    {charName = "Ahri", spellName = "AhriTumble", endposcast = true, useult = "no", cap = 1, spellSlot = "R"},
    {charName = "Kassadin", spellName = "RiftWalk", endposcast = true, useult = "no", cap = 1, spellSlot = "R"},
    {charName = "Tristana", spellName = "RocketJump", endposcast = false, useult = "no", cap = 1, spellSlot = "W"},
	{charName = "Akali", spellName = "AkaliShadowDance", endposcast = true, useult = "no", cap = 1, spellSlot = "R"},
	{charName = "Caitlyn", spellName = "CaitlynEntrapment", endposcast = false, useult = "no", cap = 1, spellSlot = "E"},
	{charName = "Pantheon",  spellName = "PantheonW", endposcast = true, useult = "no", cap = 1, spellSlot = "W"},
	{charName = "Quinn",  spellName = "QuinnE", endposcast = false, useult = "no", cap = 1, spellSlot = "E"},
	{charName = "Renekton",  spellName = "RenektonSliceAndDice", endposcast = true, useult = "no", cap = 1, spellSlot = "E"},
	{charName = "Sejuani",  spellName = "SejuaniArcticAssault", endposcast = false, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "Shyvana",  spellName = "ShyvanaTransformCast", endposcast = false, useult = "no", cap = 1, spellSlot = "R"},
	{charName = "Tryndamere",  spellName = "slashCast", endposcast = true, useult = "no", cap = 1, spellSlot = "E"},
	{charName = "Vi",  spellName = "ViQ", endposcast = false, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "XinZhao",  spellName = "XenZhaoSweep", endposcast = true, useult = "no", cap = 1, spellSlot = "E"},
	{charName = "Yasuo",  spellName = "YasuoDashWrapper", endposcast = true, useult = "no", cap = 1, spellSlot = "E"},
	{charName = "Leona", spellName = "LeonaZenithBlade", endposcast = false, useult = "no", cap = 1, spellSlot = "E"}

	}
	
	
local SpellsToShild = {}
local ShildSpellsDB = {

	{charName = "Ashe", spellName = "Volley", description = "W", important = 1},
	{charName = "Caitlyn", spellName = "CaitlynPiltoverPeacemaker", description = "Q", important = 1},
	{charName = "Caitlyn", spellName = "CaitlynAceintheHole", description = "R", important = 3},
	{charName = "Corki", spellName = "PhosphorusBomb", description = "Q", important = 1},
	{charName = "Corki", spellName = "GGun", description = "E", important = 1},
	{charName = "Corki", spellName = "MissileBarrage", description = "R", important = 3},
	{charName = "Draven", spellName = "DravenSpinning", description = "Q", important = 1},
	{charName = "Draven", spellName = "DravenDoubleShot", description = "E", important = 2},
	{charName = "Draven", spellName = "DravenRCast", description = "R", important = 3},
	{charName = "Ezreal", spellName = "EzrealMysticShot", description = "Q", important = 1},
	{charName = "Ezreal", spellName = "EzrealTrueshotBarrage", description = "R", important = 3},
	{charName = "Graves", spellName = "GravesClusterShot", description = "Q", important = 1},
	{charName = "Graves", spellName = "GravesChargeShot", description = "R", important = 3},
	{charName = "Jinx", spellName = "JinxW", description = "W", important = 2},
	{charName = "Jinx", spellName = "JinxRWrapper", description = "R", important = 3},
	{charName = "KogMaw", spellName = "KogMawLivingArtillery", description = "R", important = 3},
	{charName = "Lucian", spellName = "LucianQ", description = "Q", important = 2},
	{charName = "Lucian", spellName = "LucianW", description = "W", important = 1},
	{charName = "Lucian", spellName = "LucianR", description = "R", important = 3},
	{charName = "MissFortune", spellName = "MissFortuneRicochetShot", description = "Q", important = 2},
	{charName = "MissFortune", spellName = "MissFortuneBulletTime", description = "R", important = 3},
	{charName = "Quinn", spellName = "QuinnQ", description = "Q", important = 1},
	{charName = "Quinn", spellName = "QuinnE", description = "E", important = 3},
	{charName = "Sivir", spellName = "SivirQ", description = "Q", important = 2},
--	{charName = "Sivir", spellName = "SivirW", description = "W", important = 2},
	{charName = "Tristana", spellName = "RapidFire", description = "Q", important = 1},
	{charName = "Twitch", spellName = "Expunge", description = "E", important = 3},
--	{charName = "Twitch", spellName = "FullAutomatic", description = "R", important = 3}, -- new ult name ???
	{charName = "Urgot", spellName = "UrgotHeatseekingMissile", description = "Q", important = 2},
	{charName = "Urgot", spellName = "UrgotPlasmaGrenade", description = "E", important = 1},
	{charName = "Varus", spellName = "VarusQ", description = "Q", important = 3},
	{charName = "Varus", spellName = "VarusE", description = "E", important = 1},
	{charName = "Vayne", spellName = "VayneTumble", description = "Q", important = 2},
	{charName = "Vayne", spellName = "VayneCondemn", description = "E", important = 1},
	{charName = "Vayne", spellName = "VayneInquisition", description = "R", important = 3},
	{charName = "LeeSin", spellName = "BlindMonkRKick", description = "R", important = 3},
	{charName = "Nasus", spellName = "NasusQ", description = "Q", important = 2},
	{charName = "Nocturne", spellName = "NocturneParanoia", description = "R", important = 3},
	{charName = "Shaco", spellName = "TwoShivPoison", description = "E", important = 2},
	{charName = "Trundle", spellName = "TrundleTrollSmash", description = "Q", important = 2},
	{charName = "Vi", spellName = "ViE", description = "E", important = 2},
	{charName = "XinZhao", spellName = "XenZhaoComboTarget", description = "Q", important = 2},
	{charName = "Khazix", spellName = "KhazixQ", description = "Q", important = 2},
	{charName = "Khazix", spellName = "KhazixW", description = "W", important = 2},
	{charName = "MasterYi", spellName = "AlphaStrike", description = "Q", important = 1},
	{charName = "MasterYi", spellName = "WujuStyle", description = "E", important = 1},
	{charName = "Talon", spellName = "TalonNoxianDiplomacy", description = "Q", important = 1},
	{charName = "Talon", spellName = "TalonShadowAssault", description = "R", important = 3},
	{charName = "Pantheon", spellName = "PantheonQ", description = "Q", important = 2}, -- mby wrong name
	{charName = "Yasuo", spellName = "YasuoQW", description = "Q", important = 2}, 
	{charName = "Zed", spellName = "ZedShuriken", description = "Q", important = 1}, -- mby wrong name
	{charName = "Zed", spellName = "ZedPBAOEDummy", description = "E", important = 2}, -- mby wrong name
	{charName = "Aatrox", spellName = "AatroxW", description = "W", important = 2},
	{charName = "Darius", spellName = "DariusExecute", description = "R", important = 3},
	{charName = "Gangplank", spellName = "Parley", description = "Q", important = 1},
	{charName = "Garen", spellName = "GarenQ", description = "Q", important = 1},
	{charName = "Garen", spellName = "GarenE", description = "E", important = 2},
	{charName = "Jayce", spellName = "JayceToTheSkies", description = "Q", important = 2},
	{charName = "Jayce", spellName = "jayceshockblast", description = "2 Q", important = 2},
	{charName = "Renekton", spellName = "RenektonCleave", description = "Q", important = 2},
	{charName = "Renekton", spellName = "RenektonPreExecute", description = "W", important = 2},
	{charName = "Renekton", spellName = "RenektonSliceAndDice", description = "E", important = 2},
	{charName = "Rengar", spellName = "RengarQ", description = "Q", important = 2},
	{charName = "Rengar", spellName = "RengarE", description = "E", important = 1},
	{charName = "Rengar", spellName = "RengarR", description = "R", important = 3},
	{charName = "Riven", spellName = "RivenFengShuiEngine", description = "R", important = 3},
	{charName = "Tryndamere", spellName = "UndyingRage", description = "R", important = 3},
	{charName = "MonkeyKing", spellName = "MonkeyKingDoubleAttack", description = "Q", important = 1},
	{charName = "MonkeyKing", spellName = "MonkeyKingNimbus", description = "E", important = 2},
	{charName = "MonkeyKing", spellName = "MonkeyKingSpinToWin", description = "R", important = 3}


}


function OnLoad()

	require "Prodiction"
	require 'VPrediction'
	require 'SOW'
	
	
	VPred = VPrediction()
	iSOW = SOW(VPred)

	JannaMenu = scriptConfig("Big Fat Janna's Assistant", "Big Fat Janna's Assistant")
	
	ts = TargetSelector(TARGET_LESS_CAST, 1400, true)
	ts.name = "JannaMenu"
    JannaMenu:addTS(ts)

	JannaMenu:addSubMenu("[Prodiction Settings]", "ProdictionSettings")
	JannaMenu.ProdictionSettings:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
	
	JannaMenu:addSubMenu("[KS Options]", "KSOptions")
	JannaMenu.KSOptions:addParam("KSwithW","KS with W", SCRIPT_PARAM_ONOFF, true)
	--JannaMenu.KSOptions:addParam("KSwithQ","KS with Q", SCRIPT_PARAM_ONOFF, true)
	
	JannaMenu:addSubMenu("[Show in Game]", "Show")
	JannaMenu.Show:addParam("info", "~=[ New Settings will be saved after Reload ]=~", SCRIPT_PARAM_INFO, "")
	JannaMenu.Show:addParam("showcombo","Combo Key", SCRIPT_PARAM_ONOFF, false)
	JannaMenu.Show:addParam("showspamq","Spam Q Toggle", SCRIPT_PARAM_ONOFF, true)
	
	JannaMenu:addSubMenu("[Draws]", "Draws")
	JannaMenu.Draws:addSubMenu("[Q Settings]", "QSettings")
	JannaMenu.Draws.QSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	JannaMenu.Draws.QSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	JannaMenu.Draws.QSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
	JannaMenu.Draws:addSubMenu("[W Settings]", "WSettings")
	JannaMenu.Draws.WSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	JannaMenu.Draws.WSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	JannaMenu.Draws.WSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
	JannaMenu.Draws:addSubMenu("[E Settings]", "ESettings")
	JannaMenu.Draws.ESettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	JannaMenu.Draws.ESettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	JannaMenu.Draws.ESettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
	JannaMenu.Draws:addSubMenu("[R Settings]", "RSettings")
	JannaMenu.Draws.RSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	JannaMenu.Draws.RSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	JannaMenu.Draws.RSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
	JannaMenu.Draws:addParam("UselowfpsDraws","Use low fps Draws", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.Draws:addParam("DrawQRange","Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.Draws:addParam("DrawWRange","Draw W Range", SCRIPT_PARAM_ONOFF, false)
	JannaMenu.Draws:addParam("DrawERange","Draw E Range", SCRIPT_PARAM_ONOFF, false)
	JannaMenu.Draws:addParam("DrawRRange","Draw R Range", SCRIPT_PARAM_ONOFF, false)
	


	JannaMenu:addSubMenu("[Boost Allies Dmg Output]", "BoostAlliesDmgOutput")
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team and teammate.charName == "Caitlyn" then
				JannaMenu.BoostAlliesDmgOutput:addParam("CaitPassive","Caitlyn | Passive Headshot", SCRIPT_PARAM_ONOFF, true)
				JannaMenu.BoostAlliesDmgOutput:addParam("CaitPlevel","Mana Priority level", SCRIPT_PARAM_SLICE, 1, 1, 3)
				JannaMenu.BoostAlliesDmgOutput:addParam("info", " ", SCRIPT_PARAM_INFO, "")
			end
		end
	
	JannaMenu:addSubMenu("[Interrupter]", "Int")
	JannaMenu.Int:addParam("interrupterdebug","Interrupter Debug", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.Int:addParam("info", " ", SCRIPT_PARAM_INFO, "")
	
	JannaMenu:addSubMenu("[Antigaploser]", "Antigaploser")
	JannaMenu.Antigaploser:addParam("Antigaploserdebug","Antigaploser Debug", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.Antigaploser:addParam("info", " ", SCRIPT_PARAM_INFO, "")
		
	JannaMenu:addSubMenu("[Shild Towers]", "ShildTowers")
	JannaMenu.ShildTowers:addParam("STiae","Shild Towers if enemys get attacked", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.ShildTowers:addParam("OnlyifhaveArdentCenser","Only if have Ardent Censer", SCRIPT_PARAM_ONOFF, false)
	JannaMenu.ShildTowers:addParam("info", "~=[ Will cast only if not lower: ]=~", SCRIPT_PARAM_INFO, "")
	JannaMenu.ShildTowers:addParam("minhp", "My minimal Life %",   SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
	JannaMenu.ShildTowers:addParam("minmana", "My minimal Mana %",   SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
	JannaMenu:addSubMenu("[Mana Settings]", "ManaSettings")
	JannaMenu.ManaSettings:addParam("info", "~=[ Minimum Mana till skills used ]=~", SCRIPT_PARAM_INFO, "")
	JannaMenu.ManaSettings:addParam("info", "~=[ Boost Allies Dmg Output ]=~", SCRIPT_PARAM_INFO, "")
	JannaMenu.ManaSettings:addParam("Prioritylvl1", "Mana Priority lvl 1",   SCRIPT_PARAM_SLICE, 45, 0, 100, 0)
	JannaMenu.ManaSettings:addParam("Prioritylvl2", "Mana Priority lvl 2",   SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
	JannaMenu.ManaSettings:addParam("Prioritylvl3", "Mana Priority lvl 3",   SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
	JannaMenu.ManaSettings:addParam("info", "~=[ Harass ]=~", SCRIPT_PARAM_INFO, "")
	JannaMenu.ManaSettings:addParam("HarassMana", "Min Mana",   SCRIPT_PARAM_SLICE, 60, 0, 100, 0)
	--JannaMenu:addParam("debugmode","debugmode", SCRIPT_PARAM_ONOFF, false)
	JannaMenu:addParam("info", " ", SCRIPT_PARAM_INFO, "")

	JannaMenu:addParam("evadee","Evadeee Intergration", SCRIPT_PARAM_ONOFF, true)
	
	JannaMenu:addParam("AlwaysDoubleQ","Always Double Q", SCRIPT_PARAM_ONOFF, false)
	JannaMenu:addParam("combo","Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	JannaMenu:addParam("harassw","Harass W", SCRIPT_PARAM_ONKEYDOWN, false, 88)
	JannaMenu:addParam("castq","Spam Q Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, 65)

	-- interrupter + anticap
	for i, enemy in ipairs(GetEnemyHeroes()) do
		for _, champ in pairs(SpellsDBInterrupt_Antigaplose) do
			if enemy.charName == champ.charName then
			table.insert(SpellsTOInterrupt_Antigaplose, {charName = champ.charName, spellSlot = champ.spellSlot, spellName = champ.spellName, useult = champ.useult, cap = champ.cap, spellType = champ.spellType, endposcast = champ.endposcast})
			end
		end
	end

	if #SpellsTOInterrupt_Antigaplose > 0 then
		for _, Inter in pairs(SpellsTOInterrupt_Antigaplose) do
				if Inter.cap == 0 then
				JannaMenu.Int:addParam(Inter.spellName, ""..Inter.charName.. " | " ..Inter.spellSlot.. " - " ..Inter.spellName, SCRIPT_PARAM_ONOFF, true)
				if Inter.useult == "no" then
				JannaMenu.Int:addParam(Inter.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, false)
				elseif Inter.useult == "yes" then
				JannaMenu.Int:addParam(Inter.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, true)
				end
				JannaMenu.Int:addParam("info", " ", SCRIPT_PARAM_INFO, "")
				
				elseif Inter.cap == 1 then
				JannaMenu.Antigaploser:addParam(Inter.spellName, ""..Inter.charName.. " | " ..Inter.spellSlot.. " - " ..Inter.spellName, SCRIPT_PARAM_ONOFF, true)
				if Inter.useult == "no" then
				JannaMenu.Antigaploser:addParam(Inter.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, false)
				elseif Inter.useult == "yes" then
				JannaMenu.Antigaploser:addParam(Inter.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, true)
				end
				JannaMenu.Antigaploser:addParam("info", " ", SCRIPT_PARAM_INFO, "")
				end
		end

	end		
	--
	--Boost Allies Dmg

	for i, ally in ipairs(GetAllyHeroes()) do
		for _, champ in pairs(ShildSpellsDB) do
			if ally.charName == champ.charName then
			table.insert(SpellsToShild, {charName = champ.charName, spellName = champ.spellName, description = champ.description, important = champ.important})
			end
		end
	end

	if #SpellsToShild > 0 then
		for _, Boost in pairs(SpellsToShild) do
		JannaMenu.BoostAlliesDmgOutput:addParam(Boost.spellName, ""..Boost.charName.. " | " ..Boost.description.. " - " ..Boost.spellName, SCRIPT_PARAM_ONOFF, true)
		JannaMenu.BoostAlliesDmgOutput:addParam(Boost.spellName..0, "Mana Priority level", SCRIPT_PARAM_SLICE, Boost.important, 1, 3)
		JannaMenu.BoostAlliesDmgOutput:addParam("info", " ", SCRIPT_PARAM_INFO, "")
		end 
	end	
	--

	if JannaMenu.Show.showcombo then
	JannaMenu:permaShow("combo")
	end	
	if JannaMenu.Show.showspamq then
	JannaMenu:permaShow("castq")
	end
	
	JannaMenu:addSubMenu("[Orbwalker]", "Orbwalk")
	JannaMenu.Orbwalk:addParam("standartts", "Use Standart TargetSelector", SCRIPT_PARAM_ONOFF, true)

	
	PrintChat("<font color='#c9d7ff'> Big Fat Janna's Assistant </font><font color='#64f879'> v. "..version.." </font><font color='#c9d7ff'> by Big Fat Nidalee, loaded! </font>")
end


function OnTick()

	if onHowlingGale == true and not myHero.dead then
		if JannaMenu.ProdictionSettings.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q}):send()
			if JannaMenu.debugmode then
            PrintChat("casted packets onHowlingGale")
			end
		else
			CastSpell(_Q)
			if JannaMenu.debugmode then
			PrintChat("casted normal onHowlingGale")
			end
		end
	end

	ts:update()
	
	orbwalkcheck()
	target = ts.target
	Target = getTarget()
	
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	ArdentC = GetInventorySlotItem(3504)
	ArdentCReady = (ArdentC ~= nil)


	if JannaMenu.castq and ValidTarget(Target) and myHero.mana >= ManaCost(Q) and not myHero.dead then
	CastQ()
	end
	
	if JannaMenu.combo and ValidTarget(Target) and not myHero.dead then
		if myHero.mana >= ManaCost(WQ) then
		CastQ()
		CastW()
		elseif myHero.mana <= ManaCost(WQ) then
		CastQ()
		end
	end	
	
	if JannaMenu.harassw and ValidTarget(Target) and not myHero.dead and not mymanaislowerthen(JannaMenu.ManaSettings.HarassMana) then
	CastW()
	end		
	
	if JannaMenu.KSOptions.KSwithW and WReady and myHero.mana >= ManaCost(W) and not myHero.dead then	
	KSW()
	end 
	
	--if JannaMenu.KSOptions.KSwithQ and QReady and myHero.mana >= ManaCost(Q) and not myHero.dead then	
	--KSQ()
	--end 

	if JannaMenu.evadee then
	if _G.Evadeee_impossibleToEvade and EReady and myHero.mana >= ManaCost(E) and not myHero.dead then
	CastSpell(_E)
	end
	end

end 

function KSW()

	for _, enemy in pairs(GetEnemyHeroes()) do
		if enemy and not enemy.dead and enemy.health < getDmg("W", enemy, myHero) then
		if GetDistance(enemy) <= WRange then
			if JannaMenu.ProdictionSettings.UsePacketsCast then
				Packet("S_CAST", {spellId = _W, targetNetworkId = enemy.networkID}):send()
			else
				CastSpell(_W, enemy)
			end
	 end
			return true
		end
	end
	
	return false
	
end
--[[
function KSQ()

	for _, enemy in pairs(GetEnemyHeroes()) do
		if enemy and not enemy.dead and enemy.health < getDmg("Q", enemy, myHero) then
		if GetDistance(enemy) <= QRangeMin then
			if JannaMenu.ProdictionSettings.UsePacketsCast then
				Packet("S_CAST", {spellId = _Q, fromX =  enemy.x, fromY =  enemy.z, toX =  enemy.x, toY =  enemy.z}):send()
			else
				CastSpell(_Q, enemy.x, enemy.z)
			end
	 end
			return true
		end
	end
	
	return false
	
end
]]--

function OnProcessSpell(unit, spell)

		if #SpellsTOInterrupt_Antigaplose > 0 then
			for _, Inter in pairs(SpellsTOInterrupt_Antigaplose) do
				if spell.name == Inter.spellName and not myHero.dead and unit.team ~= myHero.team then
				
				-- interupter

					
					if JannaMenu.Int[Inter.spellName] and QReady and myHero.mana >= ManaCost(Q) and ValidTarget(unit, QRangeMin) then
					if JannaMenu.Int.interrupterdebug then PrintChat("Tried to interrupt with Q: " ..Inter.charName.. " | " ..Inter.spellSlot.. " - " ..Inter.spellName) end
					
						if JannaMenu.ProdictionSettings.UsePacketsCast then
						Packet("S_CAST", {spellId = _Q, fromX =  unit.x, fromY =  unit.z, toX =  unit.x, toY =  unit.z}):send()
							if QReady then secondqcheck = true elseif not QReady then secondqcheck = false
							end
							if JannaMenu.debugmode then
							PrintChat("casted packets using interrupter")
							end
						else
						CastSpell(_Q, unit.x, unit.z)
							if QReady then secondqcheck = true elseif not QReady then secondqcheck = false
							end
						if JannaMenu.debugmode then
                        PrintChat("casted normal using interrupter")
						end
						
						end

					elseif JannaMenu.Int[Inter.spellName..2] and JannaMenu.Int[Inter.spellName] and not QReady and myHero.mana >= ManaCost(R) and RReady and ValidTarget(unit, RRange) then
					if JannaMenu.Int.interrupterdebug then PrintChat("Tried to interrupt with R: " ..Inter.charName.. " | " ..Inter.spellSlot.. " - " ..Inter.spellName) end
						CastSpell(_R)
						
					end 
					
					-- capcloser
					if JannaMenu.Antigaploser[Inter.spellName] and QReady and myHero.mana >= ManaCost(Q) and ValidTarget(unit, QRangeMin) then
					if JannaMenu.Antigaploser.Antigaploserdebug then PrintChat("Antigaploser: "  ..Inter.charName.. " | " ..Inter.spellSlot.. " - " ..Inter.spellName) end
					
						if Inter.endposcast == true then
							if JannaMenu.ProdictionSettings.UsePacketsCast then

							Packet("S_CAST", {spellId = _Q, fromX =  spell.endPos.x, fromY = spell.endPos.z, toX =  spell.endPos.x, toY = spell.endPos.z}):send()
							if QReady then secondqcheck = true elseif not QReady then secondqcheck = false
							end
							
							if JannaMenu.debugmode then
							PrintChat("casted packets using Antigaploser endpos")
							end
							else
							CastSpell(_Q, endPos.x, spell.endPos.z)
							if QReady then secondqcheck = true elseif not QReady then secondqcheck = false
							end
							
							if JannaMenu.debugmode then
							PrintChat("casted normal using Antigaploser endpos")
							end
							end
						elseif Inter.endposcast == false then
							if JannaMenu.ProdictionSettings.UsePacketsCast then

							Packet("S_CAST", {spellId = _Q, fromX = spell.startPos.x, fromY = spell.startPos.z, toX = spell.startPos.x, toY = spell.startPos.z}):send()
							if QReady then secondqcheck = true elseif not QReady then secondqcheck = false
							end

							if JannaMenu.debugmode then
							PrintChat("casted packets using Antigaploser startPos")
							end
							else
							CastSpell(_Q, spell.startPos.x, spell.startPos.z)
							if QReady then secondqcheck = true elseif not QReady then secondqcheck = false
							end
							
							if JannaMenu.debugmode then
							PrintChat("casted normal using Antigaploser startPos")
							end
							
							end
							
						end
						end
				

					elseif JannaMenu.Antigaploser[Inter.spellName..2] and JannaMenu.Antigaploser[Inter.spellName] and not QReady and myHero.mana >= ManaCost(R) and RReady and ValidTarget(unit, RRange) then
					if JannaMenu.Antigaploser.Antigaploserdebug then PrintChat("Antigaploser with R: " ..Inter.charName.. " | " ..Inter.spellSlot.. " - " ..Inter.spellName) end
						CastSpell(_R)
						
					end
					
				if spell.name == Inter.spellName and not QReady then 
				secondqcheck = false
				elseif not spell.name == Inter.spellName then 
				secondqcheck = false
				end
					
			end
		end
	--	secondqcheck = false		
			if #SpellsToShild > 0 then
			for _, Boost in pairs(SpellsToShild) do
				if spell.name == Boost.spellName and not myHero.dead and unit.team == myHero.team then
					if JannaMenu.BoostAlliesDmgOutput[Boost.spellName] and EReady and myHero.mana >= ManaCost(E) and (GetDistance(unit) < ERange) then
						if JannaMenu.BoostAlliesDmgOutput[Boost.spellName..0] == 1 and not mymanaislowerthen(JannaMenu.ManaSettings.Prioritylvl1) then 
							if JannaMenu.ProdictionSettings.UsePacketsCast then
							Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
							else
							CastSpell(_E, unit)
							end
						elseif JannaMenu.BoostAlliesDmgOutput[Boost.spellName..0] == 2 and not mymanaislowerthen(JannaMenu.ManaSettings.Prioritylvl2) then 
							if JannaMenu.ProdictionSettings.UsePacketsCast then
							Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
							else
							CastSpell(_E, unit)
							end
						elseif JannaMenu.BoostAlliesDmgOutput[Boost.spellName..0] == 3 and not mymanaislowerthen(JannaMenu.ManaSettings.Prioritylvl3) then 
							if JannaMenu.ProdictionSettings.UsePacketsCast then
							Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
							else
							CastSpell(_E, unit)
							end
						end
					end
				end
			end
			end
			
	if JannaMenu.ShildTowers.STiae and not myHero.dead then
        if (spell.name:find("ChaosTurret") and myHero.team == TEAM_RED) or (spell.name:find("OrderTurret") and myHero.team == TEAM_BLUE) then

		for i=1, heroManager.iCount do
            local enemy = heroManager:GetHero(i)
            if ValidTarget(enemy) then
                if JannaMenu.ShildTowers.OnlyifhaveArdentCenser and ArdentCReady and GetDistance(spell.endPos, enemy)<80 and GetDistance(unit) <= ERange and not mymanaislowerthen(JannaMenu.ShildTowers.minmana) and not myhpislowerthen(JannaMenu.ShildTowers.minhp) and myHero.mana >= ManaCost(E) and EReady then
					if JannaMenu.ProdictionSettings.UsePacketsCast then
					Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
					else
					CastSpell(_E, unit)
					end
				elseif not JannaMenu.ShildTowers.OnlyifhaveArdentCenser and GetDistance(spell.endPos, enemy)<80 and GetDistance(unit) <= ERange and not mymanaislowerthen(JannaMenu.ShildTowers.minmana) and not myhpislowerthen(JannaMenu.ShildTowers.minhp) and myHero.mana >= ManaCost(E) and EReady then
					if JannaMenu.ProdictionSettings.UsePacketsCast then
					Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
					else
					CastSpell(_E, unit)
					end
				end
            end
        end  
		
		end
	end
	


end



function OnGainBuff(unit, buff)

    if unit == nil or buff == nil then return end
    if unit.isMe and buff then
		if JannaMenu.debugmode then
		PrintChat("GAINED: " .. buff.name)
		end
		if not JannaMenu.AlwaysDoubleQ then
			if buff.name == "HowlingGale" and not myHero.dead and secondqcheck == true then
				if JannaMenu.debugmode then
				PrintChat("TRUE")
				end
			onHowlingGale = true
			end
		elseif JannaMenu.AlwaysDoubleQ then
			if buff.name == "HowlingGale" and not myHero.dead then
				if JannaMenu.debugmode then
				PrintChat("TRUE")
				end
			onHowlingGale = true
			end
		end 
	end


	if buff.name == "caitlynheadshot" and unit.team == myHero.team then
	caitlynheadshot = true
	end 
	
	if caitlynheadshot == true and JannaMenu.BoostAlliesDmgOutput.CaitPassive and EReady and myHero.mana >= ManaCost(E) and (GetDistance(unit) < ERange) and unit.team == myHero.team and not myHero.dead then
		if JannaMenu.BoostAlliesDmgOutput.CaitPlevel == 1 and not mymanaislowerthen(JannaMenu.ManaSettings.Prioritylvl1) then 
			if JannaMenu.ProdictionSettings.UsePacketsCast then
			Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
			else
			CastSpell(_E, unit)
			end
		elseif JannaMenu.BoostAlliesDmgOutput.CaitPlevel == 2 and not mymanaislowerthen(JannaMenu.ManaSettings.Prioritylvl2) then 
			if JannaMenu.ProdictionSettings.UsePacketsCast then
			Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
			else
			CastSpell(_E, unit)
			end
		elseif JannaMenu.BoostAlliesDmgOutput.CaitPlevel == 3 and not mymanaislowerthen(JannaMenu.ManaSettings.Prioritylvl3) then 
			if JannaMenu.ProdictionSettings.UsePacketsCast then
			Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
			else
			CastSpell(_E, unit)
			end
		end
	end 
end

function OnLoseBuff(unit, buff)
    if unit == nil or buff == nil then return end
    if unit.isMe and buff then
		if JannaMenu.debugmode then
        PrintChat("LOST: " .. buff.name)
		end
        if buff.name == "HowlingGale" then
        onHowlingGale = false
        end
    end
		
	if buff.name == "caitlynheadshot" and unit.team == myHero.team then
	caitlynheadshot = false
	end  
end 

function CastQ()

	if QReady and not myHero.dead and GetDistance(Target) <= QRangeMin then
	local qpos, qinfo = Prodiction.GetPrediction(Target, QRangeMin, QSpeed, QDelay, QWidth, myPlayer)
			
		if qpos and qinfo.hitchance >= 2 then
		secondqcheck = true	
			if JannaMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end 
		secondqcheck = false		
	end 
	
end

function CastW()

	if WReady and GetDistance(Target) <= WRange then 
		if JannaMenu.debugmode then
        PrintChat("casted normal W sbtw")
		end
		if JannaMenu.ProdictionSettings.UsePacketsCast then
		Packet("S_CAST", {spellId = _W, targetNetworkId = Target.networkID}):send()
		else
		CastSpell(_W, Target)
		end
					
	end
end 


-----------------------------------------------------------------------------------------------
	--JannaMenu:addSubMenu("[Orbwalker]", "Orbwalk")
	--iSOW:LoadToMenu(JannaMenu.Orbwalk)
function orbwalkcheck()
	if checkedMMASAC then return end
	if not (starttick + 5000 < GetTickCount()) then return end
	checkedMMASAC = true
    if _G.MMA_Loaded then
     	print(' >>Big Fat Jannas Assistant: MMA found. MMA support loaded.')
		is_MMA = true
	end	
	if _G.AutoCarry then
		print(' >>Big Fat Jannas Assistant: SAC found. SAC support loaded.')
		is_SAC = true
	end	
	if is_MMA then
		JannaMenu.Orbwalk:addSubMenu("Marksman's Mighty Assistant", "mma")
		JannaMenu.Orbwalk.mma:addParam("mmastatus", "Use MMA Target Selector", SCRIPT_PARAM_ONOFF, false)			
	end
	if is_SAC then
		JannaMenu.Orbwalk:addSubMenu("Sida's Auto Carry", "sac")
		JannaMenu.Orbwalk.sac:addParam("sacstatus", "Use SAC Target Selector", SCRIPT_PARAM_ONOFF, false)
	end
	if not is_SAC then
		JannaMenu.Orbwalk:addParam("line", "----------------------------------------------------", SCRIPT_PARAM_INFO, "")
		JannaMenu.Orbwalk:addParam("line", "", SCRIPT_PARAM_INFO, "")
		iSOW:LoadToMenu(JannaMenu.Orbwalk)
	end
end

function getTarget()
	if not checkedMMASAC then return end
	if is_MMA and is_SAC then
		if JannaMen.JannaMenu.Orbwalk.mma.mmastatus then
			JannaMenu.Orbwalk.sac.sacstatus = false
			JannaMenu.Orbwalk.standartts = false
		elseif JannaMenu.Orbwalk.sac.sacstatus then
			JannaMenu.Orbwalk.mma.mmastatus = false
			JannaMenu.Orbwalk.standartts = false
		elseif	JannaMenu.Orbwalk.standartts then
			JannaMenu.Orbwalk.mma.mmastatus = false
			JannaMenu.Orbwalk.sac.sacstatus = false
		end
	end	
	if not is_MMA and is_SAC then
		if JannaMenu.Orbwalk.sac.sacstatus then
			JannaMenu.Orbwalk.standartts = false
		else
			JannaMenu.Orbwalk.standartts = true
		end	
	end
	if is_MMA and not is_SAC then
		if JannaMenu.Orbwalk.mma.mmastatus then
			JannaMenu.Orbwalk.standartts = false
		else
			JannaMenu.Orbwalk.standartts = true
		end	
	end
	if not is_MMA and not is_SAC then
		JannaMenu.Orbwalk.standartts = true	
	end	
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then
		return _G.MMA_Target 
	end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then
		return _G.AutoCarry.Attack_Crosshair.target		
	end
    return ts.target	
end

-----------------------------------------------------------------------------------------------

function mymanaislowerthen(percent)
    if myHero.mana < (myHero.maxMana * ( percent / 100)) then
    return true
    else
    return false
    end
end

function myhpislowerthen(percent)
    if myHero.health < (myHero.maxHealth * ( percent / 100)) then
    return true
    else
    return false
    end
end

function ManaCost(spell)
	if spell == Q then
	return 75 + (15 * myHero:GetSpellData(_Q).level)
	elseif spell == W then
	return 30 + (10 * myHero:GetSpellData(_W).level)
	elseif spell == E then
	return 60 + (10 * myHero:GetSpellData(_E).level)
	elseif spell == R then
	return 100
	elseif spell == WQ then
	return 30 + (10 * myHero:GetSpellData(_W).level) + 75 + (15 * myHero:GetSpellData(_Q).level)
	end 
end			


function OnDraw()

	if JannaMenu.Draws.UselowfpsDraws then
		if QReady and JannaMenu.Draws.DrawQRange and not myHero.dead then
		DrawCircleQ(myHero.x, myHero.y, myHero.z, QRangeMin, ARGB(JannaMenu.Draws.QSettings.colorAA[1],JannaMenu.Draws.QSettings.colorAA[2],JannaMenu.Draws.QSettings.colorAA[3],JannaMenu.Draws.QSettings.colorAA[4]))
		end	
		if WReady and JannaMenu.Draws.DrawWRange and not myHero.dead then
		DrawCircleW(myHero.x, myHero.y, myHero.z, WRange, ARGB(JannaMenu.Draws.WSettings.colorAA[1],JannaMenu.Draws.WSettings.colorAA[2],JannaMenu.Draws.WSettings.colorAA[3],JannaMenu.Draws.WSettings.colorAA[4]))
		end		
		if EReady and JannaMenu.Draws.DrawERange and not myHero.dead then
		DrawCircleE(myHero.x, myHero.y, myHero.z, ERange, ARGB(JannaMenu.Draws.ESettings.colorAA[1],JannaMenu.Draws.ESettings.colorAA[2],JannaMenu.Draws.ESettings.colorAA[3],JannaMenu.Draws.ESettings.colorAA[4]))
		end		
		if RReady and JannaMenu.Draws.DrawRRange and not myHero.dead then
		DrawCircleR(myHero.x, myHero.y, myHero.z, RRange, ARGB(JannaMenu.Draws.RSettings.colorAA[1],JannaMenu.Draws.RSettings.colorAA[2],JannaMenu.Draws.RSettings.colorAA[3],JannaMenu.Draws.RSettings.colorAA[4]))
		end	
	end
	
	if not JannaMenu.Draws.UselowfpsDraws then
	if QReady then 
		if JannaMenu.Draws.DrawQRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRangeMin, 0xb9c3ed)
		end	
	end
	if WReady then 
		if JannaMenu.Draws.DrawWRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0xb9c3ed)
		end
	end
	if EReady then 
		if JannaMenu.Draws.DrawWRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0xb9c3ed)
		end
	end
	if RReady then 
		if JannaMenu.Draws.DrawWRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xb9c3ed)
		end
	end
	end
	

end 



--Q Range Circle QUality
function DrawCircleNextLvlQ(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(JannaMenu.Draws.QSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end


--Q Range Circle Width
function DrawCircleQ(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlQ(x, y, z, radius, JannaMenu.Draws.QSettings.width, color, 75)	
	end
end 	

--W Range Circle QUality
function DrawCircleNextLvlW(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(JannaMenu.Draws.WSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end


--W Range Circle Width
function DrawCircleW(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlW(x, y, z, radius, JannaMenu.Draws.WSettings.width, color, 75)	
	end
end 	
	

--E Range Circle QUality
function DrawCircleNextLvlE(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(JannaMenu.Draws.ESettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end


--E Range Circle Width
function DrawCircleE(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlW(x, y, z, radius, JannaMenu.Draws.ESettings.width, color, 75)	
	end
end 	
	

--R Range Circle QUality
function DrawCircleNextLvlR(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(JannaMenu.Draws.RSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end


--R Range Circle Width
function DrawCircleR(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlW(x, y, z, radius, JannaMenu.Draws.RSettings.width, color, 75)	
	end
end 	

