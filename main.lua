-- [[ 1. 설정 ]]
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local SAFE_ZONE_NAME = "InfiniteSafetyZone"
local HUGE_WALL_NAME = "VipLeftHugeWall"
local player = game.Players.LocalPlayer

-- [[ 2. 구조물 정리 함수 (깔끔하게 삭제) ]]
local function clearOldStructures()
    local existingZone = workspace:FindFirstChild(SAFE_ZONE_NAME)
    if existingZone then existingZone:Destroy() end
    
    local existingWall = workspace:FindFirstChild(HUGE_WALL_NAME)
    if existingWall then existingWall:Destroy() end
end

-- [[ 3. VIP Bottom 기준 거대 벽 생성 ]]
local function buildVipWall()
    local bottomPart = nil
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj.Name == "Bottom" and obj:IsA("BasePart") then
            bottomPart = obj
            break
        end
    end

    if bottomPart then
        local wall = Instance.new("Part")
        wall.Name = HUGE_WALL_NAME
        wall.Size = Vector3.new(5, 1000, 40000) -- 길이를 더 늘림
        
        -- CFrame을 사용하여 Bottom의 월드 좌표 기준으로 왼쪽 배치
        local leftOffset = -(bottomPart.Size.X / 2) - 2.5
        wall.CFrame = bottomPart.CFrame * CFrame.new(leftOffset, 500, 0)
        
        wall.Anchored = true
        wall.CanCollide = true
        wall.Transparency = 0.5
        wall.BrickColor = BrickColor.new("Really black")
        wall.Parent = workspace
    end
end

-- [[ 4. 내 캐릭터 추적 안전 구조물 ]]
local function buildSuperStructure()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    local model = Instance.new("Model", workspace)
    model.Name = SAFE_ZONE_NAME
    
    -- 바닥
    local floor = Instance.new("Part", model)
    floor.Size = Vector3.new(2000, 2, 2000)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0.5
    floor.BrickColor = BrickColor.new("Dark stone grey")

    -- 벽 생성 도우미
    local function createWall(name, size)
        local w = Instance.new("Part", model)
        w.Name = name
        w.Size = size
        w.Anchored = true
        w.CanCollide = true
        w.Transparency = 0.8
        w.BrickColor = BrickColor.new("Really blue")
        return w
    end

    local wallR = createWall("WR", Vector3.new(10, 500, 2000))
    local wallL = createWall("WL", Vector3.new(10, 500, 2000))
    local wallF = createWall("WF", Vector3.new(2000, 500, 10))
    local wallB = createWall("WB", Vector3.new(2000, 500, 10))

    -- 루프 추적 (캐릭터가 죽으면 자동 종료되도록 조건 설정)
    task.spawn(function()
        local startY = root.Position.Y - 10
        while char and char.Parent and model.Parent do
            local p = root.Position
            floor.Position = Vector3.new(p.X, startY, p.Z)
            wallR.Position = Vector3.new(p.X + 1005, startY + 245, p.Z)
            wallL.Position = Vector3.new(p.X - 1005, startY + 245, p.Z)
            wallF.Position = Vector3.new(p.X, startY + 245, p.Z + 1005)
            wallB.Position = Vector3.new(p.X, startY + 245, p.Z - 1005)
            task.wait()
        end
    end)
end

-- [[ 5. 실행 및 리스폰 관리 ]]
local function initialize()
    clearOldStructures()
    buildVipWall()
    buildSuperStructure()
end

-- 최초 실행
initialize()

-- 캐릭터가 바뀔 때마다(죽었을 때) 다시 실행
player.CharacterAdded:Connect(function()
    task.wait(1) -- 로딩 대기
    initialize()
end)

