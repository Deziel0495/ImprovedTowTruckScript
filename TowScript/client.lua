-- Created by Asser90 - modified by Deziel0495 and IllusiveTea - further modified by Vespura --

-- These vehicles will be registered as "allowed/valid" tow trucks.
local allowedTowModels = { 
    'flatbed',
    'flatbed2',
}
local allowTowingBoats = false -- Set to true if you want to be able to tow boats.
local allowTowingPlanes = false -- Set to true if you want to be able to tow planes.
local allowTowingHelicopters = false -- Set to true if you want to be able to tow helicopters.
local allowTowingTrains = false -- Set to true if you want to be able to tow trains.
local allowTowingTrailers = false -- Disables trailers. NOTE: THIS ALSO DISABLES: AIRTUG, TOWTRUCK, SADLER, ANY OTHER VEHICLE THAT IS IN THE UTILITY CLASS.

local currentlyTowedVehicle = nil

RegisterCommand("tow", function()
	TriggerEvent("tow")
end,false)

function isVehicleATowTruck(vehicle)
    local isValid = false
    for k,model in ipairs(allowedTowModels) do
        if IsVehicleModel(vehicle, model) then
            isValid = true
            break
        end
    end
    return isValid
end

function isTargetVehicleATrailer(modelHash)
    if GetVehicleClassFromName(modelHash) == 11 then
        return true
    else
        return false
    end
end

RegisterNetEvent('tow')
AddEventHandler('tow', function()
	
	local playerped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerped, true)
	
	local isVehicleTow = isVehicleATowTruck(vehicle)

	if isVehicleTow then

		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)
        

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)
				isVehicleTow = isVehicleATowTruck(vehicle)
				local roll = GetEntityRoll(GetVehiclePedIsIn(PlayerPedId(), true))
				if IsEntityUpsidedown(GetVehiclePedIsIn(PlayerPedId(), true)) and isVehicleTow or roll > 70.0 or roll < -70.0 then
					DetachEntity(currentlyTowedVehicle, false, false)
					currentlyTowedVehicle = nil
					ShowNotification("~o~~h~Tow Service:~n~~s~Looks like the cables holding on the vehicle have broke!")
				end
			end
		end)

		if currentlyTowedVehicle == nil then
			if targetVehicle ~= 0 then
                local targetModelHash = GetEntityModel(targetVehicle)
                -- Check to make sure the target vehicle is allowed to be towed (see settings at lines 8-12)
                if not ((not allowTowingBoats and IsThisModelABoat(targetModelHash)) or (not allowTowingHelicopters and IsThisModelAHeli(targetModelHash)) or (not allowTowingPlanes and IsThisModelAPlane(targetModelHash)) or (not allowTowingTrains and IsThisModelATrain(targetModelHash)) or (not allowTowingTrailers and isTargetVehicleATrailer(targetModelHash))) then 
                    if not IsPedInAnyVehicle(playerped, true) then
                        if vehicle ~= targetVehicle and IsVehicleStopped(vehicle) then
                            AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, 'bodyshell'), 0, -1.5, 0.5, 0, 0, 0, 1, 1, 0, 1, 0, 1)
                            currentlyTowedVehicle = targetVehicle
                            ShowNotification("~o~~h~Tow Service:~n~~s~Vehicle has been loaded onto the flatbed.")
                        else
                            ShowNotification("~o~~h~Tow Service:~n~~s~There is currently no vehicle on the flatbed.")
                        end
                    else
                        ShowNotification("~o~~h~Tow Service:~n~~s~You need to be outside of your vehicle to load or unload vehicles.")
                    end
                else
                    ShowNotification("~o~~h~Tow Service:~n~~s~Your towtruck is not equipped to tow this vehicle.")
                end
            else
                ShowNotification("~o~~h~Tow Service:~n~~s~No towable vehicle detected.")
			end
		elseif IsVehicleStopped(vehicle) then
            DetachEntity(currentlyTowedVehicle, false, false)
            local vehiclesCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -8.0, 0.0)
			SetEntityCoords(currentlyTowedVehicle, vehiclesCoords["x"], vehiclesCoords["y"], vehiclesCoords["z"], 1, 0, 0, 1)
			SetVehicleOnGroundProperly(currentlyTowedVehicle)
			currentlyTowedVehicle = nil
			ShowNotification("~o~~h~Tow Service:~n~~s~Vehicle has been unloaded from the flatbed.")
		end
	else
        ShowNotification("~o~~h~Tow Service:~n~~s~Your vehicle is not registered as an official ~o~Tow Service ~s~tow truck.")
    end
end)

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
	DrawNotification(false, false)
end
