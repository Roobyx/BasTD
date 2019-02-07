l = require "modules/l"
Assets = require "modules/assets"
Maps = require "maps/maps"
MapTools = require "modules/MapTools"
Settings = require "modules/Settings"
UI = require "modules/UI"
Tower = require "game/tower"
Enemy = require "game/enemy"
FpsGraph = require "modules/vendor/FPSGraph"
ripple = require "modules/vendor/ripple"

-- Logging on/off
local debug = true


-- ---------------------------------------
-- ----------- LOAD
-- ---------------------------------------

function love.load()

	Settings.load()
	-- love.window.maximize()


	
	-- Game settings
	windowWidth  = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()
	
	source = love.audio.newSource( "assets/audio/menu.mp3", "static" )

	-- love.sound.newSoundData('assets/audio/menu.mp3')
	menuMusic = ripple.newSound(source, options)
	
	-- Load the map
	MapTools.loadMap()

	-- Game Charecters:


	
	-- -----------  Load UI elements
	-- ---------------------------------------
	-- Menu
	UI.load()




	-- -----------  TODO:
	-- ---------------------------------------
	--X UI: Tower menu 
	-- Info panel - gold, lives, enemies left
	-- Speed up/down?
	
	selectionState = 0
		
	splashScreen = Assets.images.startScreen
	game_state = 1
	
	print(windowHeight, windowWidth)
	print('Game State: ', game_state)
	menuMusic:play()
	print('A: ', Assets.enemies[1])
	print('WI: ', wave_index)
	print('-----------------------------------------------LOADED------------------------------------------------------')


	-- ---------------------------------------
	-- ---------------------------------------
	-- ---------------------------------------
	-- ---------------------------------------
	-- --------------------------------------- IMAGES TO newQuad - from spritesheet
	-- ---------------------------------------
	-- ---------------------------------------
	-- ---------------------------------------

end

function randomUpdate(graph, dt, n)
	local val = love.math.random()*n

	FpsGraph.updateGraph(graph, val, "Random: " .. math.floor(val*10)/10, dt)
end

function inMapBounds()
	local x, y = love.mouse.getPosition()

	if x > 0 and x < windowWidth and y > 0 and y < 639 then
		return true
	end

	return false
end

function nextGameState()
	game_state = game_state + 1
	menuMusic:stop()

	print('State changed to: ', game_state)
end

-- ---------------------------------------
-- ----------- UPDATE
-- ---------------------------------------

function love.update(dt)
	next_time = next_time + min_dt
	Settings.timer = Settings.timer + dt


	
	if game_state == 2 then
		Enemy.update(dt)

		-- update graphs using the update functions included in fpsGraph
		FpsGraph.updateFPS(testGraph, dt)

		Tower.checkRange(dt)
		
		for i,v in ipairs(bullets) do
			v.x = v.x + (v.dx * dt)
			v.y = v.y + (v.dy * dt)
		end

		-- Upgrade enemies and create next wave dynamically
		if #activeWave < 1 then
			wave_timer_current = wave_timer_current - dt

			if wave_timer_current < 1 then
				wave_index = wave_index + 1
				Enemy.upgradeEnemy()
				enemiesLeft = 30
				wave_timer_current = wave_timer_reset
			end
		end

		-- End the game
		if player_lives == 0 then
		-- if player_lives < 50 then
			splashScreen = Assets.images.endScreen
			game_state = 3
			print('State changed to: ', game_state)
		end
	end
end



-- ---------------------------------------
-- ----------- DRAW
-- ---------------------------------------


function love.draw()
-- -----------  Slow down the framerate for better resource management
-- ---------------------------------------
	local cur_time = love.timer.getTime()
	if next_time <= cur_time then
		next_time = cur_time
		return
	end

	love.timer.sleep(next_time - cur_time)



	if game_state == 2 then
		-- -----------  Draw the map
		-- ---------------------------------------
		MapTools.drawMap()

		-- -----------  Draw the UI
		-- ---------------------------------------
		UI.draw()

		-- -----------  Enemy DRAW
		-- ---------------------------------------
		Enemy.draw()


		-- -----------  Bullets DRAW
		-- ---------------------------------------
		Tower.bulletsDraw()


		-- -----------  Logging
		-- ---------------------------------------

			-- if #towersOnMap > 0 then
			-- 	for i = 1, #towersOnMap, 1 do
			-- 		for a = 1, #towersOnMap[i], 1 do
			-- 			l.d(Assets.images.selection, #towersOnMap[i].neighbours[a].yPos, #towersOnMap[i].neighbours[a].xPos)
			-- 		end
			-- 	end
			-- end

			-- Tower.drawNeighbours()


			if inMapBounds() then
				local currentTileX, currentTileY = MapTools.getTile(love.mouse.getPosition())
				local tile = map[currentTileY][currentTileX]

				if selectionState == 1 then
					l.d(currentTower.image, tile.yPos, tile.xPos)

					if tile.canBuild == false then
						l.d(Assets.images.forbidden, tile.yPos, tile.xPos)
					end
				end

				-- if debug then
				-- 	l.p('X: ' .. tile.mx .. ', Y: '.. tile.my, 10, 10)
				-- 	l.p('Type: ' ..tile.type, 150, 10)
				-- 	l.p('hasTower: ' ..string.format("%s", tile.hasTower), 10, 25)
				-- 	l.p('canBuild: ' ..string.format("%s", tile.canBuild), 10, 40)
				-- end
			end


			if debug then
				-- l.p('Enemies left: ' .. 30 - #wave, 700, 10)
				-- l.p('TestChar pt: ' .. testChar.prevTile.my .. ', ' .. testChar.prevTile.mx, 200, 730)
				-- l.p('TestChar ct: ' .. testChar.currentTile.my .. ', ' .. testChar.currentTile.mx, 200, 760)

				-- l.p(testChar.prevTile, 200, 700)
				-- l.p(map[1][1], 200, 700)
			end

			-- draw the graphs
			FpsGraph.drawGraphs({testGraph})
		else
			l.d(splashScreen, -0, -0)
		end
end



--Escape option
function love.keyreleased(key)
	if key == "/" then
		love.event.quit()
	end
end