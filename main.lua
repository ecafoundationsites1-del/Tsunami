-- [[ 1. 설정 ]]
local player = game.Players.LocalPlayer
local SAFE_ZONE_NAME = "AccessibleVipZone"
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}

-- [[ 2. 기존 구조물 제거 ]]
local function clearOld()
    local old = workspace:FindFirstChild(SAFE_ZONE_NAME)
    if old then old:Destroy() end
end

-- [[ 3. VIP 구역 재건축 (진입 가능 버전) ]]
local function buildVipZone()
    local bottom = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Bottom" and v:IsA("BasePart") then
            bottom = v
            break
        end
    end

    if not bottom then return end

    local model = Instance.new("Model", workspace)
    model.Name = SAFE_ZONE_NAME

    -- [바닥] 20,000 x 20,000 거대 바닥
    local floor = Instance.new("Part", model)
    floor.Size = Vector3.new(20000, 2, 20000)
    floor.CFrame = bottom.CFrame * CFrame.new(0, -0.1, 0) -- 원래 바닥보다 살짝 아래
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0.5
    floor.BrickColor = BrickColor.new("Dark stone grey")

    -- [벽 생성 함수] - 핵심: CanCollide를 false로 하거나 특정 조건 부여
    local function makeWall(name, size, offset)
        local w = Instance.new("Part", model)
        w.Name = name
        w.Size = size
        w.CFrame = bottom.CFrame * offset
        w.Anchored = true
        
        -- [[ 진입 해결책 ]]
        -- 벽은 보이되(Transparency 0.8), 캐릭터는 통과할 수 있게(CanCollide false) 설정
        -- 만약 물리적으로 막고 싶다면 이 값을 true로 하고 위치를 더 멀리 잡아야 합니다.
        w.CanCollide = false 
        
        w.Transparency = 0.8
        w.BrickColor = BrickColor.new("Really blue")
        w.Material = Enum.Material.Plastic
    end

    -- 벽의 위치를 VIP 구역에서 훨씬 멀리(5000 스터드) 배치하여 시야 방해 최소화
    local wallDistance = 5000 
    local wallHeight = 1000 -- 위아래로 충분히 길게

    makeBigWall = makeWall -- 별칭
    makeBigWall("F", Vector3.new(10000, wallHeight, 20), CFrame.new(0, wallHeight/2, wallDistance))
    makeBigWall("B", Vector3.new(10000, wallHeight, 20), CFrame.new(0, wallHeight/2, -wallDistance))
    makeBigWall("L", Vector3.new(20, wallHeight, 10000), CFrame.new(-wallDistance, wallHeight/2, 0))
    makeBigWall("R", Vector3.new(20, wallHeight, 10000), CFrame.new(wallDistance, wallHeight/2, 0))
end

-- [[ 4. 실행 및 리스폰 관리 ]]
local function run()
    clearOld()
    buildVipZone()
end

run()
player.CharacterAdded:Connect(function()
    task.wait(2)
    run()
end)

-- [[ 5. 실시간 투명화 및 충돌 관리 ]]
task.spawn(function()
    while true do
        for _, obj in pairs(workspace:GetDescendants()) do
            -- VIP 관련 파트 투명화 (단, 우리가 만든 구조물은 제외)
            for _, n in pairs(REMOVE_TARGETS) do
                if obj.Name == n and obj:IsA("BasePart") and obj.Name ~= "Bottom" then
                    if not obj:IsDescendantOf(workspace:FindFirstChild(SAFE_ZONE_NAME)) then
                        obj.Transparency = 1
                        obj.CanCollide = false
                    end
                end
            end
        end
        task.wait(1)
    end
end)

