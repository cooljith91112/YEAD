constants = {}

constants.resetBgColor = {0.15, 0.15, 0.15}
constants.resetFgColor = {1, 1, 1}
constants.defaultFontSize = 13
constants.defaultFont = love.graphics.newFont('assets/fonts/C800.ttf', constants.defaultFontSize)

function constants:resetColors()
    love.graphics.setColor(constants.resetFgColor)
    love.graphics.setBackgroundColor(constants.resetBgColor)
end

return constants