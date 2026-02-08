-- 1. 설정: 없앨 벽 이름과 바닥/벽 속성
local transparentWalls = {"Mud", "Part", "VIP", "VIP_PLUS"}
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- 2. VIP 바닥 및 가이드 벽 생성 (상점까지 쭈욱 이어짐)
local function createExtendedVipPath()
    if workspace:FindFirstChild("VipHighWay") then 
        workspace.VipHighWay:Destroy() -- 기존 길이 있다면 갱신을 위해 삭제
    end
    
    local highway = Instance.new("Model", workspace)
    highway.Name = "VipHighWay"
    
    -- [바닥 연장] VIP 룸 바닥 느낌의 색상과 재질
    local floor = Instance.new("Part", highway)
    floor.Name = "ExtendedFloor"
    floor.Size = Vector3.new(30, 1, 1000) -- 너비 30, 길이 1000 (아주 길게)
    floor.Position = character.HumanoidRootPart.Position - Vector3.new(0, 3.5, 0)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 0 -- 불투명
    floor.BrickColor = BrickColor.new("Bright yellow") -- VIP 느낌의 노란색 바닥
    floor.Material = Enum.Material.Neon
    
    -- [왼쪽 벽]
    local wallL = Instance.new("Part", highway)
    wallL.Size = Vector3.new(1, 15, 1000)
    wallL.Position = floor.Position + Vector3.new(15, 7, 0)
    wallL.Anchored = true
    wallL.Transparency = 0
    wallL.BrickColor = BrickColor.new("Really blue") -- 파란색 벽
    wallL.Material = Enum.Material.Glass

    -- [오른쪽 벽]
    local wallR = wallL:Clone()
    wallR.Parent = highway
    wallR.Position = floor.Position + Vector3.new(-15, 7, 0)
end

-- 3. 실시간 감시 루프 (이벤트 대응)
task.spawn(function()
    while task.wait(0.5) do
        -- 특정 벽들은 투명도 100% 및 충돌 해제
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            for _, name in pairs(transparentWalls) do
                if obj.Name == name and obj:IsA("BasePart") then
                    obj.Transparency = 1 -- 100% 투명
                    obj.CanCollide = false -- 통과 가능
                end
            end
        end
        
        -- 캐릭터 무적 (쓰나미 접촉 무시)
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanTouch = false
                end
            end
        end
    end
end)

-- 고속도로 생성 실행
createExtendedVipPath()
print("VIP 고속도로 건설 완료! 기존 벽들은 투명해졌습니다.")
