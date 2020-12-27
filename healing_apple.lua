Tool = script.Parent

Tool.Activated:connect(
function(mouse)
local hum = Tool.Parent:FindFirstChild("Humanoid")
if (hum ~= nil) then
hum.Health = hum.Health + 15
end end)

Tool.Equipped:connect(
function(mouse)
mouse.Icon = "rbxasset://textures\\GunCursor.png"
end)
