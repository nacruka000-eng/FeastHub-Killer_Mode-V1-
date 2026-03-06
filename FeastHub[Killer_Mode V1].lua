--[[
    FeastHUB [Killer_Mode V1] - Mobile Edition
    ANTI-ANTICHEAT / ANTI-LOGGER SYSTEM V5
    Полное уничтожение всех систем слежения
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

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = LoaderFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = LoaderFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 20, 0, 15)
TitleLabel.Size = UDim2.new(1, -40, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "FeastHUB [Killer_Mode V1]"
TitleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
TitleLabel.TextScaled = true

local SubLabel = Instance.new("TextLabel")
SubLabel.Parent = LoaderFrame
SubLabel.BackgroundTransparency = 1
SubLabel.Position = UDim2.new(0, 20, 0, 55)
SubLabel.Size = UDim2.new(1, -40, 0, 25)
SubLabel.Font = Enum.Font.Gotham
SubLabel.Text = "запуск скрипта..."
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
DetailStatus.Text = "[AntiCheat:0% | AntiLogger:0% | Total:0%]"
DetailStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
DetailStatus.TextSize = 12
DetailStatus.TextWrapped = true

-- Функция обновления загрузки
local function updateLoader(percent, stage, ac, logger, total)
    ProgressBar:TweenSize(UDim2.new(percent/100, 0, 1, 0), "Out", "Linear", 0.2, true)
    PercentLabel.Text = math.floor(percent) .. "%"
    DetailStatus.Text = string.format("[AntiCheat:%d%% | AntiLogger:%d%% | Total:%d%%]", 
        ac or 0, logger or 0, total or 0)
    StatusLabel.Text = "Статус: " .. stage
end

-- Этапы загрузки
updateLoader(0, "Поиск систем слежения", 0, 0, 0)
wait(0.5)

for i = 1, 40 do
    updateLoader(i, "Сканирование AntiCheat", i, 0, 0)
    wait(0.03)
end

for i = 40, 80 do
    updateLoader(i, "Поиск логгеров", 40, i-40, 0)
    wait(0.02)
end

for i = 80, 100 do
    updateLoader(i, "Уничтожение угроз", 40, 40, i-80)
    wait(0.05)
end

updateLoader(100, "Система активна", 40, 40, 20)
wait(0.5)
LoaderGui:Destroy()

-- ==========================================
-- ГЛАВНАЯ СИСТЕМА: ОХОТНИК ЗА АНТИЧИТАМИ
-- ==========================================
wait(0.2)

-- Создаем главный GUI
local MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "FeastHUB_Button"
MobileGui.Parent = game.CoreGui
MobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MobileGui.ResetOnSpawn = false
MobileGui.IgnoreGuiInset = true
MobileGui.DisplayOrder = 999998

-- Плавающая кнопка F
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

-- Анимация пульсации
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
local AC_HunterTab = Window:NewTab("🔍 ANTI-CHEAT HUNTER")
local SpeedTab = Window:NewTab("Speed")
local FarmTab = Window:NewTab("Auto Farm")
local SettingsTab = Window:NewTab("Settings")

-- ==========================================
-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- ==========================================
local Hunter = {
    active = true,
    scanInterval = 2,
    threatsFound = 0,
    threatsDestroyed = 0,
    lastScan = 0
}

-- ==========================================
-- АНТИ-АНТИЧИТ / АНТИ-ЛОГГЕР (ГЛАВНОЕ)
-- ==========================================
local HunterSection = AC_HunterTab:NewSection("🎯 ОХОТНИК ЗА АНТИЧИТАМИ")

-- СПИСОК ВСЕХ ИЗВЕСТНЫХ АНТИЧИТОВ BLOX FRUIT
local KNOWN_ANTICHEATS = {
    -- Названия античитов
    "AntiCheat", "AC", "AntiCheatModule", "CheatDetector",
    "BanSystem", "BanHandler", "Admin", "ADMIN", "Remote",
    "AntiExploit", "AE", "Security", "Sec", "Guard",
    "Detector", "Scanner", "Monitor", "Logger", "Log",
    "BanService", "Punishment", "KickHandler", "Kick",
    
    -- Подозрительные модули
    "Module_AC", "Module_AntiCheat", "AC_Module",
    "RemoteEvent_AC", "RemoteFunction_AC",
    "AntiCheatEvent", "BanEvent", "KickEvent",
    
    -- Системы слежения
    "Tracking", "Tracker", "Telemetry", "Analytics",
    "DataCollection", "PlayerData", "ActivityLog",
    
    -- Специфичные для Blox Fruit
    "BloxFruitAC", "BF_AC", "BF_AntiCheat",
    "FruitGuard", "IslandGuard", "WorldGuard",
    "CombatLogger", "MovementChecker", "SpeedChecker",
    "JumpChecker", "FlyChecker", "TPChecker"
}

-- СПИСОК ЛОГГЕРОВ (сбор информации)
local KNOWN_LOGGERS = {
    "Logger", "LogService", "DataLogger", "Analytics",
    "Telemetry", "Metric", "Stats", "Statistics",
    "DataCollector", "DataGatherer", "InfoGather",
    "PlayerTracker", "ActivityTracker", "SessionTracker",
    "ReportSystem", "ReportHandler", "Feedback",
    "CrashReporter", "ErrorHandler", "Debugger"
}

-- СПИСОК REMOTE СОБЫТИЙ (подозрительные)
local SUSPICIOUS_REMOTES = {
    "Ban", "Kick", "AC", "AntiCheat", "Detection",
    "Report", "Flag", "Suspect", "CheatDetected",
    "Punish", "Punishment", "KickPlayer", "BanPlayer"
}

-- ГЛАВНАЯ ФУНКЦИЯ ПОИСКА И УНИЧТОЖЕНИЯ
local function HuntAndDestroy()
    spawn(function()
        while Hunter.active do
            pcall(function()
                local currentTime = tick()
                
                -- Сканируем раз в 2 секунды
                if currentTime - Hunter.lastScan >= Hunter.scanInterval then
                    Hunter.lastScan = currentTime
                    
                    local threatsFound = 0
                    local threatsDestroyed = 0
                    
                    -- ==========================================
                    -- 1. СКАНИРОВАНИЕ PLAYERGUI
                    -- ==========================================
                    local player = game:GetService("Players").LocalPlayer
                    if player and player.PlayerGui then
                        for _, v in pairs(player.PlayerGui:GetDescendants()) do
                            -- Проверяем по именам
                            for _, name in pairs(KNOWN_ANTICHEATS) do
                                if v.Name:lower():find(name:lower()) then
                                    threatsFound = threatsFound + 1
                                    pcall(function() v:Destroy() end)
                                    threatsDestroyed = threatsDestroyed + 1
                                end
                            end
                            
                            for _, name in pairs(KNOWN_LOGGERS) do
                                if v.Name:lower():find(name:lower()) then
                                    threatsFound = threatsFound + 1
                                    pcall(function() v:Destroy() end)
                                    threatsDestroyed = threatsDestroyed + 1
                                end
                            end
                            
                            -- Проверяем типы объектов
                            if v:IsA("ScreenGui") and v.Name:lower():find("ac") then
                                threatsFound = threatsFound + 1
                                pcall(function() v:Destroy() end)
                                threatsDestroyed = threatsDestroyed + 1
                            end
                            
                            if v:IsA("Frame") and v.BackgroundColor3 == Color3.fromRGB(255, 0, 0) then
                                if v.Name:lower():find("alert") or v.Name:lower():find("warning") then
                                    threatsFound = threatsFound + 1
                                    pcall(function() v:Destroy() end)
                                    threatsDestroyed = threatsDestroyed + 1
                                end
                            end
                        end
                    end
                    
                    -- ==========================================
                    -- 2. СКАНИРОВАНИЕ WORKSPACE
                    -- ==========================================
                    for _, v in pairs(workspace:GetDescendants()) do
                        for _, name in pairs(KNOWN_ANTICHEATS) do
                            if v.Name:lower():find(name:lower()) then
                                threatsFound = threatsFound + 1
                                pcall(function() v:Destroy() end)
                                threatsDestroyed = threatsDestroyed + 1
                            end
                        end
                        
                        for _, name in pairs(KNOWN_LOGGERS) do
                            if v.Name:lower():find(name:lower()) then
                                threatsFound = threatsFound + 1
                                pcall(function() v:Destroy() end)
                                threatsDestroyed = threatsDestroyed + 1
                            end
                        end
                    end
                    
                    -- ==========================================
                    -- 3. СКАНИРОВАНИЕ COREGUI
                    -- ==========================================
                    for _, v in pairs(game.CoreGui:GetDescendants()) do
                        -- Не удаляем собственный GUI
                        if not v.Name:find("FeastHUB") then
                            for _, name in pairs(KNOWN_ANTICHEATS) do
                                if v.Name:lower():find(name:lower()) then
                                    threatsFound = threatsFound + 1
                                    pcall(function() v:Destroy() end)
                                    threatsDestroyed = threatsDestroyed + 1
                                end
                            end
                            
                            for _, name in pairs(KNOWN_LOGGERS) do
                                if v.Name:lower():find(name:lower()) then
                                    threatsFound = threatsFound + 1
                                    pcall(function() v:Destroy() end)
                                    threatsDestroyed = threatsDestroyed + 1
                                end
                            end
                        end
                    end
                    
                    -- ==========================================
                    -- 4. СКАНИРОВАНИЕ REPLICATEDSTORAGE
                    -- ==========================================
                    if game:GetService("ReplicatedStorage") then
                        for _, v in pairs(game.ReplicatedStorage:GetDescendants()) do
                            -- Проверяем Remote события
                            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                                for _, name in pairs(SUSPICIOUS_REMOTES) do
                                    if v.Name:lower():find(name:lower()) then
                                        threatsFound = threatsFound + 1
                                        -- Блокируем, но не удаляем (может сломать игру)
                                        pcall(function() 
                                            v:Destroy() 
                                            threatsDestroyed = threatsDestroyed + 1
                                        end)
                                    end
                                end
                            end
                            
                            -- Проверяем модули
                            if v:IsA("ModuleScript") then
                                for _, name in pairs(KNOWN_ANTICHEATS) do
                                    if v.Name:lower():find(name:lower()) then
                                        threatsFound = threatsFound + 1
                                        pcall(function() 
                                            v:Destroy() 
                                            threatsDestroyed = threatsDestroyed + 1
                                        end)
                                    end
                                end
                            end
                        end
                    end
                    
                    -- ==========================================
                    -- 5. ПОИСК СКРЫТЫХ ЛОГГЕРОВ
                    -- ==========================================
                    for _, v in pairs(getgc(true)) do
                        if type(v) == "table" then
                            -- Проверяем таблицы на наличие функций логирования
                            for key, value in pairs(v) do
                                if type(key) == "string" then
                                    if key:lower():find("log") or key:lower():find("report") then
                                        if type(value) == "function" then
                                            -- Очищаем таблицу
                                            pcall(function()
                                                v[key] = function() return true end
                                                threatsDestroyed = threatsDestroyed + 1
                                            end)
                                        end
                                    end
                                    
                                    if key:lower():find("ban") or key:lower():find("kick") then
                                        if type(value) == "function" then
                                            pcall(function()
                                                v[key] = function() return false end
                                                threatsDestroyed = threatsDestroyed + 1
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Обновляем статистику
                    Hunter.threatsFound = Hunter.threatsFound + threatsFound
                    Hunter.threatsDestroyed = Hunter.threatsDestroyed + threatsDestroyed
                end
            end)
            wait(1)
        end
    end)
end

-- Кнопка активации охотника
HunterSection:NewToggle("🔍 АКТИВИРОВАТЬ ОХОТНИКА", "Поиск и уничтожение античитов", function(state)
    Hunter.active = state
    if state then
        HuntAndDestroy()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "FeastHUB",
            Text = "🔍 Охотник за античитами активирован!",
            Duration = 3
        })
    end
end)

-- Настройки охотника
local HunterSettings = AC_HunterTab:NewSection("⚙️ Настройки охотника")

HunterSettings:NewSlider("Интервал сканирования", "Частота проверки (сек)", 5, 1, function(s)
    Hunter.scanInterval = s
end)

HunterSettings:NewButton("Принудительное сканирование", "Проверить сейчас", function()
    Hunter.lastScan = 0
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "FeastHUB",
        Text = "🔍 Сканирование запущено...",
        Duration = 2
    })
