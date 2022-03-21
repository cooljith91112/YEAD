level1 = {} -- Level1 State
require("core.screen_shaker")
Map = require("core.map")
--require("scenes.menu_scene")
local Gamestate = require("libs.hump.gamestate")
-- imports
require("core.constants")
require("core.ambience")
local map
function level1:init()
  constants.resetColors()
  screenShake = ScreenShaker()
  ambience = Ambience({"atmosphere1","thunder"})
  map = Map("level1", false)
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
  if scancode=="r" then
    love.audio.stop( )
    Gamestate.switch(menu)
  end
end

function level1:leave()
end

return level1
