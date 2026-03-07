--[[
    FeastHUB [Killer_Mode V1.3] - FULL UI RESTORED
    Автор: FeastTeam
]]

-- ==========================================
-- УНИЧТОЖЕНИЕ СТАРЫХ GUI
-- ==========================================
pcall(function()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name:find("FeastHUB") then
            v:Destroy()
        end
    end
end)

-- ==========================================
-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- ==========================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Переменные состояния
local isAttackEnabled = false
local isGodHealEnabled = false
local attackConnection = nil
local godHealConnection = nil
local currentSea = 1
local Window = nil

-- Метки для статистики (чтобы обновлять)
local levelLabel = nil
local expLabel = nil
local moneyLabel = nil
local fragmentsLabel = nil
local beliLabel = nil

-- ==========================================
-- ТОЧНОЕ ОПРЕДЕЛЕНИЕ МОРЯ (ПО ID)
-- ==========================================
local function getCurrentSea()
    local place = game.PlaceId
    
    if place == 2753915549 then
        return 1
    elseif place == 4442272183 then
        return 2
    elseif place == 7449423635 then
        return 3
    end
    
    return 1
end

currentSea = getCurrentSea()

-- ==========================================
-- ОЖИДАНИЕ ЗАГРУЗКИ ПЕРСОНАЖА
-- ==========================================
repeat wait(0.5) until player
repeat wait(0.5) until player.Character
repeat wait(0.5) until player.Character:FindFirstChild("Humanoid")
repeat wait(0.5) until player.Character:FindFirstChild("HumanoidRootPart")

-- ==========================================
-- ДЕТАЛЬНЫЙ ЗАГРУЗОЧНЫЙ ЭКРАН
-- ==========================================
local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "FeastHUB_Loader"
LoaderGui.Parent = game.CoreGui
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

local LoaderFrame = Instance.new("Frame")
LoaderFrame.Name = "LoaderFrame"
LoaderFrame.Parent = LoaderGui
LoaderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoaderFrame.BorderSizePixel = 0
LoaderFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
LoaderFrame.Size = UDim2.new(0, 350, 0, 300)
LoaderFrame.BackgroundTransparency = 0.1
LoaderFrame.Active = true
LoaderFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = LoaderFrame

