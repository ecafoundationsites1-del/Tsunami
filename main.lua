-- [[ 1. 설정 ]]
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local REMOVE_TARGETS = {"Mud", "Part", "VIP", "VIP_PLUS"}
local EXPAND_SIZE = 900000 -- 요청하신 90만 스터드

-- [[ 2. 핵심 실행 함수 ]]
local function updateEnvironment()
    local char = player.Character
    if not char then return end

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            
            -- [핵심 1] 이름이 Bottom이면 무조건 삭제
            if v.Name == "Bottom" then
                v:Destroy()
            
            -- [핵심 2] Cosmic 파트 90만 x 90만 확장 (위아래 높이는 유지)
            elseif v.Name == "Cosmic" then
                -- 매 프레임마다 크기를 강제로 90만으로 고정
                v.Size = Vector3.new(EXPAND_SIZE, v.Size.Y, EXPAND_SIZE)
                v.Anchored = true
                v.CanCollide = true
                v.Transparency = 0.5
                -- 위치가 맵 중앙에서 벗어나지 않도록 설정 (필요 시)
                -- v.CFrame = CFrame.new(v.Position.X, v.Position.Y, v.Position.Z)
            end
            
            -- [3] 기타 제거 대상 처리 (Mud 등)
            for _, targetName in pairs(REMOVE_TARGETS) do
                if v.Name == targetName and v.Name ~= "Cosmic" then
                    v.Transparency = 1
                    v.CanCollide = false
                end
            end
        end
    end
end

-- [[ 3. 무한 감시 및 강제 실행 ]]
-- Heartbeat를 사용하여 게임이 크기를 되돌리거나 Bottom을 생성할 틈을 주지 않음
RunService.Heartbeat:Connect(updateEnvironment)

-- 리스폰 시 대응
player.CharacterAdded:Connect(function()
    task.wait(1)
    updateEnvironment()
end)

print("🚀 스크립트 가동: Bottom 삭제 및 Cosmic 90만 확장 완료!")
