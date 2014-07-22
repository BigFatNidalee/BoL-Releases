if myHero.charName ~= "Sona" then return end

local version = "0.01"

local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL-Releases/master/for-Prodiction-Donators/Common/SidasAutoCarryPlugin - Sona.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."/Common/SidasAutoCarryPlugin - Sona.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Big Fat Sona:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL-Releases/master/versions/Sona.version")
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


	local Target = AutoCarry.GetAttackTarget()
	--
	local QReady, WReady, EReady, RReady = false, false, false, false
	local QRange = 650
	local WRange = 1000
	local ERange = 1000
	local RRange, RSpeed, RDelay, RWidth = 1000, 2400, 0.250, 140
	--
	local ksfilter = false
	--

function PluginOnLoad()


	require "Prodiction"

	AutoCarry.PluginMenu:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("RHitchance", "R Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
	AutoCarry.PluginMenu:addParam("info1", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("ult4me","Ult 4 Me", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))
	AutoCarry.PluginMenu:addParam("useult","Use Auto Ult", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("ultenemys", "Auto Ult if X enemys in range", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
	AutoCarry.PluginMenu:addParam("info2", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("DrawQ","Draw Q", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("DrawR","Draw R", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("info3", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("info4", "add to SBTW:", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("SpamW","Spam W", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("H"))
	AutoCarry.PluginMenu:addParam("SpamE","Spam E", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("J"))
	AutoCarry.PluginMenu:addParam("Showaddons","Perma Show additions", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("info5", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("info6", "Private Sona v. "..version.."", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("info7", "by Big Fat Nidalee", SCRIPT_PARAM_INFO, "")

	if AutoCarry.PluginMenu.Showaddons then
	AutoCarry.PluginMenu:permaShow("SpamW")
	AutoCarry.PluginMenu:permaShow("SpamE")
	end

	if AutoCarry.Skills then IsSACReborn = true else IsSACReborn = false end

	if IsSACReborn then
	AutoCarry.Skills:DisableAll()
	end
		rts = TargetSelector(TARGET_LESS_CAST_PRIORITY, RRange, DAMAGE_MAGIC)
		rts.name = 'Ultimate'
		AutoCarry.PluginMenu:addTS(rts)
	PrintChat("<font color='#c9d7ff'>Private Sona: </font><font color='#64f879'> v. "..version.." </font><font color='#c9d7ff'> loaded, happy elo boosting! </font>")

end 


function PluginOnTick()
	rts:update()
	Target = AutoCarry.GetAttackTarget()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)

	if Target and AutoCarry.MainMenu.AutoCarry then Combo() end
	if Target and AutoCarry.MainMenu.MixedMode then Harass1() end
	if Target and AutoCarry.MainMenu.LaneClear then Harass2() end
	
	if rts.target and ValidTarget(rts.target)then
		if AutoCarry.PluginMenu.ult4me then ULT4ME() end	
		if AutoCarry.PluginMenu.useult then Autoult() end
	end

end 
 
 -- << --  -- << --  -- << --  -- << -- [COMBO]  -- >> --  -- >> --  -- >> --  -- >> --

function Combo()
	if not Target then return end
	
	if QReady and GetDistance(Target) <= QRange then
	CastSpell(_Q)
	end
	
	if AutoCarry.PluginMenu.SpamW and WReady then
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team and teammate.visible and teammate.dead == false and teammate.health/teammate.maxHealth<=0.9 and myHero:GetDistance(teammate) < WRange then
			CastSpell(_W)
			end
		end
	end

	if AutoCarry.PluginMenu.SpamE and EReady then
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team and teammate.visible and teammate.dead == false and myHero:GetDistance(teammate) < ERange then
			CastSpell(_E)
			end
		end
	end
	

end 

 -- << --  -- << --  -- << --  -- << -- [Ult]  -- >> --  -- >> --  -- >> --  -- >> --
function ULT4ME()
 	if not rts.target then return end
 	if RReady and AutoCarry.PluginMenu.ult4me and GetDistance(rts.target) <= RRange then	
		local rpos, rinfo = Prodiction.GetLineAOEPrediction(rts.target, RRange, RSpeed, RDelay, RWidth, myPlayer)		
		if rpos and rinfo.hitchance >= AutoCarry.PluginMenu.RHitchance then
			if AutoCarry.PluginMenu.UsePacketsCast then
				Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
				CastSpell(_R, rpos.x, rpos.z)
			end
		end 		
	end	
end

function Autoult()
 	if not rts.target then return end
 	if RReady and GetDistance(rts.target) <= RRange then
		local boolean, rpos, rinfo = Prodiction.GetMinCountLineAOEPrediction(AutoCarry.PluginMenu.ultenemys, RRange, RSpeed, RDelay, RWidth, myPlayer)
		if boolean == true and rpos then
			if AutoCarry.PluginMenu.UsePacketsCast and rinfo.hitchance >= 1 then
				Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
				CastSpell(_R, rpos.x, rpos.z)
			end			
		end 
	end	
end


 -- << --  -- << --  -- << --  -- << -- [HARASS]  -- >> --  -- >> --  -- >> --  -- >> --
 
function Harass1()
	if not Target then return end
	if QReady and GetDistance(Target) <= QRange then
	CastSpell(_Q)
	end
end 

function Harass2()
	if not Target then return end
	if QReady and GetDistance(Target) <= QRange then
	--CastSpell(_Q)
	end
end 

-- << --  -- << --  -- << --  -- << -- [Draws]  -- >> --  -- >> --  -- >> --  -- >> --
function PluginOnDraw()



		if AutoCarry.PluginMenu.DrawQ and not myHero.dead then
		DrawCircle3D(myHero.x, myHero.y, myHero.z, 600, 1, ARGB(60,23,190,23))
		end	

	
	if RReady then 
		if AutoCarry.PluginMenu.DrawR and not myHero.dead then
		DrawCircle3D(myHero.x, myHero.y, myHero.z, 920, 1, ARGB(60,23,190,23))
		end
	end


end 


-- << --  -- << --  -- << --  -- << -- [MANA nicht fertig]  -- >> --  -- >> --  -- >> --  -- >> --
 
function mymanaislowerthen(percent)
    if myHero.mana < (myHero.maxMana * ( percent / 100)) then
        return true
    else
        return false
    end
end

function MyMana(spell)
	if spell == Q then
		return 50 + (10 * myHero:GetSpellData(_Q).level)
	elseif spell == E then
		return 50
	elseif spell == QR then
		return 50 + (10 * myHero:GetSpellData(_Q).level) + 20
	elseif spell == R then
		return 20
	end
end	
