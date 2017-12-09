-- Created by Asser90 - modified by Deziel0495 and IllusiveTea --

local currentlyTowedVehicle = nil

RegisterCommand("tow", function()
	TriggerEvent("tow")
end,false)

RegisterNetEvent('tow')
AddEventHandler('tow', function()
	
	local playerped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerped, true)
	
	local towmodel = GetHashKey('mule5')
	local isVehicleTow = IsVehicleModel(vehicle, towmodel)

	if isVehicleTow then

		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)
				local towmodel = GetHashKey('flatbed')
				local isVehicleTow = IsVehicleModel(vehicle, towmodel)
				roll = GetEntityRoll(GetVehiclePedIsIn(PlayerPedId(), true))
				if IsEntityUpsidedown(GetVehiclePedIsIn(PlayerPedId(), true)) and isVehicleTow or roll > 70.0 or roll < -70.0 then
					DetachEntity(currentlyTowedVehicle, false, false)
					currentlyTowedVehicle = nil
					ShowNotification("~o~~h~Tow Service:~n~~s~Looks like the cables holding on the vehicle have broke!")
				end
			end
		end)

		if currentlyTowedVehicle == nil then
			if targetVehicle ~= 0 then
				if not IsPedInAnyVehicle(playerped, true) then
					if vehicle ~= targetVehicle and IsVehicleStopped(vehicle) then
						AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, 'bodyshell'), 0, -1.5, 0.5, 0, 0, 0, 1, 1, 0, 1, 0, 1)
						currentlyTowedVehicle = targetVehicle
						ShowNotification("~o~~h~Tow Service:~n~~s~Vehicle has been loaded onto the flatbed.")
						else
						ShowNotification("~o~~h~Tow Service:~n~~s~There is currently no vehicle on the flatbed.")
					end
				end
			end
		elseif IsVehicleStopped(vehicle) then
		DetachEntity(currentlyTowedVehicle, false, false)
		local vehiclesCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -8.0, 0.0)
			SetEntityCoords(currentlyTowedVehicle, vehiclesCoords["x"], vehiclesCoords["y"], vehiclesCoords["z"], 1, 0, 0, 1)
			SetVehicleOnGroundProperly(currentlyTowedVehicle)
			currentlyTowedVehicle = nil
			ShowNotification("~o~~h~Tow Service:~n~~s~Vehicle has been unloaded from the flatbed.")
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
