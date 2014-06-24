if myHero.charName ~= "Janna" then return end

local version = "0.01"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL-Releases/master/Big Fat Janna's Assistant.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Big Fat Janna's Assistant.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#64f879\">Big Fat Janna's Assistant:</font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL-Releases/master/versions/Big Fat Janna's Assistant.version")
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

local	SpellsTOInterrupt_Anticaplose = {}
local	SpellsDBInterrupt_Anticaplose = 
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
	-- Anticapcloser
	{charName = "Aatrox", spellName = "AatroxQ", endposcast = true, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "Corki", spellName = "CarpetBomb", endposcast = false, useult = "no", cap = 1, spellSlot = "W"},
	{charName = "Diana", spellName = "DianaTeleport", endposcast = true, useult = "no", cap = 1, spellSlot = "R"},
	{charName = "LeeSin", spellName = "blindmonkqtwo", endposcast = false, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "JarvanIV", spellName = "JarvanIVDragonStrike", endposcast = false, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "Fiora", spellName = "FioraQ", endposcast = true, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "Leblanc", spellName = "LeblancSlide", endposcast = true, useult = "no", cap = 1, spellSlot = "W"},
	{charName = "Leblanc", spellName = "leblacslidereturn", endposcast = true, useult = "no", cap = 1, spellSlot = "W"},
	{charName = "Fizz", spellName = "FizzPiercingStrike", endposcast = true, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "Gragas", spellName = "GragasE", endposcast = false, useult = "no", cap = 1, spellSlot = "E"},
	{charName = "Irelia", spellName = "IreliaGatotsu", endposcast = true, useult = "no", cap = 1, spellSlot = "Q"},
	{charName = "Jax", spellName = "JaxLeapStrike", endposcast = false, useult = "no", cap = 1, spellSlot = "Q"},
    {charName = "Khazix", spellName = "KhazixE", endposcast = false, useult = "no", cap = 1, spellSlot = "E"},
    {charName = "Khazix", spellName = "khazixelong", endposcast = false, useult = "no", cap = 1, spellSlot = "E"},
	{charName = "Braum", spellName = "BraumW", endposcast = true, useult = "no", cap = 1, spellSlot = "W"},
	{charName = "Thresh", spellName = "threshqleap", endposcast = false, useult = "no", cap = 1, spellSlot = "Q 2"},
    {charName = "Ahri", spellName = "AhriTumble", endposcast = true, useult = "no", cap = 1, spellSlot = "R"},
    {charName = "Kassadin", spellName = "RiftWalk", endposcast = true, useult = "no", cap = 1, spellSlot = "R"},
    {charName = "Tristana", spellName = "RocketJump", endposcast = true, useult = "no", cap = 1, spellSlot = "W"},
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

	{charName = "Ashe", spellName = "Volley", description = "W", important = 0},
	{charName = "Caitlyn", spellName = "CaitlynPiltoverPeacemaker", description = "Q", important = 0},
	{charName = "Caitlyn", spellName = "CaitlynAceintheHole", description = "R", important = 2},
	{charName = "Corki", spellName = "PhosphorusBomb", description = "Q", important = 0},
	{charName = "Corki", spellName = "GGun", description = "E", important = 0},
	{charName = "Corki", spellName = "MissileBarrage", description = "R", important = 2},
	{charName = "Draven", spellName = "DravenSpinning", description = "Q", important = 0},
	{charName = "Draven", spellName = "DravenDoubleShot", description = "E", important = 1},
	{charName = "Draven", spellName = "DravenRCast", description = "R", important = 2},
	{charName = "Ezreal", spellName = "EzrealMysticShot", description = "Q", important = 0},
	{charName = "Ezreal", spellName = "EzrealTrueshotBarrage", description = "R", important = 2},
	{charName = "Graves", spellName = "GravesClusterShot", description = "Q", important = 0},
	{charName = "Graves", spellName = "GravesChargeShot", description = "R", important = 2},
	{charName = "Jinx", spellName = "JinxW", description = "W", important = 0},
	{charName = "Jinx", spellName = "JinxRWrapper", description = "R", important = 2},
	{charName = "KogMaw", spellName = "KogMawLivingArtillery", description = "R", important = 2},
	{charName = "Lucian", spellName = "LucianQ", description = "Q", important = 1},
	{charName = "Lucian", spellName = "LucianW", description = "W", important = 0},
	{charName = "Lucian", spellName = "LucianR", description = "R", important = 2},
	{charName = "MissFortune", spellName = "MissFortuneRicochetShot", description = "Q", important = 2},
	{charName = "MissFortune", spellName = "MissFortuneBulletTime", description = "R", important = 1},
	{charName = "Quinn", spellName = "QuinnQ", description = "Q", important = 0},
	{charName = "Quinn", spellName = "QuinnE", description = "E", important = 1},
	{charName = "Sivir", spellName = "SivirQ", description = "Q", important = 0},
	{charName = "Sivir", spellName = "SivirW", description = "W", important = 1},
	{charName = "Tristana", spellName = "RapidFire", description = "Q", important = 1},
	{charName = "Twitch", spellName = "Expunge", description = "E", important = 2},
	{charName = "Twitch", spellName = "FullAutomatic", description = "R", important = 2}, -- new ult name ???
	{charName = "Urgot", spellName = "UrgotHeatseekingMissile", description = "Q", important = 0},
	{charName = "Urgot", spellName = "UrgotPlasmaGrenade", description = "E", important = 0},
	{charName = "Varus", spellName = "VarusQ", description = "Q", important = 1},
	{charName = "Varus", spellName = "VarusE", description = "E", important = 1},
	{charName = "Vayne", spellName = "VayneTumble", description = "Q", important = 1},
	{charName = "Vayne", spellName = "VayneCondemn", description = "E", important = 0},
	{charName = "Vayne", spellName = "VayneInquisition", description = "R", important = 2},
	{charName = "LeeSin", spellName = "BlindMonkRKick", description = "R", important = 2},
	{charName = "Nasus", spellName = "NasusQ", description = "Q", important = 2},
	{charName = "Nocturne", spellName = "NocturneParanoia", description = "R", important = 2},
	{charName = "Shaco", spellName = "TwoShivPoison", description = "E", important = 1},
	{charName = "Trundle", spellName = "TrundleTrollSmash", description = "Q", important = 1},
	{charName = "Vi", spellName = "ViE", description = "E", important = 1},
	{charName = "XinZhao", spellName = "XenZhaoComboTarget", description = "Q", important = 1},
	{charName = "Khazix", spellName = "KhazixQ", description = "Q", important = 1},
	{charName = "Khazix", spellName = "KhazixW", description = "W", important = 1},
	{charName = "MasterYi", spellName = "AlphaStrike", description = "Q", important = 0},
	{charName = "MasterYi", spellName = "WujuStyle", description = "E", important = 1},
	{charName = "Talon", spellName = "TalonNoxianDiplomacy", description = "Q", important = 0},
	{charName = "Talon", spellName = "TalonShadowAssault", description = "R", important = 2},
	{charName = "Pantheon", spellName = "PantheonQ", description = "Q", important = 1}, -- mby wrong name
	{charName = "Yasuo", spellName = "YasuoQW", description = "Q", important = 1}, 
	{charName = "Zed", spellName = "ZedShuriken", description = "Q", important = 1}, -- mby wrong name
	{charName = "Zed", spellName = "ZedPBAOEDummy", description = "E", important = 0}, -- mby wrong name
	{charName = "Aatrox", spellName = "AatroxW", description = "W", important = 0},
	{charName = "Darius", spellName = "DariusExecute", description = "R", important = 2},
	{charName = "Gangplank", spellName = "Parley", description = "Q", important = 0},
	{charName = "Garen", spellName = "GarenQ", description = "Q", important = 1},
	{charName = "Garen", spellName = "GarenE", description = "E", important = 0},
	{charName = "Jayce", spellName = "JayceToTheSkies", description = "Q", important = 1},
	{charName = "Jayce", spellName = "jayceshockblast", description = "2 Q", important = 1},
	{charName = "Renekton", spellName = "RenektonCleave", description = "Q", important = 1},
	{charName = "Renekton", spellName = "RenektonPreExecute", description = "W", important = 1},
	{charName = "Renekton", spellName = "RenektonSliceAndDice", description = "E", important = 1},
	{charName = "Rengar", spellName = "RengarQ", description = "Q", important = 1},
	{charName = "Rengar", spellName = "RengarE", description = "E", important = 1},
	{charName = "Rengar", spellName = "RengarR", description = "R", important = 2},
	{charName = "Riven", spellName = "RivenFengShuiEngine", description = "R", important = 2},
	{charName = "Tryndamere", spellName = "UndyingRage", description = "R", important = 2},
	{charName = "MonkeyKing", spellName = "MonkeyKingDoubleAttack", description = "Q", important = 1},
	{charName = "MonkeyKing", spellName = "MonkeyKingNimbus", description = "E", important = 1},
	{charName = "MonkeyKing", spellName = "MonkeyKingSpinToWin", description = "R", important = 2}


}

