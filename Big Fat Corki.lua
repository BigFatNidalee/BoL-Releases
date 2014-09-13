if myHero.charName ~= "Corki" then return end
local version = "0.28"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL-Releases/master/Big Fat Corki.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Big Fat Corki.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Big Fat Corki:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL-Releases/master/versions/bigfatcorki.version")
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
local loading_text = false 
local AARange = 615
local QRange, QSpeed, QDelay, QWidth = 825, 1500, 0.350, 250
local WRange = 800
local ERange, ESpeed, EDelay, EWidth = 610, 902, 0.5, 100
local RRange, RSpeed, RDelay, RWidth, RWidthCol = 1220, 2000, 0.200, 40, 60
local QReady, WReady, EReady, RReady = false, false, false, false
local lastSkin = 0
local corki_draws_aa_menu_loaded = false
local corki_draws_q_menu_loaded = false
local corki_draws_w_menu_loaded = false
local corki_draws_e_menu_loaded = false
local corki_draws_r_menu_loaded = false
local ts_dmg = DAMAGE_PHYSICAL
local whitelistrange = 1700 
local ksannouncerrange = 2000
local possibleks1 = false
local possibleks2 = false
local possibleks3 = false
local possibleks4 = false
local is_MMA = false
local is_SAC = false
local mma_menu_loaded = false
local sac_menu_loaded = false
local dmg = {}
function OnLoad()
	require "Collision"
	require "Prodiction"
	corki_harass_tables()	
	AddTickCallback(function() if corki_Menu.Draws.DrawAARange and corki_Menu.Draws.UselowfpsDraws and corki_draws_aa_menu_loaded == false then corki_draws_aa_menu() end end)
	AddTickCallback(function() if corki_Menu.Draws.DrawQRange and corki_Menu.Draws.UselowfpsDraws and corki_draws_q_menu_loaded == false then corki_draws_q_menu() end end)
	AddTickCallback(function() if corki_Menu.Draws.DrawWRange and corki_Menu.Draws.UselowfpsDraws and corki_draws_w_menu_loaded == false then corki_draws_w_menu() end end)
	AddTickCallback(function() if corki_Menu.Draws.DrawERange and corki_Menu.Draws.UselowfpsDraws and corki_draws_e_menu_loaded == false then corki_draws_e_menu() end end)
	AddTickCallback(function() if corki_Menu.Draws.DrawRRange and corki_Menu.Draws.UselowfpsDraws and corki_draws_r_menu_loaded == false then corki_draws_r_menu() end end)	
	AddTickCallback(function() if corki_Menu.SkinHack then SkinHack() end end)
	AddDrawCallback(function() if corki_Menu.Draws.DrawAARange and corki_Menu.Draws.UselowfpsDraws and corki_draws_aa_menu_loaded == true then corki_draw_AA() end end)
	AddDrawCallback(function() if corki_Menu.Draws.DrawQRange and corki_Menu.Draws.UselowfpsDraws and corki_draws_q_menu_loaded == true then corki_draw_Q() end end)
	AddDrawCallback(function() if corki_Menu.Draws.DrawWRange and corki_Menu.Draws.UselowfpsDraws and corki_draws_w_menu_loaded == true then corki_draw_W() end end)
	AddDrawCallback(function() if corki_Menu.Draws.DrawERange and corki_Menu.Draws.UselowfpsDraws and corki_draws_e_menu_loaded == true then corki_draw_E() end end)
	AddDrawCallback(function() if corki_Menu.Draws.DrawRRange and corki_Menu.Draws.UselowfpsDraws and corki_draws_r_menu_loaded == true then corki_draw_R() end end)
	AddDrawCallback(function() if corki_Menu.Draws.DrawAARange and not corki_Menu.Draws.UselowfpsDraws then corki_draw_AA_b() end end)
	AddDrawCallback(function() if corki_Menu.Draws.DrawQRange and not corki_Menu.Draws.UselowfpsDraws then corki_draw_Q_b() end end)
	AddDrawCallback(function() if corki_Menu.Draws.DrawWRange and not corki_Menu.Draws.UselowfpsDraws then corki_draw_W_b() end end)
	AddDrawCallback(function() if corki_Menu.Draws.DrawERange and not corki_Menu.Draws.UselowfpsDraws then corki_draw_E_b() end end)
	AddDrawCallback(function() if corki_Menu.Draws.DrawRRange and not corki_Menu.Draws.UselowfpsDraws then corki_draw_R_b() end end)				
	AddLoadCallback(function() corki_Menu() end)
	loading_text_start_delay = os.clock()
	PrintChat("<font color='#c9d7ff'>Big Fat Corki: </font><font color='#64f879'> v. "..version.." </font><font color='#c9d7ff'> loaded, good luck! </font>")	
