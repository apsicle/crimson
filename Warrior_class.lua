Warrior = {}

function Warrior.new(x, y, N, speed, radius, color, collision_group)
	warrior = {}
	setmetatable(warrior, {__index = Warrior})
	warrior.color = color
	warrior.x = x
	warrior.y = y
	warrior.N = N
	warrior.speed = speed
	warrior.radius = radius
	warrior.counter = 0
	warrior.collision_group = 2
	warrior.hp = 1
	warrior.refresh_speed = 60
	warrior.sprite = Polygon.new(x, y, N, radius)

	warrior.global_index = add_object(global_obj_array, global_obj_pointer, warrior)
	return warrior
end

function Warrior:update()
	if self.hp <= 0 then
		self:destroy();
	end
end

function Warrior:destroy()
	local num_shards = love.math.random(3,5);
	for i = 1, num_shards, 1 do
		Shard.new(self, self.x, self.y, self.x + love.math.random(-10,10), self.y + love.math.random(-10,10), 5)
	end
	global_obj_array[self.global_index] = nil
end

function Warrior:move()
	local dist_to_player = distance_obj_sq(self, player)
	self.x, self.y = move_constant_speed(self.x, self.y, player.x, player.y, self.speed)
	self.sprite:move(self.x, self.y)
	if self.counter == 0 then
		self:shoot()
		self.counter = self.refresh_speed
	end
	self.counter = self.counter - 1;
end

function Warrior:shoot()

	local angle = math.atan2(player.y - self.y, player.x - self.x);
	local xdisp = math.cos(angle) * self.radius / 2
	local ydisp = math.sin(angle) * self.radius / 2
	Bullet.new(self.x + xdisp, self.y + ydisp, self.N, angle, 10, self.radius / 4, self.color, self.collision_group);
		
		

end


function Warrior:draw()
	love.graphics.setColor(self.color)
	self.sprite:draw()
end

function Warrior:resolve_collision(collider)
	if collider.color ~= global_palette[1] then
		self.color = collider.color
	else
		self.hp = self.hp - 1
	end
end

