Class = require("libs.hump.class")
Shack = require("libs.shack")
local Timer = require("libs.hump.timer")

ScreenShaker = Class {
    init = function(self)
        monsterGrowl = love.audio.newSource("assets/sfx/monster_growl.wav", "static")
        local width, height = love.graphics.getDimensions()
        Shack:setDimensions(width, height)
        Timer.every(10, shakeScreen)
    end
}

function ScreenShaker:update(dt)
    Timer.update(dt)
    Shack:update(dt)
end

function ScreenShaker:draw()
    Shack:apply()
end

function shakeScreen()
    Shack:setShake(20)
    monsterGrowl:play()
end

return ScreenShaker