end 
function OnTick()
	target_selector()
	ts:update()
	Target = getTarget()
	corki_tartgets()
	corki_Welcome()
	corki_ReadyCheck()
	if corki_Menu.Draws.KillAnnouncer then
	dmg2screen()
	end 
	if corki_Menu.KSOptions.enabled then
		KS()
	end 
	if not possibleks1 == true or not possibleks2 == true or not possibleks3 == true or not possibleks4 == true then
		if Target and corki_Menu.KeyBindings.Combo then 
		Combo() 
		end	
		if Target and corki_Menu.KeyBindings.Harass1 or corki_Menu.KeyBindings.Harass2 then 
		Harass() 
		end
	end
end 
function OnDraw()
	if corki_Menu.Draws.KillAnnouncer then
		for i = 1, #GetEnemyHeroes() do
		local enemy = GetEnemyHeroes()[i]
		if not enemy.dead and enemy.visible and ValidTarget(enemy) and enemy ~= nil then
			if dmg[i] ~= nil then 
			DrawText3D(tostring(dmg[i]), enemy.x, enemy.y, enemy.z, 16, ARGB(255, 255, 255, 0), true)
			end 
		end 
		end 
	end 
end 
	function corki_Menu()
		corki_Menu = scriptConfig("Big Fat Corki", "Big Fat Corki")		
		corki_Menu:addSubMenu("[Prodiction Settings]", "ProdictionSettings")
			corki_Menu.ProdictionSettings:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
			corki_Menu.ProdictionSettings:addParam("info0", "Combo", SCRIPT_PARAM_INFO, "")
			corki_Menu.ProdictionSettings:addParam("QHitCOM", "Q Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
			corki_Menu.ProdictionSettings:addParam("RHitCOM", "R Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
			corki_Menu.ProdictionSettings:addParam("blank", "", SCRIPT_PARAM_INFO, "")
			corki_Menu.ProdictionSettings:addParam("info1", "Harass", SCRIPT_PARAM_INFO, "")
			corki_Menu.ProdictionSettings:addParam("QHitHAR", "Q Hitchance", SCRIPT_PARAM_SLICE, 3, 1, 3, 0)
			corki_Menu.ProdictionSettings:addParam("RHitHAR", "R Hitchance", SCRIPT_PARAM_SLICE, 3, 1, 3, 0)
			corki_Menu.ProdictionSettings:addParam("blank2", "", SCRIPT_PARAM_INFO, "")
			corki_Menu.ProdictionSettings:addParam("info1", "HITCHANCE:", SCRIPT_PARAM_INFO, "")
			corki_Menu.ProdictionSettings:addParam("info2", "Faster <- LOW = 1  NORMAL = 2  HIGH = 3 -> Slower", SCRIPT_PARAM_INFO, "")	
		corki_Menu:addSubMenu("[Combo]", "Combo")
			corki_Menu.Combo:addParam("UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
			corki_Menu.Combo:addParam("UseE","Use E", SCRIPT_PARAM_ONOFF, true)
			corki_Menu.Combo:addParam("UseR","Use R", SCRIPT_PARAM_ONOFF, true)
		corki_Menu:addSubMenu("[Harass]", "Harass")
			corki_Menu.Harass:addParam("HarassUseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
			corki_Menu.Harass:addParam("HarassUseE","Use E", SCRIPT_PARAM_ONOFF, false)
			corki_Menu.Harass:addParam("HarassUseR","Use R", SCRIPT_PARAM_ONOFF, true)
			corki_Menu.Harass:addParam("ManaSliderHarass", "Use mana till :",   SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
			corki_Menu.Harass:addParam("blank1", "", SCRIPT_PARAM_INFO, "")
			corki_Menu.Harass:addParam("UseWhiteList","Use White List", SCRIPT_PARAM_ONOFF, true)
			corki_Menu.Harass:addParam("whitelistexception","exception if White List Out Of Range", SCRIPT_PARAM_ONOFF, true)
			corki_Menu.Harass:addParam("blank2", "", SCRIPT_PARAM_INFO, "")
			corki_Menu.Harass:addParam("harassinfo", "Harass White List:", SCRIPT_PARAM_INFO, "")		
		for i = 1, #GetEnemyHeroes() do
		local enemy = GetEnemyHeroes()[i]
			if whitelisted[""..enemy.charName..""] == true then 
			corki_Menu.Harass:addParam(enemy.hash, enemy.charName, SCRIPT_PARAM_ONOFF, true)
			end 		
			if whitelisted[""..enemy.charName..""] == nil then
			corki_Menu.Harass:addParam(enemy.hash, enemy.charName, SCRIPT_PARAM_ONOFF, false)
			end 
		end 
		corki_Menu:addSubMenu("[KS Options]", "KSOptions")
			corki_Menu.KSOptions:addParam("enabled","Enable KS", SCRIPT_PARAM_ONOFF, true)
			corki_Menu.KSOptions:addParam("KSwithAA","KS with AA", SCRIPT_PARAM_ONOFF, true)
			corki_Menu.KSOptions:addParam("KSwithQ","KS with Q", SCRIPT_PARAM_ONOFF, true)
			corki_Menu.KSOptions:addParam("KSwithR","KS with R", SCRIPT_PARAM_ONOFF, true)
		corki_Menu:addSubMenu("[Draws]", "Draws")
			corki_Menu.Draws:addParam("UselowfpsDraws","Use low fps Draws", SCRIPT_PARAM_ONOFF, true)
			corki_Menu.Draws:addParam("KillAnnouncer","Kill Announcer", SCRIPT_PARAM_ONOFF, true)
			corki_Menu.Draws:addParam("DrawAARange","Draw AA Range", SCRIPT_PARAM_ONOFF, true)
			corki_Menu.Draws:addParam("DrawQRange","Draw Q Range", SCRIPT_PARAM_ONOFF, false)
			corki_Menu.Draws:addParam("DrawWRange","Draw W Range", SCRIPT_PARAM_ONOFF, false)
			corki_Menu.Draws:addParam("DrawERange","Draw E Range", SCRIPT_PARAM_ONOFF, false)
			corki_Menu.Draws:addParam("DrawRRange","Draw R Range", SCRIPT_PARAM_ONOFF, false)
		corki_Menu:addSubMenu("[Key Bindings]", "KeyBindings")
			corki_Menu.KeyBindings:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			corki_Menu.KeyBindings:addParam("Harass1","Harass 1", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			corki_Menu.KeyBindings:addParam("Harass2","Harass 2", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))		
		corki_Menu:addSubMenu("[Target Selector]", "TargetSelector")
		corki_Menu.TargetSelector:addParam("mode", "Current Dmg Mode:", SCRIPT_PARAM_LIST, 1, {"Physical ", "Magical"})
		corki_Menu.TargetSelector:addParam("corki", "Use Standart Target Selector", SCRIPT_PARAM_ONOFF, true)		
		corki_Menu:addParam("blank", "", SCRIPT_PARAM_INFO, "")
		corki_Menu:addParam("SkinHack","Use Skin Hack", SCRIPT_PARAM_ONOFF, false)
		corki_Menu:addParam("skin", "Skin Hack by Shalzuth:", SCRIPT_PARAM_LIST, 5, { "UFO", "Ice Toboggan", "Red Baron", "Hot Rod", "Urfrider", "Dragonwing", "No Skin" })
		corki_Menu:addParam("blank", "", SCRIPT_PARAM_INFO, "")
		corki_Menu:addParam("about1", "Big Fat Corki v. "..version.."", SCRIPT_PARAM_INFO, "")
		corki_Menu:addParam("about2", "by Big Fat Nidalee", SCRIPT_PARAM_INFO, "")
		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, RRange, ts_dmg)
		ts.name = "Target "
		corki_Menu.TargetSelector:addTS(ts)
	end 
	function corki_Welcome()
		if loading_text == false and os.clock() >= loading_text_start_delay+1 then
		PrintFloatText(myHero, 11, "Big Fat Corki: v. "..version.." loaded!")
		loading_text = true
		end 
	end 
function target_selector()
	if mma_menu_loaded == false and sac_menu_loaded == false then
		if is_MMA == false and is_SAC == false then
			if _G.MMA_Loaded then
				PrintChat("<font color='#c9d7ff'>Big Fat Corki: </font><font color='#64f879'> MMA Detected! </font><font color='#c9d7ff'> MMA Support loaded! </font>")
				is_MMA = true
			end	
			if _G.AutoCarry then
				PrintChat("<font color='#c9d7ff'>Big Fat Corki: </font><font color='#64f879'> SAC Detected! </font><font color='#c9d7ff'> SAC Support loaded! </font>")
				is_SAC = true
			end	
		end 
		if mma_menu_loaded == false and is_MMA == true then
		corki_Menu.TargetSelector:addParam("mma", "Use MMA Target Selector", SCRIPT_PARAM_ONOFF, false)
		mma_menu_loaded = true
		end 
		if sac_menu_loaded == false and is_SAC == true then
		corki_Menu.TargetSelector:addParam("sac", "Use SAC Target Selector", SCRIPT_PARAM_ONOFF, false)
		sac_menu_loaded = true
		end 
	end 
end 
function getTarget()
	if is_MMA and is_SAC then		
		if corki_Menu.TargetSelector.mma then
			corki_Menu.TargetSelector.sac = false
			corki_Menu.TargetSelector.corki = false
		elseif corki_Menu.TargetSelector.sac then
			corki_Menu.TargetSelector.mma = false
			corki_Menu.TargetSelector.corki = false
		elseif	corki_Menu.TargetSelector.corki then
			corki_Menu.TargetSelector.mma = false
			corki_Menu.TargetSelector.sac = false
		end
	end	
	if not is_MMA and is_SAC then
		if corki_Menu.TargetSelector.sac then
			corki_Menu.TargetSelector.corki = false
		else
			corki_Menu.TargetSelector.corki = true
		end	
	end
	if is_MMA and not is_SAC then
		if corki_Menu.TargetSelector.mma then
			corki_Menu.TargetSelector.corki = false
		else
			corki_Menu.TargetSelector.corki = true
		end	
	end
	if not is_MMA and not is_SAC then
		corki_Menu.TargetSelector.corki = true	
	end		
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then
		return _G.MMA_Target 
	end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then
		return _G.AutoCarry.Attack_Crosshair.target		
	end
    return ts.target	
end
	function corki_draws_aa_menu()
	corki_Menu.Draws:addSubMenu("[AA Settings]", "AASettings")
	corki_Menu.Draws.AASettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	corki_Menu.Draws.AASettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	corki_Menu.Draws.AASettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
	corki_draws_aa_menu_loaded = true
	end 
	function corki_draws_q_menu()
	corki_Menu.Draws:addSubMenu("[Q Settings]", "QSettings")
	corki_Menu.Draws.QSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	corki_Menu.Draws.QSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	corki_Menu.Draws.QSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
	corki_draws_q_menu_loaded = true
	end 
	function corki_draws_w_menu()
	corki_Menu.Draws:addSubMenu("[W Settings]", "WSettings")
	corki_Menu.Draws.WSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	corki_Menu.Draws.WSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	corki_Menu.Draws.WSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
	corki_draws_w_menu_loaded = true	
	end 
	function corki_draws_e_menu()
	corki_Menu.Draws:addSubMenu("[E Settings]", "ESettings")
	corki_Menu.Draws.ESettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	corki_Menu.Draws.ESettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	corki_Menu.Draws.ESettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
	corki_draws_e_menu_loaded = true	
	end 
	function corki_draws_r_menu()
	corki_Menu.Draws:addSubMenu("[R Settings]", "RSettings")
	corki_Menu.Draws.RSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	corki_Menu.Draws.RSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	corki_Menu.Draws.RSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
	corki_draws_r_menu_loaded = true	
	end 
	function corki_ReadyCheck()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	end 
	function corki_tartgets()
		if corki_Menu.TargetSelector.mode == 1 then 
		ts_dmg = DAMAGE_PHYSICAL
		end 
		if corki_Menu.TargetSelector.mode == 2 then 
		ts_dmg = DAMAGE_MAGIC
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
	function SkinHack()
	if corki_Menu.skin ~= lastSkin and VIP_USER then
		lastSkin = corki_Menu.skin
		GenModelPacket("Corki", corki_Menu.skin)
	end
	end
function KS()
	for i = 1, #GetEnemyHeroes() do
	local enemy = GetEnemyHeroes()[i]
		if not enemy.dead and enemy.visible and ValidTarget(enemy) and enemy ~= nil then
			if QReady and corki_Menu.KSOptions.KSwithQ and ValidTarget(enemy, QRange) and enemy.health < getDmg("Q",enemy,myHero) and myHero.mana >= CorkiMana(Q) then
			possibleks1 = true
				local qpos, qinfo = Prodiction.GetPrediction(enemy, QRange, QSpeed, QDelay, QWidth, myPlayer)
				if qpos and qinfo.hitchance >= 2 then
					if corki_Menu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
					else 
					CastSpell(_Q, qpos.x, qpos.z)
					end
				end
			else 
			possibleks1 = false
			end 
			if RReady and corki_Menu.KSOptions.KSwithR and ValidTarget(enemy, RRange) and enemy.health < getDmg("R",enemy,myHero) and myHero.mana >= CorkiMana(R) then
			possibleks2 = true
				local rpos, rinfo = Prodiction.GetPrediction(enemy, RRange, RSpeed, RDelay, RWidth, myPlayer)
				local coll = Collision(RRange, RSpeed, RDelay, RWidthCol)
				if rpos and rinfo.hitchance >= 2 and not coll:GetMinionCollision(rpos, myHero) then
					if corki_Menu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
					else 
					CastSpell(_R, rpos.x, rpos.z)
					end
				end
			else 
			possibleks2 = false
			end
			if RReady and QReady and corki_Menu.KSOptions.KSwithR and corki_Menu.KSOptions.KSwithQ and ValidTarget(enemy, QRange) and enemy.health < getDmg("R",enemy,myHero) + getDmg("Q",enemy,myHero) and myHero.mana >= CorkiMana(QR) then
			possibleks3 = true
				local rpos, rinfo = Prodiction.GetPrediction(enemy, RRange, RSpeed, RDelay, RWidth, myPlayer)
				local qpos, qinfo = Prodiction.GetPrediction(enemy, QRange, QSpeed, QDelay, QWidth, myPlayer)
				local coll = Collision(RRange, RSpeed, RDelay, RWidthCol)
				if rpos and qpos and rinfo.hitchance >= 2 and qinfo.hitchance >= 2 and not coll:GetMinionCollision(rpos, myHero) then
					if corki_Menu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
					else 
					CastSpell(_Q, qpos.x, qpos.z)
					end
					if corki_Menu.ProdictionSettings.UsePacketsCast then
					Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
					else 
					CastSpell(_R, rpos.x, rpos.z)
					end
				end
			else 
			possibleks3 = false
			end	
			if corki_Menu.KSOptions.KSwithAA and ValidTarget(enemy, AARange) and enemy.health < getDmg("AD",enemy,myHero) then
			possibleks4 = true
			myHero:Attack(enemy)
			else 
			possibleks4 = false			
			end	
		else
		possibleks1 = false
		possibleks2 = false
		possibleks3 = false
		possibleks4 = false
		end
	end
end 
function Combo()
	if not Target then return end
	if corki_Menu.Combo.UseQ and QReady and GetDistance(Target) <= QRange then
		local qpos, qinfo = Prodiction.GetCircularAOEPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)	
		if qpos and qinfo.hitchance >= corki_Menu.ProdictionSettings.QHitCOM then
			if corki_Menu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end	
	end 
	if corki_Menu.Combo.UseE and EReady and GetDistance(Target) <= ERange then
		local epos, einfo = Prodiction.GetPrediction(Target, ERange, ESpeed, EDelay, EWidth, myPlayer)
		if epos and einfo.hitchance >= 1 then
			if corki_Menu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
			else 
			CastSpell(_E, epos.x, epos.z)
			end
		end	
	end  
	if corki_Menu.Combo.UseR and RReady and GetDistance(Target) <= RRange then
		local rpos, rinfo = Prodiction.GetPrediction(Target, RRange, RSpeed, RDelay, RWidth, myPlayer)
		local coll = Collision(RRange, RSpeed, RDelay, RWidthCol)
		if rpos and rinfo.hitchance >= corki_Menu.ProdictionSettings.RHitCOM and not coll:GetMinionCollision(rpos, myHero) then
			if corki_Menu.ProdictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
		end	
	end 
end 
function dmg2screen()
	for i = 1, #GetEnemyHeroes() do
	local enemy = GetEnemyHeroes()[i]
		if not enemy.dead and enemy.visible and ValidTarget(enemy) and enemy ~= nil and GetDistance(enemy) <= ksannouncerrange then
			if enemy.health < getDmg("AD",enemy,myHero) then
			dmg[i] = "possible kill: AA"
			elseif QReady and enemy.health < getDmg("Q",enemy,myHero) and myHero.mana >= CorkiMana(Q) then
			dmg[i] = "possible kill: Q"
			elseif QReady and enemy.health < getDmg("Q",enemy,myHero) + getDmg("AD",enemy,myHero) and myHero.mana >= CorkiMana(Q) then
			dmg[i] = "possible kill: Q + AA"
			elseif RReady and enemy.health < getDmg("R",enemy,myHero) and myHero.mana >= CorkiMana(R) then
			dmg[i] = "possible kill: R"
			elseif RReady and QReady and enemy.health < getDmg("R",enemy,myHero) + getDmg("Q",enemy,myHero) and myHero.mana >= CorkiMana(QR) then
			dmg[i] = "possible kill: Q + R"
			elseif RReady and QReady and enemy.health < getDmg("R",enemy,myHero) + getDmg("Q",enemy,myHero) + getDmg("AD",enemy,myHero) and myHero.mana >= CorkiMana(QR) then
			dmg[i] = "possible kill: Q + R + AA"
			else
			dmg[i] = nil
			end 
		end 
		if enemy.dead then
		dmg[i] = nil
		end 
	end 
end 
function Harass()
if not Target then return end
	if not CorkiManaislowerthen(corki_Menu.Harass.ManaSliderHarass) then
		if corki_Menu.Harass.UseWhiteList then
			for i = 1, #GetEnemyHeroes() do
			local enemy = GetEnemyHeroes()[i]
				if corki_Menu.Harass[enemy.hash] then
				if GetDistance(enemy) <= whitelistrange and not enemy.dead and enemy.visible then
					if corki_Menu.Harass.HarassUseQ and QReady and GetDistance(enemy) <= QRange then
						local qpos, qinfo = Prodiction.GetCircularAOEPrediction(enemy, QRange, QSpeed, QDelay, QWidth, myPlayer)
						if qpos and qinfo.hitchance >= corki_Menu.ProdictionSettings.QHitHAR then
							if corki_Menu.ProdictionSettings.UsePacketsCast then
							Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
							else 
							CastSpell(_Q, qpos.x, qpos.z)
							end
						end	
					end 
					if corki_Menu.Harass.HarassUseE and EReady and GetDistance(enemy) <= ERange then
						local epos, einfo = Prodiction.GetPrediction(enemy, ERange, ESpeed, EDelay, EWidth, myPlayer)
						if epos and einfo.hitchance >= 1 then
							if corki_Menu.ProdictionSettings.UsePacketsCast then
							Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
							else 
							CastSpell(_E, epos.x, epos.z)
							end
						end	
					end  
					if corki_Menu.Harass.HarassUseR and RReady and GetDistance(enemy) <= RRange then
						local rpos, rinfo = Prodiction.GetPrediction(enemy, RRange, RSpeed, RDelay, RWidth, myPlayer)
						local coll = Collision(RRange, RSpeed, RDelay, RWidthCol)
						if rpos and rinfo.hitchance >= corki_Menu.ProdictionSettings.RHitHAR and not coll:GetMinionCollision(rpos, myHero) then
							if corki_Menu.ProdictionSettings.UsePacketsCast then
							Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
							else 
							CastSpell(_R, rpos.x, rpos.z)
							end
						end	
					end
				end
				if corki_Menu.Harass.whitelistexception then
				if GetDistance(enemy) >= whitelistrange or enemy.dead or not enemy.visible then
					if corki_Menu.Harass.HarassUseQ and QReady and GetDistance(Target) <= QRange then
						local qpos, qinfo = Prodiction.GetCircularAOEPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
						if qpos and qinfo.hitchance >= corki_Menu.ProdictionSettings.QHitHAR then
							if corki_Menu.ProdictionSettings.UsePacketsCast then
							Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
							else 
							CastSpell(_Q, qpos.x, qpos.z)
							end
						end	
					end 
					if corki_Menu.Harass.HarassUseE and EReady and GetDistance(Target) <= ERange then
						local epos, einfo = Prodiction.GetPrediction(Target, ERange, ESpeed, EDelay, EWidth, myPlayer)
						if epos and einfo.hitchance >= 1 then
							if corki_Menu.ProdictionSettings.UsePacketsCast then
							Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
							else 
							CastSpell(_E, epos.x, epos.z)
							end
						end	
					end  
					if corki_Menu.Harass.HarassUseR and RReady and GetDistance(Target) <= RRange then
						local rpos, rinfo = Prodiction.GetPrediction(Target, RRange, RSpeed, RDelay, RWidth, myPlayer)
						local coll = Collision(RRange, RSpeed, RDelay, RWidthCol)
						if rpos and rinfo.hitchance >= corki_Menu.ProdictionSettings.RHitHAR and not coll:GetMinionCollision(rpos, myHero) then
							if corki_Menu.ProdictionSettings.UsePacketsCast then
							Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
							else 
							CastSpell(_R, rpos.x, rpos.z)
							end
						end	
					end 
				end 
				end 
				end 
			end 
		end 
		if not corki_Menu.Harass.UseWhiteList then
					if corki_Menu.Harass.HarassUseQ and QReady and GetDistance(Target) <= QRange then
						local qpos, qinfo = Prodiction.GetCircularAOEPrediction(Target, QRange, QSpeed, QDelay, QWidth, myPlayer)
						if qpos and qinfo.hitchance >= corki_Menu.ProdictionSettings.QHitHAR then
							if corki_Menu.ProdictionSettings.UsePacketsCast then
							Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
							else 
							CastSpell(_Q, qpos.x, qpos.z)
							end
						end	
					end 
					if corki_Menu.Harass.HarassUseE and EReady and GetDistance(Target) <= ERange then
						local epos, einfo = Prodiction.GetPrediction(Target, ERange, ESpeed, EDelay, EWidth, myPlayer)
						if epos and einfo.hitchance >= 1 then
							if corki_Menu.ProdictionSettings.UsePacketsCast then
							Packet('S_CAST', {spellId = _E, toX = epos.x, toY = epos.z, fromX = epos.x, fromY = epos.z}):send(true)
							else 
							CastSpell(_E, epos.x, epos.z)
							end
						end	
					end  
					if corki_Menu.Harass.HarassUseR and RReady and GetDistance(Target) <= RRange then
						local rpos, rinfo = Prodiction.GetPrediction(Target, RRange, RSpeed, RDelay, RWidth, myPlayer)
						local coll = Collision(RRange, RSpeed, RDelay, RWidthCol)
						if rpos and rinfo.hitchance >= corki_Menu.ProdictionSettings.RHitHAR and not coll:GetMinionCollision(rpos, myHero) then
							if corki_Menu.ProdictionSettings.UsePacketsCast then
							Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
							else 
							CastSpell(_R, rpos.x, rpos.z)
							end
						end	
					end
		end 
	end 
end 
	function corki_draw_AA()
		if not myHero.dead then
		DrawCircleAA(myHero.x, myHero.y, myHero.z, AARange, ARGB(corki_Menu.Draws.AASettings.colorAA[1],corki_Menu.Draws.AASettings.colorAA[2],corki_Menu.Draws.AASettings.colorAA[3],corki_Menu.Draws.AASettings.colorAA[4]))
		end
	end 
	function corki_draw_Q()
		if not myHero.dead and QReady then
		DrawCircleQ(myHero.x, myHero.y, myHero.z, QRange, ARGB(corki_Menu.Draws.QSettings.colorAA[1],corki_Menu.Draws.QSettings.colorAA[2],corki_Menu.Draws.QSettings.colorAA[3],corki_Menu.Draws.QSettings.colorAA[4]))
		end
	end  
	function corki_draw_W()
		if not myHero.dead and WReady then
		DrawCircleW(myHero.x, myHero.y, myHero.z, WRange, ARGB(corki_Menu.Draws.WSettings.colorAA[1],corki_Menu.Draws.WSettings.colorAA[2],corki_Menu.Draws.WSettings.colorAA[3],corki_Menu.Draws.WSettings.colorAA[4]))
		end
	end  
	function corki_draw_E()
		if not myHero.dead and EReady then
		DrawCircleE(myHero.x, myHero.y, myHero.z, ERange, ARGB(corki_Menu.Draws.ESettings.colorAA[1],corki_Menu.Draws.ESettings.colorAA[2],corki_Menu.Draws.ESettings.colorAA[3],corki_Menu.Draws.ESettings.colorAA[4]))
		end	
	end  
	function corki_draw_R()
		if not myHero.dead and RReady then
		DrawCircleR(myHero.x, myHero.y, myHero.z, RRange, ARGB(corki_Menu.Draws.RSettings.colorAA[1],corki_Menu.Draws.RSettings.colorAA[2],corki_Menu.Draws.RSettings.colorAA[3],corki_Menu.Draws.RSettings.colorAA[4]))
		end	
	end 
	function corki_draw_AA_b()
		if not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, AARange, 0xb9c3ed)
		end
	end 
	function corki_draw_Q_b()
		if not myHero.dead and QReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0xb9c3ed)
		end
	end  
	function corki_draw_W_b()
		if not myHero.dead and WReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0xb9c3ed)
		end
	end  
	function corki_draw_E_b()
		if not myHero.dead and EReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0xb9c3ed)
		end	
	end  
	function corki_draw_R_b()
		if not myHero.dead and RReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xb9c3ed)
		end	
	end 
