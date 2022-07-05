function love.load()
    main = love.physics.newWorld( 0, 0, true )
    main:setCallbacks(beginContact, endContact, preSolve, postSolve)
    love.window.setMode(1200, 650)
    local drawSelectionBox = false
    local mouseOriginalX = 0
    local mouseOriginalY = 0
    love.mouse.setVisible(false)
end

function love.update(dt)

end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", love.mouse.getX(), 0, 1, 650)
    love.graphics.rectangle("fill", 0, love.mouse.getY(), 1200, 1)
    love.graphics.setColor(0.5, 0.75, 1, 0.3)
    if drawSelectionBox then
        love.graphics.rectangle("fill", mouseOriginalX, mouseOriginalY, love.mouse.getX()-mouseOriginalX, love.mouse.getY()-mouseOriginalY)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(mouseOriginalX ..", ".. mouseOriginalY, mouseOriginalX, mouseOriginalY)
        love.graphics.print(love.mouse.getX() ..", ".. love.mouse.getY(), love.mouse.getX(), love.mouse.getY())
    end
end

function love.mousepressed(x, y, button, isTouch)
    drawSelectionBox = true
    mouseOriginalX = x
    mouseOriginalY = y
end

function love.mousereleased(x, y, button, isTouch)
    drawSelectionBox = false
end
