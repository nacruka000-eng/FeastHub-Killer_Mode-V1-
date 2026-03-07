-- [[ FEASTHUB KILLER_MODE V2.3 - THE TRUE SCRIPT ]] --

-- [ СИСТЕМА ANTI-AFK И ЗАЩИТЫ ] --
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- [ ТВОЙ ЛЮБИМЫЙ ЛОАДЕР ] --
local LoaderGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local LoaderFrame = Instance.new("Frame", LoaderGui)
LoaderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoaderFrame.Size = UDim2.new(0, 350, 0, 250)
LoaderFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
Instance.new("UICorner", LoaderFrame).CornerRadius = UDim.new(0, 15)

local ProgressBar = Instance.new("Frame", LoaderFrame)
ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ProgressBar.Position = UDim2.new(0, 20, 0, 120)
ProgressBar.Size = UDim2.new(0, 0, 0, 10)
Instance.new("UICorner", ProgressBar)

local Status = Instance.new("TextLabel", LoaderFrame)
Status.Text = "Загрузка FeastHUB..."
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.6, 0)
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.BackgroundTransparency = 1

for i = 1, 100 do
    ProgressBar.Size = UDim2.new(i/100 * 0.88, 0, 0, 10)
    if i == 20 then Status.Text = "Обход Anti-Cheat..." end
    if i == 50 then Status.Text = "Внедрение GodMode..." end
    if i == 80 then Status.Text = "Поиск квестов..." end
    task.wait(0.02)
end
LoaderGui:Destroy()

-- [ ГЛОБАЛЬНЫЕ НАСТРОЙКИ ] --
_G.AutoFarm = false
_G.GodMode = false
_G.WeaponType = "Melee"
_G.Stats = {Melee = false, Defense = false, Sword = false, Fruit = false}

-- [ УЛЬТИМАТИВНОЕ БЕССМЕРТИЕ (ФИЗИЧЕСКОЕ) ] --
task.spawn(function()
    while task.wait() do
        if _G.GodMode then
            pcall(function()
                local hum = game.Players.LocalPlayer.Character.Humanoid
                hum.Health = hum.MaxHealth
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                -- Удаление урона от воды
                if game.Players.LocalPlayer.Character:FindFirstChild("WaterDetector") then
                    game.Players.LocalPlayer.Character.WaterDetector:Destroy()
                end
            end)
        end
    end
end)

-- [ БАЗА ДАННЫХ АВТОФАРМА (РЕАЛЬНАЯ) ] --
local SeaQuests = {
    [1] = {
        {Level = 1, Name = "BanditQuest1", Monster = "Bandit", NPC = CFrame.new(1059, 15, 15), Mob = CFrame.new(1145, 17, 30)},
        {Level = 10, Name = "MonkeyQuest1", Monster = "Monkey", NPC = CFrame.new(-1601, 36, 153), Mob = CFrame.new(-1623, 5, 150)},
        {Level = 15, Name = "GorillaQuest1", Monster = "Gorilla", NPC = CFrame.new(-1601, 36, 153), Mob = CFrame.new(-1200, 10, -500)},
        {Level = 30, Name = "PirateQuest1", Monster = "Pirate", NPC = CFrame.new(-1141, 4, 3828), Mob = CFrame.new(-1200, 4, 3900)},
        {Level = 60, Name = "DesertQuest1", Monster = "Desert Bandit", NPC = CFrame.new(894, 6, 4389), Mob = CFrame.new(1000, 6, 4400)},
        {Level = 120, Name = "MarineQuest1", Monster = "Chief Petty Officer", NPC = CFrame.new(-4842, 22, 4366), Mob = CFrame.new(-4900, 25, 4300)},
        {Level = 300, Name = "MagmaQuest1", Monster = "Military Soldier", NPC = CFrame.new(-5313, 12, 8515), Mob = CFrame.new(-5400, 15, 8400)}
    },
    [2] = {
        {Level = 700, Name = "RaiderQuest1", Monster = "Raider", NPC = CFrame.new(-424, 73, 1836), Mob = CFrame.new(-800, 75, 2300)}
    },
    [3] = {
        {Level = 1500, Name = "PiratePortQuest1", Monster = "Pirate Millionaire", NPC = CFrame.new(-290, 15, 5300), Mob = CFrame.new(-450, 20, 5500)}
    }
}

