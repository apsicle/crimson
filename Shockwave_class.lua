Shockwave = {}

function Shockwave.new(x, y)
	shockwave = {}
	setmetatable(shockwave, {__index = Shockwave})

	shockwave.x = x
	shockwave.y = y
end

function Shockwave:go()
	print("success!")
	return
end