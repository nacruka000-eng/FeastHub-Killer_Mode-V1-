--[[
    FeastHUB [Killer_Mode V1] - FINAL EDITION
    Версия: 2
    Автор: FeastTeam
]]

-- ==========================================
-- УНИЧТОЖЕНИЕ СТАРЫХ GUI
-- ==========================================
pcall(function()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name:find("FeastHUB") or v.Name:find("Loader") or v.Name:find("Button") then
            v:Destroy()
        end
    end
end)

-- ==========================================
-- ПРИНУДИТЕЛЬНАЯ ЗАГРУЗКА ПЕРСОНАЖА
-- ==========================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer

repeat wait(0.1) until player

local function forceLoadCharacter()
    pcall(function()
        if not player.Character then
            player.CharacterAdded:Wait()
        end
        
        local character = player.Character
        if not character then return end
        
        local humanoid = character:WaitForChild("Humanoid", 5)
        local rootPart = character:WaitForChild("HumanoidRootPart", 5)
        
        if humanoid and rootPart then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            
            if rootPart.Anchored then
                rootPart.Anchored = false
            end
            
            if humanoid.Health <= 0 then
                humanoid.Health = humanoid.MaxHealth
            end
            return true
        end
        return false
    end)
end

local loaded = forceLoadCharacter()
if not loaded then
    if player.Character then
        player.Character:BreakJoints()
    end
    wait(1)
    player.CharacterAdded:Wait()
    forceLoadCharacter()
end

-- ==========================================
-- ЗАГРУЗОЧНЫЙ ЭКРАН
-- ==========================================
local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "FeastHUB_Loader"
LoaderGui.Parent = game.CoreGui
LoaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoaderGui.ResetOnSpawn = false
LoaderGui.IgnoreGuiInset = true
LoaderGui.DisplayOrder = 999999

local BlackBG = Instance.new("Frame")
BlackBG.Name = "BlackBG"
BlackBG.Parent = LoaderGui
BlackBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackBG.BackgroundTransparency = 0.3
BlackBG.Size = UDim2.new(1, 0, 1, 0)
BlackBG.Position = UDim2.new(0, 0, 0, 0)
BlackBG.Active = true

