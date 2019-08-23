-------------MADE BY SHADOW


local Radio = false 
local PlayerData		= {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

function disableEngine()
	Citizen.CreateThread(function()
		local thief = GetPlayerPed(-1)
		local nicecar = GetVehiclePedIsIn(thief)
		IsVehicleNeedsToBeHotwired(nicecar)
		SetVehicleNeedsToBeHotwired(nicecar, true)
		SetVehicleUndriveable(nicecar, true)
		SetVehicleEngineOn(nicecar, false, false)
		Citizen.Wait(0)
	end)
end

RegisterNetEvent('shadow:EnteringVeh')
AddEventHandler('shadow:EnteringVeh', function(veh)
	local veh = GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))
    Citizen.CreateThread(function() 
        while IsVehicleNeedsToBeHotwired(veh) do
            Citizen.Wait(0)
            SetVehicleNeedsToBeHotwired(veh, true)
        end
    end)
end)

function EnableEngine()
	Citizen.CreateThread(function()
		local thief = GetPlayerPed(-1)
		local nicecar = GetVehiclePedIsIn(thief)
		ToggleVehicleMod(nicecar, 22, true)
		SetVehicleAlarm(nicecar, true)
		SetVehicleAlarm(nicecar, true)
		SetVehicleEngineOn(nicecar, true, true, true)
		Citizen.Wait(0)
	end)
end

function VehicleInFront()
	local cleanped = PlayerPedId()
	local pos = GetEntityCoords(cleanped)
	local entityWorld = GetOffsetFromEntityInWorldCoords(cleanped, 0.0, 2.0, 0.0)
	local car = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 30, cleanped, 0)
	local _, _, _, _, result = GetRaycastResult(car)
	return result
end

RegisterNetEvent("shadow:onUse")
AddEventHandler("shadow:onUse", function()
	local BitchTheif = GetPlayerPed(-1)
	local ohlookwhatwegot = VehicleInFront()
	if GetVehiclePedIsIn(BitchTheif, false) == 0 and DoesEntityExist(ohlookwhatwegot) and IsEntityAVehicle(ohlookwhatwegot) then
		TriggerServerEvent('shadow:removeKit')
        SetVehicleDoorsShut(ohlookwhatwegot, true)
        RequestAnimDict("mini@repair")
        while not HasAnimDictLoaded("mini@repair") do
        	Citizen.Wait(100)
		end
		TriggerEvent("mythic_progbar:client:progress", {
			name = "Lockpicking [stage 1]",
			duration = 7000,
			label = "Lockpicking [stage 1]",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "mini@repair",
				anim = "fixing_a_player",
			}
		}, function(status)
			if not status then
				StopAnimTask(PlayerPedId(), 'mini@repair', 'fixing_a_player', 1.0)
				TriggerEvent('shadow:EnteringVeh')
				SetVehicleDoorsLocked(ohlookwhatwegot, false)
				SetVehicleEngineOn(ohlookwhatwegot, false, false)
				TaskEnterVehicle(BitchTheif, ohlookwhatwegot, 10.0, -1, 1.0, 1, 0)
				Citizen.Wait(3500)
				disableEngine()
				TriggerEvent('shadow:lockpick2')
			end
		end)
    return
    else
      exports['mythic_notify']:DoHudText('inform', 'You must be near a vehicle to be able to lockpick it')
    end
end)

RegisterNetEvent("shadow:lockpick2")
AddEventHandler("shadow:lockpick2", function()
	local BitchTheif = GetPlayerPed(-1)
    local mycarnow = GetVehiclePedIsIn(BitchTheif, false)
    RequestAnimDict("veh@std@ds@base")
    while not HasAnimDictLoaded("veh@std@ds@base") do
        Citizen.Wait(100)
	end
	TriggerEvent("mythic_progbar:client:progress", {
		name = "Lockpicking [stage 2]",
		duration = 10000,
		label = "Hotwiring [stage 2]",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "veh@std@ds@base",
			anim = "hotwire",
		}
	}, function(status)
		if not status then
			StopAnimTask(PlayerPedId(), 'veh@std@ds@base', 'hotwire', 1.0)
			Citizen.Wait(1000)
			TriggerEvent('shadow:lockpick3')
		end
	end)
