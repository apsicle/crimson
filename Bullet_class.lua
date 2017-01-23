Bullet = {}

function Bullet.new(x, y, N, direction, speed, radius, color, collision_group)
	bullet = {}
	setmetatable(bullet, {__index = Bullet})
	bullet.x = x; bullet.y = y; 
	bullet.N = N
	bullet.color = color
	bullet.direction = direction; 
	bullet.speed = speed;
	bullet.radius = radius;
	bullet.collision_group = collision_group;
	bullet.sprite = Polygon.new(x, y, N, radius)
	bullet.hp = 1
	bullet.global_index = add_object(global_obj_array, global_obj_pointer, bullet)
	return bullet
end

function Bullet:update()
	if (self.hp <= 0) or (self.x > global_width) or (self.x < 0) or (self.y > global_height) or (self.y < 0) then
		global_obj_array[self.global_index] = nil
	end
end

function Bullet:move()

	d = math.cos(self.direction) * self.speed
	e = math.sin(self.direction) * self.speed

	obj, t = raycast(self, d, e)
	
	
	if (obj ~= nil) and (t < 1) then
		collide(self, obj)
		return
	else
		self.x = self.x + d
		self.y = self.y + e
	end
	
	self.sprite:move(self.x, self.y)
end

function Bullet:draw()
	love.graphics.setColor(self.color)
	self.sprite:draw()
end
	


function Bullet:resolve_collision(collider)
	self.hp = self.hp - 1
end