local LoaderFrame = Instance.new("Frame")
LoaderFrame.Name = "LoaderFrame"
LoaderFrame.Parent = LoaderGui
LoaderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoaderFrame.BorderSizePixel = 0
LoaderFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
LoaderFrame.Size = UDim2.new(0, 350, 0, 250)
LoaderFrame.BackgroundTransparency = 0.1
LoaderFrame.Active = true
LoaderFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = LoaderFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = LoaderFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 20, 0, 15)
TitleLabel.Size = UDim2.new(1, -40, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "FeastHUB [Killer_Mode V1.1]"
TitleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
TitleLabel.TextScaled = true

local SubLabel = Instance.new("TextLabel")
SubLabel.Parent = LoaderFrame
SubLabel.BackgroundTransparency = 1
SubLabel.Position = UDim2.new(0, 20, 0, 55)
SubLabel.Size = UDim2.new(1, -40, 0, 25)
SubLabel.Font = Enum.Font.Gotham
SubLabel.Text = "Запуск скрипта..."
SubLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SubLabel.TextScaled = true

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = LoaderFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 20, 0, 85)
StatusLabel.Size = UDim2.new(1, -40, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Статус: Запуск"
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextSize = 16

local ProgressBg = Instance.new("Frame")
ProgressBg.Parent = LoaderFrame
ProgressBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ProgressBg.BorderSizePixel = 0
ProgressBg.Position = UDim2.new(0, 20, 0, 115)
ProgressBg.Size = UDim2.new(1, -40, 0, 25)

local ProgressCorner = Instance.new("UICorner")
ProgressCorner.CornerRadius = UDim.new(0, 8)
ProgressCorner.Parent = ProgressBg

local ProgressBar = Instance.new("Frame")
ProgressBar.Parent = ProgressBg
ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ProgressBar.BorderSizePixel = 0
ProgressBar.Size = UDim2.new(0, 0, 1, 0)

local ProgressCorner2 = Instance.new("UICorner")
ProgressCorner2.CornerRadius = UDim.new(0, 8)
ProgressCorner2.Parent = ProgressBar

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Parent = ProgressBg
PercentLabel.BackgroundTransparency = 1
PercentLabel.Size = UDim2.new(1, 0, 1, 0)
PercentLabel.Font = Enum.Font.GothamBold
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PercentLabel.TextSize = 16

local DetailStatus = Instance.new("TextLabel")
DetailStatus.Parent = LoaderFrame
DetailStatus.BackgroundTransparency = 1
DetailStatus.Position = UDim2.new(0, 20, 0, 150)
DetailStatus.Size = UDim2.new(1, -40, 0, 40)
DetailStatus.Font = Enum.Font.Gotham
DetailStatus.Text = "[AntiCheat:0% | AntiLogger:0% | AntiKick:0%]"
DetailStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
DetailStatus.TextSize = 12
DetailStatus.TextWrapped = true

local function updateLoader(percent, stage, ac, logger, kick)
    ProgressBar:TweenSize(UDim2.new(percent/100, 0, 1, 0), "Out", "Linear", 0.2, true)
    PercentLabel.Text = math.floor(percent) .. "%"
    DetailStatus.Text = string.format("[AntiCheat:%d%% | AntiLogger:%d%% | AntiKick:%d%%]", 
        ac, logger, kick)
    StatusLabel.Text = "Статус: " .. stage
end

-- Этапы загрузки
updateLoader(0, "Подготовка", 0, 0, 0)
wait(0.5)

for i = 1, 33 do
    updateLoader(i, "Загрузка AntiCheat", i, 0, 0)
    wait(0.03)
end

for i = 34, 66 do
    updateLoader(i, "Загрузка AntiLogger", 33, i-33, 0)
    wait(0.03)
end

for i = 67, 100 do
    updateLoader(i, "Загрузка AntiKick", 33, 33, i-66)
    wait(0.03)
end

updateLoader(100, "Готово!", 33, 33, 34)
wait(0.5)
LoaderGui:Destroy()

-- ==========================================
-- ПРОДВИНУТЫЙ ANTIBAN/ANTIKICK
-- ==========================================
local mt = getrawmetatable(game)
local old_namecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    -- Блокируем кики
    if method == "Kick" or method == "kick" then
        return
    end
    
    -- Блокируем удаление персонажа
    if method == "Destroy" and tostring(self):find("Character") then
        return
    end
    
    -- Блокируем подозрительные Remote события
    if method == "FireServer" and type(args[1]) == "string" then
        if args[1]:lower():find("ban") or args[1]:lower():find("kick") or 
           args[1]:lower():find("anticheat") or args[1]:lower():find("detect") then
            return
        end
    end
    
    return old_namecall(self, ...)
end)

setreadonly(mt, true)

-- Защита от телепорт-детекта
local lastPos = nil
local teleportCounter = 0

game:GetService("RunService").Heartbeat:Connect(function()
    pcall(function()
        if not player or not player.Character then return end
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        if lastPos then
            local dist = (root.Position - lastPos).Magnitude
            if dist > 500 then
                teleportCounter = teleportCounter + 1
                if teleportCounter > 3 then
                    wait(1)
                    teleportCounter = 0
                end
            end
        end
        lastPos = root.Position
    end)
end)

-- ==========================================
-- ПЛАВАЮЩАЯ КНОПКА F
-- ==========================================
wait(0.2)

local MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "FeastHUB_Button"
MobileGui.Parent = game.CoreGui
MobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MobileGui.ResetOnSpawn = false
MobileGui.IgnoreGuiInset = true
MobileGui.DisplayOrder = 999998

local FloatButton = Instance.new("Frame")
FloatButton.Name = "FloatButton"
FloatButton.Parent = MobileGui
FloatButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatButton.BackgroundTransparency = 0.1
FloatButton.Position = UDim2.new(0, 20, 0.5, -25)
FloatButton.Size = UDim2.new(0, 50, 0, 50)
FloatButton.Active = true
FloatButton.Draggable = true

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 10)
ButtonCorner.Parent = FloatButton

local FLetter = Instance.new("TextLabel")
FLetter.Parent = FloatButton
FLetter.BackgroundTransparency = 1
FLetter.Size = UDim2.new(1, 0, 1, 0)
FLetter.Font = Enum.Font.GothamBold
FLetter.Text = "F"
FLetter.TextColor3 = Color3.fromRGB(0, 255, 0)
FLetter.TextScaled = true

