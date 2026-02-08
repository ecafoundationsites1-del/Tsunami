-- [[ 1. 설정 및 변수 ]]
local player = game.Players.LocalPlayer
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local SAFE_ZONE_NAME = "InfiniteSafetyZone"
local HUGE_WALL_NAME = "VipLeftHugeWall"

local currentUpdateLoop = 0 -- 루프 중복 방지용 ID

-- [[ 2. 기존 구조물 완벽 제거 ]]
local function clearAll()
    currentUpdateLoop = currentUpdateLoop + 1 -- 이전 루프 중단 신호
    local s = workspace:FindFirstChild(SAFE_ZONE_NAME)
    if s then s:Destroy() end
    local w = workspace:FindFirstChild(HUGE_WALL_NAME)
    if w then w:Destroy() end
end

-- [[ 3. VIP Bottom 기준 거대 벽 생성 (각도 고정) ]]
local function buildVipWall()
    local bottom = nil
    -- 맵 전체에서 "Bottom" 파트 검색
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Bottom" and v:IsA("BasePart") then
            bottom = v
            break
        end
    end

    if bottom then
        local wall = Instance.new("Part")
        wall.Name = HUGE_WALL_NAME
        wall.Size = Vector3.new(10, 1500, 80000) -- 더 높고 더 길게
        
        -- 핵심: Bottom의 CFrame을 기준으로 정확히 왼쪽(-X)에 배치
        -- Y축 높이는 바닥에서 위로 750만큼 올려서 거대한 벽처럼 보이게 함
        local leftPos = -(bottom.Size.X / 2) - 5
        wall.CFrame = bottom.CFrame * CFrame.new(leftPos, 750, 0)
        
        wall.Anchored = true
        wall.CanCollide = true
        wall.Transparency = 0.5
        wall.BrickColor = BrickColor.new("Really black")
        wall.Material = Enum.Material.Plastic
        wall.Parent = workspace
    end
end

-- [[ 4. 캐릭터 추적 안전 구역 ]]
local function setupSafetyZone()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    local model = Instance.new("Model", workspace)
    model.Name = SAFE_ZONE_NAME
    
    local floor = Instance.new("Part", model)
    floor.Size = Vector3.new(2000, 2, 2000)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0.5
    floor.BrickColor = BrickColor.new("Dark stone grey")

    local function makeW(name, size)
        local p = Instance.new("Part", model)
        p.Name = name
        p.Size = size
        p.Anchored = true
        p.CanCollide = true
        p.Transparency = 0.8
        p.BrickColor = BrickColor.new("Really blue")
        return p
    end

    local wR = makeW("WR", Vector3.new(10, 500, 2000))
    local wL = makeW("WL", Vector3.new(10, 500, 2000))
    local wF = makeW("WF", Vector3.new(2000, 500, 10))
    local wB = makeW("WB", Vector3.new(2000, 500, 10))

    -- 루프 추적 시작
    local myLoopId = currentUpdateLoop
    task.spawn(function()
        local startY = root.Position.Y - 10
        while char and char.Parent and model.Parent and currentUpdateLoop == myLoopId do
            local p = root.Position
            floor.Position = Vector3.new(p.X, startY, p.Z)
            wR.Position = Vector3.new(p.X + 1005, startY + 245, p.Z)
            wL.Position = Vector3.new(p.X - 1005, startY + 245, p.Z)
            wF.Position = Vector3.new(p.X, startY + 245, p.Z + 1005)
            wB.Position = Vector3.new(p.X, startY + 245, p.Z - 1005)
            task.wait()
        end
    end)
end

-- [[ 5. 초기 실행 및 자동 관리 ]]
local function initialize()
    clearAll()
    task.wait(0.5) -- 정리 대기
    buildVipWall()
    setupSafetyZone()
end

-- 실행
initialize()

-- 캐릭터 재생성 시 호출
player.CharacterAdded:Connect(function()
    task.wait(2) -- 맵 로딩 안정화 대기
    initialize()
end)

-- 투명화 유지
task.spawn(function()
    while true do
        for _, obj in pairs(workspace:GetDescendants()) do
            for _, name in pairs(REMOVE_TARGETS) do
                if obj.Name == name and obj:IsA("BasePart") then
                    obj.Transparency = 1
                    obj.CanCollide = false
                end
            end
        end
        task.wait(1)
    end
end)

