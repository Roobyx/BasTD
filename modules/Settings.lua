-- Global Game Settings
local Settings = {}

	Settings = {
		-- Window
		defaultWidth = 960,
		defaultHeight = 800,
		
		-- Game
		tileSize = 64,

		timer = 2,
		delay = 0.25,
	}

function Settings.load()
	-- Synteticly lower the fps
	min_dt = 1/30 --fps
	next_time = love.timer.getTime()
	-- fps graph
	testGraph = FpsGraph.createGraph(850, 650)

	---- Window manipulation on load
	love.window.setMode(
		Settings.defaultWidth,
		Settings.defaultHeight,
		{resizable=false,
		vsync=false,
		minwidth=Settings.defaultWidth,
		minheight=Settings.defaultHeight
	})

	
	player_lives = 50
	player_gold = 0
	player_score = 0
end

return Settings