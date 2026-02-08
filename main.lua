-- [[ 1. 설정 ]]
local player = game.Players.LocalPlayer
local SAFE_ZONE_NAME = "UprightStableZone"
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}

-- [[ 2. 이전 구조물 제거 ]]
local function clearOld()
    local old = workspace:FindFirstChild(SAFE_ZONE_NAME)
    if old then old:Destroy() end
end

-- [[ 3. Cosmic 확장 및 벽 생성 (수직 고정) ]]
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

    -- 1. Cosmic 파트 40,000 x 40,000 확장
    if cosmic then
        cosmic.Size = Vector3.new(40000, 5, 40000)
        cosmic.Anchored = true
        cosmic.CanCollide = true
        cosmic.Transparency = 0.5
        print("✅ Cosmic 4만 스터드 확장 완료")
    end

    -- 2. 벽 생성 (Bottom 기준 왼쪽으로 10스터드 이동 및 수직 고정)
    if bottom then
        local model = Instance.new("Model", workspace)
        model.Name = SAFE_ZONE_NAME

        -- 벽 생성 보조 함수 (CFrame.new만 사용하여 회전값 초기화 -> 똑바로 섬)
        local function makeVerticalWall(name, size, worldPos)
            local w = Instance.new("Part", model)
            w.Name = name
            w.Size = size
            w.CFrame = CFrame.new(worldPos) -- 회전값 없이 좌표만 설정 (수직 고정)
            w.Anchored = true
            w.CanCollide = true
            w.Transparency = 0.7
            w.BrickColor = BrickColor.new("Really blue")
            w.Material = Enum.Material.Plastic
        end

        local bp = bottom.Position
        local bs = bottom.Size
        local wallHeight = 1000 -- 요청하신 대로 아주 높게
        local yPos = bp.Y + (wallHeight / 2) -- 바닥에서 위로 솟아오르게

        -- [핵심] 왼쪽 방향으로 10스터드 더 이동한 위치 계산
        -- Bottom의 X축 기준 왼쪽 끝에서 -10만큼 더 이동
        local leftEdgeX = bp.X - (bs.X / 2) - 10 

        -- 왼쪽 벽 생성 (쓰러지지 않음)
        makeVerticalWall("LeftHugeWall", Vector3.new(5, wallHeight, bs.Z + 40), Vector3.new(leftEdgeX, yPos, bp.Z))
        
        -- (선택 사항) 오른쪽/뒤쪽도 대칭으로 맞추고 싶다면 아래 주석을 푸세요
        -- makeVerticalWall("RightWall", Vector3.new(5, wallHeight, bs.Z + 40), Vector3.new(bp.X + (bs.X/2) + 10, yPos, bp.Z))
        
        print("✅ 벽을 왼쪽으로 10스터드 이동 및 수직 고정 완료")
    end
end

-- [[ 4. 실행 로직 ]]
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

-- 투명화 (Cosmic, Bottom 제외)
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

