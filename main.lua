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

local win = assert(SDL.createWindow{
    title   = "arkenidar/lua-sdl from lua-maze-love2d",
    width   = 500,
    height  = 500,
    flags   = { SDL.window.Resizable },
    x       = 126,
    y       = 126,
})
local rdr, err = SDL.createRenderer(win, 0, 0)

function image_load(file)
local img, ret = image.load(file)
img = rdr:createTextureFromSurface(img)
return img
end

function next_map()
  map_current=1+map_current
  load_map("assets/map"..map[map_current]..".txt")
end

function load()
  tile_size=32*2

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
rdr:copy(image,nil,{x=xywh[1],y=xywh[2],w=xywh[3],h=xywh[4]})
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

local show = true

local running = true
while running do
  
    local mouse_down=false, mouse_position
  
    for e in SDL.pollEvent() do
        if e.type == SDL.event.Quit then
            running = false
        elseif e.type == SDL.event.MouseButtonDown then
            mouse_down = true
            mouse_position = {e.x, e.y}
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
    
    rdr:setDrawColor(0xFFFFFF) ; rdr:clear()
  
    draw()

    rdr:present()
end

------------------------------------------------------------
