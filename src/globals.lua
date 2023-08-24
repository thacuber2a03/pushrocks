import "CoreLibs/object"

PD = playdate
GFX = PD.graphics
DISP = PD.display

DISP.setScale(4)
DWIDTH = DISP.getWidth()
DHEIGHT = DISP.getHeight()
SCALE = 1

---@alias Color
---| `BLACK`
---| `WHITE`
---| `XOR`
BLACK = GFX.kColorBlack
WHITE = GFX.kColorWhite
XOR   = GFX.kColorXOR

SCREEN_SIZE = 60
SCREEN_SIZE_SQR = SCREEN_SIZE * SCREEN_SIZE
SCREEN_SIZE_IN_PIX = SCREEN_SIZE * SCALE

---@class Sprite
---@field public width integer
---@field public height integer
---@field public data string
