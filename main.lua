-- [[ 1. 설정 ]]
local player = game.Players.LocalPlayer
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local SAFE_ZONE_NAME = "InfiniteSafetyZone"

-- [[ 2. VIP 룸 처리 (벽 제거 + 바닥 확장) ]]
local function expandVipRoom()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then

            -- 🔥 벽 전부 제거
            if obj.Name:lower():find("wall") then
                obj:Destroy()
            end

            -- 🔥 VIP 바닥 확장 (위로 말고 X/Z만)
            if obj.Name == "Bottom" then
                obj.Size = Vector3.new(40000, obj.Size.Y, 40000)
                -- 중심 유지 → 앞/뒤/왼/오른쪽으로만 확장됨
                obj.Anchored = true
                obj.CanCollide = true
                obj.Transparency = 0.5
                obj.Color = Color3.fromRGB(99, 95, 98)
            end
        end
    end

    print("✅ 벽 제거 + VIP 바닥 40000x40000 확장 완료")
end

-- [[ 3. 캐릭터 추적 안전 발판 ]]
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
