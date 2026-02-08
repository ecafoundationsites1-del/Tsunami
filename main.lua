-- [[ 쓰나미 브레인롯 V4: 무한 바닥 + 벽 삭제 + 완전 무적 ]] --

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- 1. 강력 갓모드 (어떤 데미지에도 죽지 않음)
local function ApplyGod(character)
    local hum = character:WaitForChild("Humanoid", 10)
    if hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        
        hum.HealthChanged:Connect(function()
            hum.Health = math.huge
        end)
    end
end
player.CharacterAdded:Connect(ApplyGod)
ApplyGod(char)

-- 2. 맵 개조: 바닥은 잇고 벽은 밀어버리기
local function FixMap()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local name = v.Name:lower()
            
            -- [바닥 로직] 캐릭터 발밑에 있거나 이름이 바닥인 경우
            -- 지우지 않고 오히려 앞뒤로 길게(50,000) 늘려서 고속도로를 만듭니다.
            if name:find("floor") or name:find("ground") or v.Position.Y < (char.HumanoidRootPart.Position.Y - 1) then
                v.CanCollide = true
                v.Transparency = 0 -- 바닥은 보여야 함
                v.Size = Vector3.new(1000, v.Size.Y, 50000) -- 앞뒤로 무한 확장
                v.CanTouch = false -- 바닥에 깔린 킬 스크립트 무력화
                v.Color = Color3.fromRGB(50, 200, 50) -- 초록색 바닥으로 통일 (옵션)
            
            -- [벽 로직] 바닥보다 위에 솟아있는 벽들만 삭제
            elseif v.Size.Y > 2 then
                if name:find("wall") or name:find("vip") or name:find("border") or name:find("part") then
                    v:Destroy()
                end
            end
        end
    end
end

-- 3. 쓰나미 실시간 삭제 루프
task.spawn(function()
    while true do
        for _, v in pairs(workspace:GetChildren()) do
            local n = v.Name:lower()
            if n:find("tsunami") or n:find("wave") or n:find("water") then
                v:Destroy()
            end
        end
        task.wait(0.3)
    end
end)

-- 실행
FixMap()
print("만우절 에디션 로드 완료: 고속도로가 개통되었습니다!")
