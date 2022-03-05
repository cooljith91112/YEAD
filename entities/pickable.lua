Class = require("libs.hump.class")

Pickable = Class{
    init = function(self, x, y, w, h, name, gameWorld)
        self.x = x
        self.y = y
        self.width = w
        self.height = h
        self.image = name
        self.world = gameWorld
        self.image = love.graphics.newImage("assets/images/"..name..".png")
        self.sfx = love.audio.newSource("assets/sfx/"..name..".wav", "static")
    end,
    x=0,
    y=0,
    width=0,
    height=0,
    image=nil,
    world=nil,
    collider=nil,
    acquired=false,
    sfx=nil
}

function Pickable:setCollider(colliderData)
    self.collider = self.world:newRectangleCollider(self.x, self.y, self.width, self.height)
    self.collider:setFixedRotation(true)
    self.collider:setType('static')
    self.collider:setCollisionClass('pickable')
    self.collider:setObject(colliderData)
end

function Pickable:draw()
    love.graphics.draw(self.image,self.x, self.y)
end

function Pickable:update(dt)
    if self.collider then
        if self.collider:enter('player') then
            self.acquired = true
            self.sfx:play()
            self.collider:destroy()
        end
    end
end

return Pickable