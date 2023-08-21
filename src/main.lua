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
			Screen.pixels[y][x] = {}
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
			table.insert(Screen.toChange, { x=x, y=y, color=color or WHITE })
		end
	end
end

---Set a pixel in the screen to `color`.
---@param x integer
---@param y integer
---@param color Color?
function Screen.setPixel(x, y, color)
	if x < 0 or y < 0 or x > SCREEN_SIZE or y > SCREEN_SIZE then return end
	table.insert(Screen.toChange, {
		x = math.floor(x),
		y = math.floor(y),
		color = color or BLACK
	})
end

local init = true
function playdate.update()
	if init then
		Screen.reset(WHITE)
		init = false
	end

	if Screen.isDirty then
		for _, p in ipairs(Screen.toChange) do
			local x, y = p.x+1, p.y+1
			if p.color ~= Screen.pixels[y][x] then
				local pixelRealSize = SCALE -- real
				GFX.setColor(p.color)
				GFX.fillRect(
					(p.x)*pixelRealSize,
					(p.y)*pixelRealSize,
					pixelRealSize, pixelRealSize
				)
				Screen.pixels[y] = Screen.pixels[y] or {}
				Screen.pixels[y][x] = p.color
			end
		end
		Screen.isDirty = false
	end
end
