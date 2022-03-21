Class = require("libs.hump.class")
Gamestate = require("libs.hump.gamestate")
STI = require("libs.sti")
local Moonshine = require("libs.moonshine")
Camera = require("libs.hump.camera")
Windfield = require("libs.windfield")
require("libs.tserial")
require("core.notifications")
require("entities.enemy")
require("entities.pickable")
anim8 = require("libs.anim8.anim8")
local zoomFactor = 3
local player = {
  x=0,
  y=0,
  sprite=love.graphics.newImage("assets/images/player_demo.png"),
  speed=70,
  dir="down",
  spriteSheet= love.graphics.newImage("assets/images/aswani.png")
}
local fullscreen = true

local windowWidth, windowHeight = love.graphics.getDimensions()
local _w = windowWidth/zoomFactor
local _h = windowHeight/zoomFactor

Map = Class {
  __include=Gamestate,
  init = function(self, mapName, debug)
    self.debug = debug and debug or false
    initAnimations()
    _gameWorld = Windfield.newWorld(0,0)
    _gameWorld:setQueryDebugDrawing(debug and debug or false) -- Remove when deploy
    _gameWorld:addCollisionClass('interactive')
    _gameWorld:addCollisionClass('pickable')
    _gameWorld:addCollisionClass('enemy')
    _gameWorld:addCollisionClass('player')
    effect = Moonshine(windowWidth, windowHeight, Moonshine.effects.crt)
                    .chain(Moonshine.effects.vignette)
                    .chain(Moonshine.effects.scanlines)
                    .chain(Moonshine.effects.chromasep)

    effect.scanlines.thickness = .2
    effect.scanlines.opacity = .5
    effect.chromasep.angle = 1
    effect.chromasep.radius = 3

    notifications = Notifications(zoomFactor)
    camera = Camera()
    camera:zoom(zoomFactor)
    currentMap = STI("assets/maps/"..mapName..".lua")
    if currentMap.layers["entities"] then
        for i,obj in pairs(currentMap.layers["entities"].objects) do
          if obj.name=="player" and obj.type=="player" then
            player.x = obj.x
            player.y = obj.y
            player.collider = _gameWorld:newBSGRectangleCollider(player.x, player.y, 16, 16, 0)
            
            player.collider:setFixedRotation(true)
            player.collider:setCollisionClass('player')
            player.collider:setObject(player)
          end

          if obj.type=="interactive" then
            local collider = _gameWorld:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            local interactiveData = {
              type = obj.type,
              interactive_type = obj.properties.interactive_type,
              message = obj.properties.message and obj.properties.message or nil,
              talker_data = obj.properties.talker_data and obj.properties.talker_data or nil
            }
            collider:setObject(interactiveData)
            collider:setCollisionClass('interactive')
            collider:setType("static")
          end

          if obj.type=="pickable" then
            local pickable = Pickable(obj.x, obj.y, obj.width, obj.height, obj.name and obj.name or nil, _gameWorld)
            pickable:setCollider(obj.properties)
            table.insert(self.pickables, pickable)
          end

          if obj.type=="enemy" then
            local enemy = Enemy(obj.x, obj.y, _gameWorld)
            enemy:setCollider()
            table.insert(self.enemies, enemy)
          end
        end
    end

    if currentMap.layers["walls"] then
      for i,obj in pairs(currentMap.layers["walls"].objects) do
        local wall = _gameWorld:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
        wall:setType("static")
      end
    end
  end,
  entities={},
  enemies={},
  pickables={},
  debug=false
}

function Map:update(dt)
  local vx = 0
  local vy = 0
  local isMoving = false
  if love.keyboard.isDown("w") then
    vy = player.speed * -1
    player.dir = player.animations.up
    isMoving = true
  end
  
  if love.keyboard.isDown("a") then
    vx = player.speed * -1
    player.dir = player.animations.left
    isMoving = true
  end
  
  if love.keyboard.isDown("s") then
    vy = player.speed
    player.dir = player.animations.down
    isMoving = true
  end

  if love.keyboard.isDown("d") then
    vx = player.speed
    player.dir = player.animations.right
    isMoving = true
  end

  if isMoving == false then
    player.dir:gotoFrame(2)
  end
  player.dir:update(dt)

  player.collider:setLinearVelocity(vx, vy)

  _gameWorld:update(dt)
  player.x = player.collider:getX() - 8
  player.y = player.collider:getY() - 8
  player.collider:setObject(player)

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

  if player.collider:enter('interactive') or player.collider:enter('pickable')then
    local _interColliderData = player.collider:getEnterCollisionData('interactive') or player.collider:getEnterCollisionData('pickable')
    local interactiveCollider = _interColliderData.collider
    local interactiveData = interactiveCollider:getObject()
    if interactiveData.message then 
      notifications:send(interactiveData.message)
    end
  end
  notifications:update(dt)
  for i,enemy in pairs(self.enemies) do
    if enemy.dead then
      table.remove(self.enemies, i)
    else
      enemy:update(dt)
    end
  end

  for i,pickable in pairs(self.pickables) do
    if pickable.acquired then
      table.remove(self.pickables, i)
    else
      pickable:update(dt)
    end
  end
  
end

function Map:draw()
  effect(function()
    camera:attach()
      drawMapLayer("water")
      drawMapLayer("ground")
      drawMapLayer("decorations")
      --love.graphics.draw(player.sprite, player.x, player.y)
      player.dir:draw(player.spriteSheet, player.x, player.y, nil, 0.5, 0.5)
      drawMapLayer("foreground")
      if self.debug then
        _gameWorld:draw() -- Debug Collision Draw
      end
      for i,enemy in pairs(self.enemies) do
        enemy:draw()
      end

      for i,pickable in pairs(self.pickables) do
        pickable:draw()
      end
    camera:detach()
    notifications:draw()
  end)

end

function Map:keypressed(key, scancode)
  if(scancode=="f4") then
    fullscreen = not fullscreen
    love.window.setFullscreen(fullscreen)
    resize()
  end
end

function drawMapLayer(layerName)
  if currentMap.layers[layerName].visible then
    currentMap:drawLayer(currentMap.layers[layerName])
  end
end

function resize()
	_width, _height = love.graphics.getDimensions()
  if not(fullscreen) then
		_width = 1280
		_height = 720
	end
	effect.resize(_width,_height)
  notifications.calculateWindowDimensions()
end

function initAnimations()
  player.grid=anim8.newGrid(32,32,player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
  
  player.animations = {}
  player.animations.down = anim8.newAnimation(player.grid('1-3', 1),0.1)
  player.animations.left = anim8.newAnimation(player.grid('1-3', 2),0.1)
  player.animations.right = anim8.newAnimation(player.grid('1-3', 3),0.1)
  player.animations.up = anim8.newAnimation(player.grid('1-3', 4),0.1)
  player.dir = player.animations.down
end

return Map
