require 'Player_class'
require 'Bullet_class'
require 'Polygon_class'
require 'Enemy_class'
require 'Enemy_spawner_class'
require 'Inanimate_class'
require 'scripts'


function love.load()
-- Preloads


-- this is a comment
	global_width = love.graphics.getWidth()
	global_height = love.graphics.getHeight()
	global_obj_array = {};
	global_obj_pointer = 1;
	player = Player.new()
	player.global_index = add_object(global_obj_array, global_obj_pointer, player)
	
	north_wall = Inanimate.new(-10, -10, 0, 0, global_width, 0 , global_width + 10, -10)
	south_wall = Inanimate.new(-10, global_height + 10, 0, global_height, global_height, global_width, global_width + 10, global_height + 10)
	west_wall = Inanimate.new(-10, -10, 0, 0, 0, global_height, -10, global_height + 10)
	east_wall = Inanimate.new(global_width + 10, -10, global_width, 0, global_width, global_height, global_width + 10, global_height + 10)

-- love.window.getWidth doesn't work. So I think the graphics window is different from 'Window'. What exactly is "draw" doing? How does it open a window and
-- where is the window object stored?
	
end

function love.update()
	-- Player controls. I figure I'll just put this on the first layer, ie. in update, so there's the least overhead as possible?
	-- Movement:
	if (love.keyboard.isDown('up')) then
		player.y = player.y - player.speed
	end
	if (love.keyboard.isDown('left')) then
		player.x = player.x - player.speed
	end
	if (love.keyboard.isDown('down')) then
		player.y = player.y + player.speed
	end
	if (love.keyboard.isDown('right')) then
		player.x = player.x + player.speed
	end

	--Shooting. Create mini versions of yourself with direction and velocity
	if(love.keyboard.isDown('w')) then
		player:shoot()
	end

	--Create an object on mouse press


	-- Update moving objects
	update_objects();
	move_objects();

end

function love.draw()
	draw_objects();
	player:draw();
end

-- Unique callbacks
function love.mousepressed(x, y, button, istouch)
	Enemy_spawner.new(x, y, 3, 4, 16)

end

function draw_objects()
	for key, value in pairs(global_obj_array) do
		value:draw()
	end
end

function move_objects()
	for key, value in pairs(global_obj_array) do
		value:move()
	end
end
	
function update_objects()
	for key, value in pairs(global_obj_array) do
		value:update()
	end
end
	