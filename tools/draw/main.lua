---@diagnostic disable: unused-local
io.stdout:setvbuf "no"

local suit = require 'suit'

local colors = {
	white = "white",
	black = "black",
	xor   = "xor",
	trnsp = "transparent",
}

local currentColor = colors.trnsp

local sprite = {
	width = 8,
	height = 8,
	data = {},
}

for i=1, sprite.width*sprite.height do
	sprite.data[i] = colors.trnsp
end

function love.load()
	
end

function love.update(dt)
	suit.layout:reset(10, 10)
	if suit.Button("save and exit", suit.layout:row(90, 20)).hit then
		local f = io.open("out.lua", "w+b")
		if not f then error "couldn't open output file" end
		f:write "local sprite = {\n"
		f:write(string.format("\twidth = %i, height = %i,\n", sprite.width, sprite.height))

		local encoded = ""
		for i=1, sprite.width*sprite.height do
			if sprite.data[i] == colors.trnsp then
				encoded = encoded .. "-"
			else
				encoded = encoded .. sprite.data[i]
			end
		end
		f:write("\tdata = \""..encoded.."\",\n")
		f:write "}"
		f:close()

		print "wrote output file; exiting..."

		love.event.quit()
	end

	suit.Label("current color: "..currentColor, { valign = "top" }, suit.layout:row(nil, 30))
	--suit.layout:nextRow()
	--suit.layout:col(40, 40)

	if suit.Button(colors.white, suit.layout:row(45, 45)).hit then currentColor = colors.white end
	if suit.Button(colors.black, suit.layout:col()).hit       then currentColor = colors.black end
	suit.layout:left()
	if suit.Button(colors.xor,   suit.layout:row()).hit then currentColor = colors.xor   end
	if suit.Button(colors.trnsp, suit.layout:col()).hit then currentColor = colors.trnsp end
end

function love.keypressed(k)
	if k == "escape" then love.event.quit() end
end

function love.draw()
	suit.draw()
end
