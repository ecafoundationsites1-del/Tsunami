-- [[ BRAINROT V16: 데미지 루프 차단 + Hitbox 완전 박멸 + 절대 불멸 ]] --

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

-- [UI 디자인 - 블랙 & 골드 테마]
MainFrame.Size = UDim2.new(0, 230, 0, 350)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
MainFrame.Active = true
MainFrame.Draggable = true
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255, 215, 0) -- 골드 테마
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
    btn.TextSize = 11
    btn.MouseButton1Click:Connect(callback)
    Instance.new("UICorner", btn)
end

-- 1. [데미지 루프 브레이커 + 절대 불멸]
-- 피가 계속 닳는 현상을 막기 위해 캐릭터 내부의 모든 데미지 태그를 삭제합니다.
CreateButton("STOP DAMAGE LOOP & GOD", 65, Color3.fromRGB(180, 0, 0), function()
    local function AntiDamage(char)
        local hum = char:WaitForChild("Humanoid")
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        
        runService.Heartbeat:Connect(function()
            -- 1. 체력 무한 고정
            hum.MaxHealth = 9e9
            hum.Health = 9e9
            
            -- 2. 캐릭터 내부에 서버가 심어놓은 '데미지/독' 관련 오브젝트 삭제
            for _, tag in pairs(char:GetDescendants()) do
                local n = tag.Name:lower()
                if n:find("damage") or n:find("kill") or n:find("tag") or n:find("poison") then
                    tag:Destroy()
                end
            end
            
            -- 3. 실시간 Hitbox 완전 삭제
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find("hitbox") then
                    v:Destroy()
                end
            end
        end)
    end
    if player.Character then AntiDamage(player.Character) end
    player.CharacterAdded:Connect(AntiDamage)
    print("데미지 루프가 차단되었습니다.")
end)

-- 2. [빨간 구역(VIP/옆벽) 안쪽 대청소]
CreateButton("ERASE RED ZONE (CLEAR)", 125, Color3.fromRGB(150, 70, 0), function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local n = v.Name:lower()
            -- 바닥 제외 모든 옆 장애물 삭제
            if not n:find("floor") and not n:find("base") then
                if n:find("vip") or n:find("wall") or n:find("border") or n:find("gate") then
                    v:Destroy()
                end
            end
            -- 바닥 무한 확장 및 색상 고정 (앞이 잘 보이도록)
            if n:find("floor") or v.Position.Y < (player.Character.HumanoidRootPart.Position.Y - 1) then
                v.Size = Vector3.new(10000, v.Size.Y, 1000000)
                v.Color = Color3.fromRGB(20, 20, 20)
                v.CanTouch = false
            end
        end
    end
end)

-- 3. [쓰나미 유령화 (79% 투명도)]
CreateButton("GHOST TSUNAMI (79%)", 185, Color3.fromRGB(80, 0, 120), function()
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

CreateButton("CLOSE MENU", 260, Color3.fromRGB(40, 40, 40), function() ScreenGui:Destroy() end)

