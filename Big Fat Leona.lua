if myHero.charName ~= "Leona" then return end

local AUTOUPDATE = true
local version = "0.02"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL-Releases/master/Big Fat Leona.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Big Fat Leona.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Big Fat Leona:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL-Releases/master/versions/BigFatLeona.version")
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

local ERange, ESpeed, EDelay, EWidth = 900, 2000, 0.250, 85
local RRange, RSpeed, RDelay, RWidth = 1200, math.huge, 0.250, 300

local whitelistrange = 1200

local autor = "Big Fat Corki"
local scriptname = "Big Fat Private Series: Leona"

function OnLoad()
--require "Prodiction"
require "VPrediction"
VP = VPrediction()
corki_harass_tables()
			Menu = scriptConfig(scriptname, scriptname)
			
			Menu:addParam("EHit", "E Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 2, 0)
			Menu:addParam("RHit", "R Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 2, 0)
			Menu:addParam("Packets","Packets Cast", SCRIPT_PARAM_ONOFF, false)
			Menu:addParam("blank1", "", SCRIPT_PARAM_INFO, "")
			Menu:addParam("CastE","Cast E", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			Menu:addParam("CastR","Cast R", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Y"))
			
			Menu:addParam("harassinfo", "Harass White List:", SCRIPT_PARAM_INFO, "")		
		for i = 1, #GetEnemyHeroes() do
		local enemy = GetEnemyHeroes()[i]
			if whitelisted[""..enemy.charName..""] == true then 
			Menu:addParam(enemy.hash, enemy.charName, SCRIPT_PARAM_ONOFF, true)
			end 		
			if whitelisted[""..enemy.charName..""] == nil then
			Menu:addParam(enemy.hash, enemy.charName, SCRIPT_PARAM_ONOFF, false)
			end 
		end 

			Menu:addParam("about1", ""..scriptname.." v. "..version.."", SCRIPT_PARAM_INFO, "")
			Menu:addParam("about2", "by "..autor.."", SCRIPT_PARAM_INFO, "")
			ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, RRange, DAMAGE_MAGIC)
			ts.name = "Target "
			Menu:addTS(ts)

end 


function OnTick()
	ts:update()
	Target = ts.target
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	
	if ValidTarget(Target) then
		if Menu.CastE then 
			for i = 1, #GetEnemyHeroes() do
			local enemy = GetEnemyHeroes()[i]
				if Menu[enemy.hash] then
				
					if GetDistance(enemy) <= whitelistrange and not enemy.dead and enemy.visible then
					if GetDistance(enemy) <= 780 then
					CastE(enemy)
					end
						if QReady and GetDistance(enemy) <= 155 then
						CastSpell(_Q,myHero)
						myHero:Attack(enemy)
						end
					else
						if enemy.dead or not enemy.visible or Menu[enemy.hash] == nil then
						if GetDistance(Target) <= 780 then
						CastE(Target)
						end
							if QReady and GetDistance(Target) <= 155 then
							CastSpell(_Q,myHero)
							myHero:Attack(Target)
							end
						end
					end
				end
			end 
		
		--CastE(Target)
		end
		if Menu.CastR then 
		CastR(Target)
		end
	
	end 
	

end 

--[[
function CastR(unit)
	local pos, info = Prodiction.GetCircularAOEPrediction(unit, RRange, RSpeed, RDelay, RWidth, myPlayer)	
	
		if pos and info.hitchance >= Menu.RHit then
			if Menu.Packets then
			Packet('S_CAST', {spellId = _R, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_R, pos.x, pos.z)
			end
		end
end 


function CastE(unit)
	local pos, info = Prodiction.GetPrediction(unit, ERange, ESpeed, EDelay, EWidth, myPlayer)	
	
		if pos and info.hitchance >= Menu.EHit then
			if Menu.Packets then
			Packet('S_CAST', {spellId = _E, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_E, pos.x, pos.z)
			end
		end
end 
]]--


function CastE(unit)
	local pos, info = VP:GetLineCastPosition(unit, EDelay, EWidth, ERange, ESpeed, myHero, false)	

	if pos and info >= Menu.EHit then								
		if Menu.Packets then
			Packet('S_CAST', {spellId = _E, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_E, pos.x, pos.z)
			end										
		end

end 

function CastR(unit)
	local pos, info, targets = VP:GetCircularAOECastPosition(unit, Delay, RDelay, RRange, RSpeed, myHero, false)

	if pos and info >= Menu.RHit and targets >= 3 then								
		if Menu.Packets then
			Packet('S_CAST', {spellId = _R, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send(true)
			else 
			CastSpell(_R, pos.x, pos.z)
			end										
		end

end

function corki_harass_tables()
	whitelisted={}
	whitelisted["Ashe"] = true
	whitelisted["Caitlyn"] = true
	whitelisted["Corki"] = true
	whitelisted["Draven"] = true
	whitelisted["Ezreal"] = true
	whitelisted["Graves"] = true
	whitelisted["Jinx"] = true
	whitelisted["KogMaw"] = true
	whitelisted["Lucian"] = true
	whitelisted["MissFortune"] = true
	whitelisted["Quinn"] = true
	whitelisted["Sivir"] = true
	whitelisted["Tristana"] = true
	whitelisted["Twitch"] = true
	whitelisted["Urgot"] = true
	whitelisted["Varus"] = true
	whitelisted["Vayne"] = true
end

function OnDraw()
	if EReady and not myHero.dead then
	DrawCircle3D(myHero.x, myHero.y, myHero.z, 750, 1, ARGB(70,23,190,23))
	--DrawCircle3D(myHero.x, myHero.y, myHero.z, 900, 1, ARGB(60,23,190,23))
	end
end
