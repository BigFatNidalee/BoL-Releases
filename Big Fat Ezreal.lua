if myHero.charName ~= "Ezreal" then return end

local version = "0.02"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BigFatNidalee/BoL-Releases/master/Big Fat Ezreal.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Big Fat Ezreal.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#66cc00\">Big Fat Ezreal.lua:</font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/BigFatNidalee/BoL-Releases/master/versions/Big Fat Ezreal.version")
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
--
local autor = "Big Fat Nidalee"
local scriptname = "Big Fat Ezreal"
local loading_text = false 
--
local AARange = 615 
local QReady, WReady, EReady, RReady = false, false, false, false
local QRange, QSpeed, QDelay, QWidth, QWidthCol = 1200, 2025, 0.240, 50, 60
local WRange, WSpeed, WDelay, WWidth = 1050, 1600, 0, 60
local ERange = 475
local RRange, RSpeed, RDelay, RWidth = 25000, 2000, 0.980, 120

--
local QRangeCut, WRangeCut = 1080, 925
--
--
local QHitPRO = 2
local WHitPRO = 2
local QHitVPRE = 2
local WHitVPRE = 2
--
local whitelistrange = 1700 
local TSRange = 1500
local ts_dmg = DAMAGE_PHYSICAL
local is_MMA = false
local is_SAC = false
local mma_menu_loaded = false
local sac_menu_loaded = false
--
local lastSkin = 0
local draws_aa_menu_loaded = false
local draws_q_menu_loaded = false
local draws_w_menu_loaded = false
local draws_e_menu_loaded = false
--
local possibleks1 = false
local possibleks2 = false
local possibleks3 = false
local possibleks4 = false

--
function OnLoad()
	require "Collision"
	require "Prodiction"
	require "VPrediction"
	VP = VPrediction()
	harass_tables()	
	AddTickCallback(function() if Menu.Draws.DrawAARange and Menu.Draws.UselowfpsDraws and draws_aa_menu_loaded == false then draws_aa_menu() end end)
	AddTickCallback(function() if Menu.Draws.DrawQRange and Menu.Draws.UselowfpsDraws and draws_q_menu_loaded == false then draws_q_menu() end end)
	AddTickCallback(function() if Menu.Draws.DrawWRange and Menu.Draws.UselowfpsDraws and draws_w_menu_loaded == false then draws_w_menu() end end)
	AddTickCallback(function() if Menu.Draws.DrawERange and Menu.Draws.UselowfpsDraws and draws_e_menu_loaded == false then draws_e_menu() end end)
	AddTickCallback(function() if Menu.Draws.DrawRRange and Menu.Draws.UselowfpsDraws and draws_r_menu_loaded == false then draws_r_menu() end end)	
	AddTickCallback(function() if Menu.SkinHack then SkinHack() end end)
	AddDrawCallback(function() if Menu.Draws.DrawAARange and Menu.Draws.UselowfpsDraws and draws_aa_menu_loaded == true then draw_AA() end end)
	AddDrawCallback(function() if Menu.Draws.DrawQRange and Menu.Draws.UselowfpsDraws and draws_q_menu_loaded == true then draw_Q() end end)
	AddDrawCallback(function() if Menu.Draws.DrawWRange and Menu.Draws.UselowfpsDraws and draws_w_menu_loaded == true then draw_W() end end)
	AddDrawCallback(function() if Menu.Draws.DrawERange and Menu.Draws.UselowfpsDraws and draws_e_menu_loaded == true then draw_E() end end)
	AddDrawCallback(function() if Menu.Draws.DrawRRange and Menu.Draws.UselowfpsDraws and draws_r_menu_loaded == true then draw_R() end end)
	AddDrawCallback(function() if Menu.Draws.DrawAARange and not Menu.Draws.UselowfpsDraws then draw_AA_b() end end)
	AddDrawCallback(function() if Menu.Draws.DrawQRange and not Menu.Draws.UselowfpsDraws then draw_Q_b() end end)
	AddDrawCallback(function() if Menu.Draws.DrawWRange and not Menu.Draws.UselowfpsDraws then draw_W_b() end end)
	AddDrawCallback(function() if Menu.Draws.DrawERange and not Menu.Draws.UselowfpsDraws then draw_E_b() end end)
	AddDrawCallback(function() if Menu.Draws.DrawRRange and not Menu.Draws.UselowfpsDraws then draw_R_b() end end)				
	AddLoadCallback(function() Menu() end)
	loading_text_start_delay = os.clock()
	PrintChat("<font color='#c9d7ff'>"..scriptname..": </font><font color='#64f879'> v. "..version.." </font><font color='#c9d7ff'> loaded, good luck! </font>")	
