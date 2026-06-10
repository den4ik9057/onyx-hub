local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local States = {
    Fly = false, NoClip = false, SpeedHack = false, 
    InfJump = false, AntiAFK = false, ESP = false,
    FlySpeed = 60, WalkSpeed = 100,
    UIVisible = true
}

local Connections = {}
local bodyGyro, bodyVelocity

local CaptchaData = {}
local charset = "ABCDEFGHiJKLMNOPQRSTUVWXYZ0123456789"
math.randomseed(os.time())

for i = 1, 500 do
    local cap = ""
    local key = "ONYX_"
    for j = 1, 6 do 
        local r = math.random(1, #charset)
        cap = cap .. string.sub(charset, r, r)
        key = key .. string.sub(charset, math.random(1, #charset), math.random(1, #charset))
    end
    CaptchaData[cap] = key .. "_" .. i
end

local currentCap = "B1C2A3"
for k, v in pairs(CaptchaData) do currentCap = k break end
local currentKey = CaptchaData[currentCap]

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ONYX_FINAL_ULTIMATE"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainCanvas = Instance.new("CanvasGroup")
MainCanvas.Size = UDim2.new(0, 260, 0, 480)
MainCanvas.Position = UDim2.new(0.5, -130, 0.5, -240)
MainCanvas.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainCanvas.GroupTransparency = 1
MainCanvas.Visible = false
MainCanvas.Parent = ScreenGui
Instance.new("UICorner", MainCanvas).CornerRadius = UDim.new(0, 12)

local CaptchaFrame = Instance.new("Frame", ScreenGui)
CaptchaFrame.Size = UDim2.new(0, 320, 0, 220)
CaptchaFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
CaptchaFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
CaptchaFrame.BorderSizePixel = 0
Instance.new("UICorner", CaptchaFrame).CornerRadius = UDim.new(0, 10)

local CapTitle = Instance.new("TextLabel", CaptchaFrame)
CapTitle.Size = UDim2.new(1, 0, 0, 40)
CapTitle.Text = "SYSTEM VERIFICATION"
CapTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
CapTitle.Font = Enum.Font.GothamBold
CapTitle.TextSize = 14
CapTitle.BackgroundTransparency = 1

local DisplayCap = Instance.new("TextLabel", CaptchaFrame)
DisplayCap.Size = UDim2.new(1, 0, 0, 40)
DisplayCap.Position = UDim2.new(0, 0, 0, 40)
DisplayCap.Text = "CAPTCHA: " .. currentCap
DisplayCap.TextColor3 = Color3.fromRGB(0, 255, 180)
DisplayCap.Font = Enum.Font.Code
DisplayCap.TextSize = 22
DisplayCap.BackgroundTransparency = 1

local function CreateInput(placeholder, pos)
    local box = Instance.new("TextBox", CaptchaFrame)
    box.Size = UDim2.new(0, 260, 0, 35)
    box.Position = pos
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    return box
end

local Input1 = CreateInput("Enter Captcha...", UDim2.new(0.5, -130, 0, 90))
local Input2 = CreateInput("Paste Key...", UDim2.new(0.5, -130, 0, 135))

local Status = Instance.new("TextLabel", CaptchaFrame)
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0, 180)
Status.Text = "Verify to continue"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 11

local WelcomeFrame = Instance.new("CanvasGroup", ScreenGui)
WelcomeFrame.Size = UDim2.new(0, 320, 0, 160)
WelcomeFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
WelcomeFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
WelcomeFrame.GroupTransparency = 1
WelcomeFrame.Visible = false
Instance.new("UICorner", WelcomeFrame).CornerRadius = UDim.new(0, 15)

local AvatarImg = Instance.new("ImageLabel", WelcomeFrame)
AvatarImg.Size = UDim2.new(0, 70, 0, 70)
AvatarImg.Position = UDim2.new(0, 15, 0, 20)
AvatarImg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150"
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

local WelText = Instance.new("TextLabel", WelcomeFrame)
WelText.Size = UDim2.new(0, 210, 0, 30) WelText.Position = UDim2.new(0, 95, 0, 30)
WelText.Text = "Welcome, " .. LocalPlayer.DisplayName WelText.TextColor3 = Color3.fromRGB(255, 255, 255)
WelText.Font = Enum.Font.GothamBold WelText.TextSize = 18 WelText.BackgroundTransparency = 1 WelText.TextXAlignment = Enum.TextXAlignment.Left

local StatusText = Instance.new("TextLabel", WelcomeFrame)
StatusText.Size = UDim2.new(0, 210, 0, 20) StatusText.Position = UDim2.new(0, 95, 0, 55)
StatusText.Text = "System Initializing..." StatusText.TextColor3 = Color3.fromRGB(160, 160, 160)
StatusText.Font = Enum.Font.Gotham StatusText.TextSize = 13 StatusText.BackgroundTransparency = 1 StatusText.TextXAlignment = Enum.TextXAlignment.Left

local LoadingBarBack = Instance.new("Frame", WelcomeFrame)
LoadingBarBack.Size = UDim2.new(1, -40, 0, 4) LoadingBarBack.Position = UDim2.new(0, 20, 1, -30)
LoadingBarBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30) LoadingBarBack.BorderSizePixel = 0

local LoadingBarFill = Instance.new("Frame", LoadingBarBack)
LoadingBarFill.Size = UDim2.new(0, 0, 1, 0) LoadingBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255) LoadingBarFill.BorderSizePixel = 0

