ESX = nil
local OBJ = {}
local cacheobj = nil
local vehiclecache = nil
local openedvehicle = nil
local CurrentActionMsg        = ''
local LastZone                = nil
local CurrentAction           = nil
local DepositKey              = nil
local HasAlreadyEnteredMarker = false
local PlayerData 			  = {}
local JobBlips 				  = {}
local CurrentActionData       = {}
local userProperties          = {}
local this_Garage             = {}
local privateBlips            = {}
local Keys 					  = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	refreshBlips()
	LoadNPC()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	refreshBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
	deleteBlips()
	refreshBlips()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(0, Keys['E']) then
                if CurrentAction == 'car_garage_point_deposit' then
                    StoreOwnedCarsMenu(DepositKey)
                elseif CurrentAction == 'car_garage_point_undeposit' then
                    ListOwnedCarsMenu(DepositKey)
                end
				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function LoadNPC()
	for k, v in pairs(Config.DepositCar) do
		Citizen.CreateThread(function()
			local npcHash = GetHashKey(Config.ModelNPC)
			RequestModel(npcHash)
			while not HasModelLoaded(npcHash) do
				Citizen.Wait(1)
			end
			local ped = CreatePed(4, npcHash, v.UnDepositPoint.x, v.UnDepositPoint.y, v.UnDepositPoint.z - 1, 0.0, false, true)
			RequestAnimDict("mini@strip_club@idles@bouncer@base")
            while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
                Citizen.Wait(1)
			end
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            TaskPlayAnim(ped, "mini@strip_club@idles@bouncer@base", "base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
		end)
	end
end


Citizen.CreateThread(function()
	local currentZone = 'garage'
	local zone = 'garage'
	while true do
		Citizen.Wait(1)
		local playerPed  = PlayerPedId()
		local coords     = GetEntityCoords(playerPed)
		local isInMarker = false
		
		if Config.DepositCarGarages == true then
			for k,v in pairs(Config.DepositCar) do
				if k == "Eco" then
					if (GetDistanceBetweenCoords(coords, v.DepositPoint.x, v.DepositPoint.y, v.DepositPoint.z, true) < 5) and IsPedInAnyVehicle(PlayerPedId(), true) then
						isInMarker  = true
						this_Garage = v
						currentZone = 'car_garage_point_deposit'
						DepositKey = v.key
					end

				elseif k == "Fishing" then
					if (GetDistanceBetweenCoords(coords, v.DepositPoint.x, v.DepositPoint.y, v.DepositPoint.z, true) < 15) and IsPedInAnyVehicle(PlayerPedId(), true) then
						isInMarker  = true
						this_Garage = v
						currentZone = 'car_garage_point_deposit'
						DepositKey = v.key
					end
				else
					if (GetDistanceBetweenCoords(coords, v.DepositPoint.x, v.DepositPoint.y, v.DepositPoint.z, true) < Config.DepositMarker.x) and IsPedInAnyVehicle(PlayerPedId(), true) then
						isInMarker  = true
						this_Garage = v
						currentZone = 'car_garage_point_deposit'
						DepositKey = v.key
					end
				end
				
				if v.UnDepositPoint then
					if k == "Fishing" then
						if(GetDistanceBetweenCoords(coords, v.UnDepositPoint.x, v.UnDepositPoint.y, v.UnDepositPoint.z, true) < 15) and IsPedInAnyVehicle(PlayerPedId(), true) == false then 
							isInMarker  = true
							this_Garage = v
							currentZone = 'car_garage_point_undeposit'
							DepositKey = v.key
						end
					else
						if(GetDistanceBetweenCoords(coords, v.UnDepositPoint.x, v.UnDepositPoint.y, v.UnDepositPoint.z, true) < Config.UnDepositMarker.x +0.8) and IsPedInAnyVehicle(PlayerPedId(), true) == false then 
							isInMarker  = true
							this_Garage = v
							currentZone = 'car_garage_point_undeposit'
							DepositKey = v.key
						end
					end
				end
			end
		end
		
		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			LastZone                = currentZone
			zone 					= currentZone
			if zone == 'car_garage_point_deposit' then
				CurrentAction     = 'car_garage_point_deposit'
				CurrentActionMsg  = 'Press ~INPUT_CONTEXT~ to Deposit Vehicle.'
				CurrentActionData = {}
			elseif zone == 'car_garage_point_undeposit' then
				CurrentAction     = 'car_garage_point_undeposit'
				CurrentActionMsg  = 'Press ~INPUT_CONTEXT~ to Un Deposit Vehicle.'
				CurrentActionData = {}
			end
		end
		
		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false		
			ESX.UI.Menu.CloseAll()
			CurrentAction = nil
		end
		
		if not isInMarker then
            Citizen.Wait(500)
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
		local canSleep  = true
		if Config.DepositCarGarages == true then
			for k,v in pairs(Config.DepositCar) do
				if k == "Eco" then
					if (GetDistanceBetweenCoords(coords, v.DepositPoint.x, v.DepositPoint.y, v.DepositPoint.z, true) < Config.DrawDistance) then
						canSleep = false
						if IsPedInAnyVehicle(PlayerPedId(), true) == 1 then	
							DrawMarker(1, v.DepositPoint.x, v.DepositPoint.y, v.DepositPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, Config.DepositMarker.r, Config.DepositMarker.g, Config.DepositMarker.b, 100, false, true, 2, false, false, false, false)	
							-- DrawMarker(Config.DepositMarker.type, v.DepositPoint.x, v.DepositPoint.y, v.DepositPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.DepositMarker.x - 15, Config.DepositMarker.y - 15, Config.DepositMarker.z - 15, Config.DepositMarker.r - 250, Config.DepositMarker.g + 250, Config.DepositMarker.b, 100, false, true, 2, false, false, false, false)
						end
					end
				elseif k == "Fishing" then
					if (GetDistanceBetweenCoords(coords, v.DepositPoint.x, v.DepositPoint.y, v.DepositPoint.z, true) < Config.DrawDistance) then
						canSleep = false
						if IsPedInAnyVehicle(PlayerPedId(), true) == 1 then	
							DrawMarker(1, v.DepositPoint.x, v.DepositPoint.y, v.DepositPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 20.0, 20.0, 5.0, Config.DepositMarker.r, Config.DepositMarker.g, Config.DepositMarker.b, 100, false, true, 2, false, false, false, false)	
							-- DrawMarker(Config.DepositMarker.type, v.DepositPoint.x, v.DepositPoint.y, v.DepositPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.DepositMarker.x - 15, Config.DepositMarker.y - 15, Config.DepositMarker.z - 15, Config.DepositMarker.r - 250, Config.DepositMarker.g + 250, Config.DepositMarker.b, 100, false, true, 2, false, false, false, false)
						end
					end
				else
					if (GetDistanceBetweenCoords(coords, v.DepositPoint.x, v.DepositPoint.y, v.DepositPoint.z, true) < Config.DrawDistance) then
						canSleep = false
						if IsPedInAnyVehicle(PlayerPedId(), true) == 1 then	
							DrawMarker(Config.DepositMarker.type, v.DepositPoint.x, v.DepositPoint.y, v.DepositPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.DepositMarker.x, Config.DepositMarker.y, Config.DepositMarker.z, Config.DepositMarker.r, Config.DepositMarker.g, Config.DepositMarker.b, 100, false, true, 2, false, false, false, false)	
							-- DrawMarker(Config.DepositMarker.type, v.DepositPoint.x, v.DepositPoint.y, v.DepositPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.DepositMarker.x - 15, Config.DepositMarker.y - 15, Config.DepositMarker.z - 15, Config.DepositMarker.r - 250, Config.DepositMarker.g + 250, Config.DepositMarker.b, 100, false, true, 2, false, false, false, false)
						end
						if (GetDistanceBetweenCoords(coords, v.DepositPoint.x, v.DepositPoint.y, v.DepositPoint.z, true) < 16.5) then
							local vehicle = GetVehiclePedIsIn(playerPed, false)
							if vehicle ~= 0 then 
								local vehCoords = GetEntityCoords(vehicle)
								SetEntityCoords(vehicle, vehCoords)
								TaskLeaveVehicle(playerPed, vehicle, 0)
							end
						end
					end
				end
			end
			for k,v in pairs(Config.DepositCar) do
				if v.UnDepositPoint then
					if k == "Eco" then
						if (GetDistanceBetweenCoords(coords, v.UnDepositPoint.x, v.UnDepositPoint.y, v.UnDepositPoint.z, true) < 30) then
							canSleep = false
							if IsPedInAnyVehicle(PlayerPedId(), true) == false then
	
								-- RequestModel(GetHashKey("u_m_m_jewelsec_01"))
								-- while not HasModelLoaded(GetHashKey("u_m_m_jewelsec_01")) do
								-- 	Wait(1)
								-- end
	
								-- local playerPed = CreatePed(4, "u_m_m_jewelsec_01", v.UnDepositPoint.x, v.UnDepositPoint.y, v.UnDepositPoint.z - 1, 0.0, false, true)
								-- FreezeEntityPosition(playerPed, true)
								-- SetEntityInvincible(playerPed, true)
								-- SetBlockingOfNonTemporaryEvents(playerPed, true)
								DrawMarker(Config.UnDepositMarker.type, v.UnDepositPoint.x, v.UnDepositPoint.y, v.UnDepositPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.UnDepositMarker.x, Config.UnDepositMarker.y, Config.UnDepositMarker.z, Config.UnDepositMarker.r, Config.UnDepositMarker.g, Config.UnDepositMarker.b, 100, true, true, 2, false, false, false, false)
							end
						end
					elseif k == "Fishing" then
						if (GetDistanceBetweenCoords(coords, v.UnDepositPoint.x, v.UnDepositPoint.y, v.UnDepositPoint.z, true) < 30) then
							canSleep = false
							if IsPedInAnyVehicle(PlayerPedId(), true) == false then
	
								-- RequestModel(GetHashKey("u_m_m_jewelsec_01"))
								-- while not HasModelLoaded(GetHashKey("u_m_m_jewelsec_01")) do
								-- 	Wait(1)
								-- end
	
								-- local playerPed = CreatePed(4, "u_m_m_jewelsec_01", v.UnDepositPoint.x, v.UnDepositPoint.y, v.UnDepositPoint.z - 1, 0.0, false, true)
								-- FreezeEntityPosition(playerPed, true)
								-- SetEntityInvincible(playerPed, true)
								-- SetBlockingOfNonTemporaryEvents(playerPed, true)
								DrawMarker(1, v.UnDepositPoint.x, v.UnDepositPoint.y, v.UnDepositPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 20.0, 20.0, 5.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
							end
						end
					else
						if (GetDistanceBetweenCoords(coords, v.UnDepositPoint.x, v.UnDepositPoint.y, v.UnDepositPoint.z, true) < 30) then
							canSleep = false
							-- if IsPedInAnyVehicle(PlayerPedId(), true) == false then
	
							-- 	-- RequestModel(GetHashKey("u_m_m_jewelsec_01"))
							-- 	-- while not HasModelLoaded(GetHashKey("u_m_m_jewelsec_01")) do
							-- 	-- 	Wait(1)
							-- 	-- end
	
							-- 	-- local playerPed = CreatePed(4, "u_m_m_jewelsec_01", v.UnDepositPoint.x, v.UnDepositPoint.y, v.UnDepositPoint.z - 1, 0.0, false, true)
							-- 	-- FreezeEntityPosition(playerPed, true)
							-- 	-- SetEntityInvincible(playerPed, true)
							-- 	-- SetBlockingOfNonTemporaryEvents(playerPed, true)
							-- 	DrawMarker(Config.UnDepositMarker.type, v.UnDepositPoint.x, v.UnDepositPoint.y, v.UnDepositPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.UnDepositMarker.x, Config.UnDepositMarker.y, Config.UnDepositMarker.z, Config.UnDepositMarker.r, Config.UnDepositMarker.g, Config.UnDepositMarker.b, 100, true, true, 2, false, false, false, false)
							-- end
						end
					end
				end
			end
        end
		if canSleep then
            Citizen.Wait(1000)
        end
	end
end)

function ListOwnedCarsMenu(deposit_key)
	local elements = {}
	ESX.TriggerServerCallback('nightclub_vehiclebox:getOwnedCarsDeposit', function(ownedCars)
		if #ownedCars == 0 then
			ESX.ShowNotification('You dont own any Cars!')
		else
			for _,v in pairs(ownedCars) do
				local hashVehicule = json.decode(v.vehicle).model
				local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
				local labelfuel = 0
				local plate = v.plate
				local kuys = json.decode(v.health_vehicles)
				if kuys then
					labelfuel = Round(kuys.fuel,1)
				end
				local props = json.decode(v.vehicle)
				local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
				if vehicleName == 'NULL' then
					vehicleName = 'Mod car'
				end
				local labelvehicle = ('%s - <span style="color:#FFB447;">%s</span> : '):format(vehicleName, props.plate)
				table.insert(elements, {label = labelvehicle, vehicle = json.decode(v.vehicle), stored = v.stored, plate = v.plate, damage = json.decode(v.health_vehicles)})
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category',
                {
                    title    = "จุดฝากรถ",
                    align    = 'right',
                    elements = {
                        {label = 'เบิกรถที่ฝาก',			value = 'undeposit_car'},
                        {label = 'ฝากของท้ายรถ',			value = 'open_trunk'}
                    },
                }, function(data, menu)
                    if data.current.value == 'open_trunk' then
                        menu.close()
                        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category',
                        {
                            title    = "เปิดท้ายรถ",
                            align    = 'right',
                            elements = elements,
                        }, function(data2, menu2)
                            
                            if data2.current.vehicle then
                                openedvehicle = CreateInvisible(data2.current.vehicle)
                                TriggerEvent("xzero_trunk:CL:On_OpenInventoryBox",openedvehicle)
                                menu2.close()
                            end
            
                        end, function(data2, menu2)
                            menu2.close()
                        end)
                    elseif data.current.value == 'undeposit_car' then
                        menu.close()
                        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_car_deposit', {
                            title    = 'รถที่ฝากไว้ #'..deposit_key..'',
                            align    = 'right',
                            elements = elements
                        }, function(data3, menu3)
                            menu3.close()
                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "stealing",
                                duration = 5000,
                                label = "กำลังเบิกรถ..",
                                useWhileDead = false,
                                canCancel = false,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                },
                            }, function(status)
                                if not status then
                                    Wait(Config.Coodown * 1000)
                                    SpawnVehicle(data3.current.vehicle, data3.current.plate, data3.current.damage)
                                    TriggerEvent("pNotify:SendNotification", {
                                        text = "เอารถออกจากที่ฝากแล้ว",
                                        type = "info",
                                        timeout = 3000,
                                        layout = "centerRight",
                                        queue = "global"
                                    })
                        
                                end
                            end)
                        end, function(data3, menu3)
                            menu3.close()
                        end)
                    end
        
                end, function(data, menu)
                    menu.close()
                end)
			end
		end
	end, deposit_key)
