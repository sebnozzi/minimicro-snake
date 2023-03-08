// == CONSTANTS

scaleFactor = 20
displayWidth = 48 // 960 / 20
displayHeight = 32 // 640 / 20

fieldWidth = 24
fieldHeight = 28

fieldBottomLeftX = displayWidth/2-fieldWidth/2
fieldBottomLeftY = displayHeight/2-fieldHeight/2

fieldColor = color.navy

KEY_LEFT = 17
KEY_RIGHT = 18
KEY_UP = 19
KEY_DOWN = 20

// == MAIN

main = function
	setupDisplay
	initObjects
	
	while Snake.alive
		
		if key.available then
			k = key.get
			keyCode = k.code
			
			if keyCode == KEY_LEFT then
				Snake.go(LEFT)
			else if keyCode == KEY_RIGHT then
				Snake.go(RIGHT)
			else if keyCode == KEY_UP then
				Snake.go(UP)
			else if keyCode == KEY_DOWN then
				Snake.go(DOWN)
			end if
		end if
		
		Snake.update
		
		drawFrame
		
		wait 0.1
	end while
	
	showGameOver
	
end function

// == DIRECTIONS

LEFT = {"dx": -1, "dy": 0}
RIGHT = {"dx": 1, "dy": 0}
UP = {"dx": 0, "dy": 1}
DOWN = {"dx": 0, "dy": -1}

// == SNAKE

Snake = {}
Snake.init = function
	x = fieldWidth / 2
	y = fieldHeight / 2
	self.parts = [
	{"x": x-2, "y": y}, 
	{"x": x-1, "y": y}, 
	{"x": x, "y": y}]
	self.direction = LEFT
	self.alive = true
end function

Snake.go = function(direction)
	// Calculate the opposite of the current direction
	opposite = {"dx": self.direction.dx * -1, "dy": self.direction.dy * -1}
	// Only change if the requested direction is not the
	// opposite of where we are headed.
	if direction != opposite then
		self.direction = direction
	end if
end function

Snake.update = function
	head = self.parts[0]
	// Compute new head
	newHead = {
	"x": (head.x + self.direction.dx + fieldWidth) % fieldWidth, 
	"y": (head.y + self.direction.dy + fieldHeight) % fieldHeight}	
	// Detect if new head is hitting the apple
	if newHead.x == Apple.x and newHead.y == Apple.y then
		// Add new head
		self.parts.insert(0,newHead)
		// Apple found! (should eat)
		Apple.beEaten
	else
		// Shrink (remove) tail
		self.parts.pop
		// Check for collision
		if self.occupies(newHead.x,newHead.y) then
			self.alive = false
		else
			// Add new head
			self.parts.insert(0,newHead)	
		end if
	end if
end function

Snake.occupies = function(x,y)
	for part in self.parts
		if part.x == x and part.y == y then return true
	end for
	return false
end function

Snake.draw = function
	for part in self.parts
		x = part.x
		y = part.y
		drawFieldPixel x,y,color.green
	end for
end function

// == APPLE

Apple = {}
Apple.init = function
	self.moveToRandomPosition
end function
Apple.beEaten = function
	self.moveToRandomPosition
end function
Apple.moveToRandomPosition = function
	while true
		self.x = floor(rnd * fieldWidth)
		self.y = floor(rnd * fieldHeight)
		if not Snake.occupies(self.x, self.y) then return
	end while
end function
Apple.draw = function
	drawFieldPixel self.x,self.y,color.red
end function

// == IMPLEMENTATION

setupDisplay = function
	clear
	gfx.scale = [scaleFactor, scaleFactor]
end function

initObjects = function
	Snake.init
	Apple.init
end function

// == DRAWING

drawFrame = function
	drawBackground
	Snake.draw
	Apple.draw
end function

drawField = function
	gfx.fillRect fieldBottomLeftX,fieldBottomLeftY,fieldWidth,fieldHeight,fieldColor
end function

drawFieldPixel = function(fieldX,fieldY,pixelColor)
	gfx.setPixel fieldBottomLeftX+fieldX,fieldBottomLeftY+fieldY,pixelColor	
end function

// == UI

showGameOver = function
	previousColor = text.color
	text.color = color.white
	
	msg = "Game Over"
	text.column = 68 / 2 - msg.len / 2
	text.row = 26 / 2
	text.print msg
	
	text.color = previousColor
end function

// == MAIN INVOCATION

main
