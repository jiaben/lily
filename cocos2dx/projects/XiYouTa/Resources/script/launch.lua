require "AudioEngine"
require "Base.extern"
require "Layers.LoginLayer"
-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

local function Login()
end

createLoginLayer()