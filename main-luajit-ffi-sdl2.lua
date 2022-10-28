------------------------------------------------------------
function load_map(file_path)
  grid={}
  local line_count=1
  for line in io.lines(file_path) do
    local row={}
    for i=1,#line do
      local char=line:sub(i,i)
      if char=="P" then
        px=i
        py=line_count
        char=" "
      end
      table.insert(row,char)
    end
    table.insert(grid,row)
    line_count=line_count+1
  end
end
------------------------------------------------------------

-- https://github.com/torch/sdl2-ffi
local sdl = require("sdl2")
local ffi = require 'ffi'

sdl.init(sdl.INIT_VIDEO)

local window = sdl.createWindow("Hello Maze",
                                sdl.WINDOWPOS_CENTERED,
                                sdl.WINDOWPOS_CENTERED,
                                512,
                                512,
                                sdl.WINDOW_SHOWN)

local windowsurface = sdl.getWindowSurface(window)

function image_load(file)
  return sdl.loadBMP(file)
end

function next_map()
  map_current=1+map_current
  load_map("assets/map"..map[map_current]..".txt")
end

function load()
  tile_size=32

	local player=image_load("assets/P.bmp")
  local space=image_load("assets/-.bmp")
  local wall=image_load("assets/W.bmp")
  local exit=image_load("assets/E.bmp")
  tile={P=player,[" "]=space,["#"]=wall,E=exit}
  map={"01","02","03"}
  map_current=0
  next_map()
end

load()

function image_draw(image,xywh)
  
  local rect = ffi.new('SDL_Rect')
  rect.x = xywh[1]
  rect.y = xywh[2]
  rect.w = xywh[3]
  rect.h = xywh[4]
  
  sdl.upperBlit(image, nil, windowsurface, rect)
end

function draw()
  for y=1,#grid do
    for x=1,#grid[1] do
      local tile_type=grid[y][x]
      if x==px and y==py then tile_type="P" end
      local dx,dy=(x-1)*tile_size,(y-1)*tile_size
      image_draw(tile[tile_type],{dx,dy,tile_size,tile_size})
    end
  end
end

local running = true
local event = ffi.new('SDL_Event')

local mouse_down=false
local mouse_position={0,0}

while running do
    
  while sdl.pollEvent(event) ~= 0 do
    if event.type == sdl.QUIT then
      running = false
    
    elseif event.type == sdl.MOUSEBUTTONDOWN then
      mouse_down = true
    elseif event.type == sdl.MOUSEBUTTONUP then
      mouse_down = false
      
    elseif event.type == sdl.MOUSEMOTION then
      mouse_position = {event.button.x, event.button.y}
    end
  end
    
  function update()
    if mouse_down then
      local mx,my=mouse_position[1],mouse_position[2]
      local tx,ty=math.floor(mx/tile_size)+1,math.floor(my/tile_size)+1
      
      if grid[ty]~=nil and grid[ty][tx]~=nil then
        if
        (math.abs(tx-px)==1 and ty==py)
        or (math.abs(ty-py)==1 and tx==px)
        then
          local going=grid[ty][tx]
          if going~="#" then
            px,py=tx,ty
            if going=="E" then next_map() end
          end
        end
      end
    
    end
  end
  
  update()
  
  draw()
  
  sdl.updateWindowSurface(window)
   
end
