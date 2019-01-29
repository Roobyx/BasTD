-- Module to shorten the most used LOVE functions to speed up writing
local l = {}

l = {
	g = love.graphics,
	d = love.graphics.draw,
	ni = love.graphics.newImage,
	p = love.graphics.print
}

return l