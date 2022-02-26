menu = {} -- Menu Game State

local Timer = require "libs.hump.timer"
local Gamestate = require("libs.hump.gamestate")

-- scenes
require("scenes.level1_scene");

local titleFontSize = 25
local msgFontSize = 15
local defaultFontFactor = 8
local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

function menu:init()
    print("Entering Menu")
    titleFont = love.graphics.newFont('assets/fonts/minecraftia.ttf', titleFontSize)
    startMsgFont = love.graphics.newFont('assets/fonts/minecraftia.ttf', msgFontSize)
    music = love.audio.newSource("assets/music/Stevia Sphere - Drum machine dreams.ogg", "stream")
    music:setLooping(true)
    msgFontColor = {0, 0, 0}
    titleFontColor = {1, 1, 1}
    starfield = generateStarfield()

    fadeIn = function()
        Timer.tween(0.5, msgFontColor, {1, 1, 1}, 'linear', fadeOut)
    end

    fadeOut = function()
        Timer.tween(0.5, msgFontColor, {0, 0, 0}, 'linear', fadeIn)
    end

    fadeIn()
    music:play()
end

function menu:enter(previous)

end

function menu:leave()
    music:stop()
end

function menu:update(dt)
    psystem:update(dt)
    Timer.update(dt)
end

function menu:draw()
    love.graphics.setFont(titleFont)
    love.graphics.setColor(titleFontColor)
    love.graphics.draw(starfield, love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)
    love.graphics.print("Enemy is in Another Dungeon",(windowWidth * 0.5) - (titleFontSize * defaultFontFactor), (windowHeight * 0.5) - 50)

    love.graphics.setFont(startMsgFont)
    love.graphics.setColor(msgFontColor)
    love.graphics.print("Press X to START", (windowWidth * 0.5) - (msgFontSize * (defaultFontFactor/1.5)), windowHeight - 50)
    
end

function menu:keyreleased(key, scancode)
    if scancode == 'x' then
        Gamestate.switch(level1)
    end
end

function generateStarfield()
    image = love.graphics.newImage("assets/images/particle.png")
    psystem = love.graphics.newParticleSystem(image, 500)
	psystem:setParticleLifetime(2, 15) -- Particles live at least 2s and at most 5s.
	psystem:setEmissionRate(500)
	psystem:setSizeVariation(1)
	psystem:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
	psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency.
    return psystem
end

return menu