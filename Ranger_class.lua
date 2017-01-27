Ranger = Class(Ground_enemy_base)
function Ranger:_init(x, y, N, speed, radius, color, damage, collision_group)
	ranger = {}
	setmetatable(ranger, {__index = Ranger})
	ranger.color = color
	ranger.x = x
	ranger.y = y
	ranger.N = 5
	ranger.speed = speed
	ranger.radius = radius
	ranger.shot_counter = 0
	ranger.bullet_refresh_counter = 3
	ranger.bullet_refresh_max = 3
	ranger.color = color
	ranger.damage = damage
	ranger.collision_group = collision_group
	ranger.hp = 3
	ranger.status = Status_table.new(ranger)
	ranger.state = "moving"
	ranger.stagger_max = 60
	ranger.stagger = 60
	ranger.z_index = 3
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
	local dist_to_player = distance_obj(self, player);

	if self.state == "moving" then
		local x_dist, y_dist = player.x - self.x, player.y - self.y

		if dist_to_player > (self.radius*10) then
			self.state = "attacking"
		else 
			move_constant_speed(self, self.x - x_dist, self.y - y_dist, self.speed)
		end

	elseif self.state == "attacking" then
		if self.shot_counter < 3 then
			if self.bullet_refresh_counter <= 0 then
				self:shoot()
				self.shot_counter = self.shot_counter + 1
				self.bullet_refresh_counter = self.bullet_refresh_max
			else
				self.bullet_refresh_counter = self.bullet_refresh_counter - 1
			end
		else
			self.state = "recovering"
			self.shot_counter = 0
		end
		
	elseif self.state == "recovering" then
		self.stagger = self.stagger - 1
		if self.stagger == 0 then
			self.stagger = self.stagger_max
			self.state = "moving"
		end	
	end
	
	self.sprite:move(self.x, self.y)
	
end

function Ranger:shoot()
	local angle = math.atan2(player.y - self.y, player.x - self.x);
	local xdisp = math.cos(angle) * self.radius / 2
	local ydisp = math.sin(angle) * self.radius / 2
	Bullet.new(self.x + xdisp, self.y + ydisp, self.N, angle, 10, self.radius / 4, self.color, self.damage, self.collision_group);
end


function Ranger:draw()
	love.graphics.setColor(self.color)
	self.sprite:draw()
end

function Ranger:resolve_collision(collider)
	if collider.color ~= global_palette[1] then--and collider.color ~= nil then
		self.color = collider.color
	else
		self.hp = self.hp - 1
	end
end

