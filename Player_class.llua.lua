Player = {}

function Player.new (x, y, N) 
	player = {}
	setmetatable(player, {__index = Player})
	player.x = love.graphics.getWidth() / 2
	player.y = love.graphics.getHeight() / 2
	player.N = 4
	player.size = 16;
	player.speed = 5;
	return player
end

function Player:shoot()
	for i = 1, 4, 1 do
		Bullet.new(self.x, self.y, (math.pi/2) * i, 30);
	end
end


function Player:draw() 
	love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end