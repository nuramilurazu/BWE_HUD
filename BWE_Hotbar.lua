BWE_HUD = BWE_HUD or {}

local evm = GetEventManager()
local wim = GetWindowManager()

local ULTIMATE_SLOT_INDEX = ACTION_BAR_ULTIMATE_SLOT_INDEX + 1
local actionBarUltimateButton = ZO_ActionBar_GetButton(ULTIMATE_SLOT_INDEX)

BWE_HUD.hotBarElements = {}

function BWE_HUD.CreateHotbarElements()
    local frame = {}

    frame = ZO_ActionBar1

    frame.ultVal = wim:CreateControl(nil, actionBarUltimateButton.slot, CT_LABEL)
	frame.ultVal:SetDimensions(120, 20)
    frame.ultVal:SetAnchor(BOTTOM, actionBarUltimateButton.slot, TOP, 0, -3)
	frame.ultVal:SetDrawLayer(1)
	frame.ultVal:SetDrawLevel(0)
	frame.ultVal:SetHorizontalAlignment(1)
	frame.ultVal:SetVerticalAlignment(2)
	frame.ultVal:SetFont("$(BOLD_FONT)|13|soft-shadow-thin")
    frame.ultVal:SetText("0/0")

    frame.ultPCT = wim:CreateControl(nil, actionBarUltimateButton.slot, CT_LABEL)
	frame.ultPCT:SetDimensions(120, 20)
	frame.ultPCT:SetAnchor(CENTER, actionBarUltimateButton.slot, CENTER, 0, 0)
	frame.ultPCT:SetDrawLayer(1)
	frame.ultPCT:SetDrawLevel(0)
	frame.ultPCT:SetHorizontalAlignment(1)
	frame.ultPCT:SetVerticalAlignment(1)
	frame.ultPCT:SetFont("$(BOLD_FONT)|13|soft-shadow-thin")
    frame.ultPCT:SetText("100%")

    frame.potionCD = wim:CreateControl(nil, ActionButton9, CT_LABEL)
	frame.potionCD:SetDimensions(120, 20)
	frame.potionCD:SetAnchor(BOTTOM, ActionButton9, TOP, 0, -2)
	frame.potionCD:SetDrawLayer(1)
	frame.potionCD:SetDrawLevel(0)
	frame.potionCD:SetHorizontalAlignment(1)
	frame.potionCD:SetVerticalAlignment(2)
	frame.potionCD:SetFont("$(BOLD_FONT)|13|soft-shadow-thin")
    frame.potionCD:SetText("45s")
    frame.potionCD:SetHidden(false)

	BWE_HUD.hotBarElements["BWE_HOTBAR"] = frame

	BWE_HUD.HotbarInit()
end

function BWE_HUD.HotbarInit()
	BWE_HUD.UltimateUpdate()

	evm:RegisterForUpdate("PotionCD", 100, function() BWE_HUD.PotionUpdate() end)

	BWE_HUD.HotbarOptionals()

	BWE_HUD.RegisterHotbarEvents()
end

function BWE_HUD.UltimateUpdate()
	local frame = BWE_HUD.hotBarElements["BWE_HOTBAR"]

	local current, max, effectiveMax = GetUnitPower('player', POWERTYPE_ULTIMATE)

	local cost = GetSlotAbilityCost(8)

	local pct = 0

	if (current == 0) then
		frame.ultPCT:SetText("0%")
		frame.ultVal:SetText("0/"..cost)
	else
		pct = (current / cost) * 100
		if pct < 10 then
			pct = ZO_LocalizeDecimalNumber(zo_roundToNearest(pct, .1))
		else
			pct = zo_round(pct)
		end
		frame.ultPCT:SetText(pct.."%")
		frame.ultVal:SetText(current.."/"..cost)
	end

end

function BWE_HUD.HotbarOptionals()
	local frame = BWE_HUD.hotBarElements["BWE_HOTBAR"]

	--set textsize
	local textSize = BWE_HUD.SV.hotbar.textSize
	frame.ultVal:SetFont("$(BOLD_FONT)|"..textSize.."|soft-shadow-thin")
	frame.ultPCT:SetFont("$(BOLD_FONT)|"..textSize.."|soft-shadow-thin")
	frame.potionCD:SetFont("$(BOLD_FONT)|"..textSize.."|soft-shadow-thin")

	--hide keybinds
	if BWE_HUD.SV.hotbar.showKeybinds == false then
		ZO_ActionBar1KeybindBG:SetAlpha(true and 0)
		ZO_ActionBar1KeybindBG:SetHidden(true)
		ActionButton3ButtonText:SetAlpha(true and 0)
		ActionButton3ButtonText:SetHidden(true)
		ActionButton4ButtonText:SetAlpha(true and 0)
		ActionButton4ButtonText:SetHidden(true)
		ActionButton5ButtonText:SetAlpha(true and 0)
		ActionButton5ButtonText:SetHidden(true)
		ActionButton6ButtonText:SetAlpha(true and 0)
		ActionButton6ButtonText:SetHidden(true)
		ActionButton7ButtonText:SetAlpha(true and 0)
		ActionButton7ButtonText:SetHidden(true)
		ActionButton8ButtonText:SetAlpha(true and 0)
		ActionButton8ButtonText:SetHidden(true)
		ActionButton9ButtonText:SetAlpha(true and 0)
		ActionButton9ButtonText:SetHidden(true)
	end

	--hide weapon swap
	if BWE_HUD.SV.hotbar.showWeaponSwap == false then
		ZO_ActionBar1WeaponSwap:SetAlpha(true and 0)
		ZO_ActionBar1WeaponSwapLock:SetAlpha(true and 0)
		ZO_ActionBar1WeaponSwap:SetHidden(true)
		ZO_ActionBar1WeaponSwapLock:SetHidden(true)
	end
end

function BWE_HUD.PotionUpdate()
	local frame = BWE_HUD.hotBarElements["BWE_HOTBAR"]

	local remain, duration, global = GetSlotCooldownInfo(GetCurrentQuickslot())

	-- Global cooldown
	if ( global and duration == 1000 ) then return end

	-- No cooldown
	if ( remain == 0 ) then
		frame.potionCD:SetHidden(true)
		return
	end

	-- On cooldown
	remain = remain/1000
	remain = ZO_LocalizeDecimalNumber(zo_roundToNearest(remain, .1))
	frame.potionCD:SetText(remain.."s")
	frame.potionCD:SetHidden(false)

end

function BWE_HUD.UnregisterHotBarEvents()
    evm:UnregisterForEvent(BWE_HUD.ADDON_NAME, EVENT_POWER_UPDATE)
    evm:UnregisterForEvent(BWE_HUD.ADDON_NAME, EVENT_ACTIVE_WEAPON_PAIR_CHANGED)
end

function BWE_HUD.RegisterHotbarEvents()
    evm:RegisterForEvent(BWE_HUD.ADDON_NAME, EVENT_POWER_UPDATE, BWE_HUD.UltimateUpdate)
	evm:RegisterForEvent(BWE_HUD.ADDON_NAME, EVENT_ACTIVE_WEAPON_PAIR_CHANGED, BWE_HUD.UltimateUpdate)

	evm:AddFilterForEvent(BWE_HUD.ADDON_NAME, EVENT_POWER_UPDATE, REGISTER_FILTER_POWER_TYPE, POWERTYPE_ULTIMATE)
	evm:AddFilterForEvent(BWE_HUD.ADDON_NAME, EVENT_POWER_UPDATE, REGISTER_FILTER_UNIT_TAG, 'player')
end