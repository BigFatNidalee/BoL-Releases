if myHero.charName ~= "Jayce" then return end
local version = "0.04"
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
--Ranged:
local QRangeS, QSpeedS, QDelayS, QWidthS = 1150, 1460, 0.200, 70
local QRangeL, QSpeedL, QDelayL, QWidthL = 1750, 2300, 0.200, 70
--Meele:
local QRange2, WRange2, ERange2 = 600, 285, 240


local AARange = 560

local TSRange = 1800 
local autor = "Big Fat Corki"
local scriptname = "Big Fat Jayce"
local currentgapclose = {}

local currentgapclosestarttime = 0

local loading_text = false 
local QHitPRO = 2
local QHitVPRE = 2

local EQBlock = false
local currentqpos = {}
local currentqpostime = 0

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
			Menu:addSubMenu("[Combo]", "ComboMenu")
			Menu.ComboMenu:addParam("autoswap","Auto Swap", SCRIPT_PARAM_ONOFF, true)
			Menu.ComboMenu:addParam("mcombo", "Current Meele Combo Priority:", SCRIPT_PARAM_LIST, 2, {"QWE", "EQW"})			

			Menu:addSubMenu("[Harass]", "Harass")
			Menu.Harass:addParam("ManaSliderHarass", "Use mana in Harass till (%)",   SCRIPT_PARAM_SLICE, 40, 0, 100, 0)

			Menu:addParam("blank1", "", SCRIPT_PARAM_INFO, "")
			Menu:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			Menu:addParam("EQ2Mouse","EQ to Mouse", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("S"))
			Menu:addParam("Harass1","Harass 1", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			Menu:addParam("Harass2","Harass 2", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
			
			Menu:addParam("blank", "", SCRIPT_PARAM_INFO, "")
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
	jaycetslogic()
	
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
	AntigapcloserNextLvL()
	
	korzina()
	castQErangedAddE()

	if ValidTarget(Target) then

		if Menu.Combo then
			--ranged
			if SwitchTo2 then
				if QReady and Q1 and EReady and E1 then
					if GetDistance(Target) <= QRangeL then
						if Menu.PredictionSettings.mode == 1 then
						local QHitPRO = Menu.PredictionSettings.ProdictionSettings.QHitCOM
						castQEranged(Target)
						end
						if Menu.PredictionSettings.mode == 2 then
						local QHitVPRE = Menu.PredictionSettings.VPredictionSettings.QHitCOM
						castQErangedVpred(Target)
						end
					--cast QE aka Long
					end 
				end
				if QReady and Q1 and not EReady then
					if GetDistance(Target) <= QRangeS then
						if Menu.PredictionSettings.mode == 1 then
						local QHitPRO = Menu.PredictionSettings.ProdictionSettings.QHitCOM
						castQranged(Target)
						end
						if Menu.PredictionSettings.mode == 2 then
						local QHitVPRE = Menu.PredictionSettings.VPredictionSettings.QHitCOM
						castQrangedVpred(Target)
						end
					--cast Q aka Short
					end
				end
				if WReady and W1 then
					if GetDistance(Target) <= AARange + 50 then
						if Menu.PredictionSettings.Packets then
						Packet("S_CAST", {spellId = _W, targetNetworkId = Target.networkID}):send()
						else
						CastSpell(_W,Target)
						end
					-- some logic then cast w
					end 
				end 
				if Menu.ComboMenu.autoswap then
					if not QReady and not WReady and not EReady and RReady then
					
						if Menu.ComboMenu.mcombo == 1 then
							if GetDistance(Target) <= QRange2 then
								if Menu.PredictionSettings.Packets then
								Packet("S_CAST", {spellId = _R, targetNetworkId = myHero.networkID}):send()
								else
								CastSpell(_R,myHero)
								end
							--r
							end 
						end
						
						if Menu.ComboMenu.mcombo == 2 then
							if GetDistance(Target) <= 450 then
								if Menu.PredictionSettings.Packets then
								Packet("S_CAST", {spellId = _R, targetNetworkId = myHero.networkID}):send()
								else
								CastSpell(_R,myHero)
								end
							--r
							end 
						end
							
						
					-- check all stuff then swap
					end 
				end 
			end 
			--				
			-- meele
			if SwitchTo1 then
				if Menu.ComboMenu.mcombo == 1 then
				--QWE
					if QReady and Q2 then
						if GetDistance(Target) <= QRange2 then
							if Menu.PredictionSettings.Packets then
							Packet("S_CAST", {spellId = _Q, targetNetworkId = Target.networkID}):send()
							else
							CastSpell(_Q,Target)
							end
						end 
					--cast q
					end 
					if WReady and W2 then
						if GetDistance(Target) <= WRange2 then
							if Menu.PredictionSettings.Packets then
							Packet("S_CAST", {spellId = _W, targetNetworkId = myHero.networkID}):send()
							else
							CastSpell(_W,myHero)
							end
						end 
					--cast w
					end 
					if EReady and E2 then
						if GetDistance(Target) <= ERange2 then
							if Menu.PredictionSettings.Packets then
							Packet("S_CAST", {spellId = _E, targetNetworkId = Target.networkID}):send()
							else
							CastSpell(_E,Target)
							end
						end 
					--cast e
					end 
					
					if Menu.ComboMenu.autoswap then
						if not QReady and not WReady and not EReady and RReady then
							if Menu.PredictionSettings.Packets then
							Packet("S_CAST", {spellId = _R, targetNetworkId = myHero.networkID}):send()
							else
							CastSpell(_R,myHero)
							end
						end 
					-- check all stuff then swap
					end 			
				end 
				if Menu.ComboMenu.mcombo == 2 then
				--EQW
					if EReady and E2 then
						if GetDistance(Target) <= ERange2 then
							if Menu.PredictionSettings.Packets then
							Packet("S_CAST", {spellId = _E, targetNetworkId = Target.networkID}):send()
							else
							CastSpell(_E,Target)
							end
						end 
					--cast e
					end 
					if QReady and Q2 then
						if GetDistance(Target) <= QRange2 then
							if Menu.PredictionSettings.Packets then
							Packet("S_CAST", {spellId = _Q, targetNetworkId = Target.networkID}):send()
							else
							CastSpell(_Q,Target)
							end
						end 
					--cast q
					end 
					if WReady and W2 then
						if GetDistance(Target) <= WRange2 then
							if Menu.PredictionSettings.Packets then
							Packet("S_CAST", {spellId = _W, targetNetworkId = myHero.networkID}):send()
							else
							CastSpell(_W,myHero)
							end
						end 
					--cast w
					end 
					
					if Menu.ComboMenu.autoswap then
						if not QReady and not WReady and not EReady and RReady then
							if Menu.PredictionSettings.Packets then
							Packet("S_CAST", {spellId = _R, targetNetworkId = myHero.networkID}):send()
							else
							CastSpell(_R,myHero)
							end
						end 
					-- check all stuff then swap
					end 				
				end 
			end 
			--
		end
		

		if Menu.Harass1 or Menu.Harass2 then 
		if not Manaislowerthen(Menu.Harass.ManaSliderHarass) then
			--ranged
			if SwitchTo2 then
				if QReady and Q1 and EReady and E1 then
					if GetDistance(Target) <= QRangeL then
						if Menu.PredictionSettings.mode == 1 then
						local QHitPRO = Menu.PredictionSettings.ProdictionSettings.QHitHAR
						castQEranged(Target)
						end
						if Menu.PredictionSettings.mode == 2 then
						local QHitVPRE = Menu.PredictionSettings.VPredictionSettings.QHitHAR
						castQErangedVpred(Target)
						end
					--cast QE aka Long
					end 
				end
				if QReady and Q1 and not EReady then
					if GetDistance(Target) <= QRangeS then
						if Menu.PredictionSettings.mode == 1 then
						local QHitPRO = Menu.PredictionSettings.ProdictionSettings.QHitHAR
						castQranged(Target)
						end
						if Menu.PredictionSettings.mode == 2 then
						local QHitVPRE = Menu.PredictionSettings.VPredictionSettings.QHitHAR
						castQrangedVpred(Target)
						end
					--cast Q aka Short
					end
				end
			end 
		end
		end
	
	end 
	
		if Menu.EQ2Mouse then 
			--ranged
			if SwitchTo2 then
				if QReady and Q1 and EReady and E1 then
				castQErangedToMouse()
				--cast QE aka Long to mouse
				end
			end 
		end 
	

end 

function OnSendPacket(p)
	if EQBlock == true then
		if p.header == Packet.headers.S_MOVE then
		p:Block() 
		end 
		
		if os.clock() >= currentqpostime+0.5 then
		EQBlock = false 
		currentqpostime = 0
		end 
	end 
end



function korzina()

	if myHero.dead then
	currentgapclose[1] = nil
	
	EQBlock = false 
	currentqpos[1] = nil
	currentqpos[2] = nil
	currentqpostime = 0
	end 
	
	if os.clock() >= currentqpostime+1 then
		currentqpos[1] = nil
		currentqpos[2] = nil
		EQBlock = false
	end 
	
	if os.clock() >= currentqpostime+0.5 then
		EQBlock = false
		currentqpostime = 0
	end 
	
	if not EReady and E1 then
		EQBlock = false
		currentqpostime = 0
	end 
	
end 

function jaycetslogic()
	if SwitchTo2 then
		if QReady and Q1 and EReady and E1 then
		TSRange = QRangeL
		end
		
		if QReady and Q1 and not EReady then
		TSRange = QRangeS
		end
	end
	if SwitchTo1 then
		TSRange = 900
	end
end 


function castQEranged(unit)
	local pos, info = Prodiction.GetPrediction(unit, QRangeL, QSpeedL, QDelayL, QWidthL, myPlayer)	
	local coll = Collision(QRangeL, QSpeedL, QDelayL, QWidthL)	

		if pos and info.hitchance >= QHitPRO and not coll:GetMinionCollision(pos, myHero) then
		currentqpos[1] = pos.x
		currentqpos[2] = pos.z
		currentqpostime = os.clock()
		EQBlock = true		
		
			if Menu.PredictionSettings.Packets then
			Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_Q, pos.x, pos.z)
			end
			
		end
end 

function castQErangedVpred(unit)
	local pos, info = VP:GetLineCastPosition(unit, QDelayL, QWidthL, QRangeL, QSpeedL, myHero, true)		
		if pos and info >= QHitVPRE then
		currentqpos[1] = pos.x
		currentqpos[2] = pos.z
		currentqpostime = os.clock()
		EQBlock = true	
		
			if Menu.PredictionSettings.Packets then
			Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_Q, pos.x, pos.z)
			end
			
			
		end
