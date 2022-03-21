Class = require("libs.hump.class")
require("libs.tserial")
anim8 = require("libs.anim8.anim8")
Enemy = Class{
    init = function(self, x, y, gameWorld)
        self.x = x
        self.y = y
        self.world = gameWorld
        self.grid=anim8.newGrid(32,32,self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
  
        self.animations = {}
        self.animations.down = anim8.newAnimation(self.grid('1-3', 1),0.1)
        self.animations.left = anim8.newAnimation(self.grid('1-3', 2),0.1)
        self.animations.right = anim8.newAnimation(self.grid('1-3', 3),0.1)
        self.animations.up = anim8.newAnimation(self.grid('1-3', 4),0.1)
        self.dir = self.animations.down
        print(self.dir)
    end,
    x=0,
    y=0,
    speed=60,
    collider=nil,
    world=nil,
    chasing=false,
    dead=false,
    dir="down",
    spriteSheet= love.graphics.newImage("assets/images/enemy.png"),
    animations = {},
    grid=nil
}

function Enemy:draw()
    love.graphics.setColor({1,0,0})
    self.dir:draw(self.spriteSheet, self.x, self.y, nil, 0.5, 0.5)
    if self.collider then
        
    end
end

function Enemy:setCollider()
    self.collider = self.world:newRectangleCollider(self.x, self.y, 8, 8)
    self.collider:setFixedRotation(true)
    self.collider:setType('static')
    self.collider:setCollisionClass('enemy')
end

function Enemy:update(dt)
    if self.chasing == false then
        self.dir:gotoFrame(2)
    end
    self.dir:update(dt)
    if self.collider then
        local playerColliders = self.world:queryCircleArea(self.x, self.y, 100,{'player'})
        local enemyColliders = self.world:queryCircleArea(self.x+4, self.y+4, 8,{'enemy'})
        if #playerColliders > 0 then
            self.chasing = true
            for i,collider in pairs(playerColliders) do
                local playerObject = collider:getObject()
                
                directionX = playerObject.x - self.x
                directionY = playerObject.y - self.y
                local angle = math.atan2(directionX,directionY)
                print((angle*180)/3.14)
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
                self.collider:setX(self.x+8)
                self.collider:setY(self.y+8)    
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
