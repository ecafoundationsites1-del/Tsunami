-- [[ BRAINROT V12 FINAL: Hitbox 삭제 + VIP 옆 청소 + 절대 불멸 ]] --

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

-- [UI 디자인 - 네온 퍼플 테마]
MainFrame.Name = "BrainrotV12"
MainFrame.Size = UDim2.new(0, 230, 0, 350)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.Active = true
MainFrame.Draggable = true

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255, 0, 255)
UIStroke.Thickness = 3

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "BRAINROT V12 FINAL"
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Instance.new("UICorner", Title)

-- [버튼 생성 함수]
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

-- [[ 1. ERASE HITBOX & ABSOLUTE IMMORTAL ]] --
-- Hitbox를 삭제하고 기존 갓모드 로직을 합쳐 완벽한 무적을 만듭니다.
CreateButton("ERASE HITBOX & GOD", 65, Color3.fromRGB(255, 0, 100), function()
    local function UltraImmortal(char)
        local hum = char:WaitForChild("Humanoid")
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        
        -- 매 프레임마다 초고속으로 Hitbox 삭제 및 체력 고정
        runService.Stepped:Connect(function()
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            
            -- 데미지 판정인 Hitbox를 찾는 즉시 제거
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find("hitbox") then
                    v:Destroy()
                end
            end
        end)
    end
    if player.Character then UltraImmortal(player.Character) end
    player.CharacterAdded:Connect(UltraImmortal)
    print("Hitbox가 제거되었으며 절대 불멸 상태입니다.")
end)

-- [[ 2. CLEAR VIP SIDE & EXPAND FLOOR ]] --
-- VIP 왼쪽과 옆 공간을 밀어버려 쓰나미 옆에 여유 공간을 만듭니다.
CreateButton("CLEAR VIP SIDE (CLEAN)", 125, Color3.fromRGB(0, 120, 255), function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local n = v.Name:lower()
            -- 바닥을 제외한 옆벽, VIP 구조물, 경계선 모두 삭제
            if not n:find("floor") and not n:find("base") then
                if n:find("vip") or n:find("wall") or n:find("border") or n:find("gate") then
                    v:Destroy()
                end
            end
            -- 바닥은 무한 고속도로로 확장
            if n:find("floor") or v.Position.Y < (player.Character.HumanoidRootPart.Position.Y - 1) then
                v.Size = Vector3.new(5000, v.Size.Y, 500000)
                v.CanTouch = false -- 바닥 데미지 무시
                v.Color = Color3.fromRGB(30, 30, 30) -- 정신 사납지 않게 어두운 색으로
            end
        end
    end
    print("VIP 구역 옆 공간 대청소 완료!")
end)

-- [[ 3. GHOST TSUNAMI (79% VISIBLE) ]] --
-- 쓰나미 모델을 삭제하는 대신 79% 투명하게 만들어 통과하게 합니다.
CreateButton("GHOST TSUNAMI (79%)", 185, Color3.fromRGB(150, 0, 255), function()
    task.spawn(function()
        while true do
            for _, v in pairs(workspace:GetDescendants()) do
                local n = v.Name:lower()
                if n:find("tsunami") or n:find("wave") then
                    if v:IsA("BasePart") then
                        v.CanTouch = false
                        v.CanCollide = false
                        v.Transparency = 0.79
                    end
                end
            end
            task.wait(0.5)
        end
    end)
    print("쓰나미가 79% 투명해졌으며 통과 가능합니다.")
end)

-- [[ 4. CLOSE UI ]] --
CreateButton("CLOSE MENU", 255, Color3.fromRGB(40, 40, 40), function()
    ScreenGui:Destroy()
end)

