--Collision groups: 0 - items/pickupable, 1 - player, 2 - standard enemies 


function sign(x)
  return x>0 and 1 or x<0 and -1 or 0
end

function add_object(array, pointer, object)
	--inserts an object in an table and returns the index at which it was inserted
	table.insert(array, pointer, object)
	global_obj_pointer = global_obj_pointer + 1;
	return pointer
end

function collide(obj_a, obj_b)
	obj_a:resolve_collision(obj_b)
	obj_b:resolve_collision(obj_a)
	obj_a:update()
	obj_b:update()
	return
end

function clamp(min, max, num)
	return math.max(math.min(num, max), min)
end

function blend_colors(rgb1, rgb2, t)
	-- sqrt( [1-t]*rgb1^2 + [t]*rgb2^2)
	rgb3 = {}
	local t = t or 0.5;
	for key, value in pairs(rgb1) do
		color1 = value;
		color2 = rgb2[key];

		color3 = math.sqrt( (1-t)*color1*color1 + (t)*color2*color2 )

		table.insert(rgb3, color3)
	end
	return rgb3;
end

function sq(num)
	return num * num
end

function move_constant_speed(x1, y1, x2, y2, speed)
	local x_dist = x2 - x1
	local y_dist = y2 - y1

	if sq(x_dist) + sq(y_dist) > 10 then

		local k = y_dist / x_dist
		local theta = math.atan2(y_dist, x_dist);
		local a = math.sin(theta) * speed
		local b = a / k

		return x1 + b, y1 + a;

	end

	return x1, y1

	
end

function distance2dsq(x1, y1, x2, y2) 
	return sq(x2 - x1) + sq(y2 - y1)
end

function distance_obj_sq(obj1, obj2)
	return sq(obj1.x - obj2.x) + sq(obj1.y - obj2.y)
end


function check_collision(object) 
	if object.ray_class ~= nil then
		return raycast(object, object.d, object.e)
	else
	end
end

function radcheck(self, obj)
	if distance_obj_sq(self, obj) < (sq(self.radius) + sq(obj.radius)) then
		return true
	end
	return false
end

function raycast(self, d, e)
	-- raycast from an object
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
			if value.non_collidable ~= nil then
			elseif value.color ~= self.color then
				
				table.insert(collidable_objs, value)
			end
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
			end
			if sign(t_1) == -1 then
				t_1 = math.huge
			end
			if min_t > math.min(t_0, t_1) then
				min_t = math.min(t_0, t_1)
				colliding_obj = value
			end
		end
	end

	return colliding_obj, min_t
end