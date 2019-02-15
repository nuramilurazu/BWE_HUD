BWE_HUD = {
    ADDON_NAME      = "BWE_HUD",  
    ADDON_AUTHOR    = "Nurami",
    ADDON_VERSION   = "0.1",
    ADDON_SETTINGS  = 2,
    color           = "DDFFEE",             
    menuName        = "BWE_HUD Options",
}

function BWE_HUD.Colorize(text, color)
    -- Default to addon's .color.
    if not color then color = BWE_HUD.color end

    text = "|c" .. color .. text .. "|r"

    return text
end

function BWE_HUD.OnAddOnLoaded(event, addonName)
    if addonName ~= BWE_HUD.ADDON_NAME then return end
    
    BWE_HUD:Initialize()
end

function BWE_HUD:Initialize()

    BWE_HUD.savedVariables = ZO_SavedVars:NewAccountWide("BWE_HUD_SV", ADDON_SETTINGS, nil, BWE_HUD.savedVariables)
    
    BWE_HUD.CreateSettings()
    --BWE_HUD.CreateTargetControls
    --BWE_HUD.CreatePlayerControls

    EVENT_MANAGER:UnregisterForEvent(BWE_HUD.ADDON_NAME, EVENT_ADD_ON_LOADED)
    
end

EVENT_MANAGER:RegisterForEvent(BWE_HUD.ADDON_NAME, EVENT_ADD_ON_LOADED, BWE_HUD.OnAddOnLoaded)