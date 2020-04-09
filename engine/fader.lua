-- usage: 
-- fader:fadeInOut(func1, func2) -- run func1 when it fades to white (like load scene), runs func2 when it fades back out of white to show the new scene (like start dialog)

fader = {}

fader.timer = require "libs.hump.timer"

fader.alpha = 0
fader.color = {0,0,0}
fader.duration = 0.5;

function fader:fadeToColor(finishedCallback)
self.timer.tween(self.duration, self, {alpha = 1}, 'linear', finishedCallback)
end

function fader:fadeOutOfColor(finishedCallback)
self.timer.tween(self.duration, self, {alpha = 0}, 'linear', finishedCallback)
end

function fader:fadeInOut(func1, func2)
self:fadeToColor(function() 
	func1()
	self:fadeOutOfColor(func2)
end)
end

function fader:update(dt)
self.timer.update(dt)
end

function fader:draw()
love.graphics.push("all")
love.graphics.origin()
love.graphics.setColor( self.color[1],self.color[2],self.color[3], self.alpha )
love.graphics.rectangle( "fill", 0, 0, love.graphics.getWidth( ), love.graphics.getHeight( ) )
love.graphics.pop()
end

return fader