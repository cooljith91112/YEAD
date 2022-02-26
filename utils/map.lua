Class = require("libs.hump.class")
Gamestate = require("libs.hump.gamestate")
STI = require("libs.sti")
Moonshine = require("libs.moonshine")
Camera = require("libs.hump.camera")

Map = Class {
  init = function(self, mapName) -- TODO pass map instance parameter
    width, height = love.graphics.getDimensions( )
    effect = Moonshine(width, height, Moonshine.effects.crt)
                    .chain(Moonshine.effects.vignette)
                    .chain(Moonshine.effects.scanlines)
                    .chain(Moonshine.effects.chromasep)
    effect.scanlines.thickness = .2
    effect.scanlines.opacity = .5
    effect.chromasep.angle = 1
    effect.chromasep.radius = 5
    camera = Camera()
    camera:zoom(1)
    print("Map Manager")
    currentMap = STI("assets/maps/"..mapName..".lua")
    if currentMap.layers["entities"] then
        for i,obj in pairs(currentMap.layers["entities"].objects) do
          print(obj.name)
        end
    end
  end,
  entities={}
}

function Map:update(dt)
  print("Map Update")
  currentMap:update(dt)
end

function Map:draw()
  print("Map Draw")
  camera:attach()
  effect(function()
    
      currentMap:drawLayer(currentMap.layers["ground"])
    
  end)
  camera:detach()
end

function Map:keypressed(key, scancode)
  
end

return Map