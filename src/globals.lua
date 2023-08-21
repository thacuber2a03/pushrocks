import "CoreLibs/object"

PD = playdate
GFX = PD.graphics
DISP = PD.display

DWIDTH = DISP.getWidth()
DHEIGHT = DISP.getHeight()
SCALE = 3

---@alias Color
---| `BLACK`
---| `WHITE`
---| `XOR`
BLACK = GFX.kColorBlack
WHITE = GFX.kColorWhite
XOR   = GFX.kColorXOR

SCREEN_SIZE = (1<<6) -- or 64

---@class Sprite
---@field public width integer
---@field public height integer
---@field public data string
