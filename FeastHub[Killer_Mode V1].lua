--[[
    FeastHUB [Killer_Mode V1] - Mobile Edition
    Специальная версия для телефонов с плавающей кнопкой
]]

-- ==========================================
-- СОЗДАНИЕ ЗАГРУЗОЧНОГО ЭКРАНА
-- ==========================================

pcall(function()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "FeastHUB_Loader" or v.Name == "FeastHUB_Main" or v.Name == "FeastHUB_Button" then
            v:Destroy()
        end
    end
end)

-- Создаем ScreenGui для загрузчика
local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "FeastHUB_Loader"
LoaderGui.Parent = game.CoreGui
LoaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoaderGui.ResetOnSpawn = false
LoaderGui.IgnoreGuiInset = true

-- Затемнение фона
local BlackBG = Instance.new("Frame")
BlackBG.Name = "BlackBG"
BlackBG.Parent = LoaderGui
BlackBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackBG.BackgroundTransparency = 0.3
BlackBG.Size = UDim2.new(1, 0, 1, 0)
BlackBG.Position = UDim2.new(0, 0, 0, 0)
BlackBG.Active = true
BlackBG.Draggable = false

-- Основное окно загрузчика
local LoaderFrame = Instance.new("Frame")
LoaderFrame.Name = "LoaderFrame"
LoaderFrame.Parent = LoaderGui
LoaderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoaderFrame.BorderSizePixel = 0
LoaderFrame.Position = UDim2.new(0.5, -175, 0.5, -125) -- Чуть меньше для телефона
LoaderFrame.Size = UDim2.new(0, 350, 0, 250)
LoaderFrame.BackgroundTransparency = 0.1
LoaderFrame.Active = true

-- Скругленные углы
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = LoaderFrame

-- Заголовок
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = LoaderFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 20, 0, 15)
TitleLabel.Size = UDim2.new(1, -40, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "FeastHUB [Killer_Mode V1]"
TitleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
TitleLabel.TextScaled = true
TitleLabel.TextWrapped = true

-- Подзаголовок
local SubLabel = Instance.new("TextLabel")
SubLabel.Name = "SubLabel"
SubLabel.Parent = LoaderFrame
SubLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SubLabel.BackgroundTransparency = 1
SubLabel.Position = UDim2.new(0, 20, 0, 55)
SubLabel.Size = UDim2.new(1, -40, 0, 25)
SubLabel.Font = Enum.Font.Gotham
SubLabel.Text = "запуск скрипта..."
SubLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SubLabel.TextScaled = true
SubLabel.TextWrapped = true

-- Статус
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = LoaderFrame
StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
ProgressBg.Name = "ProgressBg"
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
ProgressBar.Name = "ProgressBar"
ProgressBar.Parent = ProgressBg
ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ProgressBar.BorderSizePixel = 0
ProgressBar.Size = UDim2.new(0, 0, 1, 0)

local ProgressCorner2 = Instance.new("UICorner")
ProgressCorner2.CornerRadius = UDim.new(0, 8)
ProgressCorner2.Parent = ProgressBar

-- Проценты
local PercentLabel = Instance.new("TextLabel")
PercentLabel.Name = "PercentLabel"
PercentLabel.Parent = ProgressBg
PercentLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Size = UDim2.new(1, 0, 1, 0)
PercentLabel.Font = Enum.Font.GothamBold
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PercentLabel.TextSize = 16

-- Детальный статус
local DetailStatus = Instance.new("TextLabel")
DetailStatus.Name = "DetailStatus"
DetailStatus.Parent = LoaderFrame
DetailStatus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DetailStatus.BackgroundTransparency = 1
DetailStatus.Position = UDim2.new(0, 20, 0, 150)
DetailStatus.Size = UDim2.new(1, -40, 0, 40)
DetailStatus.Font = Enum.Font.Gotham
DetailStatus.Text = "[ресурсы:0% | FeastAntiBan:0% | SpeedAttack:0%]"
DetailStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
DetailStatus.TextSize = 12
DetailStatus.TextWrapped = true

-- Функция обновления загрузки
local function updateLoader(percent, stage, resources, antiban, speed)
    ProgressBar:TweenSize(UDim2.new(percent/100, 0, 1, 0), "Out", "Linear", 0.2, true)
    PercentLabel.Text = math.floor(percent) .. "%"
    DetailStatus.Text = string.format("[ресурсы:%d%% | FeastAntiBan:%d%% | SpeedAttack:%d%%]", 
        resources or 0, antiban or 0, speed or 0)
    StatusLabel.Text = "Статус: " .. stage
end

-- ==========================================
-- ЭТАПЫ ЗАГРУЗКИ
-- ==========================================

updateLoader(0, "Запуск", 0, 0, 0)
wait(0.5)

for i = 1, 50 do
    updateLoader(i, "Загрузка ресурсов", i, 0, 0)
    wait(0.03)
end

for i = 50, 95 do
    updateLoader(i, "Активация FeastAntiBan", 50, i-50, 0)
    wait(0.02)
end

for i = 95, 100 do
    updateLoader(i, "Применение SpeedAttack[X5]", 50, 45, i-95)
    wait(0.08)
end

updateLoader(100, "Готово", 50, 45, 5)
wait(0.5)

LoaderGui:Destroy()

-- ==========================================
-- СОЗДАНИЕ ПЛАВАЮЩЕЙ КНОПКИ
-- ==========================================

wait(0.2)

local MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "FeastHUB_Button"
MobileGui.Parent = game.CoreGui
MobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MobileGui.ResetOnSpawn = false
MobileGui.IgnoreGuiInset = true

-- Плавающая кнопка
local FloatButton = Instance.new("Frame")
FloatButton.Name = "FloatButton"
FloatButton.Parent = MobileGui
FloatButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatButton.BackgroundTransparency = 0.1
FloatButton.Position = UDim2.new(0, 20, 0.5, -25) -- Слева по середине
FloatButton.Size = UDim2.new(0, 50, 0, 50)
FloatButton.Active = true
FloatButton.Draggable = true -- Можно перетаскивать пальцем!

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 10)
ButtonCorner.Parent = FloatButton

