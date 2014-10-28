if myHero.charName ~= "Lux" then return end
local version = "0.01"
local autor = "Big Fat Corki"
local scriptname = "Big Fat Private Series: Lux"
local loading_text = false 
--
local TSRange = 1500

local QRange, QSpeed, QDelay, QWidth, QWidthCol = 1150, 1200, 0.234, 60, 70
local ERange, ESpeed, EDelay, ERadius = 1100, 1300, 0.250, 200
local DetonateRadius = 350
local RRange, RSpeed, RDelay, RWidth = 3340, math.huge, 0.700, 90
local CurrentHitchance = 2
local AARange = 650
local possibleks1, possibleks2, possibleks3, possibleks4, possibleks5, possibleks6 = false, false, false, false, false, false

local etimer = 0 
local ecasting = false
local epos = {}


function OnLoad()
	require "Collision"
	require "Prodiction"
	LuxColl = Collision(QRange, QSpeed, QDelay, QWidthCol)
	if _G.allowSpells then 
	evade_found = true
	PrintChat("<font color='#c9d7ff'>"..scriptname.." </font><font color='#64f879'> Evadeee found =)) ! </font>")
	else
	evade_found = false
	PrintChat("<font color='#c9d7ff'>"..scriptname.." </font><font color='#64f879'> Evadeee not found ;'( </font>")
	end
	
	AddLoadCallback(function() Menu() end)
	AddTickCallback(function() if Menu.SkinHack then SkinHack() end end)
	loading_text_start_delay = os.clock()
	PrintChat("<font color='#c9d7ff'>"..scriptname..": </font><font color='#64f879'> v. "..version.." </font><font color='#c9d7ff'> loaded, good luck! </font>")
	
end 


function OnTick()
	Welcome()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	TSRangeLogic()
	ts:update()
	Target = ts.target
	detonateE()
	KS()

	if evade_found == true then
		if _G.Evadeee_impossibleToEvade and EReady and not myHero.dead then
			if Menu.PredictionSettings.Packets then
			Packet('S_CAST', {spellId = _W, toX = myHero.x, toY = myHero.z, fromX = myHero.x, fromY = myHero.z}):send(true)
			else 
			CastSpell(_W, myHero.x, myHero.z)
			end
		end
	end
	if ValidTarget(Target) then
	SaveZone()
		if possibleks1 == false and possibleks2 == false and possibleks3 == false and possibleks4 == false and possibleks5 == false and possibleks6 == false then 
			--Autoult()
			if Menu.Combo then 
			Combo()
			end
			if Menu.Harass1 or  Menu.Harass2 then 
			Harass()
			end
		end
	end 
	
end
function OnProcessSpell(unit, spell)
	if unit == myHero and spell.name == "LuxLightStrikeKugel" then
	ecasting = true
	etimer = os.clock()
	end
end 

function OnCreateObj(object)
	if object.name:find("LuxLightstrike_tar_green") then
	epos[1] = object
	end 	
end 

function OnDeleteObj(object)
	if object.name:find("LuxLightstrike_tar_green") then
	ecasting = false
	epos[1] = nil
	etimer = 0
	end 	
end

function korzina()

	if os.clock() >= etimer+5.5 then
	etimer = 0
	ecasting = false
	epos[1] = nil
	end 
	
	if not EReady then
	etimer = 0
	ecasting = false
	epos[1] = nil
	end 
	if myHero.dead then
	possibleks1, possibleks2, possibleks3, possibleks4, possibleks5, possibleks6 = false, false, false, false, false, false
	etimer = 0
	ecasting = false
	epos[1] = nil
	end 
	
end 

function detonateE()
	for i = 1, #GetEnemyHeroes() do
	local enemy = GetEnemyHeroes()[i]
		if not enemy.dead and enemy.visible and ValidTarget(enemy) and enemy ~= nil then
			if ecasting == true and epos[1] ~= nil then
				if GetDistance(enemy, epos[1]) < DetonateRadius then
				CastSpell(_E)
				end 
			end
		end
	end

end 


function TSRangeLogic()
	if RReady then
	TSRange = RRange
	else
	TSRange = 1500
	end
end 

