-- https://github.com/torch/sdl2-ffi
local sdl = require("sdl2")
local ffi = require("ffi")
local C = ffi.C

-- initialize SDL
sdl.init(sdl.INIT_VIDEO)

-- create window
local window = sdl.createWindow("Hello Starter",
                                sdl.WINDOWPOS_CENTERED,
                                sdl.WINDOWPOS_CENTERED,
                                512,
                                512,
                                bit.bor( sdl.WINDOW_SHOWN , sdl.WINDOW_RESIZABLE ) )

-- initialize event loop
local running = true
local event = ffi.new('SDL_Event')

-- initialize mouse
local mouse_down = false
local mouse_position = {0, 0}
local mouse_just_down = false

-- load assets
local image = sdl.loadBMP("assets/P.bmp")

-- initial game state
local show = true

-- main loop (iterations)
while running do
  
  -- initialize this current loop iteration
  
  local window_surface = sdl.getWindowSurface(window)
  
  mouse_just_down = false
  
  -- handle events
  
  while sdl.pollEvent(event) ~= 0 do
    
    -- quit stops running
    if event.type == sdl.QUIT then
      running = false
    
    -- mouse_down, mouse_just_down
    elseif event.type == sdl.MOUSEBUTTONDOWN then
      if mouse_down == false then
        mouse_just_down = true
      end
      mouse_down = true
      
    elseif event.type == sdl.MOUSEBUTTONUP then
      mouse_down = false
    
    -- mouse_position
    elseif event.type == sdl.MOUSEMOTION then
      mouse_position = {event.button.x, event.button.y}
    end
  end
  
  -- utility
  function point_in_rectangle(point,xywh)
    return
      point[1]>=xywh[1] and
      point[1]<=(xywh[1]+xywh[3]) and
      point[2]>=xywh[2] and
      point[2]<=(xywh[2]+xywh[4])
  end
  
  -- utility
  function mouse_inside(xywh)
    return point_in_rectangle(mouse_position,xywh)
  end
  
  --update
  
  -- sizes and positions
  local w, h = window_surface.w/2, window_surface.h/2
  local xywh = {w, h, w/2, h/2}
 
  -- if clicked
  if mouse_inside(xywh) and mouse_just_down then
    -- then alternate/toggle
    show = not show
  end

  -- utility
  function rect_from_xywh(xywh)
    if xywh == nil then return nil end
    local rect = ffi.new('SDL_Rect')
    rect.x = xywh[1]
    rect.y = xywh[2]
    rect.w = xywh[3]
    rect.h = xywh[4]
    return rect
  end
  
  -- utility
  function draw_image(image, xywh)
    sdl.upperBlitScaled(image, nil, window_surface, rect_from_xywh(xywh) )
  end
  
  -- utility
  function draw_rect(rgb, xywh)
    sdl.fillRect(window_surface, rect_from_xywh(xywh), sdl.mapRGB(window_surface.format,rgb[1],rgb[2],rgb[3]))
  end

  -- clear (draw begin)
  draw_rect({0,0,0}, nil)
  
  -- draw
  if show then
    draw_image(image, xywh)
  else
    draw_rect({255,255,0}, xywh)
  end

  -- present (draw end)
  sdl.updateWindowSurface(window)
end