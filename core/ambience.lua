Class = require("libs.hump.class")

Ambience = Class {
    init = function(self, ambienceTypes)
        if ambienceTypes then 
            for i,ambience in pairs(ambienceTypes) do
                local ambientSound = love.audio.newSource("assets/sfx/"..ambience..".ogg", "static")
                ambientSound:setLooping(true)
                ambientSound:play()
            end
        end
    end
}

return Ambience