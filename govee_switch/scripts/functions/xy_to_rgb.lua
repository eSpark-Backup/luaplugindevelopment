-- Philips bridge works only with XY coordinate color system
-- There is function for translating from XY to RGB color representation system
local params = ...

local x = params.value[1]; --// the given x value
local y = params.value[2]; --// the given y value
local z = 1.0 - x - y;
local Y = params.brightness/254; --// The given brightness value
local X = (Y / y) * x;
local Z = (Y / y) * z;

local r =  X * 1.656492 - Y * 0.354851 - Z * 0.255038;
local g = -X * 0.707196 + Y * 1.655397 + Z * 0.036152;
local b =  X * 0.051713 - Y * 0.121364 + Z * 1.011530;

r = r <= 0.0031308 and 12.92 * r or (1.0 + 0.055) * r ^ (1.0 / 2.4) - 0.055;
g = g <= 0.0031308 and 12.92 * g or (1.0 + 0.055) * g ^ (1.0 / 2.4) - 0.055;
b = b <= 0.0031308 and 12.92 * b or (1.0 + 0.055) * b ^ (1.0 / 2.4) - 0.055;

-- result rounding
r = math.tointeger( r * 255 - (r * 255 % 1))
g = math.tointeger( g * 255 - (g * 255 % 1))
b = math.tointeger( b * 255 - (b * 255 % 1))

return {red = r, blue = b, green = g}
