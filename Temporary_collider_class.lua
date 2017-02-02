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
	setmetatable(t,{__index={x = 0, y = 0, speed=0, direction=0, sprite = nil, damage = 0, collision_group = player.collision_group, radius = 0, lifetime = 1}}) 
	print_table(t)
	self.x = t[1] or t.x
	self.y = t[2] or t.y 
	self.speed = t[3] or t.speed
	self.sprite = t[4] or t.sprite
	self.damage = t[5] or t.damage
	self.collision_group = t[6] or t.collision_group
	self.radius = t[7] or t.radius
	self.timer = t[8] or t.lifetime
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
	end
end

function Temporary_collider:move()
	print_table(self)
	circle_cast(self, radcheck)
	return
end

function Temporary_collider:resolve_collision()
	return
end
