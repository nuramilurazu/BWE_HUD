BWE_HUD = BWE_HUD or {}
local evm = GetEventManager()
local wim = GetWindowManager()
local sf = 1/GetSetting(SETTING_TYPE_UI, UI_SETTING_CUSTOM_SCALE)

BWE_HUD.targetContainer = {}
BWE_HUD.targetFrame = {}
BWE_HUD.targetUnlock = false

local allianceIcons = {
	[1]			= [[/esoui/art/guild/guildbanner_icon_aldmeri.dds]],
	[2]			= [[/esoui/art/guild/guildbanner_icon_ebonheart.dds]],
	[3]			= [[/esoui/art/guild/guildbanner_icon_daggerfall.dds]],
	[100]		= [[/esoui/art/ava/ava_allianceflag_neutral.dds]]
}

function BWE_HUD.targetUnlocker(value)
    local frame = BWE_HUD.targetFrame["BWE_TARGET"]

    if value == true then 
        BWE_HUD.UnregisterTargetEvents()
    else
        BWE_HUD.RegisterTargetEvents()
    end
    
	BWE_HUD.targetContainer:SetMovable(value)
	BWE_HUD.targetContainer:SetMouseEnabled(value)
    
    frame:SetHidden(not value)
    frame:SetMovable(value)
    frame:SetMouseEnabled(value)

end

function BWE_HUD.CreateTargetControls()
    local tlw = {}

    tlw = wim:CreateTopLevelWindow()
    tlw:SetDimensions(300, 50)
    tlw:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT)
    tlw:SetMovable(false)
    tlw:SetMouseEnabled(false)
    tlw:SetClampedToScreen(true)
    tlw:SetHidden(false) 

    BWE_HUD.targetContainer = tlw

    local frame = {}

    frame = wim:CreateControl("BWE_TARGET", BWE_HUD.targetContainer, CT_CONTROL)
	frame:SetDimensions(300, 50)
	frame:SetAnchor(TOPLEFT, BWE_HUD.targetContainer, TOPLEFT)
    frame:SetMouseEnabled(true)

    frame.statusBar = wim:CreateControl(nil, frame, CT_CONTROL)
    frame.statusBar:SetDimensions(frame:GetDimensions())
    frame.statusBar:SetAnchor(BOTTOM, frame, BOTTOM, 0, -(3*sf))

    frame.barBg = wim:CreateControl(nil, frame.statusBar, CT_BACKDROP)
    frame.barBg:SetAnchorFill()
    frame.barBg:SetDrawLayer(0)
    frame.barBg:SetDrawLevel(0)
    frame.barBg:SetCenterColor(0, 0, 0, 0.6)
    frame.barBg:SetEdgeColor(0, 0, 0, 1)
    frame.barBg:SetEdgeTexture(nil, 1,1, (2*sf))
    frame.barBg:SetInheritAlpha(false)

    frame.bar = wim:CreateControl(nil, frame.statusBar, CT_STATUSBAR)
    frame.bar:SetDimensions(frame.statusBar:GetWidth()-(4*sf), frame.statusBar:GetHeight()-(4*sf))
	frame.bar:SetAnchor(TOP, frame.statusBar, TOP, 0, (2*sf))
    frame.bar:SetDrawLayer(0)
	frame.bar:SetDrawLevel(1)
	frame.bar:SetColor(0.4, 0.4, 0.4, 1)
	frame.bar:SetBarAlignment(0)
	frame.bar:SetMinMax(0, 1000)
    frame.bar:SetValue(1000)
    
    frame.gloss = wim:CreateControl(nil, frame.bar, CT_STATUSBAR)
	frame.gloss:SetDimensions(frame.bar:GetDimensions())
	frame.gloss:SetAnchor(TOP, frame.bar, TOP)
	frame.gloss:SetDrawLayer(0)
	frame.gloss:SetDrawLevel(2)
	frame.gloss:SetTexture("EsoUI/Art/Miscellaneous/timerBar_genericFill_gloss.dds")
	frame.gloss:SetTextureCoords(0, 1, 0, 0.8125)
	frame.gloss:SetBarAlignment(0)
	frame.gloss:SetMinMax(0, 1000)
    frame.gloss:SetValue(1000)

    frame.value = wim:CreateControl(nil, frame, CT_LABEL)
	frame.value:SetAnchor(CENTER, frame.bar, CENTER)
	frame.value:SetDrawLayer(1)
	frame.value:SetDrawLevel(0)
	frame.value:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	frame.value:SetVerticalAlignment(TEXT_ALIGN_BOTTOM)
	frame.value:SetAlpha(0.9)
	frame.value:SetFont("$(BOLD_FONT)|13|soft-shadow-thick")
    frame.value:SetText("18k / 18k 100%")
    
    frame.info = wim:CreateControl(nil, frame, CT_LABEL)
	frame.info:SetDimensions(frame:GetWidth(), 15)
	frame.info:SetAnchor(BOTTOMLEFT, frame.statusBar, TOPLEFT, -(2*sf), -(4*sf))
	frame.info:SetDrawLayer(1)
	frame.info:SetDrawLevel(2)
	frame.info:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	frame.info:SetFont("$(BOLD_FONT)|13|soft-shadow-thin")
	frame.info:SetText("Queen Ayren(50) ")
    
    frame.title = wim:CreateControl(nil, frame, CT_LABEL)
    frame.title:SetDimensions(frame:GetWidth(), 15)
    frame.title:SetAnchor(BOTTOMLEFT, frame.statusBar, BOTTOMLEFT, 2*sf, 13*sf)
    frame.title:SetDrawLayer(1)
    frame.title:SetDrawLevel(4)
    frame.title:SetVerticalAlignment(TEXT_ALIGN_CENTER)
    frame.title:SetFont("$(BOLD_FONT)|13|soft-shadow-thin")
    frame.title:SetText("  Veteran")
    
    frame.alliance = wim:CreateControl(nil, frame, CT_TEXTURE)
	frame.alliance:SetDimensions(0, 18)
	frame.alliance:SetAnchor(TOPRIGHT, frame.statusBar, TOPLEFT, -sf, 0)
	frame.alliance:SetDrawLayer(2)
	frame.alliance:SetDrawLevel(1)
	frame.alliance:SetHidden(false)
	frame.alliance:SetTexture("/esoui/art/ava/ava_allianceflag_neutral.dds")

    BWE_HUD.targetFrame["BWE_TARGET"] = frame

