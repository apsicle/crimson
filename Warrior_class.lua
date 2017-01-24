Warrior = {}

function Warrior.new(x, y, N, speed, radius, color, damage, collision_group)
	warrior = {}
	setmetatable(warrior, {__index = Warrior})
	warrior.color = color
	warrior.x = x
	warrior.y = y
	warrior.N = N
	warrior.target_x = 0;
	warrior.target_y = 0;
	warrior.speed = speed
	warrior.radius = radius
	warrior.counter = 0
	warrior.damage = damage
	warrior.collision_group = 2
	warrior.hp = 1
	warrior.refresh_speed = 60
	warrior.state = "moving"
	warrior.stagger_max = 30;
	warrior.stagger = 30;


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
	local dist_to_player = distance_obj(self, player);

	if self.state == "moving" then
		move_constant_speed(self, player.x, player.y, self.speed)
		if dist_to_player < self.radius * 4 then
			self:attack(player)
		end

	elseif self.state == "attacking" then
		moved = move_constant_speed(self, self.target_x, self.target_y, self.speed * 2)
		if moved == false then
			self.state = "recovering"
		end

	elseif self.state == "recovering" then
		self.stagger = self.stagger - 1
		if self.stagger == 0 then
			self.stagger = self.stagger_max
			self.state = "moving"
		end	
	end

	self.sprite:move(self.x, self.y);

end

function Warrior:attack(obj)
	self.state = "attacking"
	self.target_x = player.x
	self.target_y = player.y
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

