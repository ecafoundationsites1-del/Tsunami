-- [[ 1. 설정 및 대상 ]]
local player = game.Players.LocalPlayer
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local SAFE_ZONE_NAME = "InfiniteSafetyZone"

-- [[ 2. 환경 수정 함수 ]]
local function updateEnvironment()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local rootPos = char.HumanoidRootPart.Position

    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            -- 1. 바닥 확장 (이름이 Bottom인 경우)
            if obj.Name == "Bottom" then
                obj.Size = Vector3.new(20000, obj.Size.Y, 20000)
                obj.CanCollide = true
                obj.Transparency = 0.5
                obj.Anchored = true
            end
            
            -- 2. 벽 확장 및 뒤로 밀기 (10스터드 추가 이동)
            if obj.Name:lower():find("wall") and (obj.Position - rootPos).Magnitude < 500 then
                -- 높이 확장
                local currentSize = obj.Size
                obj.Size = Vector3.new(currentSize.X, currentSize.Y + 400, currentSize.Z)
                
                -- 방향 계산: 캐릭터에서 벽을 바라보는 방향으로 10스터드 밀기
                local direction = (obj.Position - rootPos).Unit
                -- Y축 이동은 방지하고 X, Z축으로만 밀어냄
                obj.Position = obj.Position + Vector3.new(direction.X * 10, 0, direction.Z * 10)
                
                obj.CanCollide = true
                obj.Transparency = 0.5
                obj.Anchored = true
            end

            -- 3. 장애물 투명화
            for _, targetName in pairs(REMOVE_TARGETS) do
                if obj.Name == targetName and obj.Name ~= "Bottom" then
                    obj.Transparency = 1
                    obj.CanCollide = false
                end
            end
        end
    end
    print("✅ 벽 10스터드 뒤로 이동 및 확장 완료")
end

-- [[ 3. 내 캐릭터 추적 안전 발판 ]]
local function setupSafetyZone()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    if workspace:FindFirstChild(SAFE_ZONE_NAME) then workspace[SAFE_ZONE_NAME]:Destroy() end
    
    local floor = Instance.new("Part", workspace)
    floor.Name = SAFE_ZONE_NAME
    floor.Size = Vector3.new(2000, 2, 2000)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0.6
    floor.BrickColor = BrickColor.new("Dark stone grey")

    task.spawn(function()
        local startY = root.Position.Y - 10
        while char and char.Parent do
            if root and root.Parent then
                floor.Position = Vector3.new(root.Position.X, startY, root.Position.Z)
            end
            task.wait()
        end
    end)
end

-- 실행 및 재시작 설정
player.CharacterAdded:Connect(function()
    task.wait(2)
    updateEnvironment()
    setupSafetyZone()
end)

-- 초기 실행
updateEnvironment()
setupSafetyZone()
