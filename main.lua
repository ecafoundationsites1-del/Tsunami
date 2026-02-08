-- 제거할 대상 목록
local targetNames = {"Mud", "Part", "VIP", "VIP_PLUS"}

-- 1. 벽 제거 함수
local function clearWalls()
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        for _, name in pairs(targetNames) do
            if obj.Name == name and obj:IsA("BasePart") then
                obj.CanCollide = false
                obj.Transparency = 1
                -- obj:Destroy() -- 완전히 삭제하려면 주석 해제
            end
        end
    end
end

-- 2. 캐릭터 무적(Hitbox 무력화) 함수
local function makeGodMode()
    local char = game.Players.LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanTouch = false
            end
        end
    end
end

-- [메인 루프] 맵 이벤트로 벽이 재생성되는 것을 방지하기 위해 1초마다 실행
task.spawn(function()
    while task.wait(1) do
        clearWalls()
        makeGodMode()
    end
end)

print("쓰나미 브레인롯: 실시간 벽 제거 및 무적 모드 가동 중 (Mud 포함)")
