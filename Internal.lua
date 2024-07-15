local Targ = nil 
local Part = nil

local function GetNearestPlayer()
    local A, B = nil, math.huge

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character.PrimaryPart then
            local PrimaryPart = v.Character.PrimaryPart
            local PartPosition, InViewport = game.Workspace.CurrentCamera:WorldToScreenPoint(PrimaryPart.Position)

            if InViewport then
                local D = (Vector2.new(game:GetService("UserInputService"):GetMouseLocation().X, game:GetService("UserInputService"):GetMouseLocation().Y) - Vector2.new(PartPosition.X, PartPosition.Y))
                
                if D.Magnitude < B then 
                    B = D.Magnitude
                    A = v 
                end
            end
        end
    end

    return A
end

local function GetNearestPart()
    local A, B = nil, math.huge 

    if Targ and Targ.Character then
        for _, v in pairs(Targ.Character:GetChildren()) do
            if v and v:IsA("BasePart") then
                local PartPosition, InViewport = game.Workspace.CurrentCamera:WorldToScreenPoint(v.Position)

                if InViewport then 
                    local D = (Vector2.new(game:GetService("UserInputService"):GetMouseLocation().X, game:GetService("UserInputService"):GetMouseLocation().Y) - Vector2.new(PartPosition.X, PartPosition.Y))

                    if D.Magnitude < B then 
                        B = D.Magnitude
                        A = v 
                    end 
                end 
            end
        end
    end

    return A
end

game:GetService("RunService").RenderStepped:Connect(function()
    Targ = GetNearestPlayer()
    Part = GetNearestPart()

    if Targ and Part then 
        print("Target: " .. Targ.Name)
        print("Part: " .. tostring(Part))
    end
end)

local ogNamecall = nil 
ogNamecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    
    if Self == game.Workspace and not checkcaller() then
        if Method == "Raycast" then
            local Origin = Args[1]
            local Direction = Args[2]

            if Part then 
                Direction = (Part.Position - Origin).Unit * 1000              
                Args[2] = Direction
            end
            return ogNamecall(Self, unpack(Args))
            
        elseif Method == "FindPartOnRayWithWhitelist" then
            local NewRay = Args[1]
            local Whitelist = Args[2]
            local IgnoreWater = Args[3] or false

            if Part then 
                local Origin = NewRay.Origin
                local Direction = (Part.Position - Origin).Unit * 1000
                Args[1] = Ray.new(Origin, Direction)
            end
            return ogNamecall(Self, unpack(Args))
        end
    end
    
    return ogNamecall(Self, unpack(Args))
end))
