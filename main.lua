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
    nodesToGenerate=100
    for i=0,nodesToGenerate,1 do
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
    hoveringExit = false
    hoveringOptions = false
    hoveringBegin = false
    hoveringDisplay = false
    hoveringMouse = false
    hoveringGame = false
    hoveringBack = false
    hoverShades = {255,255,255,255,255,255,255}
    useFancyBackground=true
    hoveringBrightness=false
    brightness=0
    showMouse=true
    showCrossSection=false
    showMouseCircle=false
    showSelectionBox=false
    hoveringShowMouse=false
    hoveringCrossSection=false
    hoveringMouseCircle=false
    hoveringSelectionBox=false
    transitionFade=0
	button_click = love.audio.newSource("sounds/button_click.wav", "static")
end

function love.update(dt)
    if scene~="game" and scene~="transition" then
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
    if scene=="title" then
        if love.mouse.getX()>=525 and love.mouse.getY()>=402 and love.mouse.getX()<=673 and love.mouse.getY()<=439 then
            hoveringBegin=true
            if hoverShades[1]~=0 then hoverShades[1]=hoverShades[1]-15 end
        else
            hoveringBegin=false
            if hoverShades[1]~=255 then hoverShades[1]=hoverShades[1]+15 end
        end
        if love.mouse.getX()>=488 and love.mouse.getY()>=477 and love.mouse.getX()<=710 and love.mouse.getY()<=515 then
            hoveringOptions=true
            if hoverShades[2]~=0 then hoverShades[2]=hoverShades[2]-15 end
        else
            hoveringOptions=false
            if hoverShades[2]~=255 then hoverShades[2]=hoverShades[2]+15 end
        end
        if love.mouse.getX()>=548 and love.mouse.getY()>=552 and love.mouse.getX()<=654 and love.mouse.getY()<=589 then
            hoveringExit=true
            if hoverShades[3]~=0 then hoverShades[3]=hoverShades[3]-15 end
        else
            hoveringExit=false
            if hoverShades[3]~=255 then hoverShades[3]=hoverShades[3]+15 end
        end
    elseif string.sub(scene,1,7)=="options" then
        if love.mouse.getX()>=201 and love.mouse.getY()>=52 and love.mouse.getX()<=360 and love.mouse.getY()<=99 then
            hoveringDisplay=true
            if hoverShades[4]~=0 then hoverShades[4]=hoverShades[4]-15 end
        else
            hoveringDisplay=false
            if hoverShades[4]~=255 then hoverShades[4]=hoverShades[4]+15 end
        end
        if love.mouse.getX()>=527 and love.mouse.getY()>=52 and love.mouse.getX()<=672 and love.mouse.getY()<=89 then
            hoveringMouse=true
            if hoverShades[5]~=0 then hoverShades[5]=hoverShades[5]-15 end
        else
            hoveringMouse=false
            if hoverShades[5]~=255 then hoverShades[5]=hoverShades[5]+15 end
        end
        if love.mouse.getX()>=847 and love.mouse.getY()>=52 and love.mouse.getX()<=1073 and love.mouse.getY()<=99 then
            hoveringGameplay=true
            if hoverShades[6]~=0 then hoverShades[6]=hoverShades[6]-15 end
        else
            hoveringGameplay=false
            if hoverShades[6]~=255 then hoverShades[6]=hoverShades[6]+15 end
        end
        if love.mouse.getX()>=548 and love.mouse.getY()>=552 and love.mouse.getX()<=654 and love.mouse.getY()<=589 then
            hoveringBack=true
            if hoverShades[7]~=0 then hoverShades[7]=hoverShades[7]-15 end
        else
            hoveringBack=false
            if hoverShades[7]~=255 then hoverShades[7]=hoverShades[7]+15 end
        end
        if scene=="options-display" then
            if love.mouse.getX()>=327 and love.mouse.getY()>=203 and love.mouse.getX()<=874 and love.mouse.getY()<=250 then
                hoveringFancyBackground=true
            else
                hoveringFancyBackground=false
            end
            if love.mouse.getX()>=427 and love.mouse.getY()>=277 and love.mouse.getX()<=773 and love.mouse.getY()<=325 then
                hoveringBrightness=true
            else
                hoveringBrightness=false
            end
        elseif scene=="options-mouse" then
            if love.mouse.getX()>=390 and love.mouse.getY()>=202 and love.mouse.getX()<=809 and love.mouse.getY()<=240 then
                hoveringShowMouse=true
            else
                hoveringShowMouse=false
            end
            if love.mouse.getX()>=379 and love.mouse.getY()>=277 and love.mouse.getX()<=821 and love.mouse.getY()<=315 then
                hoveringCrossSection=true
            else
                hoveringCrossSection=false
            end
            if love.mouse.getX()>=389 and love.mouse.getY()>=352 and love.mouse.getX()<=811 and love.mouse.getY()<=389 then
                hoveringMouseCircle=true
            else
                hoveringMouseCircle=false
            end
            if love.mouse.getX()>=381 and love.mouse.getY()>=427 and love.mouse.getX()<=818 and love.mouse.getY()<=464 then
                hoveringSelectionBox=true
            else
                hoveringSelectionBox=false
            end
        end
    elseif scene=="transition" then
        transitionFade=transitionFade+1
        if transitionFade>=255 then
            scene="game"
        end
    end