end

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

function refreshBlips()
	local blipList = {}
	local JobBlips = {}
	if Config.DepositCarGarages == true then
		for k,v in pairs(Config.DepositCar) do
			if v.Blips then
				table.insert(blipList, {
					coords = { v.DepositPoint.x, v.DepositPoint.y },
					text   = Config.DepositCarBlip,
					sprite = Config.BlipDepositCar.Sprite,
					color  = Config.BlipDepositCar.Color,
					scale  = Config.BlipDepositCar.Scale
				})
			end
		end
	end
	for i=1, #blipList, 1 do
		CreateBlip(blipList[i].coords, blipList[i].text, blipList[i].sprite, blipList[i].color, 0.6)
	end
end

function CreateBlip(coords, text, sprite, color, scale)
	local blip = AddBlipForCoord( table.unpack(coords) )
	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
	table.insert(JobBlips, blip)
end

function SpawnVehicle(vehicle, plate, damage)
	local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint()

	local cb_veh = nil
	if foundSpawn then
		ESX.Game.SpawnVehicle(vehicle.model, spawnPoint.coords, spawnPoint.heading, function(callback_vehicle)
			ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
			cb_veh = callback_vehicle
			SetDamage(callback_vehicle, damage)
			SetVehRadioStation(callback_vehicle, "OFF")
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
		end)

		TriggerServerEvent('nightclub_vehiclebox:setDepositVehicleState', plate, false)
		TriggerServerEvent('nightclub_vehiclebox:setDepositVehicleDepositCar', plate, nil)

		Wait(500)
		SetVehicleFuelLevel(cb_veh, damage.fuel)
	else
		ESX.ShowNotification('your vehicle is not stored in the garage.')
	end