function KS()
	for i = 1, #GetEnemyHeroes() do
	local enemy = GetEnemyHeroes()[i]
		if not enemy.dead and enemy.visible and ValidTarget(enemy) and enemy ~= nil then
		
			if QReady and ValidTarget(enemy, QRange) and enemy.health < getDmg("Q",enemy,myHero) and myHero.mana >= MyMana(Q) then
			possibleks1 = true
			CastQ(enemy)
			CastQ2(enemy)
				if GetDistance(enemy) <= AARange then
				myHero:Attack(enemy)
				end
			else 
			possibleks1 = false
			end 
			
			if EReady and ecasting == false and ValidTarget(enemy, ERange) and enemy.health < getDmg("E",enemy,myHero) and myHero.mana >= MyMana(E) then
			possibleks2 = true
			CastE(enemy)
				if GetDistance(enemy) <= AARange then
				myHero:Attack(enemy)
				end
			else 
			possibleks2 = false
			end 
			
			if EReady and ecasting == false and QReady and ValidTarget(enemy, ERange) and enemy.health < getDmg("E",enemy,myHero) + getDmg("Q",enemy,myHero) and myHero.mana >= MyMana(EQ) then
			possibleks3 = true
			CastE(enemy)
			CastQ(enemy)
			CastQ2(enemy)
				if GetDistance(enemy) <= AARange then
				myHero:Attack(enemy)
				end
			else 
			possibleks3 = false
			end 
			
			if RReady and ValidTarget(enemy, RRange) and enemy.health < getDmg("R",enemy,myHero) and myHero.mana >= MyMana(R) then
			possibleks4 = true
			CastR(enemy)
				if GetDistance(enemy) <= AARange then
				myHero:Attack(enemy)
				end
			else 
			possibleks4 = false
			end 
			
			if EReady and ecasting == false and QReady and RReady and ValidTarget(enemy, ERange) and enemy.health < getDmg("E",enemy,myHero) + getDmg("Q",enemy,myHero) + getDmg("R",enemy,myHero) and myHero.mana >= MyMana(EQR) then
			possibleks5 = true
			CastE(enemy)
			CastQ(enemy)
			CastQ2(enemy)
			CastR(enemy)
				if GetDistance(enemy) <= AARange then
				myHero:Attack(enemy)
				end
			else 
			possibleks5 = false
			end 		
			if ValidTarget(enemy, AARange) and enemy.health < getDmg("AD",enemy,myHero) then
			possibleks6 = true
			myHero:Attack(enemy)
			else 
			possibleks6 = false
			end 
	
		
		else
		possibleks1, possibleks2, possibleks3, possibleks4, possibleks5, possibleks6 = false, false, false, false, false, false
		end
	end
end 
function SaveZone()
	if QReady and GetDistance(Target) <= 500 then
	CastQ(Target)
	end
end 
function Combo()
if not Target then return end

	if EReady and ecasting == false and GetDistance(Target) <= ERange then
	local CurrentHitchance = Menu.PredictionSettings.CHit
	CastE(Target)
	end 
	
	if QReady and GetDistance(Target) <= QRange then
	local CurrentHitchance = Menu.PredictionSettings.CHit
	CastQ(Target)
	CastQ2(Target)
	end 


end
function Harass()
if not Target then return end
	if not Manaislowerthen(Menu.ManaSliderHarass) then
	
		if EReady and ecasting == false and GetDistance(Target) <= ERange then
		local CurrentHitchance = Menu.PredictionSettings.HHit
		CastE(Target)
		end 

	end
end

function CastE(unit)
	local pos, info = Prodiction.GetCircularAOEPrediction(unit, ERange, ESpeed, EDelay, ERadius, myPlayer)		
		if pos and info.hitchance >= CurrentHitchance then
			if Menu.PredictionSettings.Packets then
			Packet('S_CAST', {spellId = _E, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_E, pos.x, pos.z)
			end
		end
end 

function CastQ(unit)
	local pos, info = Prodiction.GetPrediction(unit, QRange, QSpeed, QDelay, QWidth, myPlayer)	
	local coll = Collision(QRange, QSpeed, QDelay, QWidthCol)					
		if pos and info.hitchance >= CurrentHitchance and not coll:GetMinionCollision(pos, myHero) then
			if Menu.PredictionSettings.Packets then
			Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_Q, pos.x, pos.z)
			end
		end
end 