end)

RegisterNetEvent("shadow:lockpick3")
AddEventHandler("shadow:lockpick3", function()
   	local BitchTheif = GetPlayerPed(-1)
    local whatthefuck = GetVehiclePedIsIn(BitchTheif, false)
    RequestAnimDict("veh@std@ds@base")
    while not HasAnimDictLoaded("veh@std@ds@base") do
        Citizen.Wait(100)
	end
	TriggerEvent("mythic_progbar:client:progress", {
		name = "Lockpicking [stage 3]",
		duration = 5000,
		label = "Fuses burnt out reparing fuses",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "veh@std@ds@base",
			anim = "hotwire",
		}
	}, function(status)
		if not status then
			SetVehicleDoorsLocked(whatthefuck, 1)
			exports['mythic_notify']:DoHudText('success', 'Vehicle Unlocked')
			Citizen.Wait(2000)
			EnableEngine()
			if not Radio then
				SetVehicleRadioEnabled(whatthefuck, false)
			end
		end
	end)
end)

RegisterNetEvent('shadow:clean')
AddEventHandler('shadow:clean', function()
    local playerPed = GetPlayerPed(-1)
    local vehicle = VehicleInFront()
    if GetVehiclePedIsIn(playerPed, false) == 0 and DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        RequestAnimDict("amb@world_human_maid_clean")
        while not HasAnimDictLoaded("amb@world_human_maid_clean") do
            Citizen.Wait(100)
		end
		TriggerEvent("mythic_progbar:client:progress", {
			name = "unique_action_name",
			duration = 10000,
			label = "Cleaning Car",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@world_human_maid_clean",
				anim = "base",
			}
		}, function(status)
			if not status then
				ClearPedTasksImmediately(ped)
				StopAnimTask(PlayerPedId(), 'amb@world_human_maid_clean', 'base', 1.0)
				SetVehicleDirtLevel(vehicle, 0)
				exports['mythic_notify']:DoHudText('success', 'Your vehicle has been cleaned!')
			end
		end)
	else
        exports['mythic_notify']:DoHudText('inform', 'You must be near a vehicle to be able to clean it')
    end
end)

local isIntrunk = false
RegisterCommand('getin', function(source, args, rawCommand)
	local whodis = GetEntityCoords(GetPlayerPed(-1), false)
  	local trunk = GetClosestVehicle(whodis.x, whodis.y, whodis.z, 5.0, 0, 71)
  	if DoesEntityExist(trunk) and GetVehicleDoorLockStatus(trunk) == 1 then
    	if not isIntrunk then
      		AttachEntityToEntity(GetPlayerPed(-1), trunk, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
      		RaiseConvertibleRoof(trunk, false)
      		if IsEntityAttached(GetPlayerPed(-1)) then
        		RequestAnimDict('timetable@floyd@cryingonbed@base')
        		while not HasAnimDictLoaded('timetable@floyd@cryingonbed@base') do
          			Citizen.Wait(1)
        		end
        		TaskPlayAnim(GetPlayerPed(-1), 'timetable@floyd@cryingonbed@base', 'base', 1.0, -1, -1, 1, 0, 0, 0, 0)
      		end
    	end
    	isIntrunk = true
  	end
end)

RegisterCommand('getout', function(source, args, rawCommand)
	local whodis = GetEntityCoords(GetPlayerPed(-1), false)
  	local trunk = GetClosestVehicle(whodis.x, whodis.y, whodis.z, 5.0, 0, 71)
  	if DoesEntityExist(trunk) and GetVehicleDoorLockStatus(trunk) == 1 then
    	if isIntrunk then
      		DetachEntity(GetPlayerPed(-1), 0, true)
      		SetEntityVisible(GetPlayerPed(-1), true)
      		ClearPedTasksImmediately(GetPlayerPed(-1))
    	end
    	isInTrunk = false
  	end
end)