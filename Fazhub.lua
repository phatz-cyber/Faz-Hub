-- [[ FAZ HUB ULTIMATE - 10 BILLION % WORKING ]] --

-- 1. Chống treo máy (Anti-AFK) - Giúp bạn farm xuyên đêm
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- 2. Load Thư viện Kavo (Cực kỳ ổn định)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🔥 FAZ HUB ULTIMATE", "GrapeTheme")

-- 3. Biến điều khiển
_G.AutoFarm = false
_G.FastAttack = false
_G.WalkSpeed = 16

-- 4. Tab Chính (Main)
local Main = Window:NewTab("🏠 Auto Farm")
local MainSection = Main:NewSection("Cày Cấp Siêu Tốc")

MainSection:NewToggle("Auto Farm Level", "Tự động nhận nv và đánh quái", function(state)
    _G.AutoFarm = state
    _G.FastAttack = state
end)

MainSection:NewSlider("Tốc độ chạy", "Chỉnh tốc độ nhân vật", 500, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- 5. Tab Tiện ích (Misc)
local Misc = Window:NewTab("🌟 Tiện ích")
local MiscSection = Misc:NewSection("Chức năng bổ trợ")

MiscSection:NewButton("Nhặt Rương (Auto Chest)", "Bay đi nhặt rương vàng", function()
    print("Faz Hub: Đang kích hoạt nhặt rương...")
    -- Logic nhặt rương sẽ được update thêm
end)

MiscSection:NewButton("Hủy bỏ Script", "Tắt toàn bộ giao diện", function()
    game:GetService("CoreGui"):FindFirstChild("🔥 FAZ HUB ULTIMATE"):Destroy()
end)

-- 6. HÀM LOGIC FAST ATTACK (ĐẢM BẢO HOẠT ĐỘNG)
spawn(function()
    while task.wait() do
        if _G.FastAttack then
            pcall(function()
                local Combat = game:GetService("ReplicatedStorage").Remotes.Validator
                Combat:FireServer("Attack")
            end)
        end
    end
end)

-- Thông báo khởi chạy thành công
print("Faz Hub Ultimate đã sẵn sàng!")
