function HUD()
	local client = LocalPlayer()
	
	if !client:Alive() then
	return
	end
	
	draw.RoundedBox(0,0,ScrH() - 100, 250, 100, Color(50, 50, 142, 55))
	
	draw.SimpleText("Health: "..client:Health(), "DermaDefaultBold", 10, ScrH() - 90, Color(255, 255, 255, 255), 0, 0)
	draw.RoundedBox(0,10, ScrH() - 75, 100 * 2.25, 15, Color(255, 0, 0, 30))
	draw.RoundedBox(0, 10, ScrH() - 75, math.Clamp(client:Health(), 0, 100) * 2.25, 15, Color(255, 0, 0, 255))
	draw.RoundedBox(0, 10, ScrH() - 75, math.Clamp(client:Health(), 0, 100) * 2.25, 5, Color(255, 30, 30, 255))
	draw.SimpleText("$ " .. client:GetNWInt("playerMoney"), "DermaDefaultBold", 10, ScrH() - 45, Color(255, 255, 255, 255), 0)
	
	
	
	local expToLevel = (client:GetNWInt("playerLvl") * 100) * 2
	
	draw.RoundedBox(0,0,ScrH() - 145, 250, 40, Color(50, 50, 142, 55))
	draw.SimpleText("Level " .. client:GetNWInt("playerLvl"), "DermaDefaultBold", 10, ScrH() - 140, Color(255, 255, 255, 255), 0)
	draw.SimpleText("EXP " .. client:GetNWInt("playerExp") .. "/" .. expToLevel, "DermaDefaultBold", 10, ScrH() - 125, Color(255, 255, 255, 255), 0)
	
end
hook.Add("HUDPaint", "GMR2Hud", HUD)

function HideHud(name)
	for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do
		if name == v then 
		return false
		end
	end
end
hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud)