local Category = "Half-Life 2"

local function HandleRollercoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER ) 
end

local V = { 	
				// Required information
				Name = "BF2 Buggy", 
				Class = "prop_vehicle_jeep_old",
				Category = Category,

				// Optional information
				Author = "MaKc,Erghize",
				Information = "Buggy from BF2",
				Model = "models/bf2bb.mdl",
				
				KeyValues = {
								vehiclescript	=	"addons/bf2_buggy/lua/scripts/vehicles/jeep_test.txt"
							}
			}

list.Set( "Vehicles", "BF2 Buggy", V )