end

function love.draw()
    if scene~="game" and useFancyBackground then
        nodes[nodesToGenerate+1]={love.mouse.getX(),love.mouse.getY(),5}
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
            if i[3]~=5 then
                love.graphics.circle("fill", i[1], i[2], 5)
            end
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
    end
    if scene=="title" then
        love.graphics.setColor(1,1,1,0.25)
        love.graphics.rectangle("fill", 100, 125, 1000, 175, 25, 25)
        love.graphics.rectangle("fill", 500, 390, 200, 65, 15, 15)
        love.graphics.rectangle("fill", 470, 465, 260, 65, 15, 15)
        love.graphics.rectangle("fill", 525, 540, 150, 65, 15, 15)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(helvetica_title)
        love.graphics.printf("tthe video game", 0, 150, 1200, "center")
        love.graphics.setFont(helvetica_button)
        love.graphics.setColor(1,hoverShades[1]/255,hoverShades[1]/255)
        love.graphics.printf("BEGIN", 0, 400, 1200, "center")
        love.graphics.setColor(1,hoverShades[2]/255,hoverShades[2]/255)
        love.graphics.printf("OPTIONS", 0, 475, 1200, "center")
        love.graphics.setColor(1,hoverShades[3]/255,hoverShades[3]/255)
        love.graphics.printf("EXIT", 0, 550, 1200, "center")
    end
    if scene=="options-display" then
        love.graphics.setFont(helvetica_button)
        love.graphics.setColor(1,1,1,0.25)
        love.graphics.rectangle("fill", 320, 190, 560, 65, 15, 15)
        love.graphics.rectangle("fill", 420, 265, 360, 65, 15, 15)
        if useFancyBackground then
            love.graphics.setColor(0,1,0)
        else
            love.graphics.setColor(1,0,0)
        end
        love.graphics.printf("Fancy Background: ".. tostring(useFancyBackground), 0, 200, 1200, "center")
        love.graphics.setColor(1,1,1)
        love.graphics.printf("Brightness: ".. tostring(brightness*2), 0, 275, 1200, "center")
    end
    if scene=="options-mouse" then
        love.graphics.setFont(helvetica_button)
        love.graphics.setColor(1,1,1,0.25)
        love.graphics.rectangle("fill", 380, 190, 440, 65, 15, 15)
        love.graphics.rectangle("fill", 365, 265, 470, 65, 15, 15)
        love.graphics.rectangle("fill", 375, 340, 450, 65, 15, 15)
        love.graphics.rectangle("fill", 370, 415, 460, 65, 15, 15)
        if showMouse then
            love.graphics.setColor(0,1,0)
        else
            love.graphics.setColor(1,0,0)
        end
        love.graphics.printf("Show Mouse: ".. tostring(showMouse), 0, 200, 1200, "center")
        if showCrossSection then
            love.graphics.setColor(0,1,0)
        else
            love.graphics.setColor(1,0,0)
        end
        love.graphics.printf("Cross Section: ".. tostring(showCrossSection), 0, 275, 1200, "center")
        if showMouseCircle then
            love.graphics.setColor(0,1,0)
        else
            love.graphics.setColor(1,0,0)
        end
        love.graphics.printf("Mouse Circle: ".. tostring(showMouseCircle), 0, 350, 1200, "center")
        if showSelectionBox then
            love.graphics.setColor(0,1,0)
        else
            love.graphics.setColor(1,0,0)
        end
        love.graphics.printf("Selection Box: ".. tostring(showSelectionBox), 0, 425, 1200, "center")
    end
    if string.sub(scene,1,7)=="options" then
        love.graphics.setColor(1,1,1,0.25)
        love.graphics.rectangle("fill", 80, 40, 1040, 70, 25, 25)
        love.graphics.rectangle("fill", 525, 540, 150, 65, 15, 15)
        love.graphics.setFont(helvetica_button)
        love.graphics.setColor(1,hoverShades[4]/255,hoverShades[4]/255)
        love.graphics.printf("Display",100,50,360,"center")
        love.graphics.setColor(1,hoverShades[5]/255,hoverShades[5]/255)
        love.graphics.printf("Mouse",0,50,1200,"center")
        love.graphics.setColor(1,hoverShades[6]/255,hoverShades[6]/255)
        love.graphics.printf("Gameplay",780,50,360,"center")
        love.graphics.setColor(1,hoverShades[7]/255,hoverShades[7]/255)
        love.graphics.printf("Back",0,550,1200,"center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("   |  |   ", 0, 50, 1200, "justify")
    end
    if scene=="transition" then
        love.graphics.setColor(1,1,1,0.25)
        love.graphics.rectangle("fill", 100, 125, 1000, 175, 25, 25)
        love.graphics.rectangle("fill", 500, 390, 200, 65, 15, 15)
        love.graphics.rectangle("fill", 470, 465, 260, 65, 15, 15)
        love.graphics.rectangle("fill", 525, 540, 150, 65, 15, 15)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(helvetica_title)
        love.graphics.printf("tthe video game", 0, 150, 1200, "center")
        love.graphics.setFont(helvetica_button)
        love.graphics.setColor(1,hoverShades[1]/255,hoverShades[1]/255)
        love.graphics.printf("BEGIN", 0, 400, 1200, "center")
        love.graphics.setColor(1,hoverShades[2]/255,hoverShades[2]/255)
        love.graphics.printf("OPTIONS", 0, 475, 1200, "center")
        love.graphics.setColor(1,hoverShades[3]/255,hoverShades[3]/255)
        love.graphics.printf("EXIT", 0, 550, 1200, "center")
        love.graphics.setColor(0,0,0,transitionFade/255)
        love.graphics.rectangle("fill", 0, 0, 1200, 650)
    end
    if showSelectionBox and drawSelectionBox then
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
    love.graphics.setColor(1, 1, 1)
    if showCrossSection then
        love.graphics.rectangle("fill", love.mouse.getX(), 0, 1, 650)
        love.graphics.rectangle("fill", 0, love.mouse.getY(), 1200, 1)
    end
    if showMouseCircle then
        love.graphics.circle("line", love.mouse.getX(), love.mouse.getY(), 20)
    end
    love.mouse.setVisible(showMouse)
    if brightness<0 then
        love.graphics.setColor(0,0,0,math.abs(brightness/10))
    else
        love.graphics.setColor(1,1,1,math.abs(brightness/20))
    end
    --love.graphics.setColor(0.5+brightness/10,0.5+brightness/10,0.5+brightness/10,math.abs(brightness/10))
    love.graphics.rectangle("fill",0,0,1200,650)
end

function love.mousepressed(x, y, button, isTouch)
    love.audio.stop(button_click)
    love.audio.play(button_click)
    if hoveringExit then
        os.exit()
    elseif hoveringOptions then
        scene="options-display"
        hoveringOptions=false
    elseif hoveringDisplay then
        scene="options-display"
    elseif hoveringMouse then
        scene="options-mouse"
    elseif hoveringGameplay then
        scene="options-gameplay"
    elseif hoveringFancyBackground then
        useFancyBackground=not useFancyBackground
    elseif hoveringBrightness then
        if button==1 then
            if brightness<5 then
                brightness=brightness+0.5
            end
        elseif button==2 then
            if brightness>-5 then
                brightness=brightness-0.5
            end
        end
    elseif hoveringShowMouse then
        showMouse=not showMouse
    elseif hoveringCrossSection then
        showCrossSection=not showCrossSection
    elseif hoveringMouseCircle then
        showMouseCircle=not showMouseCircle
    elseif hoveringSelectionBox then
        showSelectionBox=not showSelectionBox
    elseif hoveringBack then
        scene="title"
        hoveringBack=false
    elseif hoveringBegin then
        scene="transition"
    else
        love.audio.stop(button_click)
    end
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
