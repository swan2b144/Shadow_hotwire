ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('hotwirekit', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('shadow:onUse', _source)
end)

RegisterNetEvent('shadow:removeKit')
AddEventHandler('shadow:removeKit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('hotwirekit', 1)
    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'You used x1 lockpick.' })
end)

