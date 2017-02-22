Temporary_collider = {}
Temporary_collider.__index = Temporary_collider

setmetatable(Temporary_collider, {
	__call = function(cls, ...)
				local self = setmetatable({}, cls)
				self:_init(...)
				return self
			end,
		})
-- To create temporary objects with sprites attached to them or not that hit things (like the boomerang hat)

function Temporary_collider:_init(t)
	setmetatable(t,{__index={x = 0, y = 0, speed=0, direction=0, sprite = nil, damage = 0, collision_group = player.collision_group, radius = 0, lifetime = 1, effect = nil}}) 
	self.x = t.x
	self.y = t.y 
	self.speed = t.speed
	self.sprite = t.sprite
	self.damage = t.damage
	self.color = t.color
	self.collision_group = t.collision_group
	self.radius = t.radius
	self.timer = t.lifetime
	self.effect_table = t.effect_table
	self.global_index = add_object(global_obj_array, global_obj_pointer, self)
end

function Temporary_collider:update() 
	if self.timer <= 0 then
		global_obj_array[self.global_index] = nil
	end
	self.timer = self.timer - 1
end

function Temporary_collider:draw()
	if self.sprite ~= nil then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(self.sprite, self.x, self.y)
		love.graphics.ellipse('line', self.x, self.y, self.radius, self.radius)
	end
end

function Temporary_collider:move()
	circle_cast(self, radcheck)
	return
end

function Temporary_collider:resolve_collision(collider)
	if self.effect_table ~= nil then
		if collider.status ~= nil then
			collider.status:activate_status(self.effect_table)
		end
	end
	return
end
