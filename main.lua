-- [[ 1. 설정 ]]
local MOVE_STUDS = 10 -- 정확히 스터드 10칸 (돌기 10개 분량) 이동
local player = game.Players.LocalPlayer

-- [[ 2. 벽 처리 함수 ]]
local function fixWalls()
    local char = player.Character
    if not char then return end
    local root = char:WaitForChild("HumanoidRootPart")

    -- 워크스페이스의 모든 파트 확인
    for _, obj in pairs(workspace:GetDescendants()) do
        -- 이름이 Bottom이고, 벽(높이가 높음)인 경우만 찾음
        if obj:IsA("BasePart") and obj.Name == "Bottom" then
            
            -- 바닥(얇은거) 말고 벽(두꺼운거)만 골라냄 (높이 5 이상)
            if obj.Size.Y > 5 then
                
                -- 1. 재질을 플라스틱으로 변경 (스터드 무늬 제거)
                obj.Material = Enum.Material.Plastic 
                obj.Transparency = 0.5 -- 반투명
                obj.BrickColor = BrickColor.new("Dark stone grey")
                obj.Anchored = true -- 고정

                -- 2. 위치 이동 (캐릭터 기준 뒤쪽으로 10스터드)
                -- 벽이 캐릭터보다 멀어지는 방향을 계산
                local direction = (obj.Position - root.Position).Unit
                
                -- 위아래(Y축) 이동은 막고, 수평으로만 10칸 밀기
                local moveVector = Vector3.new(direction.X, 0, direction.Z).Unit * MOVE_STUDS
                
                -- CFrame으로 강제 이동 (기존 위치 + 10칸)
                obj.CFrame = obj.CFrame + moveVector
                
                print("✅ 벽("..obj.Name..")을 스터드 "..MOVE_STUDS.."칸 뒤로 밀었습니다.")
            end
        end
    end
end

-- [[ 3. 실행 및 유지 ]]
-- 한번만 하면 게임이 다시 돌려놓을 수 있으니 반복 체크
task.spawn(function()
    while true do
        fixWalls()
        task.wait(2) -- 2초마다 위치 확인해서 다시 밀기
    end
end)

-- 시작 시 바로 실행
fixWalls()
