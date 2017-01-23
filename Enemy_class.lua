Ranger = {}

function Ranger.new(x, y, N, speed, radius, color, collision_group)
	ranger = {}
	setmetatable(ranger, {__index = Ranger})
	ranger.color = color
	ranger.x = x
	ranger.y = y
	ranger.N = N
	ranger.speed = speed
	ranger.radius = radius
	ranger.counter = 0
	ranger.collision_group = 2
	ranger.hp = 1
	ranger.refresh_speed = 60
	ranger.sprite = Polygon.new(x, y, N, radius)

	ranger.global_index = add_object(global_obj_array, global_obj_pointer, ranger)
	return ranger
end

function Ranger:update()
	if self.hp <= 0 then
		self:destroy();
	end
end

function Ranger:destroy()
	local num_shards = love.math.random(3,5);
	for i = 1, num_shards, 1 do
		Shard.new(self, self.x, self.y, self.x + love.math.random(-10,10), self.y + love.math.random(-10,10), 5)
	end
	global_obj_array[self.global_index] = nil
end

function Ranger:move()
	
	self.x, self.y = self.x, self.y
	self.sprite:move(self.x, self.y)
	if self.counter == 0 then
		self:shoot()
		self.counter = self.refresh_speed
	end
	self.counter = self.counter - 1;
end

function Ranger:shoot()

	local angle = math.atan2(player.y - self.y, player.x - self.x);
	local xdisp = math.cos(angle) * self.radius / 2
	local ydisp = math.sin(angle) * self.radius / 2
	Bullet.new(self.x + xdisp, self.y + ydisp, self.N, angle, 10, self.radius / 4, self.color, self.collision_group);
		
		

end


function Ranger:draw()
	love.graphics.setColor(self.color)
	self.sprite:draw()
end

function Ranger:resolve_collision(collider)
	if collider.color ~= global_palette[1] then
		self.color = collider.color
	else
		self.hp = self.hp - 1
	end
end

