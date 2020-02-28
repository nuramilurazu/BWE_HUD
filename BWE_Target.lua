BWE_HUD = BWE_HUD or {}
local evm = GetEventManager()
local wim = GetWindowManager()
local sf = 1/GetSetting(SETTING_TYPE_UI, UI_SETTING_CUSTOM_SCALE)

BWE_HUD.targetFrame = {}
BWE_HUD.targetUnlock = false

local shielded = false

local allianceIcons = {
	[1]			= [[/esoui/art/guild/guildbanner_icon_aldmeri.dds]],
	[2]			= [[/esoui/art/guild/guildbanner_icon_ebonheart.dds]],
	[3]			= [[/esoui/art/guild/guildbanner_icon_daggerfall.dds]],
	[100]		= [[/esoui/art/ava/ava_allianceflag_neutral.dds]]
}

local allianceColors = {
	[1] = "f7e14d",
	[2] = "b5371b",
	[3] = "699eb3",
}

function BWE_HUD.targetUnlocker(value)
    local frame = BWE_HUD.targetFrame["BWE_TARGET"]

    if value == true then
        BWE_HUD.UnregisterTargetEvents()
    else
        BWE_HUD.SV.target.position.offsetX = zo_round(frame:GetLeft())
        BWE_HUD.SV.target.position.offsetY = zo_round(frame:GetTop())
        BWE_HUD.RegisterTargetEvents()
    end

    BWE_HUD.targetUnlock = value

    frame:SetHidden(not value)
    frame:SetMovable(value)
    frame:SetMouseEnabled(value)

end

function BWE_HUD.CreateTargetControls()

    local frame = {}

    frame = wim:CreateControl("BWE_TARGET", BWE_HUD.container, CT_CONTROL)
    frame:SetDimensions(BWE_HUD.SV.target.size.width, BWE_HUD.SV.target.size.height)
	frame:SetAnchor(TOPLEFT, BWE_HUD.container, TOPLEFT, BWE_HUD.SV.target.position.offsetX, BWE_HUD.SV.target.position.offsetY)    
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

    frame.shield = wim:CreateControl(nil, frame.bar, CT_STATUSBAR)
    frame.shield:SetDimensions(frame.bar:GetDimensions())
	frame.shield:SetAnchor(TOP, frame.bar, TOP)
	frame.shield:SetDrawLayer(0)
    frame.shield:SetDrawLevel(2)
	frame.shield:SetColor(0.4, 0.4, 0.4, 1)
	frame.shield:SetBarAlignment(0)
	frame.shield:SetMinMax(0, 1000)
    frame.shield:SetValue(1000)

    frame.gloss = wim:CreateControl(nil, frame.bar, CT_STATUSBAR)
	frame.gloss:SetDimensions(frame.bar:GetDimensions())
	frame.gloss:SetAnchor(TOP, frame.bar, TOP)
	frame.gloss:SetDrawLayer(0)
	frame.gloss:SetDrawLevel(3)
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
    frame.title:SetAnchor(BOTTOMLEFT, frame.statusBar, BOTTOMLEFT, -(2*sf), 13*sf)
    frame.title:SetDrawLayer(1)
    frame.title:SetDrawLevel(4)
    frame.title:SetVerticalAlignment(TEXT_ALIGN_CENTER)
    frame.title:SetFont("$(BOLD_FONT)|13|soft-shadow-thin")
    frame.title:SetText("  Veteran")

    frame.alliance = wim:CreateControl(nil, frame, CT_TEXTURE)
	frame.alliance:SetDimensions(BWE_HUD.SV.target.size.height/1.5, BWE_HUD.SV.target.size.height/1.5)
	frame.alliance:SetAnchor(TOPRIGHT, frame.statusBar, TOPLEFT, -sf, BWE_HUD.SV.target.size.height/5)
	frame.alliance:SetDrawLayer(2)
	frame.alliance:SetDrawLevel(0)
	frame.alliance:SetTexture("/esoui/art/ava/ava_allianceflag_neutral.dds")

    BWE_HUD.targetFrame["BWE_TARGET"] = frame

