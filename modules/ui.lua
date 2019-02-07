-- Global Game Settings
Assets = require "modules/assets"

local UI = {}

button = {
	xPos = -10,
	yPos = -10
}

function UI.load()
	Assets.images.bg:setWrap("repeat", "repeat")
	Assets.images.border_h:setWrap("repeat", "repeat")

	bg_quad = love.graphics.newQuad(0, 0, windowWidth, 160, Assets.images.bg:getWidth(), Assets.images.bg:getHeight())
	border_top_quad = love.graphics.newQuad(0, 0, windowWidth, 18, Assets.images.border_h:getWidth(), Assets.images.border_h:getHeight())
	border_bottom_quad = love.graphics.newQuad(0, 0, windowWidth, 18, Assets.images.border_h:getWidth(), Assets.images.border_h:getHeight())
	
end

function UI.draw()
		-- UI dimentions:
		-- Map Height (y): 10*64 = 640
		-- Menu height: 3*64 = 192
		
		-- Screen Width (x): 15*64 = 960

		-- Menu Row1: x: 640 - 704
		-- Menu Row2: x: 704 - 768
		-- Menu Row3: x: 768 - 832

		-- Corners
		love.graphics.draw(Assets.images.bg, bg_quad, 0, windowHeight-160)

		love.graphics.draw(Assets.images.border_h, border_top_quad, 0, windowHeight-160)
		love.graphics.draw(Assets.images.border_h, border_bottom_quad, 0, windowHeight-18)
	
		-- l.d(Assets.images.corner_br, windowWidth-66, windowHeight-65)
		-- l.d(Assets.images.corner_bl, 0, windowHeight-65)
		-- l.d(Assets.images.corner_tr, windowWidth-66, windowHeight-160)
		-- l.d(Assets.images.corner_tl, 0,  windowHeight-160)

		-- Controls
		l.d(Assets.images.button_tower_basic , 32, 662)
		l.d(Assets.images.button_tower_medium , 152, 662)
		l.d(Assets.images.button_tower_advanced , 272, 662)

		-- Info
		l.p(player_score, 900, 690)
		l.d(Assets.images.score, 870, 690)

		l.p(player_lives, 900, 720)
		l.d(Assets.images.heart, 870, 720)


		l.p(player_gold, 900, 750)
		l.d(Assets.images.coin, 870, 747)

		l.p('Wave #: ' .. wave_index, 630, 720)

		l.d(Assets.images.flag, 600, 690)
		if wave_timer_current > 0 then
			l.p('Next wave in: ' .. math.floor(wave_timer_current+0.5), 630, 690)
		else
			l.p('Next wave in: Wave is still active', 630, 690)
		end

end

return UI