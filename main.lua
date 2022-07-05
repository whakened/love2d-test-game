function love.load()
    main = love.physics.newWorld( 0, 0, true )
    main:setCallbacks(beginContact, endContact, preSolve, postSolve)
    love.window.setMode(1200, 650)
    local drawSelectionBox = false
    local mouseOriginalX = 0
    local mouseOriginalY = 0
    love.mouse.setVisible(false)
    helvetica_title = love.graphics.newFont("helvetica.ttf", 125)
    helvetica_button = love.graphics.newFont("helvetica.ttf", 50)
    scene = "title"
    nodes={}
    for i=0,100,1 do
        table.insert(nodes, {love.math.random(50,1150),love.math.random(50,600),love.math.random(1,4)})
    end
    rgbDirection = 1
    --1 red 255, begin filling green
    --2 green 255, begin emptying red
    --3 green 255, begin filling blue
    --4 blue 255, begin emptying green
    --5 blue 255, begin filling red
    --6 red 255, begin emptying blue
    backgroundR=255
    backgroundG=0
    backgroundB=0
end

function love.update(dt)
    if rgbDirection==1 then
        if backgroundG==255 then
            rgbDirection=2
        else
            backgroundG=backgroundG+1
        end
    elseif rgbDirection==2 then
        if backgroundR==0 then
            rgbDirection=3
        else
            backgroundR=backgroundR-1
        end
    elseif rgbDirection==3 then
        if backgroundB==255 then
            rgbDirection=4
        else
            backgroundB=backgroundB+1
        end
    elseif rgbDirection==4 then
        if backgroundG==0 then
            rgbDirection=5
        else
            backgroundG=backgroundG-1
        end
    elseif rgbDirection==5 then
        if backgroundR==255 then
            rgbDirection=6
        else
            backgroundR=backgroundR+1
        end
    elseif rgbDirection==6 then
        if backgroundB==0 then
            rgbDirection=1
        else
            backgroundB=backgroundB-1
        end
    end
end

function love.draw()
    if scene=="title" then
        love.graphics.setColor(backgroundR/255,backgroundG/255,backgroundB/255)
        for _, i in ipairs(nodes) do --I CANT READ ANY OF THIS LMAO
            for _, o in ipairs(nodes) do
                if distance(i[1], i[2], o[1], o[2])<100 then
                    love.graphics.setColor(backgroundR/255,backgroundG/255,backgroundB/255)
                    love.graphics.line(i[1], i[2], o[1], o[2])
                elseif distance(i[1], i[2], o[1], o[2])<150 then
                    intensity = (150-distance(i[1], i[2], o[1], o[2]))/100
                    love.graphics.setColor(backgroundR/255,backgroundG/255,backgroundB/255, intensity)
                    love.graphics.line(i[1], i[2], o[1], o[2])
                end
            end
        end
        for _, i in ipairs(nodes) do
            love.graphics.circle("fill", i[1], i[2], 5)
            -- i[3] 1 UL 2 UR 3 DR 4 DL
            if i[1]<3 and i[3]==1 then i[3]=2 elseif i[1]<3 and i[3]==4 then i[3]=3
            elseif i[1]>1197 and i[3]==2 then i[3]=1 elseif i[1]>1197 and i[3]==3 then i[3]=4
            elseif i[2]<3 and i[3]==1 then i[3]=4 elseif i[2]<3 and i[3]==2 then i[3]=3
            elseif i[2]>647 and i[3]==4 then i[3]=1 elseif i[2]>647 and i[3]==3 then i[3]=2 end
            if i[3]==1 then
                i[1]=i[1]-0.5
                i[2]=i[2]-0.5
            elseif i[3]==2 then
                i[1]=i[1]+0.5
                i[2]=i[2]-0.5
            elseif i[3]==3 then
                i[1]=i[1]+0.5
                i[2]=i[2]+0.5
            elseif i[3]==4 then
                i[1]=i[1]-0.5
                i[2]=i[2]+0.5
            end
            i[1]=i[1]+love.math.random(-1,1)/2
            i[2]=i[2]+love.math.random(-1,1)/2
        end
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", love.mouse.getX(), 0, 1, 650)
        love.graphics.rectangle("fill", 0, love.mouse.getY(), 1200, 1)
        love.graphics.setFont(helvetica_title)
        love.graphics.printf("tthe video game", 0, 150, 1200, "center")
        love.graphics.setFont(helvetica_button)
        love.graphics.printf("BEGIN", 0, 400, 1200, "center")
        love.graphics.printf("OPTIONS", 0, 475, 1200, "center")
        love.graphics.printf("EXIT", 0, 550, 1200, "center")
        if drawSelectionBox then
            love.graphics.setColor(0.5, 0.75, 1, 1)
            love.graphics.rectangle("line", mouseOriginalX, mouseOriginalY, love.mouse.getX()-mouseOriginalX, love.mouse.getY()-mouseOriginalY)
            love.graphics.setColor(0.5, 0.75, 1, 0.3)
            love.graphics.rectangle("fill", mouseOriginalX, mouseOriginalY, love.mouse.getX()-mouseOriginalX, love.mouse.getY()-mouseOriginalY)
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.setNewFont(12)
            love.graphics.print(mouseOriginalX ..", ".. mouseOriginalY, mouseOriginalX+1, mouseOriginalY+1)
            love.graphics.print(love.mouse.getX() ..", ".. love.mouse.getY(), love.mouse.getX()+1, love.mouse.getY()+1)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(mouseOriginalX ..", ".. mouseOriginalY, mouseOriginalX, mouseOriginalY)
            love.graphics.print(love.mouse.getX() ..", ".. love.mouse.getY(), love.mouse.getX(), love.mouse.getY())
        end
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

function love.keypressed(key, un)
    if key=="up" then
        love.mouse.setPosition(love.mouse.getX(), love.mouse.getY()-1)
    elseif key=="left" then
        love.mouse.setPosition(love.mouse.getX()-1, love.mouse.getY())
    elseif key=="down" then
        love.mouse.setPosition(love.mouse.getX(), love.mouse.getY()+1)
    elseif key=="right" then
        love.mouse.setPosition(love.mouse.getX()+1, love.mouse.getY())
    end
end

function distance(x1,y1,x2,y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end