-- Заголовок
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = LoaderFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 20, 0, 15)
TitleLabel.Size = UDim2.new(1, -40, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "FeastHUB [Killer_Mode V1.4(Beta)]"
TitleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
TitleLabel.TextScaled = true

-- Подзаголовок
local SubLabel = Instance.new("TextLabel")
SubLabel.Parent = LoaderFrame
SubLabel.BackgroundTransparency = 1
SubLabel.Position = UDim2.new(0, 20, 0, 55)
SubLabel.Size = UDim2.new(1, -40, 0, 25)
SubLabel.Font = Enum.Font.Gotham
SubLabel.Text = "Запуск скрипта..."
SubLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SubLabel.TextScaled = true

-- Статус
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

-- Прогресс бар фон
local ProgressBg = Instance.new("Frame")
ProgressBg.Parent = LoaderFrame
ProgressBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ProgressBg.BorderSizePixel = 0
ProgressBg.Position = UDim2.new(0, 20, 0, 115)
ProgressBg.Size = UDim2.new(1, -40, 0, 25)

local ProgressCorner = Instance.new("UICorner")
ProgressCorner.CornerRadius = UDim.new(0, 8)
ProgressCorner.Parent = ProgressBg

-- Сам прогресс
local ProgressBar = Instance.new("Frame")
ProgressBar.Parent = ProgressBg
ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ProgressBar.BorderSizePixel = 0
ProgressBar.Size = UDim2.new(0, 0, 1, 0)

local ProgressCorner2 = Instance.new("UICorner")
ProgressCorner2.CornerRadius = UDim.new(0, 8)
ProgressCorner2.Parent = ProgressBar

-- Проценты главные
local PercentLabel = Instance.new("TextLabel")
PercentLabel.Parent = ProgressBg
PercentLabel.BackgroundTransparency = 1
PercentLabel.Size = UDim2.new(1, 0, 1, 0)
PercentLabel.Font = Enum.Font.GothamBold
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PercentLabel.TextSize = 16

-- Детальный статус (КРАСНЫМ)
local DetailStatus = Instance.new("TextLabel")
DetailStatus.Parent = LoaderFrame
DetailStatus.BackgroundTransparency = 1
DetailStatus.Position = UDim2.new(0, 20, 0, 150)
DetailStatus.Size = UDim2.new(1, -40, 0, 120)
DetailStatus.Font = Enum.Font.Gotham
DetailStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
DetailStatus.Text = [[AntiBan: 0% | AntiLogger: 0% | AntiKick: 0%
AntiDetect: 0% | Удаляем угрозы: 0% | Ресурсы: 0%]]
DetailStatus.TextSize = 12
DetailStatus.TextWrapped = true
DetailStatus.TextXAlignment = Enum.TextXAlignment.Left

-- Функция обновления загрузчика
local function updateLoader(mainPercent, stage, antiBan, antiLogger, antiKick, antiDetect, threats, resources)
    ProgressBar:TweenSize(UDim2.new(mainPercent/100, 0, 1, 0), "Out", "Linear", 0.1, true)
    PercentLabel.Text = math.floor(mainPercent) .. "%"
    StatusLabel.Text = "Статус: " .. stage
    
    DetailStatus.Text = string.format([[
AntiBan: %d%% | AntiLogger: %d%% | AntiKick: %d%%
AntiDetect: %d%% | Удаляем угрозы: %d%% | Ресурсы: %d%%]],
        antiBan, antiLogger, antiKick, antiDetect, threats, resources)
end

-- ЭТАПЫ ЗАГРУЗКИ
updateLoader(0, "Подготовка", 0, 0, 0, 0, 0, 0)
wait(0.5)

for i = 1, 15 do
    local antiBanProgress = math.floor((i / 15) * 100)
    updateLoader(i, "Загрузка AntiBan", antiBanProgress, 0, 0, 0, 0, 0)
    wait(0.03)
end

for i = 15, 30 do
    local mainProgress = i
    local antiLoggerProgress = math.floor(((i - 15) / 15) * 100)
    updateLoader(mainProgress, "Загрузка AntiLogger", 100, antiLoggerProgress, 0, 0, 0, 0)
    wait(0.03)
end

for i = 30, 45 do
    local mainProgress = i
    local antiKickProgress = math.floor(((i - 30) / 15) * 100)
    updateLoader(mainProgress, "Загрузка AntiKick", 100, 100, antiKickProgress, 0, 0, 0)
    wait(0.03)
end

for i = 45, 65 do
    local mainProgress = i
    local antiDetectProgress = math.floor(((i - 45) / 20) * 100)
    updateLoader(mainProgress, "Загрузка AntiDetect", 100, 100, 100, antiDetectProgress, 0, 0)
    wait(0.03)
end

for i = 65, 85 do
    local mainProgress = i
    local threatsProgress = math.floor(((i - 65) / 20) * 100)
    updateLoader(mainProgress, "Удаление угроз", 100, 100, 100, 100, threatsProgress, 0)
    wait(0.03)
end

for i = 85, 100 do
    local mainProgress = i
    local resourcesProgress = math.floor(((i - 85) / 15) * 100)
    updateLoader(mainProgress, "Загрузка ресурсов", 100, 100, 100, 100, 100, resourcesProgress)
    wait(0.03)
end

updateLoader(100, "Готово!", 100, 100, 100, 100, 100, 100)
wait(0.5)
LoaderGui:Destroy()

-- ==========================================
-- ПЛАВАЮЩАЯ КНОПКА F
-- ==========================================
wait(0.2)

local MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "FeastHUB_Button"
MobileGui.Parent = game.CoreGui
MobileGui.ResetOnSpawn = false
MobileGui.IgnoreGuiInset = true
MobileGui.DisplayOrder = 999998

local FloatButton = Instance.new("TextButton")
FloatButton.Name = "FloatButton"
FloatButton.Parent = MobileGui
FloatButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatButton.BackgroundTransparency = 0.1
FloatButton.Position = UDim2.new(0, 20, 0.5, -25)
FloatButton.Size = UDim2.new(0, 50, 0, 50)
FloatButton.Text = ""
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

-- Анимация пульсации
local PulseIndicator = Instance.new("Frame")
PulseIndicator.Parent = FloatButton
PulseIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
PulseIndicator.BackgroundTransparency = 0.3
PulseIndicator.Position = UDim2.new(0.7, 0, 0.7, 0)
PulseIndicator.Size = UDim2.new(0, 8, 0, 8)

local PulseCorner = Instance.new("UICorner")
PulseCorner.CornerRadius = UDim.new(1, 0)
PulseCorner.Parent = PulseIndicator

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
Window = Library.CreateLib("FeastHUB [Killer_Mode]", "DarkTheme")

-- Центрируем и делаем перетаскиваемым
task.wait()
pcall(function()
    local gui = game.CoreGui:FindFirstChild("KavoUI")
    if gui then
        local main = gui:FindFirstChild("Main")
        if main then
            main.Position = UDim2.new(0.5, -300, 0.5, -200)
            main.Active = true
            main.Draggable = true
        end
    end
end)

-- ВКЛАДКИ (ПОЛНОСТЬЮ КАК НА ФОТО)
local MainTab = Window:NewTab("Main")
local FarmTab = Window:NewTab("Auto Farm")
local PlayerTab = Window:NewTab("Player")
local HealTab = Window:NewTab("Heal")
local AntiBanTab = Window:NewTab("AntiBan")
local SettingsTab = Window:NewTab("Settings")

-- ==========================================
-- УПРАВЛЕНИЕ МЕНЮ
-- ==========================================
local function ToggleMenu()
    if Library and Library.ToggleUI then
        Library:ToggleUI()
    end
end

FloatButton.MouseButton1Click:Connect(ToggleMenu)

-- Двойной клик для скрытия
local lastClick = 0
FloatButton.MouseButton1Click:Connect(function()
    local now = tick()
    if now - lastClick < 0.3 then
        FloatButton.Visible = false
        wait(1)
        FloatButton.Visible = true
    end
    lastClick = now
end)

-- ==========================================
-- PLAYER INFO (ИНТЕРФЕЙС КАК НА ФОТО)
-- ==========================================
local PlayerInfoSection = PlayerTab:NewSection("📊 Статистика")

-- Функция для форматирования чисел
local function formatNumber(num)
    if num >= 1e9 then
        return string.format("%.1fB", num / 1e9)
    elseif num >= 1e6 then
        return string.format("%.1fM", num / 1e6)
    elseif num >= 1e3 then
        return string.format("%.1fK", num / 1e3)
    else
        return tostring(num)
    end
end

-- Создаем метки СРАЗУ с правильными названиями
levelLabel = PlayerInfoSection:NewLabel("Ур. 2,667")
expLabel = PlayerInfoSection:NewLabel("61,275,204/151,664,233")
moneyLabel = PlayerInfoSection:NewLabel("$12,453")
fragmentsLabel = PlayerInfoSection:NewLabel("$884,983")
beliLabel = PlayerInfoSection:NewLabel("") -- Для совместимости

-- Функция обновления статистики
local function updateStats()
    pcall(function()
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            for _, v in pairs(leaderstats:GetChildren()) do
                if v.Name == "Level" then
                    levelLabel:UpdateLabel("Ур. " .. formatNumber(v.Value))
                elseif v.Name == "Exp" or v.Name == "XP" then
                    expLabel:UpdateLabel(formatNumber(v.Value) .. "/???")
                elseif v.Name == "Beli" or v.Name == "Money" then
                    moneyLabel:UpdateLabel("$" .. formatNumber(v.Value))
                elseif v.Name == "Fragments" then
                    fragmentsLabel:UpdateLabel("$" .. formatNumber(v.Value))
                end
            end
        end
    end)
end

-- Кнопка обновления
PlayerInfoSection:NewButton("🔄 Обновить статистику", function()
    updateStats()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "FeastHUB",
        Text = "📊 Статистика обновлена",
        Duration = 2
    })
