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
	player.speed = 3.5;
	player.damage = 0;
	player.angle = 0;
	player.status = Status_table.new(player)
	player.spells = Spell_table.new(player)
	player.z_index = 2;
	player.facing = "down"
	player.state = "standing"

	player.collision_group = 1
	player.bullet_refresh_speed = 15;
	player.bullet_counter = 0

	-- HUD status
	player.hp = 5
	player.max_hp = 5
	player.mp = {11, 11, 0, 0}
	player.max_mp = 100
	-- red, blue, green, purple

	-- SPRITES / ANIMATIONS
	player.hat = love.graphics.newImage("sprites/my_hat.png")

	-- running up
	player.sprite_running_up = love.graphics.newImage('sprites/wizard1.png')
	player.animation_running_up = create_animation(player.sprite_running_up, 10)

  	-- running side to side
  	player.sprite_running_side = love.graphics.newImage('sprites/wizard1_running_side.png')
	player.animation_running_side = create_animation(player.sprite_running_side, 3)

	-- running down

	-- facing side
	player.sprite_facing_side = love.graphics.newImage('sprites/wizard1_facing_side.png')

	

	--define the color palette for the player. Player character can switch between these freely.
	player.palette = global_palette

	return player
end

function Player:boomerang()
	return
end


function Player:shoot()
	if self.status:check_status('reloading') ~= true then
		local angle = math.atan2(love.mouse.getY() - self.y, love.mouse.getX() - self.x);
		--Bullet.new(self.x + xdisp, self.y + ydisp, self.N, angle, 10, self.radius / 4, self.color, 1, self.collision_group);

		if self.facing == "up" then
			Temporary_collider{x = self.x, y = self.y-32, damage = 1, radius = 32, color = self.color, effect_table = {'knocked_back', 60, data = {x = self.x, y = self.y}}}
			Animation{x = self.x, y = self.y-32, sprite = love.graphics.newImage('sprites/left_strike1.png'), angle = 0, scale_x = 1, scale_y = 1, offset_x = 16, offset_y = 16}
		elseif self.facing == "down" then
			Temporary_collider{x = self.x, y = self.y+32, damage = 1, radius = 32, color = self.color, effect_table = {'knocked_back', 60, data = {x = self.x, y = self.y}}}
			Animation{x = self.x, y = self.y+32, sprite = love.graphics.newImage('sprites/left_strike1.png'), angle = 0, scale_x = 1, scale_y = 1, offset_x = 16, offset_y = 16}
		elseif self.facing == "left" then
			Temporary_collider{x = self.x-32, y = self.y, damage = 1, radius = 32, color = self.color, effect_table = {'knocked_back', 60, data = {x = self.x, y = self.y}}}
			Animation{x = self.x-32, y = self.y, sprite = love.graphics.newImage('sprites/left_strike1.png'), angle = 0, scale_x = 1, scale_y = 1, offset_x = 16, offset_y = 16}
		elseif self.facing == "right" then
			Temporary_collider{x = self.x+32, y = self.y, damage = 1, radius = 32, color = self.color, effect_table = {'knocked_back', 60, data = {x = self.x, y = self.y}}}
			Animation{x = self.x+32, y = self.y, sprite = love.graphics.newImage('sprites/left_strike1.png'), angle = 0, scale_x = 1, scale_y = 1, offset_x = 16, offset_y = 16}
		end
		
		self.status:activate_status{'reloading'}
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
    	self.sprite_y = self.sprite_y - .025 *(2*airborne_status['timer'] - airborne_status['timer_max'])
    		--self.y = self.y - .025 *(2*self.airborne_counter - self.airborne_max)
    	
    	--self.sprite:move(self.sprite.x, self.sprite.y)


    else
    	-- TAKING DIRECTIONAL INPUT
    	-- When you press a wasd key, start running in that direction if you're not already running.
    	-- When you stop running (are not pressing a wasd key), then stop running but keep facing whichever direction you were already facing
	
		if (love.keyboard.isDown('up')) then
			--if self.state ~= "running" then
				self.state = "running"
				self.facing = "up"
			--end
		end
		if (love.keyboard.isDown('down')) then
			--if self.state ~= "running" then
				self.state = "running"
				self.facing = "down"
			--end
		end
		if (love.keyboard.isDown('left')) then
			--if self.state ~= "running" then
				self.state = "running"
				self.facing = "left"
			--end
		end
		if (love.keyboard.isDown('right')) then
			--if self.state ~= "running" then
				self.state = "running"
				self.facing = "right"
			--end
		end

		--Rotating. Pretty much just rotates by 2 degrees.
		if (love.keyboard.isDown('e')) then
			player.angle = player.angle + 2*math.pi/180;
		end 
		if (love.keyboard.isDown('q')) then
			

			player.angle = player.angle - 2*math.pi/180;
		end 

		-- CONTROLLING ELEMENTS
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
		if(love.keyboard.isDown('a')) then
			player:shoot()
		end

		if(love.keyboard.isDown('w')) then
			if self.facing == "up" then
				destination = {x = self.x, y = self.y - 250}
			elseif self.facing == "down" then
				destination = {x = self.x, y = self.y + 250}
			elseif self.facing == "left" then
				destination = {x = self.x - 250, y = self.y}
			elseif self.facing == "right" then
				destination = {x = self.x + 250, y = self.y}
			end

			if self.status:check_status('reloading') ~= true then
				Boomerang(destination)
				self.status:activate_status{'reloading'}
			end

		end

		--Spells
		if (love.keyboard.isDown('r')) then
			if self.mp[1] > 10 then
				self.status:activate_status{'airborne', 180, function() end, function() end,
					function(self) 
						--Spells:shockwave(self, self.x, self.y) 
						Temporary_collider{x = self.x, y = self.y, radius = 16, damage = 3}

						self.status:activate_status{'invincible', 60} end}
				self.status:activate_status{'jaunted', 180}
			end
		end

		if (love.keyboard.isDown('f')) then
			self.spells:cast(Freezing_field)
			
		end

		--Checking collisions
		self:check_collisions()



	--Move char and spritesprite
	--self.sprite:move(self.x, self.y, self.angle)
	if self.state == 'running' then
		if self.facing =='up' then
			self.y = self.y - self.speed
		elseif self.facing == 'down' then
			self.y = self.y + self.speed
		elseif self.facing == 'left' then
			self.x = self.x - self.speed
		elseif self.facing == 'right' then
			self.x = self.x + self.speed
		end
	end

	self.sprite_x = self.x
	self.sprite_y = self.y
	end

