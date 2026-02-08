-- [[ BRAINROT V1 통합 수정본 ]] --

local player = game.Players.LocalPlayer
local sgui = Instance.new("ScreenGui", game.CoreGui)
sgui.Name = "BrainrotUI_Fixed"

-- 메인 프레임
local main = Instance.new("Frame", sgui)
main.Size = UDim2.new(0, 220, 0, 300)
main.Position = UDim2.new(0.5, -110, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(170, 0, 255)
stroke.Thickness = 2

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
title.Text = "BRAINROT V1 (FIXED)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- 공통 버튼 함수
local function CreateButton(name, pos, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0, 190, 0, 45)
    btn.Position = UDim2.new(0.5, -95, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

--- [[ 기능 구현 ]] ---

-- 1. 갓모드 & 스피드 (상태 비활성화 방식 추가)
CreateButton("GOD MODE & SPEED", 55, function(self)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        
        -- 죽음 상태 방지 (클라이언트 측 최선책)
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum.WalkSpeed = 80
        hum.JumpPower = 120
        
        -- 체력이 깎일 때 즉시 회복 루프
        task.spawn(function()
            while task.wait() do
                if hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end
        end)
        
        self.Text = "GOD MODE: ACTIVE"
        self.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)

-- 2. 맵 개조 (벽 삭제 및 바닥 확장)
CreateButton("EXPAND MAP & NO WALLS", 110, function(self)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            -- 벽 및 투명벽 제거
            if obj.Name:lower():find("wall") or obj.Name:lower():find("border") or obj.Name:lower():find("invisible") then
                obj:Destroy()
            -- 바닥 무한 확장 및 색상 변경
            elseif obj.Name:lower():find("floor") or obj.Name:lower():find("ground") then
                obj.Size = Vector3.new(10000, 10, 10000)
                obj.Color = Color3.fromRGB(math.random(100,255), 0, 255)
            end
        end
    end
    self.Text = "MAP MODDED"
end)

-- 3. 쓰나미 제거 루프 (토글 방식 수정)
_G.TsunamiLoop = false
CreateButton("ANTI-TSUNAMI: OFF", 165, function(self)
    _G.TsunamiLoop = not _G.TsunamiLoop
    
    if _G.TsunamiLoop then
        self.Text = "ANTI-TSUNAMI: ON"
        self.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        task.spawn(function()
            while _G.TsunamiLoop do
                for _, v in pairs(workspace:GetChildren()) do
                    -- 쓰나미, 파도, 물 등 위험 요소 감지 시 삭제
                    if v.Name:lower():find("tsunami") or v.Name:lower():find("wave") or v.Name:lower():find("water") then
                        v:Destroy()
                    end
                end
                task.wait(0.1) -- 감지 속도 향상
            end
        end)
    else
        self.Text = "ANTI-TSUNAMI: OFF"
        self.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

-- 4. 닫기 버튼
CreateButton("CLOSE MENU", 240, function()
    _G.TsunamiLoop = false
    sgui:Destroy()
end)

