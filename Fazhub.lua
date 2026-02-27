local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "🍎 Faz Hub | Blox Fruits",
   LoadingTitle = "Faz Hub Đang Khởi Chạy...",
   ConfigurationSaving = { Enabled = true, Folder = "FazHubData" }
})

local MainTab = Window:CreateTab("🏠 Main", 4483362458)
MainTab:CreateToggle({
   Name = "Auto Farm Level (Fast)",
   CurrentValue = false,
   Callback = function(Value) _G.AutoFarm = Value end,
})

MainTab:CreateSlider({
   Name = "Tốc độ bay",
   Range = {100, 500},
   Increment = 10,
   CurrentValue = 300,
   Callback = function(Value) _G.FlySpeed = Value end,
})

Rayfield:Notify({Title = "Faz Hub Ready!", Content = "Chúc bạn farm vui vẻ!", Duration = 5})
