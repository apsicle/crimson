Spell = Class(Game_object_base)

function Spell:_init(x, y)
	Game_object_base._init(self, x, y, true)
	self.sprite = love.graphics.newImage('sprites/freezing_field.png')
	self.x = x
	self.y = y
	self.damage = 1
	self.inanimate = true
	self.collision_group = 1
	self.radius = self.sprite:getWidth() / 2
	self.counter = 0
	self.counter_max = 5
	self.z_index = 1;
	--self.global_index = add_object(global_obj_array, global_obj_pointer, self)
	return self
end

-- SHOCKWAVE SPELL--
Shockwave = Class(Spell)

function Shockwave(self, x, y)
	Spell._init(self, x, y, true)

	self.sprite = love.graphics.newImage('sprites/freezing_field.png')
	self.mp_cost = {5, 1}
end

-- FREEZING FIELD--
Freezing_field = Class(Spell)

function Freezing_field:_init()
	Spell._init(self, x, y, true)
	self.sprite = love.graphics.newImage('sprites/freezing_field.png')
	self.x = player.x
	self.y = player.y
	self.mp_cost = {10, 2}
	self.damage = 1
	self.inanimate = true
	self.collision_group = 1
	self.radius = self.sprite:getWidth() / 2
	self.counter = 0
	self.counter_step = 0.15
	self.counter_max = 5
	self.z_index = 1;
	self.global_index = add_object(global_obj_array, global_obj_pointer, self)

	return self
end


function Freezing_field:update()
	self.counter = self.counter + self.counter_step
	self.radius = self.counter * self.sprite:getWidth() / 2

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

circle_cast(self)

end

function Freezing_field:draw() 
	love.graphics.setColor(255,255,255)
	
	love.graphics.draw(self.sprite, self.x - self.radius, self.y - self.radius, 0, self.counter, self.counter)

	local xpos = math.random(-15,15)
	local ypos = math.random(-15,15)
	--love.graphics.translate(xpos, ypos)

end

function Freezing_field:resolve_collision(collider)
	return
end


