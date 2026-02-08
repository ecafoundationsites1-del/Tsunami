-- [[ 1. 설정 ]]
local player = game.Players.LocalPlayer
local SAFE_ZONE_NAME = "UprightStableZone"
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local PUSH_DISTANCE = 10 -- 벽을 뒤로 밀 거리

-- [[ 2. 이전 구조물 제거 ]]
local function clearOld()
    local old = workspace:FindFirstChild(SAFE_ZONE_NAME)
    if old then old:Destroy() end
end

-- [[ 3. 환경 재구축 (Cosmic 확장, Bottom 구분 및 벽 밀기) ]]
local function rebuild()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            -- 1. Cosmic 파트 확장
            if v.Name == "Cosmic" then
                v.Size = Vector3.new(40000, 5, 40000)
                v.Anchored = true
                v.CanCollide = true
                v.Transparency = 0.5
            
            -- 2. Bottom 이름의 파트 처리 (바닥 vs 벽 구분)
            elseif v.Name == "Bottom" then
                -- Y축 높이가 10보다 크면 '벽'으로 간주
                if v.Size.Y > 10 then
                    v.Material = Enum.Material.Plastic -- 재질을 플라스틱으로 변경
                    v.Transparency = 0.5 -- 시야 확보용
                    v.Anchored = true
                    
                    -- 캐릭터가 있다면 캐릭터 반대 방향으로 10스터드 밀기
                    if root then
                        local diff = v.Position - root.Position
                        local pushDir = Vector3.new(diff.X, 0, diff.Z).Unit -- 수평 방향 계산
                        v.CFrame = v.CFrame + (pushDir * PUSH_DISTANCE)
                    end
                    
                    -- 벽 높이도 아주 높게 보정
                    v.Size = Vector3.new(v.Size.X, 1000, v.Size.Z)
                else
                    -- 진짜 '바닥'인 경우 (Cosmic처럼 확장하고 싶을 때)
                    v.Size = Vector3.new(40000, v.Size.Y, 40000)
                    v.Anchored = true
                end
            end
        end
    end
    print("✅ Cosmic 확장 및 Bottom 벽(플라스틱) 밀기 완료")
end

-- [[ 4. 실행 로직 ]]
local function run()
    clearOld()
    rebuild()
end

-- 초기 실행 및 캐릭터 재생성 시 실행
run()
player.CharacterAdded:Connect(function()
    task.wait(2)
    run()
end)

-- [[ 5. 투명화 및 실시간 벽 체크 루프 ]]
task.spawn(function()
    while true do
        for _, obj in pairs(workspace:GetDescendants()) do
            -- 제거 대상 투명화
            for _, n in pairs(REMOVE_TARGETS) do
                if obj.Name == n and obj:IsA("BasePart") then
                    -- Cosmic이나 진짜 바닥(Bottom 중 낮은 것)은 제외
                    if obj.Name ~= "Cosmic" and not (obj.Name == "Bottom" and obj.Size.Y <= 10) then
                        obj.Transparency = 1
                        obj.CanCollide = false
                    end
                end
            end
        end
        task.wait(2) -- 주기적으로 실행하여 새로 생기는 벽 대응
    end
end)
