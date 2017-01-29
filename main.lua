-- Might be needed first
require 'anim8'

-- Utility
require 'scripts'
require 'Animation_class'

-- Parent classes
require 'Game_object_base_class'
require 'Ground_enemy_base_class'
require 'Status_table_class'
require 'Spell_table_class'

-- Derived classes / Independents
require 'Player_class'
require 'Spells_class'
require 'Bullet_class'
require 'Polygon_class'
require 'Warrior_class'
require 'Ranger_class'
require 'Enemy_spawner_class'
require 'Wall_class'
require 'Shard_class'

-- Levels and World --
require 'Rooms'


--love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
function love.load()
-- Preloads
	love.window.setMode(1024, 768)
	music_src1 = love.audio.newSource("audio/sundara.ogg")
	music_src1:setVolume(0.0)
	music_src1:play()

-- Setup globals
	global_width = love.graphics.getWidth()
	global_height = love.graphics.getHeight()
	global_tile_size = 32
	global_width_tiles = global_width / global_tile_size
	global_height_tiles = global_height / global_tile_size
	global_palette = { {255,255,255}, {181,37,9}, {11,180,214}, {64,188,3}, {127,32,176} }
	global_obj_array = {};
	global_obj_pointer = 1;
	global_animations = {}
	global_room_transition = 60

	

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



	load_room('center')
-- This is spawning enemies for testing
end

function love.update()
	-- create a new room if you are on the door ( top row, middle of row ) ---- ( middle row, first column ) ---- ( middle row, last column) ---- (last row, middle column)
	
	if global_room_transition <= 0 then
		if on_tile(player, global_width_tiles / 2 - 1, 0) then
			load_room('top')
		elseif on_tile(player, 0, global_height_tiles / 2 - 1) then
			load_room('left')
		elseif on_tile(player, global_width_tiles - 1, global_height_tiles / 2 - 1) then
			load_room('right')
		elseif on_tile(player, global_width_tiles / 2 - 1, global_height_tiles - 1) then
			load_room('bottom')
		end
	end

	--Prevent things from moving out of the room



	-- Update moving objects
	global_room_transition = global_room_transition - 1;
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
	for i = 1, 4, 1 do
		for key, value in pairs(global_obj_array) do
			
			value:draw(i)
			
		end
	end
end

function move_objects()
	for key, value in pairs(global_obj_array) do
		value:move()

		--don't let objects move beyond walls
		if value.x > global_width - 32 then
			value.x = global_width - 32
		end
		if value.y > global_height - 32 then
			value.y = global_height - 32
		end
		if value.x < 0 + 32 then
			value.x = 0 + 32
		end
		if value.y < 0 + 32 then
			value.y = 0 + 32
		end
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