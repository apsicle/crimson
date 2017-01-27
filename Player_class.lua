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
	player.damage = 0;
	player.angle = 0;
	player.status = Status_table.new(player)
	player.spells = Spell_table.new(player)
	player.z_index = 2;

	player.collision_group = 1
	player.bullet_refresh_speed = 15;
	player.bullet_counter = 0

	-- HUD status
	player.hp = 5
	player.max_hp = 5
	player.mp = {11, 11, 0, 0}
	player.max_mp = 100
	-- red, blue, green, purple

	-- Sprite
	player.hat = love.graphics.newImage("sprites/my_hat.png")
	player.sprite = Polygon.new(player.x, player.y, player.N, player.radius)
	player.spell_animation = nil

	--define the color palette for the player. Player character can switch between these freely.
	player.palette = global_palette

	return player
end

function Player:boomerang()
	return
end


function Player:shoot()
	if 1==1 then
		local angle = math.atan2(love.mouse.getY() - self.y, love.mouse.getX() - self.x);
		local xdisp = math.cos(angle) * self.radius / 2
		local ydisp = math.sin(angle) * self.radius / 2
		Bullet.new(self.x + xdisp, self.y + ydisp, self.N, angle, 10, self.radius / 4, self.color, 1, self.collision_group);
		
		self.bullet_counter = self.bullet_refresh_speed
	end
end

function Player:update()
	self.status:update()
	--print_table(self.status:get_status('invincible'))


	if self.hp <= 0 then
		global_obj_array[self.global_index] = nil
	end

end

function Player:move()

	-- Player controls. I figure I'll just put this on the first layer, ie. in update, so there's the least overhead as possible?
	-- Movement:
    if (self.status:check_status('airborne')) then
    	

    		--self.y = self.y + .1*(.5*self.airborne_max - self.airborne_counter)
    		--self.y = self.y - .001*(self.airborne_counter)*(self.airborne_counter - self.airborne_max) + (-0.25*0.001*sq(self.airborne_max))

    	local airborne_status = player.status:get_status('airborne')
    	self.sprite.y = self.sprite.y - .025 *(2*airborne_status['timer'] - airborne_status['timer_max'])
    		--self.y = self.y - .025 *(2*self.airborne_counter - self.airborne_max)
    	
    	self.sprite:move(self.sprite.x, self.sprite.y)


    else


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

		--Shooting. Create mini versions of yourself with direction and velocity
		if(love.mouse.isDown(1)) then
			player:shoot()
		end

		if(love.mouse.isDown(2)) then
			player:boomerang()
		end

		--Spells
		if (love.keyboard.isDown('r')) then
			if self.mp[1] > 10 then
				self.status:activate_status('airborne', 180, 
					function(self) 
						--Spells:shockwave(self, self.x, self.y) 
						self.status:activate_status('invincible', 60) end)
				self.status:activate_status('jaunted', 180)
			end
		end

		if (love.keyboard.isDown('f')) then
			self.spells:cast(Freezing_field)
			
		end

		--Checking collisions
		self:check_collisions()



	--Move sprite
	self.sprite:move(self.x, self.y, self.angle)
	end

end

function Player:draw() 
	
	
	love.graphics.setColor(self.color)
	self.sprite:draw()
	love.graphics.setColor(11,180,214)
	love.graphics.draw(self.hat, self.sprite.x-self.radius, self.sprite.y-self.radius*2)
end



function Player:check_collisions()

	local collidable_objs = {}
	for key, value in pairs(global_obj_array) do
		if value ~= nil then
			if (value.collision_group ~= self.collision_group) then
				if value.item ~= nil then
					--player object is the only object that can collide with items
					table.insert(collidable_objs, value)
				elseif value.is_shard ~= nil then
					--player object collides with shards no matter what
					table.insert(collidable_objs, value)
				elseif value.color ~= self.color then
					--if you are different colors, you can collide
					table.insert(collidable_objs, value)
				end
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
	if collider.is_shard ~= nil then
		local index = color_index(collider.color)
		if self.mp[index - 1] <= self.max_mp then
			self.mp[index - 1] = self.mp[index - 1] + 1
			setup_mana();
		end
		

	elseif collider.is_item ~= nil then
		--self:pick_up(collider)
	elseif self.status:check_status('invincible') ~= true then
		self.hp = self.hp - collider.damage
		setup_hearts();
		self.status:activate_status('invincible', 60, function() print("finished") end)
	end
end

