import "globals"

Screen = {
	sizeInPixels = SCREEN_SIZE * SCALE,
	isDirty = true,
	toChange = {},
	pixels = {},
	didChange = false,
}

GFX.setDrawOffset(
	DWIDTH/2 - Screen.sizeInPixels/2,
	DHEIGHT/2 - Screen.sizeInPixels/2
)

---Hard reset the screen.
---@param color Color?
function Screen.reset(color)
	Screen.toChange = {}
	Screen.pixels = {}
	for y=1, SCREEN_SIZE do
		Screen.pixels[y] = {}
		for x=1, SCREEN_SIZE do
			Screen.pixels[y][x] = WHITE
		end
	end

	GFX.clear(BLACK)
	GFX.setColor(color or WHITE)
	GFX.fillRect(0, 0, Screen.sizeInPixels, Screen.sizeInPixels)
end

---Set all the pixels on the screen to `color`.
---@param color Color?
function Screen.clear(color)
	Screen.drawRect(0, 0, SCREEN_SIZE, SCREEN_SIZE, color or WHITE)
end

---Set a pixel in the screen to `color`.
---@param x number
---@param y number
---@param color Color?
function Screen.setPixel(x, y, color)
	if x < 0 or y < 0 or x >= SCREEN_SIZE or y >= SCREEN_SIZE then return end
	if Screen.pixels[y+1][x+1] == color then return end
	table.insert(Screen.toChange, { x=x, y=y, color=color or BLACK })
	Screen.requestRedraw = true
end

---Draw a sprite onto the screen.
---@param sprite Sprite
---@param x integer
---@param y integer
function Screen.drawSprite(sprite, x, y)
	for py=0, sprite.height-1 do
		for px=0, sprite.width-1 do
			local pos = (py*sprite.width+px)+1
			local char = sprite.data:sub(pos, pos)
			local col
			if     char == "0" then col = WHITE
			elseif char == "1" then col = BLACK
			elseif char == "2" then col = XOR
			elseif char == "-" then goto continue
			end
			if not col then error("invalid color "..char) end
			Screen.setPixel(x+px, y+py, col)
		    ::continue::
		end
	end
end

---Draw a rectangle onto the screen.
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param color Color?
function Screen.drawRect(x, y, w, h, color)
	for ry=0, h-1 do
		for rx=0, w-1 do
			Screen.setPixel(x+rx, y+ry, color)
		end
	end
end

---`ipairs`, in reverse.
---@param t table
---@return function
local function ripairs(t)
	local i=#t+1
	return function()
		i=i-1
		local v = t[i]
		if not v then return end
		return i, v
	end
end

---@type Sprite
local testSprite = {
	width = 8,
	height = 8,
	data = "0011110000011000001111001111111100111100001111000010010000100100",
}

local px, py = 0, 0

local init = true
function PD.update()
	PD.drawFPS()
	if init then
		Screen.reset(WHITE)
		init = false
	else
		local speed = 1 -- in pixels
		if PD.buttonJustPressed "right" then px = px + speed end
		if PD.buttonJustPressed "left"  then px = px - speed end
		if PD.buttonJustPressed "down"  then py = py + speed end
		if PD.buttonJustPressed "up"    then py = py - speed end

		Screen.clear()
		Screen.drawSprite(testSprite, px, py)

		if Screen.requestRedraw then
			Screen.didChange = false
			for _, p in ripairs(Screen.toChange) do
				local x, y = p.x+1, p.y+1
				local pixelRealSize = SCALE -- real
				GFX.setColor(p.color)
				GFX.fillRect(
					p.x*pixelRealSize,
					p.y*pixelRealSize,
					pixelRealSize, pixelRealSize
				)
				Screen.pixels[y][x] = p.color
				Screen.didChange = true
			end
			Screen.toChange = {}
			Screen.requestRedraw = false
		end
	end
end