end

function BWE_HUD.InitializeFrame()
    local frame = BWE_HUD.targetFrame["BWE_TARGET"]

    local textSize = BWE_HUD.SV.target.textSize
    local iconSize = BWE_HUD

    if BWE_HUD.SV.target.custom.enabled == true then
        frame.bar:SetColor(unpack(BWE_HUD.SV.target.custom.frameColor))
        frame.shield:SetColor(unpack(BWE_HUD.SV.target.custom.shieldColor))
    else
        frame.bar:SetColor(unpack(BWE_HUD.SV.target.frameColor))
        frame.shield:SetColor(unpack(BWE_HUD.SV.target.shieldColor))
    end

    iconSize.class = textSize+(4*sf)
    iconSize.champ = textSize-(1*sf)
    iconSize.ava   = textSize+(4*sf)
    iconSize.ally  = textSize+(4*sf)

    frame.value:SetFont("$(BOLD_FONT)|"..textSize.."|soft-shadow-thin")
    frame.info:SetFont("$(BOLD_FONT)|"..textSize.."|soft-shadow-thin")
    frame.title:SetFont("$(BOLD_FONT)|"..textSize.."|soft-shadow-thin")

    frame.barBg:SetAlpha(BWE_HUD.SV.target.opacity.bgAlpha)
    frame.bar:SetAlpha(BWE_HUD.SV.target.opacity.barAlpha)
    frame.shield:SetAlpha(BWE_HUD.SV.target.opacity.barAlpha)
    frame.gloss:SetAlpha(BWE_HUD.SV.target.opacity.glossAlpha)

    if GetSetting(SETTING_TYPE_GRAPHICS,GRAPHICS_SETTING_FULLSCREEN) == "0" then --Real Fix for drifting issue
		local xpos = zo_round(frame:GetLeft())
		xpos = xpos - BWE_HUD.SV.target.position.offsetX
		xpos = BWE_HUD.SV.target.position.offsetX - xpos
		frame:SetAnchor(TOPLEFT, BWE_HUD.container, TOPLEFT, xpos, BWE_HUD.SV.target.position.offsetY)
	end

    if BWE_HUD.Debug == true then
        frame:SetHidden(false)
    else
        frame:SetHidden(true)
        BWE_HUD.RegisterTargetEvents()
    end
end

function BWE_HUD.SaveTargetFrameLocation()
    BWE_HUD.SV.target.position.offsetX = zo_round(BWE_HUD.targetContainer:GetLeft())
    BWE_HUD.SV.target.position.offsetY = zo_round(BWE_HUD.targetContainer:GetTop())
end

