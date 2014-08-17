if myHero.charName ~= "Janna" then return end
	
local version = "0.14"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL-Releases/master/Big Fat Janna's Assistant.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Big Fat Janna's Assistant.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#66cc00\">Big Fat Janna's Assistant:</font> <font color=\"#FFFFFF\">"..msg..".</font>") end
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

local QRange, QSpeed, QDelay, QWidth = 1025, 910, 0, 200
local QBuffRange = 1500
local RRange = 700
local WRange = 600
local ERange = 800

local QRangeextra = 1500
local buffer_objektov = {}
local buffer_processov = {}
local QReady = false
--x2Q
local onHowlingGale = false 
local secondqcheck = false
-- Orbwalk --
local myTarget = nil
local lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0
-- Skinhack
local lastSkin = 0

--- BoL Script Status Connector --- 
local ScriptKey = "TGJFNIFHLHM" -- Your script auth key
local ScriptVersion = "" -- Leave blank if version url is not registred

-- Thanks to Bilbao for his socket help & encryption
assert(load(Base64Decode("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"), nil, "bt", _ENV))()
-----------------------------------

function OnLoad()
	
	require "Prodiction"
	get_tables()
	
	if _G.allowSpells then 
	evade_found = true
	PrintChat("<font color='#c9d7ff'>Big Fat Janna's Assistant: </font><font color='#64f879'> Evadeee found =)) ! </font>")
	else
	evade_found = false
	PrintChat("<font color='#c9d7ff'>Big Fat Janna's Assistant: </font><font color='#64f879'> Evadeee not found ;'( </font>")
	end
	
	Myspace = GetDistance(myHero.minBBox)
	
	myTrueRange = 475 + Myspace
	
	JannaMenu = scriptConfig("Big Fat Janna's Assistant", "Big Fat Janna's Assistant")
	JannaMenu:addSubMenu("[Prodiction Settings]", "ProdictionSettings")
		JannaMenu.ProdictionSettings:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
		JannaMenu.ProdictionSettings:addParam("blank", "", SCRIPT_PARAM_INFO, "")
		JannaMenu.ProdictionSettings:addParam("QHitchance", "Q Hitchance", SCRIPT_PARAM_SLICE, 1, 1, 3, 0)
		JannaMenu.ProdictionSettings:addParam("blank", "", SCRIPT_PARAM_INFO, "")
		JannaMenu.ProdictionSettings:addParam("info2", "HITCHANCE:", SCRIPT_PARAM_INFO, "")
		JannaMenu.ProdictionSettings:addParam("info3", "LOW = 1  NORMAL = 2  HIGH = 3", SCRIPT_PARAM_INFO, "")
		
	JannaMenu:addSubMenu("[KS Options]", "KSOptions")
		JannaMenu.KSOptions:addParam("KSwithW","KS with W", SCRIPT_PARAM_ONOFF, true)
	
	JannaMenu:addSubMenu("[Interrupter]", "Int")
		JannaMenu.Int:addParam("interrupterdebug","Interrupter Debug", SCRIPT_PARAM_ONOFF, true)
		JannaMenu.Int:addParam("info", " ", SCRIPT_PARAM_INFO, "")
			-- interrupter
		for i, enemy in ipairs(GetEnemyHeroes()) do
			for _, champ in pairs(SpellsDBInterrupt) do
				if enemy.charName == champ.charName then
				table.insert(SpellsTOInterrupt, {charName = champ.charName, description = champ.description, spellName = champ.spellName, useult = champ.useult, endposcast = champ.endposcast})
				end
			end
		end

		if #SpellsTOInterrupt > 0 then
			for _, Inter in pairs(SpellsTOInterrupt) do
					JannaMenu.Int:addParam(Inter.spellName, ""..Inter.charName.. " | " ..Inter.description.. " - " ..Inter.spellName, SCRIPT_PARAM_ONOFF, true)
					if Inter.useult == "no" then
					JannaMenu.Int:addParam(Inter.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, false)
					elseif Inter.useult == "yes" then
					JannaMenu.Int:addParam(Inter.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, true)
					end
					JannaMenu.Int:addParam("info", " ", SCRIPT_PARAM_INFO, "")
			
			end
		else	JannaMenu.Int:addParam("404", "0 supported skills found =( ", SCRIPT_PARAM_INFO, "")	
		end
		
	JannaMenu:addSubMenu("[Antigapcloser]", "Antigapcloser")
		JannaMenu.Antigapcloser:addParam("Antigapcloserdebug","Antigapcloser Debug", SCRIPT_PARAM_ONOFF, true)
		JannaMenu.Antigapcloser:addParam("info", " ", SCRIPT_PARAM_INFO, "")
		
		for i, enemy in ipairs(GetEnemyHeroes()) do
			for _, champ in pairs(ObjectsDBAntigapclose) do
				if enemy.charName == champ.charName then
				table.insert(ObjectsTOAntigapclose, {charName = champ.charName, description = champ.description, spellName = champ.spellName, useult = champ.useult, endposcast = champ.endposcast, objectname = champ.objectname})
				end
			end
		end
		
		
		if #ObjectsTOAntigapclose > 0 then
			for _, Antigapobjects in pairs(ObjectsTOAntigapclose) do

					JannaMenu.Antigapcloser:addParam(Antigapobjects.spellName, ""..Antigapobjects.charName.. " | " ..Antigapobjects.description.. " - " ..Antigapobjects.spellName, SCRIPT_PARAM_ONOFF, true)	
					JannaMenu.Antigapcloser:addParam("info", " ", SCRIPT_PARAM_INFO, "")
				
			end
		else	JannaMenu.Antigapcloser:addParam("404noo", "0 supported skills found =( ", SCRIPT_PARAM_INFO, "")	
		end
		
		-- antigap
		for i, enemy in ipairs(GetEnemyHeroes()) do
			for _, champ in pairs(SpellsDBAntigapclose) do
				if enemy.charName == champ.charName then
				table.insert(SpellsTOAntigapclose, {charName = champ.charName, description = champ.description, spellName = champ.spellName, useult = champ.useult, endposcast = champ.endposcast})
				end
			end
		end

		if #SpellsTOAntigapclose > 0 then
			for _, Antigap in pairs(SpellsTOAntigapclose) do

					JannaMenu.Antigapcloser:addParam(Antigap.spellName, ""..Antigap.charName.. " | " ..Antigap.description.. " - " ..Antigap.spellName, SCRIPT_PARAM_ONOFF, true)
						if Antigap.useult == "no" then
						JannaMenu.Antigapcloser:addParam(Antigap.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, false)
						elseif Antigap.useult == "yes" then
						JannaMenu.Antigapcloser:addParam(Antigap.spellName..2, "allow to use ult", SCRIPT_PARAM_ONOFF, true)
						end
						
						if Antigap.endposcast == true then 
						JannaMenu.Antigapcloser:addParam(Antigap.spellName..3, "Cast to: ", SCRIPT_PARAM_LIST, 2, { "Start Position", "End Position" })
						elseif Antigap.endposcast == false then
						JannaMenu.Antigapcloser:addParam(Antigap.spellName..3, "Cast to: ", SCRIPT_PARAM_LIST, 1, { "Start Position", "End Position" })
						end
					JannaMenu.Antigapcloser:addParam("info", " ", SCRIPT_PARAM_INFO, "")
				
			end
		else	JannaMenu.Antigapcloser:addParam("404no", "0 supported skills found =( ", SCRIPT_PARAM_INFO, "")	
		end
		
	JannaMenu:addSubMenu("[Boost Allies Dmg Output]", "BoostAlliesDmgOutput")
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team and teammate.charName == "Caitlyn" then
				JannaMenu.BoostAlliesDmgOutput:addParam("CaitPassive","Caitlyn | Passive Headshot", SCRIPT_PARAM_ONOFF, true)
				JannaMenu.BoostAlliesDmgOutput:addParam("CaitPlevel","Mana Priority level", SCRIPT_PARAM_SLICE, 1, 1, 3)
				JannaMenu.BoostAlliesDmgOutput:addParam("info", " ", SCRIPT_PARAM_INFO, "")
			end
		end
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
		else JannaMenu.BoostAlliesDmgOutput:addParam("404", "0 supported skills found =( ", SCRIPT_PARAM_INFO, "")	
		end	
	--
	JannaMenu:addSubMenu("[Shild Towers]", "ShildTowers")
		JannaMenu.ShildTowers:addParam("STiae","Shild Towers if enemys get attacked", SCRIPT_PARAM_ONOFF, true)
		JannaMenu.ShildTowers:addParam("OnlyifhaveArdentCenser","Only if have Ardent Censer", SCRIPT_PARAM_ONOFF, false)
		JannaMenu.ShildTowers:addParam("info", "~=[ Will cast only if not lower: ]=~", SCRIPT_PARAM_INFO, "")
		JannaMenu.ShildTowers:addParam("minhp", "My minimal Life %",   SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
		JannaMenu.ShildTowers:addParam("minmana", "My minimal Mana %",   SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
	
	JannaMenu:addSubMenu("[Mana Settings]", "ManaSettings")
		JannaMenu.ManaSettings:addParam("info1", "Minimum Mana till skills used", SCRIPT_PARAM_INFO, "")
		JannaMenu.ManaSettings:addParam("info3", "", SCRIPT_PARAM_INFO, "")
		JannaMenu.ManaSettings:addParam("info2", "Boost Allies Dmg Output:", SCRIPT_PARAM_INFO, "")
		JannaMenu.ManaSettings:addParam("Prioritylvl1", "Mana Priority lvl 1",   SCRIPT_PARAM_SLICE, 45, 0, 100, 0)
		JannaMenu.ManaSettings:addParam("Prioritylvl2", "Mana Priority lvl 2",   SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
		JannaMenu.ManaSettings:addParam("Prioritylvl3", "Mana Priority lvl 3",   SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
		JannaMenu.ManaSettings:addParam("info4", "", SCRIPT_PARAM_INFO, "")
		JannaMenu.ManaSettings:addParam("info", "Harass:" , SCRIPT_PARAM_INFO, "")
		JannaMenu.ManaSettings:addParam("HarassMana", "Min Mana",   SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
		
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
		
	JannaMenu:addSubMenu("[Show in Game]", "Show")
		JannaMenu.Show:addParam("info", "New Settings will be saved after Reload", SCRIPT_PARAM_INFO, "")
		JannaMenu.Show:addParam("info2", "", SCRIPT_PARAM_INFO, "")
		JannaMenu.Show:addParam("showcombo","Combo Key", SCRIPT_PARAM_ONOFF, true)
		JannaMenu.Show:addParam("showspamq","Spam Q Toggle", SCRIPT_PARAM_ONOFF, true)
		JannaMenu.Show:addParam("DoubleQ","Always 2 Q Toggle", SCRIPT_PARAM_ONOFF, true)

	JannaMenu:addParam("always2q","Always 2 Q Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Y"))
	JannaMenu:addParam("Orbwalk","Use Orbwalk", SCRIPT_PARAM_ONOFF, true)
	if evade_found == true then
	JannaMenu:addParam("evadee","Evadeee Intergration", SCRIPT_PARAM_ONOFF, true)
	end
	JannaMenu:addParam("blank11", "", SCRIPT_PARAM_INFO, "")
	JannaMenu:addParam("resetbug","Reset Q bug cast", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	JannaMenu:addParam("blank1", "", SCRIPT_PARAM_INFO, "")
	JannaMenu:addParam("castq","Spam Q Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, 65)
	JannaMenu:addParam("Combo","Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	JannaMenu:addParam("Harass","Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, 88)
	JannaMenu:addParam("blank2", "", SCRIPT_PARAM_INFO, "")
	JannaMenu:addParam("SkinHack","Use Skin Hack", SCRIPT_PARAM_ONOFF, false)
	JannaMenu:addParam("skin", "Skin Hack by Shalzuth:", SCRIPT_PARAM_LIST, 3, { "Tempest", "Hextech", "Frost Queen", "Victorious", "Forecast", "No Skin" })
	JannaMenu:addParam("blank3", "", SCRIPT_PARAM_INFO, "")
	JannaMenu:addParam("info1", "Big Fat Janna's Assistant v. "..version.."", SCRIPT_PARAM_INFO, "")
	JannaMenu:addParam("info2", "by Big Fat Nidalee", SCRIPT_PARAM_INFO, "")
	

	ts = TargetSelector(TARGET_LESS_CAST, 1400, true)
	ts.name = "JannaMenu"
    JannaMenu:addTS(ts)
		if JannaMenu.Show.DoubleQ then
		JannaMenu:permaShow("always2q")
		end	

		if JannaMenu.Show.showspamq then
		JannaMenu:permaShow("castq")
		end
		
		if JannaMenu.Show.showcombo then
		JannaMenu:permaShow("Combo")
		end	
		
	PrintChat("<font color='#c9d7ff'>Big Fat Janna's Assistant: </font><font color='#64f879'> v. "..version.." </font><font color='#c9d7ff'> loaded, happy elo boosting! </font>")
end 


function OnTick()

	ts:update()
	Target = ts.target
	
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	ArdentC = GetInventorySlotItem(3504)
	ArdentCReady = (ArdentC ~= nil)

	
	if onHowlingGale == true and ValidTarget(Target, QBuffRange) and not myHero.dead then
		if JannaMenu.ProdictionSettings.UsePacketsCast then
			Packet("S_CAST", {spellId = _Q}):send()
		else
			CastSpell(_Q)
		end
	end
	
	if JannaMenu.resetbug then
	onHowlingGale = false 
	secondqcheck = false
	end 

Antigapcloser()
	--KS
	KS()
	if evade_found == true then
	if JannaMenu.evadee then
	if _G.Evadeee_impossibleToEvade and EReady and myHero.mana >= MyMana(E) and not myHero.dead then
	CastSpell(_E)
	end
	end
	end
	--
	-- Skinhack
	if JannaMenu.SkinHack then
	SkinHack()
	end 
	-- Orbwalk
	if JannaMenu.Orbwalk and JannaMenu.Combo or JannaMenu.Harass then
	OrbWalk()
	end
	--Combo
	if Target and JannaMenu.Combo then
	Combo()
	end
	-- Harass
	if Target and JannaMenu.Harass then
	Harass()
	end
	-- QSPam
	if Target and JannaMenu.castq and not JannaMenu.Combo then
	QSpam()
	end


end 

function Antigapcloser()

	
	if buffer_objektov[4] ~= nil then

		if JannaMenu.ProdictionSettings.UsePacketsCast then
		Packet("S_CAST", {spellId = _Q, fromX =  buffer_objektov[1], fromY =  buffer_objektov[3], toX =  buffer_objektov[1], toY =  buffer_objektov[3]}):send()
		else
		CastSpell(_Q, buffer_objektov[1], buffer_objektov[3])
		end
	secondqcheck = true
	end 

	if buffer_objektov[4] == nil then
	secondqcheck = false
	end 
end 

function OnProcessSpell(unit, spell)

-- Orbwalker
	if unit == myHero then
		--print(""..spell.name.."")
		if spell.name:lower():find("attack") then
			lastAttack = GetTickCount() - GetLatency() / 2
			lastWindUpTime = spell.windUpTime * 1000
			lastAttackCD = spell.animationTime * 1000
		end 
	end
--

	-- Antigap
		if #SpellsTOAntigapclose > 0 then
			for _, Antigap in pairs(SpellsTOAntigapclose) do
				if spell.name == Antigap.spellName and not myHero.dead and not unit.dead and unit.team ~= myHero.team then
					if JannaMenu.Antigapcloser[Antigap.spellName] and QReady and myHero.mana >= MyMana(Q) and GetDistance(spell.endPos) <= QRange then
					secondqcheck = true
					
						if JannaMenu.Antigapcloser[Antigap.spellName..3] == 1 then
							if JannaMenu.ProdictionSettings.UsePacketsCast then
							Packet("S_CAST", {spellId = _Q, fromX =  spell.startPos.x, fromY =  spell.startPos.z, toX =  spell.startPos.x, toY =  spell.startPos.z}):send()
							else
							CastSpell(_Q, spell.startPos.x, spell.startPos.z)
							end
							PrintChat("Antigapcloser: Tried to interrupt with Q: " ..Antigap.charName.. " | " ..Antigap.description.. " - " ..Antigap.spellName)
						elseif JannaMenu.Antigapcloser[Antigap.spellName..3] == 2 then
							if JannaMenu.ProdictionSettings.UsePacketsCast then
							Packet("S_CAST", {spellId = _Q, fromX =  spell.endPos.x, fromY =  spell.endPos.z, toX =  spell.endPos.x, toY =  spell.endPos.z}):send()
							else
							CastSpell(_Q, spell.endPos.x, spell.endPos.z)
							end
							PrintChat("Antigapcloser: Tried to interrupt with Q: " ..Antigap.charName.. " | " ..Antigap.description.. " - " ..Antigap.spellName)
						end
						
					elseif JannaMenu.Antigapcloser[Antigap.spellName..2] and not QReady and RReady and myHero.mana >= MyMana(R) and GetDistance(unit) <= RRange and unit.visible then
							secondqcheck = false
							CastSpell(_R)
							if JannaMenu.Antigapcloser.interrupterdebug then PrintChat("Antigapcloser: Tried to interrupt with R: " ..Antigap.charName.. " | " ..Antigap.description.. " - " ..Antigap.spellName) end
					
					
					end
				end
				
				if spell.name == Antigap.spellName and not QReady and unit.team ~= myHero.team then 
				secondqcheck = false
				end
			end
		end
		

		
	----------
	-- Interrupter
		if #SpellsTOInterrupt > 0 then
			for _, Inter in pairs(SpellsTOInterrupt) do
				if spell.name == Inter.spellName and not myHero.dead and not unit.dead and unit.team ~= myHero.team then
					if JannaMenu.Int[Inter.spellName] and QReady and myHero.mana >= MyMana(Q) and GetDistance(unit) <= QRange and unit.visible then
					secondqcheck = true
							if JannaMenu.ProdictionSettings.UsePacketsCast then
							Packet("S_CAST", {spellId = _Q, fromX =  unit.x, fromY =  unit.z, toX =  unit.x, toY =  unit.z}):send()
							else
							CastSpell(_Q, unit.x, unit.z)		
							end
							if JannaMenu.Int.interrupterdebug then PrintChat("Tried to interrupt with Q: " ..Inter.charName.. " | " ..Inter.description.. " - " ..Inter.spellName) end
							
					elseif JannaMenu.Int[Inter.spellName] and JannaMenu.Int[Inter.spellName..2] and not QReady and RReady and myHero.mana >= MyMana(R) and GetDistance(unit) <= RRange and unit.visible then
					secondqcheck = false
							CastSpell(_R)
							if JannaMenu.Int.interrupterdebug then PrintChat("Tried to interrupt with R: " ..Inter.charName.. " | " ..Inter.description.. " - " ..Inter.spellName) end
					end
					
					
				if spell.name == Inter.spellName and not QReady and unit.team ~= myHero.team then 
				secondqcheck = false
				end
				end
				
				
				
			end
		end
	----------
	
	----------
	-- Boost Dmg
				if #SpellsToShild > 0 then
			for _, Boost in pairs(SpellsToShild) do
				if spell.name == Boost.spellName and not myHero.dead and unit.team == myHero.team then
					if JannaMenu.BoostAlliesDmgOutput[Boost.spellName] and EReady and myHero.mana >= MyMana(E) and (GetDistance(unit) < ERange) then
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
			
	----------
	
	----------
	-- Shild Towers
	if JannaMenu.ShildTowers.STiae and not myHero.dead then
        if (spell.name:find("ChaosTurret") and myHero.team == TEAM_RED) or (spell.name:find("OrderTurret") and myHero.team == TEAM_BLUE) then

		for i=1, heroManager.iCount do
            local enemy = heroManager:GetHero(i)
            if ValidTarget(enemy) then
                if JannaMenu.ShildTowers.OnlyifhaveArdentCenser and ArdentCReady and GetDistance(spell.endPos, enemy)<80 and GetDistance(unit) <= ERange and not mymanaislowerthen(JannaMenu.ShildTowers.minmana) and not myhpislowerthen(JannaMenu.ShildTowers.minhp) and myHero.mana >= MyMana(E) and EReady then
					if JannaMenu.ProdictionSettings.UsePacketsCast then
					Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
					else
					CastSpell(_E, unit)
					end
				elseif not JannaMenu.ShildTowers.OnlyifhaveArdentCenser and GetDistance(spell.endPos, enemy)<80 and GetDistance(unit) <= ERange and not mymanaislowerthen(JannaMenu.ShildTowers.minmana) and not myhpislowerthen(JannaMenu.ShildTowers.minhp) and myHero.mana >= MyMana(E) and EReady then
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

function OnCreateObj(object) 

	if #ObjectsTOAntigapclose > 0 then
		for _, Antigapobjects in pairs(ObjectsTOAntigapclose) do
			
			
			if not myHero.dead then
			if GetDistance(object) <= QRange and JannaMenu.Antigapcloser[Antigapobjects.spellName] then
			
				if object.name == Antigapobjects.objectname then	
				buffer_objektov[1] = object.x
				buffer_objektov[2] = object.y
				buffer_objektov[3] = object.z
				buffer_objektov[4] = object.name
				
				elseif not object.name == Antigapobjects.objectname then
				buffer_objektov[1] = nil
				buffer_objektov[2] = nil
				buffer_objektov[3] = nil
				buffer_objektov[4] = nil
				end
				
			end
			end
		end
	end

end


function OnDeleteObj(object)

	if #ObjectsTOAntigapclose > 0 then
		for _, Antigapobjects in pairs(ObjectsTOAntigapclose) do
			
			
			if not myHero.dead then
			if GetDistance(object) <= QRangeextra * 2  and JannaMenu.Antigapcloser[Antigapobjects.spellName] then
			
				if object.name == Antigapobjects.objectname then
				buffer_objektov[1] = nil
				buffer_objektov[2] = nil
				buffer_objektov[3] = nil
				buffer_objektov[4] = nil
				end
				
			end
			end
		end
	end
	
end 


function OnGainBuff(unit, buff)

    if unit == nil or buff == nil then return end
    if unit.isMe and buff then

		if not JannaMenu.always2q then
			if buff.name == "HowlingGale" and not myHero.dead and secondqcheck == true then
			onHowlingGale = true
			end
		elseif JannaMenu.always2q then
			if buff.name == "HowlingGale" and not myHero.dead then
			onHowlingGale = true
			end
		end 
	end


	if buff.name == "caitlynheadshot" and unit.team == myHero.team then
	caitlynheadshot = true
	end 
	
	if caitlynheadshot == true and JannaMenu.BoostAlliesDmgOutput.CaitPassive and EReady and myHero.mana >= MyMana(E) and (GetDistance(unit) < ERange) and unit.team == myHero.team and not myHero.dead then
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
        if buff.name == "HowlingGale" then
        onHowlingGale = false
        end
    end
		
	if buff.name == "caitlynheadshot" and unit.team == myHero.team then
	caitlynheadshot = false
	end  
end 


 -- << --  -- << --  -- << --  -- << -- [Combo]  -- >> --  -- >> --  -- >> --  -- >> --
function Combo()

 	if QReady and not myHero.dead and GetDistance(Target) <= QRange and myHero.mana >= MyMana(Q) then
	local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
	
		if qpos and qinfo.hitchance >= JannaMenu.ProdictionSettings.QHitchance then
		secondqcheck = true
			if JannaMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end
		if not qpos then
		secondqcheck = false
		end
	end 
	if not QReady then 
	secondqcheck = false
	elseif QReady and GetDistance(Target) >= QRange then
	secondqcheck = false
	end
	
 	if WReady and GetDistance(Target) <= WRange and not myHero.dead and myHero.mana >= MyMana(W) then 
		if JannaMenu.ProdictionSettings.UsePacketsCast then
		Packet("S_CAST", {spellId = _W, targetNetworkId = Target.networkID}):send()
		else
		CastSpell(_W, Target)
		end
					
	end
 
end
  -- << --  -- << --  -- << --  -- << -- [QSpam]  -- >> --  -- >> --  -- >> --  -- >> --
  
function QSpam()

 	if QReady and not myHero.dead and GetDistance(Target) <= QRange and myHero.mana >= MyMana(Q) then
	local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
			
		if qpos and qinfo.hitchance >= JannaMenu.ProdictionSettings.QHitchance then
		secondqcheck = true
			if JannaMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end 
	end 
	
	if not QReady then 
	secondqcheck = false
	elseif QReady and GetDistance(Target) >= QRange then
	secondqcheck = false
	end
 
end
  
  -- << --  -- << --  -- << --  -- << -- [Harass]  -- >> --  -- >> --  -- >> --  -- >> --
function Harass()
	
 	if WReady and GetDistance(Target) <= WRange and not myHero.dead and myHero.mana >= MyMana(W) and not mymanaislowerthen(JannaMenu.ManaSettings.HarassMana) then 
		if JannaMenu.ProdictionSettings.UsePacketsCast then
		Packet("S_CAST", {spellId = _W, targetNetworkId = Target.networkID}):send()
		else
		CastSpell(_W, Target)
		end

	end
 
end 
 
 
 -- << --  -- << --  -- << --  -- << -- [KS]  -- >> --  -- >> --  -- >> --  -- >> --
 function KS()
	for i = 1, heroManager.iCount do
	local enemy = heroManager:getHero(i)

		if WReady and JannaMenu.KSOptions.KSwithW and ValidTarget(enemy, WRange) and not enemy.dead and enemy.health < getDmg("W",enemy,myHero) and myHero.mana >= MyMana(W) and enemy.visible then

			if JannaMenu.ProdictionSettings.UsePacketsCast then
			Packet("S_CAST", {spellId = _W, targetNetworkId = enemy.networkID}):send()
			else
			CastSpell(_W, enemy)
			end

		end	


	end

end

 -- << --  -- << --  -- << --  -- << -- [Mana]  -- >> --  -- >> --  -- >> --  -- >> --
 
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

function MyMana(spell)
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

 -- << --  -- << --  -- << --  -- << -- [Draws]  -- >> --  -- >> --  -- >> --  -- >> --
 

function OnDraw()

	if JannaMenu.Draws.UselowfpsDraws then
		if QReady and JannaMenu.Draws.DrawQRange and not myHero.dead then
		DrawCircleQ(myHero.x, myHero.y, myHero.z, QRange, ARGB(JannaMenu.Draws.QSettings.colorAA[1],JannaMenu.Draws.QSettings.colorAA[2],JannaMenu.Draws.QSettings.colorAA[3],JannaMenu.Draws.QSettings.colorAA[4]))
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
		DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0xb9c3ed)
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
 -- << --  -- << --  -- << --  -- << -- [Skin Hack]  -- >> --  -- >> --  -- >> --  -- >> --
function GenModelPacket(champ, skinId)
	p = CLoLPacket(0x97)
	p:EncodeF(myHero.networkID)
	p.pos = 1
	t1 = p:Decode1()
	t2 = p:Decode1()
	t3 = p:Decode1()
	t4 = p:Decode1()
	p:Encode1(t1)
	p:Encode1(t2)
	p:Encode1(t3)
	p:Encode1(bit32.band(t4,0xB))
	p:Encode1(1)--hardcode 1 bitfield
	p:Encode4(skinId)
	for i = 1, #champ do
		p:Encode1(string.byte(champ:sub(i,i)))
	end
	for i = #champ + 1, 64 do
		p:Encode1(0)
	end
	p:Hide()
	RecvPacket(p)
end

function SkinHack()
if JannaMenu.skin ~= lastSkin and VIP_USER then
	lastSkin = JannaMenu.skin
	GenModelPacket("Janna", JannaMenu.skin)
end
end
 -- << --  -- << --  -- << --  -- << -- [OrbWalker]  -- >> --  -- >> --  -- >> --  -- >> --
 
function OrbWalk()
	if JannaMenu.Orbwalk then
	myTarget = ts.target
	if myTarget ~= nil and GetDistance(myTarget) <= myTrueRange then
		if timeToShoot() then
			myHero:Attack(myTarget)
		elseif heroCanMove() then
			moveToCursor()
		end
	else		
		moveToCursor() 
	end
	end
end

function heroCanMove()
	return ( GetTickCount() + GetLatency() / 2 > lastAttack + lastWindUpTime + 20 )
end 
 
function timeToShoot()
	return ( GetTickCount() + GetLatency() / 2 > lastAttack + lastAttackCD )
end 
 
function moveToCursor()
	if GetDistance(mousePos) > 100 and GetDistance(mousePos) > 1 or lastAnimation == "Idle1" then
		local moveToPos = myHero + (Vector(mousePos) - myHero):normalized() * 250
		myHero:MoveTo(moveToPos.x, moveToPos.z)
	end 
end

 -- << --  -- << --  -- << --  -- << -- [Tables]  -- >> --  -- >> --  -- >> --  -- >> --
function get_tables()

		
	SpellsTOInterrupt = {}
	SpellsDBInterrupt = 
	{
		-- Interrupter
		{charName = "FiddleSticks", spellName = "Drain", endposcast = false, useult = "no",description = "W"},
		{charName = "FiddleSticks", spellName = "Crowstorm", endposcast = false, useult = "yes",description = "R"},
		{charName = "MissFortune", spellName = "MissFortuneBulletTime", endposcast = false, useult = "yes",description = "R"},
		{charName = "Caitlyn", spellName = "CaitlynAceintheHole", endposcast = false, useult = "no",description = "R"},
		{charName = "Katarina", spellName = "KatarinaR", endposcast = false, useult = "yes",description = "R"},
		{charName = "Karthus", spellName = "FallenOne", endposcast = false, useult = "yes",description = "R"},
		{charName = "Malzahar", spellName = "AlZaharNetherGrasp", endposcast = false, useult = "yes",description = "R"},
		{charName = "Galio", spellName = "GalioIdolOfDurand", endposcast = false, useult = "yes",description = "R"},
		{charName = "Lucian", spellName = "LucianR", endposcast = false, useult = "no",description = "R"},	
		{charName = "Shen",  spellName = "ShenStandUnited", endposcast = false, useult = "no",description = "R"},
		{charName = "Urgot",  spellName = "UrgotSwap2", endposcast = false, useult = "no",description = "R"},
		{charName = "Pantheon",  spellName = "PantheonRJump", endposcast = false, useult = "no",description = "R"},
		{charName = "Warwick",  spellName = "InfiniteDuress", endposcast = false, useult = "yes",description = "R"},
		{charName = "Xerath",  spellName = "XerathLocusOfPower2", endposcast = false, useult = "yes",description = "R"},
		{charName = "Velkoz",  spellName = "VelkozR", endposcast = false, useult = "no",description = "R"},
		{charName = "Zac",  spellName = "ZacE", endposcast = false, useult = "no",description = "E"},
		{charName = "Twitch",  spellName = "HideInShadows", endposcast = false, useult = "no",description = "Q"},
		{charName = "Xerath",  spellName = "XerathArcanopulseChargeUp", endposcast = false, useult = "no",description = "Q"}

		}

		
		
		
		
	ObjectsTOAntigapclose = {}
	ObjectsDBAntigapclose = 
{
		{charName = "Aatrox", spellName = "AatroxQ", useult = "no", description = "Q", objectname = "Aatrox_Base_Q_Cast.troy"},
		{charName = "Corki", spellName = "CarpetBomb", useult = "no", description = "W", objectname = "corki_valkrie_speed.troy"},
		{charName = "Diana", spellName = "DianaTeleport", useult = "no", description = "R", objectname = "Diana_Base_R_Cas.troy"},
		{charName = "JarvanIV", spellName = "JarvanIVDragonStrike", useult = "no", description = "Q", objectname = "JarvanQuick_buf.troy"},
		{charName = "Fiora", spellName = "FioraQ",useult = "no", description = "Q", objectname = "FioraQLunge_buf.troy"},
		{charName = "Leblanc", spellName = "LeblancSlide",useult = "no", description = "W", objectname = "LeBlanc_Displacement_Yellow_mis.troy"},
		{charName = "Leblanc", spellName = "LeblancSlideM",useult = "no", description = "WR", objectname = "LeBlanc_Displacement_mis.troy"},
		{charName = "Amumu", spellName = "BandageToss", useult = "no", description = "Q", objectname = "Bandage_beam.troy"},
		{charName = "Khazix", spellName = "KhazixE", useult = "no", description = "E", objectname = "Khazix_Base_E_Land.troy"},
		{charName = "Khazix", spellName = "khazixelong", useult = "no", description = "E", objectname = "Khazix_Base_E_Land.troy"},
		{charName = "Ahri", spellName = "AhriTumble",useult = "no", description = "R", objectname = "Ahri_Orb_cas.troy"},
		{charName = "Kassadin", spellName = "RiftWalk",useult = "no", description = "R", objectname = "Kassadin_Base_R_vanish.troy"},
		{charName = "Tristana", spellName = "RocketJump", useult = "no", description = "W", objectname = "tristana_rocketJump_cas.troy"},
		{charName = "Akali", spellName = "AkaliShadowDance",useult = "no", description = "R", objectname = "akali_shadowDance_mis.troy"},
		{charName = "Caitlyn", spellName = "CaitlynEntrapment", useult = "no", description = "E", objectname = "caitlyn_Base_entrapment_mis.troy"},
		{charName = "Pantheon",  spellName = "PantheonW",useult = "no", description = "W", objectname = "Pantheon_Base_W_tar.troy"},
		{charName = "Quinn",  spellName = "QuinnE", useult = "no", description = "E", objectname = "Quinn_Base_E_Tar.troy"},
		{charName = "Tryndamere",  spellName = "slashCast",useult = "no", description = "E", objectname = "Slash.troy"},
		{charName = "Vi",  spellName = "ViQ", useult = "no", description = "Q", objectname = "Vi_q_mis.troy"},
		{charName = "Rengar",  spellName = "404", useult = "no", description = "Passive Jump", objectname = "Rengar_Base_P_Leap_Grass.troy"},
		{charName = "Rengar",  spellName = "404", useult = "no", description = "Passive Jump", objectname = "Rengar_LeapSound.troy"},
		{charName = "Renekton",  spellName = "RenektonSliceAndDice", useult = "no", description = "E", objectname = "RenektonSliceDice_buf.troy"},
		{charName = "Sejuani",  spellName = "SejuaniArcticAssault", useult = "no", description = "Q", objectname = "Sejuani_Q_tar.troy"},
		{charName = "Shyvana",  spellName = "ShyvanaTransformCast", useult = "no", description = "R", objectname = "shyvana_dragon_idle.troy"},
		{charName = "Leona", spellName = "LeonaZenithBlade", useult = "no", description = "E", objectname = "Leona_ZenithBlade_mis.troy"}
--
		
}



	SpellsTOAntigapclose = {}
	SpellsDBAntigapclose = 
	{
		-- Antigapcloser
		{charName = "LeeSin", spellName = "blindmonkqtwo", endposcast = false, useult = "no",description = "Q"},
		{charName = "Poppy", spellName = "PoppyHeroicCharge", endposcast = false, useult = "no",description = "E"},
		{charName = "Shaco",  spellName = "Deceive", endposcast = true, useult = "no",description = "Q"},
		{charName = "Fizz", spellName = "FizzPiercingStrike", endposcast = true, useult = "no",description = "Q"},
		{charName = "Irelia", spellName = "IreliaGatotsu", endposcast = false, useult = "no",description = "Q"},
		{charName = "Alistar", spellName = "Headbutt", endposcast = false, useult = "no",description = "W"},
		{charName = "Jax", spellName = "JaxLeapStrike", endposcast = false, useult = "no",description = "Q"},
		{charName = "Braum", spellName = "BraumW", endposcast = true, useult = "no",description = "W"},
		{charName = "Thresh", spellName = "threshqleap", endposcast = false, useult = "no",description = "Q 2"},
		{charName = "Caitlyn", spellName = "CaitlynEntrapment", endposcast = false, useult = "no",description = "E"},
		{charName = "Renekton",  spellName = "RenektonSliceAndDice", endposcast = true, useult = "no",description = "E"},
		{charName = "XinZhao",  spellName = "XenZhaoSweep", endposcast = true, useult = "no",description = "E"},
		{charName = "Yasuo",  spellName = "YasuoDashWrapper", endposcast = true, useult = "no",description = "E"}

		}
		
		
		
		
	SpellsToShild = {}
	ShildSpellsDB = {

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
		{charName = "Tristana", spellName = "RocketJump", description = "W", important = 3},
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
end 