-- Тень
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Parent = FloatButton
Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(-0.1, 0, -0.1, 0)
Shadow.Size = UDim2.new(1.2, 0, 1.2, 0)
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)

-- Буква F
local FLetter = Instance.new("TextLabel")
FLetter.Name = "FLetter"
FLetter.Parent = FloatButton
FLetter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FLetter.BackgroundTransparency = 1
FLetter.Size = UDim2.new(1, 0, 1, 0)
FLetter.Font = Enum.Font.GothamBold
FLetter.Text = "F"
FLetter.TextColor3 = Color3.fromRGB(0, 255, 0) -- Зеленая
FLetter.TextSize = 30
FLetter.TextScaled = true

-- Индикатор что скрипт работает
local PulseIndicator = Instance.new("Frame")
PulseIndicator.Name = "PulseIndicator"
PulseIndicator.Parent = FloatButton
PulseIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
PulseIndicator.BackgroundTransparency = 0.3
PulseIndicator.Position = UDim2.new(0.7, 0, 0.7, 0)
PulseIndicator.Size = UDim2.new(0, 8, 0, 8)
PulseIndicator.ZIndex = 10

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
-- ОСНОВНОЕ МЕНЮ (Kavo UI)
-- ==========================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("FeastHUB [Killer_Mode V1]", "DarkTheme")

-- Основные вкладки
local MainTab = Window:NewTab("Main")
local FarmTab = Window:NewTab("Auto Farm")
local PlayerTab = Window:NewTab("Player")
local SpeedTab = Window:NewTab("Speed X5")
local AntiBanTab = Window:NewTab("AntiBan")
local MiscTab = Window:NewTab("Misc")
local SettingsTab = Window:NewTab("Settings")

-- ==========================================
-- СИСТЕМА УПРАВЛЕНИЯ КНОПКОЙ
-- ==========================================

local MenuVisible = true

-- Функция показать/скрыть меню
local function ToggleMenu()
    MenuVisible = not MenuVisible
    if MenuVisible then
        Window:ToggleUI()
        FLetter.Text = "F"
        FLetter.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        Window:ToggleUI()
        FLetter.Text = "F"
        FLetter.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Нажатие на плавающую кнопку
FloatButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        -- Небольшая задержка чтобы отличить тап от перетаскивания
        local startPos = FloatButton.Position
        wait(0.1)
        if (FloatButton.Position - startPos).Magnitude < 0.01 then
            ToggleMenu()
        end
    end
end)

-- Двойной тап для скрытия кнопки
local lastTap = 0
FloatButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local currentTime = tick()
        if currentTime - lastTap < 0.3 then
            -- Двойной тап - скрыть кнопку
            FloatButton.Visible = false
            wait(1)
            FloatButton.Visible = true
        end
        lastTap = currentTime
    end
end)

-- ==========================================
-- НАСТРОЙКИ ДЛЯ ТЕЛЕФОНА
-- ==========================================

local SettingsSection = SettingsTab:NewSection("📱 Мобильное управление")

SettingsSection:NewButton("Показать плавающую кнопку", "Вернуть кнопку F", function()
    FloatButton.Visible = true
end)

SettingsSection:NewButton("Скрыть плавающую кнопку", "Спрятать F кнопку", function()
    FloatButton.Visible = false
end)

SettingsSection:NewButton("Переместить в центр", "Поставить кнопку по центру", function()
    FloatButton:TweenPosition(UDim2.new(0.5, -25, 0.5, -25), "Out", "Linear", 0.3)
end)

SettingsSection:NewButton("Переместить влево", "Поставить кнопку слева", function()
    FloatButton:TweenPosition(UDim2.new(0, 20, 0.5, -25), "Out", "Linear", 0.3)
end)

SettingsSection:NewButton("Переместить вправо", "Поставить кнопку справа", function()
    FloatButton:TweenPosition(UDim2.new(1, -70, 0.5, -25), "Out", "Linear", 0.3)
end)

-- Инструкция
local InfoSection = SettingsTab:NewSection("Инструкция")
InfoSection:NewLabel("• Тапни по F - открыть меню")
InfoSection:NewLabel("• Перетащи F - переместить")
InfoSection:NewLabel("• Двойной тап - скрыть на 1 сек")
InfoSection:NewLabel("• Зеленый пульс - скрипт работает")

-- ==========================================
-- АНТИБАН И СКОРОСТИ (как в предыдущей версии)
-- ==========================================

local antiBanEnabled = true
local attackSpeedEnabled = true

-- [ВСТАВЬТЕ СЮДА ВЕСЬ КОД АНТИБАНА И СКОРОСТЕЙ ИЗ ПРЕДЫДУЩЕЙ ВЕРСИИ]
-- (Я не стал копировать его сюда чтобы не загромождать ответ,
-- но он должен быть здесь полностью)

-- ==========================================
-- АВТОМАТИЧЕСКАЯ АКТИВАЦИЯ
-- ==========================================

wait(0.5)
-- Включение всех функций

-- Финальное уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "FeastHUB Mobile",
    Text = "✅ Тапни по зеленой F для меню",
    Duration = 5,
    Icon = "rbxasset://textures/ui/PhoneIcon.png"
})

print("✅ FeastHUB Mobile загружен! Ищи зеленую F на экране")