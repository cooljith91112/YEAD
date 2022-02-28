Class = require("libs.hump.class")
Timer = require("libs.hump.timer")
Notifications = Class {
    init = function(self, zoomFactor)
        color = {1, 0, 0, 1}
        local windowWidth, windowHeight = love.graphics.getDimensions()
    end,
    _message={}
}

function Notifications:update(dt)
    Timer.update(dt)
end

function Notifications:draw()
    if self._message then
        love.graphics.setColor(color)
        love.graphics.print(self._message, 10, wind)
    end
end

function Notifications:send(message)
    self._message = message
    color = {1, 0, 0, 1}
    if Timer then
        Timer.clear()
    end
    Timer.tween(5, color, {0, 0, 0, 0}, 'linear')
end

return Notifications