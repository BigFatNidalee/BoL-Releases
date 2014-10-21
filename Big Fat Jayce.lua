if myHero.charName ~= "Jayce" then return end
local version = "0.01"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL-Releases/master/Big Fat Jayce.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Big Fat Jayce.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Big Fat Jayce:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL-Releases/master/versions/bigfatjayce.version")
if ServerData then
ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
if ServerVersion then
if tonumber(version) < ServerVersion then
AutoupdaterMsg("New version available" ..ServerVersion)
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
local QRange, QSpeed, QDelay, QWidth = 1150, 1460, 0.200, 70
local QRange2, QSpeed2, QDelay2, QWidth2 = 1750, 1910, 0.200, 70

local ERange = 600
local qcaststart = 0
local qcast = false

local AARange = 560

local TSRange = 1800 
local autor = "Big Fat Corki"
local scriptname = "Big Fat Jayce"
local currentgapclose = {}
local currentqpos = {}
local currentgapclosestarttime = 0
local currentqpostime = 0
local loading_text = false 
local QHitPRO = 2
local QHitVPRE = 2

function OnLoad()
	require "Prodiction"
	require "Collision"
	require "VPrediction"
	VP = VPrediction()
	get_tables()
			Menu = scriptConfig(scriptname, scriptname)
			----------

			Menu:addSubMenu("[Prediction Options]", "PredictionSettings")
			Menu.PredictionSettings:addSubMenu("[Prodiction Settings]", "ProdictionSettings")
				Menu.PredictionSettings.ProdictionSettings:addParam("info0", "Combo", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.ProdictionSettings:addParam("QHitCOM", "Q Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
				Menu.PredictionSettings.ProdictionSettings:addParam("blank", "", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.ProdictionSettings:addParam("info1", "Harass", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.ProdictionSettings:addParam("QHitHAR", "Q Hitchance", SCRIPT_PARAM_SLICE, 3, 1, 3, 0)
				Menu.PredictionSettings.ProdictionSettings:addParam("blank2", "", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.ProdictionSettings:addParam("info1", "HITCHANCE:", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.ProdictionSettings:addParam("info2", "Faster <- LOW = 1  NORMAL = 2  HIGH = 3 -> Slower", SCRIPT_PARAM_INFO, "")	
			Menu.PredictionSettings:addSubMenu("[VPrediction Settings]", "VPredictionSettings")
				Menu.PredictionSettings.VPredictionSettings:addParam("info0", "Combo", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.VPredictionSettings:addParam("QHitCOM", "Q Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 2, 0)
				Menu.PredictionSettings.VPredictionSettings:addParam("blank", "", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.VPredictionSettings:addParam("info1", "Harass", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.VPredictionSettings:addParam("QHitHAR", "Q Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 2, 0)
				Menu.PredictionSettings.VPredictionSettings:addParam("blank2", "", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.VPredictionSettings:addParam("info1", "HITCHANCE:", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.VPredictionSettings:addParam("info2", "Faster <- LOW = 1  NORMAL = 2 -> Slower", SCRIPT_PARAM_INFO, "")	
				
			Menu.PredictionSettings:addParam("mode", "Current Prediction:", SCRIPT_PARAM_LIST, 1, {"Prodiction ", "VPrediction"})
			Menu.PredictionSettings:addParam("Packets","Packets Cast", SCRIPT_PARAM_ONOFF, true)		
			
			
			Menu:addSubMenu("[Antigapcloser]", "Antigapcloser")

				Menu.Antigapcloser:addParam("info", " ", SCRIPT_PARAM_INFO, "")
				
				
				-- antigap
				for i, enemy in ipairs(GetEnemyHeroes()) do
					for _, champ in pairs(SpellsDBAntigapclose) do
						if enemy.charName == champ.charName then
						table.insert(SpellsTOAntigapclose, {charName = champ.charName, description = champ.description, spellName = champ.spellName})
						end
					end
				end

				if #SpellsTOAntigapclose > 0 then
					for _, Antigap in pairs(SpellsTOAntigapclose) do

							Menu.Antigapcloser:addParam(Antigap.spellName, ""..Antigap.charName.. " | " ..Antigap.description.. " - " ..Antigap.spellName, SCRIPT_PARAM_ONOFF, true)
							
						
					end
				else	Menu.Antigapcloser:addParam("404no", "0 supported skills found =( ", SCRIPT_PARAM_INFO, "")	
				end		
			----------
			Menu:addSubMenu("[Harass]", "Harass")
			Menu.Harass:addParam("ManaSliderHarass", "Use mana in Harass till (%)",   SCRIPT_PARAM_SLICE, 40, 0, 100, 0)

			Menu:addParam("blank1", "", SCRIPT_PARAM_INFO, "")
			Menu:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			Menu:addParam("Harass1","Harass 1", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			Menu:addParam("Harass2","Harass 2", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
			
			

			Menu:addParam("about1", ""..scriptname.." v. "..version.."", SCRIPT_PARAM_INFO, "")
			Menu:addParam("about2", "by "..autor.."", SCRIPT_PARAM_INFO, "")
			ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, TSRange, DAMAGE_PHYSICAL)
			ts.name = "Target "
			Menu:addTS(ts)
				
		loading_text_start_delay = os.clock()
		PrintChat("<font color='#c9d7ff'>"..scriptname..": </font><font color='#64f879'> v. "..version.." </font><font color='#c9d7ff'> loaded, good luck! </font>")	

end 


function OnTick()
	ts:update()
	Target = ts.target
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	
	Q1 = (myHero:GetSpellData(_Q).name) == "jayceshockblast"
	Q2 = (myHero:GetSpellData(_Q).name) == "JayceToTheSkies"
	
	W1 = (myHero:GetSpellData(_W).name) == "jaycehypercharge"
	W2 = (myHero:GetSpellData(_W).name) == "JayceStaticField"
	
	E1 = (myHero:GetSpellData(_E).name) == "jayceaccelerationgate"
	E2 = (myHero:GetSpellData(_E).name) == "JayceThunderingBlow"
	
	SwitchTo2 = (myHero:GetSpellData(_R).name) == "jaycestancegth"
	SwitchTo1 = (myHero:GetSpellData(_R).name) == "JayceStanceHtG"
	
	
	Welcome()
	
	if not EReady then qcast = false end 

	if os.clock() >= qcaststart+1 then
	qcast = false
	end 
	
	AntigapcloserNextLvL()


	if ValidTarget(Target) then

		if Menu.Combo then 
		

			Q1ShortLong()
			
			if WReady and GetDistance(Target) <= AARange and W1 then
			CastSpell(_W,myHero)
			end 
						
			if GetDistance(Target) <= 500 then
			
				if SwitchTo2 then
					if RReady then
					CastSpell(_R,myHero)					
					end
				end 	
			
			end
			
			if SwitchTo1 and GetDistance(Target) <= 600 then
			blizhnijboj()
			end 

		end
		
			if qcast == true  and currentqpos[1] ~= nil and E1 and EReady then 
			local MaxEndPosition = myHero + (-1 * (Vector(myHero.x - currentqpos[1], 0, myHero.z - currentqpos[2]):normalized()*350))
			
			
				if Menu.PredictionSettings.Packets then
				Packet('S_CAST', {spellId = _E, toX = MaxEndPosition.x, toY = MaxEndPosition.z, fromX = MaxEndPosition.x, fromY = MaxEndPosition.z}):send(true)
				else 
				CastSpell(_E, MaxEndPosition.x, MaxEndPosition.z)
				end
				
			end 
		
		if Menu.Harass1 or Menu.Harass2 then 
			if not Manaislowerthen(Menu.Harass.ManaSliderHarass) then
			Q1ShortLong()
			end
		end
		
	if os.clock() >= currentqpostime+1 then
		currentqpos[1] = nil
		currentqpos[2] = nil

	end 
		if _G.AutoCarry ~= nil and os.clock() >= currentqpostime+0.5 then
		_G.AutoCarry.MyHero:MovementEnabled(true)
		end
	
	end 
	

end 


function Welcome()
		if loading_text == false and os.clock() >= loading_text_start_delay+1 then
		PrintFloatText(myHero, 11, ""..scriptname..": v. "..version.." loaded!")
		loading_text = true
		end 
end 

function blizhnijboj()
			
				if EReady and E2 and GetDistance(Target) <= 305 then
				
				
					if Menu.PredictionSettings.Packets then
					Packet("S_CAST", {spellId = _E, targetNetworkId = Target.networkID}):send()
					else 
					CastSpell(_E,Target)
					end
					
					
				end 
				
				if QReady and Q2 and GetDistance(Target) <= 600 then
					if Menu.PredictionSettings.Packets then
					Packet("S_CAST", {spellId = _Q, targetNetworkId = Target.networkID}):send()
					else 
					CastSpell(_Q,Target)
					end
				end 
				
				if WReady and W2 and GetDistance(Target) <= 280 then
				CastSpell(_W,myHero)
				end 

			
			if not QReady and not WReady and not EReady and RReady and SwitchTo1 then
			CastSpell(_R,myHero)
			end
			
			
end 

function Q1ShortLong()
		if GetDistance(Target) <= QRange2 and QReady and Q1 and EReady then
			

		
			if Menu.PredictionSettings.mode == 1 then
				if Menu.Harass1 or Menu.Harass2 then 
					local QHitPRO = Menu.PredictionSettings.ProdictionSettings.QHitHAR
					CastQ1LongPROD(Target)
				end
				if Menu.Combo then 
					local QHitPRO = Menu.PredictionSettings.ProdictionSettings.QHitCOM
					CastQ1LongPROD(Target)
				end
			end
			if Menu.PredictionSettings.mode == 2 then
				if Menu.Harass1 or Menu.Harass2 then 
					local QHitVPRE = Menu.PredictionSettings.VPredictionSettings.QHitHAR
					CastQ1LongVPRED(Target)
				end
				if Menu.Combo then 
					local QHitVPRE = Menu.PredictionSettings.VPredictionSettings.QHitCOM
					CastQ1LongVPRED(Target)
				end
				
			end
		
		
		end	
		if GetDistance(Target) <= QRange and QReady and Q1 and not EReady then
			if Menu.PredictionSettings.mode == 1 then
				if Menu.Harass1 or Menu.Harass2 then 
					local QHitPRO = Menu.PredictionSettings.ProdictionSettings.QHitHAR
					CastQ1ShortPROD(Target)
				end
				if Menu.Combo then 
					local QHitPRO = Menu.PredictionSettings.ProdictionSettings.QHitCOM
					CastQ1ShortPROD(Target)
				end
			end
			if Menu.PredictionSettings.mode == 2 then
				if Menu.Harass1 or Menu.Harass2 then 
					local QHitVPRE = Menu.PredictionSettings.VPredictionSettings.QHitHAR
					CastQ1ShortVPRED(Target)
				end
				if Menu.Combo then 
					local QHitVPRE = Menu.PredictionSettings.VPredictionSettings.QHitCOM
					CastQ1ShortVPRED(Target)
				end
			end
		end
end 

function CastQ1LongPROD(unit)

	local pos, info = Prodiction.GetPrediction(unit, QRange2, QSpeed2, QDelay2, QWidth2, myPlayer)	
	local coll = Collision(QRange2, QSpeed2, QDelay2, QWidth2)	

		if pos and info.hitchance >= QHitPRO and not coll:GetMinionCollision(pos, myHero) then
		currentqpos[1] = pos.x
		currentqpos[2] = pos.z
		currentqpostime = os.clock()	
		
			if Menu.PredictionSettings.Packets then
				if _G.AutoCarry ~= nil then 
				_G.AutoCarry.MyHero:MovementEnabled(false)
				Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
				else
				Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
				end
			else 
				if _G.AutoCarry ~= nil then 
				_G.AutoCarry.MyHero:MovementEnabled(false)
				CastSpell(_Q, pos.x, pos.z)
				else
				CastSpell(_Q, pos.x, pos.z)
				end
			end
			
		end

end 

function CastQ1LongVPRED(unit)

	local pos, info = VP:GetLineCastPosition(unit, QDelay2, QWidth2, QRange2, QSpeed2, myHero, true)		
		if pos and info >= QHitVPRE then
		currentqpos[1] = pos.x
		currentqpos[2] = pos.z
		currentqpostime = os.clock()
		
			if Menu.PredictionSettings.Packets then
				if _G.AutoCarry ~= nil then 
				_G.AutoCarry.MyHero:MovementEnabled(false)
				Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
				else
				Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
				end
			else 
				if _G.AutoCarry ~= nil then 
				_G.AutoCarry.MyHero:MovementEnabled(false)
				CastSpell(_Q, pos.x, pos.z)
				else
				CastSpell(_Q, pos.x, pos.z)
				end
			end
			
			
		end

end 
	
				
function CastQ1ShortPROD(unit)

	local pos, info = Prodiction.GetPrediction(unit, QRange, QSpeed, QDelay, QWidth, myPlayer)	
	local coll = Collision(QRange, QSpeed, QDelay, QWidth)	
		if pos and info.hitchance >= QHitPRO and not coll:GetMinionCollision(pos, myHero) then
		
		
			if Menu.PredictionSettings.Packets then
			Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_Q, pos.x, pos.z)
			end
		end

end 

function CastQ1ShortVPRED(unit)
	local pos, info = VP:GetLineCastPosition(unit, QDelay, QWidth, QRange, QSpeed, myHero, true)		
		if pos and info >= QHitVPRE then
			if Menu.PredictionSettings.Packets then
			Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_Q, pos.x, pos.z)
			end
		end
end


function OnProcessSpell(unit, spell)


	if spell.name == "jayceshockblast" then 
	qcaststart = os.clock()
	qcast = true
	end 
	
	-- Antigap
		if #SpellsTOAntigapclose > 0 then
			for _, Antigap in pairs(SpellsTOAntigapclose) do
				if spell.name == Antigap.spellName and not myHero.dead and not unit.dead and unit.team ~= myHero.team then
				
					if Menu.Antigapcloser[Antigap.spellName]  then		--and GetDistance(spell.endPos) <= 305
					currentgapclose[1] = unit.charName
					currentgapclosestarttime = os.clock()	
					end
					
					
				end

			end
		end

end 

function Manaislowerthen(percent)
    if myHero.mana < (myHero.maxMana * ( percent / 100)) then
        return true
    else
        return false
    end
end



function AntigapcloserNextLvL()
	for i = 1, #GetEnemyHeroes() do
	local enemy = GetEnemyHeroes()[i]
		if not enemy.dead and enemy.visible and ValidTarget(enemy) and enemy ~= nil then
		
		if currentgapclose[1] ~= nil then
			if currentgapclose[1] == enemy.charName then
			if E2 then
					if EReady and GetDistance(enemy) <= 600 then	
					CastSpell(_E, enemy)	

					currentgapclose[1] = nil
					end	
			else
					if EReady and RReady and GetDistance(enemy) <= 600 then	
					CastSpell(_R,myHero)
					CastSpell(_E, enemy)		

					currentgapclose[1] = nil
					end
			end

				
					
			end
		end 

		end
	end

	if os.clock() >= currentgapclosestarttime+2 then
	currentgapclose[1] = nil
	end
	
end 

function get_tables()

	SpellsTOAntigapclose = {}
	SpellsDBAntigapclose =
	{
	-- Antigapcloser
		{charName = "Aatrox", spellName = "AatroxQ", description = "Q"},
		{charName = "Corki", spellName = "CarpetBomb", description = "W"},
		{charName = "Diana", spellName = "DianaTeleport", description = "R"},
		{charName = "LeeSin", spellName = "blindmonkqtwo", description = "Q"},
		{charName = "Poppy", spellName = "PoppyHeroicCharge", description = "E"},
		{charName = "Shaco", spellName = "Deceive", description = "Q"},
		{charName = "JarvanIV", spellName = "JarvanIVDragonStrike", description = "Q"},
		{charName = "Fiora", spellName = "FioraQ", description = "Q"},
		{charName = "Leblanc", spellName = "LeblancSlide", description = "W"},
		{charName = "Leblanc", spellName = "leblacslidereturn", description = "W"},
		{charName = "Fizz", spellName = "FizzPiercingStrike", description = "Q"},
		{charName = "Amumu", spellName = "BandageToss", description = "Q"},
		{charName = "Gragas", spellName = "GragasE", description = "E"},
		{charName = "Irelia", spellName = "IreliaGatotsu", description = "Q"},
		{charName = "Alistar", spellName = "Headbutt", description = "W"},
		{charName = "Jax", spellName = "JaxLeapStrike", description = "Q"},
		{charName = "Khazix", spellName = "KhazixE", description = "E"},
		{charName = "Khazix", spellName = "khazixelong", description = "E"},
		{charName = "Braum", spellName = "BraumW", description = "W"},
		{charName = "Thresh", spellName = "threshqleap", description = "Q 2"},
		{charName = "Ahri", spellName = "AhriTumble", description = "R"},
		{charName = "Kassadin", spellName = "RiftWalk", description = "R"},
		{charName = "Tristana", spellName = "RocketJump", description = "W"},
		{charName = "Akali", spellName = "AkaliShadowDance", description = "R"},
		{charName = "Caitlyn", spellName = "CaitlynEntrapment", description = "E"},
		{charName = "Pantheon", spellName = "PantheonW", description = "W"},
		{charName = "Quinn", spellName = "QuinnE", description = "E"},
		{charName = "Renekton", spellName = "RenektonSliceAndDice", description = "E"},
		{charName = "Sejuani", spellName = "SejuaniArcticAssault", description = "Q"},
		{charName = "Shyvana", spellName = "ShyvanaTransformCast", description = "R"},
		{charName = "Tryndamere", spellName = "slashCast", description = "E"},
		{charName = "Vi", spellName = "ViQ", description = "Q"},
		{charName = "XinZhao", spellName = "XenZhaoSweep", description = "E"},
		{charName = "Yasuo", spellName = "YasuoDashWrapper", description = "E"},
		{charName = "Leona", spellName = "LeonaZenithBlade", description = "E"}
	}


end 

