local ogNamecall = nil 
ogNamecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    
    if Self == game.Workspace and not checkcaller() then
        if Method == "Raycast" then
            local Origin = Args[1]
            local Direction = Args[2]
            print("Raycast called with Origin:", Origin, "Direction:", Direction)
            
        elseif Method == "FindPartOnRayWithWhitelist" then
            local Ray = Args[1]
            local Whitelist = Args[2]
            local IgnoreWater = Args[3] or false
            print("FindPartOnRayWithWhitelist called with Ray:", Ray, "Whitelist:", Whitelist, "IgnoreWater:", IgnoreWater)
        end
    end
    
    return ogNamecall(Self, ...)
end))