function DrawCircleNextLvlAA(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(corki_Menu.Draws.AASettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end
function DrawCircleAA(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlAA(x, y, z, radius, corki_Menu.Draws.AASettings.width, color, 75)	
	end
end
function DrawCircleNextLvlQ(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(corki_Menu.Draws.QSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end
function DrawCircleQ(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlQ(x, y, z, radius, corki_Menu.Draws.QSettings.width, color, 75)	
	end
end
function DrawCircleNextLvlW(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(corki_Menu.Draws.WSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end
function DrawCircleW(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlW(x, y, z, radius, corki_Menu.Draws.WSettings.width, color, 75)	
	end
end
function DrawCircleNextLvlE(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(corki_Menu.Draws.ESettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end
function DrawCircleE(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlE(x, y, z, radius, corki_Menu.Draws.ESettings.width, color, 75)	
	end
end 
function DrawCircleNextLvlR(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(corki_Menu.Draws.RSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end
function DrawCircleR(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlR(x, y, z, radius, corki_Menu.Draws.RSettings.width, color, 75)	
	end
end 
function CorkiMana(spell)
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
function CorkiManaislowerthen(percent)
    if myHero.mana < (myHero.maxMana * ( percent / 100)) then
        return true
    else
        return false
    end
end
function corki_harass_tables()
	whitelisted={}
	whitelisted["Ashe"] = true
	whitelisted["Caitlyn"] = true
	whitelisted["Corki"] = true
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
