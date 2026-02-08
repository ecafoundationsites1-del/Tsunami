-- 설정 값
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local player = game.Players.LocalPlayer

-- 고속도로 및 가이드 벽 생성 함수
local function buildHighWay()
    if workspace:FindFirstChild("DevHighWay") then workspace.DevHighWay:Destroy() end
    
    local folder = Instance.new("Folder", workspace)
    folder.Name = "DevHighWay"
    
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- [불투명한 노란 바닥] - VIP 구역 끝까지 연장
    local floor = Instance.new("Part", folder)
    floor.Size = Vector3.new(40, 1, 2000) -- 아주 길게 설정
    floor.Position = root.Position - Vector3.new(0, 3.5, 0)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0 -- 불투명 (요청사항)
    floor.BrickColor = BrickColor.new("Bright yellow")
    floor.Material = Enum.Material.Neon

    -- [불투명한 사이드 벽] - 낙사 방지
    local leftWall = Instance.new("Part", folder)
    leftWall.Size = Vector3.new(1, 20, 2000)
    leftWall.Position = floor.Position + Vector3.new(20, 10, 0)
    leftWall.Anchored = true
    leftWall.Transparency = 0 -- 불투명 (요청사항)
    leftWall.BrickColor = BrickColor.new("Really blue")
    
    local rightWall = leftWall:Clone()
    rightWall.Parent = folder
    rightWall.Position = floor.Position + Vector3.new(-20, 10, 0)
end

-- 실시간 감시 (이벤트 대응 및 투명화)
task.spawn(function()
    while task.wait(0.3) do -- 더 빠르게 감시
        for _, v in pairs(game.Workspace:GetDescendants()) do
            for _, name in pairs(REMOVE_TARGETS) do
                if v.Name == name and v:IsA("BasePart") then
                    v.Transparency = 1 -- 100% 투명화
                    v.CanCollide = false -- 통과 가능
                end
            end
        end
        
        -- 캐릭터 무적 유지
        if player.Character then
            for _, p in pairs(player.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanTouch = false end
            end
        end
    end
end)

buildHighWay()
print("개발자 전용 고속도로 건설 및 모든 벽 투명화 완료!")
