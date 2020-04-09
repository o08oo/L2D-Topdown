-- http://lua.space/gamedev/using-tiled-maps-in-love

--HC = require 'HC'
--local sti = require "sti"
local humpcamera = require "libs.hump.camera"
local anim8 = require "libs.anim8.anim8"

local dialog = require "engine.dialog"
local ifield = require "engine.interactfield"
local scene = require "engine.scene"
local fader = require "engine.fader"

local textarray1= {{"Hello! A typewriter is typing this. \nBye!"}, {"test test test", function() love.graphics.setBackgroundColor( 0, 0, 255, 255 ) end}}

-- array to hold collision messages
local text = {}


local canmove = true

local camsmoothing = humpcamera.smooth.none()
local zoom = 1;

function love.load()
love.graphics.setDefaultFilter( "nearest", "nearest" )
zoom = 2;

dnext = love.graphics.newImage("assets/next.png")
bg1 = love.graphics.newImage("assets/map.png")
bg2 = love.graphics.newImage("assets/map2.png")
dialog.typeTimerMax = 0.2
dialog.endcallback = function() canmove=true end


----playergraphic = love.graphics.newImage("assets/spritetest2.png")
	
	

    -- add a circle to the scene
    mouse = scene.HC.rectangle(400,300,16,16)
    mouse:moveTo(200,300)
	
	scene:load("assets/map.lua",mouse)
	scene.bgimage = bg1
	--scene.camsmoothing = scene.humpcamera.smooth.damped(3)
	-- add a rectangle to the scene
    rect = scene.HC.rectangle(200,400,400,20)
	
	 npc = scene.HC.rectangle(400,300,16,16)
    npc:moveTo(300,300)
	--npc.interactfunc = function() love.graphics.setBackgroundColor( 0, 0, 255, 1 ) end
	npc.interactfunc = function()
		canmove=false
		dialog.textarray= textarray1
		dialog:start() 
	end
	
	door1 = scene.HC.rectangle(400,200,16,16)
	door1.interactfunc = function()
		canmove=false
		fader:fadeInOut(function()
			scene:clear()
			scene:load("assets/map2.lua",mouse)
			scene.bgimage = bg2
		end, function() canmove = true end)
	end
	
	ifield.target = mouse
	ifield.width=42
	ifield.height=ifield.width
	
	camera = humpcamera(mouse._polygon.centroid.x, mouse._polygon.centroid.y, zoom)
--scene.player = mouse

	
end

function love.update(dt)

fader:update(dt)

local speed = 200;
if (canmove) then
if love.keyboard.isDown("down") then
    mouse:move(0, speed*dt)
	end
  if love.keyboard.isDown("up") then
    mouse:move(0, -speed*dt)
  end

  if love.keyboard.isDown("right")  then
    mouse:move(speed*dt, 0)
	end
  if love.keyboard.isDown("left") then
    mouse:move(-speed*dt, 0)
  end
 end

--ifield.x=mouse.x
--ifield.y=mouse.y
    -- move circle to mouse position
   -- mouse:moveTo(love.mouse.getPosition())

    -- rotate rectangle
    --rect:rotate(dt)

    -- check for collisions
    scene:update(dt)
	
	camera:lockPosition(mouse._polygon.centroid.x, mouse._polygon.centroid.y, scene.camsmoothing)
	
	ifield:update(dt,mouse._polygon.centroid.x - ifield.width/2,mouse._polygon.centroid.y - ifield.height/2)

    while #text > 40 do
        table.remove(text, 1)
    end
	
	dialog:update(dt)
end

function love.draw()
--map:draw()
    -- print messages
    for i = 1,#text do
        love.graphics.setColor(255,255,255, 255 - (i-1) * 6)
        love.graphics.print(text[#text - (i-1)], 10, i * 15)
    end
	
	camera:attach()
	
	scene:draw()
	
	love.graphics.rectangle( "fill", ifield.x, ifield.y, ifield.width, ifield.height )

    -- shapes can be drawn to the screen
    love.graphics.setColor(255,255,255)
    rect:draw('fill')
	love.graphics.setColor(255,0,255)
    mouse:draw('fill')
	love.graphics.setColor(255,0,0)
    npc:draw('fill')
	love.graphics.setColor(255,255,0)
    door1:draw('fill')
	
	-- player image
	love.graphics.setColor(255,255,255)
	----love.graphics.draw( playergraphic, mouse._polygon.vertices[2].x+(mouse._polygon.vertices[4].x-mouse._polygon.vertices[2].x)/2-playergraphic:getWidth()/2, mouse._polygon.vertices[2].y+(mouse._polygon.vertices[4].y-mouse._polygon.vertices[2].y)-playergraphic:getHeight())
	
	camera:detach()
	--love.graphics.setColor(0,255,0)
	--love.graphics.rectangle( "fill",npc._polygon.vertices[2].x,npc._polygon.vertices[2].y,npc._polygon.vertices[4].x-npc._polygon.vertices[2].x,npc._polygon.vertices[4].y-npc._polygon.vertices[2].y)
	
	
	if (dialog.hidden~=true) then
love.graphics.setColor( 0, 0, 0, 0.5 )
love.graphics.rectangle( "fill", 0, love.graphics.getHeight( )-100-20, love.graphics.getWidth( ), love.graphics.getHeight( ) )
love.graphics.setColor( 255, 255, 255, 255 )
    	dialog:draw(20,love.graphics.getHeight( )-100,love.graphics.getWidth( )-20*2)
if (dialog.finished==true) then
--love.graphics.print(">",love.graphics.getWidth( )-20,love.graphics.getHeight( )-20)
love.graphics.draw( dnext, love.graphics.getWidth( )-30,love.graphics.getHeight( )-20 )
end
end

fader:draw()

end


function love.keyreleased(key)
   if key == "e" then
      if (canmove) then
      ifield:check(npc._polygon.vertices[2].x,npc._polygon.vertices[2].y,npc._polygon.vertices[4].x-npc._polygon.vertices[2].x,npc._polygon.vertices[4].y-npc._polygon.vertices[2].y,npc.interactfunc)
	  
      ifield:check(door1._polygon.vertices[2].x,door1._polygon.vertices[2].y,door1._polygon.vertices[4].x-door1._polygon.vertices[2].x,door1._polygon.vertices[4].y-door1._polygon.vertices[2].y,door1.interactfunc)
	  else 
	  dialog:nexttext()
	  end
   end
end

