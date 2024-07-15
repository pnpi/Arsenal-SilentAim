local ogNamecall = nil 
ogNamecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
      local Args = {...}
      local Method = getnamecallmethod()
      
      print("Called method: ", Method)
      
      return ogNamecall(Self, ...)
end))
