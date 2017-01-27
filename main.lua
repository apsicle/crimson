-- Might be needed first
require 'anim8'
require 'scripts'

-- Parent classes
require 'Game_object_base_class'
require 'Ground_enemy_base_class'
require 'Status_table_class'

-- Derived classes / Independents
require 'Player_class'
require 'Spells_class'
require 'Bullet_class'
require 'Polygon_class'
require 'Warrior_class'
require 'Ranger_class'
require 'Enemy_spawner_class'
require 'Inanimate_class'
require 'Shard_class'


--love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
function love.load()
-- Preloads
	love.window.setMode(1024, 768)
	music_src1 = love.audio.newSource("audio/sundara.ogg")
	music_src1:play()

-- Setup globals
	global_width = love.graphics.getWidth()
	global_height = love.graphics.getHeight()
	global_palette = { {255,255,255}, {181,37,9}, {11,180,214}, {64,188,3}, {127,32,176} }
	global_obj_array = {};
	global_obj_pointer = 1;
	global_animations = {}

	

-- love.window.getWidth doesn't work. So I think the graphics window is different from 'Window'. What exactly is "draw" doing? How does it open a window and
-- where is the window object stored?

-- Setup room
	--love.graphics.setBackgroundColor(250, 128, 114);

	--love.graphics.setBackgroundColor(0, 0, 0);
	
	player = Player.new()
	player.global_index = add_object(global_obj_array, global_obj_pointer, player)
	Ground_enemy_base(player.x, player.y)

