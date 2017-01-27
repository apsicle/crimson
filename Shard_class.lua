Shard = {}

function Shard.new(obj, spawn_x, spawn_y, final_x, final_y, speed)
	shard = {}
	setmetatable(shard, {__index = Shard})

	shard.x = spawn_x
	shard.y = spawn_y
	shard.direction = direction
	shard.speed = speed
	shard.distance = distance
	shard.color = obj.color;
	shard.collision_group = 0;
	shard.is_shard = true;
	shard.radius = 3;

	shard.final_x = final_x
	shard.final_y = final_y
	shard.z_index = 3;
	shard.sprite = love.graphics.newImage('sprites/shard.png')
	--Polygon.new(spawn_x, spawn_y, obj.N, shard.radius);

	shard.global_index = add_object(global_obj_array, global_obj_pointer, shard)


	return shard
end

function Shard:update()
	return
end

function Shard:move()
	
		move_constant_speed(self, self.final_x, self.final_y, self.speed)
		--self.sprite:move(self.x, self.y)

	
end

function Shard:draw()
	love.graphics.setColor(self.color)
	love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1)
	--self.sprite:draw();
end

function Shard:resolve_collision(collider)
	global_obj_array[self.global_index] = nil
end