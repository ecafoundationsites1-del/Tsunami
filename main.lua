
-- [[ 1. 설정: 대상 및 이름 ]]
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local SAFE_ZONE_NAME = "InfiniteSafetyZone"
local HUGE_WALL_NAME = "VipLeftHugeWall"
local player = game.Players.LocalPlayer

-- [[ 2. VIP Bottom 기준 거대 벽 생성 함수 ]]
local function buildVipWall()
    local bottomPart = nil
    -- 워크스페이스에서 이름이 "Bottom"인 파트 검색
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj.Name == "Bottom" and obj:IsA("BasePart") then
            bottomPart = obj
            break
        end
    end

    if bottomPart then
        local existingWall = workspace:FindFirstChild(HUGE_WALL_NAME)
        if existingWall then existingWall:Destroy() end

        local wall = Instance.new("Part")
        wall.Name = HUGE_WALL_NAME
        
        -- 벽 크기 설정 (두께 5, 높이 1000, 길이 20000으로 끝까지 연장)
        local thickness = 5
        local height = 1000
        local length = 20000 
        wall.Size = Vector3.new(thickness, height, length)
        
        -- Bottom 파트의 왼쪽 위치 계산 (CFrame 활용)
        local leftOffset = -(bottomPart.Size.X / 2) - (thickness / 2)
        wall.CFrame = bottomPart.CFrame * CFrame.new(leftOffset, (height/2) - (bottomPart.Size.Y/2), 0)
        
        wall.Anchored = true
        wall.CanCollide = true
        wall.Transparency = 0
        wall.BrickColor = BrickColor.new("Really black")
        wall.Material = Enum.Material.Plastic
        wall.Parent = workspace
        print("✅ VIP Bottom 왼쪽 거대 벽 생성 완료")
    else
        warn("⚠️ Bottom 파트를 찾을 수 없어 벽을 세우지 못했습니다.")
    end
end

-- [[ 3. 내 캐릭터 추적 안전 구조물 함수 ]]
local function buildSuperStructure()
    local existing = workspace:FindFirstChild(SAFE_ZONE_NAME)
    if existing then existing:Destroy() end
    
    local model = Instance.new("Model", workspace)
    model.Name = SAFE_ZONE_NAME
    
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local startY = root.Position.Y - 10

    local floor = Instance.new("Part", model)
    floor.Name = "AntiFallFloor"
    floor.Size = Vector3.new(2000, 2, 2000)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0.5
    floor.Material = Enum.Material.Plastic
    floor.BrickColor = BrickColor.new("Dark stone grey")

    local function createWall(name, size)
        local wall = Instance.new("Part", model)
        wall.Name = name
        wall.Size = size
        wall.Anchored = true
        wall.CanCollide = true
        wall.Transparency = 0.7
        wall.BrickColor = BrickColor.new("Really blue")
        wall.Material = Enum.Material.Plastic
        return wall
    end

    local wallR = createWall("WallRight", Vector3.new(10, 500, 2000))
    local wallL = createWall("WallLeft", Vector3.new(10, 500, 2000))
    local wallF = createWall("WallFront", Vector3.new(2000, 500, 10))
    local wallB = createWall("WallBack", Vector3.new(2000, 500, 10))

    task.spawn(function()
        while model.Parent do
            local currentRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if currentRoot then
                local p = currentRoot.Position
                floor.Position = Vector3.new(p.X, startY, p.Z)
                wallR.Position = Vector3.new(p.X + 1005, startY + 245, p.Z)
                wallL.Position = Vector3.new(p.X - 1005, startY + 245, p.Z)
                wallF.Position = Vector3.new(p.X, startY + 245, p.Z + 1005)
                wallB.Position = Vector3.new(p.X, startY + 245, p.Z - 1005)
            end
            task.wait()
        end
    end)
end

-- [[ 4. 실시간 감시 및 초기화 루프 ]]
task.spawn(function()
    while task.wait(0.5) do
        -- 투명화 및 충돌 방지 로직
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            for _, name in pairs(REMOVE_TARGETS) do
                if obj.Name == name and obj:IsA("BasePart") then
                    obj.Transparency = 1
                    obj.CanCollide = false
                end
            end
        end
        
        -- 내 캐릭터 터치 방지
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanTouch = false
                end
            end
        end
    end
end)

-- 실행부
buildVipWall()      -- VIP 벽 생성
buildSuperStructure() -- 추적 바닥 생성

-- 리스폰 시 재생성
player.CharacterAdded:Connect(function()
    task.wait(1)
    buildVipWall()
    buildSuperStructure()
end)