function CastQ2(unit)
	local pos, info = Prodiction.GetPrediction(unit, QRange, QSpeed, QDelay, QWidth, myPlayer)	
	local collBoolean, collTable = LuxColl:GetMinionCollision(myHero, pos)
	if #collTable == 1 and GetDistance(collTable[1], unit) <= Menu.PredictionSettings.cllds then 			
		if pos and info.hitchance >= CurrentHitchance then
			if Menu.PredictionSettings.Packets then
			Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_Q, pos.x, pos.z)
			end
		end
	end
end 

function CastR(unit)
	local pos, info = Prodiction.GetPrediction(unit, RRange, RSpeed, RDelay, RWidth, myPlayer)	
				
		if pos and info.hitchance >= 3 then
			if Menu.PredictionSettings.Packets then
			Packet('S_CAST', {spellId = _R, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_R, pos.x, pos.z)
			end
		end
end 

function Autoult()
 	if not Target then return end
 	if RReady and GetDistance(Target) <= RRange then
		local boolean, rpos, rinfo = Prodiction.GetMinCountLineAOEPrediction(Menu.min2Ult, RRange, RSpeed, RDelay, RWidth, myPlayer)
		if boolean == true and rpos then
			if Menu.PredictionSettings.Packets and rinfo.hitchance >= 3 then
			Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end			
		end 
	end	
end

function Menu()

			Menu = scriptConfig(scriptname, scriptname)
			Menu:addSubMenu("[Prediction Options]", "PredictionSettings")
			Menu.PredictionSettings:addParam("CHit", "Combo Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
			Menu.PredictionSettings:addParam("HHit", "Harass Hitchance", SCRIPT_PARAM_SLICE, 3, 1, 3, 0)
			Menu.PredictionSettings:addParam("cllds", "Coll ignore Dist", SCRIPT_PARAM_SLICE, 250, 1, 350, 0)
			Menu.PredictionSettings:addParam("Packets","Packets Cast", SCRIPT_PARAM_ONOFF, true)
			Menu:addParam("blank1", "", SCRIPT_PARAM_INFO, "")
			Menu:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			Menu:addParam("Harass1","Harass 1", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			Menu:addParam("Harass2","Harass 2", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
			Menu:addParam("ManaSliderHarass", "Use mana in Harass till (%)",   SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
			--Menu:addParam("min2Ult", "Min amount of enemys for R", SCRIPT_PARAM_SLICE, 5, 1, 6, 0)
			Menu:addParam("blank2", "", SCRIPT_PARAM_INFO, "")
			Menu:addParam("SkinHack","Use Skin Hack", SCRIPT_PARAM_ONOFF, true)
			Menu:addParam("skin", "Skin Hack by Shalzuth:", SCRIPT_PARAM_LIST, 4, { "Sorceress", "Spellthief", "Commando", "Imperial", "Steel Legion", "No Skin" })
			Menu:addParam("blank3", "", SCRIPT_PARAM_INFO, "")
			Menu:addParam("about1", ""..scriptname.." v. "..version.."", SCRIPT_PARAM_INFO, "")
			Menu:addParam("about2", "by "..autor.."", SCRIPT_PARAM_INFO, "")
			ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, TSRange, DAMAGE_MAGIC)
			ts.name = "Target "
			Menu:addTS(ts)


end 

--[ Welcome ]--
function Welcome()
		if loading_text == false and os.clock() >= loading_text_start_delay+1 then
		PrintFloatText(myHero, 11, ""..scriptname..": v. "..version.." loaded!")
		loading_text = true
		end 
end 
--[ ---- ]--
--[ SKINHACK ]--
function SkinHack()
	if Menu.skin ~= lastSkin and VIP_USER then
		lastSkin = Menu.skin
		GenModelPacket(""..myHero.charName.."", Menu.skin)
	end
end
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
		p:Encode1(1)
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
--[ ---- ]--
function Manaislowerthen(percent)
    if myHero.mana < (myHero.maxMana * ( percent / 100)) then
        return true
    else
        return false
    end
end


function MyMana(spell)
	if spell == Q then
		return 40 + (10 * myHero:GetSpellData(_Q).level)
	elseif spell == E then
		return 55 + (15 * myHero:GetSpellData(_E).level)
	elseif spell == R then
		return 100
	elseif spell == EQ then
		return 40 + (10 * myHero:GetSpellData(_Q).level) + 55 + (15 * myHero:GetSpellData(_E).level)
	elseif spell == EQR then
		return 40 + (10 * myHero:GetSpellData(_Q).level) + 55 + (15 * myHero:GetSpellData(_E).level) + 100
	end
end	
