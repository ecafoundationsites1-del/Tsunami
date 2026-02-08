-- [[ UI 및 기능 통합 스크립트 ]] --

local Library = {} -- 간단한 UI 라이브러리 구조
local player = game.Players.LocalPlayer
local sgui = Instance.new("ScreenGui", game.CoreGui)
sgui.Name = "BrainrotUI"

-- 메인 프레임 생성
local main = Instance.new("Frame", sgui)
main.Size = UDim2.new(0, 220, 0, 280)
main.Position = UDim2.new(0.5, -110, 0.5, -140)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- 테두리 효과 (UIStroke)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(170, 0, 255)
stroke.Thickness = 2

-- 제목
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
title.Text = "BRAINROT V1 (April Fools)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold

-- 공통 버튼 생성 함수
local function CreateButton(name, pos, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0, 180, 0, 40)
    btn.Position = UDim2.new(0.5, -90, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    
    -- 버튼 둥글게
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

--- [[ 기능 구현 ]] ---

-- 1. 갓모드 & 무한 점프
CreateButton("GOD MODE & SPEED", 60, function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.MaxHealth = math.huge
        char.Humanoid.Health = math.huge
        char.Humanoid.WalkSpeed = 60
        char.Humanoid.JumpPower = 100
        
        char.Humanoid.HealthChanged:Connect(function()
            char.Humanoid.Health = math.huge
        end)
    end
    print("신이 되었습니다.")
end)

-- 2. 벽 삭제 & 맵 확장
CreateButton("DESTROY WALLS & EXPAND", 115, function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            -- 벽/경계 삭제
            if obj.Name:lower():find("wall") or obj.Name:lower():find("border") or obj.Name:lower():find("invisible") then
                obj:Destroy()
            -- 바닥 무한 확장
            elseif obj.Name:lower():find("floor") or obj.Name:lower():find("ground") then
                obj.Size = Vector3.new(20000, 5, 20000)
                obj.Transparency = 0.5
                obj.Color = Color3.fromRGB(math.random(0,255), 0, 255)
            end
        end
    end
end)

-- 3. 쓰나미 제거 루프 (Toggle)
local tsunamiActive = false
local tsunamiBtn = CreateButton("STOP TSUNAMI: OFF", 170, function()
    tsunamiActive = not tsunamiActive
    if tsunamiActive then
        _G.TsunamiLoop = true
        task.spawn(function()
            while _G.TsunamiLoop do
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:lower():find("tsunami") or v.Name:lower():find("wave") or v.Name:lower():find("water") then
                        v:Destroy()
                    end
                end
                task.wait(0.5)
            end
        end)
        script.Parent.Text = "STOP TSUNAMI: ON"
    else
        _G.TsunamiLoop = false
        script.Parent.Text = "STOP TSUNAMI: OFF"
    end
end)

-- 4. 닫기 버튼
CreateButton("CLOSE MENU", 225, function()
    sgui:Destroy()
end)
