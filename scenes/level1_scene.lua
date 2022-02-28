level1 = {} -- Level1 State
require("core.screen_shaker")
Map = require("core.map")
-- imports
require("core.constants")
require("core.ambience")

function level1:init()
  constants.resetColors()
  screenShake = ScreenShaker()
  ambience = Ambience({"atmosphere1","thunder"})
  map = Map("level1")
end

function level1:enter(previous)
end

function level1:update(dt)
  map:update(dt)
  screenShake:update(dt)
end

function level1:draw()
  screenShake:draw()
  map:draw()
end

function level1:keypressed(key, scancode)
  map:keypressed(key, scancode)
end

function level1:leave()
  map = nil
end


function printMessage()
  print('Hello')
end

return level1