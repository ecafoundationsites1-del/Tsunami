-- [[ 1. 기본 설정 ]]
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local HIGHWAY_NAME = "PerfectSafetyWay"
local player = game.Players.LocalPlayer

-- [[ 2. 바닥 매꾸기 및 고속도로 생성 (불투명) ]]
local function buildSolidPath()
    local existing = workspace:FindFirstChild(HIGHWAY_NAME)
    if existing then existing:Destroy() end
    
    local roadModel = Instance.new("Model", workspace)
    roadModel.Name = HIGHWAY_NAME
    
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- [거대 바닥] 기존 바닥의 구멍을 완전히 덮어버리는 넓고 긴 판자
    local floor = Instance.new("Part", roadModel)
    floor.Name = "SolidFloor"
    -- 너비를 100으로 넓혀서 웬만한 구멍은 다 덮습니다. 길이는 2500으로 상점 끝까지!
    floor.Size = Vector3.new(100, 1.2, 2500) 
    floor.Position = root.Position - Vector3.new(0, 3.4, 0) -- 발 밑에 딱 붙게 설정
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0 -- 불투명 (VIP 바닥 스타일)
    floor.Material = Enum.Material.Neon
    floor.BrickColor = BrickColor.new("Lime green") -- VIP룸 초록색

    -- [왼쪽 벽] 낙사 방지 가이드
    local wallL = Instance.new("Part", roadModel)
    wallL.Size = Vector3.new(1, 25, 2500)
    wallL.Position = floor.Position + Vector3.new(50, 12, 0) -- 바닥 끝에 맞춤
    wallL.Anchored = true
    wallL.CanCollide = true
    wallL.Transparency = 0
    wallL.BrickColor = BrickColor.new("Really blue") -- VIP룸 파란벽 스타일

    -- [오른쪽 벽]
    local wallR = wallL:Clone()
    wallR.Parent = roadModel
    wallR.Position = floor.Position + Vector3.new(-50, 12, 0)
end

-- [[ 3. 실시간 무한 루프 (장애물 제거 및 무적) ]]
task.spawn(function()
    while task.wait(0.2) do
        -- 1) 쓰나미 벽 및 이벤트 벽 투명화
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
buildSolidPath()
print("대장님! 구멍 없는 VIP 고속도로 건설 완료했습니다.")
