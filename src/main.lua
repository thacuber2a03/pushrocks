import "globals"

Screen = {
	sizeInPixels = SCREEN_SIZE * SCALE,
	isDirty = true,
	toChange = {},
	pixels = {},
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
	for y=0, SCREEN_SIZE-1 do
		for x=0, SCREEN_SIZE-1 do
			table.insert(Screen.toChange, { x=x, y=y, color = color or WHITE })
		end
	end
end

---Set a pixel in the screen to `color`.
---@param x integer
---@param y integer
---@param color Color?
function Screen.setPixel(x, y, color)
	if x < 0 or y < 0 or x >= SCREEN_SIZE or y >= SCREEN_SIZE then return end
	table.insert(Screen.toChange, {
		x = math.floor(x),
		y = math.floor(y),
		color=color or BLACK
	})
	Screen.isDirty = true
end

---Draw sprite onto screen.
---@param sprite Sprite
---@param x integer
---@param y integer
function Screen.drawSprite(sprite, x, y)
	for py=0, sprite.height-1 do
		for px=0, sprite.width-1 do
			local pos = (py*sprite.width+px)+1
			local char = sprite.data:sub(pos, pos)
			local col
			--TODO(thacuber2a03): a stupid `tonumber` seems to be enough
			if     char == "0" then col = WHITE
			elseif char == "1" then col = BLACK
			elseif char == "2" then col = XOR
			end
			if not col then error("invalid color "..char) end
			Screen.setPixel(x+px, y+py, col)
		end
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
		local speed = .5
		if PD.buttonIsPressed "right" then px = px + speed end
		if PD.buttonIsPressed "left"  then px = px - speed end
		if PD.buttonIsPressed "down"  then py = py + speed end
		if PD.buttonIsPressed "up"    then py = py - speed end

		Screen.clear()
		Screen.drawSprite(testSprite, px, py)

		if Screen.isDirty then
			for _, p in ipairs(Screen.toChange) do
				local x, y = p.x+1, p.y+1
				if p.color ~= Screen.pixels[y][x] then
					local pixelRealSize = SCALE -- real
					GFX.setColor(p.color)
					GFX.fillRect(
						p.x*pixelRealSize,
						p.y*pixelRealSize,
						pixelRealSize, pixelRealSize
					)
					Screen.pixels[y][x] = p.color
				end
			end
			Screen.toChange = {}
			collectgarbage "collect"
			Screen.isDirty = false
		end
	end
end