-- Setup HUD
	

	-- HP BAR
	hearts = love.graphics.newImage("sprites/heart_atlas.png")
	heart_atlas = love.graphics.newSpriteBatch( hearts, 5 )
	heart_quads = {}
	heart_quads[1] = love.graphics.newQuad(2, 0, 40, hearts:getHeight(), hearts:getDimensions())
	heart_quads[2] = love.graphics.newQuad(42, 0, 40, hearts:getHeight(), hearts:getDimensions())
	heart_quads[3] = love.graphics.newQuad(80, 0, 40, hearts:getHeight(), hearts:getDimensions())
	
	setup_hearts()

	-- MANA BAR
	manabars = love.graphics.newImage("sprites/manabars_atlas.png")
	mana = love.graphics.newImage("sprites/mana_atlas.png")
	mana_atlas = love.graphics.newSpriteBatch( mana, 4 )
	mana_quads = {}
	mana_quads[1] = love.graphics.newQuad(0, 0, 40, mana:getHeight(), mana:getDimensions())
	mana_quads[2] = love.graphics.newQuad(40, 0, 40, mana:getHeight(), mana:getDimensions())
	mana_quads[3] = love.graphics.newQuad(80, 0, 40, mana:getHeight(), mana:getDimensions())
	mana_quads[4] = love.graphics.newQuad(120, 0, 40, mana:getHeight(), mana:getDimensions())

	setup_mana()

	-- TERRAIN
	full_terrain = love.graphics.newImage("sprites/terrain_atlas.png")
	atlas_size = 1024
	tile_size = 32

    terrain_atlas = love.graphics.newSpriteBatch( full_terrain, atlas_size )
   

    --(1) CAVES--
    --18, 6 is start of cave. Goes 3 across, 6 down. (ie. ends at 20, 11)
    cave_quads = {}

    -- Laid on top, rocks
	cave_quads[1] = love.graphics.newQuad(18 * tile_size, 6 * tile_size, tile_size,  tile_size,
    full_terrain:getDimensions())
    cave_quads[2] = love.graphics.newQuad(18 * tile_size, 7 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    
    -- Center piece: hole, 2x2
    cave_quads[3] = love.graphics.newQuad(19 * tile_size, 6 * tile_size, 2 * tile_size, 2 * tile_size,
    full_terrain:getDimensions())
    
    -- Top wall, left corner to middle wall to right wall
    cave_quads[4] = love.graphics.newQuad(18 * tile_size, 8 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    cave_quads[5] = love.graphics.newQuad(19 * tile_size, 8 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    cave_quads[6] = love.graphics.newQuad(20 * tile_size, 8 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())

    -- Left wall middle piece
    cave_quads[7] = love.graphics.newQuad(18 * tile_size, 9 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())

    -- Right wall middle piece
    cave_quads[8] = love.graphics.newQuad(20 * tile_size, 9 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())

    -- Bottom wall, left corner to middle wall to right wall
    cave_quads[9] = love.graphics.newQuad(18 * tile_size, 10 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    cave_quads[10] = love.graphics.newQuad(19 * tile_size, 10 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    cave_quads[11] = love.graphics.newQuad(20 * tile_size, 10 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())

    -- Center pieces, arbitrary. [12] has decoration (cracks)
    cave_quads[12] = love.graphics.newQuad(18 * tile_size, 11 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    cave_quads[13] = love.graphics.newQuad(19 * tile_size, 11 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    cave_quads[14] = love.graphics.newQuad(20 * tile_size, 11 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    cave_quads[15] = love.graphics.newQuad(19 * tile_size, 9 * tile_size, tile_size, tile_size, 
    full_terrain:getDimensions())

    cave_center_arr = {{12, 0.02}, {13, 0.34}, {14, 0.32}, {15, 0.32}}

	setup_terrain(cave_quads, cave_center_arr)


	--(2) GRASS--
	grass_quads = {}

    -- Laid on top, rocks
	grass_quads[1] = love.graphics.newQuad(21 * tile_size, 6 * tile_size, tile_size,  tile_size,
    full_terrain:getDimensions())
    grass_quads[2] = love.graphics.newQuad(21 * tile_size, 7 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    
    -- Center piece: hole, 2x2
    grass_quads[3] = love.graphics.newQuad(22 * tile_size, 6 * tile_size, 2 * tile_size, 2 * tile_size,
    full_terrain:getDimensions())
    
    -- Top wall, left corner to middle wall to right wall
    grass_quads[4] = love.graphics.newQuad(21 * tile_size, 8 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    grass_quads[5] = love.graphics.newQuad(22 * tile_size, 8 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    grass_quads[6] = love.graphics.newQuad(23 * tile_size, 8 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())

    -- Left wall middle piece
    grass_quads[7] = love.graphics.newQuad(21 * tile_size, 9 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())

    -- Right wall middle piece
    grass_quads[8] = love.graphics.newQuad(23 * tile_size, 9 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())

    -- Bottom wall, left corner to middle wall to right wall
    grass_quads[9] = love.graphics.newQuad(21 * tile_size, 10 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    grass_quads[10] = love.graphics.newQuad(22 * tile_size, 10 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    grass_quads[11] = love.graphics.newQuad(23 * tile_size, 10 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())

    -- Center pieces, arbitrary. [12] has decoration (cracks)
    grass_quads[12] = love.graphics.newQuad(21 * tile_size, 11 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    grass_quads[13] = love.graphics.newQuad(22 * tile_size, 11 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    grass_quads[14] = love.graphics.newQuad(23 * tile_size, 11 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    grass_quads[15] = love.graphics.newQuad(22 * tile_size, 9 * tile_size, tile_size, tile_size, 
    full_terrain:getDimensions())

    -- Decorative pieces.
    grass_quads[16] = love.graphics.newQuad(2 * tile_size, 25 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    grass_quads[17] = love.graphics.newQuad(21 * tile_size, 5 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
    grass_quads[18] = love.graphics.newQuad(22 * tile_size, 5 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())
 	grass_quads[19] = love.graphics.newQuad(23 * tile_size, 5 * tile_size, tile_size, tile_size,
    full_terrain:getDimensions())


    grass_center_arr = {{12, 0.04}, {13, 0.04}, {14, 0.04}, {15, 0.22}, {16, 0.09}, {17, 0.19}, {18, 0.19}, {19, 0.19}}
	--setup_terrain(grass_quads, grass_center_arr)



-- This is spawning enemies for testing
	Ranger.new(500, 150, 5, 2, 16, global_palette[love.math.random(1, 5)], 1, 3)
	Enemy_spawner.new(200, 150, 3, 4, 16, global_palette[love.math.random(1, 5)], 2)
	Enemy_spawner.new(600, 150, 3, 4, 16, global_palette[love.math.random(1, 5)], 2)
	Enemy_spawner.new(350, 450, 3, 4, 16, global_palette[love.math.random(1, 5)], 2)
end

function love.update()
	
	--Create an object on mouse press


	-- Update moving objects
	print('updating')
	update_objects();
	move_objects();

end

function love.draw()


	love.graphics.setColor(255,255,255)
	love.graphics.draw(terrain_atlas)
	
	draw_objects();

	love.graphics.setColor(255,255,255)
	--love.graphics.draw(image, x_pos, y_pos, rotation, scalex, scaley, xoffset, yoffset from origin)
	
	love.graphics.draw(manabars, global_width - manabars:getWidth() * 0.8, -10, 0, 1, 1)
	love.graphics.draw(mana_atlas, global_width - manabars:getWidth() * 0.8, -10, 0, 1, 1)
	love.graphics.draw(heart_atlas)

end



-- Unique callbacks
function draw_objects()
	for i = 1, 3, 1 do
		for key, value in pairs(global_obj_array) do
			if value.z_index == i then
				value:draw()
			end
		end
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

function setup_mana()
	mana_atlas:clear()

	local mana = player.mp

	for i = 1, 4, 1 do
		mana_atlas:add(mana_quads[i], (i-1) * 40, (134 - mana[i]), 0, 1, mana[i])
	end
end

function setup_terrain(terrain_quads, center_arr)
	terrain_atlas:clear()

	local max_y = global_height / tile_size
	local max_x = global_width / tile_size

	for j = 1, max_y, 1 do 
		for i = 1, max_x, 1 do
			if j == 1 then
				--top row
				if i == 1 then
					--top left corner
					terrain_atlas:add(terrain_quads[4], (i-1) * tile_size, (j-1) * tile_size)
				elseif i ~= max_x then
					--middle of row
					terrain_atlas:add(terrain_quads[5], (i-1) * tile_size, (j-1) * tile_size)
				else
					--top right corner
					terrain_atlas:add(terrain_quads[6], (i-1) * tile_size, (j-1) * tile_size)
				end

			elseif j ~= max_y then
				--middle rows
				if i == 1 then
					--left middle walls
					terrain_atlas:add(terrain_quads[7], (i-1) * tile_size, (j-1) * tile_size)
				elseif i ~= max_x then
					
						--middle rows, middle elements (randomize!)
						
						local randint = sample(center_arr)
						terrain_atlas:add(terrain_quads[randint], (i-1) * tile_size, (j-1) * tile_size)

				else
					--right middle walls
					terrain_atlas:add(terrain_quads[8], (i-1) * tile_size, (j-1) * tile_size)
				end

			else
				--bottom row
				if i == 1 then
					--top left corner
					terrain_atlas:add(terrain_quads[9], (i-1) * tile_size, (j-1) * tile_size)

				elseif i ~= max_x then
					--middle of row
					terrain_atlas:add(terrain_quads[10], (i-1) * tile_size, (j-1) * tile_size)
				else
					--top right corner
					terrain_atlas:add(terrain_quads[11], (i-1) * tile_size, (j-1) * tile_size)
				end
			end
		end
	end
	local x = love.math.random()

end


