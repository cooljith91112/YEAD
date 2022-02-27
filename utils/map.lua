Class = require("libs.hump.class")
Gamestate = require("libs.hump.gamestate")
STI = require("libs.sti")
Moonshine = require("libs.moonshine")
Camera = require("libs.hump.camera")
Windfield = require("libs.windfield")

zoomFactor = 2
player = {
  x=0,
  y=0,
  sprite=love.graphics.newImage("assets/images/player_demo.png"),
  speed=100
}

windowWidth, windowHeight = love.graphics.getDimensions()
_w = windowWidth/zoomFactor
_h = windowHeight/zoomFactor

Map = Class {
  __include=Gamestate,
  init = function(self, mapName)
    _gameWorld = Windfield.newWorld(0,0)
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
          player.collider = _gameWorld:newBSGRectangleCollider(player.x, player.y, 8, 8, 0)
          player.collider:setFixedRotation(true)
        end
    end

    if currentMap.layers["walls"] then
      for i,obj in pairs(currentMap.layers["walls"].objects) do
        local wall = _gameWorld:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
        wall:setType("static")
      end
    end
  end,
  entities={}
}

function Map:update(dt)

  local vx = 0
  local vy = 0

  if love.keyboard.isDown("up") then
    vy = player.speed * -1
  end

  if love.keyboard.isDown("down") then
    vy = player.speed
  end

  if love.keyboard.isDown("left") then
    vx = player.speed * -1
  end

  if love.keyboard.isDown("right") then
    vx = player.speed
  end

  player.collider:setLinearVelocity(vx, vy)

  _gameWorld:update(dt)
  player.x = player.collider:getX() - 4
  player.y = player.collider:getY() - 4

  camera:lookAt(player.x, player.y)
  currentMap:update(dt)

  if camera.x < _w/2 then
    camera.x = _w/2
  end

  if camera.y < _h/2 then
    camera.y = _h/2
  end

  local mapWidth = currentMap.width * currentMap.tilewidth
  local mapHeight = currentMap.height * currentMap.tileheight

  if camera.x > (mapWidth - _w/2) then
    camera.x = (mapWidth - _w/2)
  end

  if camera.y > (mapHeight - _h/2) then
    camera.y = (mapHeight - _h/2)
  end
end

function Map:draw()
  effect(function()
    camera:attach()
      drawMapLayer("ground")
      drawMapLayer("decorations")
      love.graphics.draw(player.sprite, player.x, player.y)
      drawMapLayer("foreground")
      -- _gameWorld:draw()
    camera:detach()
  end)
end

function Map:keypressed(key, scancode)
end

function drawMapLayer(layerName)
  if currentMap.layers[layerName].visible then
    currentMap:drawLayer(currentMap.layers[layerName])
  end
end

return Map