local hasShownNotification = false
local isInWater = false

local function IsWinterWeather()
    local weatherType = GetPrevWeatherTypeHashName()
    for _, winterType in ipairs(Config.WinterWeatherTypes) do
        if weatherType == GetHashKey(winterType) then
            return true
        end
    end
    return false
end

local function ShowNotification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(message)
    DrawNotification(false, true)
end

local function GetPlayerGender()
    local playerPed = PlayerPedId()
    local model = GetEntityModel(playerPed)
    if model == GetHashKey("mp_m_freemode_01") or model == GetHashKey("s_m_m_default") then
        return "male"
    elseif model == GetHashKey("mp_f_freemode_01") or model == GetHashKey("s_f_m_default") then
        return "female"
    end
    return "unknown"
end

local function PlayVoiceSound(soundName)
    if Config.SoundOn then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionFile = soundName,
            transactionVolume = Config.SoundVolume
        })
    end
end

local function ApplyColdWaterEffects()
    TriggerScreenblurFadeIn(Config.BlurEffectDuration * 1000)

    local playerPed = PlayerPedId()
    ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", Config.ShakeIntensity)

    Citizen.Wait(Config.BlurEffectDuration * 1000)
    TriggerScreenblurFadeOut(Config.BlurEffectDuration * 1000)
end

local function ApplyWaterTemperatureDamage()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.WaterDamageInterval * 1000)

            if IsWinterWeather() then
                local playerPed = PlayerPedId()
                if IsEntityInWater(playerPed) then
                    if not isInWater then
                        local gender = GetPlayerGender()
                        if gender == "male" then
                            PlayVoiceSound("cold_water_voice_male")
                        elseif gender == "female" then
                            PlayVoiceSound("cold_water_voice_female")
                        end
                        isInWater = true
                    end

                    ApplyDamageToPed(playerPed, Config.WaterDamageAmount, false)

                    if not hasShownNotification then
                        ShowNotification(Config.NotificationMessage)
                        ApplyColdWaterEffects()
                        hasShownNotification = true
                    end
                else
                    if isInWater then
                        local gender = GetPlayerGender()
                        if gender == "male" then
                            PlayVoiceSound("exit_water_voice_male")
                        elseif gender == "female" then
                            PlayVoiceSound("exit_water_voice_female")
                        end
                        isInWater = false
                    end

                    hasShownNotification = false
                end
            end
        end
    end)
end

ApplyWaterTemperatureDamage()
