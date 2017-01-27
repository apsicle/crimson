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

function Spell:shockwave(self, x, y)
	shockwave = {}
	shockwave.sprite = nil


	function shockwave:draw()
	end

end

Freezing_field = Class(Spell)

function Freezing_field:_init(x, y)
Spell._init(self, x, y, true)
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
self.global_index = add_object(global_obj_array, global_obj_pointer, self)

return self
end


function Freezing_field:update()
	print(self.counter, self.counter_max)
	self.counter = self.counter + 0.1

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

local collidable_objs = {}
for key, value in pairs(global_obj_array) do
	if value ~= nil then
		if (value.collision_group ~= self.collision_group) then
			if value.item ~= nil then
				--player object is the only object that can collide with items
				table.insert(collidable_objs, value)
			elseif value.is_shard ~= nil then
				--player object collides with shards no matter what
				table.insert(collidable_objs, value)
			elseif value.color ~= self.color then
				--if you are different colors, you can collide
				table.insert(collidable_objs, value)
			end
		end
	end
end

for key, value in pairs(collidable_objs, value) do
	if radcheck(self, value) then
		collide(self, value)
	end
end
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


