Loopy_ghost = {}

function Loopy_ghost.new(x, y, N, speed, radius, color, damage, collision_group)
	loopy_ghost = {}
	setmetatable(loopy_ghost, {__index = Loopy_ghost})
	loopy_ghost.color = color
	loopy_ghost.x = x
	loopy_ghost.y = y
	loopy_ghost.N = N
	loopy_ghost.target_x = 0;
	loopy_ghost.target_y = 0;
	loopy_ghost.speed = speed
	loopy_ghost.radius = 32
	loopy_ghost.counter = 0
	loopy_ghost.damage = damage
	loopy_ghost.collision_group = 2
	loopy_ghost.hp = 1
	loopy_ghost.refresh_speed = 60
	loopy_ghost.state = "moving"
	loopy_ghost.stagger_max = 30;
	loopy_ghost.stagger = 30;

	-- SPRITES, ANIMATIONS
	loopy_ghost.sprite_moving = love.graphics.newImage('sprites/loopy_ghost_atlas.png')
  	local g = anim8.newGrid(64, 64, loopy_ghost.sprite_moving:getWidth(), loopy_ghost.sprite_moving:getHeight())
  	loopy_ghost.animation_moving = anim8.newAnimation(g('1-3',1), 15)

  	loopy_ghost.sprite_attacking = love.graphics.newImage('sprites/loopy_ghost_attack_atlas.png')
  	local h = anim8.newGrid(64, 64, loopy_ghost.sprite_attacking:getWidth(), loopy_ghost.sprite_attacking:getHeight())
  	loopy_ghost.animation_attacking = anim8.newAnimation(h('1-3',1), 15)
	--loopy_ghost.sprite = Polygon.new(x, y, N, radius)
	
	loopy_ghost.global_index = add_object(global_obj_array, global_obj_pointer, loopy_ghost)
	return loopy_ghost
end

function Loopy_ghost:update()
	if self.hp <= 0 then
		self:destroy();
	end
end

function Loopy_ghost:destroy()
	local num_shards = love.math.random(3,5);
	for i = 1, num_shards, 1 do
		Shard.new(self, self.x, self.y, self.x + love.math.random(-20,20), self.y + love.math.random(-20,20), 5)
	end
	global_obj_array[self.global_index] = nil
end

function Loopy_ghost:move()
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

	--self.sprite:move(self.x, self.y);

end

function Loopy_ghost:attack(obj)
	self.state = "attacking"
	self.target_x = player.x
	self.target_y = player.y
end


function Loopy_ghost:draw()
	--love.graphics.setColor(self.color)
	--self.sprite:draw()
	love.graphics.setColor(self.color)
	if self.state == "moving" or self.state == "recovering" then
		self.animation_moving:update(1)
		self.animation_moving:draw(self.sprite_moving, self.x, self.y - 20, (math.pi/180) * sign(player.x - self.x) * 10, 1, 1)
	else
		self.animation_attacking:update(1)
		self.animation_attacking:draw(self.sprite_attacking, self.x, self.y - 20, (math.pi/180) * sign(player.x - self.x) * 10, 1, 1)
	end
end

function Loopy_ghost:resolve_collision(collider)
	if collider.color ~= global_palette[1] then
		self.color = collider.color
	else
		self.hp = self.hp - 1
	end
end

