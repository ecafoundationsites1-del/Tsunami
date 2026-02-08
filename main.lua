-- [[ BRAINROT V7: ALL-IN-ONE UI ]] --

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

-- [1. UI 기본 설정]
MainFrame.Name = "BrainrotMenu"
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(170, 0, 255)
UIStroke.Thickness = 3

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "BRAINROT V7"
Title.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- [버튼 생성 함수]
local function CreateButton(name, yPos, color, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Name = name
    btn.Size = UDim2.new(0, 190, 0, 45)
    btn.Position = UDim2.new(0.5, -95, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- [2. 기능 구현]

-- 버튼 1: 갓모드 & 넘어짐 방지 (사진 속 눕는 문제 해결)
CreateButton("ACTIVATE GODMODE", 60, Color3.fromRGB(60, 60, 60), function()
    local function God(char)
        local hum = char:WaitForChild("Humanoid")
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) -- 눕는 거 방지
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        
        runService.Heartbeat:Connect(function()
            hum.Health = math.huge
            if hum.MoveDirection.Magnitude > 0 then
                char.HumanoidRootPart.Velocity = hum.MoveDirection * hum.WalkSpeed + Vector3.new(0, char.HumanoidRootPart.Velocity.Y, 0)
            end
        end)
    end
    God(player.Character)
    player.CharacterAdded:Connect(God)
    print("갓모드 및 넘어짐 방지 활성화!")
end)

-- 버튼 2: 맵 개조 (무한 바닥 + 일자 벽 제거)
CreateButton("FIX MAP & HIGHWAY", 120, Color3.fromRGB(0, 150, 100), function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local n = v.Name:lower()
            -- 바닥 확장
            if n:find("floor") or n:find("ground") or v.Position.Y < (player.Character.HumanoidRootPart.Position.Y - 1) then
                v.Size = Vector3.new(v.Size.X, v.Size.Y, 200000)
                v.CanTouch = false -- 데미지 무시
                v.Color = Color3.fromRGB(0, 255, 120)
            -- 옆벽 및 VIP 벽 제거
            elseif v.Size.Y > 2 and (n:find("wall") or n:find("vip") or n:find("border") or n:find("gate")) then
                v:Destroy()
            end
        end
    end
end)

-- 버튼 3: 쓰나미 영구 제거
CreateButton("DELETE TSUNAMI", 180, Color3.fromRGB(0, 100, 200), function()
    _G.AntiTsunami = true
    task.spawn(function()
        while _G.AntiTsunami do
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name:lower():find("tsunami") or v.Name:lower():find("wave") then
                    v:Destroy()
                end
            end
            task.wait(0.2)
        end
    end)
end)

-- 버튼 4: UI 닫기
CreateButton("CLOSE MENU", 250, Color3.fromRGB(40, 40, 40), function()
    ScreenGui:Destroy()
end)