function BWE_HUD.UpdateTargetFrame()
    local frame = BWE_HUD.targetFrame["BWE_TARGET"]
    local iconSize = BWE_HUD

    ZO_TargetUnitFramereticleover:SetHidden(true)

    if (not DoesUnitExist('reticleover')) then frame:SetHidden(true) return end
    
    if (IsUnitDead('reticleover')) then frame:SetHidden(true) return end

    if BWE_HUD.SV.target.uRColor == true then frame.bar:SetColor(GetUnitReactionColor("reticleover")) end

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

        frame.info:SetText(target.name..target.classIcon..target.lvl)

        target.avaRank = GetAvARankIcon(GetUnitAvARank('reticleover'))
        target.avaRankIcon = zo_iconFormatInheritColor(target.avaRank, iconSize.ava, iconSize.ava)
        target.title = GetUnitTitle('reticleover')

        if target.title == "" then target.title = GetAvARankName(GetUnitGender('reticleover'), GetUnitAvARank('reticleover')) end

        if BWE_HUD.SV.target.useLargeIcon == true then 
            frame.alliance:SetTexture(allianceIcons[GetUnitAlliance('reticleover')])
            frame.alliance:SetHidden(false)
            frame.title:SetText("|c"..allianceColors[GetUnitAlliance('reticleover')]..target.avaRankIcon.."| ".."|cFFFFFF"..target.title.."|")
        else
            frame.title:SetText(target.alliance.." ".."|c"..allianceColors[GetUnitAlliance('reticleover')]..target.avaRankIcon.."| ".."|cFFFFFF"..target.title.."|")
            frame.alliance:SetHidden(true)
        end

        BWE_HUD.UpdateTargetHealth()
        frame:SetHidden(false)

    else

        if GetUnitDifficulty('reticleover') == MONSTER_DIFFICULTY_HARD then
            frame.alliance:SetTexture("/esoui/art/lfg/lfg_normaldungeon_down.dds")
            frame.alliance:SetHidden(false)
        elseif GetUnitDifficulty('reticleover') == MONSTER_DIFFICULTY_DEADLY then
            frame.alliance:SetTexture("/esoui/art/unitframes/target_veteranrank_icon.dds")
            frame.alliance:SetHidden(false)
        else
            frame.alliance:SetHidden(true)
        end

        target.title = GetUnitCaption('reticleover')

		if target.title == "" or target.title == nil then
			frame.title:SetText("")
		else
			if string.char(string.byte(target.title, 1 , 5)) == "Guild" then
				local startValue = string.find( target.title, "%(" ) + 1
				local endValue = string.len(target.title) - 1
				target.title = string.sub(target.title, startValue, endValue)
				frame.title:SetText(target.title)
			else
				frame.title:SetText(target.title)
			end
		end

        target.name = GetUnitName('reticleover')
        frame.info:SetText("|cFFFFFF"..target.name.."|")

        BWE_HUD.UpdateTargetHealth()
        frame:SetHidden(false)

    end

end

function  BWE_HUD.UpdateTargetHealth()
    local frame = BWE_HUD.targetFrame["BWE_TARGET"]
    local healthValue, healthMax, healthEffMax, shieldValue, shieldMax, temp

    healthValue, healthMax, healthEffMax = GetUnitPower('reticleover', POWERTYPE_HEALTH)

	temp = GetUnitAttributeVisualizerEffectInfo('reticleover', ATTRIBUTE_VISUAL_POWER_SHIELDING, STAT_MITIGATION, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH)
	if shielded == true then
		shieldValue = temp
		frame.shield:SetValue(shieldValue)
	else
		if temp == nil then
		else
			shieldValue, shieldMax = BWE_HUD.ShieldUpdate(temp)			
			frame.shield:SetMinMax(0, shieldMax)
			frame.shield:SetValue(shieldValue)
			frame.shield:SetHidden(false)
		end
	end

    if healthValue <= 0 then frame:SetHidden(true) return end

    local percent = 0
    if maximum ~= 0 then
        percent = (healthValue / healthMax) * 100
        if percent < 10 then
            percent = ZO_LocalizeDecimalNumber(zo_roundToNearest(percent, .1))
        else
            percent = zo_round(percent)
        end
    end

    frame.bar:SetMinMax(0, healthMax)
    frame.bar:SetValue(healthValue)
	frame.gloss:SetMinMax(0, healthMax)
    frame.gloss:SetValue(healthValue)
	
    if shieldValue == 0 or shieldValue == nil then
        frame.shield:SetHidden(true)
		shielded = false
    end
	
    if (healthValue > 1000000) then
        healthValue =  healthValue/1000000
        healthValue = ZO_LocalizeDecimalNumber(zo_roundToNearest(healthValue, .001))
        if shielded == false then
            frame.value:SetText(healthValue.."M ("..percent.."%)")
        else
            frame.value:SetText(healthValue.."M ("..percent.."%)".." ["..shieldValue.."]")
        end
    else
        if shielded == false then
            frame.value:SetText(BWE_HUD.comma_value(healthValue).." ("..percent.."%)")            
        else
			frame.value:SetText(BWE_HUD.comma_value(healthValue).." ("..percent.."%)".." ["..shieldValue.."]")
        end
    end

end

function BWE_HUD.ShieldUpdate(value)

	if shielded == true then return end
	
    if value == nil then
        shieldValue = 0
        shieldMax = 0
	else
		shieldValue = value
		shieldMax = value
		shielded = true
    end
	
	return shieldValue, shieldMax
