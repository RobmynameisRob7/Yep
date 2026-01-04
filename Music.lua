-- MUSIC PLAYER GUI - FINAL FULL VERSION

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- SOUND
local sound = Instance.new("Sound")
sound.Volume = 1
sound.Looped = false
sound.Parent = workspace

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.4, 0.42)
frame.Position = UDim2.fromScale(0.3, 0.3)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

-- HIDE / SHOW
local hide = Instance.new("TextButton", frame)
hide.Size = UDim2.fromScale(0.15,0.1)
hide.Position = UDim2.fromScale(0.83,0.02)
hide.Text = "X"

local show = Instance.new("TextButton", gui)
show.Size = UDim2.fromScale(0.07,0.07)
show.Position = UDim2.fromScale(0.01,0.15)
show.Text = "🎵"
show.Visible = false

-- ID BOX
local idBox = Instance.new("TextBox", frame)
idBox.Size = UDim2.fromScale(0.9,0.1)
idBox.Position = UDim2.fromScale(0.05,0.14)
idBox.PlaceholderText = "Nhập ID nhạc (đổi lúc đang phát được)"

-- BUTTONS
local play = Instance.new("TextButton", frame)
play.Text = "▶ / ⏸"
play.Size = UDim2.fromScale(0.25,0.1)
play.Position = UDim2.fromScale(0.05,0.28)

local reset = Instance.new("TextButton", frame)
reset.Text = "RESET"
reset.Size = UDim2.fromScale(0.2,0.1)
reset.Position = UDim2.fromScale(0.35,0.28)

-- SPEED
local speed = 1

local speedUp = Instance.new("TextButton", frame)
speedUp.Text = "Speed +"
speedUp.Size = UDim2.fromScale(0.18,0.1)
speedUp.Position = UDim2.fromScale(0.6,0.28)

local speedDown = Instance.new("TextButton", frame)
speedDown.Text = "Speed -"
speedDown.Size = UDim2.fromScale(0.18,0.1)
speedDown.Position = UDim2.fromScale(0.6,0.40)

-- SEEK BAR (TUA)
local barBack = Instance.new("Frame", frame)
barBack.Size = UDim2.fromScale(0.9,0.06)
barBack.Position = UDim2.fromScale(0.05,0.48)
barBack.BackgroundColor3 = Color3.fromRGB(70,70,70)

local bar = Instance.new("Frame", barBack)
bar.Size = UDim2.fromScale(0,1)
bar.BackgroundColor3 = Color3.fromRGB(0,200,0)

-- TIME
local timeText = Instance.new("TextLabel", frame)
timeText.Size = UDim2.fromScale(0.9,0.07)
timeText.Position = UDim2.fromScale(0.05,0.55)
timeText.BackgroundTransparency = 1
timeText.TextColor3 = Color3.new(1,1,1)
timeText.Text = "0:00 / 0:00"

-- VOLUME
local volText = Instance.new("TextLabel", frame)
volText.Text = "Volume"
volText.Size = UDim2.fromScale(0.2,0.06)
volText.Position = UDim2.fromScale(0.05,0.63)
volText.BackgroundTransparency = 1
volText.TextColor3 = Color3.new(1,1,1)

local volBack = Instance.new("Frame", frame)
volBack.Size = UDim2.fromScale(0.65,0.05)
volBack.Position = UDim2.fromScale(0.25,0.64)
volBack.BackgroundColor3 = Color3.fromRGB(70,70,70)

local volBar = Instance.new("Frame", volBack)
volBar.Size = UDim2.fromScale(1,1)
volBar.BackgroundColor3 = Color3.fromRGB(0,150,255)

-- MINI BAR
local miniBack = Instance.new("Frame", gui)
miniBack.Size = UDim2.fromScale(0.2,0.015)
miniBack.Position = UDim2.fromScale(0.01,0.1)
miniBack.BackgroundColor3 = Color3.fromRGB(60,60,60)

local miniBar = Instance.new("Frame", miniBack)
miniBar.Size = UDim2.fromScale(0,1)
miniBar.BackgroundColor3 = Color3.fromRGB(0,255,0)

-- FORMAT TIME
local function formatTime(t)
	return string.format("%d:%02d", math.floor(t/60), math.floor(t%60))
end

-- PLAY / PAUSE / ĐỔI ID
play.MouseButton1Click:Connect(function()
	if idBox.Text ~= "" then
		local newId = "rbxassetid://"..idBox.Text
		if sound.SoundId ~= newId then
			sound:Stop()
			sound.SoundId = newId
			sound.TimePosition = 0
			sound.PlaybackSpeed = speed
			sound:Play()
			return
		end
	end

	if sound.IsPlaying then
		sound:Pause()
	else
		sound.PlaybackSpeed = speed
		sound:Resume()
	end
end)

-- RESET
reset.MouseButton1Click:Connect(function()
	sound:Stop()
	sound.TimePosition = 0
	sound:Play()
end)

-- SPEED
speedUp.MouseButton1Click:Connect(function()
	speed = math.clamp(speed + 0.1,0.5,2)
	sound.PlaybackSpeed = speed
end)

speedDown.MouseButton1Click:Connect(function()
	speed = math.clamp(speed - 0.1,0.5,2)
	sound.PlaybackSpeed = speed
end)

-- DRAG LOGIC
local dragSeek = false
local dragVol = false

barBack.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragSeek = true
	end
end)

volBack.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragVol = true
	end
end)

UserInputService.InputEnded:Connect(function()
	dragSeek = false
	dragVol = false
end)

UserInputService.InputChanged:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
		local x = i.Position.X

		if dragSeek and sound.TimeLength > 0 then
			local p = math.clamp((x - barBack.AbsolutePosition.X) / barBack.AbsoluteSize.X,0,1)
			sound.TimePosition = p * sound.TimeLength
		end

		if dragVol then
			local v = math.clamp((x - volBack.AbsolutePosition.X) / volBack.AbsoluteSize.X,0,1)
			sound.Volume = v
			volBar.Size = UDim2.fromScale(v,1)
		end
	end
end)

-- UPDATE UI
RunService.RenderStepped:Connect(function()
	if sound.TimeLength > 0 then
		local p = sound.TimePosition / sound.TimeLength
		bar.Size = UDim2.fromScale(p,1)
		miniBar.Size = UDim2.fromScale(p,1)
		timeText.Text = formatTime(sound.TimePosition).." / "..formatTime(sound.TimeLength)
	end
end)

-- AUTO REPLAY
sound.Ended:Connect(function()
	sound.TimePosition = 0
	sound:Play()
end)

-- HIDE / SHOW
hide.MouseButton1Click:Connect(function()
	frame.Visible = false
	show.Visible = true
end)

show.MouseButton1Click:Connect(function()
	frame.Visible = true
	show.Visible = false
end)