end

function SetDamage(callback_vehicle, damage)
	if damage then
	SetVehicleEngineHealth(callback_vehicle, damage.health_engine + 0.0 or 1000.0)
	SetVehicleBodyHealth(callback_vehicle, damage.health_body + 0.0 or 1000.0)
	exports['Dv_Hunter_legacyfuel']:SetFuel(callback_vehicle, damage.fuel)

	if damage.tyres then
		for tyreId = 1, 7, 1 do
			if damage.tyres[tyreId] ~= false then
				SetVehicleTyreBurst(callback_vehicle, tyreId, true, 1000)
			end
		end
	end

	if damage.doors then
		for doorId = 0, 5, 1 do
			if damage.doors[doorId] ~= false then
				SetVehicleDoorBroken(callback_vehicle, doorId - 1, true)
			end
		end
	end
	end
end

function SaveDamage(vehicle, vehicleProps)
	local damage = {}
	damage.tyres = {}
	damage.doors = {}

	for id = 1, 7 do
		local tyreId = IsVehicleTyreBurst(vehicle, id, false)
	
		if tyreId then
			damage.tyres[#damage.tyres + 1] = tyreId
	
			if tyreId == false then
				tyreId = IsVehicleTyreBurst(vehicle, id, true)
				damage.tyres[ #damage.tyres] = tyreId
			end
		else
			damage.tyres[#damage.tyres + 1] = false
		end
	end
	
	for id = 0, 5 do
		local doorId = IsVehicleDoorDamaged(vehicle, id)
	
		if doorId then
			damage.doors[#damage.doors + 1] = doorId
		else
			damage.doors[#damage.doors + 1] = false
		end
	end

	damage.fuel = GetVehicleFuelLevel(vehicle)
	damage.health_engine = GetVehicleEngineHealth(vehicle)
	damage.health_body = GetVehicleBodyHealth(vehicle)
	TriggerServerEvent('nightclub_vehiclebox:modifyDepositDamage', vehicleProps.plate, damage)
end


-- Store Owned Cars Menu
function StoreOwnedCarsMenu(DepositKey)
	local playerPed  = GetPlayerPed(-1)
	local vehicle =	GetVehiclePedIsIn(playerPed, false)
	local DSMSS = GetVehiclePedIsIn(playerPed, false)
	local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
	
	ESX.TriggerServerCallback('nightclub_vehiclebox:UndepositstoreVehicle',function(valid)
		if(valid) then
			ESX.TriggerServerCallback('nightclub_vehiclebox:checkMoneyUndeposit', function(hasEnoughMoney)
				TriggerEvent("mythic_progbar:client:progress", {
					name = "stealing",
					duration = 5000,
					label = "กำลังเบิกรถ..",
					useWhileDead = false,
					canCancel = false,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
				}, function(status)
					if not status then
						if hasEnoughMoney then
							SaveDamage(vehicle, vehicleProps)
							DeleteEntity(vehicle)
							print(DepositKey)
							TriggerServerEvent('nightclub_vehiclebox:setDepositVehicleState', vehicleProps.plate, false)
							TriggerServerEvent('nightclub_vehiclebox:setDepositVehicleDepositCar', vehicleProps.plate, DepositKey)
							TriggerEvent("pNotify:SendNotification", {
								text = "ฝากพาหนะของคุณเรียบร้อย",
								type = "info",
								timeout = 3000,
								layout = "centerRight",
								queue = "global"
							})
						else
							TriggerEvent("pNotify:SendNotification", {
								text = "เงินของคุณไม่เพียงพอ",
								type = "info",
								timeout = 3000,
								layout = "centerRight",
								queue = "global"
							})
						end
					end
				end)
			end, Config.UndepositPrice)
		else
			TriggerEvent("pNotify:SendNotification", {
				text = "คุณไม่ใช่เจ้าของ",
				type = "info",
				timeout = 3000,
				layout = "centerRight",
				queue = "global"
			})
		end
	end, vehicleProps)
end




ShowFloatingHelpNotification = function(msg, coords)
	SetTextFont(fontId)
	AddTextEntry('vehiclebox', msg)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('vehiclebox')
	EndTextCommandDisplayHelp(2, false, false, -1)
end

function CallVehicle()
    ESX.TriggerServerCallback('nightclub_vehiclebox:getOwnedCarsDeposit', function(ownedCars)
        if #ownedCars == 0 then
            TriggerEvent("pNotify:SendNotification", {
                text = "คุณไม่มีรถที่เป็นเจ้าของ",
                type = "error",
                queue = "right",
                timeout = 5000,
                layout = "centerRight"
            })
        else
            local elements = {}
            for _,v in pairs(ownedCars) do
                table.insert(elements, {label = '<span style="color: #f7adad;">' .. v.plate .. ' - '..GetLabelText(GetDisplayNameFromVehicleModel(json.decode(v.vehicle).model))..'</span>', plate = v.plate, vehicle = json.decode(v.vehicle)})
            end
            vehiclecache = elements
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category',
            {
                title    = "เปิดท้ายรถ",
                align    = 'top-left',
                elements = elements,
            }, function(data, menu)

                if data.current.vehicle then
                    openedvehicle = CreateInvisible(data.current.vehicle)
                    Config["TRUNK_EVENT"](openedvehicle)
                    menu.close()
                end

            end, function(data, menu)
                menu.close()
            end)
        end
    end)
end

function CreateInvisible(data)
    RequestModel(data.model)
    repeat Wait(0) until HasModelLoaded(data.model)
	local vehicle = CreateVehicle(data.model, GetEntityCoords(PlayerPedId()), 0.0, false, false)
    ESX.Game.SetVehicleProperties(vehicle, data)
    SetEntityVisible(vehicle, false, 0)
	SetVehicleIsConsideredByPlayer(vehicle, false)
	SetEntityCollision(vehicle, false, false)
	return vehicle
end

AddEventHandler("nightclub_vehiclebox:closed",function()
    while DoesEntityExist(openedvehicle) do
        DeleteEntity(openedvehicle)
        Wait(0)
    end
    print("DELETED")
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(OBJ) do
			DeleteObject(v.obj)
		end
	end
end)

function GetAvailableVehicleSpawnPoint()
	local spawnPoints = Config.DepositCar[DepositKey].SpawnDepositPoint
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		ESX.ShowNotification('there\'s no available spawn points!')
		return false
	end
end