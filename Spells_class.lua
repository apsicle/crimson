Spells = {}





function Spells:shockwave(self, x, y)
	shockwave = {}
	shockwave.sprite = nil


	function shockwave:draw()
	end

end

function Spells:cast_freezing_field(self, x, y)
	freezing_field = {}
	setmetatable(freezing_field, {__index = Spells.freezing_field})
	freezing_field.sprite = love.graphics.newImage('sprites/freezing_field.png')
	freezing_field.x = x
	freezing_field.y = y
	freezing_field.damage = 1
	freezing_field.inanimate = true
	freezing_field.collision_group = 1
	freezing_field.radius = freezing_field.sprite:getWidth() / 2
	freezing_field.counter = 0
	freezing_field.counter_max = 5
	freezing_field.z_index = 1;
	freezing_field.global_index = add_object(global_obj_array, global_obj_pointer, freezing_field)

	return freezing_field
end

Spells.freezing_field = {}



	function Spells.freezing_field:update()

		self.counter = self.counter + 0.1

		self.radius = self.counter * self.sprite:getWidth() / 2

		if self.counter >= self.counter_max then
			global_obj_array[self.global_index] = nil
		end
		

	end

	function Spells.freezing_field:move()
		self.x = player.x
		self.y = player.y

		self:check_collisions()
	end

	function Spells.freezing_field:check_collisions()

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

	function Spells.freezing_field:draw() 
		love.graphics.setColor(255,255,255)
		
		love.graphics.draw(self.sprite, self.x - self.radius, self.y - self.radius, 0, self.counter, self.counter)

		local xpos = math.random(-15,15)
		local ypos = math.random(-15,15)
		love.graphics.translate(xpos, ypos)

	end

	function Spells.freezing_field:resolve_collision(collider)
		return
	end