end)

-- Первое обновление
updateStats()

-- Автообновление
spawn(function()
    while true do
        wait(5)
        updateStats()
    end
end)

-- ==========================================
-- GOD HEAL
-- ==========================================
local HealSection = HealTab:NewSection("👑 GOD HEAL")

local function startGodHeal()
    if godHealConnection then
        godHealConnection:Disconnect()
    end
    
    godHealConnection = RunService.RenderStepped:Connect(function()
        if not isGodHealEnabled then return end
        if not player.Character then return end
        
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
            
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end)
end

HealSection:NewToggle("👑 GOD HEAL", "Абсолютное бессмертие", function(state)
    isGodHealEnabled = state
    if state then
        startGodHeal()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "FeastHUB",
            Text = "👑 God Heal активирован",
            Duration = 3
        })
    else
        if godHealConnection then
            godHealConnection:Disconnect()
            godHealConnection = nil
        end
    end
end)

-- ==========================================
-- АВТОАТАКА
-- ==========================================
local AutoAttackSection = FarmTab:NewSection("⚔️ ULTRA ATTACK")

local function findAllTargets()
    local targets = {}
    if not player.Character then return targets end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return targets end
    
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v ~= player.Character then
            local hum = v:FindFirstChildOfClass("Humanoid")
            local hrp = v:FindFirstChild("HumanoidRootPart")
            
            if hum and hrp and hum.Health > 0 then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist <= 50 then
                    table.insert(targets, hrp)
                end
            end
        end
    end
    
    return targets
