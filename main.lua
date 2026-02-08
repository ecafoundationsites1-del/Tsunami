-- [[ 1. 설정: 투명화 대상 및 고속도로 이름 ]]
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local SAFE_ZONE_NAME = "InfiniteSafetyZone"
local player = game.Players.LocalPlayer

-- [[ 2. 절대 낙사 방지 바닥 및 벽 생성 함수 ]]
local function buildSuperStructure()
    local existing = workspace:FindFirstChild(SAFE_ZONE_NAME)
    if existing then existing:Destroy() end
    
    local model = Instance.new("Model", workspace)
    model.Name = SAFE_ZONE_NAME
    
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- [슈퍼 바닥] 맵 전체를 덮을 정도로 거대하게 생성 (2000x2000)
    -- 사진 속의 모든 구멍과 낭떠러지를 이 바닥이 밑에서 받쳐줍니다.
    local floor = Instance.new("Part", model)
    floor.Name = "AntiFallFloor"
    floor.Size = Vector3.new(2000, 2, 2000) 
    floor.Position = root.Position - Vector3.new(0, 4, 0) -- 발바닥 바로 아래
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0.3 -- 위치 확인을 위해 살짝 투명하게 설정
    floor.Material = Enum.Material.Neon
    floor.BrickColor = BrickColor.new("Lime green") -- VIP 스타일 초록색

    -- [철벽 방어] 양옆에 아주 높은 벽을 세워 쓰나미가 밀어도 안 떨어지게 함
    local function createSideWall(offset)
        local wall = Instance.new("Part", model)
        wall.Size = Vector3.new(1, 100, 2000) -- 높이 100의 거대한 벽
        wall.Position = floor.Position + offset
        wall.Anchored = true
        wall.CanCollide = true
        wall.Transparency = 0.5
        wall.BrickColor = BrickColor.new("Really blue")
    end
    
    createSideWall(Vector3.new(50, 50, 0))  -- 오른쪽 벽
    createSideWall(Vector3.new(-50, 50, 0)) -- 왼쪽 벽
end

-- [[ 3. 실시간 감시 루프 (장애물 제거 및 무적 유지) ]]
task.spawn(function()
    while task.wait(0.2) do
        -- 1) 특정 벽들 100% 투명화
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            for _, name in pairs(REMOVE_TARGETS) do
                if obj.Name == name and obj:IsA("BasePart") then
                    obj.Transparency = 1 
                    obj.CanCollide = false
                end
            end
        end
        
        -- 2) 캐릭터 무적 (쓰나미 판정 무시)
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
print("낙사 방지 시스템 가동! 이제 맵 밖으로 떨어지지 않습니다.")
