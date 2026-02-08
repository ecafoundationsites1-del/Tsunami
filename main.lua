-- [[ 1. 설정 ]]
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local PUSH_DIST = 10 -- 정확히 스터드 10칸 뒤로 후퇴
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}

-- 벽들의 고정 좌표를 저장할 테이블
local fixedWalls = {}

-- [[ 2. 환경 재구축 및 강제 고정 함수 ]]
local function forceProcess()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            -- [A] 바닥 확장 (Cosmic 및 진짜 낮은 바닥)
            if v.Name == "Cosmic" or (v.Name == "Bottom" and v.Size.Y <= 5) then
                if v.Size.X < 20000 then
                    v.Size = Vector3.new(40000, v.Size.Y, 40000)
                    v.Anchored = true
                end
            
            -- [B] Bottom 이름의 '벽' (캐릭터보다 높은 위치의 파트)
            elseif v.Name == "Bottom" and v.Size.Y > 5 then
                -- 아직 고정 좌표가 계산되지 않았다면
                if not fixedWalls[v] then
                    v.Material = Enum.Material.Plastic -- 스터드 제거
                    v.Transparency = 0.5
                    v.CanCollide = false -- 통과 가능
                    v.Anchored = true

                    -- 캐릭터에서 벽을 바라보는 방향으로 10칸 계산
                    local diff = (v.Position - root.Position) * Vector3.new(1, 0, 1)
                    if diff.Magnitude > 0 then
                        local pushDir = diff.Unit
                        -- 벽의 새로운 고정 위치 결정
                        local targetCFrame = v.CFrame + (pushDir * PUSH_DIST)
                        fixedWalls[v] = targetCFrame
                    end
                end

                -- [핵심] 게임이 벽을 되돌려도 매 프레임마다 강제로 고정 좌표에 박아버림
                if fixedWalls[v] then
                    v.CFrame = fixedWalls[v]
                    v.Size = Vector3.new(v.Size.X, 500, v.Size.Z) -- 벽 높이 고정
                end
            end
            
            -- [C] 기타 장애물 제거
            for _, targetName in pairs(REMOVE_TARGETS) do
                if v.Name == targetName and v.Name ~= "Bottom" and v.Name ~= "Cosmic" then
                    v.Transparency = 1
                    v.CanCollide = false
                end
            end
        end
    end
end

-- [[ 3. 실행 루프 ]]
-- Heartbeat를 사용하여 게임 시스템보다 더 빠르게 위치를 강제합니다.
RunService.Heartbeat:Connect(forceProcess)

-- 리스폰 시 벽 고정 데이터 초기화 (새 위치에서 다시 밀기 위해)
player.CharacterAdded:Connect(function()
    fixedWalls = {} 
    task.wait(1)
end)

print("✅ 모든 기능 통합 완료: 벽이 10칸 뒤로 강제 박제되었습니다.")
