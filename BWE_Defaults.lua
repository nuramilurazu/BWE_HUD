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
			icBarAlpha = 1,
			icGlossAlpha = 1,
			icBGAlpha = 0.8,
		},
		size = {
			height = 40,
			width = 300,
		},
		custom = {
			frameColor = {1, 1, 1, 1},
			shieldColor = {1, 1, 1, 1},
			enabled = false,
		},
		frameColor    = {128, 0, 0, 1},   --ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_HEALTH],
		shieldColor   = {0, 0, 205, 1},
		textSize = 12,
		useACCID = false,
		enabled  = false,
		uRColor  = false,
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
			height = 63,
			width = 200,
		},
		custom = {
			healthColor    = {1, 1, 1, 1},
			magickaColor   = {1, 1, 1, 1},
			staminaColor   = {1, 1, 1, 1},
			healthEnabled  = false,
			magickaEnabled = false,
			staminaEnabled = false,
		},
		color = {
			health  = {128, 0, 0, 1},   --ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_HEALTH],
			magicka = {128, 0, 0, 1},   --ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_MAGICKA],
			stamina = {128, 0, 0, 1},   --ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_STAMINA],
		},
		textSize = 12,
		enable = false,
	},
}

local iconSize = BWE_HUD
iconSize.class = 18
iconSize.champ = 10
iconSize.ava   = 18
iconSize.ally  = 18