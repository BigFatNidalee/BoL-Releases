if myHero.charName ~= "Graves" then return end

local version = "0.1"

local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL-Releases/master/Common/SidasAutoCarryPlugin - Graves.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."/Common/SidasAutoCarryPlugin - Graves.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Big Fat Graves:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL-Releases/master/versions/Graves.version")
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
local QReady, WReady, EReady, RReady = false, false, false, false
local QRange, QSpeed, QDelay, QWidth = 925, 1950, 0.265, 85
local WRange, WSpeed, WDelay, WWidth = 925, 1650, 0.300, 250
local RRange, RSpeed, RDelay, RWidth, RWidth2 = 1000, 2100, 0.219, 55, 100
local ksfilter = false



function PluginOnLoad()


	require "Collision"
	require "Prodiction"

	
	AutoCarry.PluginMenu:addSubMenu("[Harass]", "Harass")
	AutoCarry.PluginMenu.Harass:addParam("info", "~=[ Harass Mixed Mode ]=~", SCRIPT_PARAM_INFO, "")
    AutoCarry.PluginMenu.Harass:addParam("Harass1UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
    AutoCarry.PluginMenu.Harass:addParam("Harass1UseW","Use W", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu.Harass:addParam("ManaSliderHarass1", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 55, 0, 100, 0)
	
	AutoCarry.PluginMenu.Harass:addParam("info", "~=[ Harass Lane Clear ]=~", SCRIPT_PARAM_INFO, "")
    AutoCarry.PluginMenu.Harass:addParam("Harass2UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
    AutoCarry.PluginMenu.Harass:addParam("Harass2UseW","Use W", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu.Harass:addParam("ManaSliderHarass2", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 55, 0, 100, 0)
	
	
	AutoCarry.PluginMenu:addSubMenu("[Prodiction Settings]", "ProdictionSettings")
	AutoCarry.PluginMenu.ProdictionSettings:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
	
	AutoCarry.PluginMenu:addSubMenu("[KS Options]", "KSOptions")

	AutoCarry.PluginMenu.KSOptions:addParam("KSwithQ","KS with Q", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.KSOptions:addParam("KSwithW","KS with W", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.KSOptions:addParam("KSwithR","KS with R", SCRIPT_PARAM_ONOFF, true)
	
	
	AutoCarry.PluginMenu:addParam("info", "~=[ BFN Graves v"..version.." ]=~", SCRIPT_PARAM_INFO, "")


	if AutoCarry.Skills then IsSACReborn = true else IsSACReborn = false end

	-- Disable SAC Reborn's skills. Ours are better.
	if IsSACReborn then
		AutoCarry.Skills:DisableAll()
	end

	PrintChat("<font color='#c9d7ff'>Big Fat Nidalee's Graves: </font><font color='#64f879'> "..version.." </font><font color='#c9d7ff'> loaded, happy elo boosting! </font>")



end 

function PluginOnTick()

	Target = AutoCarry.GetAttackTarget()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	KS()
	if Target and AutoCarry.MainMenu.AutoCarry and not ksfilter == true then WQ() end
	if Target and AutoCarry.MainMenu.MixedMode and not ksfilter == true then WQHarass1() end
	if Target and AutoCarry.MainMenu.LaneClear and not ksfilter == true then WQHarass2() end

	


end 

	
function KS()
	for i = 1, heroManager.iCount do
	local enemy = heroManager:getHero(i)
--	
		if QReady and AutoCarry.PluginMenu.KSOptions.KSwithQ and ValidTarget(enemy, QRange) and enemy.health < getDmg("Q",enemy,myHero) and myHero.mana >= ManaCost(Q) then
		local qpos, qinfo = Prodiction.GetPrediction(enemy, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
			
		ksfilter = true 
		end	
		else ksfilter = false
		end
--
		if WReady and AutoCarry.PluginMenu.KSOptions.KSwithW and ValidTarget(enemy, WRange) and enemy.health < getDmg("W",enemy,myHero)  then
		local wpos, winfo = Prodiction.GetPrediction(enemy, WRange, WSpeed, WDelay, WWidth, myPlayer)
		if wpos and winfo.hitchance >= 1 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, epos.x, epos.z)
			end
		ksfilter = true 
		end	
		else ksfilter = false
		end
--	
		if RReady and AutoCarry.PluginMenu.KSOptions.KSwithR and ValidTarget(enemy, RRange) and enemy.health < getDmg("R",enemy,myHero) and myHero.mana >= ManaCost(R) then
		local rpos, rinfo = Prodiction.GetPrediction(enemy, RRange, RSpeed, RDelay, RWidth, myPlayer)
		local Rcoll = Collision(RRange, RSpeed, RDelay, RWidth2)
		
		if rpos and rinfo.hitchance >= 2 and not Rcoll:GetMinionCollision(rpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
		ksfilter = true 
		end	
		else ksfilter = false
		end
--
--	
		if QReady and RReady and AutoCarry.PluginMenu.KSOptions.KSwithR and AutoCarry.PluginMenu.KSOptions.KSwithQ and ValidTarget(enemy, QRange) and enemy.health < getDmg("R",enemy,myHero) + getDmg("Q",enemy,myHero)  and myHero.mana >= ManaCost(QR) then
		local rpos, rinfo = Prodiction.GetPrediction(enemy, RRange, RSpeed, RDelay, RWidth, myPlayer)
		local qpos, qinfo = Prodiction.GetPrediction(enemy, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local Rcoll = Collision(RRange, RSpeed, RDelay, RWidth2)
		
		if rpos and qpos and rinfo.hitchance >= 2 and not Rcoll:GetMinionCollision(rpos, myHero) then
		
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
		ksfilter = true 
		end	
		else ksfilter = false
		end
--
	end

end

function WQ ()
	if QReady and WReady and myHero.mana >= ManaCost(WQ) and GetDistance(Target) <= WRange then 
		local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if wpos and winfo.hitchance >= 1 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
		
		if qpos and qinfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
		
		
	elseif QReady and WReady and myHero.mana <= ManaCost(WQ) then 
		if myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
		
		end 
	elseif QReady and not WReady and myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)

		
		if qpos and qinfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	end	
end



function WQHarass1 ()
	if AutoCarry.PluginMenu.Harass.Harass1UseQ and AutoCarry.PluginMenu.Harass.Harass1UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and QReady and WReady and myHero.mana >= ManaCost(WQ) and GetDistance(Target) <= WRange then 
		local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if wpos and winfo.hitchance >= 1 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
		
		
		if qpos and qinfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
		
	elseif AutoCarry.PluginMenu.Harass.Harass1UseQ and AutoCarry.PluginMenu.Harass.Harass1UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and QReady and WReady and myHero.mana <= ManaCost(WQ) then 
		if myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)

		
		if qpos and qinfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
		
		end 
	elseif AutoCarry.PluginMenu.Harass.Harass1UseQ and AutoCarry.PluginMenu.Harass.Harass1UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and QReady and not WReady and myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)

		
		if qpos and qinfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	elseif AutoCarry.PluginMenu.Harass.Harass1UseQ and not AutoCarry.PluginMenu.Harass.Harass1UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and QReady and myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	elseif AutoCarry.PluginMenu.Harass.Harass1UseW and not AutoCarry.PluginMenu.Harass.Harass1UseQ and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and WReady and myHero.mana >= ManaCost(W) and GetDistance(Target) <= WRange then
		local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		
		if wpos and winfo.hitchance >= 1 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
	end	
end  



function WQHarass2 ()
	if AutoCarry.PluginMenu.Harass.Harass2UseQ and AutoCarry.PluginMenu.Harass.Harass2UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and QReady and WReady and myHero.mana >= ManaCost(WQ) and GetDistance(Target) <= WRange then 
		local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if wpos and winfo.hitchance >= 1 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
		
		if qpos and qinfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
		
		
	elseif AutoCarry.PluginMenu.Harass.Harass2UseQ and AutoCarry.PluginMenu.Harass.Harass2UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and QReady and WReady and myHero.mana <= ManaCost(WQ) then 
		if myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)

		
		if qpos and qinfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
		
		end 
	elseif AutoCarry.PluginMenu.Harass.Harass2UseQ and AutoCarry.PluginMenu.Harass.Harass2UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and QReady and not WReady and myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= 2 then 
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	elseif AutoCarry.PluginMenu.Harass.Harass2UseQ and not AutoCarry.PluginMenu.Harass.Harass2UseW and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and QReady and myHero.mana >= ManaCost(Q) and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= 2 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	elseif AutoCarry.PluginMenu.Harass.Harass2UseW and not AutoCarry.PluginMenu.Harass.Harass2UseQ and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and WReady and myHero.mana >= ManaCost(W) and GetDistance(Target) <= WRange then
		local wpos, winfo = Prodiction.GetPrediction(Target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		
		if wpos and winfo.hitchance >= 1 then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
	end	
end  



function mymanaislowerthen(percent)
    if myHero.mana < (myHero.maxMana * ( percent / 100)) then
        return true
    else
        return false
    end
end

function ManaCost(spell)
	if spell == Q then
		return 50 + (10 * myHero:GetSpellData(_Q).level)
	elseif spell == W then
		return 65 + (5 * myHero:GetSpellData(_W).level)
	elseif spell == R then
		return 100
	elseif spell == QR then
		return 50 + (10 * myHero:GetSpellData(_Q).level) + 100
	elseif spell == WQ then
		return 65 + (5 * myHero:GetSpellData(_W).level) + 50 + (10 * myHero:GetSpellData(_Q).level)
	end 
end			

