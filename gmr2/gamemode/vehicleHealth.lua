
/*==================================================================================================== 
[[===SIMPLE VEHICLE HEALTH SCRIPT===

A simple script by Sven Brimstone (SonofBrim) based off of the similar 2010 script by SinTwins.
Gives cars a set amount of health, sets them on fire and blows them up when that health is depleted.
Comes with some customization.]]
====================================================================================================*/

-- Config Options

defaulthp = 500		-- Vehicle health
smokepoint = 250	-- Point at which vehicles begin to smoke

timemin = 5			-- Minimum time between the vehicle's health reaching 0 and detonation
timemax = 20		-- Maximum time between the vehicle's health reaching 0 and detonation

smokeeffect = "smoke_burning_engine_01"		-- Vehicle smoke effect
explodeeffect = "explosion_huge_f"				-- Explosion effect
	
// Give cars health when they spawn.
hook.Add("PlayerSpawnedVehicle", "VehicleHP", function( ply, ent ) 
	if not ent:IsValid() then return end
		
	ent:SetHealth( defaulthp )
	ent.Screwed = false // More or less lets later parts of the code know whether the car needs to be blow up or not.
	ent.Hurt = false
	
end)

// Make cars take damage and blow up if they are damaged too much.
hook.Add("EntityTakeDamage", "VehicleHPHook", function( ent, dmginfo ) 
	if not ent:IsVehicle() then return end
	
		local damage = dmginfo:GetDamage()
		
		// Compensate for weird vehicle damage system, make explosives do more damage.
		if dmginfo:IsBulletDamage() then ent:SetHealth(ent:Health() - (10000 * damage)) 
			elseif dmginfo:IsExplosionDamage() then ent:SetHealth(ent:Health() - (8 * damage))
			else ent:SetHealth(ent:Health() - damage) 
		end
		
	
		// This was used for testing purposes, spits out a bunch of damage info to the console.
		// print(ent:GetAttachments(), dmginfo:GetDamageType(), dmginfo:GetAmmoType(), damage, dmginfo:IsBulletDamage())
		 
		// Make the vehicle smoke if health gets low.
		if ent:IsValid() and ent:Health() <= smokepoint and ent.Hurt == false then
			local id = ent:LookupAttachment("vehicle_engine")
			ent.Hurt = true // Let it know that the car is hurt so it doesn't add the effect the next time it gets damaged.
			ParticleEffectAttach( smokeeffect, PATTACH_POINT_FOLLOW, ent, id )
		end 
			
		// Once health drops to 0 or below, light the car on fire, kick everyone out, and blow it up.
		if ent:IsValid() and ent:Health() <= 0 and ent.Screwed == false then
				
			ent.Screwed = true // Let it know that the car is going to blow up and the timer is started (so it doesn't keep on restarting)
			
			local randomtime = math.random(timemin,timemax)
			
			ent:Ignite( randomtime, 100 )
			
			// Boot the driver out
			if ent:GetDriver():IsValid() then ent:GetDriver():ExitVehicle(ent) end 
			
			// Blow it up after a set time.
			timer.Create("CarExplode", randomtime, 1, function() 
				if not ent:IsValid() then return end
				local explosion = ents.Create("env_explosion")
				ParticleEffect(explodeeffect,ent:GetPos(),Angle(0,0,0),nil) 
				explosion:SetPos(ent:GetPos())
				explosion:SetOwner(attacker)
				explosion:Spawn()
				explosion:SetKeyValue("iMagnitude", "250")
				explosion:Fire("Explode", 0, 0)
				ent:Remove()
			end)
		end 
end)

// If a car is going to blow up, don't let players in.
hook.Add("CanPlayerEnterVehicle", "ExplodedVehicles", function(ply, ent, role)
	if ent.Screwed then 
		return false
	end
end)