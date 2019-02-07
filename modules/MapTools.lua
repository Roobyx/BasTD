-- Module to build and manipulate maps from tables

Assets = require "modules/assets"
Settings = require "modules/Settings"
Helpers = require "modules/helpers"

local MapTools = {}

-- Convert the map table to a usable tile objects with data
function MapTools.prapare(input_map)
	-- Tile = {
	-- 	1:type,
	-- 	2:canBuild,
	-- 	3:hasTower,
	-- 	4:x,
	-- 	5:y,
	--  6:my,
	--  7:mx,
	-- 	6:image,
	--	7:tileX,
	--	8:tileY,
	--  9: id
	-- }

	local temp = {}
	local x = 1
	local y = 1
	local tileId = 0

	-- Helpers.logArray( input_map )

	for tableY = 1, #input_map, 1 do
		temp[tableY] = {}

		for tableX = 1, #input_map[tableY], 1 do
			temp[tableY][tableX] = {}

			if input_map[tableY][tableX] == 0 then
				temp[tableY][tableX] = {
					type='wall', canBuild=false,
					hasTower=false,
					tower = '',
					xPos=x,
					yPos=y,
					my = tableY,
					mx = tableX,
					id = tileId,
					image=Assets.images.wall,
					isStart = false,
					isNextToLast = false
				}
			elseif input_map[tableY][tableX] == 1 then
				temp[tableY][tableX] = {
					type='slot',
					canBuild=true,
					hasTower=false,
					tower = '',
					xPos=x,
					yPos=y,
					my = tableY,
					mx = tableX,
					id = tileId,
					image=Assets.images.slot,
					isStart = false,
					isNextToLast = false
				}
			elseif input_map[tableY][tableX] == 2 then
				temp[tableY][tableX] = {
					type='path',
					canBuild=false,
					hasTower=false,
					tower = '',
					xPos=x,
					yPos=y,
					my = tableY,
					mx = tableX,
					id = tileId,
					image=Assets.images.path,
					isStart = false,
					isNextToLast = false
				}


			elseif input_map[tableY][tableX] == 3 then
				temp[tableY][tableX] = {
					type='path',
					canBuild=false,
					hasTower=false,
					yPos=y,
					tower = '',
					xPos=x,
					my = tableY,
					mx = tableX,
					id = tileId,
					image=Assets.images.path,
					isStart = true,
					isNextToLast = false
				}


			elseif input_map[tableY][tableX] == 4 then
				temp[tableY][tableX] = {
					type='path',
					canBuild=false,
					hasTower=false,
					tower = '',
					xPos=x,
					yPos=y,
					my = tableY,
					mx = tableX,
					id = tileId,
					image=Assets.images.path,
					isStart = false,
					isLast = true
				}
		end

			y = y + Settings.tileSize
			tileId = tileId + 1
		end
		y = 1
		x = x + Settings.tileSize
	end

	return temp
end

-- Find out witch tile is the mouse pointing to
-- Get mouse position and return the coresponding tile
function MapTools.getTile(x,y)
	local mX = math.ceil(x/Settings.tileSize)
	local mY = math.floor(y/Settings.tileSize)+1

	return mX, mY
end

-- function MapTools.getPos(tile)
-- 	local mX = math.ceil(tile.X * Settings.tileSize)
-- 	local mY = math.floor(tile[2] * Settings.tileSize)+1

-- 	return mX, mY
-- end

-- For now the function would work correctly with a map in which each tile has only one possible neighbour
function MapTools.getNextCell(map, pc, cc)
	-- look at flood-fill
	local nextCell = cc
	local direction = 0

	if nextCell.my <= 10 and nextCell.my > 0 and nextCell.mx <= 15 and nextCell.mx > 0 then

		if pc == nil then
			if map[cc.my-1][cc.mx].type == 'path' then
				direction = 270
				nextCell = map[cc.my-1][cc.mx]
			elseif map[cc.my+1][cc.mx].type == 'path' then
				direction = 90
				nextCell = map[cc.my+1][cc.mx]
			elseif map[cc.my][cc.mx-1].type == 'path' then
				direction = 180
				nextCell = map[cc.my][cc.mx-1]
			elseif map[cc.my][cc.mx+1].type == 'path' then
				nextCell = map[cc.my][cc.mx+1]
			end
		else
			-- up
			if map[cc.my-1][cc.mx] ~= nil and map[cc.my-1][cc.mx].type == 'path' and map[cc.my-1][cc.mx].id ~= pc.id then
				nextCell = map[cc.my-1][cc.mx]
				direction = 270
			-- Down
			elseif map[cc.my+1][cc.mx] ~= nil and map[cc.my+1][cc.mx].type == 'path' and map[cc.my+1][cc.mx].id ~= pc.id then
				nextCell = map[cc.my+1][cc.mx]
				direction = 90
			-- Left
			elseif map[cc.my][cc.mx-1] ~= nil and map[cc.my][cc.mx-1].type == 'path' and map[cc.my][cc.mx-1].id ~= pc.id then
				nextCell = map[cc.my][cc.mx-1]
				direction = 180
			-- Right
			elseif map[cc.my][cc.mx+1] ~= nil and map[cc.my][cc.mx+1].type == 'path' and map[cc.my][cc.mx+1].id ~= pc.id then
				nextCell = map[cc.my][cc.mx+1]
				direction = 0
			end
		end

	end
	
	return cc, nextCell, direction
end

function MapTools.loadMap()
	map = MapTools.prapare(Maps.mainMap.map)
	mapStart = map[3][2]
end

function MapTools.drawMap()
	for y = 1, #map, 1 do
		for x = 1, #map[1], 1 do
			l.d(map[y][x].image, map[y][x].yPos, map[y][x].xPos)
			
			if map[y][x].hasTower then
				l.d(map[y][x].tower.image, map[y][x].yPos, map[y][x].xPos)
			end
			-- if(debug) then
			-- 	l.p('y: '..y, map[y][x].yPos, map[y][x].xPos)
			-- 	l.p('x: '..x, map[y][x].yPos, map[y][x].xPos+14)
			-- 	-- love.graphics.setColor(1, 0, 0)
			-- 	-- l.p('id: ' .. map[y][x].id, map[y][x].yPos, map[y][x].xPos + 40)
			-- 	love.graphics.setColor(1, 1, 1)
			-- end
		end
		-- End draw the map
	end
end

return MapTools