Polygon = {}
--this is a sprite class. It just follows around objects and displays them. it doesn't do collisions! Collisions
--are handled by the objects themselves.

function Polygon.new(x, y, N, radius)
	polygon = {}
	setmetatable(polygon, {__index = Polygon})

	polygon.x = x
	polygon.y = y
	polygon.N = N
	polygon.radius = radius
	polygon.inner_angle = (N-2) * math.pi / N
	polygon.useful_angle = (math.pi * 2) / N
	polygon.vertices = {}

	for i = 1, N, 1 do
		x_vert = x + math.cos(polygon.useful_angle * i) * polygon.radius
		y_vert = y + math.sin(polygon.useful_angle * i) * polygon.radius
		table.insert(polygon.vertices, 2*i - 1, x_vert)
		table.insert(polygon.vertices, 2*i, y_vert)
	end
	return polygon
end

function Polygon:draw()
	love.graphics.polygon("fill", self.vertices)
end

function Polygon:move(x, y)
	self.x = x
	self.y = y
		for i = 1, self.N, 1 do
			x_vert = self.x + math.cos(self.useful_angle * i) * self.radius
			y_vert = self.y + math.sin(self.useful_angle * i) * self.radius
			self.vertices[2*i - 1] = x_vert
			self.vertices[2*i] = y_vert
		end
end