require "game"
BUTTON_HEIGHT = 64
local gameState="menu"
local function newButton(text, fn)
	return {text= text, fn = fn, now = false, last= false}
end

local buttons = {}
local font = nil

function love.load()
	logo= love.graphics.newImage("/images/logo.png")
	font = love.graphics.newFont("minecraft.ttf",32)
	main= love.graphics.newImage("/images/backgrounds/main.png")
	table.insert(buttons, newButton(
		"Start the game", 
		function()
			gameState="game"
			game.load()
		end))
	table.insert(buttons, newButton(
		"Exit", 
		function()
			os.exit()
		end))
end
function love.update(dt)
    if gameState == "game" then
        game.update(dt)
        
        -- Check if the player's health reaches 0 and switch to menu
        if player.health <= 0 then
            gameState = "menu"  -- Switch to the menu
            finalScore=score
            score=nil
            -- Optionally, reset game-related variables if needed here
        end
    end
end
function love.draw()
	local ww = love.graphics.getWidth()
	local wh = love.graphics.getHeight()	
	if gameState == "menu" then
		love.graphics.draw(main)
		love.graphics.draw(logo,300,100)	
		if finalScore~=nil then
			love.graphics.print("Previous score: ".. finalScore,font,10,10)
		end

		local button_width = ww * (1/3)
		local margin = 16

		local total_height = (BUTTON_HEIGHT+margin) * #buttons
		local cursor_y = 0
		for i, button in ipairs(buttons) do
			button.last = button.now
			local bx= (ww*0.5) - (button_width* 0.5)
			local by= (wh*0.5) - (total_height*0.5) + cursor_y

			local color = {0.4, 0.4, 0.5, 1.0}
			local mx, my = love.mouse.getPosition()
			local hot = mx > bx and mx<bx+button_width and my>by and my<by+BUTTON_HEIGHT
			if hot then
				color= {0.8, 0.8, 0.9, 1.0}
			end
			button.now= love.mouse.isDown(1)
			if button.now and not button.last and hot then
				button.fn()
			end
			love.graphics.setColor(unpack(color))
			love.graphics.rectangle(
				"fill", 
				bx,
				by,
				button_width,
				BUTTON_HEIGHT
			)
			love.graphics.setColor(1,1,1,1)

			local textW = font:getWidth(button.text)
			local textH = font:getHeight(button.text)

			love.graphics.print(button.text,font,ww *0.5 - textW*0.5,by+textH*0.5)

			cursor_y = cursor_y + (BUTTON_HEIGHT +margin)

		end
	elseif gameState== "game" then
		game.draw()
	end
end