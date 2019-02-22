BWE_HUD = BWE_HUD or {}

local evm = GetEventManager()

BWE_HUD.ADDON_NAME      = "BWE_HUD"
BWE_HUD.ADDON_AUTHOR    = "Nurami"
BWE_HUD.ADDON_VERSION   = 0.2
BWE_HUD.ADDON_SETTINGS  = 1.3
BWE_HUD.menuName        = "BWE_HUD Options"
BWE_HUD.container       = {}
BWE_HUD.Debug			= false

local strgsub			= string.gsub
local captureStr		= '%1' .. "," .. '%2'
local k

function BWE_HUD.CreateHUD()
    local tlw = {}

    tlw = WINDOW_MANAGER:CreateTopLevelWindow()
    tlw:SetDimensions(1920, 1080)
    tlw:SetAnchor(CENTER)
    tlw:SetMovable(false)
    tlw:SetMouseEnabled(false)
    tlw:SetClampedToScreen(true)
    tlw:SetHidden(false)

    BWE_HUD.container = tlw
end

function BWE_HUD.comma_value(amount)
	while (true) do
		amount, k = strgsub(amount, '^(-?%d+)(%d%d%d)', captureStr)

		if (k == 0) then
			break
		end
	end

	return amount
end

function BWE_HUD.OnAddOnLoaded(event, addonName)
    if addonName ~= BWE_HUD.ADDON_NAME then return end

    BWE_HUD:Initialize()
end

function BWE_HUD:Initialize()

    BWE_HUD.SV = ZO_SavedVars:NewAccountWide("BWE_HUD_SV", BWE_HUD.ADDON_SETTINGS, nil, BWE_HUD.defaults)

    BWE_HUD.CreateHUD()
    BWE_HUD.CreateSettings()

    if BWE_HUD.SV.target.enabled == true then
        ZO_TargetUnitFramereticleover:SetHidden(true)

        BWE_HUD.CreateTargetControls()
        BWE_HUD.InitializeFrame()

        --[[ BWE_HUD.targetContainer:ClearAnchors()
        BWE_HUD.targetContainer:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, BWE_HUD.SV.target.position.offsetX, BWE_HUD.SV.target.position.offsetY)
        BWE_HUD.targetContainer:SetHandler("OnMoveStop", BWE_HUD.SaveTargetFrameLocation) ]]
    end

    --if BWE_HUD_SV.player.enabled == true then BWE_HUD.CreatePlayerControls() end

    --if BWE_HUD_SV.hotbarEnabled == true then BWE_HUD.CreateHotbarElements() end

    evm:UnregisterForEvent(BWE_HUD.ADDON_NAME, EVENT_ADD_ON_LOADED)

end

evm:RegisterForEvent(BWE_HUD.ADDON_NAME, EVENT_ADD_ON_LOADED, BWE_HUD.OnAddOnLoaded)