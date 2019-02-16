BWE_HUD = BWE_HUD or {}

local evm = GetEventManager()
local wim = GetWindowManager()
    
BWE_HUD.ADDON_NAME      = "BWE_HUD"
BWE_HUD.ADDON_AUTHOR    = "Nurami"
BWE_HUD.ADDON_VERSION   = 0.1
BWE_HUD.ADDON_SETTINGS  = 1      
BWE_HUD.menuName        = "BWE_HUD Options"
BWE_HUD.Debug			= false

function BWE_HUD.OnAddOnLoaded(event, addonName)
    if addonName ~= BWE_HUD.ADDON_NAME then return end
    
    BWE_HUD:Initialize()
end

function BWE_HUD:Initialize()

    BWE_HUD.SV = ZO_SavedVars:NewAccountWide("BWE_HUD_SV", BWE_HUD.ADDON_SETTINGS, nil, BWE_HUD.defaults)
    
    BWE_HUD.CreateSettings()

    if BWE_HUD.SV.target.enabled == true then 
        ZO_TargetUnitFramereticleover:SetHidden(true)
        
        BWE_HUD.CreateTargetControls() 
        BWE_HUD.InitializeFrame()

        BWE_HUD.targetContainer:ClearAnchors()
        BWE_HUD.targetContainer:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, BWE_HUD.SV.target.position.offsetX, BWE_HUD.SV.target.position.offsetY)
        BWE_HUD.targetContainer:SetHandler("OnMoveStop", BWE_HUD.SaveTargetFrameLocation)
    end
    
    --if BWE_HUD_SV.player.enabled == true then BWE_HUD.CreatePlayerControls() end

    evm:UnregisterForEvent(BWE_HUD.ADDON_NAME, EVENT_ADD_ON_LOADED)

end

evm:RegisterForEvent(BWE_HUD.ADDON_NAME, EVENT_ADD_ON_LOADED, BWE_HUD.OnAddOnLoaded)