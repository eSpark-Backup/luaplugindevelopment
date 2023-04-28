-- Philips bridge works only with XY coordinate color system
-- There is function for translating from RGB to XY color representation system
local params = ...

local  redC =  (params.value.red / 255)
local  greenC = (params.value.green / 255)
local blueC = (params.value.blue / 255)

local redN = (redC > 0.04045) and (((redC + 0.055) / (1.0 + 0.055)) ^ 2.4) or (redC / 12.92)
local greenN = (greenC > 0.04045) and (((greenC + 0.055) / (1.0 + 0.055)) ^ 2.4) or (greenC / 12.92)
local blueN = (blueC > 0.04045) and (((blueC + 0.055) / (1.0 + 0.055))^ 2.4) or (blueC / 12.92)

local X = redN * 0.649926 + greenN * 0.130455 + blueN * 0.197109;

local Y = redN * 0.234327 + greenN * 0.743075 + blueN * 0.022598;

local Z = redN * 0.0 + greenN * 0.053077 + blueN * 1.035763;

local x = X / (X + Y + Z);

local y = Y / (X + Y + Z);

-- rounding number to 4 decimal places
x = ( x * 10000 - x * 10000 % 1)/10000
y = ( y * 10000 - y * 10000 % 1)/10000


return {x,y}
