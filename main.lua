-- [[ 1. 설정 및 대상 ]]
local player = game.Players.LocalPlayer
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local SAFE_ZONE_NAME = "InfiniteSafetyZone"

-- [[ 2. VIP 룸 직접 확장 함수 ]]
local function expandVipRoom()
    -- 워크스페이스에서 VIP 관련 파트들을 찾습니다.
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            -- 1. 바닥 확장 (이름이 Bottom인 경우)
            if obj.Name == "Bottom" then
                obj.Size = Vector3.new(20000, obj.Size.Y, 20000)
                obj.CanCollide = true
                obj.Transparency = 0.5 -- 발판 확인용
                obj.BrickColor = BrickColor.new("Dark stone grey")
            end
            
            -- 2. 벽 확장 (이름에 Wall이 들어가거나 VIP 룸의 벽으로 추정되는 파트)
            -- 보통 VIP룸의 벽들은 "Wall"이라는 이름을 포함하거나 Bottom 주변에 있습니다.
            if obj.Name:lower():find("wall") and (obj.Position - player.Character.HumanoidRootPart.Position).Magnitude < 500 then
                -- 위아래로 200스터드씩 늘림 (현재 높이에서 Y축 크기 증가 및 위치 보정)
                local currentSize = obj.Size
                obj.Size = Vector3.new(currentSize.X, currentSize.Y + 400, currentSize.Z)
                obj.CFrame = obj.CFrame * CFrame.new(0, 0, 0) -- 위치 고정
                obj.CanCollide = true
                obj.Transparency = 0.5
            end
        end
    end
    print("✅ VIP 룸 바닥(2만x2만) 및 벽(위아래 200) 확장 완료")
end

-- [[ 3. 내 캐릭터 추적 안전 발판 (기존 기능 유지) ]]
local function setupSafetyZone()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    -- 기존 구역 삭제
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

-- 죽었을 때 다시 실행 (VIP룸 파트는 서버 파트일 경우 유지되지만, 안전을 위해 재호출)
player.CharacterAdded:Connect(function()
    task.wait(2)
    runScript()
end)

-- 투명화 루프
task.spawn(function()
    while true do
        for _, obj in pairs(workspace:GetDescendants()) do
            for _, targetName in pairs(REMOVE_TARGETS) do
                if obj.Name == targetName and obj:IsA("BasePart") and obj.Name ~= "Bottom" then
                    obj.Transparency = 1
                    obj.CanCollide = false
                end
            end
        end
        task.wait(1)
    end
end)

