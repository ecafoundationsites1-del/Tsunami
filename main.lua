-- [[ BRAINROT V6: 최종 통합본 - 갓모드 + 무한 직진 + 맵 개조 ]] --

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

-- 1. [갓모드 & 움직임 고정 해제]
-- 캐릭터가 죽지 않고, 쓰나미나 바닥 판정에 의해 멈추지 않게 합니다.
local function SetUnstoppable(char)
    local hum = char:WaitForChild("Humanoid", 10)
    local root = char:WaitForChild("HumanoidRootPart", 10)
    
    if hum and root then
        -- 무적 상태 유지
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        
        -- 외부에서 캐릭터를 멈추거나 속도를 0으로 만드는 모든 시도를 무시
        runService.Heartbeat:Connect(function()
            hum.Health = math.huge
            if hum.MoveDirection.Magnitude > 0 then
                -- 걷고 있을 때는 물리적 저항을 무시하고 속도 유지
                root.Velocity = root.Velocity.Unit * hum.WalkSpeed + Vector3.new(0, root.Velocity.Y, 0)
            end
        end)
        
        -- 캐릭터의 마찰력을 0으로 만들어 미끄러지듯 이동 (멈춤 방지)
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            end
        end
    end
end

player.CharacterAdded:Connect(SetUnstoppable)
if player.Character then SetUnstoppable(player.Character) end

-- 2. [맵 개조: 바닥 고속도로 및 벽 삭제]
-- 바닥은 길게 잇고, 진행을 방해하는 옆벽들만 골라서 지웁니다.
local function RefactorMap()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local n = v.Name:lower()
            -- 바닥 판별 (캐릭터 발밑에 있는 넓은 판)
            if n:find("floor") or n:find("ground") or v.Position.Y < (player.Character.HumanoidRootPart.Position.Y - 1) then
                v.CanCollide = true
                v.CanTouch = false -- 바닥 킬 스크립트 무력화
                v.Transparency = 0
                -- 바닥을 앞뒤로 100,000 유닛 확장하여 무한 통로 생성
                v.Size = Vector3.new(v.Size.X, v.Size.Y, 100000) 
                v.Color = Color3.fromRGB(0, 255, 100) -- 초록색 길로 통일
            
            -- 벽 판별 (옆을 막는 VIP 벽이나 장애물)
            elseif v.Size.Y > 2 then
                if n:find("wall") or n:find("vip") or n:find("border") or n:find("gate") then
                    v:Destroy()
                end
            end
        end
    end
end

-- 3. [쓰나미 완전 소멸 루프]
task.spawn(function()
    while true do
        for _, v in pairs(workspace:GetChildren()) do
            local n = v.Name:lower()
            if n:find("tsunami") or n:find("wave") or n:find("water") then
                -- 물리적 충돌과 터치 판정을 끄고 삭제
                if v:IsA("BasePart") then
                    v.CanTouch = false
                    v.CanCollide = false
                end
                v:Destroy()
            end
        end
        task.wait(0.1) -- 0.1초마다 매우 빠르게 검사
    end
end)

-- 즉시 실행
RefactorMap()
print("BRAINROT V6 로드 완료. 이제 막힘없이 질주하세요!")
