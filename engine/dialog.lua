local dialog = {}
dialog.hidden = true
function dialog:nexttext()
if (self.printedText==self.textarray[self.arrayPosition][1]) then
if (self.textarray[self.arrayPosition+1]) then
self.typePosition = 0
self.printedText  = ""
self.arrayPosition= self.arrayPosition+1
self.textToPrint= self.textarray[self.arrayPosition][1]
self.finished = false
if (self.textarray[self.arrayPosition][2]) then
self.textarray[self.arrayPosition][2]()
end
else
self:hide()
if(self.endcallback) then
self.endcallback()
end
end
else 
self.printedText=self.textarray[self.arrayPosition][1]
self.typePosition=#self.printedText
end
end

function dialog:hide()
self.hidden = true
end

function dialog:start() 
    -- Full text we want to print
    self.textToPrint  = ""
    self.printedText  = "" -- Section of the text printed so far
    self.hidden = false
    -- Timer to know when to print a new letter
    self.typeTimerMax = 0.01 -- speed
    self.typeTimer 	 = 0.1
    
    -- Current position in the text
    self.typePosition = 0
self.arrayPosition=1
self.textToPrint= self.textarray[self.arrayPosition][1]
    
end

function dialog:update(dt)
-- Decrease timer
if (self.hidden == false) then
    	self.typeTimer = self.typeTimer - dt
    	
    	-- Timer done, we need to print a new letter:
    	-- Adjust position, use string.sub to get sub-string
    	if self.typeTimer <= 0 then
    		self.typeTimer = self.typeTimerMax
    		self.typePosition = self.typePosition + 1
    
    		self.printedText = string.sub(self.textToPrint,0,self.typePosition)
    	end

		
self.finished=self.printedText== self.textarray[self.arrayPosition][1]

end
end

    function dialog:draw(x,y,w)
    	-- Print text so far
if (self.hidden==false) then
    	love.graphics.printf(self.printedText,x,y,w)
end
    end        

return dialog
