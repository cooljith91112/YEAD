Class = require("libs.hump.class")
Timer = require("libs.hump.timer")
require("core.constants")
Notifications = Class {
    init = function(self, zoomFactor)
        self.calculateWindowDimensions()
    end,
    messages={}
}

function Notifications:calculateWindowDimensions()
    windowWidth, windowHeight = love.graphics.getDimensions()
end

function Notifications:update(dt)
    for i,obj in pairs(self.messages) do
        if obj.timer then
            obj.timer:update(dt)
        end
    end
end

function Notifications:draw()
    love.graphics.setFont(constants.defaultFont)
    local defaultY =  windowHeight - 20
    for i,obj in pairs(self.messages) do
        love.graphics.setColor(obj.color)
        love.graphics.print(obj.message, 10, defaultY)
        defaultY = defaultY - 15
    end
end

function Notifications:send(message)
    local messageItem={
        message=message,
        color={1, 0, 0, 1},
        timer=nil
    }
    table.insert(self.messages, messageItem)
    for i,obj in pairs(self.messages) do
        if obj.timer==nil then
            obj.timer = Timer.new()
            obj.timer:tween(5, obj.color, {0, 0, 0, 0}, 'linear', function()
                obj.timer:clear()
                obj.timer = nil
                table.remove(self.messages, 1)
            end)
        end
    end   
end

return Notifications