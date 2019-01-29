Assets = require "modules/assets"
MapTools = require "modules/MapTools"
Settings = require "modules/Settings"
l = require "modules/l"

-- Tower model
tower = {
	state = 1,
	type = 'basic',
	img = Assets.images.tower_basic,
	xPos = 0,
	yPos = 0,
	tile = '',
	range = 1,
	dmg = 10,
	cost = 1000,
	onMap = false,
	neighbours = {},
	reloadDelay = 0.5,
	enemyQue = 2
}

function tower:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end


bulletSpeed = 1000
bullets = {}
startX = 0
startY = 0


-- Temp delay fix
defaultDelays = {0.1, 0.5}


currentTower = {}
towersOnMap = {}

function createTower(type, image, dmg, range, delay, cost)
	local temp = tower:new()
	temp.type = type
	temp.image = image
	temp.dmg = dmg
	temp.range = range
	temp.reloadDelay = delay
	temp.cost = cost

	return temp
end

--X Create list of neighbours
--X Check all enemies against all neighbours until you find one
--X Shoot at it
--X repeat

function tower.drawNeighbours()
	for i = 1, #towersOnMap, 1 do
		for a = 1, #towersOnMap[i].neighbours, 1 do
			print(towersOnMap[i].neighbours[a][1], towersOnMap[i].neighbours[a][2])
			-- l.d(Assets.images.selection, map[towersOnMap[i].neighbours[a][1]][towersOnMap[i].neighbours[a][1]].xPos, map[towersOnMap[i].neighbours[a][1]][towersOnMap[i].neighbours[a][2]].yPos)
		end
		print('----------------!-------------------')
	end
end

function tower.getNeighbours()
	local xStart = towersOnMap[#towersOnMap].tile.mx-1
	local yStart = towersOnMap[#towersOnMap].tile.my-1
	local tempNs = {}

	-- go 1 column to the left and move 2 columns to the right
	for x = xStart, xStart+2, 1 do
		for y = yStart, yStart+2, 1 do
			-- print('Adding: ', x, y)
			table.insert(tempNs, {y, x})
		end
	end

	currentTower = {}

	towersOnMap[#towersOnMap].neighbours = tempNs
	print('Ns count: ', #towersOnMap[#towersOnMap].neighbours)
end


function tower.checkRange(dt)
	-- Each enemy
	for i, pawn in ipairs(activeWave) do
		-- Checks each tower's
		for b = 1, #towersOnMap, 1 do
			-- Each neighbour
			for a = 1, #towersOnMap[b].neighbours, 1 do
				local cEnemy = activeWave[i]
				local cTower = towersOnMap[b]

				cTower.reloadDelay = cTower.reloadDelay - dt
				if cTower.reloadDelay <= 0 then
					if #activeWave > 0 then
						
						-- if cTower.enemyQue > 0 then
							-- cTower.enemyQue = cTower.enemyQue - 1

							if cEnemy.currentTile.my == cTower.neighbours[a][1] and cEnemy.currentTile.mx == cTower.neighbours[a][2] then
								-- $Shooting
								-- The tower shoots the enemy and removes hp equal to the its dmg
								
								cEnemy.hp = cEnemy.hp - cTower.dmg


								-- Bullets
								startX = cTower.xPos + 32
								startY = cTower.yPos + 32
								
								local targetX = cEnemy.xPos
								local targetY = cEnemy.yPos
						
								local angle = math.atan2((targetY - startY), (targetX - startX))
						
								local bulletDx = bulletSpeed * math.cos(angle)
								local bulletDy = bulletSpeed * math.sin(angle)
								table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})

								if cEnemy.currentTile.my == bulletDy and cEnemy.currentTile.mx == bulletDx then
									table.remove(bullets, #bullets)
								end


								-- Remove enemy
								if cEnemy.hp < 0 then
									table.remove(activeWave, i)
									player_gold = player_gold + 100
									player_score = player_score + Enemy.calculateReward(cEnemy)
								end
								-- cTower.enemyQue = cTower.enemyQue + 1

							end
						-- end

						-- Temp fix for tower shooting delay
						if cTower.type == 'basic' or cTower.type == 'medium' then
							cTower.reloadDelay = defaultDelays[1]
						else
							cTower.reloadDelay = defaultDelays[2]
						end
					end
				end
			end
		end
	end
end

function tower.bulletsDraw()
	for i,v in ipairs(bullets) do
		l.d(Assets.images.bullet_basic, v.y, v.x)
	
		-- love.graphics.circle("fill", v.y, v.x, 3)
	end
end


function tower.selectTower(x, y)
	if x < 132 then
		-- print('Basic tower selected')
		return createTower('basic', Assets.images.tower_basic, 10, 1, 1, 1000)
	elseif x > 162 and x < 262 then
		-- print('Medium tower selected')
		return createTower('medium', Assets.images.tower_medium, 50, 2, 1, 5000)
	elseif x > 282 then
		-- print('Advanced tower selected')
		return createTower('advanced', Assets.images.tower_advanced, 1000, 1, 5, 10000)
	end
end


function tower.placeTower(tempTower)
	local currentTileX, currentTileY = MapTools.getTile(love.mouse.getPosition())
	local currentTile = map[currentTileY][currentTileX]

	if currentTile.canBuild and currentTile.hasTower == false then
		currentTile.hasTower = true
		

		table.insert(towersOnMap, tempTower)

		-- Does not seem right to cross assign like that
		currentTile.tower = tempTower -- In order to draw it easily
		towersOnMap[#towersOnMap].tile = currentTile -- For neighbour calculations and enemy checks
		towersOnMap[#towersOnMap].xPos = currentTile.xPos
		towersOnMap[#towersOnMap].yPos = currentTile.yPos

		tower.getNeighbours()
	end
end


function love.mousepressed(x, y, button)
	if game_state == 2 then
		-- Check if currently clicking in the tower menu and select a tower
		if button == 1 and y > 662 and y < 775 and x > 32 and x < 372 then
			currentTower = Tower.selectTower(x, y)
			-- selectedTower = Tower.selectTower(x, y)
			selectionState = 1
		
		-- Or if outside the menu and click place the tower
		elseif button == 1 and inMapBounds() then
			if selectionState == 1 then
				Tower.placeTower(currentTower)
				selectionState = 0
			end
		elseif button == 2 then
			selectionState = 0
		end
	else
		if button == 1 then
			nextGameState()
		end
	end
end

return tower