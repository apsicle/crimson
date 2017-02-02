Spell = Class(Game_object_base)

--[[ SPELL METACLASS 
Basic functionality for a class object. Defaults to freezing field attributes]]
function Spell:_init(x, y)
	Game_object_base._init(self, x, y, true)
	self.sprite = love.graphics.newImage('sprites/freezing_field.png')
	self.hit_sprite = love.graphics.newImage('sprites/freezing_field_hit.png')
	self.x = x
	self.y = y
	self.damage = 1
	self.inanimate = true
	self.collision_group = 1
	self.radius = (self.sprite:getWidth() / 2) * 5
	self.counter = 0
	self.counter_max = 5
	self.z_index = 1;
	--self.global_index = add_object(global_obj_array, global_obj_pointer, self)
	return self
end

-- BOOMERANG SPELL --
Boomerang = Class(Spell)

function Boomerang:_init(destination)
	Spell._init(self, x, y, true)
	self.sprite = love.graphics.newImage('sprites/my_hat.png')
	self.x = player.x
	self.y = player.y
	self.mp_cost = {1, 0}
	self.damage = 1
	self.inanimate = true
	self.speed = 4
	self.collision_group = 1
	self.angle = 0;
	self.radius = (self.sprite:getWidth() / 2)
	self.state = "outgoing"
	self.global_index = add_object(global_obj_array,global_obj_pointer, self)
	self.destination = destination
	print_table(self.destination)

end

function Boomerang:update()
	if self.x >= global_width - 32 then
		self.state = "returning"
		self.x = global_width - 32
		end
	if self.y >= global_height - 32 then
		self.state = "returning"
		self.y = global_height - 32
		end
	if self.x <= 0 + 32 then
		self.state = "returning"
		self.x = 0 + 32
		end
	if self.y <= 0 + 32 then
		self.state = "returning"
		self.y = 0 + 32
		end
	if distance_coord_sq(self.x, self.y, self.destination.x, self.destination.y) < 10 then
		if self.state == "outgoing" then
			self.state = "returning"
		elseif self.state == "returning" then
			global_obj_array[self.global_index] = nil
		end
	end
	if self.state == "returning" then
		self.destination.x = player.x
		self.destination.y = player.y
	end
	self.angle = self.angle + (math.pi / 180) * 10


end

function Boomerang:move()
	move_constant_speed(self, self.destination.x, self.destination.y, self.speed)
	circle_cast(self, in_my_radius)
	return
end

function Boomerang:draw()

	love.graphics.draw(self.sprite, self.x, self.y, self.angle, 1, 1, self.sprite:getHeight() / 2, self.sprite:getHeight()/ 2)
end

-- SHOCKWAVE SPELL --
Shockwave = Class(Spell)

function Shockwave(self, x, y)
	Spell._init(self, x, y, true)

	self.sprite = love.graphics.newImage('sprites/freezing_field.png')
	self.mp_cost = {5, 1}
end

-- FREEZING FIELD --
Freezing_field = Class(Spell)

function Freezing_field:_init()
	Spell._init(self, x, y, true)
	self.sprite = love.graphics.newImage('sprites/freezing_field.png')
	self.sprite_hit = love.graphics.newImage('sprites/freezing_field_hit.png')
	self.x = player.x
	self.y = player.y
	self.mp_cost = {0, 2}
	self.damage = 1
	self.inanimate = true
	self.collision_group = 1
	self.radius = (self.sprite:getWidth() / 2) * 5
	self.counter = 0
	self.counter_step = 0.15
	self.counter_max = 5
	self.z_index = 1;
	self.global_index = add_object(global_obj_array, global_obj_pointer, self)

	-- SPRITES, ANIMATIONS 

  	local g = anim8.newGrid(32, 32, self.sprite_hit:getWidth(), self.sprite_hit:getHeight())
  	self.animation_hit = anim8.newAnimation(g('1-8',1), 1, 'pauseAtEnd')

	return self
end


function Freezing_field:update()
	self.counter = self.counter + self.counter_step
	--self.radius = self.counter * self.sprite:getWidth() / 2

	if self.counter >= self.counter_max then
		global_obj_array[self.global_index] = nil
	end
end

function Freezing_field:move()
	self.x = player.x
	self.y = player.y

	self:check_collisions()
end

function Freezing_field:check_collisions()
	
	self.collided_objs = circle_cast(self, in_my_radius, true)
	
	if self.collided_objs ~= nil then

		for ind, value in pairs(self.collided_objs) do
			value.speed = 1
			value.color = global_palette[3]
			value.status:activate_status('stunned', 60, function(obj) obj.speed = 0 end, function(obj) obj.speed = 0.5 end)
		end
	end
end

function Freezing_field:draw(i) 

	love.graphics.setColor(255,255,255)
	
	if (i == 1) then
		love.graphics.draw(self.sprite, self.x - self.radius, self.y - self.radius, 0, 5, 5)
	end
	
	if (i == 4) then
		self.animation_hit:update(1)
		for ind, value in pairs(self.collided_objs) do
			print(value)
			self.animation_hit:draw(self.sprite_hit, value.x, value.y)
		end
	end

	local xpos = math.random(-15,15)
	local ypos = math.random(-15,15)
	--love.graphics.translate(xpos, ypos)

end

function Freezing_field:resolve_collision(collider)
	return
end