local function ToggleUIVisibility()
    States.UIVisible = not States.UIVisible
    local targetTrans = States.UIVisible and 0 or 1
    TweenService:Create(MainCanvas, TweenInfo.new(0.5), {GroupTransparency = targetTrans}):Play()
    task.wait(targetTrans == 1 and 0.5 or 0)
    MainCanvas.Visible = States.UIVisible
end

local function StartLoadingSequence()
    CaptchaFrame:Destroy()
    WelcomeFrame.Visible = true
    TweenService:Create(WelcomeFrame, TweenInfo.new(0.8), {GroupTransparency = 0}):Play()
    task.wait(0.5)
    local loadTween = TweenService:Create(LoadingBarFill, TweenInfo.new(2.2, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 1, 0)})
    loadTween:Play()
    loadTween.Completed:Wait()
    StatusText.Text = "Authorized!" StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    task.wait(0.4)
    TweenService:Create(WelcomeFrame, TweenInfo.new(0.6), {GroupTransparency = 1}):Play()
    task.wait(0.7) 
    WelcomeFrame:Destroy()
    MainCanvas.Visible = true
    TweenService:Create(MainCanvas, TweenInfo.new(0.8), {GroupTransparency = 0}):Play()
end

Input1:GetPropertyChangedSignal("Text"):Connect(function()
    if Input1.Text == currentCap then
        setclipboard(currentKey)
        Status.Text = "Key copied! Paste it below."
        Status.TextColor3 = Color3.fromRGB(255, 255, 0)
    end
end)

