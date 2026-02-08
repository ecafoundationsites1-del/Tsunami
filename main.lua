-- [1] 벽 제거 및 VIP 통로 개방
local targetNames = {"Part", "VIP", "VIP_PLUS"}

for _, obj in pairs(game.Workspace:GetDescendants()) do
    for _, targetName in pairs(targetNames) do
        if obj.Name == targetName and obj:IsA("BasePart") then
            obj.CanCollide = false -- 통과 가능
            obj.Transparency = 0.5  -- 위치 확인을 위해 반투명하게 설정 (완전 삭제는 1)
            -- obj:Destroy() -- 아예 없애고 싶으면 이 줄의 주석을 푸세요
        end
    end
end

-- [2] 쓰나미 면역 (Hitbox 무력화)
-- 캐릭터의 터치 판정을 조절하여 쓰나미에 닿아도 죽지 않게 시도합니다.
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

for _, part in pairs(character:GetDescendants()) do
    if part:IsA("BasePart") then
        part.CanTouch = false -- 쓰나미(Kill Part)와의 접촉 판정을 끔
    end
end

print("스크립트 활성화: 벽 제거 및 쓰나미 면역 상태입니다.")
