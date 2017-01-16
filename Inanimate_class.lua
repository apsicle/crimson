Inanimate = {}

function Inanimate.new(vertices)
	inanimate = {}
	setmetatable(inanimate, {__index = Inanimate})

	inanimate.vertices = vertices

end

function Inanimate:move()
	return
end

function Inanimate:draw() 
	love.graphics.polygon("fill", self.vertices)
end

function Inanimate:resolve_collision(collider)
	return
end