end

function BWE_HUD.InitializeFrame()
    local frame = BWE_HUD.targetFrame["BWE_TARGET"]

    if BWE_HUD.SV.target.custom.enabled == true then
        frame.bar:SetColor(unpack(BWE_HUD.SV.target.custom.Color))
    else
        frame.bar:SetColor(unpack(BWE_HUD.SV.target.color))
    end

    frame.value:SetFont("$(BOLD_FONT)|"..BWE_HUD.SV.target.textSize.."|soft-shadow-thin")
    frame.info:SetFont("$(BOLD_FONT)|"..BWE_HUD.SV.target.textSize.."|soft-shadow-thin")
    frame.title:SetFont("$(BOLD_FONT)|"..BWE_HUD.SV.target.textSize.."|soft-shadow-thin")

    frame:SetDimensions(BWE_HUD.SV.target.size.width, BWE_HUD.SV.target.size.height)

    frame.barBg:SetAlpha(BWE_HUD.SV.target.opacity.bgAlpha)
    frame.bar:SetAlpha(BWE_HUD.SV.target.opacity.barAlpha)
    frame.gloss:SetAlpha(BWE_HUD.SV.target.opacity.glossAlpha)
    
    if BWE_HUD.Debug == true then 
        frame:SetHidden(false)
    else
        frame:SetHidden(true)
        BWE_HUD.RegisterTargetEvents()
        --zo_callLater(BWE_HUD.RegisterTargetEvents, 2000)
    end 
end

function BWE_HUD.SaveTargetFrameLocation()
    BWE_HUD.SV.target.position.offsetX = zo_round(BWE_HUD.targetContainer:GetLeft())
    BWE_HUD.SV.target.position.offsetY = zo_round(BWE_HUD.targetContainer:GetTop())

    BWE_HUD.targetContainer:ClearAnchors()
    BWE_HUD.targetContainer:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, BWE_HUD.SV.target.position.offsetX, BWE_HUD.SV.target.position.offsetY)
end

function BWE_HUD.UpdateTargetFrame()
    local frame = BWE_HUD.targetFrame["BWE_TARGET"]

    ZO_TargetUnitFramereticleover:SetHidden(true)    

	if (not DoesUnitExist('reticleover')) then frame:SetHidden(true) return end

    local target = {
        name        = "",
        lvl         = 0,
        class       = "",
        classIcon   = "",
        alliance    = "",
        avaRank     = "",
        avaRankIcon = "",
        title       = "",
    }

    if GetUnitType('reticleover') == 0 then
        frame:SetHidden(true)

    elseif GetUnitType('reticleover') == 1 then

        if BWE_HUD.SV.target.useACCID == true then
            target.name = GetUnitDisplayName('reticleover')
        else
            target.name = GetUnitName('reticleover')
        end

        if IsUnitChampion('reticleover') then
            target.lvl = zo_iconTextFormat("esoui/art/champion/champion_icon_32.dds", iconSize.champ, iconSize.champ, GetUnitChampionPoints('reticleover'))
        else
            target.lvl = GetUnitLevel('reticleover')
        end

        target.class = GetClassIcon(GetUnitClassId('reticleover'))
        target.classIcon = zo_iconFormat(target.class, iconSize.class, iconSize.class)
		target.alliance = zo_iconFormat(allianceIcons[GetUnitAlliance('reticleover')], iconSize.ally, iconSize.ally)

        frame.info:SetText(target.name..target.lvl.." "..target.classIcon.." "..target.alliance)

        frame.alliance:SetTexture(allianceIcons[GetUnitAlliance('reticleover')])
        --frame.alliance:SetHidden(false)

        target.avaRank = GetAvARankIcon(GetUnitAvARank('reticleover'))
        target.avaRankIcon = zo_iconFormat(target.avaRank, iconSize.ava, iconSize.ava)
        target.title = GetUnitTitle('reticleover')

        if target.title == "" then target.title = GetAvARankName(GetUnitGender('reticleover'), GetUnitAvARank('reticleover')) end
        frame.title:SetText(target.avaRankIcon.." "..target.title)

        BWE_HUD.UpdateTargetHealth()
        frame:SetHidden(false)
        
    else

        if GetUnitDifficulty('reticleover') == 2 then
            frame.alliance:SetTexture("/esoui/art/lfg/lfg_normaldungeon_down.dds")
            frame.alliance:SetHidden(false)
        elseif GetUnitDifficulty('reticleover') == 3 then
            frame.alliance:SetTexture("/esoui/art/unitframes/target_veteranrank_icon.dds")
            frame.alliance:SetHidden(false)
        else
            frame.alliance:SetHidden(true)
        end    
        
        target.title = GetUnitCaption('reticleover')
        frame.title:SetText(target.title)
        target.name = GetUnitName('reticleover')
        frame.info:SetText(target.name)

        BWE_HUD.UpdateTargetHealth()
        frame:SetHidden(false)

    end

