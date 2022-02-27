Class = require("libs.hump.class")
Shack = require("libs.shack")
local Timer = require("libs.hump.Timer")

ScreenShaker = Class {
    init = function(self)
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
end

return ScreenShaker