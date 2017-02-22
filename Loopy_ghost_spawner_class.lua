Loopy_ghost_spawner = {}

function Loopy_ghost_spawner.new(x, y, speed, radius, color, collision_group)
	loopy_ghost_spawner = {}
	setmetatable(loopy_ghost_spawner, {__index = Loopy_ghost_spawner})
	loopy_ghost_spawner.color = color
	loopy_ghost_spawner.x = x
	loopy_ghost_spawner.y = y
	loopy_ghost_spawner.speed = speed
	loopy_ghost_spawner.radius = radius
	loopy_ghost_spawner.counter = 180
	loopy_ghost_spawner.damage = 0
	--loopy_ghost_spawner.status = Status_table.new(loopy_ghost_spawner)
	loopy_ghost_spawner.collision_group = collision_group
	loopy_ghost_spawner.hp = 10
	loopy_ghost_spawner.z_index = 3
	--loopy_ghost_spawner.sprite = Polygon.new(x, y, N, radius)
	loopy_ghost_spawner.sprite = love.graphics.newImage('sprites/loopy_ghost_grave.png')

	loopy_ghost_spawner.global_index = add_object(global_obj_array, global_obj_pointer, loopy_ghost_spawner)
	return loopy_ghost_spawner
end

function Loopy_ghost_spawner:update()
	if self.hp <= 0 then
		global_obj_array[self.global_index] = nil
	end
end

function Loopy_ghost_spawner:move()
	if self.counter % 360 == 0 then
		Loopy_ghost.new(self.x, self.y, 1, 16, self.color, 0.5, 2)
	end

	--self.sprite:move(self.x, self.y)
	self.counter = self.counter + 1
end

function Loopy_ghost_spawner:draw()
	--love.graphics.setColor(self.color)
	--self.sprite:draw()
	love.graphics.setColor(global_palette[1])
	love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1, self.sprite:getHeight() * 0.5, self.sprite:getHeight() * 0.5)
end

function Loopy_ghost_spawner:resolve_collision(collider)
	self.hp = self.hp - 1
end