end

function  BWE_HUD.UpdateTargetHealth()
    local frame = BWE_HUD.targetFrame["BWE_TARGET"]
    local current, max, effectiveMax = GetUnitPower('reticleover', POWERTYPE_HEALTH)

	if current <= 0 then frame:SetHidden(true) return end

    local percent = 0
    if maximum ~= 0 then
        percent = (current / max) * 100
        if percent < 10 then
            percent = ZO_LocalizeDecimalNumber(zo_roundToNearest(percent, .1))
        else
            percent = zo_round(percent)
        end
    end

    frame.bar:SetMinMax(0, max)
    frame.bar:SetValue(current)
	frame.gloss:SetMinMax(0, max)
	frame.gloss:SetValue(current)
    frame.value:SetText(current.." ("..percent.."%)")    
end

function BWE_HUD.ReinitFrame()
    local frame = BWE_HUD.targetFrame["BWE_TARGET"]

    if BWE_HUD.SV.target.custom.enabled == true then
        frame.bar:SetColor(unpack(BWE_HUD.SV.target.custom.Color))
    else
        frame.bar:SetColor(unpack(BWE_HUD.SV.target.color))
    end

    frame.value:SetFont("$(BOLD_FONT)|"..BWE_HUD.SV.target.textSize.."|soft-shadow-thin")
    frame.info:SetFont("$(BOLD_FONT)|"..BWE_HUD.SV.target.textSize.."|soft-shadow-thin")
    frame.title:SetFont("$(BOLD_FONT)|"..BWE_HUD.SV.target.textSize.."|soft-shadow-thin")

    frame:SetDimensions(BWE_HUD.SV.target.size.width, BWE_HUD.SV.target.size.height)

    frame.barBg:SetAlpha(BWE_HUD.SV.target.opacity.bgAlpha)
    frame.bar:SetAlpha(BWE_HUD.SV.target.opacity.barAlpha)
    frame.gloss:SetAlpha(BWE_HUD.SV.target.opacity.glossAlpha)
end

function BWE_HUD.CombatState()
    local frame = BWE_HUD.targetFrame["BWE_TARGET"]
    local combatState = IsUnitInCombat('player')
	
	if combatState == true then
        frame.bar:SetAlpha(1)
        frame.gloss:SetAlpha(1)
	else
		frame.bar:SetAlpha(BWE_HUD.SV.target.opacity.barAlpha)
        frame.gloss:SetAlpha(BWE_HUD.SV.target.opacity.glossAlpha)
	end
end

function BWE_HUD.UnregisterTargetEvents()
    evm:UnregisterForEvent(BWE_HUD.ADDON_NAME, EVENT_RETICLE_TARGET_CHANGED)
    evm:UnregisterForEvent(BWE_HUD.ADDON_NAME, EVENT_COMBAT_EVENT)
    evm:UnregisterForEvent(BWE_HUD.ADDON_NAME, EVENT_PLAYER_COMBAT_STATE)
end

function BWE_HUD.RegisterTargetEvents()
    evm:RegisterForEvent(BWE_HUD.ADDON_NAME, EVENT_RETICLE_TARGET_CHANGED, BWE_HUD.UpdateTargetFrame)
    evm:RegisterForEvent(BWE_HUD.ADDON_NAME, EVENT_COMBAT_EVENT, BWE_HUD.UpdateTargetHealth)
    evm:RegisterForEvent(BWE_HUD.ADDON_NAME, EVENT_PLAYER_COMBAT_STATE, BWE_HUD.CombatState)
end