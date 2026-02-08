local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- 1. 설정: 벽 이름과 권한 확인 (개발자님의 설정에 맞춤)
local targetWall = workspace:FindFirstChild("Part") -- 없애려는 벽의 이름

-- 2. VIP 여부 확인 (게임 내 VIP 시스템 방식에 따라 수정이 필요할 수 있습니다)
-- 보통 GamePass를 사용하거나 특정 스탯을 확인합니다.
local isVIP = player:FindFirstChild("VIP") -- 일반 VIP
local isVIPPlus = player:FindFirstChild("VIP_PLUS") -- VIP+

-- 3. 벽 제거 실행
if targetWall then
    if isVIP or isVIPPlus then
        -- 방법 A: 아예 삭제하기
        targetWall:Destroy() 
        print("VIP 확인됨: 지름길 벽을 제거했습니다.")
        
        -- 방법 B: (권장) 투명하게 만들고 통과 가능하게 하기 (시각적 피드백 유지)
        -- targetWall.Transparency = 0.5 
        -- targetWall.CanCollide = false
    else
        print("VIP 권한이 없습니다.")
    end
end

