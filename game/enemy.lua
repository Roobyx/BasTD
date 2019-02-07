Assets = require "modules/assets"
MapTools = require "modules/MapTools"
Settings = require "modules/Settings"
l = require "modules/l"

-- local defaultImg = Assets.images.enemy_lvl_1


counter  = 0


-- Pawns (enemies)
enemy = {
	state = 1,
	name = 'Enemy',
	img = Assets.enemies[1],
	xPos = 65,
	yPos = 129,
	prevTile = {},
	currentTile = {},
	speed = 4,
	hp = 500,
	mana = 100,
	rechargeTimer = 2,
	onMap = false,
	direction = 0,
	xOffset = 0,
	yOffset = 0
}


function enemy:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end


function enemy.update(dt)
	enemy.spawn(dt)
	
	for i,pawn in ipairs(activeWave) do
		local prevTile, nextTile, e_direction = MapTools.getNextCell(map, pawn.prevTile, pawn.currentTile)

		if prevTile.isLast then
			table.remove(activeWave, i)
			player_lives = player_lives - 1
		end
		
		pawn.direction = math.rad(e_direction)

		if e_direction == 180 then
			pawn.xOffset = 64
			pawn.yOffset = 64
		elseif e_direction == 270 then
			pawn.xOffset = 0
			pawn.yOffset = 0
		elseif e_direction == 90 then
			pawn.xOffset = 64 
			pawn.yOffset = 64
		else
			pawn.xOffset = 0
			pawn.yOffset = 0
		end
		
		if pawn.xPos > nextTile.xPos then
			if nextTile.xPos > pawn.xPos - pawn.speed then
				pawn.xPos = nextTile.xPos
			else
				pawn.xPos = pawn.xPos - pawn.speed
			end
		elseif pawn.xPos < nextTile.xPos then
			if nextTile.xPos < pawn.xPos + pawn.speed then
				pawn.xPos = nextTile.xPos
			else
				pawn.xPos = pawn.xPos + pawn.speed
			end
		elseif pawn.yPos > nextTile.yPos then
			if nextTile.yPos > pawn.yPos - pawn.speed then
				pawn.yPos = nextTile.yPos
			else
				pawn.yPos = pawn.yPos - pawn.speed
			end
		elseif pawn.yPos < nextTile.yPos then
			if nextTile.yPos < pawn.yPos + pawn.speed then
				pawn.yPos = nextTile.yPos
			else
				pawn.yPos = pawn.yPos + pawn.speed
			end
		elseif pawn.xPos == nextTile.xPos and pawn.yPos == nextTile.yPos then
			pawn.prevTile = prevTile
			pawn.currentTile = nextTile
		end

	end
end

function enemy.draw()
	for i,enemy in ipairs(activeWave) do
		if enemy.onMap then
			-- if enemy.direction == math.pi or 0 then
				-- l.d(enemy.img, enemy.yPos, enemy.xPos, enemy.direction, 1, 1)
				l.d(enemy.img, enemy.yPos, enemy.xPos, enemy.direction, 1, 1, enemy.xOffset, enemy.yOffset)
			-- else
			-- 	l.d(enemy.img, enemy.yPos, enemy.xPos, enemy.direction, 1, 1, 64, 64)
			-- end
		end
	end
end

function enemy.spawn(dt)
	spawnTimer = spawnTimer - dt

	if spawnTimer <= 0 then
		local enemy = Enemy:new()

		enemy.prevTile = map[3][2]
		enemy.currentTile = map[3][3]

		enemy.name = enemy.name .. ' ' .. counter
		enemy.onMap = true

		if enemiesLeft > 0 then
			table.insert(activeWave, enemy)
			enemiesLeft = enemiesLeft - 1
		end
		counter = counter + 1
		spawnTimer = 1
	end
end

function enemy.calculateReward(target)
	return ((target.hp * target.speed)/2) * -1
end

function enemy.upgradeEnemy()
	enemy.name = 'Enemy' .. ' ' .. wave_index
	enemy.img = Assets.enemies[wave_index]

	enemy.speed = enemy.speed + 0.5
	enemy.hp = enemy.hp + 50
	enemy.mana = enemy.mana + 100

	print('Enemy upgraded')
end

return enemy