end

function Player:draw(i) 
	
	if i == 3 then
		if self.status:get_status('invincible')['timer'] % 5 == 0 then
			love.graphics.setColor(self.color)
		

			if self.facing == "up" then
				if self.state == "running" then
					self.animation_running_up:resume()
					self.animation_running_up:update(1)
					self.animation_running_up:draw(self.sprite_running_up, self.sprite_x, self.sprite_y, 0, 1, 1, 32, 56)
				else
					self.animation_running_up:gotoFrame(1)
					self.animation_running_up:draw(self.sprite_running_up, self.sprite_x, self.sprite_y, 0, 1, 1, 32, 56)
				end
			elseif self.facing == "down" then
				if self.state == "running" then
					self.animation_running_up:resume()
					self.animation_running_up:update(1)
					self.animation_running_up:draw(self.sprite_running_up, self.sprite_x, self.sprite_y, 0, 1, 1, 32, 56)
				else
					self.animation_running_up:gotoFrame(1)
					self.animation_running_up:draw(self.sprite_running_up, self.sprite_x, self.sprite_y, 0, 1, 1, 32, 56)
				end

			elseif self.facing == "left" then
				if self.state == "running" then
					self.animation_running_side:resume()
					self.animation_running_side:update(1)
					self.animation_running_side:draw(self.sprite_running_side, self.sprite_x, self.sprite_y, 0, 1, 1, 32, 56)
				else
					local img = self.sprite_facing_side
					local origin = {x = img:getWidth() * 0.5, y = img:getHeight() * 0.5}
					love.graphics.draw(self.sprite_facing_side, self.sprite_x, self.sprite_y, 0, 1, 1, 32, 56)
				end
			elseif self.facing == "right" then
				if self.state == "running" then
					local img = self.sprite_running_side
					local origin = {x = img:getWidth() * 0.5, y = img:getHeight() * 0.5}
					self.animation_running_side:resume()
					self.animation_running_side:update(1)
					self.animation_running_side:draw(self.sprite_running_side, self.sprite_x, self.sprite_y, 0, -1, 1, 32, 56)
				else
					local img = self.sprite_facing_side
					local origin = {x = img:getWidth() * 0.5, y = img:getHeight() * 0.5}
					love.graphics.draw(self.sprite_facing_side, self.sprite_x, self.sprite_y, 0, -1, 1, 32, 56)
				end
			end

			love.graphics.setColor(11,180,214)
			love.graphics.draw(self.hat, self.sprite_x, self.sprite_y, 0, 1, 1, 16, 72)
		end
	end
end

function Player:check_collisions()
	circle_cast(self)
end

function Player:resolve_collision(collider)
	if collider.is_shard ~= nil then
		local index = color_index(collider.color) 
		if index ~= 1 then
			if self.mp[index - 1] <= self.max_mp then
				self.mp[index - 1] = self.mp[index - 1] + 1
				setup_mana();
			end
		end
		

	elseif collider.is_item ~= nil then
		--self:pick_up(collider)
	elseif self.status:check_status('invincible') ~= true then
		self.hp = self.hp - collider.damage
		setup_hearts();
		self.status:activate_status{'invincible', 60}
	end
end

function love.keyreleased(key) 
	if key == "up" or key == "down" or key == "left" or key == "right" then
		player.state = "standing"
	end
end