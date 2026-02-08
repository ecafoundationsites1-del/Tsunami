-- [[ 1. 설정 ]]
local player = game.Players.LocalPlayer
local SAFE_ZONE_NAME = "FixedUprightZone"
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}

-- [[ 2. 이전 구조물 제거 ]]
local function clearOld()
    local old = workspace:FindFirstChild(SAFE_ZONE_NAME)
    if old then old:Destroy() end
end

-- [[ 3. Cosmic 확장 및 벽 직립 생성 ]]
local function rebuild()
    local cosmic = nil
    local bottom = nil

    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Cosmic" and v:IsA("BasePart") then
            cosmic = v
        elseif v.Name == "Bottom" and v:IsA("BasePart") then
            bottom = v
        end
    end

    -- 1. Cosmic 파트 초대형 확장 (40,000 x 40,000)
    if cosmic then
        cosmic.Size = Vector3.new(40000, 5, 40000) -- 두께도 약간 줌
        cosmic.Anchored = true
        cosmic.CanCollide = true
        cosmic.Transparency = 0.5
        -- 위치를 맵의 중앙이나 현재 바닥 위치에 고정
        print("✅ Cosmic 4만 스터드 확장 완료")
    end

    -- 2. 벽 생성 (쓰러지지 않도록 WorldAxis 사용)
    if bottom then
        local model = Instance.new("Model", workspace)
        model.Name = SAFE_ZONE_NAME

        local function makeStableWall(name, size, worldPos)
            local w = Instance.new("Part", model)
            w.Name = name
            w.Size = size
            -- CFrame.new(위치)만 사용하여 회전값을 0으로 강제 초기화 (똑바로 서게 함)
            w.CFrame = CFrame.new(worldPos) 
            w.Anchored = true
            w.CanCollide = true
            w.Transparency = 0.7
            w.BrickColor = BrickColor.new("Really blue")
            w.Material = Enum.Material.Plastic
        end

        -- Bottom의 위치를 기준으로 10스터드 여유를 두고 좌표 계산
        local bp = bottom.Position
        local bs = bottom.Size
        local h = 500 -- 벽의 높이 절반 (총 높이 1000)

        -- 각 벽의 위치를 월드 좌표 기준으로 직접 계산 (Bottom의 회전에 영향받지 않음)
        -- 뒤쪽 벽 (10스터드 뒤)
        makeStableWall("BackWall", Vector3.new(bs.X + 20, 1000, 5), bp + Vector3.new(0, h, (bs.Z/2) + 10))
        -- 왼쪽 벽 (10스터드 옆)
        makeStableWall("LeftWall", Vector3.new(5, 1000, bs.Z + 20), bp + Vector3.new(-(bs.X/2 + 10), h, 0))
        -- 오른쪽 벽 (10스터드 옆)
        makeStableWall("RightWall", Vector3.new(5, 1000, bs.Z + 20), bp + Vector3.new((bs.X/2 + 10), h, 0))
        
        print("✅ 벽 직립 고정 및 10스터드 후퇴 완료")
    end
end

-- [[ 4. 통합 실행 로직 ]]
local function run()
    clearOld()
    rebuild()
end

run()

-- 리스폰 시 재생성
player.CharacterAdded:Connect(function()
    task.wait(2)
    run()
end)

-- 투명화 필터링 (Cosmic, Bottom 제외)
task.spawn(function()
    while true do
        for _, obj in pairs(workspace:GetDescendants()) do
            for _, n in pairs(REMOVE_TARGETS) do
                if obj.Name == n and obj:IsA("BasePart") then
                    if obj.Name ~= "Cosmic" and obj.Name ~= "Bottom" then
                        obj.Transparency = 1
                        obj.CanCollide = false
                    end
                end
            end
        end
        task.wait(1)
    end
end)

