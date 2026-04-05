import os

patch_dir = "projects/1000y/完整代码/tgs1000"
uLuaEngine_content = """unit uLuaEngine;

interface

uses
  Windows, SysUtils, Classes, Dialogs;

type
  lua_State = Pointer;
  lua_CFunction = function(L: lua_State): Integer; cdecl;

var
  luaL_newstate: function: lua_State; cdecl;
  luaL_openlibs: procedure(L: lua_State); cdecl;
  lua_close: procedure(L: lua_State); cdecl;
  luaL_loadfilex: function(L: lua_State; const filename: PAnsiChar; const mode: PAnsiChar): Integer; cdecl;
  lua_pcallk: function(L: lua_State; nargs, nresults, errfunc: Integer; ctx: Integer; k: Pointer): Integer; cdecl;
  lua_pushcclosure: procedure(L: lua_State; fn: lua_CFunction; n: Integer); cdecl;
  lua_setglobal: procedure(L: lua_State; const name: PAnsiChar); cdecl;
  lua_tolstring: function(L: lua_State; idx: Integer; len: PInteger): PAnsiChar; cdecl;
  
  g_LuaState: lua_State;
  hLuaDll: HMODULE;

function InitLuaEngine: Boolean;
procedure FreeLuaEngine;

implementation

function lua_P_saysystem(L: lua_State): Integer; cdecl;
var
  Msg: string;
begin
  Result := 0;
  if Assigned(lua_tolstring) then
  begin
    Msg := string(lua_tolstring(L, 1, nil));
    MessageBox(0, PChar('Lua Msg: ' + Msg), 'Lua', MB_OK);
  end;
end;

function InitLuaEngine: Boolean;
begin
  Result := False;
  hLuaDll := LoadLibrary('lua5.4.6.dll');
  if hLuaDll = 0 then Exit;

  @luaL_newstate := GetProcAddress(hLuaDll, 'luaL_newstate');
  @luaL_openlibs := GetProcAddress(hLuaDll, 'luaL_openlibs');
  @lua_close := GetProcAddress(hLuaDll, 'lua_close');
  @luaL_loadfilex := GetProcAddress(hLuaDll, 'luaL_loadfilex');
  @lua_pcallk := GetProcAddress(hLuaDll, 'lua_pcallk');
  @lua_pushcclosure := GetProcAddress(hLuaDll, 'lua_pushcclosure');
  @lua_setglobal := GetProcAddress(hLuaDll, 'lua_setglobal');
  @lua_tolstring := GetProcAddress(hLuaDll, 'lua_tolstring');

  if Assigned(luaL_newstate) then g_LuaState := luaL_newstate();
  if g_LuaState = nil then Exit;

  if Assigned(luaL_openlibs) then luaL_openlibs(g_LuaState);

  if Assigned(lua_pushcclosure) and Assigned(lua_setglobal) then
  begin
    lua_pushcclosure(g_LuaState, @lua_P_saysystem, 0);
    lua_setglobal(g_LuaState, 'P_saysystem');
  end;

  Result := True;
end;

procedure FreeLuaEngine;
begin
  if g_LuaState <> nil then
  begin
    if Assigned(lua_close) then lua_close(g_LuaState);
    g_LuaState := nil;
  end;
  if hLuaDll <> 0 then FreeLibrary(hLuaDll);
end;

end.
"""

with open(f"{patch_dir}/uLuaEngine.pas", "w", encoding="gbk") as f:
    f.write(uLuaEngine_content)

print("Created uLuaEngine.pas locally!")