end 
function OnTick()

	target_selector()
	ts:update()
	Target = getTarget()
	tartgets()
	Welcome()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	ks()
	carry_me()
	
	if Menu.KeyBindings.WE2Mouse then
	CastSpell(_E, mousePos.x, mousePos.z)
	end 
end 
--
	function Menu()
		Menu = scriptConfig(scriptname, scriptname)		
		Menu:addSubMenu("[Prediction Options]", "PredictionSettings")
			Menu.PredictionSettings:addSubMenu("[Prodiction Settings]", "ProdictionSettings")
				Menu.PredictionSettings.ProdictionSettings:addParam("info0", "Combo", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.ProdictionSettings:addParam("QHitCOM", "Q Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
				Menu.PredictionSettings.ProdictionSettings:addParam("WHitCOM", "W Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
				Menu.PredictionSettings.ProdictionSettings:addParam("blank", "", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.ProdictionSettings:addParam("info1", "Harass", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.ProdictionSettings:addParam("QHitHAR", "Q Hitchance", SCRIPT_PARAM_SLICE, 3, 1, 3, 0)
				Menu.PredictionSettings.ProdictionSettings:addParam("WHitHAR", "W Hitchance", SCRIPT_PARAM_SLICE, 3, 1, 3, 0)
				Menu.PredictionSettings.ProdictionSettings:addParam("blank2", "", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.ProdictionSettings:addParam("info1", "HITCHANCE:", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.ProdictionSettings:addParam("info2", "Faster <- LOW = 1  NORMAL = 2  HIGH = 3 -> Slower", SCRIPT_PARAM_INFO, "")	
			Menu.PredictionSettings:addSubMenu("[VPrediction Settings]", "VPredictionSettings")
				Menu.PredictionSettings.VPredictionSettings:addParam("info0", "Combo", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.VPredictionSettings:addParam("QHitCOM", "Q Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
				Menu.PredictionSettings.VPredictionSettings:addParam("WHitCOM", "W Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
				Menu.PredictionSettings.VPredictionSettings:addParam("blank", "", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.VPredictionSettings:addParam("info1", "Harass", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.VPredictionSettings:addParam("QHitHAR", "Q Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
				Menu.PredictionSettings.VPredictionSettings:addParam("WHitHAR", "W Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
				Menu.PredictionSettings.VPredictionSettings:addParam("blank2", "", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.VPredictionSettings:addParam("info1", "HITCHANCE:", SCRIPT_PARAM_INFO, "")
				Menu.PredictionSettings.VPredictionSettings:addParam("info2", "LOW = 1  HIGH = 2  only if Target CC'ed/slowed = 3", SCRIPT_PARAM_INFO, "")	
			Menu.PredictionSettings:addParam("UsePacketsCast","Use Packets Cast", SCRIPT_PARAM_ONOFF, true)
			Menu.PredictionSettings:addParam("mode", "Current Prediction:", SCRIPT_PARAM_LIST, 1, {"Prodiction ", "VPrediction"})
		Menu:addSubMenu("[Combo]", "Combo")
			Menu.Combo:addParam("UseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("UseW","Use W", SCRIPT_PARAM_ONOFF, false)
		Menu:addSubMenu("[Harass]", "Harass")
			Menu.Harass:addParam("HarassUseQ","Use Q", SCRIPT_PARAM_ONOFF, true)
			Menu.Harass:addParam("HarassUseW","Use W", SCRIPT_PARAM_ONOFF, false)
			Menu.Harass:addParam("ManaSliderHarass", "Use mana till :",   SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
			Menu.Harass:addParam("blank1", "", SCRIPT_PARAM_INFO, "")
			Menu.Harass:addParam("UseWhiteList","Use White List", SCRIPT_PARAM_ONOFF, true)
			Menu.Harass:addParam("whitelistexception","exception if White List Out Of Range", SCRIPT_PARAM_ONOFF, true)
			Menu.Harass:addParam("blank2", "", SCRIPT_PARAM_INFO, "")
			Menu.Harass:addParam("harassinfo", "Harass White List:", SCRIPT_PARAM_INFO, "")		
		for i = 1, #GetEnemyHeroes() do
		local enemy = GetEnemyHeroes()[i]
			if whitelisted[""..enemy.charName..""] == true then 
			Menu.Harass:addParam(enemy.hash, enemy.charName, SCRIPT_PARAM_ONOFF, true)
			end 		
			if whitelisted[""..enemy.charName..""] == nil then
			Menu.Harass:addParam(enemy.hash, enemy.charName, SCRIPT_PARAM_ONOFF, false)
			end 
		end 
		Menu:addSubMenu("[KS Options]", "KSOptions")
			Menu.KSOptions:addParam("enabled","Enable KS", SCRIPT_PARAM_ONOFF, true)
			Menu.KSOptions:addParam("KSwithAA","KS with AA", SCRIPT_PARAM_ONOFF, true)
			Menu.KSOptions:addParam("KSwithQ","KS with Q", SCRIPT_PARAM_ONOFF, true)
			Menu.KSOptions:addParam("KSwithW","KS with W", SCRIPT_PARAM_ONOFF, true)
			Menu.KSOptions:addParam("KSwithR","KS with R", SCRIPT_PARAM_ONOFF, true)
			Menu.KSOptions:addParam("min", "min distance",   SCRIPT_PARAM_SLICE, 600, 0, 2000, 0)
			Menu.KSOptions:addParam("max", "max distance",   SCRIPT_PARAM_SLICE, 1500, 0, 2000, 0)
		Menu:addSubMenu("[Draws]", "Draws")
	Menu.Draws:addSubMenu("[WE2Mouse Settings]", "WESettings")
	Menu.Draws.WESettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	Menu.Draws.WESettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	Menu.Draws.WESettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
			Menu.Draws:addParam("UselowfpsDraws","Use low fps Draws", SCRIPT_PARAM_ONOFF, true)
			--Menu.Draws:addParam("KillAnnouncer","Kill Announcer", SCRIPT_PARAM_ONOFF, true)
			Menu.Draws:addParam("DrawAARange","Draw AA Range", SCRIPT_PARAM_ONOFF, true)
			Menu.Draws:addParam("DrawQRange","Draw Q Range", SCRIPT_PARAM_ONOFF, false)
			Menu.Draws:addParam("DrawWRange","Draw W Range", SCRIPT_PARAM_ONOFF, false)
			Menu.Draws:addParam("DrawERange","Draw E Range", SCRIPT_PARAM_ONOFF, false)
			Menu.Draws:addParam("WE2Mouse","Draw WE2Mouse helper", SCRIPT_PARAM_ONOFF, false)

		Menu:addSubMenu("[Key Bindings]", "KeyBindings")
			Menu.KeyBindings:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			Menu.KeyBindings:addParam("Harass1","Harass 1", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			Menu.KeyBindings:addParam("Harass2","Harass 2", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
			Menu.KeyBindings:addParam("WE2Mouse","W E 2 Mouse", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("S"))
			
			
		Menu:addSubMenu("[Target Selector]", "TargetSelector")
		Menu.TargetSelector:addParam("mode", "Current Dmg Mode:", SCRIPT_PARAM_LIST, 1, {"Physical ", "Magical"})
		Menu.TargetSelector:addParam("ts", "Use Standart Target Selector", SCRIPT_PARAM_ONOFF, true)
		
		Menu:addParam("blank", "", SCRIPT_PARAM_INFO, "")
		Menu:addParam("SkinHack","Use Skin Hack", SCRIPT_PARAM_ONOFF, false)
		Menu:addParam("skin", "Skin Hack by Shalzuth:", SCRIPT_PARAM_LIST, 5, { "Nottingham", "Striker", "Frosted", "Explorer", "Pulsefire", "TPA", "Debonair", "No Skin" })
		Menu:addParam("blank", "", SCRIPT_PARAM_INFO, "")
		Menu:addParam("about1", ""..scriptname.." v. "..version.."", SCRIPT_PARAM_INFO, "")
		Menu:addParam("about2", "by "..autor.."", SCRIPT_PARAM_INFO, "")
		Menu:addParam("about3", "P.S.: evolved into Big Fat Corki xD", SCRIPT_PARAM_INFO, "")
		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, TSRange, ts_dmg)
		ts.name = "Target "
		Menu.TargetSelector:addTS(ts)
	end 
	
	function draws_aa_menu()
	Menu.Draws:addSubMenu("[AA Settings]", "AASettings")
	Menu.Draws.AASettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	Menu.Draws.AASettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	Menu.Draws.AASettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
	draws_aa_menu_loaded = true
	end 
	function draws_q_menu()
	Menu.Draws:addSubMenu("[Q Settings]", "QSettings")
	Menu.Draws.QSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	Menu.Draws.QSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	Menu.Draws.QSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
	draws_q_menu_loaded = true
	end 
	function draws_w_menu()
	Menu.Draws:addSubMenu("[W Settings]", "WSettings")
	Menu.Draws.WSettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	Menu.Draws.WSettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	Menu.Draws.WSettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)
	draws_w_menu_loaded = true	
	end 
	function draws_e_menu()
	Menu.Draws:addSubMenu("[E Settings]", "ESettings")
	Menu.Draws.ESettings:addParam("colorAA", "Circle Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
	Menu.Draws.ESettings:addParam("width", "Circle Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
	Menu.Draws.ESettings:addParam("quality", "Circle Quality", SCRIPT_PARAM_SLICE, 90, 0, 360)	
	draws_e_menu_loaded = true	
	end 
function ks()
	if Menu.KSOptions.enabled then
	for i = 1, #GetEnemyHeroes() do
	local enemy = GetEnemyHeroes()[i]
		if not enemy.dead and enemy.visible and enemy ~= nil then
			if QReady and Menu.KSOptions.KSwithQ and ValidTarget(enemy, QRangeCut) and enemy.health < getDmg("Q",enemy,myHero) and myHero.mana >= myMana(Q) then
			possibleks1 = true
				if Menu.PredictionSettings.mode == 1 then
				QHitPRO = 2
				CastQProd(enemy)
				end	
				if Menu.PredictionSettings.mode == 2 then
				QHitVPRE = 2
				CastQVPred(enemy)
				end
			else 
			possibleks1 = false
			end 
			if QReady and WReady and Menu.KSOptions.KSwithQ and Menu.KSOptions.KSwithW and ValidTarget(enemy, WRangeCut) and enemy.health < getDmg("Q",enemy,myHero) + getDmg("W",enemy,myHero) and myHero.mana >= myMana(QW) then
			possibleks2 = true
				if Menu.PredictionSettings.mode == 1 then
				QHitPRO = 2
				WHitPRO = 2
				CastWProd(enemy)
				CastQProd(enemy)
				end	
				if Menu.PredictionSettings.mode == 2 then
				QHitVPRE = 2
				WHitVPRE = 2
				CastWVPred(enemy)
				CastQVPred(enemy)
				end
			else 
			possibleks2 = false
			end 
			if not QReady and WReady and Menu.KSOptions.KSwithW and ValidTarget(enemy, WRangeCut) and enemy.health < getDmg("W",enemy,myHero) and myHero.mana >= myMana(W) then
			possibleks3 = true
				if Menu.PredictionSettings.mode == 1 then
				WHitPRO = 2
				CastWProd(enemy)
				end	
				if Menu.PredictionSettings.mode == 2 then
				WHitVPRE = 2
				CastWVPred(enemy)
				end
			else 
			possibleks3 = false
			end 
			if Menu.KSOptions.KSwithAA and ValidTarget(enemy, AARange) and enemy.health < getDmg("AD",enemy,myHero) then
			possibleks2 = true
			myHero:Attack(enemy)
			else 
			possibleks2 = false			
			end	
			

			if RReady and myHero.mana >= myMana(R) and Menu.KSOptions.KSwithR and enemy.health < getDmg("R",enemy,myHero) - 30 and GetDistance(enemy) >= Menu.KSOptions.min and GetDistance(enemy) <= Menu.KSOptions.max then
			possibleks4 = true
						if Menu.PredictionSettings.mode == 1 then
						CastRProd(enemy)
						end	
						if Menu.PredictionSettings.mode == 2 then
						CastRVPred(enemy)
						end
			
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

end 

function carry_me()
if Target then
if not possibleks1 == true and not possibleks2 == true and not possibleks3 == true and not possibleks4 == true then
		if Menu.KeyBindings.Combo then 
			if Menu.Combo.UseQ and QReady and GetDistance(Target) <= QRangeCut then
				if Menu.PredictionSettings.mode == 1 then
				QHitPRO = Menu.PredictionSettings.ProdictionSettings.QHitCOM
				CastQProd(Target)
				end
				if Menu.PredictionSettings.mode == 2 then
				QHitVPRE = Menu.PredictionSettings.VPredictionSettings.QHitCOM
				CastQVPred(Target)
				end 
			end 
			if Menu.Combo.UseW and WReady and GetDistance(Target) <= WRangeCut then
				if Menu.PredictionSettings.mode == 1 then
				WHitPRO = Menu.PredictionSettings.ProdictionSettings.WHitCOM
				CastWProd(Target)
				end
				if Menu.PredictionSettings.mode == 2 then
				WHitVPRE = Menu.PredictionSettings.VPredictionSettings.WHitCOM
				CastWVPred(Target)
				end 
			end 
		end
		if Menu.KeyBindings.Harass1 or Menu.KeyBindings.Harass2 then
			if not Manaislowerthen(Menu.Harass.ManaSliderHarass) then
				if Menu.Harass.UseWhiteList then
					for i = 1, #GetEnemyHeroes() do
					local enemy = GetEnemyHeroes()[i]
						if Menu.Harass[enemy.hash] then
							if GetDistance(enemy) <= whitelistrange and not enemy.dead and enemy.visible then
								if Menu.Harass.HarassUseQ and QReady and GetDistance(enemy) <= QRangeCut then
									if Menu.PredictionSettings.mode == 1 then
									QHitPRO = Menu.PredictionSettings.ProdictionSettings.QHitHAR
									CastQProd(enemy)
									end
									if Menu.PredictionSettings.mode == 2 then
									QHitVPRE = Menu.PredictionSettings.VPredictionSettings.QHitHAR
									CastQVPred(enemy)
									end 
								end 
								if Menu.Harass.HarassUseW and WReady and GetDistance(enemy) <= WRangeCut then
									if Menu.PredictionSettings.mode == 1 then
									WHitPRO = Menu.PredictionSettings.ProdictionSettings.WHitHAR
									CastWProd(enemy)
									end
									if Menu.PredictionSettings.mode == 2 then
									WHitVPRE = Menu.PredictionSettings.VPredictionSettings.WHitHAR
									CastWVPred(enemy)
									end 
								end 
							end
							if GetDistance(enemy) > whitelistrange or enemy.dead or not enemy.visible then
								if Menu.Harass.HarassUseQ and QReady and GetDistance(Target) <= QRangeCut then
									if Menu.PredictionSettings.mode == 1 then
									QHitPRO = Menu.PredictionSettings.ProdictionSettings.QHitHAR
									CastQProd(Target)
									end
									if Menu.PredictionSettings.mode == 2 then
									QHitVPRE = Menu.PredictionSettings.VPredictionSettings.QHitHAR
									CastQVPred(Target)
									end 
								end 
								if Menu.Harass.HarassUseW and WReady and GetDistance(Target) <= WRangeCut then
									if Menu.PredictionSettings.mode == 1 then
									WHitPRO = Menu.PredictionSettings.ProdictionSettings.WHitHAR
									CastWProd(Target)
									end
									if Menu.PredictionSettings.mode == 2 then
									WHitVPRE = Menu.PredictionSettings.VPredictionSettings.WHitHAR
									CastWVPred(Target)
									end 
								end 
							end
						end 
					end 
				end 
				if not Menu.Harass.UseWhiteList then
								if Menu.Harass.HarassUseQ and QReady and GetDistance(Target) <= QRangeCut then
									if Menu.PredictionSettings.mode == 1 then
									QHitPRO = Menu.PredictionSettings.ProdictionSettings.QHitHAR
									CastQProd(Target)
									end
									if Menu.PredictionSettings.mode == 2 then
									QHitVPRE = Menu.PredictionSettings.VPredictionSettings.QHitHAR
									CastQVPred(Target)
									end 
								end 
								if Menu.Harass.HarassUseW and WReady and GetDistance(Target) <= WRangeCut then
									if Menu.PredictionSettings.mode == 1 then
									WHitPRO = Menu.PredictionSettings.ProdictionSettings.WHitHAR
									CastWProd(Target)
									end
									if Menu.PredictionSettings.mode == 2 then
									WHitVPRE = Menu.PredictionSettings.VPredictionSettings.WHitHAR
									CastWVPred(Target)
									end 
								end
				end 
				
			end 
		end 
end 
		
	end
end 

function CastQProd(unit)
	local qpos, qinfo = Prodiction.GetPrediction(unit, QRange, QSpeed, QDelay, QWidth, myPlayer)
	local coll = Collision(QRange, QSpeed, QDelay, QWidthCol)			
		if qpos and qinfo.hitchance >= QHitPRO and not coll:GetMinionCollision(qpos, myHero) then
			if Menu.PredictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end
end 
function CastQVPred(unit)
	local qpos, qinfo = VP:GetLineCastPosition(unit, QDelay, QWidth, QRange, QSpeed, myHero, true)		
		if qpos and qinfo >= QHitVPRE then
			if Menu.PredictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _Q, toX = qpos.x, toY = qpos.z, fromX = qpos.x, fromY = qpos.z}):send(true)
			else 
			CastSpell(_Q, qpos.x, qpos.z)
			end
		end
end 
function CastWProd(unit)
	local wpos, winfo = Prodiction.GetPrediction(unit, WRange, WSpeed, WDelay, WWidth, myPlayer)		
		if wpos and winfo.hitchance >= WHitPRO then
			if Menu.PredictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end 
end 
function CastWVPred(unit)
	local wpos, winfo = VP:GetLineCastPosition(unit, WDelay, WWidth, WRange, WSpeed, myHero, false)		
		if wpos and winfo >= WHitVPRE then
			if Menu.PredictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _W, toX = wpos.x, toY = wpos.z, fromX = wpos.x, fromY = wpos.z}):send(true)
			else 
			CastSpell(_W, wpos.x, wpos.z)
			end
		end
end 

function CastRProd(unit)
	local rpos, rinfo = Prodiction.GetPrediction(unit, RRange, RSpeed, RDelay, RWidth, myPlayer)	
		if rpos and rinfo.hitchance >= 3 then
			if Menu.PredictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
		end 
end
function CastRVPred(unit)
	local rpos, rinfo = VP:GetLineCastPosition(unit, RDelay, RWidth, RRange, RSpeed, myHero, false)		
		if rpos and rinfo >= 2 then
			if Menu.PredictionSettings.UsePacketsCast then
			Packet('S_CAST', {spellId = _R, toX = rpos.x, toY = rpos.z, fromX = rpos.x, fromY = rpos.z}):send(true)
			else 
			CastSpell(_R, rpos.x, rpos.z)
			end
		end
end 
--
function target_selector()
	if mma_menu_loaded == false and sac_menu_loaded == false then
		if is_MMA == false and is_SAC == false then
			if _G.MMA_Loaded then
				PrintChat("<font color='#c9d7ff'>"..scriptname..": </font><font color='#64f879'> MMA Detected! </font><font color='#c9d7ff'> MMA Support loaded! </font>")
				is_MMA = true
			end	
			if _G.AutoCarry then
				PrintChat("<font color='#c9d7ff'>"..scriptname..": </font><font color='#64f879'> SAC Detected! </font><font color='#c9d7ff'> SAC Support loaded! </font>")
				is_SAC = true
			end	
		end 
		if mma_menu_loaded == false and is_MMA == true then
		Menu.TargetSelector:addParam("mma", "Use MMA Target Selector", SCRIPT_PARAM_ONOFF, false)
		mma_menu_loaded = true
		end 
		if sac_menu_loaded == false and is_SAC == true then
		Menu.TargetSelector:addParam("sac", "Use SAC Target Selector", SCRIPT_PARAM_ONOFF, false)
		sac_menu_loaded = true
		end 
	end 
end 
function getTarget()
	if is_MMA and is_SAC then		
		if Menu.TargetSelector.mma then
			Menu.TargetSelector.sac = false
			Menu.TargetSelector.ts = false
		elseif Menu.TargetSelector.sac then
			Menu.TargetSelector.mma = false
			Menu.TargetSelector.ts = false
		elseif	Menu.TargetSelector.ts then
			Menu.TargetSelector.mma = false
			Menu.TargetSelector.sac = false
		end
	end	
	if not is_MMA and is_SAC then
		if Menu.TargetSelector.sac then
			Menu.TargetSelector.ts = false
		else
			Menu.TargetSelector.ts = true
		end	
	end
	if is_MMA and not is_SAC then
		if Menu.TargetSelector.mma then
			Menu.TargetSelector.ts = false
		else
			Menu.TargetSelector.ts = true
		end	
	end
	if not is_MMA and not is_SAC then
		Menu.TargetSelector.ts = true	
	end		
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then
		return _G.MMA_Target 
	end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then
		return _G.AutoCarry.Attack_Crosshair.target		
	end
    return ts.target	
end
function tartgets()
		if Menu.TargetSelector.mode == 1 then 
		ts_dmg = DAMAGE_PHYSICAL
		end 
		if Menu.TargetSelector.mode == 2 then 
		ts_dmg = DAMAGE_MAGIC
		end 
end

--
	function Welcome()
		if loading_text == false and os.clock() >= loading_text_start_delay+1 then
		PrintFloatText(myHero, 11, ""..scriptname..": v. "..version.." loaded!")
		loading_text = true
		end 
	end 
--
function OnSendPacket(packet)
    if (Menu.KeyBindings.WE2Mouse and myHero:CanUseSpell(_W) == READY and myHero:GetSpellData(_E).mana + myHero:GetSpellData(_W).mana <= myHero.mana) then
    local p = Packet(packet)
		if (p:get('name') == 'S_CAST' and p:get('sourceNetworkId') == myHero.networkID and p:get('spellId') == _E) then
		
		
			if Menu.PredictionSettings.UsePacketsCast then
			Packet("S_CAST", {spellId = _W, toX = p:get('toX'), toY = p:get('toY')}):send()
			else 
			CastSpell(_W, p:get('toX'), p:get('toY'))
			end
		
		end
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
	if Menu.skin ~= lastSkin and VIP_USER then
		lastSkin = Menu.skin
		GenModelPacket(""..myHero.charName.."", Menu.skin)
	end
	end
	function draw_AA()
		if not myHero.dead then
		DrawCircleAA(myHero.x, myHero.y, myHero.z, AARange, ARGB(Menu.Draws.AASettings.colorAA[1],Menu.Draws.AASettings.colorAA[2],Menu.Draws.AASettings.colorAA[3],Menu.Draws.AASettings.colorAA[4]))
		end
	end 
	function draw_Q()
		if not myHero.dead and QReady then
		DrawCircleQ(myHero.x, myHero.y, myHero.z, QRange, ARGB(Menu.Draws.QSettings.colorAA[1],Menu.Draws.QSettings.colorAA[2],Menu.Draws.QSettings.colorAA[3],Menu.Draws.QSettings.colorAA[4]))
		end
	end  
	function draw_W()
		if not myHero.dead and WReady then
		DrawCircleW(myHero.x, myHero.y, myHero.z, WRange, ARGB(Menu.Draws.WSettings.colorAA[1],Menu.Draws.WSettings.colorAA[2],Menu.Draws.WSettings.colorAA[3],Menu.Draws.WSettings.colorAA[4]))
		end
	end  
	function draw_E()
		if not myHero.dead and EReady then
		DrawCircleE(myHero.x, myHero.y, myHero.z, ERange, ARGB(Menu.Draws.ESettings.colorAA[1],Menu.Draws.ESettings.colorAA[2],Menu.Draws.ESettings.colorAA[3],Menu.Draws.ESettings.colorAA[4]))
		end	
	end  
	function draw_AA_b()
		if not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, AARange, 0xb9c3ed)
		end
	end 
	function draw_Q_b()
		if not myHero.dead and QReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0xb9c3ed)
		end
	end  
	function draw_W_b()
		if not myHero.dead and WReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0xb9c3ed)
		end
	end  
	function draw_E_b()
		if not myHero.dead and EReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0xb9c3ed)
		end	
	end  
	function draw_R_b()
		if not myHero.dead and RReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xb9c3ed)
		end	
	end 
	
function OnDraw()
	if Menu.Draws.UselowfpsDraws then
		if Menu.Draws.WE2Mouse and not myHero.dead and EReady and WReady then
		DrawCircleWE(myHero.x, myHero.y, myHero.z, ERange, ARGB(Menu.Draws.AASettings.colorAA[1],Menu.Draws.AASettings.colorAA[2],Menu.Draws.AASettings.colorAA[3],Menu.Draws.AASettings.colorAA[4]))
		end	
	end 
	if not Menu.Draws.UselowfpsDraws then
		if Menu.Draws.WE2Mouse and not myHero.dead and EReady and WReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0xb9c3ed)
		end	
	end 
end 
--WE Range Circle QUality
function DrawCircleNextLvlWE(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(Menu.Draws.WESettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end


--WE Range Circle Width
function DrawCircleWE(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvlWE(x, y, z, radius, Menu.Draws.WESettings.width, color, 75)	
	end
end 
function DrawCircleNextLvlAA(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(Menu.Draws.AASettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlAA(x, y, z, radius, Menu.Draws.AASettings.width, color, 75)	
	end
end
function DrawCircleNextLvlQ(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(Menu.Draws.QSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlQ(x, y, z, radius, Menu.Draws.QSettings.width, color, 75)	
	end
end
function DrawCircleNextLvlW(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(Menu.Draws.WSettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlW(x, y, z, radius, Menu.Draws.WSettings.width, color, 75)	
	end
end
function DrawCircleNextLvlE(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(Menu.Draws.ESettings.quality/math.deg((math.asin((chordlength/(2*radius)))))))
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
		DrawCircleNextLvlE(x, y, z, radius, Menu.Draws.ESettings.width, color, 75)	
	end
end 

function Manaislowerthen(percent)
    if myHero.mana < (myHero.maxMana * ( percent / 100)) then
        return true
    else
        return false
    end
end
function harass_tables()
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
function myMana(spell)
	if spell == Q then
		return 25 + (3 * myHero:GetSpellData(_Q).level)
	elseif spell == W then
		return 40 + (10 * myHero:GetSpellData(_W).level)
	elseif spell == QW then
		return 25 + (3 * myHero:GetSpellData(_Q).level) + 40 + (10 * myHero:GetSpellData(_W).level)
	elseif spell == R then
		return 100
	end
end	
