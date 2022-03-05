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
    chasing=false,
    dead=false
}

function Enemy:draw()
    love.graphics.setColor({1,0,0})
    love.graphics.rectangle('fill', self.x, self.y, 8, 8)
    if self.collider then
        
    end
end

function Enemy:setCollider()
    self.collider = self.world:newRectangleCollider(self.x, self.y, 8, 8)
    self.collider:setFixedRotation(true)
    self.collider:setType('static')
end

function Enemy:update(dt)
    if self.collider then
        local playerColliders = self.world:queryCircleArea(self.x, self.y, 100,{'player'})
        local enemyColliders = self.world:queryCircleArea(self.x+4, self.y+4, 8,{'enemy'})
        if #playerColliders then
            self.chasing = true
            for i,collider in pairs(playerColliders) do
                local playerObject = collider:getObject()
                
                directionX = playerObject.x - self.x
                directionY = playerObject.y - self.y
                distance = math.sqrt(directionX * directionX + directionY * directionY)
                local angle = math.atan2(directionY, directionX)
                if distance > 20  then
                    -- self.x = self.x + directionX / distance * self.speed * dt
                    -- self.y = self.y + directionY / distance * self.speed * dt
                    self.x = self.x + self.speed * math.cos(angle) * dt
                    self.y = self.y + self.speed * math.sin(angle) * dt
                end
            end
            
            if self.collider then
                self.collider:setX(self.x+4)
                self.collider:setY(self.y+4)    
            end
            
        else
            self.chasing = false
        end

        if self.collider:enter('player') then
            -- self.dead = true
            self.collider:destroy()
        end
    end
end