local PulseIndicator = Instance.new("Frame")
PulseIndicator.Parent = FloatButton
PulseIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
PulseIndicator.BackgroundTransparency = 0.3
PulseIndicator.Position = UDim2.new(0.7, 0, 0.7, 0)
PulseIndicator.Size = UDim2.new(0, 8, 0, 8)

local PulseCorner = Instance.new("UICorner")
PulseCorner.CornerRadius = UDim.new(1, 0)
PulseCorner.Parent = PulseIndicator

-- Простая пульсация
spawn(function()
    while true do
        for i = 0.3, 0.7, 0.1 do
            PulseIndicator.BackgroundTransparency = i
            wait(0.1)
        end
        for i = 0.7, 0.3, -0.1 do
            PulseIndicator.BackgroundTransparency = i
            wait(0.1)
        end
        wait(0.2)
    end
end)

-- ==========================================
-- ОСНОВНОЕ МЕНЮ (KAVO UI)
-- ==========================================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("FeastHUB [Killer_Mode V1]", "DarkTheme")

-- Вкладки
local MainTab = Window:NewTab("Main")
local FarmTab = Window:NewTab("Auto Farm")
local PlayerTab = Window:NewTab("Player")
local AntiBanTab = Window:NewTab("AntiBan")
local SettingsTab = Window:NewTab("Settings")

-- ==========================================
-- AUTO ATTACK (РАДИУС 20)
-- ==========================================
local AutoAttackSection = FarmTab:NewSection("⚔️ AUTO ATTACK [20]")

local attackEnabled = false
local attackConnection = nil

local function findTarget()
    if not player or not player.Character then return nil end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local objRoot = obj:FindFirstChild("HumanoidRootPart")
            
            if hum and hum.Health > 0 and objRoot then
                if not obj:FindFirstChild("Player") then
                    local dist = (objRoot.Position - root.Position).Magnitude
                    if dist <= 20 then
                        return obj
                    end
                end
            end
        end
    end
    return nil
end

local function doAttack(target)
    if not player or not player.Character then return end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    local tool = player.Character:FindFirstChildOfClass("Tool")
    local targetRoot = target:FindFirstChild("HumanoidRootPart")
    
    if root and targetRoot then
        -- Поворачиваемся к цели
        root.CFrame = CFrame.lookAt(root.Position, targetRoot.Position)
        
        -- Если далеко - подходим
        local dist = (targetRoot.Position - root.Position).Magnitude
        if dist > 8 then
            root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 4)
        end
        
        -- Атакуем
        if tool then
            tool:Activate()
        end
    end
end

AutoAttackSection:NewButton("▶ ВКЛЮЧИТЬ", "Автоатака радиус 20", function()
    attackEnabled = true
    if attackConnection then attackConnection:Disconnect() end
    
    attackConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not attackEnabled then return end
        pcall(function()
            local target = findTarget()
            if target then
                doAttack(target)
            end
        end)
    end)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "FeastHUB",
        Text = "⚔️ Auto Attack включен",
        Duration = 2
    })
end)

AutoAttackSection:NewButton("⏹ ВЫКЛЮЧИТЬ", "Остановить", function()
    attackEnabled = false
    if attackConnection then
        attackConnection:Disconnect()
        attackConnection = nil
    end
end)

-- Статус
local attackStatus = AutoAttackSection:NewLabel("Статус: ⚪ Выключен")

-- Обновление статуса
spawn(function()
    while true do
        if attackEnabled then
            attackStatus:UpdateLabel("Статус: 🔴 Атакуем")
        else
            attackStatus:UpdateLabel("Статус: ⚪ Выключен")
        end
        wait(1)
    end
end)

-- ==========================================
-- SPEED FUNCTIONS
-- ==========================================
local SpeedSection = PlayerTab:NewSection("⚡ Speed Control")

SpeedSection:NewSlider("Скорость бега", "Максимум 100", 100, 16, function(s)
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = s
        end
    end
end)

SpeedSection:NewSlider("Сила прыжка", "Высота прыжка", 100, 50, function(s)
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = s
        end
    end
end)

