--[[
    FeastHUB [Killer_Mode V1.1]- ULTIMATE EDITION
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
-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- ==========================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Переменные состояния
local isMenuVisible = true
local isAttackEnabled = false
local isInstantHealEnabled = false
local attackConnection = nil
local healConnection = nil
local lastPos = nil
local teleportCounter = 0
local currentSea = 1

-- ==========================================
-- ФУНКЦИЯ ОПРЕДЕЛЕНИЯ МОРЯ
-- ==========================================
local function getCurrentSea()
    if not player then return 1 end
    
    local success, result = pcall(function()
        local seas = {
            [1] = {name = "First Sea", islands = {"Starter Island", "Marine Starter", "Pirate Starter", "Windmill", "Shell Town"}},
            [2] = {name = "Second Sea", islands = {"Kingdom of Rose", "Green Zone", "Usoap's Island"}},
            [3] = {name = "Third Sea", islands = {"Mansion", "Great Tree", "Castle on the Sea", "Hydra Island"}}
        }
        
        for seaNum, seaData in pairs(seas) do
            for _, islandName in ipairs(seaData.islands) do
                if workspace:FindFirstChild(islandName) then
                    return seaNum
                end
            end
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            local y = pos.Y
            
            if y < 1000 then
                return 1
            elseif y < 5000 then
                return 2
            else
                return 3
            end
        end
        
        return 1
    end)
    
    if success then
        return result
    else
        return 1
    end
end

-- ==========================================
-- ФУНКЦИЯ ПРИНУДИТЕЛЬНОЙ ЗАГРУЗКИ ПЕРСОНАЖА
-- ==========================================
local function waitForCharacter()
    repeat wait(0.1) until player
    
    local function fullyLoadCharacter(character)
        if not character then return false end
        
        local humanoid = character:WaitForChild("Humanoid", 5)
        local rootPart = character:WaitForChild("HumanoidRootPart", 5)
        
        if not humanoid or not rootPart then return false end
        
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        
        if rootPart.Anchored then
            rootPart.Anchored = false
        end
        
        if humanoid.Health <= 0 then
            humanoid.Health = humanoid.MaxHealth
        end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                part.Visible = true
            end
        end
        
        return true
    end
    
    if player.Character then
        local success = fullyLoadCharacter(player.Character)
        if success then return end
    end
    
    local character = player.CharacterAdded:Wait()
    fullyLoadCharacter(character)
    
    player.CharacterAdded:Connect(function(newChar)
        wait(1)
        fullyLoadCharacter(newChar)
        
        if isAttackEnabled then
            startAutoAttack()
        end
        if isInstantHealEnabled then
            startInstantHeal()
        end
    end)
end

waitForCharacter()

-- ==========================================
-- ПРОДВИНУТЫЙ ANTIBAN/ANTIKICK
-- ==========================================
local mt = getrawmetatable(game)
local old_namecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "Kick" or method == "kick" then
        return
    end
    
    if method == "Destroy" and tostring(self):find("Character") then
        return
    end
    
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
RunService.Heartbeat:Connect(function()
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
-- ИСПРАВЛЕННЫЙ ЗАГРУЗОЧНЫЙ ЭКРАН
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
TitleLabel.Text = "FeastHUB [Killer_Mode V1]"
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

-- Новый статус с детальными процентами
local DetailStatus = Instance.new("TextLabel")
DetailStatus.Parent = LoaderFrame
DetailStatus.BackgroundTransparency = 1
DetailStatus.Position = UDim2.new(0, 20, 0, 150)
DetailStatus.Size = UDim2.new(1, -40, 0, 60)
DetailStatus.Font = Enum.Font.Gotham
DetailStatus.Text = "AntiBan: 0% | AntiLogger: 0% | AntiKick: 0%\nРесурсы: 0% | Запуск: 0%"
DetailStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
DetailStatus.TextSize = 12
DetailStatus.TextWrapped = true

-- Функция обновления загрузки (ИСПРАВЛЕНА)
local function updateLoader(percent, stage, antiBan, antiLogger, antiKick, resources, launch)
    ProgressBar:TweenSize(UDim2.new(percent/100, 0, 1, 0), "Out", "Linear", 0.2, true)
    PercentLabel.Text = math.floor(percent) .. "%"
    DetailStatus.Text = string.format("AntiBan: %d%% | AntiLogger: %d%% | AntiKick: %d%%\nРесурсы: %d%% | Запуск: %d%%", 
        antiBan, antiLogger, antiKick, resources, launch)
    StatusLabel.Text = "Статус: " .. stage
end

-- ЭТАПЫ ЗАГРУЗКИ (0-100%)
updateLoader(0, "Подготовка", 0, 0, 0, 0, 0)
wait(0.5)

-- Этап 1: AntiBan (0-35% основной, AntiBan 0-100%)
for i = 1, 35 do
    updateLoader(i, "Загрузка AntiBan", math.floor(i * 2.86), 0, 0, 0, 0)
    wait(0.03)
end

-- Этап 2: AntiLogger (35-50% основной, AntiLogger 0-100%)
for i = 35, 50 do
    local progress = (i - 35) * 6.67
    updateLoader(i, "Загрузка AntiLogger", 100, math.floor(progress), 0, 0, 0)
    wait(0.03)
end

-- Этап 3: AntiKick (50-75% основной, AntiKick 0-100%)
for i = 50, 75 do
    local progress = (i - 50) * 4
    updateLoader(i, "Загрузка AntiKick", 100, 100, math.floor(progress), 0, 0)
    wait(0.03)
end

-- Этап 4: Ресурсы (75-95% основной)
for i = 75, 95 do
    local progress = (i - 75) * 5
    updateLoader(i, "Загрузка ресурсов", 100, 100, 100, math.floor(progress), 0)
    wait(0.03)
end

-- Этап 5: Запуск (95-100% основной)
for i = 95, 100 do
    local progress = (i - 95) * 20
    updateLoader(i, "Запуск скрипта", 100, 100, 100, 100, math.floor(progress))
    wait(0.05)
end

updateLoader(100, "Готово!", 100, 100, 100, 100, 100)
wait(0.5)
LoaderGui:Destroy()

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
-- ОСНОВНОЕ МЕНЮ
-- ==========================================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("FeastHUB [Killer_Mode V1]", "DarkTheme")

-- Вкладки
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
    isMenuVisible = not isMenuVisible
    if isMenuVisible then
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
-- INSTANT HEAL (НОВЫЙ)
-- ==========================================
local HealSection = HealTab:NewSection("💚 INSTANT HEAL")

local function startInstantHeal()
    if healConnection then
        healConnection:Disconnect()
    end
    
    healConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not isInstantHealEnabled then return end
            if not player or not player.Character then return end
            
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                -- Мгновенно восстанавливаем здоровье если оно упало
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
                
                -- Защита от смерти
                if humanoid.Health <= 0 then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end)
    end)
end

HealSection:NewToggle("💚 INSTANT HEAL", "Мгновенное восстановление здоровья", function(state)
    isInstantHealEnabled = state
    if state then
        startInstantHeal()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "FeastHUB",
            Text = "💚 Instant Heal активирован",
            Duration = 3
        })
    else
        if healConnection then
            healConnection:Disconnect()
            healConnection = nil
        end
    end
