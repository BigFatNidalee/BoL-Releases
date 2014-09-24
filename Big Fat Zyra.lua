if myHero.charName ~= "Zyra" then return end

local version = "1.3"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL-Releases/master/Big Fat Zyra.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Big Fat Zyra.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#66cc00\">Big Fat Zyra.lua:</font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL-Releases/master/versions/Big Fat Zyra.version")
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

local QReady, WReady, EReady, RReady = false, false, false, false
local AARange = 640
local QRange, QSpeed, QDelay, QWidth, QWidth2 = 800, 1400, 0.5, 100, 150
local WRange, WSpeed, WDelay, WWidth = 840, math.huge, 0.2432, 10
--local ERange, ESpeed, EDelay, EWidth = 1000, 1100, 0.23, 40
local ERange, ESpeed, EDelay, EWidth = 1000, 1400, 0.5, 40
local RRange, RSpeed, RDelay, RRadius = 700, math.huge, 0.500, 500
local PRange, PSpeed, PDelay, PWidth = 1470, 1870, 0.500, 60

local Seed1 = false
local Seed2 = false
local seedtime = {}
local processes = {}
local qcasting = false
local farming = false

--[MMA & SAC Information]--
local starttick = 0
local checkedMMASAC = false
local is_MMA = false
local is_REVAMP = false
local is_REBORN = false
local is_SAC = false
local itsme = false


--- BoL Script Status Connector --- 
local ScriptKey = "VILHPKHIHKP" -- replace by auth key for each script

-- Thanks to Bilbao for his socket help & encryption
assert(load(Base64Decode("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"), nil, "bt", _ENV))() BolBoost( ScriptKey, "" )
-----------------------------------


