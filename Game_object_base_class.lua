Game_object_base = {}
Game_object_base.__index = Game_object_base

setmetatable(Game_object_base, {
	__call = function(cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,

})

function Game_object_base:_init(x, y, suppress)
	local suppress = suppress or false

	self.x = x
	self.y = y
	self.sprite = love.graphics.newImage("sprites/my_hat.png")
	self.color = global_palette[1]
	self.radius = 16
	self.damage = 0
	self.status = Status_table.new(self)
	self.z_index = 1

	if suppress == false then 	
		self.global_index = add_object(global_obj_array, global_obj_pointer, self)
	end
end

function Game_object_base:update()
	return
end

function Game_object_base:draw(i)
	return
end

function Game_object_base:move()
	return
end

function Game_object_base:resolve_collision()
	return
end