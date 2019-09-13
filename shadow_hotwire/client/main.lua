-------------MADE BY shadow


local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  }

key= false
local Radio = false 
local PlayerData		= {}
ESX = nil
hotwire = false

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

function disableEngine(hotwires)
	local thief = GetPlayerPed(-1)
	local nicecar = GetVehiclePedIsIn(thief,false)
	Citizen.CreateThread(function() 
		print(hotwire)
		print(hotwires)
		if hotwires == 5 then
			hotwire = true
			TriggerEvent('shadow:disable')
		elseif hotwires == 4 then
			hotwire = false
			EnableEngine()
		end
	end)
end


RegisterNetEvent('shadow:disable')
AddEventHandler('shadow:disable', function()
	local thief = GetPlayerPed(-1)
    local nicecar = GetVehiclePedIsIn(thief,false)
	Citizen.CreateThread(function() 	
		while hotwire == true do
			Citizen.Wait(0)
            if (IsVehicleEngineStarting(nicecar) or GetIsVehicleEngineRunning(nicecar)) then
            	SetVehicleNeedsToBeHotwired(nicecar, true)
				SetVehicleEngineOn(nicecar, false, false, true)
    		end
		end
	end)
end)



RegisterNetEvent('shadow:EnteringVeh')
AddEventHandler('shadow:EnteringVeh', function()
	local thief = GetPlayerPed(-1)
	local nicecar = GetVehiclePedIsIn(thief,false)
    Citizen.CreateThread(function() 
        while IsVehicleNeedsToBeHotwired(nicecar) do
			Citizen.Wait(0)
			if (IsVehicleEngineStarting(nicecar) or GetIsVehicleEngineRunning(nicecar)) then
				SetVehicleNeedsToBeHotwired(nicecar, true)

        	end
		end
	end)
end)

function EnableEngine()
	Citizen.CreateThread(function()
		local thief = GetPlayerPed(-1)
		local nicecar = GetVehiclePedIsIn(thief,false)
		ClearPedTasksImmediately(theif)
		SetVehicleRadioEnabled(nicecar, true)
		SetVehicleNeedsToBeHotwired(nicecar, false)
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
	local nicecar = GetVehiclePedIsIn(Bitchthief,false)
	if GetVehiclePedIsIn(BitchTheif, false) == 0 and DoesEntityExist(ohlookwhatwegot) and IsEntityAVehicle(ohlookwhatwegot) then
		TriggerServerEvent('shadow:removeKit')
		SetVehicleDoorsShut(ohlookwhatwegot, true)
		SetVehicleNeedsToBeHotwired(ohlookwhatwegot, true)
		SetVehicleEngineOn(ohlookwhatwegot, false, false, false)
		
        RequestAnimDict("mini@repair")
        while not HasAnimDictLoaded("mini@repair") do
        	Citizen.Wait(100)
		end
		TriggerEvent("mythic_progbar:client:progress", {
			name = "Lockpicking",
			duration = 15000,
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
				SetVehicleDoorsLocked(ohlookwhatwegot, false)
				TaskEnterVehicle(BitchTheif, ohlookwhatwegot, 10.0, -1, 1.0, 1, 0)	
				Citizen.Wait(3500)
				disableEngine(5)
				TriggerEvent('shadow:lockpick2')
			end
		end)
    return
	else
		exports.pNotify:SendNotification({text = "You must be near a vehicle to be able to lockpick it", type = "success", queue = "left", timeout = 4000, layout = "centerRight"})
    end
end)

RegisterNetEvent("shadow:lockpick2")
AddEventHandler("shadow:lockpick2", function()
    RequestAnimDict("veh@std@ds@base")
    while not HasAnimDictLoaded("veh@std@ds@base") do
        Citizen.Wait(100)
	end
	TriggerEvent("mythic_progbar:client:progress", {
		name = "Lockpicking [stage 2]",
		duration = 20000,
		label = "Stripping Wires",
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
		else  disableEngine(5)
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
		duration = 25000,
		label = "Splicing Wires",
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
			exports.pNotify:SendNotification({text = "Vehicle Hotwired", type = "success", queue = "left", timeout = 4000, layout = "centerRight"})

			Citizen.Wait(2000)
			disableEngine(4)
			if not Radio then
				SetVehicleRadioEnabled(whatthefuck, false)
			else disableEngine(5)
			end
		end
	end)
end)

