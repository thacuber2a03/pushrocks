import "globals"

Screen = {}

local displayImage = GFX.image.new(SCREEN_SIZE, SCREEN_SIZE, BLACK)

---Hard reset the screen.
---@param color Color?
function Screen:reset(color)
	GFX.unlockFocus()
	GFX.clear(BLACK)
	GFX.lockFocus(displayImage)
	self:clear(color)
end

---Set all the pixels on the screen to `color`.
---@param color Color?
function Screen:clear(color)
	self:drawRect(0, 0, SCREEN_SIZE, SCREEN_SIZE, color or WHITE)
end

---Set a pixel in the screen to `color`.
---@param x number
---@param y number
---@param color Color?
function Screen:setPixel(x, y, color)
	color = color or WHITE
	
	if x < 0 or y < 0 or x >= SCREEN_SIZE or y >= SCREEN_SIZE then return end
	x = math.floor(x); y = math.floor(y)

	self.pixels[(y*SCREEN_SIZE+x)+1] = color
end

---Draw a sprite onto the screen.
---@param sprite Sprite
---@param x integer
---@param y integer
function Screen:drawSprite(sprite, x, y)
	sprite:draw(x, y)
end

---Draw a rectangle onto the screen.
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param color Color?
function Screen:drawRect(x, y, w, h, color)
	GFX.setColor(color or WHITE)
	GFX.fillRect(x, y, w, h)
	self.didChange = true
end

---Ask the screen for a redraw.
---@return boolean # If the screen did change.
function Screen:requestRedraw()
	if self.didChange then
		GFX.unlockFocus()
		displayImage:draw((DWIDTH - SCREEN_SIZE) // 2, (DHEIGHT - SCREEN_SIZE) // 2)
		GFX.lockFocus(displayImage)
	end
	
	return self.didChange
end

---@type Sprite
local testSprite = GFX.image.new("player")

local px, py = 0, 0
local oldPx, oldPy

GFX.clear(BLACK)
GFX.lockFocus(displayImage)
Screen:reset(WHITE)

function PD.update()
	if PD.buttonIsPressed "right" then px = px + 2 end
	if PD.buttonIsPressed "left"  then px = px - 2 end
	if PD.buttonIsPressed "down"  then py = py + 2 end
	if PD.buttonIsPressed "up"    then py = py - 2 end

	if oldPx ~= px or oldPy ~= py then
		Screen:clear()
		Screen:drawSprite(testSprite, px, py)
		oldPx, oldPy = px, py
	end
	
	if not Screen:requestRedraw() then
		Screen.didChange = false
	end
	
	PD.drawFPS()
end
