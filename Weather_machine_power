--Made by Stickmasterluke


local sp = script.Parent


--todo: steam particles form stacks
--todo: spinning turbine
--todo: adjustable speed of globespin
--todo: engine colors
--todo: tube colors

local powerLevelTag = sp:WaitForChild('PowerLevel')
local globeTag = sp:WaitForChild('Globe'):WaitForChild('SpinGlobeEnabled')
local screenFrame = sp:WaitForChild('Screen'):WaitForChild('SurfaceGui'):WaitForChild('TextLabelFull')
local tube1 = sp:WaitForChild('Tube1')
local tube2 = sp:WaitForChild('Tube2')
local engineColor = sp:WaitForChild('EngineColor')
local emitter1 = sp:WaitForChild('Stacks'):WaitForChild('Union1'):WaitForChild('ParticleEmitter')
local emitter2 = sp:WaitForChild('Stacks'):WaitForChild('Union2'):WaitForChild('ParticleEmitter')

local mainPart = sp:WaitForChild('MainPart')
local letterSorting = mainPart:WaitForChild('LetterSorting')
local powerDown = mainPart:WaitForChild('PowerDown')
local powerUpSound = mainPart:WaitForChild('PowerUpSound')


local engineColors = {
	[0] = 'Black',
	[1] = 'Pastel Blue',
	[2] = 'Pastel violet',
	[3] = 'Alder',
	[4] = 'Carnation pink',
	[5] = 'Persimmon',
	[6] = 'Bright red',
	[7] = 'Really red',
	[8] = 'Toothpaste',
	[9] = 'Lime green',
}

local lastValue = powerLevelTag.Value
function updateState()
	local val = powerLevelTag.Value
	if val > lastValue then
		powerUpSound:Play()
	end
	lastValue = val

	screenFrame.Text = tostring(val)

	tube1.BrickColor = BrickColor.new(val >= 1 and 'Cyan' or 'Light blue')
	tube2.BrickColor = BrickColor.new(val >= 3 and 'Cyan' or 'Light blue')
	engineColor.BrickColor = BrickColor.new(engineColors[val] or 'Institutional white')
	emitter2.Enabled = val >= 2
	emitter1.Enabled = val >= 4

	if val <= 0 then
		globeTag.Value = false
		powerDown:Play()
		letterSorting:Stop()
	else
		letterSorting.Pitch = val*.5
		letterSorting:Play()
		globeTag.Value = true
	end
end

updateState()

powerLevelTag.Changed:connect(updateState)


