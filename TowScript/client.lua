-- Created by Asser90, modified by Deziel0495 --

local currentlyTowedVehicle = nil

RegisterNetEvent('tow')
AddEventHandler('tow', function()
	
	local playerped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerped, true)
	
	local towmodel = GetHashKey('flatbed')
	local isVehicleTow = IsVehicleModel(vehicle, towmodel)
			
	if isVehicleTow then
	
		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)
		
		
		if currentlyTowedVehicle == nil then
			if targetVehicle ~= 0 then
				if not IsPedInAnyVehicle(playerped, true) then
					if vehicle ~= targetVehicle then
						AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, 'bodyshell'), 0, -2.0, 1.0, 0, 0, 0, 1, 1, 0, 1, 0, 1)
						currentlyTowedVehicle = targetVehicle
						ShowNotification("Vehicle has been successfully ~g~ATTACHED ~s~to the flatbed.")
					else
						ShowNotification("~o~You cannot tow your own truck!")
					end
				end
			end
		else
		DetachEntity(currentlyTowedVehicle, false, false)
		local vehiclesCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -10.0, 0.0)
			SetEntityCoords(currentlyTowedVehicle, vehiclesCoords["x"], vehiclesCoords["y"], vehiclesCoords["z"], 1, 0, 0, 1)
			SetVehicleOnGroundProperly(currentlyTowedVehicle)
			currentlyTowedVehicle = nil
			ShowNotification("Vehicle has been succesfully ~r~DETACHED ~s~from the flatbed.")
		end
	end
end)

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end


function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end
