if myHero.charName ~= "Graves" then return end

local version = "0.2"

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

local AARange = 590
local QReady, WReady, EReady, RReady = false, false, false, false
local QRange, QSpeed, QDelay, QWidth = 925, 1950, 0.265, 85
local WRange, WSpeed, WDelay, WWidth = 925, 1650, 0.300, 250
local RRange, RSpeed, RDelay, RWidth, RWidthCol = 1000, 2100, 0.219, 55, 100

local lastSkin = 0
local KSProcess = false

function PluginOnLoad()


	require "Collision"
	require "Prodiction"

	AutoCarry.PluginMenu:addSubMenu("[Combo]", "Combo")
	AutoCarry.PluginMenu.Combo:addParam("UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.Combo:addParam("UseW","Use W", SCRIPT_PARAM_ONOFF, true)

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
	AutoCarry.PluginMenu.ProdictionSettings:addParam("info0", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu.ProdictionSettings:addParam("QHitchance", "Q Hitchance", SCRIPT_PARAM_SLICE, 1, 1, 3, 0)
	AutoCarry.PluginMenu.ProdictionSettings:addParam("WHitchance", "W Hitchance", SCRIPT_PARAM_SLICE, 1, 1, 3, 0)
	AutoCarry.PluginMenu.ProdictionSettings:addParam("RHitchance", "R Hitchance", SCRIPT_PARAM_SLICE, 1, 1, 3, 0)
	AutoCarry.PluginMenu.ProdictionSettings:addParam("info", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu.ProdictionSettings:addParam("info2", "HITCHANCE:", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu.ProdictionSettings:addParam("info3", "LOW = 1  NORMAL = 2  HIGH = 3", SCRIPT_PARAM_INFO, "")

	AutoCarry.PluginMenu:addSubMenu("[KS Options]", "KSOptions")
	AutoCarry.PluginMenu.KSOptions:addParam("KSwithQ","KS with Q", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.KSOptions:addParam("KSwithW","KS with W", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.KSOptions:addParam("KSwithR","KS with R", SCRIPT_PARAM_ONOFF, true)

	AutoCarry.PluginMenu:addSubMenu("[Draws]", "Draws")
	AutoCarry.PluginMenu.Draws:addSubMenu("[AA Settings]", "AASettings")
	AutoCarry.PluginMenu.Draws.AASettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	AutoCarry.PluginMenu.Draws.AASettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	AutoCarry.PluginMenu.Draws.AASettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
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
	AutoCarry.PluginMenu.Draws:addParam("DrawAARange","Draw AA Range", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu.Draws:addParam("DrawQRange","Draw Q Range", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu.Draws:addParam("DrawWRange","Draw W Range", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu.Draws:addParam("DrawERange","Draw E Range", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu.Draws:addParam("DrawRRange","Draw R Range", SCRIPT_PARAM_ONOFF, false)
	
	AutoCarry.PluginMenu:addParam("info8", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("Ult4me","Ult 4 Me", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Y"))
	AutoCarry.PluginMenu:addParam("info8", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("SkinHack","Use Skin Hack", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu:addParam("skin", "Skin Hack by Shalzuth:", SCRIPT_PARAM_LIST, 5, { "Hired Gun", "Jailbreak", "Mafia", "Riot", "Pool Party", "No Skin" })
	AutoCarry.PluginMenu:addParam("info8", "", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("info", "Big Fat Graves v. "..version.."", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("info9", "by Big Fat Nidalee", SCRIPT_PARAM_INFO, "")
	
	myts = TargetSelector(TARGET_LESS_CAST_PRIORITY, RRange, DAMAGE_PHYSICAL)
	myts.name = 'Skills'
	AutoCarry.PluginMenu:addTS(myts)

	if AutoCarry.Skills then IsSACReborn = true else IsSACReborn = false end

	if IsSACReborn then
	AutoCarry.Skills:DisableAll()
	end
	
	PrintChat("<font color='#c9d7ff'>Big Fat Graves: </font><font color='#64f879'> v. "..version.." </font><font color='#c9d7ff'> loaded, happy elo boosting! </font>")

end 


function PluginOnTick()

	myts:update()

	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	
	Killsteal()
	
	if AutoCarry.PluginMenu.SkinHack then
	SkinHack()
	end 
	
	if myts.target and ValidTarget(myts.target) and myts.target.visible then
		if AutoCarry.MainMenu.AutoCarry and KSProcess == false then Combo() end
		if AutoCarry.MainMenu.MixedMode and KSProcess == false then Harass1() end
		if AutoCarry.MainMenu.LaneClear and KSProcess == false then Harass2() end
		if AutoCarry.PluginMenu.Ult4me then ULT4ME() end 
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
if AutoCarry.PluginMenu.skin ~= lastSkin and VIP_USER then
	lastSkin = AutoCarry.PluginMenu.skin
	GenModelPacket("Graves", AutoCarry.PluginMenu.skin)
end
end
 -- << --  -- << --  -- << --  -- << -- [Ult]  -- >> --  -- >> --  -- >> --  -- >> --
 
function ULT4ME()
 	if not myts.target then return end
	
 	if RReady and AutoCarry.PluginMenu.Ult4me and GetDistance(myts.target) <= RRange then
	local rpos, rinfo = Prodiction.GetPrediction(enemy, RRange, RSpeed, RDelay, RWidth, myPlayer)
	local Rcoll = Collision(RRange, RSpeed, RDelay, RWidthCol)
		if rpos and rinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.RHitchance and not Rcoll:GetMinionCollision(rpos, myHero) then
		
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
		
		end 
		
	end	
end
 -- << --  -- << --  -- << --  -- << -- [KS]  -- >> --  -- >> --  -- >> --  -- >> --

function Killsteal()

	for i = 1, heroManager.iCount do
	
		local enemy = heroManager:getHero(i)
		local ksqpos, ksqinfo = Prodiction.GetPrediction(enemy, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local kswpos, kswinfo = Prodiction.GetPrediction(enemy, WRange, WSpeed, WDelay, WWidth, myPlayer)
		local ksrpos, ksrinfo = Prodiction.GetPrediction(enemy, RRange, RSpeed, RDelay, RWidth, myPlayer)
		
		local Rcoll = Collision(RRange, RSpeed, RDelay, RWidthCol)
		
		if QReady and AutoCarry.PluginMenu.KSOptions.KSwithQ and ValidTarget(enemy, QRange) and not enemy.dead and enemy.visible and enemy.health < getDmg("Q",enemy,myHero) and myHero.mana >= MyMana(Q) and ksqpos and ksqinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance then
		KSProcess = true
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = ksqpos.x, toY = ksqpos.z, fromX = ksqpos.x, fromY = ksqpos.z}):send(true)
			else 
			CastSpell(_Q, ksqpos.x, ksqpos.z)
			end
			
		else 
		KSProcess = false
		end
		
		if WReady and AutoCarry.PluginMenu.KSOptions.KSwithW and ValidTarget(enemy, WRange) and not enemy.dead and enemy.visible and enemy.health < getDmg("W",enemy,myHero) and myHero.mana >= MyMana(W) and kswpos and kswinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.WHitchance then
		KSProcess = true
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = kswpos.x, toY = kswpos.z, fromX = kswpos.x, fromY = kswpos.z}):send(true)
			else 
			CastSpell(_W, kswpos.x, kswpos.z)
			end
			
		else 
		KSProcess = false
		end
		
		if RReady and AutoCarry.PluginMenu.KSOptions.KSwithR and ValidTarget(enemy, RRange) and not enemy.dead and enemy.visible and enemy.health < getDmg("R",enemy,myHero) and myHero.mana >= MyMana(R) and ksrpos and ksrinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.RHitchance and not Rcoll:GetMinionCollision(ksrpos, myHero) then
		KSProcess = true
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _R, toX = ksrpos.x, toY = ksrpos.z, fromX = ksrpos.x, fromY = ksrpos.z}):send(true)
			else 
			CastSpell(_R, ksrpos.x, ksrpos.z)
			end
			
		else 
		KSProcess = false
		end
		
		if QReady and WReady and AutoCarry.PluginMenu.KSOptions.KSwithQ and AutoCarry.PluginMenu.KSOptions.KSwithW and ValidTarget(enemy, QRange) and not enemy.dead and enemy.visible and enemy.health < getDmg("Q",enemy,myHero) + getDmg("W",enemy,myHero) and myHero.mana >= MyMana(WQ) and ksqpos and ksqinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance and kswpos and kswinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.WHitchance then
		KSProcess = true
		
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = kswpos.x, toY = kswpos.z, fromX = kswpos.x, fromY = kswpos.z}):send(true)
			Packet('S_CAST', {spellId = _Q, toX = ksqpos.x, toY = ksqpos.z, fromX = ksqpos.x, fromY = ksqpos.z}):send(true)
			else 
			CastSpell(_W, kswpos.x, kswpos.z)
			CastSpell(_Q, ksqpos.x, ksqpos.z)
			end
			
		else 
		KSProcess = false
		end
		
		if QReady and RReady and AutoCarry.PluginMenu.KSOptions.KSwithQ and AutoCarry.PluginMenu.KSOptions.KSwithR and ValidTarget(enemy, QRange) and not enemy.dead and enemy.visible and enemy.health < getDmg("Q",enemy,myHero) + getDmg("R",enemy,myHero) and myHero.mana >= MyMana(QR) and ksqpos and ksqinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance and ksrpos and ksrinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.RHitchance and not Rcoll:GetMinionCollision(ksrpos, myHero) then
		KSProcess = true
		
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = ksqpos.x, toY = ksqpos.z, fromX = ksqpos.x, fromY = ksqpos.z}):send(true)
			Packet('S_CAST', {spellId = _R, toX = ksrpos.x, toY = ksrpos.z, fromX = ksrpos.x, fromY = ksrpos.z}):send(true)
			else 
			CastSpell(_Q, ksqpos.x, ksqpos.z)
			CastSpell(_R, ksrpos.x, ksrpos.z)
			end
			
		else 
		KSProcess = false
		end
		
		if QReady and WReady and RReady and AutoCarry.PluginMenu.KSOptions.KSwithQ and AutoCarry.PluginMenu.KSOptions.KSwithW and AutoCarry.PluginMenu.KSOptions.KSwithR and ValidTarget(enemy, QRange) and not enemy.dead and enemy.visible and enemy.health < getDmg("Q",enemy,myHero) + getDmg("W",enemy,myHero) + getDmg("R",enemy,myHero) and myHero.mana >= MyMana(WQR) and ksqpos and ksqinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance and kswpos and kswinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.WHitchance and ksrpos and ksrinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.RHitchance and not Rcoll:GetMinionCollision(ksrpos, myHero) then
		KSProcess = true
		
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = kswpos.x, toY = kswpos.z, fromX = kswpos.x, fromY = kswpos.z}):send(true)
			Packet('S_CAST', {spellId = _Q, toX = ksqpos.x, toY = ksqpos.z, fromX = ksqpos.x, fromY = ksqpos.z}):send(true)
			Packet('S_CAST', {spellId = _R, toX = ksrpos.x, toY = ksrpos.z, fromX = ksrpos.x, fromY = ksrpos.z}):send(true)
			else 
			CastSpell(_W, kswpos.x, kswpos.z)
			CastSpell(_Q, ksqpos.x, ksqpos.z)
			CastSpell(_R, ksrpos.x, ksrpos.z)
			end
			
		else 
		KSProcess = false
		end

		

	end 

end 

 -- << --  -- << --  -- << --  -- << -- [COMBO]  -- >> --  -- >> --  -- >> --  -- >> --

function Combo()
	if not myts.target then return end
	
	if QReady and WReady and myHero.mana >= MyMana(WQ) and GetDistance(myts.target) <= QRange and AutoCarry.PluginMenu.Combo.UseQ and AutoCarry.PluginMenu.Combo.UseW then 
	local wpos, winfo = Prodiction.GetPrediction(myts.target, WRange, WSpeed, WDelay, WWidth, myPlayer)
	local qpos, qinfo = Prodiction.GetPrediction(myts.target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if wpos and winfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.WHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
		
		if qpos and qinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	end	
	
	if QReady and myHero.mana >= MyMana(Q) and GetDistance(myts.target) <= QRange and AutoCarry.PluginMenu.Combo.UseQ then 
	local qpos, qinfo = Prodiction.GetPrediction(myts.target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	end	
	
	if WReady and myHero.mana >= MyMana(W) and GetDistance(myts.target) <= WRange and AutoCarry.PluginMenu.Combo.UseW then 
	local wpos, winfo = Prodiction.GetPrediction(myts.target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		
		if wpos and winfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.WHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
	end	

end 


-- << --  -- << --  -- << --  -- << -- [HARASS]  -- >> --  -- >> --  -- >> --  -- >> --
 
function Harass1()
	if not myts.target then return end
	
	if AutoCarry.PluginMenu.Harass.Harass1UseQ and AutoCarry.PluginMenu.Harass.Harass1UseW and QReady and WReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and myHero.mana >= MyMana(WQ) and GetDistance(myts.target) <= QRange then

		local qpos, qinfo = Prodiction.GetPrediction(myts.target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local wpos, winfo = Prodiction.GetCircularAOEPrediction(myts.target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		
		if qpos and wpos and qinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance and winfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.WHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	end 
	
	if AutoCarry.PluginMenu.Harass.Harass1UseQ and QReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and myHero.mana >= MyMana(Q) and GetDistance(myts.target) <= QRange then

		local qpos, qinfo = Prodiction.GetPrediction(myts.target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	end 
	
	if AutoCarry.PluginMenu.Harass.Harass1UseW and WReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass1) and myHero.mana >= MyMana(W) and GetDistance(myts.target) <= WRange then
		local wpos, winfo = Prodiction.GetCircularAOEPrediction(myts.target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		
		if wpos and winfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.WHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
	end  

end 


function Harass2()
	if not myts.target then return end
	
	if AutoCarry.PluginMenu.Harass.Harass2UseQ and AutoCarry.PluginMenu.Harass.Harass2UseW and QReady and WReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and myHero.mana >= MyMana(WQ) and GetDistance(myts.target) <= QRange then

		local qpos, qinfo = Prodiction.GetPrediction(myts.target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		local wpos, winfo = Prodiction.GetCircularAOEPrediction(myts.target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		
		if qpos and wpos and qinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance and winfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.WHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	end 
	
	if AutoCarry.PluginMenu.Harass.Harass2UseQ and QReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and myHero.mana >= MyMana(Q) and GetDistance(myts.target) <= QRange then

		local qpos, qinfo = Prodiction.GetPrediction(myts.target, QRange, QSpeed, QDelay, QWidth, myPlayer)
		
		if qpos and qinfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.QHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	end 
	
	if AutoCarry.PluginMenu.Harass.Harass2UseW and WReady and not mymanaislowerthen(AutoCarry.PluginMenu.Harass.ManaSliderHarass2) and myHero.mana >= MyMana(W) and GetDistance(myts.target) <= WRange then
		local wpos, winfo = Prodiction.GetCircularAOEPrediction(myts.target, WRange, WSpeed, WDelay, WWidth, myPlayer)
		
		if wpos and winfo.hitchance >= AutoCarry.PluginMenu.ProdictionSettings.WHitchance then
			if AutoCarry.PluginMenu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end	
	end  

end 

-- << --  -- << --  -- << --  -- << -- [Draws]  -- >> --  -- >> --  -- >> --  -- >> --
function PluginOnDraw()

	if AutoCarry.PluginMenu.Draws.UselowfpsDraws then
		if AutoCarry.PluginMenu.Draws.DrawAARange and not myHero.dead then
		DrawCircleAA(myHero.x, myHero.y, myHero.z, AARange, ARGB(AutoCarry.PluginMenu.Draws.AASettings.colorAA[1],AutoCarry.PluginMenu.Draws.AASettings.colorAA[2],AutoCarry.PluginMenu.Draws.AASettings.colorAA[3],AutoCarry.PluginMenu.Draws.AASettings.colorAA[4]))
		end	
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
	
		if AutoCarry.PluginMenu.Draws.DrawAARange and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, AARange, 0xb9c3ed)
		end
		
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

--AA Range Circle QUality
function DrawCircleNextLvlAA(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(AutoCarry.PluginMenu.Draws.AASettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlAA(x, y, z, radius, AutoCarry.PluginMenu.Draws.AASettings.width, color, 75)	
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
	
	elseif spell == W then
	return 65 + (5 * myHero:GetSpellData(_W).level)
	
	elseif spell == R then
	return 100
	
	elseif spell == QR then
	return 50 + (10 * myHero:GetSpellData(_Q).level) + 100
	
	elseif spell == WQR then
	return 65 + (5 * myHero:GetSpellData(_W).level) + 50 + (10 * myHero:GetSpellData(_Q).level) + 100
	
	elseif spell == WQ then
	return 65 + (5 * myHero:GetSpellData(_W).level) + 50 + (10 * myHero:GetSpellData(_Q).level)
	end 
	
end