end 


function castQErangedAddE()

	if currentqpos[1] ~= nil and E1 and EReady then 
		local MyEpos = myHero + (-1 * (Vector(myHero.x - currentqpos[1], 0, myHero.z - currentqpos[2]):normalized()*350))
			
		if Menu.PredictionSettings.Packets then
		Packet('S_CAST', {spellId = _E, toX = MyEpos.x, toY = MyEpos.z, fromX = MyEpos.x, fromY = MyEpos.z}):send(true)
		else 
		CastSpell(_E, MyEpos.x, MyEpos.z)
		end
		
	end 
	

end 

function castQErangedToMouse()
	local MyEpos = myHero + (-1 * (Vector(myHero.x - mousePos.x, 0, myHero.z - mousePos.z):normalized()*350))
		currentqpostime = os.clock()
		EQBlock = true		
	if Menu.PredictionSettings.Packets then
	Packet('S_CAST', {spellId = _Q, toX = mousePos.x, toY = mousePos.z, fromX = mousePos.x, fromY = mousePos.z}):send(true)
	Packet('S_CAST', {spellId = _E, toX = MyEpos.x, toY = MyEpos.z, fromX = MyEpos.x, fromY = MyEpos.z}):send(true)
	else 
	CastSpell(_Q, mousePos.x, mousePos.z)
	CastSpell(_E, MyEpos.x, MyEpos.z)
	end
		
end 

function castQranged(unit)
	local pos, info = Prodiction.GetPrediction(unit, QRangeS, QSpeedS, QDelayS, QWidthS, myPlayer)	
	local coll = Collision(QRangeS, QSpeedS, QDelayS, QWidthS)	

		if pos and info.hitchance >= QHitPRO and not coll:GetMinionCollision(pos, myHero) then
		
			if Menu.PredictionSettings.Packets then
			Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_Q, pos.x, pos.z)
			end
			
		end
end 


function castQrangedVpred(unit)
	local pos, info = VP:GetLineCastPosition(unit, QDelayS, QWidthS, QRangeS, QSpeedS, myHero, true)		
		if pos and info >= QHitVPRE then
		
			if Menu.PredictionSettings.Packets then
			Packet('S_CAST', {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_Q, pos.x, pos.z)
			end
			
			
		end
end 






function Welcome()
		if loading_text == false and os.clock() >= loading_text_start_delay+1 then
		PrintFloatText(myHero, 11, ""..scriptname..": v. "..version.." loaded!")
		loading_text = true
		end 
end 
function OnProcessSpell(unit, spell)
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

