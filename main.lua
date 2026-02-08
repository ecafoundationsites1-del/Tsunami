-- [[ 1. 설정 ]]
local player = game.Players.LocalPlayer
local MOVE_STUDS = 10 -- 정확히 스터드 10칸(돌기 10개) 뒤로 후퇴
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}

-- [[ 2. 환경 재구축 (벽 밀기 + 확장) ]]
local function rebuild()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            -- [A] Cosmic 및 진짜 바닥 확장
            if v.Name == "Cosmic" or (v.Name == "Bottom" and v.Size.Y <= 5) then
                v.Size = Vector3.new(40000, v.Size.Y, 40000)
                v.Anchored = true
                v.CanCollide = true
                if v.Name == "Cosmic" then v.Transparency = 0.5 end

            -- [B] Bottom 이름의 '벽' (높이가 있는 파트) 처리
            elseif v.Name == "Bottom" and v.Size.Y > 5 then
                -- 한 번만 밀리도록 태그 확인
                if not v:FindFirstChild("IsMoved") then
                    v.Material = Enum.Material.Plastic -- 재질 변경 (스터드 제거)
                    v.Transparency = 0.5
                    v.Anchored = true
                    v.CanCollide = false -- 통과 가능하게 설정

                    -- 캐릭터 중심에서 바깥쪽 방향 계산
                    local diff = v.Position - root.Position
                    local direction = Vector3.new(diff.X, 0, diff.Z).Unit
                    
                    -- 벽이 바라보는 방향 기준으로 10스터드 뒤로 이동
                    v.CFrame = v.CFrame + (direction * MOVE_STUDS)
                    
                    -- 높이를 대폭 키워 경계 확실히 표시
                    v.Size = Vector3.new(v.Size.X, 1000, v.Size.Z)

                    -- 중복 이동 방지 태그
                    local tag = Instance.new("BoolValue", v)
                    tag.Name = "IsMoved"
                end
            end
        end
    end
end

-- [[ 3. 장애물 제거 ]]
local function clearObstacles()
    for _, obj in pairs(workspace:GetDescendants()) do
        for _, n in pairs(REMOVE_TARGETS) do
            if obj.Name == n and obj:IsA("BasePart") then
                -- 바닥이나 이미 처리된 벽 제외하고 투명화
                if obj.Name ~= "Cosmic" and not obj:FindFirstChild("IsMoved") and obj.Size.Y <= 5 then
                    obj.Transparency = 1
                    obj.CanCollide = false
                end
            end
        end
    end
end

-- [[ 4. 메인 실행 및 루프 ]]
task.spawn(function()
    while true do
        rebuild()
        clearObstacles()
        task.wait(2) -- 2초마다 체크 (새로 생기는 벽 대응)
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    rebuild()
end)

rebuild()
print("✅ 벽 10칸 후퇴 + 통과 + 플라스틱 변경 완료!")

