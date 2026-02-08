-- [[ BRAINROT V10 FINAL: GHOST EDITION ]] --

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

-- [UI 디자인 설정]
MainFrame.Name = "BrainrotGhostMenu"
MainFrame.Size = UDim2.new(0, 230, 0, 330)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Active = true
MainFrame.Draggable = true

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 3

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "BRAINROT V10 (Ghost)"
Title.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

-- [공통 버튼 생성 함수]
local function CreateButton(name, yPos, color, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 200, 0, 45)
    btn.Position = UDim2.new(0.5, -100, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- [[ 1. ANTI-HITBOX & ETERNAL GOD (투명도 79%) ]] --
CreateButton("ACTIVATE ETERNAL GOD", 65, Color3.fromRGB(0, 120, 150), function()
    local function GodMode(char)
        local hum = char:WaitForChild("Humanoid")
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        
        runService.Stepped:Connect(function()
            hum.MaxHealth = 9e9
            hum.Health = 9e9
            
            -- Hitbox 감지 및 79% 투명화 판정 제거
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find("hitbox") then
                    v.CanTouch = false
                    v.CanCollide = false
                    v.Transparency = 0.79
                end
            end
        end)
    end
    if player.Character then GodMode(player.Character) end
    player.CharacterAdded:Connect(GodMode)
    print("불멸 모드 및 Hitbox 투명화 활성화!")
end)

-- [[ 2. INFINITE HIGHWAY & NO WALLS ]] --
CreateButton("FIX MAP & HIGHWAY", 125, Color3.fromRGB(0, 150, 80), function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local n = v.Name:lower()
            -- 바닥 확장 로직
            if n:find("floor") or v.Position.Y < (player.Character.HumanoidRootPart.Position.Y - 1) then
                v.Size = Vector3.new(v.Size.X, v.Size.Y, 500000)
                v.CanTouch = false
                v.Color = Color3.fromRGB(50, 255, 100)
            -- 옆벽 및 VIP 벽 삭제
            elseif v.Size.Y > 2 and (n:find("wall") or n:find("vip") or n:find("border")) then
                v:Destroy()
            end
        end
    end
    print("맵 개조 완료!")
end)

-- [[ 3. GHOST TSUNAMI (투명도 79%) ]] --
CreateButton("GHOST TSUNAMI (79%)", 185, Color3.fromRGB(120, 0, 200), function()
    task.spawn(function()
        while true do
            for _, v in pairs(workspace:GetDescendants()) do
                local n = v.Name:lower()
                if n:find("tsunami") or n:find("wave") then
                    if v:IsA("BasePart") then
                        v.CanTouch = false
                        v.CanCollide = false
                        v.Transparency = 0.79 -- 요청하신 투명도 설정
                    end
                end
            end
            task.wait(0.5)
        end
    end)
    print("쓰나미 유령 모드 활성화!")
end)

-- [[ 4. UI CLOSE ]] --
CreateButton("CLOSE MENU", 255, Color3.fromRGB(50, 50, 50), function()
    ScreenGui:Destroy()
end)

