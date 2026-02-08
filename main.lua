-- [[ 쓰나미 브레인롯 V3: 일자 벽 삭제 + 완전 무적 합본 ]] --

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- 1. 강력 갓모드 (리스폰 대응 및 체력 고정)
local function ApplyUltimateGod(character)
    local hum = character:WaitForChild("Humanoid", 10)
    if hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) -- 죽음 상태 차단

        -- 데미지 입을 때마다 즉시 회복
        hum.HealthChanged:Connect(function()
            hum.Health = math.huge
        end)
    end
end

player.CharacterAdded:Connect(ApplyUltimateGod)
ApplyUltimateGod(char)

-- 2. 벽 일자 삭제 및 바닥 데미지 제거 (핵심 로직)
local function CleanMap()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local name = v.Name:lower()
            
            -- [벽 삭제] 이름에 상관없이 '벽처럼 생긴(높거나 긴)' 구조물 타겟팅
            -- 사진 속의 VIP 벽이나 복도 벽을 크기(Size) 기준으로 판별하여 제거
            if v.Size.Y > 5 or v.Size.X > 20 or v.Size.Z > 20 then
                if not name:find("floor") and not name:find("base") then
                    v:Destroy()
                end
            end

            -- [앞으로 가도 안 죽게] 바닥이나 물의 터치 판정을 끔
            -- 바닥에 깔린 '닿으면 죽는 스크립트'를 무력화합니다.
            if name:find("floor") or name:find("kill") or name:find("water") or name:find("lava") then
                v.CanTouch = false -- 터치 이벤트를 발생시키지 않음
            end
        end
    end
    print("벽이 일자로 제거되었고, 바닥 데미지 판정이 비활성화되었습니다.")
end

-- 3. 쓰나미 영구 제거 루프
task.spawn(function()
    while true do
        for _, v in pairs(workspace:GetChildren()) do
            local n = v.Name:lower()
            if n:find("tsunami") or n:find("wave") or n:find("water") then
                v:Destroy()
            end
        end
        task.wait(0.5)
    end
end)

-- 4. UI 및 실행
-- (앞서 만든 UI 버튼 로직에 CleanMap() 함수를 연결하면 됩니다.)
CleanMap() -- 스크립트 실행 시 즉시 맵 청소

