BWE_HUD = BWE_HUD or {}
-- Default settings.
BWE_HUD.defaults = {
    target = {
        position = {
            offsetX = 500,
            offsetY = 200,
        },
        opacity = {
            barAlpha   = 0.5,
            glossAlpha = 1,
            bgAlpha    = 0.8,
        },
        size = {
            hight = 40,
            width = 300,
        },
        custom = {
            Color = {1, 1, 1},
            enabled = ture
        },        
        color    = ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_HEALTH],
        useACCID = false,
        enable   = true,
    },
    player = {
        position = {
            offsetX = 500,
            offsetY = 200,
        },
        opacity = {
            barAlpha   = 0.5,
            glossAlpha = 1,
            bgAlpha    = 0.8,
        },
        size = {
            hight = 63,
            width = 200,
        },
        custom = {
            healthColor    = {1, 1, 1},
            magickaColor   = {1, 1, 1},
            staminaColor   = {1, 1, 1},
            healthEnabled  = true,
            magickaEnabled = true,
            staminaEnabled = true,
        },
        color = {
            health  = ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_HEALTH],
            magicka = ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_MAGICKA],
            stamina = ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_STAMINA],
        },
        enable = true,
    },
}