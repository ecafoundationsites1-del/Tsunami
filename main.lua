-- [[ 1. 설정 ]]
local player = game.Players.LocalPlayer
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local SAFE_ZONE_NAME = "InfiniteSafetyZone"
local WALL_RETREAT_DISTANCE = 10

-- [[ 2. VIP 룸 확장 ]]
local function expandVipRoom()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local vipBottom = nil

    -- 먼저 VIP 바닥 찾기
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Bottom" then
            vipBottom = obj
            obj.Size = Vector3.new(20000, obj.Size.Y, 20000)
            obj.Anchored = true
            obj.CanCollide = true
            obj.Transparency = 0.5
            obj.Color = Color3.fromRGB(99, 95, 98)
            break
        end
    end

    if not vipBottom then return end
    local center = vipBottom.Position

    -- 벽 처리
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("wall") then
            if (obj.Position - center).Magnitude < 600 then

                -- 높이 위로 확장
                local oldSize = obj.Size
                obj.Size = Vector3.new(oldSize.X, oldSize.Y + 400, oldSize.Z)
                obj.CFrame = obj.CFrame * CFrame.new(0, 200, 0)

                -- 🔥 VIP 중심 기준 바깥쪽으로 10스터드
                local dir = (obj.Position - center)
                local flatDir = Vector3.new(dir.X, 0, dir.Z)

                if flatDir.Magnitude > 0 then
                    obj.CFrame = obj.CFrame + flatDir.Unit * WALL_RETREAT_DISTANCE
                end

                obj.Anchored = true
                obj.CanCollide = true
                obj.Transparency = 0.5
            end
        end
    end

    print("✅ VIP룸 정상 확장 완료 (입구 안 막힘)")
end

-- [[ 3. 안전 발판 ]]
local function setupSafetyZone()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    if workspace:FindFirstChild(SAFE_ZONE_NAME) then
        workspace[SAFE_ZONE_NAME]:Destroy()
    end

    local model = Instance.new("Model", workspace)
    model.Name = SAFE_ZONE_NAME

    local floor = Instance.new("Part", model)
    floor.Size = Vector3.new(2000, 2, 2000)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0.6
    floor.Color = Color3.fromRGB(99, 95, 98)

    task.spawn(function()
        while root and root.Parent do
            floor.Position = root.Position - Vector3.new(0, 6, 0)
            task.wait()
        end
    end)
end

-- [[ 4. 실행 ]]
local function runScript()
    expandVipRoom()
    setupSafetyZone()
end

runScript()

player.CharacterAdded:Connect(function()
    task.wait(2)
    runScript()
end)

-- [[ 5. 장애물 투명화 ]]
task.spawn(function()
    while true do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                for _, name in pairs(REMOVE_TARGETS) do
                    if obj.Name:find(name)
                    and obj.Name ~= "Bottom"
                    and not obj.Name:lower():find("wall") then
                        obj.Transparency = 1
                        obj.CanCollide = false
                    end
                end
            end
        end
        task.wait(1)
    end
end)
