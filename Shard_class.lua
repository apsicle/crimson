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
	shard.non_collidable = true;
	shard.final_x = final_x
	shard.final_y = final_y
	shard.sprite = Polygon.new(spawn_x, spawn_y, obj.N, 3);

	shard.global_index = add_object(global_obj_array, global_obj_pointer, shard)


	return shard
end

function Shard:update()
	return
end

function Shard:move()
	
		self.x, self.y = move_constant_speed(self.x, self.y, self.final_x, self.final_y, self.speed)
		self.sprite:move(self.x, self.y)

	
end

function Shard:draw()
	love.graphics.setColor(self.color)
	self.sprite:draw();
end