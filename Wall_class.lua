Wall = Class(Game_object_base)

function Wall:_init(vertices)
	Game_object_base._init(self)
end

function Wall:move()
	return
end

function Wall:draw() 
	return
end

function Wall:resolve_collision(collider)
	return
end