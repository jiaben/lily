require "Base.init"
require "Base.AudioEngine"
require "Base.CCBReaderLoad"
require "Base.extern"
require "Base.Cocos2d"
require "Base.CocoStudio"
require "Layers.LoginLayer"
-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

createLoginLayer()