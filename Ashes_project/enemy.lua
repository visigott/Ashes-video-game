Enemy = Object:extend()
require "game"
sprites= {}
table.insert(sprites, "/images/guests/jeff.png")
table.insert(sprites, "/images/guests/elon.png")
table.insert(sprites, "/images/guests/mark.png")


function Enemy:new()
  local randomIndex = love.math.random(1, #sprites)
  self.image=love.graphics.newImage(sprites[randomIndex])
  a= true
  while a==true do
    spawnerX=love.math.random(1100, -100,1000)
    spawnerY=love.math.random(1100, -100,1000)
    if (spawnerX<0 or spawnerX>900) and spawnerY<600 then
      self.x = spawnerX
      self.y = spawnerY
    end
    if self.x and self.y then
    a = false
    end
  end 
    self.speed = 100
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.dead = false
    self.health = 3
    self.target_x = player.x
    self.target_y = player.y
    self.collidingPlayer= false
end

function Enemy:checkCollision(obj)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local obj_left = obj.x
    local obj_right = obj.x + obj.width
    local obj_top = obj.y
    local obj_bottom = obj.y + obj.height

    if  self_right > obj_left
    and self_left < obj_right
    and self_bottom > obj_top
    and self_top < obj_bottom then
        self.dead = true
    else
      self.dead = false
    end
end

function Enemy:aggro(dt, player)
  if not self.angle then
    self.angle = math.atan2(player.y - self.y, player.x - self.x)
  end
  a= self.angle
  if a==self.angle then
    self.angle = math.atan2(player.y - self.y, player.x - self.x)
  end
  local cos = math.cos(self.angle)
  local sin = math.sin(self.angle)
  self.x = self.x + cos * self.speed * dt
  self.y = self.y + sin * self.speed * dt
end

function Enemy:update(dt)
  self:aggro(dt, player)
  local window_width = love.graphics.getWidth()

  if self.x < 0 then
      self.x = 0
      self.speed = -self.speed
  elseif self.x + self.width > window_width then
      self.x = window_width - self.width
      self.speed= -self.speed
  end
end

function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y)
end