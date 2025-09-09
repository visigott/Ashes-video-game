  --! bullet.lua
  Bullet = Object:extend()

  function Bullet:new(player, x, y)
    self.image = love.graphics.newImage("/images/dagger.png")
    self.x = player.x+30
    self.y = player.y+50 
    self.speed = 1000
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.target_x = x
    self.target_y = y
    self.origin_x = self.image:getWidth()/2
    self.origin_y = self.image:getHeight()/2
  end
  
function Bullet:checkCollision(obj)
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

        --Increase enemy speed
        if obj.speed > 0 then
          obj.speed = obj.speed + 50
        elseif obj.speed < 0 then
          obj.speed = obj.speed - 50
        end
    end
end


function Bullet:update(dt)
    if self.target_x and self.target_y then
      if not self.angle then
        self.angle = math.atan2(self.target_y - self.y, self.target_x - self.x)
      end
        local cos = math.cos(self.angle)
        local sin = math.sin(self.angle)
        self.x = self.x + cos * self.speed * dt
        self.y = self.y + sin * self.speed * dt
    end
end    

function Bullet:draw()
  love.graphics.draw(self.image, self.x, self.y, self.angle, 1, 1, self.origin_x, self.origin_y)
end