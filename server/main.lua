local currentHour, currentMinute = math.random(0, 23), math.random(0, 59)
local currentWeatherType = Config.AvailableWeatherTypes[math.random(1, #Config.AvailableWeatherTypes)]

local freezeTime = Config.FreezeTime

local function syncAllPlayers()
    TriggerClientEvent('vSync:syncTime', -1, currentHour, currentMinute)
    TriggerClientEvent('vSync:syncWeather', -1, currentWeatherType)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if not freezeTime then
            currentMinute = currentMinute + 1
            if currentMinute >= 60 then
                currentMinute = 0
                currentHour = currentHour + 1
                if currentHour >= 24 then
                    currentHour = 0
                end
            end
        end
        TriggerClientEvent('vSync:syncTime', -1, currentHour, currentMinute)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000) 
    syncAllPlayers()
end)

RegisterNetEvent('vSync:requestSync', function()
    local _src = source
    TriggerClientEvent('vSync:syncTime', _src, currentHour, currentMinute)
    TriggerClientEvent('vSync:syncWeather', _src, currentWeatherType)
end)

-- Command to change the time
RegisterCommand('time', function(source, args)
    if not args[1] then return end
    currentHour = tonumber(args[1]) or currentHour
    currentMinute = tonumber(args[2]) or 0
    TriggerClientEvent('vSync:syncTime', -1, currentHour, currentMinute)
end, true)

-- Command to change the weather
RegisterCommand('weather', function(source, args)
    if not args[1] then return end
    currentWeatherType = args[1]
    TriggerClientEvent('vSync:syncWeather', -1, currentWeatherType)
end, true)

-- Command to freeze or unfreeze time
RegisterCommand('freezeTime', function(source, args)
    freezeTime = not freezeTime
end, true)