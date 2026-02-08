-- [[ BRAINROT V15: 전면 개조 - 모든 킬 판정 삭제 & 빨간 구역 청소 ]] --

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

-- [UI 디자인 - 데인저 레드 테마]
MainFrame.Size = UDim2.new(0, 230, 0, 350)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Thickness = 4
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

-- 1. [게임 파일 전수 조사 및 킬 판정 완전 삭제]
CreateButton("NUKE ALL KILL SCRIPTS", 65, Color3.fromRGB(150, 0, 0), function()
    local function PurgeKillElements()
        for _, v in pairs(workspace:GetDescendants()) do
            local name = v.Name:lower()
            -- Hitbox, Kill, Damage, Lava, Dead 등 위험 단어 포함된 모든 것 삭제
            if name:find("hitbox") or name:find("kill") or name:find("damage") or name:find("lava") then
                if v:IsA("BasePart") then
                    v.CanTouch = false
                    v.CanQuery = false
                    v:Destroy()
                elseif v:IsA("Script") or v:IsA("LocalScript") then
                    v.Disabled = true
                    v:Destroy()
                end
            end
        end
    end
    
    -- 즉시 실행 및 실시간 감시 (새로 생성되는 킬 파트 방지)
    runService.Stepped:Connect(PurgeKillElements)
    
    -- 캐릭터 불멸 상태 고정
    local function Immortal(char)
        local hum = char:WaitForChild("Humanoid")
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        runService.Heartbeat:Connect(function()
            hum.MaxHealth = 9e9
            hum.Health = 9e9
        end)
    end
    if player.Character then Immortal(player.Character) end
    player.CharacterAdded:Connect(Immortal)
    print("모든 킬 판정 및 스크립트가 영구 삭제되었습니다.")
end)

-- 2. [빨간 선 안쪽 VIP/옆벽 전면 삭제]
CreateButton("ERASE RED ZONE (INSIDE)", 125, Color3.fromRGB(200, 50, 0), function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local n = v.Name:lower()
            -- 바닥(Floor) 계열이 아니면서 옆을 막는 모든 구조물 삭제
            if not n:find("floor") and not n:find("base") then
                if n:find("vip") or n:find("wall") or n:find("border") or n:find("gate") or n:find("obstacle") then
                    v:Destroy()
                end
            end
            -- 바닥은 무한 확장하여 안전지대 확보
            if n:find("floor") or v.Position.Y < (player.Character.HumanoidRootPart.Position.Y - 1) then
                v.Size = Vector3.new(10000, v.Size.Y, 1000000)
                v.CanTouch = false
                v.Transparency = 0
            end
        end
    end
    print("사진 속 빨간 구역의 모든 장애물이 제거되었습니다.")
end)

-- 3. [쓰나미 고스트화 (79% 투명도)]
CreateButton("GHOST TSUNAMI (79%)", 185, Color3.fromRGB(100, 0, 150), function()
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

