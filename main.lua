-- [[ 1. 설정 ]]
local player = game.Players.LocalPlayer
local SAFE_ZONE_NAME = "FinalSafetyZone"
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}

-- [[ 2. 구조물 초기화 ]]
local function clearOld()
    local old = workspace:FindFirstChild(SAFE_ZONE_NAME)
    if old then old:Destroy() end
end

-- [[ 3. Cosmic 확장 및 벽 생성 ]]
local function rebuildZone()
    local cosmic = nil
    local bottom = nil

    -- 맵에서 Cosmic과 Bottom 파트 찾기
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Cosmic" and v:IsA("BasePart") then
            cosmic = v
        elseif v.Name == "Bottom" and v:IsA("BasePart") then
            bottom = v
        end
    end

    -- 1. Cosmic 파트 40,000 x 40,000으로 확장
    if cosmic then
        cosmic.Size = Vector3.new(40000, cosmic.Size.Y, 40000)
        cosmic.CanCollide = true -- 밟을 수 있게
        cosmic.Transparency = 0.5
        cosmic.Anchored = true
        print("✅ Cosmic 파트 4만x4만 확장 완료")
    end

    -- 2. VIP 벽 생성 (Bottom 기준 10스터드 뒤로 후퇴)
    if bottom then
        local model = Instance.new("Model", workspace)
        model.Name = SAFE_ZONE_NAME

        local function makeWall(name, size, offset)
            local w = Instance.new("Part", model)
            w.Name = name
            w.Size = size
            -- 뒤로 10스터드 밀어내기 위해 CFrame 오프셋 조절
            w.CFrame = bottom.CFrame * offset
            w.Anchored = true
            w.CanCollide = true -- 이번엔 물리적으로 막되, 위치를 뒤로 뺌
            w.Transparency = 0.7
            w.BrickColor = BrickColor.new("Really blue")
            w.Material = Enum.Material.Plastic
        end

        -- 벽 높이 1000, 10스터드 뒤로(Z축 방향) 배치
        -- 뒤로 10스터드 보정하기 위해 기존 거리값에 +10 추가
        local dist = (bottom.Size.Z / 2) + 10 
        
        -- VIP 구역 입구를 막지 않도록 위치를 더 뒤로 설정
        makeWall("BackWall", Vector3.new(2000, 1000, 5), CFrame.new(0, 500, -dist))
        makeWall("LeftWall", Vector3.new(5, 1000, 2000), CFrame.new(-(bottom.Size.X/2 + 10), 500, 0))
        makeWall("RightWall", Vector3.new(5, 1000, 2000), CFrame.new(bottom.Size.X/2 + 10, 500, 0))
        print("✅ 벽을 10스터드 뒤로 배치 완료")
    end
end

-- [[ 4. 실행 및 관리 ]]
local function run()
    clearOld()
    rebuildZone()
end

run()

-- 리스폰 시 다시 적용
player.CharacterAdded:Connect(function()
    task.wait(2)
    run()
end)

-- 투명화 (Cosmic과 Bottom은 제외)
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

