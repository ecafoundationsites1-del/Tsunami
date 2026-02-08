-- [[ 1. 설정: 투명화 대상 및 고속도로 이름 ]]
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local SAFE_ZONE_NAME = "InfiniteSafetyZone"
local player = game.Players.LocalPlayer

-- [[ 2. 구조물 생성 및 실시간 추적 함수 ]]
local function buildSuperStructure()
    local existing = workspace:FindFirstChild(SAFE_ZONE_NAME)
    if existing then existing:Destroy() end
    
    local model = Instance.new("Model", workspace)
    model.Name = SAFE_ZONE_NAME
    
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    -- 바닥 (재질을 Plastic으로 변경하여 눈부심 방지)
    local floor = Instance.new("Part", model)
    floor.Name = "AntiFallFloor"
    floor.Size = Vector3.new(2000, 2, 2000)
    -- 플레이어의 현재 높이보다 10유닛 아래에 고정 생성
    floor.Position = Vector3.new(root.Position.X, root.Position.Y - 10, root.Position.Z)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0.5
    floor.Material = Enum.Material.Plastic -- Neon에서 Plastic으로 변경
    floor.BrickColor = BrickColor.new("Dark stone grey") -- 색상도 차분하게 변경

    -- 안전벽 생성 함수 (높이를 크게 키워 이탈 방지)
    local function createWall(name, size)
        local wall = Instance.new("Part", model)
        wall.Name = name
        wall.Size = size
        wall.Anchored = true
        wall.CanCollide = true
        wall.Transparency = 0.8
        wall.BrickColor = BrickColor.new("Really blue")
        wall.Material = Enum.Material.Plastic
        return wall
    end

    local wallR = createWall("WallRight", Vector3.new(10, 500, 2000))
    local wallL = createWall("WallLeft", Vector3.new(10, 500, 2000))
    local wallF = createWall("WallFront", Vector3.new(2000, 500, 10))
    local wallB = createWall("WallBack", Vector3.new(2000, 500, 10))

    -- 실시간 위치 업데이트 (길 끊김 방지)
    task.spawn(function()
        while model.Parent do
            local currentRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if currentRoot then
                local p = currentRoot.Position
                local fy = floor.Position.Y -- 처음 생성된 높이 유지
                
                floor.Position = Vector3.new(p.X, fy, p.Z)
                wallR.Position = Vector3.new(p.X + 1005, fy + 245, p.Z)
                wallL.Position = Vector3.new(p.X - 1005, fy + 245, p.Z)
                wallF.Position = Vector3.new(p.X, fy + 245, p.Z + 1005)
                wallB.Position = Vector3.new(p.X, fy + 245, p.Z - 1005)
            end
            task.wait() -- 매 프레임마다 부드럽게 추적
        end
    end)
end

-- [[ 3. 실시간 감시 루프 (기존 기능 유지) ]]
task.spawn(function()
    while task.wait(0.5) do
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            for _, name in pairs(REMOVE_TARGETS) do
                if obj.Name == name and obj:IsA("BasePart") then
                    obj.Transparency = 1
                    obj.CanCollide = false
                end
            end
        end
        
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

-- 리스폰 시 재생성
player.CharacterAdded:Connect(function()
    task.wait(1)
    buildSuperStructure()
end)

print("눈 안 아픈 바닥 + 무한 추적 안전벽 시스템 가동")
