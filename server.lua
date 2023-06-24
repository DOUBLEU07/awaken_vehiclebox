LocalVault = {}
SharedVault = {}
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('nightclub_vehiclebox:getOwnedCarsDeposit', function(source, cb, deposit_key)
	local ownedCars = {}
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND deposit_car = @deposit_car ', {
		['@owner']  = GetPlayerIdentifiers(source)[1],
		['@Type']   = 'car',
        ['@deposit_car'] = deposit_key,
		-- ['@stored'] = true
	}, function(data)
		for _,v in pairs(data) do
			table.insert(ownedCars, v)
		end
		cb(ownedCars)
	end)
end)


RegisterServerEvent('nightclub_vehiclebox:setDepositVehicleState')
AddEventHandler('nightclub_vehiclebox:setDepositVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE owned_vehicles SET stored = @stored WHERE plate = @plate', {
		['@stored'] = state,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then end
	end)
end)

RegisterServerEvent('nightclub_vehiclebox:setDepositVehicleDepositCar')
AddEventHandler('nightclub_vehiclebox:setDepositVehicleDepositCar', function(plate, DepositKey)
	local xPlayer = ESX.GetPlayerFromId(source)
	print(DepositKey)
	MySQL.Async.execute('UPDATE owned_vehicles SET deposit_car = @deposit_car WHERE plate = @plate', {
		['@deposit_car'] = DepositKey,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then end
	end)
end)

RegisterServerEvent('nightclub_vehiclebox:modifyDepositDamage')
AddEventHandler('nightclub_vehiclebox:modifyDepositDamage', function(plate, damage)
	local plate = plate
	local health = json.encode(damage)
	MySQL.Async.execute("UPDATE `owned_vehicles` SET `health_vehicles` = @health WHERE `plate`=@plate", {
		['@plate'] = plate,
		['@health'] = health
	})
end)

ESX.RegisterServerCallback('nightclub_vehiclebox:UndepositstoreVehicle', function (source, cb, vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehplate = vehicleProps.plate
	local vehiclemodel = vehicleProps.model

	MySQL.Async.fetchAll("SELECT * FROM `owned_vehicles` where `plate`=@plate and `owner`=@identifier",{
		['@plate'] = vehplate, 
		['@identifier'] = xPlayer.identifier
	}, function(result)  
		if result[1] ~= nil then
			local veh = json.decode(result[1].vehicle)
			if veh.model == vehiclemodel then
				local vehprop = json.encode(vehicleProps)
				MySQL.Async.execute("UPDATE `owned_vehicles` SET `vehicle`= @vehprop WHERE plate= @plate",{
					['@vehprop'] = vehprop, 
					['@plate'] = vehplate
				})
				cb(true)
			end	
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('nightclub_vehiclebox:checkMoneyUndeposit', function(source, cb, money)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= money then
		cb(true)
	else
		cb(false)
	end
end)