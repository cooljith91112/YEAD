Class = require("libs.hump.class")
require("libs.tserial")
Enemy = Class{
    init = function(self, x, y, gameWorld)
        self.x = x
        self.y = y
        self.world = gameWorld
    end,
    x=0,
    y=0,
    speed=60,
    collider=nil,
    world=nil,
    chasing=false
}

function Enemy:draw()
    love.graphics.setColor({1,0,0})
    love.graphics.rectangle('fill', self.x, self.y, 16, 16)
    if self.collider then
        
    end
end

function Enemy:setCollider()
    self.collider = self.world:newRectangleCollider(self.x, self.y, 16, 16)
    self.collider:setFixedRotation(true)
end

function Enemy:update(dt)
    if self.collider then
        -- Do the Query
        local colliders = self.world:queryCircleArea(self.x, self.y, 100,{'player'})
        local vx = 0
        local vy = 0
        if #colliders then
            self.chasing = true
            for i,collider in pairs(colliders) do
                local playerObject = collider:getObject()

                if playerObject.dir=="up" then
                    vy = self.speed * -1
                end

                if playerObject.dir=="left" then
                    vx = self.speed * -1
                end

                if playerObject.dir=="down" then
                    vy = self.speed
                end

                if playerObject.dir=="right" then
                    vx = self.speed
                end
                
                directionX = playerObject.x - self.x
                directionY = playerObject.y - self.y
                distance = math.sqrt(directionX * directionX + directionY * directionY)
                if distance >16  then
                    self.x = self.x + directionX / distance * self.speed * dt
                    self.y = self.y + directionY / distance * self.speed * dt
                end
            end
            self.collider:setX(self.x+8)
            self.collider:setY(self.y+8)
        else
            self.chasing = false
        end
    end
end