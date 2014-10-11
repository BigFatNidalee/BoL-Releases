if myHero.charName ~= "Draven" then return end

local version = "0.02"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL-Releases/master/Big Fat Draven.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Big Fat Draven.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#66cc00\">Big Fat Draven.lua:</font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL-Releases/master/versions/Big Fat Draven.version")
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


local qcatchpositions = {}
local inrange = false
local aablock = false
local axesonhold = false
local possibleks = false

local loading_text = false 

local autor = "Big Fat Corki"
local scriptname = "Big Fat Draven"

local ERange, ERangeCut, ESpeed, EDelay, EWidth = 1100, 1000, 1.400, 251, 130
local RRange, RRangeCut, RSpeed, RDelay, RWidth = 10000, 2500, 2.000, 500, 160
local AARange = 615

local ecasted = false
local catchrange = 100
local aablockrange = 500
local spot1_start, spot2_start, spot3_start, spot4_start = 0, 0, 0, 0


local buffer_objektov = {}
local buffer_processov = {}

local spotscounter = 0

function OnLoad()
	get_tables()
	require "Prodiction"
	AddLoadCallback(function() Menu() end)
	--AdvancedCallback:bind('OnTowerFocus', function(tower, unit) OnTowerFocus(tower,unit) end)
	--AdvancedCallback:bind('OnTowerIdle', function(tower) OnTowerIdle(tower) end)
	loading_text_start_delay = os.clock()
	PrintChat("<font color='#c9d7ff'>"..scriptname..": </font><font color='#64f879'> v. "..version.." </font><font color='#c9d7ff'> loaded, good luck! </font>")	
end 

function OnCreateObj(object) 
	
        if object ~= nil and object.name ~= nil and object.x ~= nil and object.z ~= nil and GetDistance(myHero, object) <= 700 then
	
			if object.name:find("reticle_self.troy") then
			
				if qcatchpositions[1] == nil then
				qcatchpositions[1] = object.x
				qcatchpositions[2] = object.y
				qcatchpositions[3] = object.z
				qcatchpositions[4] = object	
				spot1_start = os.clock()
				elseif qcatchpositions[1] ~= nil and qcatchpositions[5] == nil then 
				qcatchpositions[5] = object.x
				qcatchpositions[6] = object.y
				qcatchpositions[7] = object.z
				qcatchpositions[8] = object	
				spot2_start = os.clock()
				elseif qcatchpositions[1] ~= nil and qcatchpositions[5] ~= nil and qcatchpositions[9] == nil then 
				qcatchpositions[9] = object.x
				qcatchpositions[10] = object.y
				qcatchpositions[11] = object.z
				qcatchpositions[12] = object
				spot3_start = os.clock()				
				elseif qcatchpositions[1] ~= nil and qcatchpositions[5] ~= nil and qcatchpositions[9] ~= nil and qcatchpositions[13] == nil then 	
				qcatchpositions[13] = object.x
				qcatchpositions[14] = object.y
				qcatchpositions[15] = object.z
				qcatchpositions[16] = object
				spot4_start = os.clock()				
				end 
				
	
			
			
			if GetDistance(myHero, object) <= aablockrange and inrange == false then
			aablock = true
			else 
			aablock = false
			end 
			
			
			
			end 

		end 
			
        
		if object.name == "draven_spinning_buff_end_sound.troy" then 
			qcatchpositions[1] = nil
			qcatchpositions[2] = nil
			qcatchpositions[3] = nil
			qcatchpositions[4] = nil	
			qcatchpositions[5] = nil
			qcatchpositions[6] = nil
			qcatchpositions[7] = nil
			qcatchpositions[8] = nil	
			qcatchpositions[9] = nil
			qcatchpositions[10] = nil
			qcatchpositions[11] = nil
			qcatchpositions[12] = nil
			qcatchpositions[13] = nil
			qcatchpositions[14] = nil	
			qcatchpositions[15] = nil
			qcatchpositions[16] = nil	
		end 
		
	if #ObjectsTOAntigapclose > 0 then
		for _, Antigapobjects in pairs(ObjectsTOAntigapclose) do
			
			
			if not myHero.dead then
			if GetDistance(object) <= ERangeCut and Menu.Antigapcloser[Antigapobjects.spellName] then
			
				if object.name == Antigapobjects.objectname then	
				buffer_objektov[1] = object.x
				buffer_objektov[2] = object.y
				buffer_objektov[3] = object.z
				buffer_objektov[4] = object.name
				
				ecasted = false
				
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
if object ~= nil and object.name ~= nil and object.x ~= nil and object.z ~= nil and GetDistance(myHero, object) <= 700 then
	if object.name:find("reticle_self.troy") then
		if qcatchpositions[1] ~= nil and qcatchpositions[4] == object then 
			qcatchpositions[1] = nil
			qcatchpositions[2] = nil
			qcatchpositions[3] = nil
			qcatchpositions[4] = nil	
		end 	
		
		if qcatchpositions[5] ~= nil and qcatchpositions[8] == object then 
			qcatchpositions[5] = nil
			qcatchpositions[6] = nil
			qcatchpositions[7] = nil
			qcatchpositions[8] = nil	
		end 
		
		if qcatchpositions[9] ~= nil and qcatchpositions[12] == object then 
			qcatchpositions[9] = nil
			qcatchpositions[10] = nil
			qcatchpositions[11] = nil
			qcatchpositions[12] = nil	
		end 	
		
		if qcatchpositions[13] ~= nil and qcatchpositions[16] == object then 
			qcatchpositions[13] = nil
			qcatchpositions[14] = nil
			qcatchpositions[15] = nil
			qcatchpositions[16] = nil	
		end 	
	end 		
