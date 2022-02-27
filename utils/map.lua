Class = require("libs.hump.class")
Gamestate = require("libs.hump.gamestate")
STI = require("libs.sti")
Moonshine = require("libs.moonshine")
Camera = require("libs.hump.camera")


zoomFactor = 3
player = {
  x=0,
  y=0,
  sprite=love.graphics.newImage("assets/images/player_demo.png"),
  speed=5
}
windowWidth, windowHeight = love.graphics.getDimensions()

w = windowWidth/zoomFactor
h = windowHeight/zoomFactor


Map = Class {
  init = function(self, mapName) -- TODO pass map instance parameter
    effect = Moonshine(windowWidth, windowHeight, Moonshine.effects.crt)
                    .chain(Moonshine.effects.vignette)
                    .chain(Moonshine.effects.scanlines)
                    .chain(Moonshine.effects.chromasep)
    effect.scanlines.thickness = .2
    effect.scanlines.opacity = .5
    effect.chromasep.angle = 1
    effect.chromasep.radius = 2
    camera = Camera()
    camera:zoom(zoomFactor)
    currentMap = STI("assets/maps/"..mapName..".lua")
    if currentMap.layers["entities"] then
        for i,obj in pairs(currentMap.layers["entities"].objects) do
          player.x = obj.x
          player.y = obj.y
        end
    end
  end,
  entities={}
}

function Map:update(dt)
  if love.keyboard.isDown("up") then
    player.y = player.y - player.speed
  end

  if love.keyboard.isDown("down") then
    player.y = player.y + player.speed
  end

  if love.keyboard.isDown("left") then
    player.x = player.x - player.speed
  end

  if love.keyboard.isDown("right") then
    player.x = player.x + player.speed
  end

  camera:lookAt(player.x, player.y)
  currentMap:update(dt)

  if camera.x < w/2 then
    camera.x = w/2
  end

  if camera.y < h/2 then
    camera.y = h/2
  end

  local mapWidth = currentMap.width * currentMap.tilewidth
  local mapHeight = currentMap.height * currentMap.tileheight

  if camera.x > (mapWidth - w/2) then
    camera.x = (mapWidth - w/2)
  end

  if camera.y > (mapHeight - h/2) then
    camera.y = (mapHeight - h/2)
  end
end

function Map:draw()
  effect(function()
    camera:attach()      
      currentMap:drawLayer(currentMap.layers["ground"])
      love.graphics.draw(player.sprite, player.x, player.y)    
    camera:detach()
  end)
end

function Map:keypressed(key, scancode)
end

return Map