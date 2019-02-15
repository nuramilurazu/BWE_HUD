-- Settings menu.
BWE_HUD = BWE_HUD or {}

local LAM2 = LibStub("LibAddonMenu-2.0")

function BWE_HUD.LoadSettings()

        local panelData = {
                type = "panel",
                name = BWE_HUD.menuName,
                displayName = BWE_HUD.Colorize(BWE_HUD.menuName),
                author = BWE_HUD.Colorize(BWE_HUD.author, "AAF0BB"),
                registerForRefresh = true,
                registerForDefaults = true,
        }
        local ctrlOptionsPanel = LAM2:RegisterAddonPanel(BWE_HUD.menuName, panelData)

        local optionsTable = {}
    
    -- Category. --
        table.insert(optionsTable, {
            type = "header",
            name = ZO_HIGHLIGHT_TEXT:Colorize("My Header"),
            width = "full",	--or "half" (optional)
        })
	
	table.insert(optionsTable, {
            type = "description",
            --title = "My Title",	--(optional)
            title = nil,	--(optional)
            text = "My description text to display.",
            width = "full",	--or "half" (optional)
        })
    
        table.insert(optionsTable, {
            type = "dropdown",
            name = "My Dropdown",
            tooltip = "Dropdown's tooltip text.",
            choices = {"table", "of", "choices"},
            getFunc = function() return "of" end,
            setFunc = function(var) print(var) end,
            width = "half",	--or "half" (optional)
            warning = "Will need to reload the UI.",	--(optional)
        })
    
        table.insert(optionsTable, {
            type = "dropdown",
            name = "My Dropdown",
            tooltip = "Dropdown's tooltip text.",
            choices = {"table", "of", "choices"},
            getFunc = function() return "of" end,
            setFunc = function(var) print(var) end,
            width = "half",	--or "half" (optional)
            warning = "Will need to reload the UI.",	--(optional)
        })
    
        table.insert(optionsTable, {
            type = "slider",
            name = "My Slider",
            tooltip = "Slider's tooltip text.",
            min = 0,
            max = 20,
            step = 1,	--(optional)
            getFunc = function() return 3 end,
            setFunc = function(value) d(value) end,
            width = "half",	--or "half" (optional)
            default = 5,	--(optional)
        })
    
        table.insert(optionsTable, {
            type = "button",
            name = "My Button",
            tooltip = "Button's tooltip text.",
            func = function() d("button pressed!") end,
            width = "half",	--or "half" (optional)
            warning = "Will need to reload the UI.",	--(optional)
        })
    
        table.insert(optionsTable, {
            type = "submenu",
            name = "Target Frame",
            controls = {
                [1] = {
                    type = "checkbox",
                    name = "Perfer User ID over Character Name",
                    tooltip = "Use @Example instead",
                    default = BWE_HUD.savedVariables.target.useACCID,
                    getFunc = function() return default end,
                    setFunc = function(newValue) BWE_HUD.savedVariables.table.useACCID = newValue end,
                },
                [2] = {
                    type = "colorpicker",
                    name = "Target Frame Color",
                    tooltip = "Color Picker's tooltip text.",
                    getFunc = function() return 1, 0, 0 end,
                    setFunc = function(r,g,b,a) print(r, g, b) end,
                },
                [3] = {
                    type = "slider",
                    name = "Target Frame Alpha",
                    min = 10,
                    max = 100,
                    step = 5,
                    default = BWE_HUD.savedVariables.alpha,
                    getFunc = function() return zo_round(BWE_HUD.savedVariables.target.opacity.barAlpha*100) end,
                    setFunc = function(newValue) 
                        BWE_HUD.savedVariables.target.opacity.barAlpha = zo_roundToNearest((newValue/100), .01),
                        BWE_HUD.UpdateTargetFrame()
                    end,
                },
            },
        })
    
    LAM2:RegisterOptionControls(BWE_HUD.menuName, optionsTable)
end