function OnLoad()

	require "Prodiction"
	Prod = ProdictManager.GetInstance()
	ProdQmin = Prod:AddProdictionObject(_Q, QRangeMin, QSpeed, QDelay, QWidth) 

	JannaMenu = scriptConfig("Big Fat Janna's Assistant", "Big Fat Janna's Assistant")

	JannaMenu:addSubMenu("[Prodiction Settings]", "ProdictionSettings")
	JannaMenu.ProdictionSettings:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
	
	JannaMenu:addSubMenu("[KS Options]", "KSOptions")
	JannaMenu.KSOptions:addParam("KSwithW","KS with W", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.KSOptions:addParam("KSwithQ","KS with Q", SCRIPT_PARAM_ONOFF, true)
	
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
	
	JannaMenu.Draws:addParam("UselowfpsDraws","Use low fps Draws", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.Draws:addParam("DrawQRange","Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.Draws:addParam("DrawWRange","Draw W Range", SCRIPT_PARAM_ONOFF, false)
	
	
	JannaMenu:addSubMenu("[Boost Allies Dmg Output]", "BoostAlliesDmgOutput")
	
	JannaMenu:addSubMenu("[Interrupter]", "Int")
	JannaMenu.Int:addParam("interrupterdebug","Interrupter Debug", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.Int:addParam("info", " ", SCRIPT_PARAM_INFO, "")
	
	JannaMenu:addSubMenu("[Anticapcloser]", "Anticapcloser")
	JannaMenu.Anticapcloser:addParam("Anticapcloserdebug","Anticapcloser Debug", SCRIPT_PARAM_ONOFF, true)
	JannaMenu.Anticapcloser:addParam("info", " ", SCRIPT_PARAM_INFO, "")
	
	--JannaMenu:addParam("debugmode","debugmode", SCRIPT_PARAM_ONOFF, false)
	JannaMenu:addParam("info", " ", SCRIPT_PARAM_INFO, "")
	JannaMenu:addParam("evadee","Evadee Intergration", SCRIPT_PARAM_ONOFF, true)
	JannaMenu:addParam("combo","Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	JannaMenu:addParam("harassw","Harass W", SCRIPT_PARAM_ONKEYDOWN, false, 88)
	JannaMenu:addParam("castq","Spam Q Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, 65)


	-- interrupter + anticap
	for i, enemy in ipairs(GetEnemyHeroes()) do
		for _, champ in pairs(SpellsDBInterrupt_Anticaplose) do
			if enemy.charName == champ.charName then
			table.insert(SpellsTOInterrupt_Anticaplose, {charName = champ.charName, spellSlot = champ.spellSlot, spellName = champ.spellName, useult = champ.useult, cap = champ.cap, spellType = champ.spellType, endposcast = champ.endposcast})
			end
		end
	end

	if #SpellsTOInterrupt_Anticaplose > 0 then
		for _, Inter in pairs(SpellsTOInterrupt_Anticaplose) do
				if Inter.cap == 0 then
				JannaMenu.Int:addParam(Inter.spellName, ""..Inter.charName.. " | " ..Inter.spellSlot.. " - " ..Inter.spellName, SCRIPT_PARAM_ONOFF, true)
				if Inter.useult == "no" then
				JannaMenu.Int:addParam(Inter.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, false)
				elseif Inter.useult == "yes" then
				JannaMenu.Int:addParam(Inter.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, true)
				end
				JannaMenu.Int:addParam("info", " ", SCRIPT_PARAM_INFO, "")
				
				elseif Inter.cap == 1 then
				JannaMenu.Anticapcloser:addParam(Inter.spellName, ""..Inter.charName.. " | " ..Inter.spellSlot.. " - " ..Inter.spellName, SCRIPT_PARAM_ONOFF, true)
				if Inter.useult == "no" then
				JannaMenu.Anticapcloser:addParam(Inter.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, false)
				elseif Inter.useult == "yes" then
				JannaMenu.Anticapcloser:addParam(Inter.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, true)
				end
				JannaMenu.Anticapcloser:addParam("info", " ", SCRIPT_PARAM_INFO, "")
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
		end

	end	
	--
	
	
	
	ts = TargetSelector(TARGET_LESS_CAST, 1400, true)
	ts.name = "JannaMenu"
    JannaMenu:addTS(ts)
	
	if JannaMenu.Show.showcombo then
	JannaMenu:permaShow("combo")
	end	
	if JannaMenu.Show.showspamq then
	JannaMenu:permaShow("castq")
	end
	

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
	Target = ts.target
	
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
		
	if ValidTarget(Target) then
	ProdQmin:GetPredictionCallBack(Target, GetQPos)
	else
	qPos = nil
	end
		
	if JannaMenu.castq and ValidTarget(Target) and not myHero.dead then
	ProdQmin:GetPredictionCallBack(Target, CastQ)
	end
	
	
	if JannaMenu.combo and ValidTarget(Target) and not myHero.dead then
	ProdQmin:GetPredictionCallBack(Target, CastQ)
	CastW()
	end	
	
	if JannaMenu.harassw and ValidTarget(Target) and not myHero.dead then
	CastW()
	end		
	
	if JannaMenu.KSOptions.KSwithW and WReady and not myHero.dead then	
	KSW()
	end 	
	if JannaMenu.KSOptions.KSwithQ and QReady and not myHero.dead then	
	KSQ()
	end 

if JannaMenu.evadee then
	if _G.Evadeee_impossibleToEvade and EReady and not myHero.dead then
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


function OnProcessSpell(unit, spell)

		if #SpellsTOInterrupt_Anticaplose > 0 then
			for _, Inter in pairs(SpellsTOInterrupt_Anticaplose) do
				if spell.name == Inter.spellName and unit.team ~= myHero.team then
				-- interupter
					if JannaMenu.Int[Inter.spellName] and QReady and ValidTarget(unit, QRangeMin) then
					if JannaMenu.Int.interrupterdebug then PrintChat("Tried to interrupt with Q: " ..Inter.charName.. " | " ..Inter.spellSlot.. " - " ..Inter.spellName) end
						if JannaMenu.ProdictionSettings.UsePacketsCast then
						Packet("S_CAST", {spellId = _Q, fromX =  unit.x, fromY =  unit.z, toX =  unit.x, toY =  unit.z}):send()
							if JannaMenu.debugmode then
							PrintChat("casted packets using interrupter")
							end
						else
						CastSpell(_Q, unit.x, unit.z)
						if JannaMenu.debugmode then
                        PrintChat("casted normal using interrupter")
						end
						
						end

					elseif JannaMenu.Int[Inter.spellName..2] and JannaMenu.Int[Inter.spellName] and not QReady and RReady and ValidTarget(unit, RRange) then
					if JannaMenu.Int.interrupterdebug then PrintChat("Tried to interrupt with R: " ..Inter.charName.. " | " ..Inter.spellSlot.. " - " ..Inter.spellName) end
						CastSpell(_R)
						
					end 	
					-- capcloser
					if JannaMenu.Anticapcloser[Inter.spellName] and QReady and ValidTarget(unit, QRangeMin) then
					if JannaMenu.Anticapcloser.Anticapcloserdebug then PrintChat("Anticapcloser: "  ..Inter.charName.. " | " ..Inter.spellSlot.. " - " ..Inter.spellName) end
					
						if Inter.endposcast == true then
							if JannaMenu.ProdictionSettings.UsePacketsCast then

							Packet("S_CAST", {spellId = _Q, fromX =  spell.endPos.x, fromY = spell.endPos.z, toX =  spell.endPos.x, toY = spell.endPos.z}):send()

							if JannaMenu.debugmode then
							PrintChat("casted packets using Anticapcloser endpos")
							end
							else
							CastSpell(_Q, endPos.x, spell.endPos.z)
							if JannaMenu.debugmode then
							PrintChat("casted normal using Anticapcloser endpos")
							end
							end
						elseif Inter.endposcast == false then
							if JannaMenu.ProdictionSettings.UsePacketsCast then

							Packet("S_CAST", {spellId = _Q, fromX = spell.startPos.x, fromY = spell.startPos.z, toX = spell.startPos.x, toY = spell.startPos.z}):send()

							if JannaMenu.debugmode then
							PrintChat("casted packets using Anticapcloser startPos")
							end
							else
							CastSpell(_Q, spell.startPos.x, spell.startPos.z)
							if JannaMenu.debugmode then
							PrintChat("casted normal using Anticapcloser startPos")
							end
							
							end
						end
						end


					elseif JannaMenu.Anticapcloser[Inter.spellName..2] and JannaMenu.Anticapcloser[Inter.spellName] and not QReady and RReady and ValidTarget(unit, RRange) then
					if JannaMenu.Anticapcloser.Anticapcloserdebug then PrintChat("Anticapcloser with R: " ..Inter.charName.. " | " ..Inter.spellSlot.. " - " ..Inter.spellName) end
						CastSpell(_R)
						
					end 
					--
					

				end
			end
			
			if #SpellsToShild > 0 then
			for _, Boost in pairs(SpellsToShild) do
				if spell.name == Boost.spellName and unit.team == myHero.team then
					if JannaMenu.BoostAlliesDmgOutput[Boost.spellName] and EReady and (GetDistance(unit) < ERange) then
							CastSpell(_E, unit)
					end
				end
			end
			end
			
		end



local function getHitBoxRadius(target)
		return GetDistance(target, target.minBBox)
end

function GetQPos(unit, pos)
	qPos = pos
end


function CastQ(unit,pos)

	if QReady and (GetDistance(pos) - getHitBoxRadius(unit)/2 < QRangeMin) then 
				if JannaMenu.ProdictionSettings.UsePacketsCast then
					Packet("S_CAST", {spellId = _Q, fromX =  pos.x, fromY =  pos.z, toX =  pos.x, toY =  pos.z}):send()
					if JannaMenu.debugmode then
                        PrintChat("casted packets CastQMin")
					end
				else
					CastSpell(_Q, pos.x, pos.z)
					if JannaMenu.debugmode then
                        PrintChat("casted normal CastQMin")
					end
				end
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

--


function OnDraw()

	if JannaMenu.Draws.UselowfpsDraws then
		if QReady and JannaMenu.Draws.DrawQRange and not myHero.dead then
		DrawCircleQ(myHero.x, myHero.y, myHero.z, QRangeMin, ARGB(JannaMenu.Draws.QSettings.colorAA[1],JannaMenu.Draws.QSettings.colorAA[2],JannaMenu.Draws.QSettings.colorAA[3],JannaMenu.Draws.QSettings.colorAA[4]))
		end	
		if WReady and JannaMenu.Draws.DrawWRange and not myHero.dead then
		DrawCircleW(myHero.x, myHero.y, myHero.z, WRange, ARGB(JannaMenu.Draws.WSettings.colorAA[1],JannaMenu.Draws.WSettings.colorAA[2],JannaMenu.Draws.WSettings.colorAA[3],JannaMenu.Draws.WSettings.colorAA[4]))
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



function OnGainBuff(unit, buff)
        if unit == nil or buff == nil then return end
        if unit.isMe and buff then
		if JannaMenu.debugmode then
                PrintChat("GAINED: " .. buff.name)
		end
if buff.name == "HowlingGale" then
if JannaMenu.debugmode then
                        PrintChat("TRUE")
end
                        onHowlingGale = true
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
end 
