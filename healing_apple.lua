local tool = script.Parent.Parent.applelife
local mordida = 0
local mxmordidas = 9999999999
tool.Activated:Connect(function()
	if mordida == mxmordidas then
	else
		game.Players.LocalPlayer.Character.Humanoid.Health = game.Players.LocalPlayer.Character.Humanoid.Health + 5
		game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(script.Parent.Animation):Play()
		mordida = mordida +1
	end
end)
