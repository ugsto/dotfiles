vim.cmd.colorscheme("catppuccin-macchiato")

local colors = require("catppuccin.palettes").get_palette("macchiato")
local highlight_groups = {
	{ "CatppuccinRosewater", colors.rosewater },
	{ "CatppuccinFlamingo", colors.flamingo },
	{ "CatppuccinPink", colors.pink },
	{ "CatppuccinMauve", colors.mauve },
	{ "CatppuccinRed", colors.red },
	{ "CatppuccinMaroon", colors.maroon },
	{ "CatppuccinPeach", colors.peach },
	{ "CatppuccinYellow", colors.yellow },
	{ "CatppuccinGreen", colors.green },
	{ "CatppuccinTeal", colors.teal },
	{ "CatppuccinSky", colors.sky },
	{ "CatppuccinSapphire", colors.sapphire },
	{ "CatppuccinBlue", colors.blue },
	{ "CatppuccinLavender", colors.lavender },
	{ "CatppuccinText", colors.text },
	{ "CatppuccinSubtext1", colors.subtext1 },
	{ "CatppuccinSubtext0", colors.subtext0 },
	{ "CatppuccinOverlay2", colors.overlay2 },
	{ "CatppuccinOverlay1", colors.overlay1 },
	{ "CatppuccinOverlay0", colors.overlay0 },
	{ "CatppuccinSurface2", colors.surface2 },
	{ "CatppuccinSurface1", colors.surface1 },
	{ "CatppuccinSurface0", colors.surface0 },
	{ "CatppuccinBase", colors.base },
	{ "CatppuccinMantle", colors.mantle },
	{ "CatppuccinCrust", colors.crust },
}

for _, group in ipairs(highlight_groups) do
	vim.api.nvim_set_hl(0, group[1], { fg = group[2] })
end