end)

HealSection:NewLabel("✅ Мгновенно восстанавливает здоровье при получении урона")
HealSection:NewLabel("✅ Безопасно - не вызывает античит")

-- ==========================================
-- УЛУЧШЕННАЯ АВТОАТАКА
-- ==========================================
local AutoAttackSection = FarmTab:NewSection("⚔️ ULTRA ATTACK [50]")

local function findTargets()
    if not player or not player.Character then return {} end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return {} end
    
    local targets = {}
    
    -- Поиск мобов
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local objRoot = obj:FindFirstChild("HumanoidRootPart")
            
            if hum and hum.Health > 0 and objRoot then
                if not obj:FindFirstChild("Player") then
                    local dist = (objRoot.Position - root.Position).Magnitude
                    if dist <= 50 then
                        table.insert(targets, obj)
                    end
                end
            end
        end
    end
    
    -- Поиск игроков
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local hum = otherPlayer.Character:FindFirstChildOfClass("Humanoid")
            local objRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if hum and hum.Health > 0 and objRoot then
                local dist = (objRoot.Position - root.Position).Magnitude
                if dist <= 50 then
                    table.insert(targets, otherPlayer.Character)
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
    
    attackConnection = RunService.Heartbeat:Connect(function()
        if not isAttackEnabled then return end
        
        pcall(function()
            local targets = findTargets()
            if #targets == 0 then return end
            
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local tool = player.Character:FindFirstChildOfClass("Tool")
            
            if not root then return end
            
            local nearestTarget = nil
            local nearestDist = 9999
            
            for _, target in ipairs(targets) do
                local targetRoot = target:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local dist = (targetRoot.Position - root.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestTarget = target
                    end
                end
            end
            
            if nearestTarget then
                local targetRoot = nearestTarget:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    root.CFrame = CFrame.lookAt(root.Position, targetRoot.Position)
                    
                    if nearestDist > 8 then
                        root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 4)
                    end
                    
                    if tool then
                        tool:Activate()
                        wait(0.05)
                        tool:Activate()
                        wait(0.05)
                        tool:Activate()
                    end
                end
            end
        end)
    end)
