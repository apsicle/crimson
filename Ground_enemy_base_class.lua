--[[Ground_enemy_base = {}
for k, v in pairs(Game_object_base) do
  Ground_enemy_base[k] = v
end
Ground_enemy_base.__index = Ground_enemy_base

setmetatable(Ground_enemy_base, {
	__index = Game_object_base,
	__call = function(cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Ground_enemy_base:_init(x, y)
	Game_object_base._init(self, x, y)
	self.x = x
	self.y = y
end

--]]


Ground_enemy_base = Class(Game_object_base)

function Ground_enemy_base:_init(x, y)
	Game_object_base._init(self, x, y, true)
end