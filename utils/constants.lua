constants = {}

constants.resetBgColor = {0, 0, 0}
constants.resetFgColor = {1, 1, 1}

function constants:resetColors()
    love.graphics.setColor(constants.resetFgColor)
    love.graphics.setBackgroundColor(constants.resetBgColor)
end

return constants