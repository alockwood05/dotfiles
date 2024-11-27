-- enable command line usage
-- require("hs.ipc")

hs.loadSpoon("TextReplacer")
local TextReplacer = spoon.TextReplacer
TextReplacer:addReplacement("//today", function() return os.date("%Y-%m-%d") end)
TextReplacer:addReplacement("//time", function() return os.date("%H:%M:%S") end)
TextReplacer:start()

hs.loadSpoon("ClipboardTool")
local ClipboardTool = spoon.ClipboardTool
ClipboardTool:start()
