-- luarocks install lua-sdl2
-- https://luarocks.org/modules/tangent128/lua-sdl2

local SDL = require("SDL")
assert(SDL.init{
    SDL.flags.Video,
})
print(string.format("SDL %d.%d.%d",
    SDL.VERSION_MAJOR,
    SDL.VERSION_MINOR,
    SDL.VERSION_PATCH
))
local image	= require "SDL.image"
local formats, ret, err = image.init { image.flags.PNG }

local img, ret = image.load("Lua-SDL2.png")

local win = assert(SDL.createWindow{
    title   = "02 - Opening a window", -- https://github.com/Tangent128/luasdl2/blob/master/tutorials/02-window/tutorial.lua
    width   = 320,
    height  = 320,
    flags   = { SDL.window.Resizable },
    x       = 126,
    y       = 126,
})
local rdr, err = SDL.createRenderer(win, 0, 0)
img = rdr:createTextureFromSurface(img)

local show = true

local running = true
while running do

    for e in SDL.pollEvent() do
        if e.type == SDL.event.Quit then
            running = false
        elseif e.type == SDL.event.MouseButtonDown then
            show = not show
        end
    end

    rdr:setDrawColor(0xFFFFFF) ; rdr:clear()

    if show then rdr:copy(img) end

    rdr:present()
end
