Player = {}

function Player.new (x, y, N, collision_group) 
	player = {}
	setmetatable(player, {__index = Player})
	player.x = x or love.graphics.getWidth() / 2
	player.y = y or love.graphics.getHeight() / 2
	player.N = 4
	player.color = {125,125,125,0.5}
	player.radius = 16;
	player.speed = 5;
	player.collision_group = 1
	player.hp = 5
	player.refresh_speed = 5
	player.counter = 0
	return player
end

function Player:shoot()
	if player.counter == 0 then
		for i = 1, 4, 1 do
			Bullet.new(self.x + (self.radius / 2), self.y + (self.radius / 2), self.N, (math.pi/2) * i, 10, self.radius / 4, self.collision_group);
		end
		self.counter = self.refresh_speed
	end
end

function Player:update()
	if self.counter ~= 0 then
		self.counter = self.counter - 1
	end
	if self.hp <= 0 then
		global_obj_array[self.global_index] = nil
	end
end

function Player:move()
	return;
end

function Player:draw() 
	--love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.x, self.y, self.radius, self.radius)
end

function Player:resolve_collision(collider)
	self.hp = self.hp - 1
end