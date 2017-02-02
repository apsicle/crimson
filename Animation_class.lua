Animation = {}
Animation.__index = Animation

setmetatable(Animation, {
	__call = function(cls, ...)
				local self = setmetatable({}, cls)
				self:_init(...)
				return self
			end,
		})


function Animation:_init(t)
	setmetatable(t,{__index={sprite=0, x = 0, y = 0, angle=0, scale_x = 1, scale_y = 1, offset_x = 0, offset_y = 0}}) 
	self.sprite = t.sprite
	self.x = t.x
	self.y = t.y
	self.angle = t.angle
	
	self.scale_x = t.scale_x
	self.scale_y = t.scale_y
	self.offset_x = t.offset_x
	self.offset_y = t.offset_y


	self.color = global_palette[1]
	local g = anim8.newGrid(self.sprite:getHeight(), self.sprite:getHeight(), self.sprite:getWidth(), self.sprite:getHeight())
  	self.animation = anim8.newAnimation(g(tostring(1) .. '-' .. tostring(self.sprite:getWidth() / self.sprite:getHeight()),1), 1, 'pauseAtEnd')
  	self.noncollidable = true
  	self.global_index = add_object(global_obj_array, global_obj_pointer, self)
  	self.timer = timer or 180
  	return self
end

function Animation:draw(i)
	if i == 4 then
		love.graphics.setColor(self.color)
		self.animation:update(1)
		self.animation:draw(self.sprite, self.x, self.y, self.angle, self.scale_x, self.scale_y, self.offset_x, self.offset_y)
	end
end

function Animation:update()
	self.timer = self.timer - 1
	if self.timer <= 0 then
		global_obj_array[self.global_index] = nil
	end
end

function Animation:move()
	--self.x = player.x
	--self.y = player.y
end