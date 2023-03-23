# lua-sdl options discussed, use cases

use case: raw, non-layered, Lua + SDL2 API use cases.
non-layered unlike more sophisticated SDL-based softwares like Love2D API/Runtime (Love2D: SDL also, Lua also, but layered/engine/runtime).

This repository collects useful pieces of software/informations in such theme, mostly source codes and links.

LUA-ROCKS OPTION: Using binding: (available both to Lua and to LuaJIT)

https://github.com/arkenidar/lua-sdl/blob/main/main.lua

https://luarocks.org/modules/tangent128/lua-sdl2

LUA-ROCKS OPTION: Using both luarock and FFI (FFI currently requires LuaJIT)

https://github.com/arkenidar/lua-sdl/blob/main/main-luajit-ffi-sdl2.lua

https://github.com/arkenidar/lua-sdl2-ffi-luajit

... forked from:

https://github.com/torch/sdl2-ffi

(EXTERNAL! repo linked) NON-LUA-ROCKS OPTION: Using only FFI and not luarocks (FFI currently requires LuaJIT)

https://github.com/arkenidar/ffi-luajit-sdl/blob/master/maze.lua

https://github.com/arkenidar/ffi-luajit-sdl

https://gist.github.com/arkenidar/bc66711dd73b047a5995f97f4b019f38

... forked from:

https://gist.github.com/creationix/1213280
