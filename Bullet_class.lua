Bullet = {}

function Bullet.new(x, y, N, direction, speed, radius, collision_group)
	bullet = {}
	setmetatable(bullet, {__index = Bullet})
	bullet.x = x; bullet.y = y; 
	bullet.N = N
	bullet.color = {255,255,255,1}
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

	obj, t = self:check_collisions(d, e)
	
	
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
	--love.graphics.setColor(self.color)
	self.sprite:draw()
end
	
function Bullet:check_collisions(d, e)
	
	local x_0 = self.x;
	local y_0 = self.y;
	local x_1 = self.x + d;
	local y_1 = self.y + e;

	--[[Parametric equations for bullet trajectory:
	Eq(1): x_1 = d*t + x_0
	Eq(2): y_1 = e*t + y_0
	where equations are parameterized by t and x_0 and y_0 is the starting point of the ray

	Equation for the object to check collision with is a circle:
	Eq(3): (x-h)^2 + (y-k)^2 = r^2

	Plugging eq(1) and (2) into Eq(3) for x and y is asserting that point (x_1, y_1) is on the circle 
	described by eq(3), ie. it intersects it. This results in equation 4 in one variable, t.
	Eq(4): (d^2 + e^2)t^2 + (-2dh + 2dx_0 - 2ek + 2ey_0)t + (x_0^2 + h^2 - 2x_0h + y_0^2 + k^2 - 2y_0k - r^2) = 0

	This is a polynomial in standard form At^2 + Bt + C = 0. To find the roots we apply the quadratic equation.
	There is no intersection when the discriminant is <0 (total miss), or t > 1 (since we travel t = 1 units at a time).
	If 0 < t <= 1, then we are about to hit the object, and we call the collision script. If t < 0, then the object is behind us
	or we are already inside it.
	]] 
	
	local collidable_objs = {}
	for key, value in pairs(global_obj_array) do
		if (value.collision_group ~= self.collision_group) then
			table.insert(collidable_objs, value)
		end
	end

	local min_t = math.huge
	local colliding_obj = nil

	for key, value in pairs(collidable_objs) do
		local h = value.x
		local k = value.y
		local r = value.radius

		local A = d*d + e*e;
		local B = 2*(-d*h + d*x_0 - e*k + e*y_0)
		local C = x_0*x_0 + h*h - 2*x_0*h + y_0*y_0 + k*k - 2*y_0*k - r*r

		local discriminant = B*B - 4*A*C

		if discriminant > 0 then
			local t_0 = (-B + math.sqrt(discriminant)) / (2*A)
			local t_1 = (-B - math.sqrt(discriminant)) / (2*A)
			if sign(t_0) == -1 then
				t_0 = math.huge
			elseif sign(t_1) == -1 then
				t_1 = math.huge
			end
			if min_t > math.min(t_0, t_1) then
				min_t = math.min(t_0, t_1)
				colliding_obj = value
			end
		end
	end

	return colliding_obj, min_t;
end

function Bullet:resolve_collision(collider)
	self.hp = self.hp - 1
	self:update()
end
