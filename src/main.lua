import "globals"

Screen = {
	sizeInPixels = 64 * SCALE,
	isDirty = true,
	toChange = {},
	pixels = {},
}

GFX.setDrawOffset(
	DWIDTH/2 - Screen.sizeInPixels/2,
	DHEIGHT/2 - Screen.sizeInPixels/2
)

---Force a clear, regardless of the screen's state.
---@param col Color?
function Screen.reset(col)
	Screen.toChange = {}
	Screen.pixels = {}
	for y=1, 64 do
		Screen.pixels[y] = {}
		for x=1, 64 do
			Screen.pixels[y][x] = {}
		end
	end

	GFX.clear(BLACK)
	GFX.setColor(col or WHITE)
	GFX.fillRect(0, 0, Screen.sizeInPixels, Screen.sizeInPixels)
end

---Set all the pixels on the screen to color `col`.
---@param col Color?
function Screen.clear(col)
	table.insert(Screen.toChange, col)
end

---Set a pixel in the screen to color `col`
---@param x integer
---@param y integer
---@param col Color?
function Screen.setPixel(x, y, col)
	if (x & (1 << 8)) == 1 or (y & (1 << 8)) == 1 then return end
	table.insert(Screen.toChange, {
		x = math.floor(x),
		y = math.floor(y),
		col = col or BLACK
	})
end

local init = true
function playdate.update()
	if init then
		Screen.reset(WHITE)
		init = false
	end

	Screen.clear()

	if Screen.isDirty then
		for _, p in ipairs(Screen.toChange) do
			if p.col ~= Screen.pixels[p.y][p.x] then
				local pixelRealSize = SCALE -- real
				GFX.setColor(p.col)
				GFX.fillRect(
					(p.x)*pixelRealSize,
					(p.y)*pixelRealSize,
					pixelRealSize, pixelRealSize
				)
				Screen.pixels[p.y] = Screen.pixels[p.y] or {}
				Screen.pixels[p.y][p.x] = p.col
			end
		end
		Screen.isDirty = false
	end
end
