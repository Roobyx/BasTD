-- Assets library
local Assets = {}

	Assets.images = {
		-- Important
		wall = l.ni("assets/wall.png"),
		path = l.ni("assets/path.png"),
		slot = l.ni("assets/slot.png"),
		selection = l.ni("assets/select.png"),
		forbidden = l.ni("assets/forbidden.png"),

		-- Decoration
		---- Vegetation
		bushG = l.ni("assets/bushG.png"),
		bushB = l.ni("assets/bushB.png"),
		treeG = l.ni("assets/treeG.png"),
		treeB = l.ni("assets/treeB.png"),

		---- Others
		barrel = l.ni("assets/barrel.png"),
		crate = l.ni("assets/crate.png"),
		defaultPawn = l.ni("assets/default_pawn.png"),

		---- Charecters
		enemy1 = l.ni("assets/chars/slimeBlock.png"),

		-- Towers
		tower_basic = l.ni("assets/towers/tower_basic.png"),
		tower_medium = l.ni("assets/towers/tower_medium.png"),
		tower_advanced = l.ni("assets/towers/tower_advanced.png"),

		bullet_basic = l.ni("assets/chars/bullet_basic.png"),

		-- UI
		---- Decorations
		-- corner_tl = l.ni("assets/ui/corner_tl_s.png"),
		-- corner_tr = l.ni("assets/ui/corner_tr_s.png"),
		-- corner_bl = l.ni("assets/ui/corner_bl_s.png"),
		-- corner_br = l.ni("assets/ui/corner_br_s.png"),
		bg = l.ni("assets/ui/bg.png"),
		border_h = l.ni("assets/ui/border_h.jpg"),
		
		---- Buttons
		button_tower_basic = l.ni("assets/ui/buttons/button__tower_basic.png"),
		button_tower_medium = l.ni("assets/ui/buttons/button__tower_medium.png"),
		button_tower_advanced = l.ni("assets/ui/buttons/button__tower_advanced.png"),

		-- Screens
		startScreen = l.ni("assets/others/startScreen.png"),
		endScreen = l.ni("assets/others/endScreen.png"),
		emptySelection = l.ni("assets/others/emptySelection.png"),

	}

	Assets.sounds = {

	}

	Assets.music = {
		
	}

return Assets