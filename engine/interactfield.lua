local interactfield={}

function interactfield:check(x,y,w,h, func)
if (self.CheckCollision(self.x,self.y,self.width,self.height, x,y,w,h)) then
func()
end
end

function interactfield:update(dt,x,y)
self.x=x
self.y=y
end

function interactfield.CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
return interactfield