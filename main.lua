-- [[ 1. 설정 ]]
local player = game.Players.LocalPlayer
local MOVE_STUDS = 10 -- 스터드 10칸 후퇴
local SAFE_ZONE_NAME = "UprightStableZone"
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}

-- [[ 2. 환경 재구축 함수 ]]
local function rebuild()
    local char = player.Character
    if not char then return end
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            -- [1] Cosmic 및 진짜 바닥 확장
            if v.Name == "Cosmic" or (v.Name == "Bottom" and v.Size.Y <= 10) then
                v.Size = Vector3.new(40000, v.Size.Y, 40000)
                v.Anchored = true
                v.CanCollide = true
                if v.Name == "Cosmic" then v.Transparency = 0.5 end
            
            -- [2] Bottom 이름의 '벽' 처리
            elseif v.Name == "Bottom" and v.Size.Y > 10 then
                -- 이미 처리된 벽은 건너뜀 (무한 이동 방지)
                if not v:FindFirstChild("Fixed") then
                    v.Material = Enum.Material.Plastic -- 재질 플라스틱으로 변경
                    v.Transparency = 0.5
                    v.Anchored = true
                    
                    -- [핵심] 벽이 바라보는 방향의 뒤쪽으로 10스터드 이동
                    -- CFrame.new(0, 0, MOVE_STUDS)는 로컬 좌표 기준 뒤쪽을 의미함
                    v.CFrame = v.CFrame * CFrame.new(0, 0, MOVE_STUDS)
                    
                    -- 처리 완료 태그 생성
                    local tag = Instance.new("BoolValue", v)
                    tag.Name = "Fixed"
                    
                    -- 벽 높이 대폭 확장 (위로 솟구치게)
                    v.Size = Vector3.new(v.Size.X, 1000, v.Size.Z)
                end
            end
        end
    end
end

-- [[ 3. 장애물 제거 함수 ]]
local function clearObstacles()
    for _, obj in pairs(workspace:GetDescendants()) do
        for _, n in pairs(REMOVE_TARGETS) do
            if obj.Name == n and obj:IsA("BasePart") then
                -- 바닥이나 이미 처리된 벽은 제외
                if obj.Name ~= "Cosmic" and not obj:FindFirstChild("Fixed") and obj.Size.Y <= 10 then
                    obj.Transparency = 1
                    obj.CanCollide = false
                end
            end
        end
    end
end

-- [[ 4. 메인 실행 루프 ]]
task.spawn(function()
    while true do
        rebuild()
        clearObstacles()
        task.wait(3) -- 3초마다 새로 생기는 구조물 체크
    end
end)

-- 초기 실행 및 리스폰 대응
player.CharacterAdded:Connect(function()
    task.wait(1)
    rebuild()
end)

rebuild()
print("✅ 스크립트 통합 완료: 벽 10칸 후퇴 및 플라스틱 변경 적용됨")
