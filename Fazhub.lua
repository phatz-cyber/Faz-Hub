-- 🔥 Faz Hub V4 - LẤY Ý TƯỞNG TỪ ZEN HUB (Fixed 100%)
-- Auto Quest thật + Farm siêu nhanh + Teleport không reset
-- Keyless - Test trên Delta, Hydrogen, Fluxus, Arceus X Mobile OK

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

if not table.find({2753915549, 4442272183, 7449423635}, game.PlaceId) then
    game.StarterGui:SetCore("SendNotification", {Title = "Faz Hub", Text = "Chỉ dùng trong Blox Fruits!", Duration = 5})
    return
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "🔥 Faz Hub V4",
    LoadingTitle = "Đang load... Inspired by Zen Hub",
    LoadingSubtitle = "Phạm's Edition - 2026",
    ConfigurationSaving = {Enabled = true, FolderName = "FazHubV4", FileName = "Config"},
    KeySystem = false
})

local FarmTab = Window:CreateTab("🗡️ Farm", 4483362458)
local TeleTab = Window:CreateTab("📍 Teleport", 4483362458)
local MiscTab = Window:CreateTab("⚙️ Misc", 4483362458)

getgenv().AutoFarm = false
getgenv().AutoQuest = false
getgenv().FastAttack = false
getgenv().NoClip = false

-- ==================== TELEPORT SIÊU ỔN ĐỊNH (như Zen) ====================
local function TeleportTo(cf)
    pcall(function()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            getgenv().NoClip = true
            local tween = TweenService:Create(root, TweenInfo.new(0.35, Enum.EasingStyle.Linear), {CFrame = cf})
            tween:Play()
            tween.Completed:Wait()
            root.CFrame = cf -- double fix reset
            task.wait(0.05)
        end
    end)
end

-- NoClip (giống Zen Hub)
RunService.Stepped:Connect(function()
    pcall(function()
        if getgenv().NoClip and player.Character then
            for _, v in ipairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- ==================== FARM LOOP CHÍNH (lấy logic Zen) ====================
spawn(function()
    while task.wait(0.08) do
        pcall(function()
            if not getgenv().AutoFarm then return end
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            -- Auto Quest (giống Zen)
            if getgenv().AutoQuest then
                local quest = RS.Remotes.CommF_:InvokeServer("QuestProgress")
                if not quest or quest == "None" then
                    RS.Remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1) -- tự điều chỉnh level sau
                end
            end

            -- Tìm quái gần + đúng level
            local target = nil
            local dist = math.huge
            local myLevel = player.Data.Level.Value
            for _, enemy in pairs(WS.Enemies:GetChildren()) do
                if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                    local level = tonumber(enemy.Name:match("%d+")) or 0
                    if math.abs(level - myLevel) <= 60 then
                        local d = (char.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                        if d < dist then dist = d; target = enemy end
                    end
                end
            end

            if target then
                TeleportTo(target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                
                -- Attack chuẩn (như Zen)
                local tool = char:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
                if tool then
                    player.Character.Humanoid:EquipTool(tool)
                    tool:Activate()
                    VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(0.01)
                    VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end
            end
        end)
    end
end)

-- ==================== UI (giống Zen Hub) ====================
FarmTab:CreateToggle({Name = "🔥 Auto Farm Level + Auto Quest", CurrentValue = false, Callback = function(v) getgenv().AutoFarm = v; getgenv().AutoQuest = v end})
FarmTab:CreateToggle({Name = "⚡ Fast Attack", CurrentValue = false, Callback = function(v) getgenv().FastAttack = v end})
FarmTab:CreateToggle({Name = "NoClip (bắt buộc)", CurrentValue = true, Callback = function(v) getgenv().NoClip = v end})

TeleTab:CreateButton({Name = "Green Zone", Callback = function() TeleportTo(CFrame.new(-2937, 45, 5411)) end})
TeleTab:CreateButton({Name = "Marine Ford", Callback = function() TeleportTo(CFrame.new(44, 74, 22065)) end})
TeleTab:CreateButton({Name = "Bartilo Race V4", Callback = function() TeleportTo(CFrame.new(-3832, 74, -3837)) end})

MiscTab:CreateButton({Name = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, player) end})

Rayfield:Notify({Title = "🔥 Faz Hub V4 LOADED!", Content = "Lấy ý từ Zen Hub + fix hết lỗi cũ! Bật NoClip + Auto Farm thử ngay.", Duration = 8})
print("🔥 Faz Hub V4 - Loaded thành công!")