Input2:GetPropertyChangedSignal("Text"):Connect(function()
    if Input2.Text == currentKey then
        Status.Text = "SUCCESS!"
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.wait(0.3)
        StartLoadingSequence()
    end
end)

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    table.insert(Connections, UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
end
MakeDraggable(MainCanvas)

local function ApplyESP(character)
    if not States.ESP then return end
    local player = Players:GetPlayerFromCharacter(character)
    if not player or player == LocalPlayer then return end
    character:WaitForChild("HumanoidRootPart", 10)
    local highlight = character:FindFirstChild("ESP_HighLight_ONYX") or Instance.new("Highlight")
    highlight.Name = "ESP_HighLight_ONYX"
    highlight.Parent = character
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(25, 25, 25) 
    highlight.FillTransparency = 0.6
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.Occlusion = Enum.HighlightOcclusion.AlwaysOnTop 
    highlight.Enabled = true
end

local function ToggleESP(state)
    States.ESP = state
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then task.spawn(ApplyESP, player.Character) end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local hl = player.Character:FindFirstChild("ESP_HighLight_ONYX")
                if hl then hl:Destroy() end
            end
        end
    end
end

local function CreateButton(name, size, pos, parent, callback, isPanic)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = size Btn.Position = pos Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = name Btn.TextColor3 = isPanic and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamMedium Btn.TextSize = 14 Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Thickness = 2 Stroke.Color = Color3.fromRGB(45, 45, 45) Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local active = false
    local function toggle()
        if isPanic then callback() else
            active = not active
            Stroke.Color = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(45, 45, 45)
            callback(active)
        end
    end
    Btn.MouseButton1Click:Connect(toggle)
    return {Btn = Btn, Toggle = toggle}
end

local function KillScript()
    States.Fly = false ToggleESP(false)
    if bodyGyro then bodyGyro:Destroy() end if bodyVelocity then bodyVelocity:Destroy() end
    for _, c in pairs(Connections) do if c then c:Disconnect() end end
    ScreenGui:Destroy()
    StarterGui:SetCore("SendNotification", {Title = "ONYX System", Text = "Script Deactivated", Duration = 3})
end

local Title = Instance.new("TextLabel", MainCanvas)
Title.Size = UDim2.new(1, 0, 0, 50) Title.Text = "ONYX PANEL" Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1 Title.Font = Enum.Font.GothamBold Title.TextSize = 18

local btnSize = UDim2.new(0, 220, 0, 35)
local flyObj = CreateButton("FLY (Insert)", btnSize, UDim2.new(0, 20, 0, 60), MainCanvas, function(s) 
    States.Fly = s local char = LocalPlayer.Character
    if s and char and char:FindFirstChild("HumanoidRootPart") then
        char.Humanoid.PlatformStand = true
        bodyGyro = Instance.new("BodyGyro", char.HumanoidRootPart) bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity = Instance.new("BodyVelocity", char.HumanoidRootPart) bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    else
        if bodyGyro then bodyGyro:Destroy() end if bodyVelocity then bodyVelocity:Destroy() end
        if char and char:FindFirstChildOfClass("Humanoid") then char.Humanoid.PlatformStand = false end
    end
end)

local noclipObj = CreateButton("NoClip (Home)", btnSize, UDim2.new(0, 20, 0, 100), MainCanvas, function(s) States.NoClip = s end)
local speedObj = CreateButton("Speed (Delete)", btnSize, UDim2.new(0, 20, 0, 140), MainCanvas, function(s) States.SpeedHack = s end)
local infJumpObj = CreateButton("Inf Jump (End)", btnSize, UDim2.new(0, 20, 0, 180), MainCanvas, function(s) States.InfJump = s end)
local espObj = CreateButton("ESP (PageUp)", btnSize, UDim2.new(0, 20, 0, 220), MainCanvas, ToggleESP)
local antiAfkObj = CreateButton("Anti-AFK", btnSize, UDim2.new(0, 20, 0, 260), MainCanvas, function(s) States.AntiAFK = s end)

local function CreateStepper(label, pos, valName)
    local f = Instance.new("Frame", MainCanvas) f.Size = UDim2.new(0, 220, 0, 35) f.Position = pos f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f) l.Size = UDim2.new(0, 110, 1, 0) l.Text = label .. ": " .. States[valName]
    l.TextColor3 = Color3.fromRGB(180, 180, 180) l.BackgroundTransparency = 1 l.Font = Enum.Font.Gotham l.TextXAlignment = Enum.TextXAlignment.Left
    CreateButton("+", UDim2.new(0, 35, 0, 30), UDim2.new(1, -35, 0, 2), f, function() States[valName] += 10 l.Text = label..": "..States[valName] end)
    CreateButton("-", UDim2.new(0, 35, 0, 30), UDim2.new(1, -75, 0, 2), f, function() States[valName] = math.max(10, States[valName]-10) l.Text = label..": "..States[valName] end)
end

CreateStepper("Fly Speed", UDim2.new(0, 20, 0, 310), "FlySpeed")
CreateStepper("Walk Speed", UDim2.new(0, 20, 0, 350), "WalkSpeed")
CreateButton("PANIC (PageDown)", btnSize, UDim2.new(0, 20, 0, 410), MainCanvas, KillScript, true)

table.insert(Connections, UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.Insert then flyObj.Toggle() end
    if i.KeyCode == Enum.KeyCode.Home then noclipObj.Toggle() end
    if i.KeyCode == Enum.KeyCode.Delete then speedObj.Toggle() end
    if i.KeyCode == Enum.KeyCode.End then infJumpObj.Toggle() end
    if i.KeyCode == Enum.KeyCode.PageUp then espObj.Toggle() end
    if i.KeyCode == Enum.KeyCode.PageDown then KillScript() end
    if i.KeyCode == Enum.KeyCode.RightShift then ToggleUIVisibility() end
end))

table.insert(Connections, RunService.RenderStepped:Connect(function()
    if States.Fly and bodyVelocity and bodyGyro then
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not root or not cam or UIS:GetFocusedTextBox() then if bodyVelocity then bodyVelocity.Velocity = Vector3.zero end return end
        bodyGyro.CFrame = cam.CFrame
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir += Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0, 1, 0) end
        bodyVelocity.Velocity = dir.Magnitude > 0 and dir.Unit * States.FlySpeed or Vector3.zero
    end
end))

table.insert(Connections, RunService.Stepped:Connect(function()
    if States.NoClip and LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if States.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = UIS:GetFocusedTextBox() and 16 or States.WalkSpeed end
end))

table.insert(Connections, UIS.JumpRequest:Connect(function()
    if States.InfJump and not UIS:GetFocusedTextBox() and LocalPlayer.Character then 
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h:ChangeState("Jumping") end
    end
end))

table.insert(Connections, Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        if States.ESP then ApplyESP(char) end
    end)
end))
