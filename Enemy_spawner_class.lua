Enemy_spawner = {}

function Enemy_spawner.new(x, y, N, speed, radius, collision_group)
	enemy_spawner = {}
	setmetatable(enemy_spawner, {__index = Enemy_spawner})
	enemy_spawner.color = {255,255,255,1}
	enemy_spawner.x = x
	enemy_spawner.y = y
	enemy_spawner.N = N
	enemy_spawner.speed = speed
	enemy_spawner.radius = radius
	enemy_spawner.counter = 1
	enemy_spawner.collision_group = 2
	enemy_spawner.hp = 5
	enemy_spawner.sprite = Polygon.new(x, y, N, radius)

	enemy_spawner.global_index = add_object(global_obj_array, global_obj_pointer, enemy_spawner)
	return enemy_spawner
end

function Enemy_spawner:update()
	if self.hp <= 0 then
		global_obj_array[self.global_index] = nil
	end
	love.graphics.print(self.hp, global_width / 2, 150)
end

function Enemy_spawner:move()
	if self.counter % 360 == 0 then
		Enemy.new(self.x, self.y, 3, 2, 16, 2)
	end

	self.sprite:move(self.x, self.y)
	self.counter = self.counter + 1
end

function Enemy_spawner:draw()
	--love.graphics.setColor(self.color)
	self.sprite:draw()
end

function Enemy_spawner:resolve_collision(collider)
	self.hp = self.hp - 1

end

