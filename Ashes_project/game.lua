 game = {}
  
function game.load()
  Object = require "/helpers/classic"
  require "player"
  require "enemy"
  require "bullet"
  require "main"

  background=love.graphics.newImage("/images/backgrounds/background.png")
  font = love.graphics.newFont("minecraft.ttf",15)
  fontScore = love.graphics.newFont("minecraft.ttf", 30)
  player = Player()
  listOfBullets = {}
  listOfEnemies = {}
  enemySpawnTimer = 0
  spawnInterval = math.random(1, 3)
  spawner=2
  score=0
  handle100= false
end



function love.mousepressed(x, y, button) ------------------------------------------------------------------------------------------------
    if button == 2  then
        local newBullet = Bullet(player, x, y)  -- Create a new bullet at the clicked position
        newBullet.target_x = x
        newBullet.target_y = y

        table.insert(listOfBullets, newBullet)  -- Add it to the bullets table
    end
end



function love.keypressed(key)
  if key == "space" and not player.dashing and (player.onGround or not player.hasDashed) then
    player.dashing = true
    player.dashTargetX, player.dashTargetY = love.mouse.getPosition()
    print("Dash initiated towards:", player.dashTargetX, player.dashTargetY)
    -- Eğer zıplayış sonrası dashing yapılacaksa, hasDashed'ı true yapıyoruz
    if not player.onGround then
      player.hasDashed = true
    end
  end
end



function game.update(dt)  ---------------------------------------------------------------------------------------------------------------
  
  if player.health <= 0 then
    finalScore = score  -- Save the final score for display in the menu
  end
  player:update(dt)
  if score % 100 == 0 and score ~= 0 and not handle100 then
      handle100 = true
      spawner = spawner - (spawner - 1) / 4
      player.health = player.health + 1
  elseif score % 100 ~= 0 then
      handle100 = false  -- Reset when the score is not a multiple of 100
  end

  enemySpawnTimer = enemySpawnTimer + dt -------------------enemy spawner.
  if enemySpawnTimer >= spawnInterval then
    enemySpawnTimer = 0  -- Reset the timer
    spawnInterval = math.random(1, spawner)
    table.insert(listOfEnemies, Enemy(x, y))
  end
  
  
  if love.keyboard.isDown("w") then -------------------------jump mechanics.
        player:jump()
  end


  for i,v in ipairs(listOfBullets) do ----------------------------bullets mechanics and check collision with enemies
      v:update(dt)
      for j,k in ipairs(listOfEnemies) do
        v:checkCollision(listOfEnemies[j])
        if v.dead then
          table.remove(listOfBullets, i)
          k.health= k.health -1
          break
        end
        if k.health==0 then
          score= score+10
          table.remove(listOfEnemies, j)
        end
      end
  end    


  for i,v in ipairs(listOfEnemies) do ---------------------enemy mechanics and check collision with player
    v:update(dt, player)
    v:checkCollision(player)
    if v.dead and not player.dashing and not v.collidingPlayer then
      player.health = player.health-1
      v.collidingPlayer= true
    elseif v.dead and player.dashing then
      v.health=v.health-3
    elseif not v.dead then
      v.collidingPlayer= false
    end
    if v.health<=0 then
      table.remove(listOfEnemies, i)
      score= score+10
    end
  end


  if player.onGround then --------------------------------------DASH MECHANICS.
    player.hasDashed = false
  end

  if player.dashing then
    player:dash(player.dashTargetX, player.dashTargetY, dt)
  end
end





function game.draw()
  love.graphics.draw(background)
  player:draw()
  love.graphics.setFont(font)
  love.graphics.print("HP: " .. player.health, player.x, player.y -20)
  love.graphics.setFont(fontScore)
  love.graphics.print(score, love.graphics.getWidth()/2-50, 10)
  for i,v in ipairs(listOfEnemies) do
        v:draw()
        love.graphics.setFont(font)
        love.graphics.print("HP: " .. v.health, v.x, v.y - 20) -- Position text above the enemy
        
  end
  
  for i,v in ipairs(listOfBullets) do
        v:draw()
  end
end 