-- [[ 1. 설정 및 대상 ]]
local player = game.Players.LocalPlayer
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local SAFE_ZONE_NAME = "InfiniteSafetyZone"
local WALL_RETREAT_DISTANCE = 10 -- 벽을 후퇴시킬 거리 (10스터드)

-- [[ 2. VIP 룸 직접 확장 및 벽 후퇴 함수 ]]
local function expandVipRoom()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local rootPos = char.HumanoidRootPart.Position

    -- 워크스페이스에서 파트들을 찾습니다.
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            -- 1. 바닥 확장 (이름이 Bottom인 경우)
            if obj.Name == "Bottom" then
                obj.Size = Vector3.new(20000, obj.Size.Y, 20000)
                obj.CanCollide = true
                obj.Transparency = 0.5
                obj.BrickColor = BrickColor.new("Dark stone grey")
                obj.Anchored = true
            end
            
            -- 2. 벽 확장 및 10스터드 후퇴
            if obj.Name:lower():find("wall") and (obj.Position - rootPos).Magnitude < 500 then
                -- 높이 확장 (위아래로 늘림)
                local currentSize = obj.Size
                obj.Size = Vector3.new(currentSize.X, currentSize.Y + 400, currentSize.Z)
                
                -- [핵심] 캐릭터 중심에서 벽을 바라보는 방향으로 10스터드 후퇴
                local direction = (obj.Position - rootPos).Unit
                -- Y축 이동은 고정하고 X, Z축 방향으로만 밀어냄
                local moveVector = Vector3.new(direction.X, 0, direction.Z).Unit * WALL_RETREAT_DISTANCE
                
                obj.CFrame = obj.CFrame + moveVector
                obj.CanCollide = true
                obj.Transparency = 0.5
                obj.Anchored = true -- 위치 고정
            end
        end
    end
    print("✅ VIP 룸 바닥 확장 및 벽 " .. WALL_RETREAT_DISTANCE .. "스터드 후퇴 완료")
end

-- [[ 3. 내 캐릭터 추적 안전 발판 ]]
local function setupSafetyZone()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    if workspace:FindFirstChild(SAFE_ZONE_NAME) then workspace[SAFE_ZONE_NAME]:Destroy() end
    
    local model = Instance.new("Model", workspace)
    model.Name = SAFE_ZONE_NAME
    
    local floor = Instance.new("Part", model)
    floor.Size = Vector3.new(2000, 2, 2000)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0.6
    floor.BrickColor = BrickColor.new("Dark stone grey")
    floor.Material = Enum.Material.Plastic

    task.spawn(function()
        local startY = root.Position.Y - 10
        while char and char.Parent and model.Parent do
            if root and root.Parent then
                floor.Position = Vector3.new(root.Position.X, startY, root.Position.Z)
            end
            task.wait()
        end
    end)
end

-- [[ 4. 실행 및 관리 ]]
local function runScript()
    expandVipRoom()
    setupSafetyZone()
end

-- 초기 실행
runScript()

-- 리스폰 시 재생성
player.CharacterAdded:Connect(function()
    task.wait(2)
    runScript()
end)

-- 투명화 루프 (장애물 제거)
task.spawn(function()
    while true do
        for _, obj in pairs(workspace:GetDescendants()) do
            for _, targetName in pairs(REMOVE_TARGETS) do
                -- 벽(Wall)이나 바닥(Bottom)은 투명화 대상에서 제외 (밀어낸 상태 유지)
                if obj.Name == targetName and obj:IsA("BasePart") and obj.Name ~= "Bottom" and not obj.Name:lower():find("wall") then
                    obj.Transparency = 1
                    obj.CanCollide = false
                end
            end
        end
        task.wait(1)
    end
end)