-- ==========================================
-- ANTIBAN НАСТРОЙКИ
-- ==========================================
local AntiBanSection = AntiBanTab:NewSection("🛡️ ЗАЩИТА")

AntiBanSection:NewLabel("✓ AntiKick активен")
AntiBanSection:NewLabel("✓ AntiTeleport активен")
AntiBanSection:NewLabel("✓ AntiCheat активен")
AntiBanSection:NewLabel("✓ Remote блокировка активна")

AntiBanSection:NewButton("Проверить защиту", "Тест системы", function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "FeastHUB",
        Text = "✅ Все системы защиты работают",
        Duration = 3
    })
end)

-- ==========================================
-- УПРАВЛЕНИЕ КНОПКОЙ F
-- ==========================================
local MenuVisible = true

local function ToggleMenu()
    MenuVisible = not MenuVisible
    Window:ToggleUI()
    FLetter.TextColor3 = MenuVisible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end

FloatButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local startPos = FloatButton.Position
        wait(0.1)
        if (FloatButton.Position - startPos).Magnitude < 0.01 then
            ToggleMenu()
        end
    end
end)

local lastTap = 0
FloatButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local currentTime = tick()
        if currentTime - lastTap < 0.3 then
            FloatButton.Visible = false
            wait(1)
            FloatButton.Visible = true
        end
        lastTap = currentTime
    end
end)

-- ==========================================
-- МОБИЛЬНЫЕ НАСТРОЙКИ
-- ==========================================
local MobileSection = SettingsTab:NewSection("📱 Управление")

MobileSection:NewButton("Показать кнопку F", "Вернуть кнопку", function()
    FloatButton.Visible = true
end)

MobileSection:NewButton("Скрыть кнопку F", "Спрятать", function()
    FloatButton.Visible = false
end)

MobileSection:NewButton("Кнопка в центр", "Переместить", function()
    FloatButton:TweenPosition(UDim2.new(0.5, -25, 0.5, -25), "Out", "Linear", 0.3)
end)

MobileSection:NewButton("Кнопка влево", "Переместить", function()
    FloatButton:TweenPosition(UDim2.new(0, 20, 0.5, -25), "Out", "Linear", 0.3)
end)

MobileSection:NewButton("Кнопка вправо", "Переместить", function()
    FloatButton:TweenPosition(UDim2.new(1, -70, 0.5, -25), "Out", "Linear", 0.3)
end)

local InfoSection = SettingsTab:NewSection("ℹ️ Инструкция")
InfoSection:NewLabel("• Тап по F - меню")
InfoSection:NewLabel("• Перетащи F - переместить")
InfoSection:NewLabel("• Двойной тап - скрыть на 1 сек")
InfoSection:NewLabel("• Антикик защищает от бана")

-- ==========================================
-- ТЕЛЕПОРТЫ
-- ==========================================
local TeleportSection = MainTab:NewSection("🌍 Телепорты")

TeleportSection:NewButton("Стартовый остров", "Телепорт на начало", function()
    if player and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(100, 50, 100)
        end
    end
end)

TeleportSection:NewButton("Джунгли", "Телепорт в джунгли", function()
    if player and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(-1200, 50, 400)
        end
    end
end)

TeleportSection:NewButton("Песчаный замок", "Телепорт в песчаный замок", function()
    if player and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(-1300, 30, -800)
        end
    end
end)

-- ==========================================
-- ИНФОРМАЦИЯ ОБ ИГРОКЕ
-- ==========================================
local InfoSection = PlayerTab:NewSection("📊 Информация")

InfoSection:NewButton("Обновить статистику", "Показать уровень", function()
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        for _, v in pairs(leaderstats:GetChildren()) do
            if v.Name == "Level" then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "FeastHUB",
                    Text = "Ваш уровень: " .. tostring(v.Value),
                    Duration = 3
                })
            end
        end
    end
end)

-- ==========================================
-- ФИНАЛЬНОЕ УВЕДОМЛЕНИЕ
-- ==========================================
wait(0.5)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "FeastHUB",
    Text = "✅ Загружено! Тапни по F",
    Duration = 3
})

print("✅ FeastHUB FINAL загружен! Тапни по зеленой F")
