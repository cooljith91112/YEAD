local Gamestate = require("libs.hump.gamestate")
local LoveSplash = require("libs.o-ten-one")
require("scenes.menu_scene");

function love.load()
    splash = LoveSplash({background={0, 0, 0}})
    splash.onDone = onLoveSplashDone
end

function onLoveSplashDone()
    splash = nil
    Gamestate.switch(menu)
    Gamestate.registerEvents()
end

function love.draw()
    if splash then
        splash:draw()
    end
end

function love.update(dt)
    if splash then
        splash:update(dt)
    end
end

function love.keyreleased(key, scancode)
    -- Temporary
    if scancode == 'escape' then
        love.event.quit()    
    end
end