require 'Player_class'
require 'Bullet_class'
require 'Polygon_class'
require 'Warrior_class'
require 'Enemy_class'
require 'Enemy_spawner_class'
require 'Inanimate_class'
require 'Shard_class'
require 'scripts'


function love.load()
-- Preloads
	music_src1 = love.audio.newSource("audio/sundara.ogg")
	music_src1:play()



-- Setup globals
	global_width = love.graphics.getWidth()
	global_height = love.graphics.getHeight()
	global_palette = { {255,255,255}, {0, 0, 255}, {0, 255, 0}, {255, 255, 0}, {255, 127, 0}, {255, 0 , 0} }
	global_obj_array = {};
	global_obj_pointer = 1;

	

-- love.window.getWidth doesn't work. So I think the graphics window is different from 'Window'. What exactly is "draw" doing? How does it open a window and
-- where is the window object stored?

-- Setup room
	love.graphics.setBackgroundColor(250, 128, 114);
	
	player = Player.new()
	player.global_index = add_object(global_obj_array, global_obj_pointer, player)


-- Setup HUD
	manabar = love.graphics.newImage("sprites/manabar1.png")
	hearts = love.graphics.newImage("sprites/heart_atlas.png")
	heart_atlas = love.graphics.newSpriteBatch( hearts, 5 )
	heart_quads = {}
	heart_quads[1] = love.graphics.newQuad(2, 0, 40, hearts:getHeight(), hearts:getDimensions())
	heart_quads[2] = love.graphics.newQuad(42, 0, 40, hearts:getHeight(), hearts:getDimensions())
	heart_quads[3] = love.graphics.newQuad(80, 0, 40, hearts:getHeight(), hearts:getDimensions())

	heart_atlas:add(heart_quads[1], 0, 0)
	heart_atlas:add(heart_quads[2], 42, 0)
	heart_atlas:add(heart_quads[3], 80, 0)
	setup_hearts()


-- This is spawning enemies for testing
	Enemy_spawner.new(200, 150, 3, 4, 16, 2, global_palette[love.math.random(1, 6)])
	Enemy_spawner.new(600, 150, 3, 4, 16, 2, global_palette[love.math.random(1, 6)])
	Enemy_spawner.new(350, 450, 3, 4, 16, 2, global_palette[love.math.random(1, 6)])
end

function love.update()
	
	--Create an object on mouse press


	-- Update moving objects
	update_objects();
	move_objects();

end

function love.draw()
	draw_objects();
	for i = 1, 4, 1 do			
		love.graphics.setColor(255,255,255)
		love.graphics.draw(manabar, global_width - 95 - i * 35, -12, 0, 1, 1)
	end
	love.graphics.draw(heart_atlas)
end



-- Unique callbacks
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

function check_collision_objects()
	for key, value in pairs(global_obj_array) do
		check_collision(value)
	end
end
	
--paint gun vs destruction gun.
--paint mode paints things diff colors
--destruction gun is your standard gun. destroys things of your same color, can pick up powerups for this.

-- Functions
function setup_hearts()
	heart_atlas:clear()

	local hp = player.hp
	local whole, frac = math.modf(hp);
	local empty = math.ceil(player.max_hp - hp)

	local xpos = -40;
	for i = 1, whole, 1 do
		xpos = xpos + 40
		heart_atlas:add(heart_quads[1], xpos, 0)
	end
	if frac ~= 0 then
		xpos = xpos + 40
		heart_atlas:add(heart_quads[2], xpos, 0)
	end

	for i = 1, empty, 1 do
		xpos = xpos + 40
		heart_atlas:add(heart_quads[3], xpos, 0)
	end
end
