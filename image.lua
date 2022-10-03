
-- luarocks install lua-sdl2
-- https://luarocks.org/modules/tangent128/lua-sdl2

--
-- image.lua -- shows SDL_image module for Lua
--

-- https://github.com/Tangent128/luasdl2/blob/master/examples/image/image.lua
-- https://github.com/Tangent128/luasdl2/blob/master/examples/image/Lua-SDL2.png

local SDL	= require "SDL"
local image	= require "SDL.image"

local ret, err = SDL.init { SDL.flags.Video }
if not ret then
	error(err)
end

local formats, ret, err = image.init { image.flags.PNG }
if not ret then
	error(err)
end

local win, err = SDL.createWindow {
	title	= "Image",
	height	= 256,
	width	= 256
}

if not win then
	error(err)
end

local rdr, err = SDL.createRenderer(win, 0, 0)
if not rdr then
	error(err)
end

-- https://github.com/Tangent128/luasdl2/blob/master/tutorials/04-drawing/Lua-SDL2.png
-- https://github.com/Tangent128/luasdl2/blob/master/tutorials/04-drawing/tutorial.lua
local img, ret = image.load("Lua-SDL2.png")
if not img then
	error(err)
end

img = rdr:createTextureFromSurface(img)

--[[
for i = 1, 50 do

	rdr:setDrawColor(0xFFFFFF)
	rdr:clear()
	rdr:copy(img)
	rdr:present()

	SDL.delay(100)
end
--]]

local show = true

-- https://raw.githubusercontent.com/Tangent128/luasdl2/master/tutorials/03-events/tutorial.lua
local running = true

while running do
	--
	-- Iterate over all events, this function does not block.
	--
	for e in SDL.pollEvent() do
    
		if e.type == SDL.event.Quit then
			running = false
      
		elseif e.type == SDL.event.KeyDown then
			print(string.format("key down: %d -> %s", e.keysym.sym, SDL.getKeyName(e.keysym.sym)))
      
		elseif e.type == SDL.event.MouseWheel then
			print(string.format("mouse wheel: %d, x=%d, y=%d", e.which, e.x, e.y))
      
		elseif e.type == SDL.event.MouseButtonDown then
			print(string.format("mouse button down: %d, x=%d, y=%d", e.button, e.x, e.y))
      
      show = not show
      
		elseif e.type == SDL.event.MouseMotion then
			print(string.format("mouse motion: x=%d, y=%d", e.x, e.y))
      
		end
	end
  
  -- https://raw.githubusercontent.com/Tangent128/luasdl2/master/examples/image/image.lua
  rdr:setDrawColor(0xFFFFFF)
	rdr:clear()
	if show then rdr:copy(img) end
	rdr:present()

end