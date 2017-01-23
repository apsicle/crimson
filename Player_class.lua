--Overview of class architecture:
--keep track of x, y, color, angle, collision group, hp, etc...

--Each class has AT LEAST 3 functions, which are called in order each round as so:
-- update() all objects: do all "status checks" and update self values accordingly. If you're dead, you're removed here.
-- move() all objects: calculate where you are going next. Check for a collision there if you are moving incredibly fast (ie. bullet or other ray classes),
-- otherwise, move there.

Player = {}

function Player.new (x, y, N, collision_group) 
	player = {}
	setmetatable(player, {__index = Player})
	player.x = x or love.graphics.getWidth() / 2
	player.y = y or love.graphics.getHeight() / 2
	player.N = N or 4
	player.color = global_palette[1]
	player.radius = 16;
	player.speed = 4;
	player.angle = 0;
	player.collision_group = color
	player.hp = 5
	player.max_hp = 5
	player.refresh_speed = 15;
	player.counter = 0
	player.sprite = Polygon.new(player.x, player.y, player.N, player.radius)

	--define the color palette for the player. Player character can switch between these freely.
	player.palette = global_palette

	return player
end

function Player:shoot()
	if player.counter == 0 then
		local angle = math.atan2(love.mouse.getY() - self.y, love.mouse.getX() - self.x);
		local xdisp = math.cos(angle) * self.radius / 2
		local ydisp = math.sin(angle) * self.radius / 2
		Bullet.new(self.x + xdisp, self.y + ydisp, self.N, angle, 10, self.radius / 4, self.color, self.collision_group);
		
		self.counter = self.refresh_speed
	end
end

function Player:update()
	if self.counter ~= 0 then
		self.counter = self.counter - 1
	end
	if self.hp <= 0 then
		global_obj_array[self.global_index] = nil
	end

end

function Player:move()
	-- Player controls. I figure I'll just put this on the first layer, ie. in update, so there's the least overhead as possible?
	-- Movement:
	if (love.keyboard.isDown('w')) then
		player.y = player.y - player.speed
	end
	if (love.keyboard.isDown('a')) then
		player.x = player.x - player.speed
	end
	if (love.keyboard.isDown('s')) then
		player.y = player.y + player.speed
	end
	if (love.keyboard.isDown('d')) then
		player.x = player.x + player.speed
	end

	--Rotating. Pretty much just rotates by 2 degrees.
	if (love.keyboard.isDown('e')) then
		player.angle = player.angle + 2*math.pi/180;
	end 
	if (love.keyboard.isDown('q')) then
		player.angle = player.angle - 2*math.pi/180;
	end 

	-- Let the player control the color palette
	if (love.keyboard.isDown('1')) then
		if self.palette[1] ~= nil then
			self.color = self.palette[1];
		end
	end

	if (love.keyboard.isDown('2')) then
		if self.palette[2] ~= nil then
			self.color = self.palette[2];
		end
	end

	if (love.keyboard.isDown('3')) then
		if self.palette[3] ~= nil then
			self.color = self.palette[3];
		end
	end

	if (love.keyboard.isDown('4')) then
		if self.palette[4] ~= nil then
			self.color = self.palette[4];
		end
	end

	if (love.keyboard.isDown('5')) then
		if self.palette[5] ~= nil then
			self.color = self.palette[5];
		end
	end

	if (love.keyboard.isDown('6')) then
		if self.palette[6] ~= nil then
			self.color = self.palette[6];
		end
	end


	--Shooting. Create mini versions of yourself with direction and velocity
	if(love.mouse.isDown(1)) then
		player:shoot()
	end

	--Checking collisions
	self:check_collisions()


	--Move sprite
	self.sprite:move(self.x, self.y, self.angle)

end

function Player:draw() 
	love.graphics.setColor(self.color)
	self.sprite:draw()
end

function Player:check_collisions()

	local collidable_objs = {}
	for key, value in pairs(global_obj_array) do
		if (value.collision_group ~= self.collision_group) then
			if value.non_collidable ~= nil then
			elseif value.color ~= self.color then
				
				table.insert(collidable_objs, value)
			end
		end
	end

	for key, value in pairs(collidable_objs, value) do
		if radcheck(self, value) then
			collide(self, value)
		end
	end
end

function Player:resolve_collision(collider)
	self.hp = self.hp - 0.5
	setup_hearts();
end