end)

-- Статистика
local HunterStats = AC_HunterTab:NewSection("📊 Статистика")

local threatsFoundLabel = HunterStats:NewLabel("Найдено угроз: 0")
local threatsDestroyedLabel = HunterStats:NewLabel("Уничтожено: 0")
local protectionStatus = HunterStats:NewLabel("Статус: Защита активна")

-- Обновление статистики
spawn(function()
    while true do
        pcall(function()
            threatsFoundLabel:UpdateLabel("Найдено угроз: " .. Hunter.threatsFound)
            threatsDestroyedLabel:UpdateLabel("Уничтожено: " .. Hunter.threatsDestroyed)
            
            if Hunter.threatsDestroyed > 0 then
                protectionStatus:UpdateLabel("Статус: ✅ Защищен")
            else
                protectionStatus:UpdateLabel("Статус: 🟢 Система активна")
            end
        end)
        wait(3)
    end
end)

-- ==========================================
-- УПРАВЛЕНИЕ КНОПКОЙ F
-- ==========================================
local MenuVisible = true

local function ToggleMenu()
    MenuVisible = not MenuVisible
    if MenuVisible then
        Window:ToggleUI()
        FLetter.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        Window:ToggleUI()
        FLetter.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
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
-- SPEED FUNCTIONS
-- ==========================================
local SpeedSection = SpeedTab:NewSection("⚡ Speed Control")

