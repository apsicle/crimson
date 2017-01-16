Enemy = {}

function Enemy.new(x, y, N, speed, radius, collision_group)
	enemy = {}
	setmetatable(enemy, {__index = Enemy})
	enemy.color = {255,255,255,1}
	enemy.x = x
	enemy.y = y
	enemy.N = N
	enemy.speed = speed
	enemy.radius = radius
	enemy.counter = 0
	enemy.collision_group = 2
	enemy.hp = 1
	enemy.sprite = Polygon.new(x, y, N, radius)

	enemy.global_index = add_object(global_obj_array, global_obj_pointer, enemy)
	return enemy
end

function Enemy:update()
	if self.hp <= 0 then
		global_obj_array[self.global_index] = nil
	end
end

function Enemy:move()
	if self.counter % 5 == 0 then
		local x_dist = player.x - self.x
		local y_dist = player.y - self.y

		local k = y_dist / x_dist
		local theta = math.atan2(y_dist, x_dist);
		self.a = math.sin(theta) * self.speed
		self.b = self.a / k
	end
		self.x = self.x + self.b
		self.y = self.y + self.a
	
	self.sprite:move(self.x, self.y)

	self.counter = self.counter + 1
end

function Enemy:draw()
	--love.graphics.setColor(self.color)
	self.sprite:draw()
end

function Enemy:resolve_collision(collider)
	self.hp = self.hp - 1
	
end

