AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "gmr2hud.lua" )
AddCSLuaFile( "custom_menu.lua" )


include( "shared.lua" )

local open = false -- checks if menu is open or closed in GM:ShowSpare2

function GM:PlayerInitialSpawn(ply) -- players initial spawn, sets level to 1, exp to 0 and money to 15000
if (ply:GetPData("playerLvl") == nil) then
	ply:SetNWInt("playerLvl", 1)
	else
	ply:SetNWInt("playerLvl", ply:GetPData("playerLvl"))
	end
	
	if (ply:GetPData("playerExp") == nil) then
	ply:SetNWInt("playerExp", 0)
	else
	ply:SetNWInt("playerExp", ply:GetPData("playerExp"))
	end
	
	if (ply:GetPData("playerMoney") == nil) then
	ply:SetNWInt("playerMoney", 15000)
	else
	ply:SetNWInt("playerMoney", ply:GetPData("playerMoney"))
	end
	
end

function GM:OnNPCKilled(npc, attacker, inflictor)
--adds money
attacker:SetNWInt("playerMoney", attacker:GetNWInt("playerMoney") + 100)

attacker:SetNWInt("playerExp", attacker:GetNWInt("playerExp") + 101)
checkForLevel(attacker)
end

function GM:PlayerDeath(victim, inflictor, attacker)
--adds money
attacker:SetNWInt("playerMoney", attacker:GetNWInt("playerMoney") + 100)

attacker:SetNWInt("playerExp", attacker:GetNWInt("playerExp") + 101)
checkForLevel(attacker)
end

function checkForLevel(ply)
	local expToLevel = (ply:GetNWInt("playerLvl") * 100) * 2
	local curExp = ply:GetNWInt("playerExp")
	local curLvl = ply:GetNWInt("playerLvl")
	
	if (curExp >= expToLevel) then
		curExp = curExp - expToLevel
		
		ply:SetNWInt("playerExp", curExp)
		ply:SetNWInt("playerLvl", curLvl + 1)
	end
end


util.AddNetworkString("Fmenu")
function GM:ShowSpare2(ply) -- broadcasts that the f4 menu is being called for, receives in custom_menu.lua
	if (open == false) then
	open = true
	else
	open = false
	end

	net.Start("FMenu")
		net.WriteBit(open)
	net.Broadcast()
end

function GM:PlayerDisconnected(ply)
	ply:SetPData("playerLvl", ply:GetNWInt("playerLvl"))
	ply:SetPData("playerExp", ply:GetNWInt("playerExp"))
	ply:SetPData("playerMoney", ply:GetNWInt("playerMoney"))
end

function GM:ShutDown()
	for k, v in pairs(player.GetAll()) do
	v:SetPData("playerLvl", v:GetNWInt("playerLvl"))
	v:SetPData("playerExp", v:GetNWInt("playerExp"))
	v:SetPData("playerMoney", v:GetNWInt("playerMoney"))
	end
end

function GM:ShowSpare1(ply) -- spawns jeep on pandafaggot at ramp
ply:Say("Yurtemburg")
local car1 = ents.Create("prop_vehicle_jeep_old")
car1:SetModel("models/bf2bb.mdl")
car1.VehicleTable = list.Get( "Vehicles" )[ "BF2 Jeep"]
car1:SetKeyValue("vehiclescript","scripts/vehicles/jeep_test.txt")  
car1:SetPos(Vector(212.367081,-4387.652832,736.044983))
car1:SetAngles(Angle(0,90,-0))
car1:Spawn()






end

function GM:PlayerLoadout( ply )

		ply:GiveAmmo(90,"buckshot", true) --Gives the player ammo type 'buckshot'
		ply:Give("weapon_shotgun") --Gives the player weapon weapon_shotgun
		ply:GiveAmmo(90,"RPG_Round", true)
		ply:Give("weapon_rpg")
		return true
		
 
end














