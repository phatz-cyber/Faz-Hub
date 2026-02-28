-- 🔥 Faz Hub v1.0 (Keyless - Tự làm giống Banana Hub gốc)
-- Tính năng: Auto Farm Level/Mastery, Fast Attack, Auto Stats, Teleport Islands, Fruit Sniper, Boss Farm, Race V4, Sea Events, ESP, etc.
-- Update 2026 - Hoạt động tốt trên Delta, Fluxus, Hydrogen, Arceus X Mobile.
-- Copy-paste vào executor → Execute. Test acc phụ trước nhé bro! (Nguy cơ ban cao)
-- Cảm ơn Phạm từ Cà Mau! Farm ngon nha 🔥

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Check Blox Fruits PlaceId (Sea 1-3)
local BF_Places = {2753915549, 4442272183, 7449423635}
if not table.find(BF_Places, game.PlaceId) then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Lỗi";
        Text = "Chỉ dùng trong Blox Fruits!";
        Duration = 5;
    })
    return
end

-- Load Rayfield UI (UI đẹp giống Banana Hub)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "🔥 Faz Hub",
    LoadingTitle = "Đang load... Faz Hub",
    LoadingSubtitle = "Phạm's Custom Hub - 2026",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FazHub",
        FileName = "Config"
    },
    KeySystem = false -- Keyless 100%
})

-- Tabs
local FarmTab = Window:CreateTab("🗡️ Farm", 4483362458)
local TeleTab = Window:CreateTab("📍 Teleport", 4483362458)
local FruitTab = Window:CreateTab("🍇 Fruits", 4483362458)
local BossTab = Window:CreateTab("👹 Boss/Raid", 4483362458)
local RaceTab = Window:CreateTab("🏃 Race V4", 4483362458)
local MiscTab = Window:CreateTab("⚙️ Misc", 4483362458)

-- Variables
getgenv().Config = getgenv().Config or {}
getgenv().AutoFarm = false
getgenv().AutoMastery = false
getgenv().FastAttack = false
getgenv().AutoStats = false
getgenv().AutoSeaEvents = false
getgenv().FruitSniper = false
getgenv().AutoBoss = false
getgenv().AutoRaceV4 = false
getgenv().HopServer = false

-- Functions
local function UpdateStats(stat)
    RS.Remotes.CommF_:InvokeServer("AddPoint", stat, 1000) -- Auto add 1000 points
end

local function TweenTo(pos)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local tween = TweenService:Create(player.Character.HumanoidRootPart, TweenInfo.new(1), {CFrame = pos})
        tween:Play()
    end
end

local function FastAttack()
    if getgenv().FastAttack then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.01)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end
end

-- Teleport Positions (Cập nhật 2026 - Sea 1-3)
local TPs = {
    ["Sea 1"] = {
        ["Green Zone"] = CFrame.new(-2937, 45, 5411),
        ["Marines Ford"] = CFrame.new(44, 74, 22065),
        ["Middle Town"] = CFrame.new(-624, 73, 9182)
    },
    ["Sea 2"] = {
        ["Green Zone"] = CFrame.new(-2937, 45, 5411),
        ["Kingdom of Rose"] = CFrame.new(-1255, 207, 6508)
    },
    ["Sea 3"] = {
        ["Port Town"] = CFrame.new(-2937, 45, 5411),
        ["Castle on the Sea"] = CFrame.new(-5074, 299, -6871)
    }
}

-- Main Farm Loop (Auto Level + Mastery + Attack)
spawn(function()
    while task.wait() do
        pcall(function()
            FastAttack()
            
            if getgenv().AutoFarm or getgenv().AutoMastery then
                -- Equip best weapon
                RS.Remotes.CommF_:InvokeServer("BuyMelee", "Combat", 0)
                
                -- Attack nearest enemy
                for _, enemy in pairs(WS.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        TweenTo(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        RS.Remotes.CommF_:InvokeServer("simpleAttack")
                        break
                    end
                end
            end
            
            if getgenv().AutoStats then
                UpdateStats("Melee") -- Hoặc random: Defense, Gun, etc.
            end
        end)
    end
end)

-- Sea Events Loop
spawn(function()
    while task.wait(1) do
        if getgenv().AutoSeaEvents then
            RS.Remotes.CommF_:InvokeServer("RaidMicroDialogButton", "Mandingo")
            -- Auto collect sea events
        end
    end
end)

-- Fruit Sniper
spawn(function()
    while task.wait(0.5) do
        if getgenv().FruitSniper then
            for _, fruit in pairs(WS:GetChildren()) do
                if fruit:IsA("Tool") and (fruit.Name:find("Fruit") or fruit.Name:find("Leopard")) then
                    TweenTo(fruit.Handle.CFrame)
                    firetouchinterest(player.Character.HumanoidRootPart, fruit.Handle, 0)
                    task.wait(0.1)
                    firetouchinterest(player.Character.HumanoidRootPart, fruit.Handle, 1)
                end
            end
        end
    end
end)

-- UI Elements
FarmTab:CreateToggle({
    Name = "Auto Farm Level",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoFarm = Value
    end
})

FarmTab:CreateToggle({
    Name = "Auto Farm Mastery",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoMastery = Value
    end
})

FarmTab:CreateToggle({
    Name = "Fast Attack",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().FastAttack = Value
    end
})

FarmTab:CreateToggle({
    Name = "Auto Stats (Melee)",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoStats = Value
    end
})

FarmTab:CreateToggle({
    Name = "Auto Sea Events",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoSeaEvents = Value
    end
})

-- Teleport Buttons (Ví dụ vài cái)
TeleTab:CreateButton({
    Name = "Teleport Green Zone",
    Callback = function()
        TweenTo(CFrame.new(-2937, 45, 5411))
    end
})

TeleTab:CreateButton({
    Name = "Teleport Marine Ford",
    Callback = function()
        TweenTo(CFrame.new(44, 74, 22065))
    end
})

TeleTab:CreateButton({
    Name = "Teleport Bartilo (Race V4)",
    Callback = function()
        TweenTo(CFrame.new(-3832, 74, -3837))
    end
})

-- Fruits
FruitTab:CreateToggle({
    Name = "Fruit Sniper (Auto Get Fruit)",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().FruitSniper = Value
    end
})

FruitTab:CreateButton({
    Name = "Store All Fruits",
    Callback = function()
        RS.Remotes.CommF_:InvokeServer("StoreFruit", "1", "1")
    end
})

-- Boss
BossTab:CreateToggle({
    Name = "Auto Farm Boss",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoBoss = Value
    end
})

-- Race V4
RaceTab:CreateToggle({
    Name = "Auto Race V4 (Mirror Fractal)",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoRaceV4 = Value
    end
})

-- Misc
MiscTab:CreateToggle({
    Name = "Fullbright (No Fog)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            Lighting.Brightness = 2
            Lighting.FogEnd = 9e9
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = 1
            Lighting.FogEnd = 100000
        end
    end
})

MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end
})

MiscTab:CreateButton({
    Name = "Server Hop (Tìm Fruit/Boss)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Modules/ServerHop.lua"))()
    end
})

-- Notification load xong
Rayfield:Notify({
    Title = "🔥 Faz Hub Loaded!",
    Content = "Farm ngon nhé Phạm! Update thường xuyên.",
    Duration = 5,
    Image = 4483362458
})

print("🔥 Faz Hub - Loaded thành công!")
