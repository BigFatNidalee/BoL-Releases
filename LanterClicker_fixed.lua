function OnLoad()
	Lanternm = scriptConfig("Lantern Clicker", "Lantern")
	Lanternm:addParam("UseLantern", "Use Lantern", SCRIPT_PARAM_ONKEYDOWN, false, 32)
end

function Lantern(id)
	p = CLoLPacket(0x3A)
	p:EncodeF(myHero.networkID)
	p:EncodeF(id)
	p.dwArg1 = 1
	p.dwArg2 = 0
	SendPacket(p)
end

function OnCreateObj(obj)
	if obj and obj.name == "ThreshLantern" then
		lant = obj
	end
end

function ClickyClicky()
	if lant and lant.valid then
		Lantern(lant.networkID)
	end
end


function OnTick()
	if Lanternm.UseLantern then
		ClickyClicky()
	end
end
