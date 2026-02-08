-- 1. 설정: 대상 벽 이름들
local targetNames = {"Mud", "Part", "VIP", "VIP_PLUS"}
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- 2. 안전 지름길(바닥 및 가이드 벽) 생성 함수
local function createSafetyPath()
    if workspace:FindFirstChild("SafetyPathFolder") then return end -- 이미 있으면 생성 안 함
    
    local folder = Instance.new("Folder", workspace)
    folder.Name = "SafetyPathFolder"
    
    -- [바닥 생성] 상점 방향으로 길게 깔아줌
    local floor = Instance.new("Part", folder)
    floor.Size = Vector3.new(20, 1, 500) -- 가로 20, 두께 1, 길이 500의 긴 바닥
    floor.Position = character.HumanoidRootPart.Position - Vector3.new(0, 3.5, 0) -- 발밑에 생성
    floor.Anchored = true
    floor.Transparency = 0.8 -- 약간 보이게 설정 (완전 투명은 1)
    floor.BrickColor = BrickColor.new("Neon orange") -- 길 확인용 색상
    
    -- [가이드 벽 생성] 옆으로 떨어지지 않게 막아줌
    local wall1 = floor:Clone()
    wall1.Parent = folder
    wall1.Size = Vector3.new(1, 10, 500)
    wall1.Position = floor.Position + Vector3.new(10, 5, 0)
    wall1.Transparency = 1 -- 가이드 벽은 투명하게
    
    local wall2 = wall1:Clone()
    wall2.Parent = folder
    wall2.Position = floor.Position + Vector3.new(-10, 5, 0)
end

-- 3. 실시간 벽 무력화 및 무적 루프
task.spawn(function()
    while task.wait(0.5) do -- 0.5초마다 빠르게 검사
        -- 기존 벽들 통과 가능하게 설정 (투명도는 0으로 유지)
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            for _, name in pairs(targetNames) do
                if obj.Name == name and obj:IsA("BasePart") then
                    obj.CanCollide = false
                    obj.Transparency = 0 -- 요청하신 대로 투명도 0 (보이게 설정)
                    obj.Color = Color3.fromRGB(255, 0, 0) -- 통과 가능한 벽임을 알기 쉽게 빨간색으로 변경 (선택사항)
                end
            end
        end
        
        -- 캐릭터 무적 (쓰나미 판정 무시)
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanTouch = false
                end
            end
        end
    end
end)

-- 실행
createSafetyPath()
print("안전 지름길 생성 및 Mud 벽 무력화 완료!")