end 


	if #ObjectsTOAntigapclose > 0 then
		for _, Antigapobjects in pairs(ObjectsTOAntigapclose) do
			
			
			if not myHero.dead then
			if GetDistance(object) <= ERangeCut * 2  and Menu.Antigapcloser[Antigapobjects.spellName] then
			
				if object.name == Antigapobjects.objectname then
				buffer_objektov[1] = nil
				buffer_objektov[2] = nil
				buffer_objektov[3] = nil
				buffer_objektov[4] = nil
				end
				
			end
			end
			
			if myHero.dead then
				buffer_objektov[1] = nil
				buffer_objektov[2] = nil
				buffer_objektov[3] = nil
				buffer_objektov[4] = nil
			end 
			
			
		end
	end



end 
function secondchecker()


		if qcatchpositions[1] ~= nil and os.clock() >= spot1_start + 10.0 then 
			qcatchpositions[1] = nil
			qcatchpositions[2] = nil
			qcatchpositions[3] = nil
			qcatchpositions[4] = nil	
		end 

		if qcatchpositions[5] ~= nil and os.clock() >= spot2_start + 10.0 then 
			qcatchpositions[5] = nil
			qcatchpositions[6] = nil
			qcatchpositions[7] = nil
			qcatchpositions[8] = nil	
		end 

		if qcatchpositions[9] ~= nil and os.clock() >= spot3_start + 10.0 then 
			qcatchpositions[9] = nil
			qcatchpositions[10] = nil
			qcatchpositions[11] = nil
			qcatchpositions[12] = nil
		end 

		if qcatchpositions[13] ~= nil and os.clock() >= spot4_start + 10.0 then 
			qcatchpositions[13] = nil
			qcatchpositions[14] = nil
			qcatchpositions[15] = nil
			qcatchpositions[16] = nil	
		end 		
			

end 

function catchaxes()

if axesonhold == false then
		
		if qcatchpositions[1] ~= nil then 
			if GetDistance(myHero, qcatchpositions[4]) <= catchrange then
			inrange = true
			else 
			inrange = false
			myHero:MoveTo(qcatchpositions[1],qcatchpositions[3])
			end	
		end 		
		
		if qcatchpositions[5] ~= nil then 
			if GetDistance(myHero, qcatchpositions[8]) <= catchrange then
			inrange = true
			else 
			inrange = false
			myHero:MoveTo(qcatchpositions[5],qcatchpositions[7])
			end	
		end 	
		
		if qcatchpositions[9] ~= nil then 
			if GetDistance(myHero, qcatchpositions[12]) <= catchrange then
			inrange = true
			else 
			inrange = false
			myHero:MoveTo(qcatchpositions[9],qcatchpositions[11])
			end	
		end 		
		
		if qcatchpositions[13] ~= nil then 
			if GetDistance(myHero, qcatchpositions[16]) <= catchrange then
			inrange = true
			else 
			inrange = false
			myHero:MoveTo(qcatchpositions[13],qcatchpositions[15])
			end	
		end 		


		
	
