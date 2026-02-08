local workspace = game.Workspace

for _, obj in pairs(workspace:GetDescendants()) do
    -- 1. 이름에 "VIP" 포함 시 충돌만 끄기 (삭제 X)
    if obj:IsA("BasePart") and string.find(obj.Name, "VIP") then
        obj.CanCollide = false
    end

    -- 2. Wall, Part(VIP 제외), Mud 삭제
    if obj.Name == "Wall" or (obj.Name == "Part" and not string.find(obj.Name, "VIP")) or obj.Name == "Mud" then
        obj:Destroy()
    end

    -- 3. Common이랑 Cosmic만 거대하게 확장
    if obj:IsA("BasePart") and (obj.Name == "Common" or obj.Name == "Cosmic") then
        obj.Size = Vector3.new(900000, obj.Size.Y, 900000)
        obj.Anchored = true -- 맵이 너무 커서 렉 방지를 위해 고정 필수
    end
end

print("작업 완료: Common & Cosmic 확장 / VIP 충돌 OFF / 나머지 청소 끝!")