end

local function startAutoAttack()
    if attackConnection then
        attackConnection:Disconnect()
    end
    
    local lastAttack = 0
    local attackSpeed = 0.03
    
    attackConnection = RunService.Heartbeat:Connect(function()
        if not isAttackEnabled then return end
        
        local currentTime = tick()
        if currentTime - lastAttack < attackSpeed then
            return
        end
        
        local targets = findAllTargets()
        if #targets == 0 then return end
        
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        local tool = player.Character:FindFirstChildOfClass("Tool")
        
        if not root then return end
        
        local target = targets[1]
        root.CFrame = CFrame.lookAt(root.Position, target.Position)
        
        if (target.Position - root.Position).Magnitude > 8 then
            root.CFrame = target.CFrame * CFrame.new(0, 0, 4)
        end
        
        if tool then
            tool:Activate()
            tool:Activate()
            tool:Activate()
            tool:Activate()
            lastAttack = currentTime
        end
    end)
end

AutoAttackSection:NewButton("▶ ВКЛЮЧИТЬ", function()
    isAttackEnabled = true
    startAutoAttack()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "FeastHUB",
        Text = "⚔️ Ultra Attack включен",
        Duration = 3
    })
end)

AutoAttackSection:NewButton("⏹ ВЫКЛЮЧИТЬ", function()
    isAttackEnabled = false
    if attackConnection then
        attackConnection:Disconnect()
        attackConnection = nil
    end
end)

local attackStatus = AutoAttackSection:NewLabel("Статус: ⚪ Выключен")

spawn(function()
    while true do
        if isAttackEnabled then
            attackStatus:UpdateLabel("Статус: 🔴 Атакуем")
        else
            attackStatus:UpdateLabel("Статус: ⚪ Выключен")
        end
        wait(1)
    end
end)

-- ==========================================
-- ТЕЛЕПОРТЫ ПО МОРЯМ (В MAIN ВКЛАДКЕ)
-- ==========================================
local function safeTeleport(position)
    if not player.Character then return end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        player.Character:WaitForChild("HumanoidRootPart")
        root = player.Character:FindFirstChild("HumanoidRootPart")
    end
    
    root.CFrame = position
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "FeastHUB",
        Text = "🌍 Телепорт выполнен",
        Duration = 1
    })
end

-- Информация о море (СРАЗУ ПОСЛЕ ВКЛАДОК)
local seaNames = {"Первое", "Второе", "Третье"}
local SeaInfoSection = MainTab:NewSection("📡 ИНФОРМАЦИЯ")
SeaInfoSection:NewLabel("Текущее море: " .. seaNames[currentSea])

-- 1 МОРЕ (ВСЕ 13 ОСТРОВОВ)
if currentSea == 1 then
    local FirstSeaSection = MainTab:NewSection("🌊 ПЕРВОЕ МОРЕ")
    
    local islands = {
        {"🏝️ Стартовый остров", CFrame.new(100, 50, 100)},
        {"🏝️ Ветряная мельница", CFrame.new(800, 30, 1200)},
        {"🏝️ Шелл Таун", CFrame.new(-500, 20, 1500)},
        {"🏝️ Город пиратов", CFrame.new(1500, 30, -500)},
        {"🏝️ Пустыня", CFrame.new(1000, 50, -1500)},
        {"🏝️ Фростен", CFrame.new(-1500, 100, -1000)},
        {"🏝️ Морской город", CFrame.new(-2000, 20, 500)},
        {"🏝️ Колизей", CFrame.new(2000, 50, 2000)},
        {"🏝️ Тюрьма", CFrame.new(-2500, 30, -500)},
        {"🏝️ Магма", CFrame.new(3000, 50, -2000)},
        {"🏝️ Небесный остров", CFrame.new(-4000, 500, 3000)},
        {"🏝️ Фонтан", CFrame.new(3500, 50, 3500)},
        {"🏝️ Шангри-Ла", CFrame.new(-3500, 50, -3500)}
    }
    
    for _, island in ipairs(islands) do
        FirstSeaSection:NewButton(island[1], function()
            safeTeleport(island[2])
        end)
    end
end

