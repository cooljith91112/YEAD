menu = {} -- Menu Game State

local Timer = require "libs.hump.timer"
local Gamestate = require("libs.hump.gamestate")
Moonshine = require("libs.moonshine")
require("core.constants")

local titleFontSize1 = 35
local titleFontSize2 = 40
local msgFontSize = 15
local defaultFontFactor = 10.30
local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

function menu:init()
    titleFont1 = love.graphics.newFont('assets/fonts/C800.ttf', titleFontSize1)
    titleFont2 = love.graphics.newFont('assets/fonts/Lazer84.ttf', titleFontSize2)
    startMsgFont = love.graphics.newFont('assets/fonts/C800.ttf', msgFontSize)
    music = love.audio.newSource("assets/music/title.ogg", "stream")
    titleText1 = love.graphics.newText(titleFont1, "Your Enemy is in Another")
    titleText2 = love.graphics.newText(titleFont2, "Dungeon")
    msgText = love.graphics.newText(startMsgFont, "Press X to START")
    effect = Moonshine(windowWidth, windowHeight, Moonshine.effects.crt)
    .chain(Moonshine.effects.vignette)
    .chain(Moonshine.effects.scanlines)
    .chain(Moonshine.effects.chromasep)
    effect.scanlines.thickness = .2
    effect.scanlines.opacity = .5
    effect.chromasep.angle = 1
    effect.chromasep.radius = 2

    music:setLooping(true)
    msgFontColor = {0, 0, 0, 0}
    titleFontColor1 = {1, 1, 1}
    titleFontColor2 = {1, 0, 0}
    starfield = generateStarfield()

    fadeIn = function()
        Timer.tween(0.5, msgFontColor, {1, 1, 1, 1}, 'linear', fadeOut)
    end

    fadeOut = function()
        Timer.tween(0.5, msgFontColor, {0, 0, 0, 0}, 'linear', fadeIn)
    end

    fadeIn()
    music:play()
    constants.resetColors()
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
    effect(function()
        love.graphics.setFont(titleFont1)
        love.graphics.setColor(titleFontColor1)
        love.graphics.draw(starfield, love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)
        love.graphics.draw(titleText1,(windowWidth * 0.5) - (titleText1:getWidth() * 0.5), (windowHeight * 0.5) - 50)
        love.graphics.setFont(titleFont2)
        love.graphics.setColor({0,0,0,1})
        love.graphics.draw(titleText2,(windowWidth * 0.5) - (titleText2:getWidth() * 0.5), (windowHeight * 0.5) + 1, -0.17)
        love.graphics.setColor(titleFontColor2)
        love.graphics.draw(titleText2,(windowWidth * 0.5) - (titleText2:getWidth() * 0.5), (windowHeight * 0.5) + 2, -0.17)

        love.graphics.setFont(startMsgFont)
        love.graphics.setColor(msgFontColor)
        love.graphics.draw(msgText, (windowWidth * 0.5) - (msgText:getWidth() * 0.5), windowHeight - 50)
    end)
end

function menu:keyreleased(key, scancode)
    if scancode == 'x' then
        Gamestate.switch(level1)
    end
end

function love.touchpressed( id, x, y, dx, dy, pressure )
    Gamestate.switch(level1)
end

function generateStarfield()
    image = love.graphics.newImage("assets/images/particle.png")
    psystem = love.graphics.newParticleSystem(image, 2500)
    psystem:setEmissionRate(466.67)
    psystem:setParticleLifetime(2*.5, 2)
    psystem:setSizeVariation(0.63)
    psystem:setRadialAcceleration(946.67*0.5, 946.67*0.5)
    psystem:setColors(love.math.random(), 1, love.math.random(), 1, love.math.random(), 1, 1, 0)
    psystem:setEmissionArea('normal', 39, 39)
    psystem:setDirection(-4.79)
    psystem:setSizes(3.13, 3, 0.1)
    psystem:setSizeVariation(0.63)
    psystem:setTangentialAcceleration(500*0.5, 500)

    return psystem
end

return menu