function OnLoad()
	get_tables()
	require "Prodiction"
	get_hooks()
	require 'VPrediction'
	require 'SOW'
	
	
	VPred = VPrediction()
	iSOW = SOW(VPred)

	
	ZyraMenu = scriptConfig("Big Fat Zyra", "Big Fat Zyra")
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, PRange, DAMAGE_MAGIC)
	ts.name = "ZyraMenu"
	ZyraMenu:addTS(ts)
	
	ZyraMenu:addSubMenu("[Prodiction Settings]", "ProdictionSettings")
	ZyraMenu.ProdictionSettings:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.ProdictionSettings:addParam("blank", "", SCRIPT_PARAM_INFO, "")
	ZyraMenu.ProdictionSettings:addParam("QHitchance", "Q Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
	ZyraMenu.ProdictionSettings:addParam("EHitchance", "E Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
	ZyraMenu.ProdictionSettings:addParam("RHitchance", "R Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
	ZyraMenu.ProdictionSettings:addParam("PHitchance", "Passive Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
	ZyraMenu.ProdictionSettings:addParam("blank", "", SCRIPT_PARAM_INFO, "")
	ZyraMenu.ProdictionSettings:addParam("info1", "HITCHANCE:", SCRIPT_PARAM_INFO, "")
	ZyraMenu.ProdictionSettings:addParam("info2", "LOW = 1  NORMAL = 2  HIGH = 3", SCRIPT_PARAM_INFO, "")
	

	ZyraMenu:addSubMenu("[Draws]", "Draws")
	ZyraMenu.Draws:addSubMenu("[AA Settings]", "AASettings")
	ZyraMenu.Draws.AASettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	ZyraMenu.Draws.AASettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	ZyraMenu.Draws.AASettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
	ZyraMenu.Draws:addSubMenu("[Q Settings]", "QSettings")
	ZyraMenu.Draws.QSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	ZyraMenu.Draws.QSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	ZyraMenu.Draws.QSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
	ZyraMenu.Draws:addSubMenu("[W Settings]", "WSettings")
	ZyraMenu.Draws.WSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	ZyraMenu.Draws.WSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	ZyraMenu.Draws.WSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
	ZyraMenu.Draws:addSubMenu("[E Settings]", "ESettings")
	ZyraMenu.Draws.ESettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	ZyraMenu.Draws.ESettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	ZyraMenu.Draws.ESettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
	ZyraMenu.Draws:addSubMenu("[R Settings]", "RSettings")
	ZyraMenu.Draws.RSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	ZyraMenu.Draws.RSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	ZyraMenu.Draws.RSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
	ZyraMenu.Draws:addSubMenu("[Passive Settings]", "PSettings")
	ZyraMenu.Draws.PSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	ZyraMenu.Draws.PSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	ZyraMenu.Draws.PSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
	ZyraMenu.Draws:addSubMenu("[WQ2Mouse Settings]", "WQ2MouseSettings")
	ZyraMenu.Draws.WQ2MouseSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	ZyraMenu.Draws.WQ2MouseSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	ZyraMenu.Draws.WQ2MouseSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
	ZyraMenu.Draws:addParam("UselowfpsDraws","Use low fps Draws", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Draws:addParam("DrawAARange","Draw AA Range", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Draws:addParam("DrawQRange","Draw Q Range", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu.Draws:addParam("DrawWRange","Draw W Range", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu.Draws:addParam("DrawERange","Draw E Range", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu.Draws:addParam("DrawRRange","Draw R Range", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu.Draws:addParam("DrawPRange","Draw Passive Range", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Draws:addParam("blank", " - Extra - ", SCRIPT_PARAM_INFO, "")
	ZyraMenu.Draws:addParam("DrawWQ","Draw WQ to mouse pos", SCRIPT_PARAM_ONOFF, false)

	
	ZyraMenu:addSubMenu("[Antigapcloser]", "Antigapcloser")
	ZyraMenu.Antigapcloser:addParam("ComfortRange", "Comfort Range", SCRIPT_PARAM_SLICE, 650, 0, 900, 0)
	ZyraMenu.Antigapcloser:addParam("DrawComfort","Draw me Comfort Range for better Setup", SCRIPT_PARAM_ONOFF, false)
	ZyraMenu.Antigapcloser:addParam("Debug","Debug Mode", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Antigapcloser:addParam("blank", " ", SCRIPT_PARAM_INFO, "")

	
	if prodictiondonator == true then
	ZyraMenu:addSubMenu("[Ultimate]", "Ultimate")
	ZyraMenu.Ultimate:addParam("UseAutoUlt","Use Auto Ult", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Ultimate:addParam("UltGroupMinimum", "Ult Enemy Team Min:", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
	end
	ZyraMenu:addSubMenu("[KS Options]", "KSOptions")
	ZyraMenu.KSOptions:addParam("KSwithQ","KS with Q", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.KSOptions:addParam("KSwithE","KS with E", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.KSOptions:addParam("AutoPassive","Auto Passive", SCRIPT_PARAM_ONOFF, true)
	
	ZyraMenu:addSubMenu("[Q Farm]", "Farm")
	ZyraMenu.Farm:addParam("info", "~=[ Q Farm 1 ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu.Farm:addParam("ManaSliderFarm1", "Min mana to use Q",   SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
	ZyraMenu.Farm:addParam("info", "~=[ Q Farm 2 ]=~", SCRIPT_PARAM_INFO, "")
	ZyraMenu.Farm:addParam("ManaSliderFarm2", "Min mana to use Q",   SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
	
	ZyraMenu:addSubMenu("[Harass]", "Harass")
	ZyraMenu.Harass:addParam("info", "~=[ Harass 1 ]=~", SCRIPT_PARAM_INFO, "")
    ZyraMenu.Harass:addParam("Harass1Mode","Harass Q Mode", SCRIPT_PARAM_LIST, 1, { "Only if W Ready", "Dont wait for W" })
	ZyraMenu.Harass:addParam("ManaSliderHarass1", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
	ZyraMenu.Harass:addParam("info", "~=[ Harass 2 ]=~", SCRIPT_PARAM_INFO, "")
    ZyraMenu.Harass:addParam("Harass2Mode","Harass Q Mode", SCRIPT_PARAM_LIST, 2, { "Only if W Ready", "Dont wait for W" })
	ZyraMenu.Harass:addParam("ManaSliderHarass2", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
	
	ZyraMenu:addSubMenu("[Combo]", "Combo")
	ZyraMenu.Combo:addParam("UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Combo:addParam("UseE","Use E", SCRIPT_PARAM_ONOFF, true)
	ZyraMenu.Combo:addParam("UseW","Use W", SCRIPT_PARAM_ONOFF, true)
	
	ZyraMenu:addParam("Ult4me","Ult 4 Me", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Y"))
	ZyraMenu:addParam("SBTW","Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	ZyraMenu:addParam("Harass1key","Harass 1 Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	ZyraMenu:addParam("Harass2key","Harass 2 Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	ZyraMenu:addParam("QFarm1key","Q Farm 1 Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	ZyraMenu:addParam("QFarm2key","Q Farm 2 Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	
	ZyraMenu:addParam("info1", "Big Fat Zyra: v. "..version.."", SCRIPT_PARAM_INFO, "")
	ZyraMenu:addParam("info2", "by Big Fat Nidalee", SCRIPT_PARAM_INFO, "")
	
	
				-- antigap
		for i, enemy in ipairs(GetEnemyHeroes()) do
			for _, champ in pairs(SpellsDBAntigapclose) do
				if enemy.charName == champ.charName then
				table.insert(SpellsTOAntigapclose, {charName = champ.charName, description = champ.description, spellName = champ.spellName, endposcast = champ.endposcast})
				end
			end
		end

		if #SpellsTOAntigapclose > 0 then
			for _, Antigap in pairs(SpellsTOAntigapclose) do

					ZyraMenu.Antigapcloser:addParam(Antigap.spellName, ""..Antigap.charName.. " | " ..Antigap.description.. " - " ..Antigap.spellName, SCRIPT_PARAM_ONOFF, true)
						
						if Antigap.endposcast == true then 
						ZyraMenu.Antigapcloser:addParam(Antigap.spellName..1, "Cast to: ", SCRIPT_PARAM_LIST, 2, { "Start Position", "End Position" })
						elseif Antigap.endposcast == false then
						ZyraMenu.Antigapcloser:addParam(Antigap.spellName..1, "Cast to: ", SCRIPT_PARAM_LIST, 1, { "Start Position", "End Position" })
						end
						
					ZyraMenu.Antigapcloser:addParam("blank", " ", SCRIPT_PARAM_INFO, "")
				
			end
		else	
		ZyraMenu.Antigapcloser:addParam("notfound", "0 supported skills found =( ", SCRIPT_PARAM_INFO, "")	
		end

	ZyraMenu:addSubMenu("[Orbwalker]", "Orbwalk")
	ZyraMenu.Orbwalk:addParam("standartts", "Use Standart TargetSelector", SCRIPT_PARAM_ONOFF, true)
	PrintChat("<font color='#c9d7ff'>Big Fat Zyra: </font><font color='#64f879'> "..version.." </font><font color='#c9d7ff'> loaded, happy elo boosting! </font>")
	


end 

function OnTick()

	ts:update()
	
		orbwalkcheck()
		target = ts.target
		Target = getTarget()

	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	PReady = (myHero:GetSpellData(_Q).name == myHero:GetSpellData(_W).name or myHero:GetSpellData(_W).name == myHero:GetSpellData(_E).name)
	
	enemyMinions = {}
	enemyMinions = minionManager(MINION_ENEMY, QRange, myHero, MINION_SORT_HEALTH_ASC)
	
	---qww
	RealCD = (MyBaseCD(W) - (MyBaseCD(W) / 100 * math.abs(myHero.cdr*100)))

	if Seed1 == false and Seed2 == false then 
	W2Ready = true
	else 
	W2Ready = false
	end 
	
	if Seed1 == true then
		Seed1 = true
		if os.clock() >= count_start_1+RealCD then
		
		Seed1 = false

		end 
	end
	if Seed2 == true then
		Seed2 = true
			if os.clock() >= seedtime[1] +RealCD + RealCD then
			
			Seed2 = false

			end

	end
	if count_start_3 ~= nil then 
		if Seed2 == false and qcasting == true and os.clock() >= count_start_3 + 0.5 and os.clock() <= count_start_3 + 2.0  and GetDistance(processes[4]) <= WRange then
		Packet('S_CAST', {spellId = _W, toX = processes[1], toY = processes[3], fromX = processes[1], fromY = processes[3]}):send(true)
		qcasting = false
		end
	end 
	----
	
		if Target and ValidTarget(Target) and not PReady then
		
			KS()
			
			if ZyraMenu.Ult4me then
			ULT4ME()
			end
			
			if ZyraMenu.SBTW then
			Combo() 
			end
				
			if ZyraMenu.Harass1key then 
			Harass1()
			end
				
			if ZyraMenu.Harass2key then 
			Harass2()
			end
			
			if prodictiondonator == true then
				if ZyraMenu.Ultimate.UseAutoUlt then
				UltGroup()
				end
			end
		
		end
		
		if Target and ValidTarget(Target) and PReady and ZyraMenu.KSOptions.AutoPassive then
		PassiveShot()
		end 
		
	if ZyraMenu.QFarm1key and not PReady then
	Farm1()
	end 
	if ZyraMenu.QFarm2key and not PReady then
	Farm2()
	end 
	if not ZyraMenu.QFarm1key then
	farming = false
	end 
	if not ZyraMenu.QFarm2key then
	farming = false
	end 

	
end 

function OnProcessSpell(unit, spell)

	if unit.isMe and spell.name == "ZyraQFissure" and farming == false then
	qcasting = true
		processes[1] = spell.endPos.x
		processes[2] = spell.endPos.y
		processes[3] = spell.endPos.z
		processes[4] = spell.endPos
		
	count_start_3 = os.clock()
	if GetDistance(spell.endPos) <= WRange then
	Packet('S_CAST', {spellId = _W, toX = spell.endPos.x, toY = spell.endPos.z, fromX = spell.endPos.x, fromY = spell.endPos.z}):send(true)
	end 
	end
	
	-- Antigap
		if #SpellsTOAntigapclose > 0 then
			for _, Antigap in pairs(SpellsTOAntigapclose) do
				if not PReady and spell.name == Antigap.spellName and not myHero.dead and not unit.dead and unit.team ~= myHero.team then
					if ZyraMenu.Antigapcloser[Antigap.spellName] and EReady and myHero.mana >= MyMana(E) and GetDistance(spell.endPos) <= ZyraMenu.Antigapcloser.ComfortRange then
					
						if ZyraMenu.Antigapcloser[Antigap.spellName..1] == 1 then
							if ZyraMenu.ProdictionSettings.UsePacketsCast then
							Packet("S_CAST", {spellId = _E, fromX =  spell.startPos.x, fromY =  spell.startPos.z, toX =  spell.startPos.x, toY =  spell.startPos.z}):send()
							else
							CastSpell(_E, spell.startPos.x, spell.startPos.z)
							end
							if ZyraMenu.Antigapcloser.Debug then
							PrintChat("Antigapcloser startpos: " ..Antigap.charName.. " | " ..Antigap.description.. " - " ..Antigap.spellName)
							end
						elseif ZyraMenu.Antigapcloser[Antigap.spellName..1] == 2 then
							if ZyraMenu.ProdictionSettings.UsePacketsCast then
							Packet("S_CAST", {spellId = _E, fromX =  spell.endPos.x, fromY =  spell.endPos.z, toX =  spell.endPos.x, toY =  spell.endPos.z}):send()
							else
							CastSpell(_E, spell.endPos.x, spell.endPos.z)
							end
							if ZyraMenu.Antigapcloser.Debug then
							PrintChat("Antigapcloser endpos: " ..Antigap.charName.. " | " ..Antigap.description.. " - " ..Antigap.spellName)
							end
						end
						
					end
				end
			end
		end
	--
		
end 
--qww
function MyBaseCD(cdr)
	if cdr == W then
	return 18 - (myHero:GetSpellData(_W).level)
	end 
end	

function OnGainBuff(unit, buff)   
        if Seed1 == false and buff.name == "ZyraSeed" and unit.team == myHero.team then
		count_start_1 = os.clock()
		seedtime[1] = count_start_1
        Seed1 = true
        elseif Seed1 == true and buff.name == "ZyraSeed" and unit.team == myHero.team then
		count_start_2 = os.clock()
        Seed2 = true
        end
end
---
-- << --  -- << --  -- << --  -- << -- [SOW]  -- >> --  -- >> --  -- >> --  -- >> --

function orbwalkcheck()
	if checkedMMASAC then return end
	if not (starttick + 5000 < GetTickCount()) then return end
	checkedMMASAC = true
    if _G.MMA_Loaded then
     	print(' >>Big Fat Zyra: MMA found. MMA support loaded.')
		is_MMA = true
	end	
	if _G.AutoCarry then
		print(' >>Big Fat Zyra: SAC found. SAC support loaded.')
		is_SAC = true
	end	
	if is_MMA then
		ZyraMenu.Orbwalk:addSubMenu("Marksman's Mighty Assistant", "mma")
		ZyraMenu.Orbwalk.mma:addParam("mmastatus", "Use MMA Target Selector", SCRIPT_PARAM_ONOFF, false)			
	end
	if is_SAC then
		ZyraMenu.Orbwalk:addSubMenu("Sida's Auto Carry", "sac")
		ZyraMenu.Orbwalk.sac:addParam("sacstatus", "Use SAC Target Selector", SCRIPT_PARAM_ONOFF, false)
	end
	if not is_SAC then
		ZyraMenu.Orbwalk:addParam("line", "----------------------------------------------------", SCRIPT_PARAM_INFO, "")
		ZyraMenu.Orbwalk:addParam("line", "", SCRIPT_PARAM_INFO, "")
		iSOW:LoadToMenu(ZyraMenu.Orbwalk)
	end
end

function getTarget()
	if not checkedMMASAC then return end
	if is_MMA and is_SAC then
		
		if ZyraMenu.Orbwalk.mma.mmastatus then
			ZyraMenu.Orbwalk.sac.sacstatus = false
			ZyraMenu.Orbwalk.standartts = false
		elseif ZyraMenu.Orbwalk.sac.sacstatus then
			ZyraMenu.Orbwalk.mma.mmastatus = false
			ZyraMenu.Orbwalk.standartts = false
		elseif	ZyraMenu.Orbwalk.standartts then
			ZyraMenu.Orbwalk.mma.mmastatus = false
			ZyraMenu.Orbwalk.sac.sacstatus = false
		end
	end	
	if not is_MMA and is_SAC then
		if ZyraMenu.Orbwalk.sac.sacstatus then
			ZyraMenu.Orbwalk.standartts = false
		else
			ZyraMenu.Orbwalk.standartts = true
		end	
	end
	if is_MMA and not is_SAC then
		if ZyraMenu.Orbwalk.mma.mmastatus then
			ZyraMenu.Orbwalk.standartts = false
		else
			ZyraMenu.Orbwalk.standartts = true
		end	
	end
	if not is_MMA and not is_SAC then
		ZyraMenu.Orbwalk.standartts = true	
	end	
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then
		return _G.MMA_Target 
	end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then
		return _G.AutoCarry.Attack_Crosshair.target		
	end
    return ts.target	
end


-- << --  -- << --  -- << --  -- << -- [Farm]  -- >> --  -- >> --  -- >> --  -- >> --
function Farm1()
	enemyMinions:update()
	for _, minion in ipairs(enemyMinions.objects) do
		if ValidTarget(minion) then
		
			if QReady and not minion.dead and GetDistance(minion) <= QRange and minion.health < getDmg("Q",minion,myHero) and myHero.mana >= MyMana(Q) and not mymanaislowerthen(ZyraMenu.Farm.ManaSliderFarm1) then
			farming = true
				if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = minion.x, toY = minion.z, fromX = minion.x, fromY = minion.z}):send(true)
					else 
					CastSpell(_Q, minion.x, minion.z)
				end	
			else
			farming = false
			end	
			
		end
end 
end

function Farm2()
	enemyMinions:update()
	for _, minion in ipairs(enemyMinions.objects) do
		if ValidTarget(minion) then
		
			if QReady and not minion.dead and GetDistance(minion) <= QRange and minion.health < getDmg("Q",minion,myHero) and myHero.mana >= MyMana(Q) and not mymanaislowerthen(ZyraMenu.Farm.ManaSliderFarm2) then
			farming = true
				if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = minion.x, toY = minion.z, fromX = minion.x, fromY = minion.z}):send(true)
					else 
					CastSpell(_Q, minion.x, minion.z)
				end						
			else
			farming = false
			end		
			
		end
end 
end

-- << --  -- << --  -- << --  -- << -- [COMBO]  -- >> --  -- >> --  -- >> --  -- >> --
 
function Combo()
	if not Target then return end
	
	if EReady and WReady and ZyraMenu.Combo.UseE then

			if GetDistance(Target) <= WRange and myHero.mana >= MyMana(E)  then

					local epos, einfo = Prodiction.GetLineAOEPrediction(Target, WRange, ESpeed, EDelay, EWidth, myPlayer)
					if epos and einfo.hitchance >= ZyraMenu.ProdictionSettings.EHitchance then
						if ZyraMenu.ProdictionSettings.UsePacketsCast then
						Packet('S_CAST', {spellId = _W, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
						Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
						Packet('S_CAST', {spellId = _W, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
						else 
						CastSpell(_W, epos.x, epos.z)
						CastSpell(_E, epos.x, epos.z)
						CastSpell(_W, epos.x, epos.z)
						end	

					end 
			elseif GetDistance(Target) <= ERange and myHero.mana >= MyMana(E)  then
					local epos, einfo = Prodiction.GetLineAOEPrediction(Target, ERange, ESpeed, EDelay, EWidth, myPlayer)
					if epos and einfo.hitchance >= ZyraMenu.ProdictionSettings.EHitchance then
						if ZyraMenu.ProdictionSettings.UsePacketsCast then
						Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
						else 
						CastSpell(_E, epos.x, epos.z)
						end	

					end 			
			end
	elseif EReady and not WReady and ZyraMenu.Combo.UseE then

			if GetDistance(Target) <= ERange and myHero.mana >= MyMana(E)  then

					local epos, einfo = Prodiction.GetLineAOEPrediction(Target, ERange, ESpeed, EDelay, EWidth, myPlayer)
					if epos and einfo.hitchance >= ZyraMenu.ProdictionSettings.EHitchance then
						if ZyraMenu.ProdictionSettings.UsePacketsCast then
						Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
						else 
						CastSpell(_E, epos.x, epos.z)
						end	

					end 
			end
	end

	--
	if QReady and not EReady and ZyraMenu.Combo.UseQ then
		if GetDistance(Target) <= QRange and myHero.mana >= MyMana(Q) then
			
			local qpos, qinfo = Prodiction.GetCircularAOEPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
			
			if qpos and qinfo.hitchance >= ZyraMenu.ProdictionSettings.QHitchance then
							

				if ZyraMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
				else 
				CastSpell(_Q, qpos.x, qpos.z)
				end

			end
			
		end
	elseif QReady and EReady and ZyraMenu.Combo.UseQ then
		if GetDistance(Target) <= QRange and myHero.mana >= MyMana(Q) then
			
			local qpos, qinfo = Prodiction.GetCircularAOEPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
			
			if qpos and qinfo.hitchance >= ZyraMenu.ProdictionSettings.QHitchance then
							

				if ZyraMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
				else 
				CastSpell(_Q, qpos.x, qpos.z)
				end

			end
			
		end
	end
--
	
end	

-- << --  -- << --  -- << --  -- << -- [Harass]  -- >> --  -- >> --  -- >> --  -- >> --
function Harass1()
	if not Target then return end
	
	if ZyraMenu.Harass.Harass1Mode == 1 then
		if QReady and WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass1) and GetDistance(Target) <= QRange then
				local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth2, myPlayer)
			
				if qpos and qinfo.hitchance >= ZyraMenu.ProdictionSettings.QHitchance then


					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
					else
					CastSpell(_Q, qpos.x, qpos.z)
					end


				end
			
		end 
	elseif ZyraMenu.Harass.Harass1Mode == 2 then
		if QReady and WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass1) and GetDistance(Target) <= QRange then
				local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth2, myPlayer)
			
				if qpos and qinfo.hitchance >= ZyraMenu.ProdictionSettings.QHitchance then

					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
					else
					CastSpell(_Q, qpos.x, qpos.z)
					end


				end
				
		elseif QReady and not WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass1) and GetDistance(Target) <= QRange then
				local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth2, myPlayer)
				
				if qpos and qinfo.hitchance >= ZyraMenu.ProdictionSettings.QHitchance then

					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
					else
					CastSpell(_Q, qpos.x, qpos.z)
					end


				end
				
		end
	end 
	
end 

function Harass2()
	if not Target then return end
	
	if ZyraMenu.Harass.Harass2Mode == 1 then
		if QReady and WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass2) and GetDistance(Target) <= QRange then
				local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth2, myPlayer)
			
				if qpos and qinfo.hitchance >= ZyraMenu.ProdictionSettings.QHitchance then

					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
					else
					CastSpell(_Q, qpos.x, qpos.z)
					end

				end
			
		end 
	elseif ZyraMenu.Harass.Harass2Mode == 2 then
		if QReady and WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass2) and GetDistance(Target) <= QRange then
				local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth2, myPlayer)
			
				if qpos and qinfo.hitchance >= ZyraMenu.ProdictionSettings.QHitchance then

				
					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
					else
					CastSpell(_Q, qpos.x, qpos.z)
					end

				end
				
		elseif QReady and not WReady and not mymanaislowerthen(ZyraMenu.Harass.ManaSliderHarass2) and GetDistance(Target) <= QRange then
				local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth2, myPlayer)
				
				if qpos and qinfo.hitchance >= ZyraMenu.ProdictionSettings.QHitchance then

					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
					else
					CastSpell(_Q, qpos.x, qpos.z)
					end


				end
				
		end
	end 
	
end 

-- << --  -- << --  -- << --  -- << -- [KS]  -- >> --  -- >> --  -- >> --  -- >> --

function KS()
	for i = 1, heroManager.iCount do
	local enemy = heroManager:getHero(i)
--	
		if QReady and ZyraMenu.KSOptions.KSwithQ and ValidTarget(enemy, QRange) and not enemy.dead and enemy.health < getDmg("Q",enemy,myHero) and myHero.mana >= MyMana(Q) and enemy.visible then
		local qpos, qinfo = Prodiction.GetPrediction(enemy, QRange, QSpeed, QDelay, QWidth, myPlayer)

			if qpos and qinfo.hitchance >= ZyraMenu.ProdictionSettings.QHitchance then
				
				if ZyraMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
				else 
				CastSpell(_Q, qpos.x, qpos.z)
				end

			end	
		end

--
		if EReady and ZyraMenu.KSOptions.KSwithE and ValidTarget(enemy, ERange) and not enemy.dead and enemy.health < getDmg("E",enemy,myHero) and myHero.mana >= MyMana(E) and enemy.visible then
		local epos, einfo = Prodiction.GetPrediction(enemy, ERange, ESpeed, EDelay, EWidth, myPlayer)

			if epos and einfo.hitchance >= ZyraMenu.ProdictionSettings.EHitchance then
				if ZyraMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
				else 
				CastSpell(_E, epos.x, epos.z)
				end

			end	

		end
--	


	end
end
 -- << --  -- << --  -- << --  -- << -- [Passive]  -- >> --  -- >> --  -- >> --  -- >> --
 
function PassiveShot()
	if not Target then return end
	
	for i = 1, heroManager.iCount do
	local enemy = heroManager:getHero(i)

		if PReady and ValidTarget(enemy, PRange) and not enemy.dead and enemy.health < getDmg("P",enemy,myHero) and enemy.visible then
		local ppos, pinfo = Prodiction.GetPrediction(enemy, PRange, PSpeed, PDelay, PWidth, myPlayer)

			if ppos and pinfo.hitchance >= ZyraMenu.ProdictionSettings.PHitchance then

				if ZyraMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = ppos.x, toY = ppos.z, fromX = ppos.x, fromY = ppos.z}):send(true)
				Packet('S_CAST', {spellId = _W, toX = ppos.x, toY = ppos.z, fromX = ppos.x, fromY = ppos.z}):send(true)
				Packet('S_CAST', {spellId = _E, toX = ppos.x, toY = ppos.z, fromX = ppos.x, fromY = ppos.z}):send(true)
				Packet('S_CAST', {spellId = _R, toX = ppos.x, toY = ppos.z, fromX = ppos.x, fromY = ppos.z}):send(true)
				else 
				CastSpell(_Q, ppos.x, ppos.z)
				CastSpell(_W, ppos.x, ppos.z)
				CastSpell(_E, ppos.x, ppos.z)
				CastSpell(_R, ppos.x, ppos.z)
				end

			end	

		elseif PReady and ValidTarget(enemy, PRange) and not enemy.dead and enemy.health > getDmg("P",enemy,myHero) and enemy.visible then
		if GetDistance(Target) <= PRange and not enemy.dead and enemy.visible then
			local ppos, pinfo = Prodiction.GetPrediction(Target, PRange, PSpeed, PDelay, PWidth, myPlayer)

				if ppos and pinfo.hitchance >= ZyraMenu.ProdictionSettings.PHitchance then

					if ZyraMenu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = ppos.x, toY = ppos.z, fromX = ppos.x, fromY = ppos.z}):send(true)
					Packet('S_CAST', {spellId = _W, toX = ppos.x, toY = ppos.z, fromX = ppos.x, fromY = ppos.z}):send(true)
					Packet('S_CAST', {spellId = _E, toX = ppos.x, toY = ppos.z, fromX = ppos.x, fromY = ppos.z}):send(true)
					Packet('S_CAST', {spellId = _R, toX = ppos.x, toY = ppos.z, fromX = ppos.x, fromY = ppos.z}):send(true)
					else 
					CastSpell(_Q, ppos.x, ppos.z)
					CastSpell(_W, ppos.x, ppos.z)
					CastSpell(_E, ppos.x, ppos.z)
					CastSpell(_R, ppos.x, ppos.z)
					end

				end	
		end
		end
		
--	
	end

end 

 -- << --  -- << --  -- << --  -- << -- [Ult]  -- >> --  -- >> --  -- >> --  -- >> --
function UltGroup()

 	if not Target then return end
 	if RReady and GetDistance(Target) <= RRange then
		local boolean, rpos, rinfo = Prodiction.GetMinCountCircularAOEPrediction(ZyraMenu.Ultimate.UltGroupMinimum, RRange, RSpeed, RDelay, RRadius, myPlayer)
		if boolean == true and rpos then
			if ZyraMenu.ProdictionSettings.UsePacketsCast and rinfo.hitchance >= ZyraMenu.ProdictionSettings.RHitchance then
			Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end			
		end 
	end
	
end

function ULT4ME()
 	if not Target then return end
 	if RReady and GetDistance(Target) <= RRange then
		local rpos, rinfo = Prodiction.GetCircularAOEPrediction(Target, RRange, RSpeed, RDelay, RRadius, myPlayer)		
		if rpos and rinfo.hitchance >= ZyraMenu.ProdictionSettings.RHitchance then
			if ZyraMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
		end 		
	end	
end


function OnDraw()

	if ZyraMenu.Antigapcloser.DrawComfort then
	DrawCircle(myHero.x, myHero.y, myHero.z, ZyraMenu.Antigapcloser.ComfortRange, 0xb9c3ed)
	end
	
	if ZyraMenu.Draws.UselowfpsDraws then
	if not PReady then
		if ZyraMenu.Draws.DrawAARange and not myHero.dead then
		DrawCircleAA(myHero.x, myHero.y, myHero.z, AARange, ARGB(ZyraMenu.Draws.AASettings.colorAA[1],ZyraMenu.Draws.AASettings.colorAA[2],ZyraMenu.Draws.AASettings.colorAA[3],ZyraMenu.Draws.AASettings.colorAA[4]))
		end	
		if QReady and ZyraMenu.Draws.DrawQRange and not myHero.dead then
		DrawCircleQ(myHero.x, myHero.y, myHero.z, QRange, ARGB(ZyraMenu.Draws.QSettings.colorAA[1],ZyraMenu.Draws.QSettings.colorAA[2],ZyraMenu.Draws.QSettings.colorAA[3],ZyraMenu.Draws.QSettings.colorAA[4]))
		end	
		if WReady and ZyraMenu.Draws.DrawWRange and not myHero.dead then
		DrawCircleW(myHero.x, myHero.y, myHero.z, WRange, ARGB(ZyraMenu.Draws.WSettings.colorAA[1],ZyraMenu.Draws.WSettings.colorAA[2],ZyraMenu.Draws.WSettings.colorAA[3],ZyraMenu.Draws.WSettings.colorAA[4]))
		end	
		if EReady and ZyraMenu.Draws.DrawERange and not myHero.dead then
		DrawCircleE(myHero.x, myHero.y, myHero.z, ERange, ARGB(ZyraMenu.Draws.ESettings.colorAA[1],ZyraMenu.Draws.ESettings.colorAA[2],ZyraMenu.Draws.ESettings.colorAA[3],ZyraMenu.Draws.ESettings.colorAA[4]))
		end	
		if RReady and ZyraMenu.Draws.DrawRRange and not myHero.dead then
		DrawCircleR(myHero.x, myHero.y, myHero.z, RRange, ARGB(ZyraMenu.Draws.RSettings.colorAA[1],ZyraMenu.Draws.RSettings.colorAA[2],ZyraMenu.Draws.RSettings.colorAA[3],ZyraMenu.Draws.RSettings.colorAA[4]))
		end	
		if QReady and WReady and ZyraMenu.Draws.DrawWQ and not myHero.dead then
		DrawCircleWQ(mousePos.x, mousePos.y, mousePos.z, QWidth2, ARGB(ZyraMenu.Draws.WQ2MouseSettings.colorAA[1],ZyraMenu.Draws.WQ2MouseSettings.colorAA[2],ZyraMenu.Draws.WQ2MouseSettings.colorAA[3],ZyraMenu.Draws.WQ2MouseSettings.colorAA[4]))
		end
	end
	if PReady and ZyraMenu.Draws.DrawPRange and not myHero.dead then
	DrawCircleP(myHero.x, myHero.y, myHero.z, PRange, ARGB(ZyraMenu.Draws.PSettings.colorAA[1],ZyraMenu.Draws.PSettings.colorAA[2],ZyraMenu.Draws.PSettings.colorAA[3],ZyraMenu.Draws.PSettings.colorAA[4]))
	end	
	end
	
	if not ZyraMenu.Draws.UselowfpsDraws then
		if not PReady then
		
			if ZyraMenu.Draws.DrawAARange and not myHero.dead then
			DrawCircle(myHero.x, myHero.y, myHero.z, AARange, 0xb9c3ed)
			end
				
			if QReady then 
				if ZyraMenu.Draws.DrawQRange and not myHero.dead then
				DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0xb9c3ed)
				end	
			end
			if WReady then 
				if ZyraMenu.Draws.DrawWRange and not myHero.dead then
				DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0xb9c3ed)
				end
			end
			if EReady then 
				if ZyraMenu.Draws.DrawERange and not myHero.dead then
				DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0xb9c3ed)
				end
			end
			if RReady then 
				if ZyraMenu.Draws.DrawRRange and not myHero.dead then
				DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xb9c3ed)
				end
			end
			if QReady and WReady then 
				if ZyraMenu.Draws.DrawWQ and not myHero.dead then
				DrawCircle(mousePos.x, mousePos.y, mousePos.z, QWidth2, 0xb9c3ed)
				end
			end
		end
		if PReady and ZyraMenu.Draws.DrawPRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, PRange, 0xb9c3ed)
		end
	
	end


end 

--AA Range Circle QUality
function DrawCircleNextLvlAA(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(ZyraMenu.Draws.AASettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end


--AA Range Circle Width
function DrawCircleAA(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlAA(x, y, z, radius, ZyraMenu.Draws.AASettings.width, color, 75)	
	end
end 

--Q Range Circle QUality
function DrawCircleNextLvlQ(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(ZyraMenu.Draws.QSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlQ(x, y, z, radius, ZyraMenu.Draws.QSettings.width, color, 75)	
	end
end 

--W Range Circle QUality
function DrawCircleNextLvlW(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(ZyraMenu.Draws.WSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlW(x, y, z, radius, ZyraMenu.Draws.WSettings.width, color, 75)	
	end
end 


--E Range Circle QUality
function DrawCircleNextLvlE(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(ZyraMenu.Draws.ESettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlE(x, y, z, radius, ZyraMenu.Draws.ESettings.width, color, 75)	
	end
end 


--R Range Circle QUality
function DrawCircleNextLvlR(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(ZyraMenu.Draws.RSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlR(x, y, z, radius, ZyraMenu.Draws.RSettings.width, color, 75)	
	end
end 


--P Range Circle QUality
function DrawCircleNextLvlP(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(ZyraMenu.Draws.PSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end


--P Range Circle Width
function DrawCircleP(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlP(x, y, z, radius, ZyraMenu.Draws.PSettings.width, color, 75)	
	end
end 

--WQ Range Circle QUality
function DrawCircleNextLvlWQ(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(ZyraMenu.Draws.WQ2MouseSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end


--WQ Range Circle Width
function DrawCircleWQ(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlWQ(x, y, z, radius, ZyraMenu.Draws.WQ2MouseSettings.width, color, 75)	
	end
end 

-- << -- -- << -- -- << -- -- << -- [Hooks] -- >> -- -- >> -- -- >> -- -- >> --
function get_hooks()

	if Prodiction.GetUserStatus() == _G.P_DONATOR then
	PrintChat("Big Fat Zyra: Donators Prodiction detected!")
	prodictiondonator = true
	elseif Prodiction.GetUserStatus() == _G.P_FREEUSER then
	PrintChat("Big Fat Zyra: Free User Prodiction detected!")
	prodictiondonator = false
	end
	if _G.allowSpells then 
	evade_found = true
	--PrintChat("Big Fat Zyra: Evadeee detected!")
	else
	evade_found = false
	--PrintChat("Big Fat Zyra: Evadeee not detected!")
	end
	
end 
--
-- << --  -- << --  -- << --  -- << -- [MANA]  -- >> --  -- >> --  -- >> --  -- >> --
 
function mymanaislowerthen(percent)
    if myHero.mana < (myHero.maxMana * ( percent / 100)) then
        return true
    else
        return false
    end
end

function MyMana(spell)
	if spell == Q then
		return 70 + (5 * myHero:GetSpellData(_Q).level)
	elseif spell == E then
		return 65 + (5 * myHero:GetSpellData(_E).level)
	elseif spell == R then
		return 80 + (20 * myHero:GetSpellData(_R).level)
	elseif spell == QER then
		return 70 + (5 * myHero:GetSpellData(_Q).level) + 65 + (5 * myHero:GetSpellData(_E).level) + 80 + (20 * myHero:GetSpellData(_R).level)
	elseif spell == QE then
		return 70 + (5 * myHero:GetSpellData(_Q).level) + 65 + (5 * myHero:GetSpellData(_E).level)
	elseif spell == QR then
		return 70 + (5 * myHero:GetSpellData(_Q).level) + 80 + (20 * myHero:GetSpellData(_R).level)
	elseif spell == ER then
		return 65 + (5 * myHero:GetSpellData(_E).level) + 80 + (20 * myHero:GetSpellData(_R).level)
	end
end
--
-- << -- -- << -- -- << -- -- << -- [Tables] -- >> -- -- >> -- -- >> -- -- >> --
function get_tables()
	
	SpellsTOAntigapclose = {}
	SpellsDBAntigapclose =
	{
	-- Antigapcloser
	{charName = "Aatrox", spellName = "AatroxQ", endposcast = true, description = "Q"},
	{charName = "Corki", spellName = "CarpetBomb", endposcast = false, description = "W"},
	{charName = "Diana", spellName = "DianaTeleport", endposcast = false, description = "R"},
	{charName = "LeeSin", spellName = "blindmonkqtwo", endposcast = false, description = "Q"},
	{charName = "Poppy", spellName = "PoppyHeroicCharge", endposcast = false, description = "E"},
	{charName = "Shaco", spellName = "Deceive", endposcast = true, description = "Q"},
	{charName = "JarvanIV", spellName = "JarvanIVDragonStrike", endposcast = false, description = "Q"},
	{charName = "Fiora", spellName = "FioraQ", endposcast = true, description = "Q"},
	{charName = "Leblanc", spellName = "LeblancSlide", endposcast = true, description = "W"},
	{charName = "Leblanc", spellName = "leblacslidereturn", endposcast = true, description = "W"},
	{charName = "Fizz", spellName = "FizzPiercingStrike", endposcast = true, description = "Q"},
	{charName = "Gragas", spellName = "GragasE", endposcast = false, description = "E"},
	{charName = "Irelia", spellName = "IreliaGatotsu", endposcast = false, description = "Q"},
	{charName = "Jax", spellName = "JaxLeapStrike", endposcast = false, description = "Q"},
	{charName = "Khazix", spellName = "KhazixE", endposcast = false, description = "E"},
	{charName = "Khazix", spellName = "khazixelong", endposcast = false, description = "E"},
	{charName = "Braum", spellName = "BraumW", endposcast = true, description = "W"},
	{charName = "Thresh", spellName = "threshqleap", endposcast = false, description = "Q 2"},
	{charName = "Ahri", spellName = "AhriTumble", endposcast = true, description = "R"},
	{charName = "Kassadin", spellName = "RiftWalk", endposcast = true, description = "R"},
	{charName = "Tristana", spellName = "RocketJump", endposcast = false, description = "W"},
	{charName = "Akali", spellName = "AkaliShadowDance", endposcast = true, description = "R"},
	{charName = "Pantheon", spellName = "PantheonW", endposcast = true, description = "W"},
	{charName = "Quinn", spellName = "QuinnE", endposcast = false, description = "E"},
	{charName = "Renekton", spellName = "RenektonSliceAndDice", endposcast = true, description = "E"},
	{charName = "Sejuani", spellName = "SejuaniArcticAssault", endposcast = false, description = "Q"},
	{charName = "Shyvana", spellName = "ShyvanaTransformCast", endposcast = false, description = "R"},
	{charName = "Tryndamere", spellName = "slashCast", endposcast = true, description = "E"},
	{charName = "Vi", spellName = "ViQ", endposcast = false, description = "Q"},
	{charName = "XinZhao", spellName = "XenZhaoSweep", endposcast = true, description = "E"},
	{charName = "Yasuo", spellName = "YasuoDashWrapper", endposcast = true, description = "E"},
	{charName = "Leona", spellName = "LeonaZenithBlade", endposcast = false, description = "E"}
	}
	
end 
