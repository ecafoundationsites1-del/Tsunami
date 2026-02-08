-- [[ BRAINROT V13 FINAL: 길 가이드 + Hitbox 삭제 + 절대 불멸 ]] --

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

-- [UI 디자인]
MainFrame.Size = UDim2.new(0, 230, 0, 350)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Active = true
MainFrame.Draggable = true
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 255, 100)
UIStroke.Thickness = 3
Instance.new("UICorner", MainFrame)

local function CreateButton(name, yPos, color, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 200, 0, 45)
    btn.Position = UDim2.new(0.5, -100, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.MouseButton1Click:Connect(callback)
    Instance.new("UICorner", btn)
end

-- 1. [절대 불멸 + Hitbox 즉시 삭제]
CreateButton("ERASE HITBOX & GOD", 65, Color3.fromRGB(200, 0, 50), function()
    local function UltraImmortal(char)
        local hum = char:WaitForChild("Humanoid")
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        runService.Stepped:Connect(function()
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find("hitbox") then
                    v:Destroy()
                end
            end
        end)
    end
    if player.Character then UltraImmortal(player.Character) end
    player.CharacterAdded:Connect(UltraImmortal)
end)

-- 2. [맵 정리 및 중앙 길 가이드]
-- 앞이 안 보이는 문제를 해결하기 위해 중앙 도로만 색을 칠합니다.
CreateButton("FIX VIEW & HIGHWAY", 125, Color3.fromRGB(0, 150, 100), function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local n = v.Name:lower()
            -- 중앙 바닥 판별
            if n:find("floor") or v.Position.Y < (player.Character.HumanoidRootPart.Position.Y - 1) then
                v.CanTouch = false
                v.Size = Vector3.new(v.Size.X, v.Size.Y, 500000) -- 길이는 무한
                -- [수정] 중앙 길은 진한 검정색, 옆 확장 구역은 투명하게 하여 앞이 보이게 함
                if math.abs(v.Position.X) < 50 then
                    v.Color = Color3.fromRGB(30, 30, 30) -- 중앙 고속도로 (보임)
                    v.Transparency = 0
                else
                    v.Transparency = 0.8 -- 옆 공간 (멀리 보임)
                end
            -- VIP 옆벽 및 정신 사나운 벽들만 골라서 삭제
            elseif v.Size.Y > 2 and (n:find("wall") or n:find("vip") or n:find("border")) then
                v:Destroy()
            end
        end
    end
    print("중앙 통로 가이드가 생성되었습니다. 이제 앞이 보일 거예요!")
end)

-- 3. [쓰나미 79% 투명화]
CreateButton("GHOST TSUNAMI (79%)", 185, Color3.fromRGB(100, 0, 200), function()
    task.spawn(function()
        while true do
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name:lower():find("tsunami") or v.Name:lower():find("wave") then
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
end)

CreateButton("CLOSE MENU", 260, Color3.fromRGB(50, 50, 50), function() ScreenGui:Destroy() end)

