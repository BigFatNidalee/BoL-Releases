if myHero.charName ~= "Corki" then return end

local version = "0.17"

local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL-Releases/master/Common/SidasAutoCarryPlugin - Corki.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."/Common/SidasAutoCarryPlugin - Corki.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Big Fat Corki:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL-Releases/master/versions/corki.version")
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
local QRange, QSpeed, QDelay, QWidth = 825, 1500, 0.350, 220
local WRange = 800
local ERange, ESpeed, EDelay, EWidth = 720, 902, 0.5, 100
local RRange, RSpeed, RDelay, RWidth = 1225, 2000, 0.165, 80
local ksfilter = false
local lastSkin = 0

function PluginOnLoad()


	require "Collision"
	require "Prodiction"

	
	AutoCarry.PluginMenu:addSubMenu("[Combo]", "Combo")
	AutoCarry.PluginMenu.Combo:addParam("UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.Combo:addParam("UseE","Use E", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.Combo:addParam("UseR","Use R", SCRIPT_PARAM_ONOFF, true)
	
	AutoCarry.PluginMenu:addSubMenu("[Harass]", "Harass")
	AutoCarry.PluginMenu.Harass:addParam("info", "~=[ Harass Mixed Mode ]=~", SCRIPT_PARAM_INFO, "")
    AutoCarry.PluginMenu.Harass:addParam("Harass1UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
    AutoCarry.PluginMenu.Harass:addParam("Harass1UseE","Use E", SCRIPT_PARAM_ONOFF, false)
    AutoCarry.PluginMenu.Harass:addParam("Harass1UseR","Use R", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.Harass:addParam("ManaSliderHarass1", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 55, 0, 100, 0)
	
	AutoCarry.PluginMenu.Harass:addParam("info", "~=[ Harass Lane Clear ]=~", SCRIPT_PARAM_INFO, "")
    AutoCarry.PluginMenu.Harass:addParam("Harass2UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
    AutoCarry.PluginMenu.Harass:addParam("Harass2UseE","Use E", SCRIPT_PARAM_ONOFF, false)
    AutoCarry.PluginMenu.Harass:addParam("Harass2UseR","Use R", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.Harass:addParam("ManaSliderHarass2", "Min mana to use skills",   SCRIPT_PARAM_SLICE, 55, 0, 100, 0)
	
	
	AutoCarry.PluginMenu:addSubMenu("[Prodiction Settings]", "ProdictionSettings")
	AutoCarry.PluginMenu.ProdictionSettings:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.ProdictionSettings:addParam("info0", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu.ProdictionSettings:addParam("QHitchance", "Q Hitchance", SCRIPT_PARAM_SLICE, 1, 1, 3, 0)
	AutoCarry.PluginMenu.ProdictionSettings:addParam("EHitchance", "E Hitchance", SCRIPT_PARAM_SLICE, 1, 1, 3, 0)
	AutoCarry.PluginMenu.ProdictionSettings:addParam("RHitchance", "R Hitchance", SCRIPT_PARAM_SLICE, 1, 1, 3, 0)
	AutoCarry.PluginMenu.ProdictionSettings:addParam("info", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu.ProdictionSettings:addParam("info2", "HITCHANCE:", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu.ProdictionSettings:addParam("info3", "LOW = 1  NORMAL = 2  HIGH = 3", SCRIPT_PARAM_INFO, "")
	
	AutoCarry.PluginMenu:addSubMenu("[KS Options]", "KSOptions")
	AutoCarry.PluginMenu.KSOptions:addParam("KSwithQ","KS with Q", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.KSOptions:addParam("KSwithR","KS with R", SCRIPT_PARAM_ONOFF, true)
	
	AutoCarry.PluginMenu:addSubMenu("[Draws]", "Draws")
	AutoCarry.PluginMenu.Draws:addSubMenu("[Q Settings]", "QSettings")
	AutoCarry.PluginMenu.Draws.QSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	AutoCarry.PluginMenu.Draws.QSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	AutoCarry.PluginMenu.Draws.QSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
	AutoCarry.PluginMenu.Draws:addSubMenu("[W Settings]", "WSettings")
	AutoCarry.PluginMenu.Draws.WSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	AutoCarry.PluginMenu.Draws.WSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	AutoCarry.PluginMenu.Draws.WSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
	AutoCarry.PluginMenu.Draws:addSubMenu("[E Settings]", "ESettings")
	AutoCarry.PluginMenu.Draws.ESettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	AutoCarry.PluginMenu.Draws.ESettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	AutoCarry.PluginMenu.Draws.ESettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
	AutoCarry.PluginMenu.Draws:addSubMenu("[R Settings]", "RSettings")
	AutoCarry.PluginMenu.Draws.RSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	AutoCarry.PluginMenu.Draws.RSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	AutoCarry.PluginMenu.Draws.RSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
	AutoCarry.PluginMenu.Draws:addParam("UselowfpsDraws","Use low fps Draws", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.Draws:addParam("DrawQRange","Draw Q Range", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu.Draws:addParam("DrawWRange","Draw W Range", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu.Draws:addParam("DrawERange","Draw E Range", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu.Draws:addParam("DrawRRange","Draw R Range", SCRIPT_PARAM_ONOFF, false)
	
	
	AutoCarry.PluginMenu:addParam("info8", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("skin", "Skin Hack by Shalzuth:", SCRIPT_PARAM_LIST, 1, { "UFO", "Ice Toboggan", "Red Baron", "Hot Rod", "Urfrider", "Dragonwing", "No Skin" })
	AutoCarry.PluginMenu:addParam("info8", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("info", "Big Fat Corki v. "..version.."", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("info9", "by Big Fat Nidalee", SCRIPT_PARAM_INFO, "")

	

	if AutoCarry.Skills then IsSACReborn = true else IsSACReborn = false end


	if IsSACReborn then
		AutoCarry.Skills:DisableAll()
		AutoCarry.Plugins:RegisterBonusLastHitDamage(PassiveFarm)
	end
	
	
	
	PrintChat("<font color='#c9d7ff'>Big Fat Corki: </font><font color='#64f879'> v. "..version.." </font><font color='#c9d7ff'> loaded, happy elo boosting! </font>")



end 


function PluginOnTick()

	Target = AutoCarry.GetAttackTarget()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	KS()
	if Target and AutoCarry.MainMenu.AutoCarry and not ksfilter == true then Combo() end
	if Target and AutoCarry.MainMenu.MixedMode and not ksfilter == true then Harass1() end
	if Target and AutoCarry.MainMenu.LaneClear and not ksfilter == true then Harass2() end
	SkinHack()

	


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
if AutoCarry.PluginMenu.skin ~= lastSkin and VIP_USER then
	lastSkin = AutoCarry.PluginMenu.skin
	GenModelPacket("Corki", AutoCarry.PluginMenu.skin)
end
end
 -- << --  -- << --  -- << --  -- << -- [KS]  -- >> --  -- >> --  -- >> --  -- >> --
 
function KS()
	for i = 1, heroManager.iCount do
	local enemy = heroManager:getHero(i)
--	
		if QReady and AutoCarry.PluginMenu.KSOptions.KSwithQ and ValidTarget(enemy, QRange) and not enemy.dead and enemy.health < getDmg("Q",enemy,myHero) and myHero.mana >= MyMana(Q) then
		local qpos, qinfo = Prodiction.GetPrediction(enemy, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance then
			
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
		if RReady and AutoCarry.PluginMenu.KSOptions.KSwithR and ValidTarget(enemy, RRange) and not enemy.dead and enemy.health < getDmg("R",enemy,myHero) and myHero.mana >= MyMana(R) then
		local rpos, rinfo = Prodiction.GetPrediction(enemy, RRange, RSpeed, RDelay, RWidth, myPlayer)
		local coll = Collision(RRange, RSpeed, RDelay, RWidth)
		
		if rpos and rinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.RHitchance and not coll:GetMinionCollision(rpos, myHero) then

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
		if RReady and QReady and AutoCarry.PluginMenu.KSOptions.KSwithR and AutoCarry.PluginMenu.KSOptions.KSwithQ and ValidTarget(enemy, QRange) and not enemy.dead and enemy.health < getDmg("R",enemy,myHero) + getDmg("Q",enemy,myHero) and myHero.mana >= MyMana(R) then
		local rpos, rinfo = Prodiction.GetPrediction(enemy, RRange, RSpeed, RDelay, RWidth, myPlayer)
		local qpos, qinfo = Prodiction.GetPrediction(enemy, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local coll = Collision(RRange, RSpeed, RDelay, RWidth)
		
		if rpos and qpos and rinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.RHitchance and not coll:GetMinionCollision(rpos, myHero) then

			
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



 -- << --  -- << --  -- << --  -- << -- [Passive]  -- >> --  -- >> --  -- >> --  -- >> --

function PassiveFarm(minion)
	return getDmg("P", minion, myHero)
end
 -- << --  -- << --  -- << --  -- << -- [COMBO]  -- >> --  -- >> --  -- >> --  -- >> --

function Combo()
	if not Target then return end
	
	if AutoCarry.PluginMenu.Combo.UseQ and QReady and myHero.mana >= MyMana(Q) and GetDistance(Target) <= QRange then
		--local qpos, qinfo = Prodiction.GetPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local qpos, qinfo = Prodiction.GetCircularAOEPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end			
	end 	
	if AutoCarry.PluginMenu.Combo.UseE and EReady and myHero.mana >= MyMana(E) and GetDistance(Target) <= ERange then
		local epos, einfo = Prodiction.GetPrediction(Target, ERange, ESpeed, EDelay, EWidth, myPlayer)
		
		if epos and einfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.EHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
			else 
			CastSpell(_E, epos.x, epos.z)
			end
		end		
	end  	
	if AutoCarry.PluginMenu.Combo.UseR and RReady and myHero.mana >= MyMana(R) and GetDistance(Target) <= RRange then
		local rpos, rinfo = Prodiction.GetPrediction(Target, RRange, RSpeed, RDelay, RWidth, myPlayer)
		local coll = Collision(RRange, RSpeed, RDelay, RWidth)
		
		if rpos and rinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.RHitchance and not coll:GetMinionCollision(rpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
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
	
	if AutoCarry.PluginMenu.Harass.Harass1UseQ and QReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and myHero.mana >= MyMana(Q) and GetDistance(Target) <= QRange then

		local qpos, qinfo = Prodiction.GetCircularAOEPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end			
	end 	
	if AutoCarry.PluginMenu.Harass.Harass1UseE and EReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1)  and GetDistance(Target) <= ERange then
		local epos, einfo = Prodiction.GetPrediction(Target, ERange, ESpeed, EDelay, EWidth, myPlayer)
		
		if epos and einfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.EHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
			else 
			CastSpell(_E, epos.x, epos.z)
			end
		end		
	end  	
	if AutoCarry.PluginMenu.Harass.Harass1UseR and RReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and myHero.mana >= MyMana(R) and GetDistance(Target) <= RRange then
		local rpos, rinfo = Prodiction.GetPrediction(Target, RRange, RSpeed, RDelay, RWidth, myPlayer)
		local coll = Collision(RRange, RSpeed, RDelay, RWidth)
		
		if rpos and rinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.RHitchance and not coll:GetMinionCollision(rpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
		end		
	end 

end 

function Harass2()
	if not Target then return end
	
	if AutoCarry.PluginMenu.Harass.Harass2UseQ and QReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and myHero.mana >= MyMana(Q) and GetDistance(Target) <= QRange then

		local qpos, qinfo = Prodiction.GetCircularAOEPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end			
	end 	
	if AutoCarry.PluginMenu.Harass.Harass2UseE and EReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2)  and GetDistance(Target) <= ERange then
		local epos, einfo = Prodiction.GetPrediction(Target, ERange, ESpeed, EDelay, EWidth, myPlayer)
		
		if epos and einfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.EHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
			else 
			CastSpell(_E, epos.x, epos.z)
			end
		end		
	end  	
	if AutoCarry.PluginMenu.Harass.Harass2UseR and RReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and myHero.mana >= MyMana(R) and GetDistance(Target) <= RRange then
		local rpos, rinfo = Prodiction.GetPrediction(Target, RRange, RSpeed, RDelay, RWidth, myPlayer)
		local coll = Collision(RRange, RSpeed, RDelay, RWidth)
		
		if rpos and rinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.RHitchance and not coll:GetMinionCollision(rpos, myHero) then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
				Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
		end		
	end 

end 

-- << --  -- << --  -- << --  -- << -- [Draws]  -- >> --  -- >> --  -- >> --  -- >> --
function PluginOnDraw()

	if AutoCarry.PluginMenu.Draws.UselowfpsDraws then
		if QReady and AutoCarry.PluginMenu.Draws.DrawQRange and not myHero.dead then
		DrawCircleQ(myHero.x, myHero.y, myHero.z, QRange, ARGB(AutoCarry.PluginMenu.Draws.QSettings.colorAA[1],AutoCarry.PluginMenu.Draws.QSettings.colorAA[2],AutoCarry.PluginMenu.Draws.QSettings.colorAA[3],AutoCarry.PluginMenu.Draws.QSettings.colorAA[4]))
		end	
		if WReady and AutoCarry.PluginMenu.Draws.DrawWRange and not myHero.dead then
		DrawCircleW(myHero.x, myHero.y, myHero.z, WRange, ARGB(AutoCarry.PluginMenu.Draws.WSettings.colorAA[1],AutoCarry.PluginMenu.Draws.WSettings.colorAA[2],AutoCarry.PluginMenu.Draws.WSettings.colorAA[3],AutoCarry.PluginMenu.Draws.WSettings.colorAA[4]))
		end		
		if EReady and AutoCarry.PluginMenu.Draws.DrawERange and not myHero.dead then
		DrawCircleE(myHero.x, myHero.y, myHero.z, ERange, ARGB(AutoCarry.PluginMenu.Draws.ESettings.colorAA[1],AutoCarry.PluginMenu.Draws.ESettings.colorAA[2],AutoCarry.PluginMenu.Draws.ESettings.colorAA[3],AutoCarry.PluginMenu.Draws.ESettings.colorAA[4]))
		end		
		if RReady and AutoCarry.PluginMenu.Draws.DrawRRange and not myHero.dead then
		DrawCircleR(myHero.x, myHero.y, myHero.z, RRange, ARGB(AutoCarry.PluginMenu.Draws.RSettings.colorAA[1],AutoCarry.PluginMenu.Draws.RSettings.colorAA[2],AutoCarry.PluginMenu.Draws.RSettings.colorAA[3],AutoCarry.PluginMenu.Draws.RSettings.colorAA[4]))
		end	
	end
	
	if not AutoCarry.PluginMenu.Draws.UselowfpsDraws then
	if QReady then 
		if AutoCarry.PluginMenu.Draws.DrawQRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0xb9c3ed)
		end	
	end
	if WReady then 
		if AutoCarry.PluginMenu.Draws.DrawWRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0xb9c3ed)
		end
	end
	if EReady then 
		if AutoCarry.PluginMenu.Draws.DrawWRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0xb9c3ed)
		end
	end
	if RReady then 
		if AutoCarry.PluginMenu.Draws.DrawWRange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xb9c3ed)
		end
	end
	end
	

end 


--Q Range Circle QUality
function DrawCircleNextLvlQ(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(AutoCarry.PluginMenu.Draws.QSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlQ(x, y, z, radius, AutoCarry.PluginMenu.Draws.QSettings.width, color, 75)	
	end
end 	

--W Range Circle QUality
function DrawCircleNextLvlW(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(AutoCarry.PluginMenu.Draws.WSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlW(x, y, z, radius, AutoCarry.PluginMenu.Draws.WSettings.width, color, 75)	
	end
end 	
	

--E Range Circle QUality
function DrawCircleNextLvlE(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(AutoCarry.PluginMenu.Draws.ESettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlW(x, y, z, radius, AutoCarry.PluginMenu.Draws.ESettings.width, color, 75)	
	end
end 	
	

--R Range Circle QUality
function DrawCircleNextLvlR(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(AutoCarry.PluginMenu.Draws.RSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlW(x, y, z, radius, AutoCarry.PluginMenu.Draws.RSettings.width, color, 75)	
	end
end 	


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
		return 50 + (10 * myHero:GetSpellData(_Q).level)
	elseif spell == E then
		return 50
	elseif spell == QR then
		return 50 + (10 * myHero:GetSpellData(_Q).level) + 20
	elseif spell == R then
		return 20
	end
end			