end

function BWE_HUD.ReinitFrame()
    local frame = BWE_HUD.targetFrame["BWE_TARGET"]
    local iconSize = BWE_HUD

    local textSize = BWE_HUD.SV.target.textSize

    if BWE_HUD.SV.target.custom.enabled == true then
        frame.bar:SetColor(unpack(BWE_HUD.SV.target.custom.frameColor))
        frame.shield:SetColor(unpack(BWE_HUD.SV.target.custom.shieldColor))
    else
        frame.bar:SetColor(unpack(BWE_HUD.SV.target.frameColor))
        frame.shield:SetColor(unpack(BWE_HUD.SV.target.shieldColor))
    end

    iconSize.class = textSize+(4*sf)
    iconSize.champ = textSize-(1*sf)
    iconSize.ava   = textSize+(4*sf)
    iconSize.ally  = textSize+(4*sf)

    frame.value:SetFont("$(BOLD_FONT)|"..textSize.."|soft-shadow-thin")
    frame.info:SetFont("$(BOLD_FONT)|"..textSize.."|soft-shadow-thin")
    frame.title:SetFont("$(BOLD_FONT)|"..textSize.."|soft-shadow-thin")

    frame.barBg:SetAlpha(BWE_HUD.SV.target.opacity.bgAlpha)
    frame.bar:SetAlpha(BWE_HUD.SV.target.opacity.barAlpha)
    frame.shield:SetAlpha(BWE_HUD.SV.target.opacity.barAlpha)
    frame.gloss:SetAlpha(BWE_HUD.SV.target.opacity.glossAlpha)
end

function BWE_HUD.CombatState()
    local frame = BWE_HUD.targetFrame["BWE_TARGET"]
    local combatState = IsUnitInCombat('player')

	if combatState == true then
        frame.bar:SetAlpha(BWE_HUD.SV.target.opacity.icBarAlpha)
        frame.shield:SetAlpha(BWE_HUD.SV.target.opacity.icBarAlpha)
        frame.gloss:SetAlpha(BWE_HUD.SV.target.opacity.icGlossAlpha)
        frame.barBg:SetAlpha(BWE_HUD.SV.target.opacity.icBGAlpha)
	else
		frame.bar:SetAlpha(BWE_HUD.SV.target.opacity.barAlpha)
        frame.shield:SetAlpha(BWE_HUD.SV.target.opacity.barAlpha)
        frame.gloss:SetAlpha(BWE_HUD.SV.target.opacity.glossAlpha)
        frame.barBg:SetAlpha(BWE_HUD.SV.target.opacity.bgAlpha)
	end
end

function BWE_HUD.UnregisterTargetEvents()
    evm:UnregisterForEvent(BWE_HUD.ADDON_NAME, EVENT_RETICLE_TARGET_CHANGED)
    evm:UnregisterForEvent(BWE_HUD.ADDON_NAME, EVENT_DISPOSITION_UPDATE)
    evm:UnregisterForEvent(BWE_HUD.ADDON_NAME, EVENT_COMBAT_EVENT)
    evm:UnregisterForEvent(BWE_HUD.ADDON_NAME, EVENT_PLAYER_COMBAT_STATE)
end

function BWE_HUD.RegisterTargetEvents()
    evm:RegisterForEvent(BWE_HUD.ADDON_NAME, EVENT_RETICLE_TARGET_CHANGED, BWE_HUD.UpdateTargetFrame)
    evm:RegisterForEvent(BWE_HUD.ADDON_NAME, EVENT_DISPOSITION_UPDATE, BWE_HUD.UpdateTargetFrame)
    evm:RegisterForEvent(BWE_HUD.ADDON_NAME, EVENT_COMBAT_EVENT, BWE_HUD.UpdateTargetHealth)
    evm:RegisterForEvent(BWE_HUD.ADDON_NAME, EVENT_PLAYER_COMBAT_STATE, BWE_HUD.CombatState)
end