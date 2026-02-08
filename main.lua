-- [[ 1. 기본 설정 ]]
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"} -- 투명하게 만들 벽들
local HIGHWAY_NAME = "VipCustomHighWay"
local player = game.Players.LocalPlayer

-- [[ 2. 고속도로 건설 함수 (불투명, VIP 스타일) ]]
local function buildRoad()
    -- 이미 길이 있다면 삭제하고 다시 생성 (위치 갱신용)
    local existing = workspace:FindFirstChild(HIGHWAY_NAME)
    if existing then existing:Destroy() end
    
    local roadModel = Instance.new("Model", workspace)
    roadModel.Name = HIGHWAY_NAME
    
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- [바닥] VIP 룸 바닥처럼 쨍한 네온 초록색 (불투명)
    local floor = Instance.new("Part", roadModel)
    floor.Name = "Floor"
    floor.Size = Vector3.new(30, 1, 2000) -- 너비 30, 길이 2000 (매우 길게)
    floor.Position = root.Position - Vector3.new(0, 3.5, 0)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0 -- 불투명
    floor.Material = Enum.Material.Neon
    floor.BrickColor = BrickColor.new("Lime green") 

    -- [왼쪽 벽] 상점 끝까지 이어지는 가이드 (불투명)
    local wallL = Instance.new("Part", roadModel)
    wallL.Size = Vector3.new(1, 20, 2000)
    wallL.Position = floor.Position + Vector3.new(15, 10, 0)
    wallL.Anchored = true
    wallL.CanCollide = true
    wallL.Transparency = 0
    wallL.BrickColor = BrickColor.new("Really blue")
    wallL.Material = Enum.Material.Glass

    -- [오른쪽 벽] 반대편 가이드
    local wallR = wallL:Clone()
    wallR.Parent = roadModel
    wallR.Position = floor.Position + Vector3.new(-15, 10, 0)
end

-- [[ 3. 실시간 무한 루프 (이벤트 대응 및 벽 투명화) ]]
task.spawn(function()
    while task.wait(0.2) do -- 0.2초마다 맵 전체 스캔
        -- 지정된 벽들 투명도 1(100%)로 만들고 통과 가능하게 설정
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            for _, name in pairs(REMOVE_TARGETS) do
                if obj.Name == name and obj:IsA("BasePart") then
                    obj.Transparency = 1 
                    obj.CanCollide = false
                end
            end
        end
        
        -- 쓰나미 면역 (Hitbox 제거)
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
buildRoad()
print("VIP 고속도로 완료! 모든 장애물은 투명화되었습니다.")
