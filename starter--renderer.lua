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

---local renderer = sdl.createRenderer(window, -1, 0)

-- initialize event loop
local running = true
local event = ffi.new('SDL_Event')

-- initialize mouse
local mouse_down = false
local mouse_position = {0, 0}
local mouse_just_down = false

-- load assets

local image_surface = sdl.loadBMP("transparence.bmp")
local window_surface = sdl.getWindowSurface(window)
local rgb = {0,0,255} -- key color (blue is transparent)
local key = sdl.mapRGB(window_surface.format,rgb[1],rgb[2],rgb[3])
sdl.setColorKey(image_surface, sdl.TRUE, key)

---local image_texture = sdl.createTextureFromSurface(renderer, image_surface)

local image_texture
if renderer then
  ffi.load("SDL2_image", true) -- libsdl2-image-dev -- /usr/lib/x86_64-linux-gnu/libSDL2_image.so
  ffi.cdef([[ SDL_Texture * IMG_LoadTexture(SDL_Renderer *renderer, const char *file); ]])
  -- this can load optionally semi-transparent PNGs as textures
  image_texture = C.IMG_LoadTexture(renderer, "transparence.png") -- "assets/P.bmp"
end

local image
if renderer then
  image = image_texture
else
  image = image_surface
end

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
  
  local mx = ffi.new("int[1]")
  local my = ffi.new("int[1]")
  sdl.getMouseState(mx, my)
  mouse_position = { mx[0], my[0]}
  
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
  
  -- utility
  function tapped(xywh)
    return mouse_inside(xywh) and mouse_just_down
  end
  
  -- initializations
  
  local w, h = window_surface.w, window_surface.h
  
  local draw = {}
  
  -- colors
  local yellow = {255,255,0}
  local blue = {0,0,255}
  
  --*(update)*******************************************
  
  local xywh = {w/2, h/2, w/4, h/4}
 
  if tapped(xywh) then -- if clicked
    show = not show -- then alternate/toggle
  end

  --*(draw)*******************************************
  
  function draw.background(draw)
    draw.ops.rectangle(blue, nil) -- blue background
  end
  
  function draw.main(draw)
    if show then -- alternate/toggle
      draw.ops.image(image, xywh) -- draw image
    else
      draw.ops.rectangle(yellow, xywh) -- draw rectangle
    end
  end

  --********************************************
  
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
  function draw_image_surface(image_surface, xywh)
    sdl.upperBlitScaled(image_surface, nil, window_surface, rect_from_xywh(xywh) )
  end
  function draw_image_texture(image_texture, xywh)
    sdl.renderCopy(renderer, image_texture, nil, rect_from_xywh(xywh))
  end
  
  function draw_image(image_texture, xywh)
    if renderer then
      draw_image_texture(image_texture, xywh)
    else
      draw_image_surface(image_surface, xywh)
    end
  end
  
  -- utility
  function draw_rect_surface(rgb, xywh)
    sdl.fillRect(window_surface, rect_from_xywh(xywh), sdl.mapRGB(window_surface.format,rgb[1],rgb[2],rgb[3]))
  end
  function draw_rect_renderer(rgb, xywh)
    sdl.setRenderDrawColor(renderer,rgb[1],rgb[2],rgb[3],255)
    sdl.renderFillRect(renderer, rect_from_xywh(xywh))
  end
  
  function draw_rect(rgb, xywh)
    if renderer then
      draw_rect_renderer(rgb, xywh)
    else
      draw_rect_surface(rgb, xywh)
    end
  end
  
  -- utility
  function present()
    if renderer then
      sdl.renderPresent(renderer)
    else
      sdl.updateWindowSurface(window)
    end
  end

  draw.ops = {
    image = draw_image,
    rectangle = draw_rect,
  }
  --************************************************
  
  -- clear (draw begin)
  draw:background()
  
  -- complex/composite draw (main object)
  draw:main()
  
  -- present (draw end)
  present()

end
