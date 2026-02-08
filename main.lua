-- [[ 1. 설정 ]]
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local PUSH_DIST = 10 -- 10스터드 후퇴
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}

-- 벽들의 고정 좌표를 저장할 테이블
local fixedWalls = {}

-- [[ 2. 핵심 실행 함수 ]]
local function forceUltimate()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            
            -- [A] Bottom 이름의 '벽' 처리 (높이가 있는 것)
            if v.Name == "Bottom" and v.Size.Y > 5 then
                -- 1. 무조건 통과하게 만듦 (매 프레임 실행)
                v.CanCollide = false 
                v.Material = Enum.Material.Plastic
                v.Transparency = 0.5
                v.Anchored = true

                -- 2. 좌표가 계산되지 않았다면 10칸 뒤 위치 계산
                if not fixedWalls[v] then
                    local diff = (v.Position - root.Position) * Vector3.new(1, 0, 1)
                    if diff.Magnitude > 0 then
                        local pushDir = diff.Unit
                        fixedWalls[v] = v.CFrame + (pushDir * PUSH_DIST)
                    end
                end

                -- 3. 위치 강제 박제
                if fixedWalls[v] then
                    v.CFrame = fixedWalls[v]
                end

            -- [B] 진짜 바닥 확장 (발판은 통과되면 안 되므로 CanCollide = true)
            elseif v.Name == "Cosmic" or (v.Name == "Bottom" and v.Size.Y <= 5) then
                if v.Size.X < 20000 then
                    v.Size = Vector3.new(9990000, v.Size.Y, 9990000)
                    v.Anchored = true
                end
                v.CanCollide = true -- 바닥은 밟아야 하니까요!
            end
            
            -- [C] 기타 장애물 (Mud 등) 무조건 투명 + 통과
            for _, targetName in pairs(REMOVE_TARGETS) do
                if v.Name == targetName and v.Name ~= "Bottom" and v.Name ~= "Cosmic" then
                    v.Transparency = 1
                    v.CanCollide = false
                end
            end
        end
    end
end

-- [[ 3. 무한 루프 고정 (0.01초 간격) ]]
RunService.Heartbeat:Connect(forceUltimate)

-- 리스폰 시 초기화
player.CharacterAdded:Connect(function()
    fixedWalls = {}
    task.wait(1)
end)

print("✅ 통과 기능(NoClip) 및 10칸 후퇴 통합 완료!")
