local ogNamecall = nil 
ogNamecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
      local Args = {...}
      local Method = getnamecallmethod()
      
      if Self == game.Workspace then
        print("Methods called by workspace: ", Method) 
      end
      
      return ogNamecall(Self, ...)
end))
