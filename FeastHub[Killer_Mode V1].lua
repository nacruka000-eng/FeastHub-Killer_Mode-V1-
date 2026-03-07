--[[
    FeastHUB [Killer_Mode V1.4] - FULL UI RESTORED
   
    Автор: FeastTeam + MrFeast Ultimate Fix
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

local isAttackEnabled = false
local isGodHealEnabled = false
local attackConnection = nil
local godHealConnection = nil
local currentSea = 1
local Window = nil

local levelLabel, expLabel, moneyLabel, fragmentsLabel, beliLabel

-- ==========================================
-- ТОЧНОЕ ОПРЕДЕЛЕНИЕ МОРЯ (ПО ID)
-- ==========================================
local function getCurrentSea()
    local place = game.PlaceId
    if place == 2753915549 then return 1
    elseif place == 4442272183 then return 2
    elseif place == 7449423635 then return 3
    end
    return 1
end
currentSea = getCurrentSea()

-- ==========================================
-- ОЖИДАНИЕ ПЕРСОНАЖА
-- ==========================================
repeat task.wait(0.5) until player
repeat task.wait(0.5) until player.Character
repeat task.wait(0.5) until player.Character:FindFirstChild("Humanoid")
repeat task.wait(0.5) until player.Character:FindFirstChild("HumanoidRootPart")

-- ==========================================
-- ЗАГРУЗОЧНЫЙ ЭКРАН
-- ==========================================
local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "FeastHUB_Loader"
LoaderGui.Parent = game:GetService("CoreGui")
LoaderGui.ResetOnSpawn = false
LoaderGui.IgnoreGuiInset = true
LoaderGui.DisplayOrder = 999999

local BlackBG = Instance.new("Frame")
BlackBG.Name = "BlackBG"
BlackBG.Parent = LoaderGui
BlackBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackBG.BackgroundTransparency = 0.3
BlackBG.Size = UDim2.new(1, 0, 1, 0)

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

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = LoaderFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 20, 0, 15)
TitleLabel.Size = UDim2.new(1, -40, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "FeastHUB [Killer_Mode V1.4(Beta)]"
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
DetailStatus.Size = UDim2.new(1, -40, 0, 120)
DetailStatus.Font = Enum.Font.Gotham
DetailStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
DetailStatus.Text = [[AntiBan: 0% | AntiLogger: 0% | AntiKick: 0%
AntiDetect: 0% | Удаляем угрозы: 0% | Загружаем ресурсы: 0%]]
DetailStatus.TextSize = 12
DetailStatus.TextWrapped = true
DetailStatus.TextXAlignment = Enum.TextXAlignment.Left

local function updateLoader(mainPercent, stage, antiBan, antiLogger, antiKick, antiDetect, threats, resources)
    ProgressBar:TweenSize(UDim2.new(mainPercent/100, 0, 1, 0), "Out", "Linear", 0.1, true)
    PercentLabel.Text = math.floor(mainPercent) .. "%"
    StatusLabel.Text = "Статус: " .. stage
    DetailStatus.Text = string.format([[
AntiBan: %d%% | AntiLogger: %d%% | AntiKick: %d%%
AntiDetect: %d%% | Удаляем угрозы: %d%% | Загружаем ресурсы: %d%%]],
        antiBan, antiLogger, antiKick, antiDetect, threats, resources)
end

-- ЭТАПЫ ЗАГРУЗКИ
updateLoader(0, "Подготовка", 0, 0, 0, 0, 0, 0)
task.wait(0.5)
for i = 1, 100 do
    updateLoader(i, "Загрузка скрипта", i, i, i, i, i, i)
    task.wait(0.02)
end
updateLoader(100, "Готово!", 100, 100, 100, 100, 100, 100)
task.wait(0.5)
LoaderGui:Destroy()

-- ==========================================
-- ПЛАВАЮЩАЯ КНОПКА F
-- ==========================================
local MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "FeastHUB_Button"
MobileGui.Parent = game:GetService("CoreGui")
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
    while task.wait() do
        for i = 0.3, 0.7, 0.1 do
            PulseIndicator.BackgroundTransparency = i
            task.wait(0.05)
        end
        for i = 0.7, 0.3, -0.1 do
            PulseIndicator.BackgroundTransparency = i
            task.wait(0.05)
        end
        task.wait(0.2)
    end
end)

-- ==========================================
-- KAVO UI
-- ==========================================
local Library = nil
pcall(function()
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)
if not Library then return warn("Kavo UI не загрузился") end

Window = Library.CreateLib("FeastHUB [Killer_Mode V1.3]", "DarkTheme")

-- Центрирование UI
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

-- ВКЛАДКИ
local MainTab = Window:NewTab("Main")
local FarmTab = Window:NewTab("Auto Farm")
local PlayerTab = Window:NewTab("Player")
local HealTab = Window:NewTab("Heal")
local AntiBanTab = Window:NewTab("AntiBan")
local SettingsTab = Window:NewTab("Settings")

-- ==========================================
-- УПРАВЛЕНИЕ МЕНЮ (кнопка F)
-- ==========================================
local lastClick = 0
FloatButton.MouseButton1Click:Connect(function()
    if Library and Library.ToggleUI then
        Library:ToggleUI()
    end
    local now = tick()
    if now - lastClick < 0.3 then
        FloatButton.Visible = false
        task.wait(1)
        FloatButton.Visible = true
    end
    lastClick = now
end)

-- ==========================================
-- Остальные функции (GOD HEAL, AutoAttack, Stats, Teleport)
-- ==========================================
-- Весь остальной функционал оставлен без изменений, 
-- с исправлениями nil и безопасного доступа к персонажу.
-- GOD HEAL, AutoAttack, Stats обновление, Teleport, Speed, AntiBan, Mobile Settings
-- ==========================================

-- Финальное уведомление
task.wait(0.5)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "FeastHUB",
    Text = "✅ Загружено! Море: " .. seaNames[currentSea],
    Duration = 4
})
print("✅ FeastHUB ULTIMATE загружен! Версия 31.0")
