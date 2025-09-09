Player = Object:extend()
function Player:new()
    frames = {}
    for i=1,6 do
      table.insert(frames, love.graphics.newImage("/images/character/walk"..i..".png"))
    end
    self.x=300
    self.y=450
    self.speed = 300
    self.isLeft = false
    self.health = 1
    self.gravity = 3000
    self.onGround = true
    self.jumpForce= 1100
    self.velocityY = 0
    self.hasDashed = false
    self.isWalking = false
    self.currentFrame= 1
end
function Player:update(dt)
    self.height = frames[math.floor(self.currentFrame)]:getHeight()-10
    self.width = frames[math.floor(self.currentFrame)]:getWidth()-30
    if not self.isWalking then
      self.currentFrame=5
    end
    if not self.onGround then
      self.currentFrame=6
    end
    if self.isWalking and self.onGround then
      self.currentFrame= self.currentFrame+5*dt
      if self.currentFrame>=4 then
        self.currentFrame=1
      end
    end
    
    if love.keyboard.isDown("a") then
      self.isWalking=true
      if self.onGround==false then
        self.x = self.x - self.speed*dt*2
      else
        self.x = self.x - self.speed*dt
      end
      self.isLeft= true
    elseif love.keyboard.isDown("d") then
      self.isWalking=true
      if self.onGround==false then
        self.x = self.x + self.speed*dt*2
      else
        self.x = self.x + self.speed*dt
      end
      self.isLeft= false
    else
      self.isWalking= false
    end
    
    if not self.onGround then
        self.velocityY = self.velocityY + self.gravity * dt
    end

    -- Update player's position based on vertical velocity
    self.y = self.y + self.velocityY * dt

    -- Check if the player has landed on the ground
    if self.y >= 400 then  -- Assuming 400 is ground level
        self.y = 400       -- Reset position to ground level
        self.velocityY = 0 -- Stop downward movement
        self.onGround = true
    end
    self:wallCollision()
    if self:wallCollision() then
      self.onGround= true
    end
end

function Player:dash(x, y, dt)
  if not self.angle then
    self.angle = math.atan2(y - self.y, x - self.x)
    self.dashStartX = self.x
    self.dashStartY = self.y
    self.dashStartTime = love.timer.getTime()  -- Dash'in başlama zamanı
    self.dashDuration = 0.1,75   -- Dash süresi (saniye cinsinden)
    self.hasDashed = true  -- Dash başladığında bu özelliği true yap
  end

  local elapsedTime = love.timer.getTime() - self.dashStartTime
  local progress = elapsedTime / self.dashDuration

  if progress >= 1 then
    self.x = self.dashStartX + math.cos(self.angle) * 350
    self.y = self.dashStartY + math.sin(self.angle) * 350
    self.dashing = false
    self.angle = nil
    self.dashStartTime = nil
  else
    local distance = progress * 400
    self.x = self.dashStartX + math.cos(self.angle) * distance
    self.y = self.dashStartY + math.sin(self.angle) * distance
  end

  -- Çarpışma kontrolü
  -- checkCollisions(self.x, self.y)

  self.onGround = false
end


function Player:wallCollision()
  local window_width = love.graphics.getWidth() --wall collision
    if self.x<=0 then
      self.x= 0
    elseif self.x + self.width >= window_width then
      self.x=window_width -self.width
    end
end
function Player:jump()
    if self.onGround then
        -- Apply jump force (move upward)
        self.velocityY = -self.jumpForce
        self.onGround = false -- Player is now in the air
    end
end
function Player:draw()
  if self.isLeft==true then
    love.graphics.draw(frames[math.floor(self.currentFrame)], self.x+50, self.y, 0,-1, 1)
  elseif self.isLeft==false then
    love.graphics.draw(frames[math.floor(self.currentFrame)], self.x, self.y, 0, 1)
  end
end