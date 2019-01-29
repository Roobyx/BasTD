-- Various helpful functions

local Helpers = {}

function Helpers.logArray( array )
	local str = ''
	for r = 1, #array do
		for c = 1, #array[r] do
			str = str .. ' ' .. array[r][c]
		end
		str = str .. '\n'
	end
	print( str )
end

return Helpers