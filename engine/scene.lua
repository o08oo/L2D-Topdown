local scene = {}

scene.HC = require 'libs.HC'
scene.sti = require "libs.sti"

scene.walls = {}
scene.soliddoors = {}
--scene.camsmoothing = scene.humpcamera.smooth.damped(3)


function scene:clear()
for i = 1,#self.walls do
	self.HC.remove(self.walls[i])
	--local hash = scene.HC:hash()
	--hash:remove(self.walls[i], self.walls[i]:bbox())
	--self.player:moveTo(self.walls[i]._polygon.centroid.x,self.walls[i]._polygon.centroid.y)
end
self.walls = {}
end

function scene:load(mapfile, player)
self.map = scene.sti(mapfile)
self.player = player
self.soliddoors = {}


for k, object in pairs(self.map.objects) do
        if object.name == "player" then
            --local player = object
			self.player:moveTo(object.x,object.y)
            break
        end
		if object.name == "door" then
			local door = self.HC.rectangle(object.x,object.y,object.width,object.height)
			--door.leadsto = "scene2"
			--door.coordsonnextmap = {20,20}
            table.insert(self.soliddoors, door) 
            break
        end
		table.insert(self.walls, self.HC.rectangle(object.x,object.y,object.width,object.height)) 
    end
	--self.HC:remove(self.walls[1])
	
end

function scene:update(dt)
self.map:update(dt)
    for shape, delta in pairs(self.HC.collisions(mouse)) do
        --text[#text+1] = string.format("Colliding. Separating vector = (%s,%s)",delta.x, delta.y)
		self.player:move(delta.x, delta.y)
    end
	
end

function scene:draw()
love.graphics.setColor(255,255,255)
love.graphics.draw( self.bgimage, 0,0 )
	for i = 1,#self.walls do
	love.graphics.setColor(255,255,255)
       -- self.walls[i]:draw('fill')
    end
end

return scene