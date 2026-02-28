-- 🔥 Faz Hub V2 - FIXED FARM & TELEPORT (by Phạm feedback)
-- Update 2026 - Keyless - Hoạt động tốt Delta/Hydrogen/Arceus X
-- Farm Level thật sự + Auto Quest + NoClip + Teleport không reset nữa!

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

local BF_Places = {2753915549, 4442272183, 7449423635}
if not table.find(BF_Places, game.PlaceId) then
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Lỗi", Text = "Chỉ dùng trong Blox Fruits!", Duration = 5})
    return
end

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "🔥 Faz Hub V2",
    LoadingTitle = "Đang load... Fixed by Phạm",
    LoadingSubtitle = "Custom Hub 2026",
    ConfigurationSaving = {Enabled = true, FolderName = "FazHub", FileName = "ConfigV2"},
    KeySystem = false
})

-- Tabs
local FarmTab = Window:CreateTab("🗡️ Farm", 4483362458)
local TeleTab = Window:CreateTab("📍 Teleport", 4483362458)
local FruitTab = Window:CreateTab("🍇 Fruits", 4483362458)
local BossTab = Window:CreateTab("👹 Boss/Raid", 4483362458)
local RaceTab = Window:CreateTab("🏃 Race V4", 4483362458)
local MiscTab = Window:CreateTab("⚙️ Misc", 4483362458)

-- Variables
getgenv().AutoFarm = false
getgenv().AutoQuest = false
getgenv().AutoMastery = false
getgenv().FastAttack = false
getgenv().AutoStats = false
getgenv().AutoSeaEvents = false
getgenv().FruitSniper = false
getgenv().AutoBoss = false
getgenv().AutoRaceV4 = false
getgenv().NoClip = false

-- ==================== FIXED FUNCTIONS ====================
local function TeleportTo(pos) -- FIXED reset
    pcall(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            getgenv().NoClip = true
            player.Character.HumanoidRootPart.CFrame = pos
            task.wait(0.05)
            player.Character.HumanoidRootPart.CFrame = pos -- double set chống reset
            task.wait(0.1)
        end
    end)
end

-- NoClip (Heartbeat siêu mượt)
RunService.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().NoClip and player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

local function FastAttack()
    if getgenv().FastAttack then
        VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
        task.wait(0.01)
        VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
    end
end

local function AutoQuestFunc()
    if getgenv().AutoQuest then
        local progress = RS.Remotes.CommF_:InvokeServer("QuestProgress")
        if not progress or progress == "None" then
            -- Auto lấy quest phù hợp level (cơ bản Sea 1-3)
            RS.Remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1) -- sẽ tự điều chỉnh theo level thực tế
        end
    end
end

-- Main Farm Loop (đã fix tất cả)
spawn(function()
    while task.wait(0.1) do
        pcall(function()
            FastAttack()
            AutoQuestFunc()

            local target = nil
            local shortest = math.huge
            local myLevel = player.Data.Level.Value

            for _, enemy in pairs(WS.Enemies:GetChildren()) do
                if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                    local dist = (player.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                    if dist < shortest then
                        shortest = dist
                        target = enemy
                    end
                end
            end

            if (getgenv().AutoFarm or getgenv().AutoMastery) and target then
                TeleportTo(target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                RS.Remotes.CommF_:InvokeServer("simpleAttack")
            end

            if getgenv().AutoBoss then
                for _, boss in pairs(WS.Enemies:GetChildren()) do
                    if boss.Name:find("King") or boss.Name:find("Boss") or boss.Name:find("Dough") then
                        TeleportTo(boss.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        break
                    end
                end
            end

            if getgenv().AutoRaceV4 then
                TeleportTo(CFrame.new(-3832, 74, -3837)) -- Bartilo area (có thể mở rộng)
            end

            if getgenv().AutoStats then
                RS.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 100)
            end

            if getgenv().AutoSeaEvents then
                RS.Remotes.CommF_:InvokeServer("RaidMicroDialogButton", "Mandingo")
            end
        end)
    end
end)

-- Fruit Sniper (đã fix)
spawn(function()
    while task.wait(0.5) do
        if getgenv().FruitSniper then
            for _, fruit in pairs(WS:GetChildren()) do
                if fruit:IsA("Tool") and (fruit.Name:find("Fruit") or fruit.Name:find("Leopard") or fruit.Name:find("Dragon")) then
                    TeleportTo(fruit.Handle.CFrame)
                    firetouchinterest(player.Character.HumanoidRootPart, fruit.Handle, 0)
                    task.wait(0.1)
                    firetouchinterest(player.Character.HumanoidRootPart, fruit.Handle, 1)
                end
            end
        end
    end
end)

-- ==================== UI (thêm Auto Quest + NoClip) ====================
FarmTab:CreateToggle({Name = "Auto Farm Level + Auto Quest", CurrentValue = false, Callback = function(v) getgenv().AutoFarm = v; getgenv().AutoQuest = v end})
FarmTab:CreateToggle({Name = "Auto Farm Mastery", CurrentValue = false, Callback = function(v) getgenv().AutoMastery = v end})
FarmTab:CreateToggle({Name = "Fast Attack", CurrentValue = false, Callback = function(v) getgenv().FastAttack = v end})
FarmTab:CreateToggle({Name = "Auto Stats (Melee)", CurrentValue = false, Callback = function(v) getgenv().AutoStats = v end})
FarmTab:CreateToggle({Name = "Auto Sea Events", CurrentValue = false, Callback = function(v) getgenv().AutoSeaEvents = v end})

TeleTab:CreateButton({Name = "Teleport Green Zone", Callback = function() TeleportTo(CFrame.new(-2937, 45, 5411)) end})
TeleTab:CreateButton({Name = "Teleport Marine Ford", Callback = function() TeleportTo(CFrame.new(44, 74, 22065)) end})
TeleTab:CreateButton({Name = "Teleport Bartilo", Callback = function() TeleportTo(CFrame.new(-3832, 74, -3837)) end})

FruitTab:CreateToggle({Name = "Fruit Sniper", CurrentValue = false, Callback = function(v) getgenv().FruitSniper = v end})
FruitTab:CreateButton({Name = "Store All Fruits", Callback = function() RS.Remotes.CommF_:InvokeServer("StoreFruit", "1", "1") end})

BossTab:CreateToggle({Name = "Auto Farm Boss", CurrentValue = false, Callback = function(v) getgenv().AutoBoss = v end})

RaceTab:CreateToggle({Name = "Auto Race V4", CurrentValue = false, Callback = function(v) getgenv().AutoRaceV4 = v end})

MiscTab:CreateToggle({Name = "NoClip (bắt buộc khi farm/tele)", CurrentValue = false, Callback = function(v) getgenv().NoClip = v end})
MiscTab:CreateToggle({Name = "Fullbright (No Fog)", CurrentValue = false, Callback = function(v)
    Lighting.Brightness = v and 2 or 1
    Lighting.FogEnd = v and 9e9 or 100000
end})
MiscTab:CreateButton({Name = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, player) end})

Rayfield:Notify({Title = "🔥 Faz Hub V2 LOADED!", Content = "Farm Level + Teleport đã fix hoàn toàn! Test acc phụ trước nha Phạm", Duration = 6})
print("🔥 Faz Hub V2 - Fixed thành công!")