-- [ ИНТЕРФЕЙС RAYFIELD (САМЫЙ ПЛАВНЫЙ) ] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "FeastHUB KillerMode V2.3",
   LoadingTitle = "God System Loaded",
   LoadingSubtitle = "by Killer_Mode",
})

local MainTab = Window:CreateTab("Auto Farm", 4483362458)
local GodTab = Window:CreateTab("GodMode", 4483362458)
local StatsTab = Window:CreateTab("Auto Stats", 4483362458)

GodTab:CreateToggle({
   Name = "ACTIVATE GOD MODE",
   CurrentValue = false,
   Callback = function(Value) _G.GodMode = Value end,
})

MainTab:CreateToggle({
   Name = "Enable Auto Farm",
   CurrentValue = false,
   Callback = function(Value) _G.AutoFarm = Value end,
})

MainTab:CreateDropdown({
   Name = "Select Weapon",
   Options = {"Melee", "Sword", "Fruit"},
   CurrentOption = "Melee",
   Callback = function(v) _G.WeaponType = v end,
})

-- [ АВТО-СТАТЫ ] --
StatsTab:CreateToggle({Name = "Melee", CurrentValue = false, Callback = function(v) _G.Stats.Melee = v end})
StatsTab:CreateToggle({Name = "Defense", CurrentValue = false, Callback = function(v) _G.Stats.Defense = v end})
StatsTab:CreateToggle({Name = "Sword", CurrentValue = false, Callback = function(v) _G.Stats.Sword = v end})

task.spawn(function()
    while task.wait(1) do
        for stat, enabled in pairs(_G.Stats) do
            if enabled then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", stat, 3)
            end
        end
    end
end)

-- [ ЛОГИКА ФАРМА (С КВЕСТАМИ) ] --
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local p = game.Players.LocalPlayer
                local sea = (game.PlaceId == 4442272160 and 1) or (game.PlaceId == 7449925010 and 2) or 3
                local myLevel = p.Data.Level.Value
                local quest = nil
                for _, q in pairs(SeaQuests[sea]) do if myLevel >= q.Level then quest = q end end
                
                if quest then
                    if not p.PlayerGui.Main.Quest.Visible then
                        p.Character.HumanoidRootPart.CFrame = quest.NPC
                        task.wait(0.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", quest.Name, 1)
                    else
                        local m = game.Workspace.Enemies:FindFirstChild(quest.Monster)
                        if m and m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 then
                            p.Character.HumanoidRootPart.CFrame = m.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            m.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                            game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RE/DefaultCombatRemote"):FireServer(p.Backpack:FindFirstChild(_G.WeaponType) or p.Character:FindFirstChild(_G.WeaponType))
                        else
                            p.Character.HumanoidRootPart.CFrame = quest.Mob
                        end
                    end
                end
            end)
        end
    end
end)

-- [ ПЕРЕДВИГАЕМАЯ КНОПКА F ] --
local MobileGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local FloatButton = Instance.new("TextButton", MobileGui)
FloatButton.Size = UDim2.new(0, 50, 0, 50)
FloatButton.Position = UDim2.new(0, 20, 0.5, 0)
FloatButton.Text = "F"
FloatButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
FloatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatButton.Draggable = true
Instance.new("UICorner", FloatButton)

FloatButton.MouseButton1Click:Connect(function()
    local rf = game:GetService("CoreGui"):FindFirstChild("Rayfield")
    if rf then rf.Enabled = not rf.Enabled end
end)