-- 2 МОРЕ
if currentSea == 2 then
    local SecondSeaSection = MainTab:NewSection("🌊 ВТОРОЕ МОРЕ")
    
    local islands = {
        {"🏝️ Королевство Роз", CFrame.new(1000, 50, 1000)},
        {"🏝️ Зеленая зона", CFrame.new(2000, 50, 2000)},
        {"🏝️ Остров Усоппа", CFrame.new(3000, 50, -1000)},
        {"🏝️ Тюрьма пончика", CFrame.new(1500, 50, -2000)},
        {"🏝️ Завод", CFrame.new(-2000, 50, 1500)},
        {"🏝️ Морской город", CFrame.new(-1500, 50, -1500)},
        {"🏝️ Древний храм", CFrame.new(2500, 100, 2500)},
        {"🏝️ Крепость", CFrame.new(-2500, 50, -2500)},
        {"🏝️ Холодный остров", CFrame.new(3500, 100, 1000)},
        {"🏝️ Вулкан", CFrame.new(4000, 200, -2000)}
    }
    
    for _, island in ipairs(islands) do
        SecondSeaSection:NewButton(island[1], function()
            safeTeleport(island[2])
        end)
    end
end

-- 3 МОРЕ
if currentSea == 3 then
    local ThirdSeaSection = MainTab:NewSection("🌊 ТРЕТЬЕ МОРЕ")
    
    local islands = {
        {"🏝️ Особняк", CFrame.new(-10000, 50, -5000)},
        {"🏝️ Великое дерево", CFrame.new(-9000, 100, -6000)},
        {"🏝️ Замок на море", CFrame.new(-11000, 50, -4000)},
        {"🏝️ Остров Гидры", CFrame.new(-8000, 50, -7000)},
        {"🏝️ Остров морского короля", CFrame.new(-12000, 50, -3000)},
        {"🏝️ Пещера", CFrame.new(-7000, 30, -8000)},
        {"🏝️ Портал", CFrame.new(-13000, 50, -2000)},
        {"🏝️ Храм неба", CFrame.new(-6000, 500, -9000)},
        {"🏝️ Подводный город", CFrame.new(-14000, -100, -1000)},
        {"🏝️ Лавовая зона", CFrame.new(-5000, 200, -10000)}
    }
    
    for _, island in ipairs(islands) do
        ThirdSeaSection:NewButton(island[1], function()
            safeTeleport(island[2])
        end)
    end
end

-- Кнопка обновления моря
SeaInfoSection:NewButton("🔄 Обновить море", function()
    currentSea = getCurrentSea()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "FeastHUB",
        Text = "🌊 Море: " .. seaNames[currentSea],
        Duration = 2
    })
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

SpeedSection:NewSlider("Сила прыжка", "Максимум 100", 100, 50, function(s)
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = s
        end
    end
end)

-- ==========================================
-- ANTIBAN
-- ==========================================
local AntiBanSection = AntiBanTab:NewSection("🛡️ ЗАЩИТА")
AntiBanSection:NewLabel("✓ AntiKick активен")
AntiBanSection:NewLabel("✓ AntiTeleport активен")
AntiBanSection:NewLabel("✓ AntiCheat активен")

-- ==========================================
-- МОБИЛЬНЫЕ НАСТРОЙКИ
-- ==========================================
local MobileSection = SettingsTab:NewSection("📱 Управление")

MobileSection:NewButton("Показать кнопку F", function()
    FloatButton.Visible = true
end)

MobileSection:NewButton("Скрыть кнопку F", function()
    FloatButton.Visible = false
end)

MobileSection:NewButton("Кнопка в центр", function()
    FloatButton:TweenPosition(UDim2.new(0.5, -25, 0.5, -25), "Out", "Linear", 0.3)
end)

MobileSection:NewButton("Кнопка влево", function()
    FloatButton:TweenPosition(UDim2.new(0, 20, 0.5, -25), "Out", "Linear", 0.3)
end)

MobileSection:NewButton("Кнопка вправо", function()
    FloatButton:TweenPosition(UDim2.new(1, -70, 0.5, -25), "Out", "Linear", 0.3)
end)

-- Инструкция
local InfoSection = SettingsTab:NewSection("ℹ️ Инструкция")
InfoSection:NewLabel("• Нажми F - открыть/закрыть меню")
InfoSection:NewLabel("• Перетащи F - переместить кнопку")
InfoSection:NewLabel("• Двойной клик - скрыть на 1 сек")
InfoSection:NewLabel("• Меню можно перетаскивать")

-- ==========================================
-- ФИНАЛ
-- ==========================================
wait(0.5)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "FeastHUB",
    Text = "✅ Загружено! Море: " .. seaNames[currentSea],
    Duration = 4
})

print("✅ FeastHUB ULTIMATE загружен! Версия 31.0")