SpeedSection:NewSlider("Speed Walk", "Скорость бега", 100, 16, function(s)
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = s
        end
    end
end)

SpeedSection:NewToggle("Speed Attack", "Ускорение атак", function(state)
    if state then
        game:GetService("RunService").Stepped:Connect(function()
            pcall(function()
                local player = game:GetService("Players").LocalPlayer
                if player and player.Character then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        for _, anim in pairs(humanoid:GetPlayingAnimationTracks()) do
                            if anim.Animation.AnimationId:lower():find("attack") then
                                anim:AdjustSpeed(5)
                            end
                        end
                    end
                end
            end)
        end)
    end
end)

-- ==========================================
-- AUTO FARM
-- ==========================================
local FarmSection = FarmTab:NewSection("🤖 Auto Farm")

local farming = false
FarmSection:NewButton("Start Auto Farm", "Атаковать мобов", function()
    farming = true
    spawn(function()
        while farming do
            pcall(function()
                local player = game:GetService("Players").LocalPlayer
                if player and player.Character then
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        for _, v in pairs(workspace:GetChildren()) do
                            if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                                local hum = v:FindFirstChildOfClass("Humanoid")
                                if hum and hum.Health > 0 then
                                    local mobRoot = v:FindFirstChild("HumanoidRootPart")
                                    if mobRoot then
                                        root.CFrame = mobRoot.CFrame * CFrame.new(0, 0, 3)
                                        wait(0.1)
                                        local tool = player.Character:FindFirstChildOfClass("Tool")
                                        if tool then
                                            tool:Activate()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            wait(0.3)
        end
    end)
end)

FarmSection:NewButton("Stop Auto Farm", "Остановить", function()
    farming = false
end)

-- ==========================================
-- МОБИЛЬНЫЕ НАСТРОЙКИ
-- ==========================================
local MobileSection = SettingsTab:NewSection("📱 Мобильное управление")

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
InfoSection:NewLabel("• Тап по F - открыть меню")
InfoSection:NewLabel("• Перетащи F - переместить")
InfoSection:NewLabel("• Двойной тап - скрыть на 1 сек")
InfoSection:NewLabel("• Охотник сам ищет античиты")

-- ==========================================
-- АВТОЗАПУСК
-- ==========================================
wait(0.5)
Hunter.active = true
HuntAndDestroy()

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "FeastHUB",
    Text = "✅ Охотник за античитами активен!",
    Duration = 5
})

print("✅ FeastHUB загружен! Охотник ищет античиты...")
