Animation = {}
Animation.__index = Animation

setmetatable(Animation, {
	__call = function(cls, ...)
				local self = setmetatable({}, cls)
				self:_init(...)
				return self
			end,
		})


function Animation:_init(x, y, sprite, angle)
	self.x = x or -100
	self.y = y or -100
	self.sprite = sprite
	self.angle = angle or 0
	self.color = global_palette[1]
	local g = anim8.newGrid(32, 32, self.sprite:getWidth(), self.sprite:getHeight())
  	self.animation = anim8.newAnimation(g(tostring(1) .. '-' .. tostring(self.sprite:getWidth() / 32),1), 1, 'pauseAtEnd')
  	self.noncollidable = true
  	self.global_index = add_object(global_obj_array, global_obj_pointer, self)
  	self.timer = timer or 180
  	return self
end

function Animation:draw(i)
	if i == 4 then
		love.graphics.setColor(self.color)
		self.animation:update(1)
		self.animation:draw(self.sprite, self.x, self.y, self.angle)
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