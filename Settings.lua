-- Settings menu.
BWE_HUD = BWE_HUD or {}

local LAM2 = LibStub("LibAddonMenu-2.0")

function BWE_HUD.CreateSettings()

        local panelData = {
                type = "panel",
                name = BWE_HUD.menuName,
                displayName = BWE_HUD.menuName,
                author = BWE_HUD.author,
                registerForRefresh = true,
                registerForDefaults = true,
        }
        
        LAM2:RegisterAddonPanel(BWE_HUD.menuName, panelData)

        local optionsTable = {}
    
    -- Category. --
        table.insert(optionsTable, {
            type = "header",
            name = ZO_HIGHLIGHT_TEXT:Colorize("Target Frame Settings"),
        })
    
        table.insert(optionsTable, {
                type = "checkbox",
                name = "Use Target Frame",
                default = BWE_HUD.SV.target.enabled,
                getFunc = function() return BWE_HUD.SV.target.enabled end,
                setFunc = function(newValue) BWE_HUD.SV.target.enabled = newValue end,
        })
    
        table.insert(optionsTable, {
            type = "submenu",
            name = "Target Frame",
            disabled = not BWE_HUD.SV.target.enabled,
            controls = {
                [1] = {
                    type = "checkbox",
                    name = "Unlock Frame",
                    default = BWE_HUD.targetUnlock,
                    getFunc = function() return BWE_HUD.targetUnlock end,
                    setFunc = function(newValue) BWE_HUD.targetUnlocker(newValue) end,					
                },
                [2] = {
                    type = "checkbox",
                    name = "Perfer User ID over Character Name",
                    tooltip = "Use @Example instead",
                    default = BWE_HUD.defaults.target.useACCID,
                    getFunc = function() return BWE_HUD.SV.target.useACCID end,
                    setFunc = function(newValue) BWE_HUD.SV.target.useACCID = newValue end,
                },
                [3] = {
                    type = "colorpicker",
                    name = "Target Frame Color",
                    default = function() return unpack(BWE_HUD.SV.target.custom.color) end,
                    getFunc = function() return unpack(BWE_HUD.SV.target.custom.color) end,
                    setFunc = function(r, g, b, a) BWE_HUD.SV.target.custom.color = {r, g, b, a} end,
                },
                [4] = {
                    type = "slider",
                    name = "Target Frame Opacity",
                    min = 10,
                    max = 100,
                    step = 5,
                    default = BWE_HUD.defaults.target.opacity.barAlpha,
                    getFunc = function() return zo_round(BWE_HUD.defaults.target.opacity.barAlpha*100) end,
                    setFunc = function(newValue) 
                        BWE_HUD.savedVariables.target.opacity.barAlpha = zo_roundToNearest((newValue/100), .01),
                        BWE_HUD.UpdateTargetFrameAlpha()
                    end,
                },
                [5] = {
                    type = "slider",
                    name = "Background Opacity",
                    min = 0,
                    max = 100,
                    step = 5,
                    default = BWE_HUD.defaults.target.opacity.bgAlpha,
                    getFunc = function() return zo_round(BWE_HUD.defaults.target.opacity.bgAlpha*100) end,
                    setFunc = function(newValue) 
                        BWE_HUD.savedVariables.target.opacity.bgAlpha = zo_roundToNearest((newValue/100), .01),
                        BWE_HUD.UpdateTargetFrameAlpha()
                    end,
                },
                [6] = {
                    type = "slider",
                    name = "Gloss Opacity",
                    min = 0,
                    max = 100,
                    step = 5,
                    default = BWE_HUD.defaults.target.opacity.glossAlpha,
                    getFunc = function() return zo_round(BWE_HUD.defaults.target.opacity.glossAlpha*100) end,
                    setFunc = function(newValue) 
                        BWE_HUD.savedVariables.target.opacity.glossAlpha = zo_roundToNearest((newValue/100), .01),
                        BWE_HUD.UpdateTargetFrameAlpha()
                    end,
                },
            },
        })
    
    LAM2:RegisterOptionControls(BWE_HUD.menuName, optionsTable)
end