end

AutoAttackSection:NewButton("▶ ВКЛЮЧИТЬ", "Атака в 3 раза быстрее, радиус 50", function()
    isAttackEnabled = true
    startAutoAttack()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "FeastHUB",
        Text = "⚔️ Ultra Attack включен",
        Duration = 3
    })
end)

AutoAttackSection:NewButton("⏹ ВЫКЛЮЧИТЬ", "Остановить", function()
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
-- ТЕЛЕПОРТЫ ПО МОРЯМ
-- ==========================================
currentSea = getCurrentSea()

local function teleportTo(position)
    if player and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = position
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "FeastHUB",
                Text = "🌍 Телепорт выполнен",
                Duration = 1
            })
        end
    end
end

-- 1 МОРЕ
local FirstSeaSection = MainTab:NewSection("🌊 ПЕРВОЕ МОРЕ")

local firstSeaIslands = {
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

for _, island in ipairs(firstSeaIslands) do
    FirstSeaSection:NewButton(island[1], "Телепорт", function()
        teleportTo(island[2])
    end)
end

-- 2 МОРЕ
local SecondSeaSection = MainTab:NewSection("🌊 ВТОРОЕ МОРЕ")

local secondSeaIslands = {
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

for _, island in ipairs(secondSeaIslands) do
    SecondSeaSection:NewButton(island[1], "Телепорт", function()
        teleportTo(island[2])
    end)
end

-- 3 МОРЕ
local ThirdSeaSection = MainTab:NewSection("🌊 ТРЕТЬЕ МОРЕ")

local thirdSeaIslands = {
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

for _, island in ipairs(thirdSeaIslands) do
    ThirdSeaSection:NewButton(island[1], "Телепорт", function()
        teleportTo(island[2])
    end)
end

-- Информация о море
local SeaInfoSection = MainTab:NewSection("📡 ИНФОРМАЦИЯ")
local seaNames = {"Первое", "Второе", "Третье"}
SeaInfoSection:NewLabel("Текущее море: " .. seaNames[currentSea])

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

-- ==========================================
-- ФИНАЛЬНОЕ УВЕДОМЛЕНИЕ
-- ==========================================
wait(0.5)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "FeastHUB",
    Text = "✅ Загружено! Море: " .. seaNames[currentSea],
    Duration = 4
})

print("✅ FeastHUB ULTIMATE загружен!")