end 
	
	
	if myHero.dead or axesonhold == true then 
			qcatchpositions[1] = nil
			qcatchpositions[2] = nil
			qcatchpositions[3] = nil
			qcatchpositions[4] = nil	
			qcatchpositions[5] = nil
			qcatchpositions[6] = nil
			qcatchpositions[7] = nil
			qcatchpositions[8] = nil	
			qcatchpositions[9] = nil
			qcatchpositions[10] = nil
			qcatchpositions[11] = nil
			qcatchpositions[12] = nil
			qcatchpositions[13] = nil
			qcatchpositions[14] = nil	
			qcatchpositions[15] = nil
			qcatchpositions[16] = nil	
	end

end 


function OnTick()

	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	Antigapcloser()
	Welcome()
	secondchecker()
	ks()
	if not myHero.dead then
		if Menu.Combo or Menu.Harass1 or Menu.Harass2 then
		catchaxes()
		end
		if Menu.Combo then 
		combo()
		end 
	end
		
end 

function ks()
	for i = 1, #GetEnemyHeroes() do
	local enemy = GetEnemyHeroes()[i]
		if not enemy.dead and enemy.visible and ValidTarget(enemy) and enemy ~= nil and not myHero.dead then
		
			if ValidTarget(enemy, 1100) and enemy.health < 200 then
			axesonhold = true
			else
			axesonhold = false
			end 		
			
			
			if EReady and Menu.KSOptions.KSwithE and ValidTarget(enemy, ERangeCut) and enemy.health < getDmg("E",enemy,myHero) then

				local pos, info = Prodiction.GetPrediction(enemy, ERange, ESpeed, EDelay, EWidth, myPlayer)		
					if pos and info.hitchance >= 2 then
					--Packet('S_CAST', {spellId = _E, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
					CastSpell(_E, pos.x, pos.z)
					end

			end 
			
			if RReady and Menu.KSOptions.KSwithR and ValidTarget(enemy, RRangeCut) and enemy.health < getDmg("R",enemy,myHero) then

				local pos, info = Prodiction.GetPrediction(enemy, RRange, RSpeed, RDelay, RWidth, myPlayer)		
					if pos and info.hitchance >= 2 then
					--Packet('S_CAST', {spellId = _R, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
					CastSpell(_R, pos.x, pos.z)
					end

			end 	
			
			if RReady and EReady and Menu.KSOptions.KSwithR and Menu.KSOptions.KSwithE and ValidTarget(enemy, ERangeCut) and enemy.health < getDmg("R",enemy,myHero) + getDmg("E",enemy,myHero) -10 then

				local rpos, rinfo = Prodiction.GetPrediction(enemy, RRange, RSpeed, RDelay, RWidth, myPlayer)
				local epos, einfo = Prodiction.GetPrediction(enemy, ERange, ESpeed, EDelay, EWidth, myPlayer)	
				
					if rpos and epos and rinfo.hitchance >= 2 and einfo.hitchance >= 2 then
					--Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
					--Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
					CastSpell(_E, epos.x, epos.z)
					CastSpell(_R, rpos.x, rpos.z)
					end

			end 
			
			if Menu.KSOptions.KSwithAA and ValidTarget(enemy, AARange) and enemy.health < getDmg("AD",enemy,myHero) then
			myHero:Attack(enemy)
			end	
			
		else
		axesonhold = false
		end 
	end 
end 

function combo()

	for i = 1, #GetEnemyHeroes() do
	local enemy = GetEnemyHeroes()[i]
		if not enemy.dead and enemy.visible and ValidTarget(enemy) and enemy ~= nil and not myHero.dead then
		
		
			if EReady and ValidTarget(enemy, ERangeCut) then

				local pos, info = Prodiction.GetPrediction(enemy, ERange, ESpeed, EDelay, EWidth, myPlayer)		
					if pos and info.hitchance >= 2 then
					--Packet('S_CAST', {spellId = _E, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
					CastSpell(_E, pos.x, pos.z)
					end

			end 

		end 
	end 
end 



function Menu()
		Menu = scriptConfig(scriptname, scriptname)		
		--
		
		
		Menu:addSubMenu("[Interrupter]", "Int")
		Menu.Int:addParam("interrupterdebug","Interrupter Debug", SCRIPT_PARAM_ONOFF, true)
		Menu.Int:addParam("info", " ", SCRIPT_PARAM_INFO, "")
			-- interrupter
		for i, enemy in ipairs(GetEnemyHeroes()) do
			for _, champ in pairs(SpellsDBInterrupt) do
				if enemy.charName == champ.charName then
				table.insert(SpellsTOInterrupt, {charName = champ.charName, description = champ.description, spellName = champ.spellName, endposcast = champ.endposcast})
				end
			end
		end

		if #SpellsTOInterrupt > 0 then
			for _, Inter in pairs(SpellsTOInterrupt) do
					Menu.Int:addParam(Inter.spellName, ""..Inter.charName.. " | " ..Inter.description.. " - " ..Inter.spellName, SCRIPT_PARAM_ONOFF, true)
					Menu.Int:addParam("info", " ", SCRIPT_PARAM_INFO, "")
			
			end
		else	Menu.Int:addParam("404", "0 supported skills found =( ", SCRIPT_PARAM_INFO, "")	
		end
		
	Menu:addSubMenu("[Antigapcloser]", "Antigapcloser")
		Menu.Antigapcloser:addParam("Antigapcloserdebug","Antigapcloser Debug", SCRIPT_PARAM_ONOFF, true)
		Menu.Antigapcloser:addParam("info", " ", SCRIPT_PARAM_INFO, "")
		
		for i, enemy in ipairs(GetEnemyHeroes()) do
			for _, champ in pairs(ObjectsDBAntigapclose) do
				if enemy.charName == champ.charName then
				table.insert(ObjectsTOAntigapclose, {charName = champ.charName, description = champ.description, spellName = champ.spellName, endposcast = champ.endposcast, objectname = champ.objectname})
				end
			end
		end
		
		
		if #ObjectsTOAntigapclose > 0 then
			for _, Antigapobjects in pairs(ObjectsTOAntigapclose) do

					Menu.Antigapcloser:addParam(Antigapobjects.spellName, ""..Antigapobjects.charName.. " | " ..Antigapobjects.description.. " - " ..Antigapobjects.spellName, SCRIPT_PARAM_ONOFF, true)	
					Menu.Antigapcloser:addParam("info", " ", SCRIPT_PARAM_INFO, "")
				
			end
		else	Menu.Antigapcloser:addParam("404noo", "0 supported objects found =( ", SCRIPT_PARAM_INFO, "")	
		end
		
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

					Menu.Antigapcloser:addParam(Antigap.spellName, ""..Antigap.charName.. " | " ..Antigap.description.. " - " ..Antigap.spellName, SCRIPT_PARAM_ONOFF, true)
						
						if Antigap.endposcast == true then 
						Menu.Antigapcloser:addParam(Antigap.spellName..3, "Cast to: ", SCRIPT_PARAM_LIST, 2, { "Start Position", "End Position" })
						elseif Antigap.endposcast == false then
						Menu.Antigapcloser:addParam(Antigap.spellName..3, "Cast to: ", SCRIPT_PARAM_LIST, 1, { "Start Position", "End Position" })
						end
					Menu.Antigapcloser:addParam("info", " ", SCRIPT_PARAM_INFO, "")
				
			end
		else	Menu.Antigapcloser:addParam("404no", "0 supported processes found =( ", SCRIPT_PARAM_INFO, "")	
		end
		--

		Menu:addSubMenu("[KS Options]", "KSOptions")
		
			Menu.KSOptions:addParam("KSwithAA","KS with AA", SCRIPT_PARAM_ONOFF, true)
			Menu.KSOptions:addParam("KSwithE","KS with E", SCRIPT_PARAM_ONOFF, true)
			Menu.KSOptions:addParam("KSwithR","KS with R", SCRIPT_PARAM_ONOFF, true)
			
		Menu:addSubMenu("[Draws]", "Draws")
			--Menu.Draws:addParam("KillAnnouncer","Kill Announcer", SCRIPT_PARAM_ONOFF, true)
			Menu.Draws:addParam("AxeStatus","Axes Status", SCRIPT_PARAM_ONOFF, true)


		Menu:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Menu:addParam("Harass1","Harass 1", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
		Menu:addParam("Harass2","Harass 2", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		
		Menu:addParam("blank", "", SCRIPT_PARAM_INFO, "")
		Menu:addParam("about1", ""..scriptname.." v. "..version.."", SCRIPT_PARAM_INFO, "")
		Menu:addParam("about2", "by "..autor.."", SCRIPT_PARAM_INFO, "")

end 

function Antigapcloser()
	
	if buffer_objektov[4] ~= nil and EReady and ecasted == false and not myHero.dead then	
	--Packet("S_CAST", {spellId = _E, fromX =  buffer_objektov[1], fromY =  buffer_objektov[3], toX =  buffer_objektov[1], toY =  buffer_objektov[3]}):send()	
	CastSpell(_E, buffer_objektov[1], buffer_objektov[3])
	ecasted = true
	end 

end 

function OnProcessSpell(unit, spell)


	-- Antigap
		if #SpellsTOAntigapclose > 0 then
			for _, Antigap in pairs(SpellsTOAntigapclose) do
				if spell.name == Antigap.spellName and not myHero.dead and not unit.dead and unit.team ~= myHero.team then
					if Menu.Antigapcloser[Antigap.spellName] and EReady and GetDistance(spell.endPos) <= ERangeCut then
					
						if Menu.Antigapcloser[Antigap.spellName..3] == 1 then
						CastSpell(_E, spell.startPos.x,spell.startPos.z)
							--Packet("S_CAST", {spellId = _E, fromX =  spell.startPos.x, fromY =  spell.startPos.z, toX =  spell.startPos.x, toY =  spell.startPos.z}):send()
							PrintChat("Antigapcloser: Tried to interrupt with E: " ..Antigap.charName.. " | " ..Antigap.description.. " - " ..Antigap.spellName)
						elseif Menu.Antigapcloser[Antigap.spellName..3] == 2 then
						CastSpell(_E, spell.endPos.x,spell.endPos.z)
							--Packet("S_CAST", {spellId = _E, fromX =  spell.endPos.x, fromY =  spell.endPos.z, toX =  spell.endPos.x, toY =  spell.endPos.z}):send()
							PrintChat("Antigapcloser: Tried to interrupt with E: " ..Antigap.charName.. " | " ..Antigap.description.. " - " ..Antigap.spellName)
						end
						

					end
				end

			end
		end
		

		
	----------
	-- Interrupter
		if #SpellsTOInterrupt > 0 then
			for _, Inter in pairs(SpellsTOInterrupt) do
				if spell.name == Inter.spellName and not myHero.dead and not unit.dead and unit.team ~= myHero.team then
					if Menu.Int[Inter.spellName] and EReady and GetDistance(unit) <= ERangeCut and unit.visible then
				
							--Packet("S_CAST", {spellId = _E, fromX =  unit.x, fromY =  unit.z, toX =  unit.x, toY =  unit.z}):send()
							CastSpell(_E, unit.x, unit.z)
	
							if Menu.Int.interrupterdebug then PrintChat("Tried to interrupt with E: " ..Inter.charName.. " | " ..Inter.description.. " - " ..Inter.spellName) end
							
					end
					

				end
				
				
				
			end
		end
	----------
        if (spell.name:find("ChaosTurret") and myHero.team == TEAM_BLUE) or (spell.name:find("OrderTurret") and myHero.team == TEAM_RED) then

                if GetDistance(spell.endPos, myHero)<80 then
				axesonhold = true
				else 
				axesonhold = false
				end

		end
	
		
end
--[[
function OnTowerFocus(tower, unit) 

    if unit.isMe then
	axesonhold = true
    end

end

function OnTowerIdle(tower) 

	axesonhold = false

end
]]--
	function Welcome()
		if loading_text == false and os.clock() >= loading_text_start_delay+1 then
		PrintFloatText(myHero, 11, ""..scriptname..": v. "..version.." loaded!")
		loading_text = true
		end 
	end 
	
function OnDraw()
	if not myHero.dead then 
	if Menu.Draws.AxeStatus then
		if Menu.Combo or Menu.Harass1 or Menu.Harass2 then
			if axesonhold == true then 
			DrawText3D(tostring("catch axes: blocked"), myHero.x, myHero.y, myHero.z, 16, ARGB(255, 255, 0, 0), true)
			elseif axesonhold == false then 
			DrawText3D(tostring("catch axes: active"), myHero.x, myHero.y, myHero.z, 16, ARGB(255, 255, 255, 0), true)
			end 
		end
		
		if not Menu.Combo and not Menu.Harass1 and not Menu.Harass2 then
			DrawText3D(tostring("catch axes: standby"), myHero.x, myHero.y, myHero.z, 16, ARGB(255, 133, 165, 200), true)
		end
		
	end 	

	
	end 
	
end 


function OnSendPacket(p)
	if qcatchpositions[1] ~= nil then 
	
		if inrange == true and axesonhold == false then
		  if p.header == S_MOVE and p:get("type") == 2 then
		  p:block() 
		  end
		end 
		
		if aablock == true and inrange == false and axesonhold == false then
			if p.header == S_MOVE and p:get("type") == 3 then
			 p:block() 
			end
		end 
		-- 2 move, 3 aa
		
	end
end

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
		
		
		
		
end 
