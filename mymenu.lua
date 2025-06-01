-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Configurações
local settings = {
    aimbot = false,
    esp = false,
    highlightESP = false,
    safeMode = true,
    smoothness = 0.2,
    fov = 100,
    highlightColor = Color3.fromRGB(255, 0, 0),
    teamCheck = true,
}

-- GUI ULTRA
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "UltraMenu"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 550)
mainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 2

-- Drag
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Layout
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🔥✇ SHARINGAN MODMENU ✇🔥"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local layout = Instance.new("UIListLayout", mainFrame)
layout.Padding = UDim.new(0, 8)
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Botões
local function createToggleButton(label, key)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Text = label .. " ❌"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        settings[key] = not settings[key]
        btn.Text = label .. (settings[key] and " ✔️" or " ❌")
    end)
end

-- Sliders
local function createSlider(label, min, max, key)
    local frame = Instance.new("Frame", mainFrame)
    frame.Size = UDim2.new(0.9, 0, 0, 30)
    frame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.5, 0, 1, 0)
    btn.Position = UDim2.new(0.5, 0, 0, 0)
    btn.Text = string.format("%.1f", settings[key])
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        settings[key] = settings[key] + 0.1
        if settings[key] > max then settings[key] = min end
        btn.Text = string.format("%.1f", settings[key])
    end)
end

-- RGB Slider
local function createRGBSlider()
    local colors = {"R", "G", "B"}
    for _, c in pairs(colors) do
        local frame = Instance.new("Frame", mainFrame)
        frame.Size = UDim2.new(0.9, 0, 0, 30)
        frame.BackgroundTransparency = 1

        local lbl = Instance.new("TextLabel", frame)
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Text = "Highlight " .. c
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(0.5, 0, 1, 0)
        btn.Position = UDim2.new(0.5, 0, 0, 0)
        btn.Text = tostring(settings.highlightColor[c:lower()] * 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        btn.MouseButton1Click:Connect(function()
            local current = math.floor(settings.highlightColor[c:lower()] * 255)
            current = (current + 10) % 256
            local r = c == "R" and current or math.floor(settings.highlightColor.R * 255)
            local g = c == "G" and current or math.floor(settings.highlightColor.G * 255)
            local b = c == "B" and current or math.floor(settings.highlightColor.B * 255)
            settings.highlightColor = Color3.fromRGB(r, g, b)
            btn.Text = tostring(current)
        end)
    end
end

-- Menu Botões
createToggleButton("Aimbot", "aimbot")
createToggleButton("ESP", "esp")
createToggleButton("Highlight ESP", "highlightESP")
createToggleButton("Safe Mode", "safeMode")
createToggleButton("Team Check", "teamCheck")
createSlider("Smoothness", 0.1, 1.0, "smoothness")
createSlider("FOV", 10, 200, "fov")
createRGBSlider()

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.NumSides = 100
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Filled = false
fovCircle.Visible = true

-- Função pegar alvo
local function getClosestPlayer()
    local closest, dist = nil, settings.fov
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            if not settings.teamCheck or player.Team ~= LocalPlayer.Team then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local mag = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if mag < dist then
                            dist = mag
                            closest = head
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- Main ESP Loop
local drawings = {}
RunService.RenderStepped:Connect(function()
    for _, v in pairs(drawings) do v:Remove() end
    drawings = {}

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            if not settings.teamCheck or player.Team ~= LocalPlayer.Team then
                local pos, visible = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if visible then
                    -- Raycast check
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
                    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

                    local direction = (player.Character.HumanoidRootPart.Position - Camera.CFrame.Position)
                    local result = workspace:Raycast(Camera.CFrame.Position, direction, rayParams)
                    local isVisible = result and result.Instance:IsDescendantOf(player.Character)

                    if settings.esp then
                        local box = Drawing.new("Square")
                        box.Size = Vector2.new(50, 100)
                        box.Position = Vector2.new(pos.X - 25, pos.Y - 50)
                        box.Color = Color3.fromRGB(255, 0, 0)
                        box.Thickness = 2
                        box.Filled = false
                        box.Visible = true
                        table.insert(drawings, box)

                        local line = Drawing.new("Line")
                        line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        line.To = Vector2.new(pos.X, pos.Y)
                        line.Color = Color3.fromRGB(255, 0, 0)
                        line.Thickness = 1
                        line.Visible = true
                        table.insert(drawings, line)

                        local text = Drawing.new("Text")
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        text.Text = string.format("%s (%.1f)", player.Name, distance)
                        text.Position = Vector2.new(pos.X, pos.Y - 60)
                        text.Size = 14
                        text.Color = Color3.fromRGB(255, 255, 255)
                        text.Center = true
                        text.Outline = true
                        text.Visible = true
                        table.insert(drawings, text)
                    end

                    if settings.highlightESP then
                        local highlight = workspace:FindFirstChild(player.Name .. "_Highlight") or Instance.new("Highlight")
                        highlight.Adornee = player.Character
                        highlight.Name = player.Name .. "_Highlight"
                        highlight.Parent = workspace
                        highlight.FillColor = isVisible and Color3.fromRGB(0, 255, 0) or settings.highlightColor
                        highlight.OutlineColor = isVisible and Color3.fromRGB(0, 255, 0) or settings.highlightColor
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                    elseif workspace:FindFirstChild(player.Name .. "_Highlight") then
                        workspace[player.Name .. "_Highlight"]:Destroy()
                    end
                end
            end
        end
    end
end)

-- Aimbot
RunService.RenderStepped:Connect(function()
    fovCircle.Position = UserInputService:GetMouseLocation()
    fovCircle.Radius = settings.fov

    if settings.aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayer()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local mousePos = UserInputService:GetMouseLocation()
            local newPos = mousePos:Lerp(Vector2.new(targetPos.X, targetPos.Y), settings.smoothness)
            mousemoverel(newPos.X - mousePos.X, newPos.Y - mousePos.Y)
        end
    end
end)
