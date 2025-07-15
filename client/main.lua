Citizen.CreateThread(function()
    TriggerEvent("chat:addSuggestion", "/time", "Permet de changer l'heure du jeu", {
        { name = "hour", help = "Heure (0-23)" },
        { name = "minute", help = "Minute (0-59)" },
    })
    TriggerEvent("chat:addSuggestion", "/weather", "Permet de changer la météo du jeu", {
        { name = "weather", help = "Type de météo" }
    })
    TriggerEvent("chat:addSuggestion", "/freezeTime", "Permet de geler ou dégeler le temps du jeu")
end)

local syncedHour = 0
local syncedMinute = 0

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('vSync:requestSync')
end)

RegisterNetEvent('vSync:syncTime')
AddEventHandler('vSync:syncTime', function(hour, minute)
    syncedHour = hour
    syncedMinute = minute
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        NetworkOverrideClockTime(syncedHour, syncedMinute, 0)
    end
end)

RegisterNetEvent('vSync:syncWeather')
AddEventHandler('vSync:syncWeather', function(weatherType)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypeOvertimePersist(weatherType, 10.0)
end)