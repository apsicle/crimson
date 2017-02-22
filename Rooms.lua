-- ROOMS --

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

	--setup_terrain(cave_quads, cave_center_arr)


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

function setup_terrain(terrain_quads, center_arr)
    terrain_atlas:clear()

    local max_y = global_height / tile_size
    local max_x = global_width / tile_size

    for i = 1, max_y, 1 do 
        for j = 1, max_x, 1 do
            if i == 1 then
                --top row
                if j == 1 then
                    --top left corner
                    terrain_atlas:add(terrain_quads[4], (j-1) * tile_size, (i-1) * tile_size)
                elseif j ~= max_x and j ~= max_x / 2 then
                    --middle of row
                    terrain_atlas:add(terrain_quads[5], (j-1) * tile_size, (i-1) * tile_size)
                else
                    --top right corner
                    terrain_atlas:add(terrain_quads[6], (j-1) * tile_size, (i-1) * tile_size)
                end

            elseif i ~= max_y then
                --middle rows
                if j == 1 then
                    --left middle row walls except center of left wall
                    if i ~= max_y / 2 then
                        terrain_atlas:add(terrain_quads[7], (j-1) * tile_size, (i-1) * tile_size)
                    else
                        ---draw empty door here
                    end
                elseif j ~= max_x then 
                    
                        --middle rows, middle elements (randomize!)
                        
                        local randint = sample(center_arr)
                        terrain_atlas:add(terrain_quads[randint], (j-1) * tile_size, (i-1) * tile_size)

                else
                    if i ~= max_y / 2 then
                        --right middle walls
                        terrain_atlas:add(terrain_quads[8], (j-1) * tile_size, (i-1) * tile_size)
                    else
                        -- draw empty door here
                    end
                end

            else
                --bottom row
                if j == 1 then
                    --top left corner
                    terrain_atlas:add(terrain_quads[9], (j-1) * tile_size, (i-1) * tile_size)

                elseif j ~= max_x then
                    if j ~= max_x / 2 then
                        
                        terrain_atlas:add(terrain_quads[10], (j-1) * tile_size, (i-1) * tile_size)
                    else
                        -- draw empty door here
                    end
                else
                    --top right corner
                    terrain_atlas:add(terrain_quads[11], (j-1) * tile_size, (i-1) * tile_size)
                end
            end
        end
    end
    local x = love.math.random()

end

function load_room(direction)
    clear_all();
    global_room_transition = 60
    if math.random() < 0.5 then
        setup_terrain(grass_quads, grass_center_arr)
    else
        setup_terrain(cave_quads, cave_center_arr)
    end

    if direction == 'right' then
        --move to left side of map
        player.x = 0
        player.y = (global_height_tiles - 1)*32 / 2
    elseif direction == 'bottom' then
        --move to top of map
        player.x = (global_width_tiles - 1) * 32 / 2
        player.y = 0
    elseif direction == 'left' then
        --move to right of map
        player.x = (global_width_tiles - 1) * 32
        player.y = (global_height_tiles - 1) * 32 / 2
    elseif direction == 'top' then
        --move to bottom of map
        player.x = (global_width_tiles - 1) * 32 / 2
        player.y = (global_height_tiles - 1) * 32
   

    elseif direction == 'center' then
        player.x = global_width / 2
        player.y = global_height / 2
    end

    --Ranger(500, 150, 5, 2, 16, global_palette[love.math.random(1, 5)], 1, 3)
    local ghosts = math.random(2,4)
    for i = 1, ghosts, 1 do
        Loopy_ghost_spawner.new(math.random(100, 600), math.random(150, 500), 0, 16, global_palette[love.math.random(1, 5)], 2)
    end
    local rangers = math.random(0, 1)
    for i = 1, rangers, 1 do
        Ranger(math.random(200, 600), math.random(150, 500), 5, 2, 16, global_palette[love.math.random(1, 5)], 1, 2)
    end
   


end

Rooms_loader = {}
function Rooms_loader.room1()
    clear_all();
    global_room_transition = 60
    setup_terrain(cave_quads, cave_center_arr)


    

    Loopy_ghost.new(400, 400, 1, 16, self.color, 0.5, 2)
end