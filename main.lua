-- 쓰나미 브레인롯 개발자용 정리 스크립트
local workspace = game.Workspace

for _, obj in pairs(workspace:GetDescendants()) do
    -- 1. "VIP"가 이름에 포함된 파트 충돌 끄기
    if obj:IsA("BasePart") and string.find(obj.Name, "VIP") then
        obj.CanCollide = false
        -- 확인용 (선택 사항)
        obj.Transparency = 0.5 
    end

    -- 2. "Wall" (벽), "Part" (VIP 제외), "Mud" 이름인 개체 삭제
    -- 주의: VIP 파트는 위에서 처리했으므로 삭제 대상에서 제외했습니다.
    if obj.Name == "Wall" or (obj.Name == "Part" and not string.find(obj.Name, "VIP")) or obj.Name == "Mud" then
        obj:Destroy()
    end

    -- 3. "Cosmic"과 "Common" 파트 확장 (900,000 x 900,000)
    if obj:IsA("BasePart") and (obj.Name == "Cosmic" or obj.Name == "rare") then
        obj.Size = Vector3.new(900000, obj.Size.Y, 900000)
        -- 너무 커서 위치가 틀어질 수 있으니 중심 고정
        obj.Anchored = true 
    end
end

print("정리 완료! 벽과 진흙은 사라졌고, 우주는 넓어졌습니다.")
