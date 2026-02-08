-- 특정 이름을 가진 모든 파트를 찾아 처리하는 함수
local targetNames = {"Part", "VIP", "VIP_PLUS"}

for _, obj in pairs(game.Workspace:GetDescendants()) do
    for _, targetName in pairs(targetNames) do
        if obj.Name == targetName and obj:IsA("BasePart") then
            -- 방법 1: 아예 삭제하기 (지도로부터 사라짐)
            obj:Destroy() 
            
            -- 방법 2: (삭제가 안 될 경우 대비) 투명화 및 충돌 해제
            -- obj.Transparency = 1
            -- obj.CanCollide = false
        end
    end
end

print("쓰나미 브레인롯: 지정된 벽들이 제거되었습니다!")
