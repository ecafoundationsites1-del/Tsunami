-- [[ 1. 설정: 투명화 대상 및 고속도로 이름 ]]
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local SAFE_ZONE_NAME = "InfiniteSafetyZone"
local player = game.Players.LocalPlayer

-- [[ 2. 절대 낙사 방지 바닥 + 안전벽 생성 함수 ]]
local function buildSuperStructure()
    local existing = workspace:FindFirstChild(SAFE_ZONE_NAME)
    if existing then existing:Destroy() end
    
    local model = Instance.new("Model", workspace)
    model.Name = SAFE_ZONE_NAME
    
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- 바닥 (원본 그대로)
    local floor = Instance.new("Part", model)
    floor.Name = "AntiFallFloor"
    floor.Size = Vector3.new(2000, 2, 2000)
    floor.Position = root.Position - Vector3.new(0, 4, 0)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0.3
    floor.Material = Enum.Material.Neon
    floor.BrickColor = BrickColor.new("Lime green")

    -- ✅ 안전벽만 제대로 생성 (지름길 영향 없음)
    local function createWall(size, position)
        local wall = Instance.new("Part", model)
        wall.Size = size
        wall.Position = position
        wall.Anchored = true
        wall.CanCollide = true
        wall.Transparency = 0.5
        wall.BrickColor = BrickColor.new("Really blue")
    end

    -- 맵 외곽 전체 봉인
    createWall(Vector3.new(10, 100, 2000), floor.Position + Vector3.new(1005, 50, 0))   -- 오른쪽
    createWall(Vector3.new(10, 100, 2000), floor.Position + Vector3.new(-1005, 50, 0))  -- 왼쪽
    createWall(Vector3.new(2000, 100, 10), floor.Position + Vector3.new(0, 50, 1005))   -- 앞
    createWall(Vector3.new(2000, 100, 10), floor.Position + Vector3.new(0, 50, -1005))  -- 뒤
end

-- [[ 3. 실시간 감시 루프 (원본 그대로) ]]
task.spawn(function()
    while task.wait(0.2) do
        -- 특정 벽들 투명화
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            for _, name in pairs(REMOVE_TARGETS) do
                if obj.Name == name and obj:IsA("BasePart") then
                    obj.Transparency = 1
                    obj.CanCollide = false
                end
            end
        end
        
        -- 캐릭터 무적 처리
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanTouch = false
                end
            end
        end
    end
end)

-- 실행
buildSuperStructure()

-- 리스폰 대응 (안전벽 유지)
player.CharacterAdded:Connect(function()
    task.wait(1)
    buildSuperStructure()
end)

print("낙사 방지 + 안전벽 시스템 가동 완료")
