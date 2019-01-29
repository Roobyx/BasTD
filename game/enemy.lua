Assets = require "modules/assets"
MapTools = require "modules/MapTools"
Settings = require "modules/Settings"
l = require "modules/l"

local defaultImg = Assets.images.enemy1
spawnTimer = 0
enemiesLeft = 30
counter  = 0


-- Pawns (enemies)
enemy = {
	state = 1,
	name = 'Enemy',
	img = defaultImg,
	xPos = 65,
	yPos = 129,
	prevTile = {},
	currentTile = {},
	speed = 4,
	hp = 1000,
	mana = 100,
	rechargeTimer = 2,
	onMap = false,
	reward = 100
}

activeWave = {}

function enemy:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end


function enemy.update(dt)
	enemy.spawn(dt)
	
	for i,pawn in ipairs(activeWave) do
		local prevTile, nextTile = MapTools.getNextCell(map, pawn.prevTile, pawn.currentTile)

		if prevTile.isLast then
			table.remove(activeWave, i)
			player_lives = player_lives - 1
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
			l.d(enemy.img , enemy.yPos, enemy.xPos)
		end
	end
end

function enemy.spawn(dt)
	spawnTimer = spawnTimer - dt

	if spawnTimer <= 0 then
		local enemy = Enemy:new()

		enemy.prevTile = map[3][2]
		enemy.currentTile = map[3][3]

		enemy.name = 'Enemy' .. counter
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

return enemy