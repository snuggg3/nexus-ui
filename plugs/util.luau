local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/snuggg3/nexus-ui/refs/heads/main/source.luau"))()
local Window = Library:CreateWindow("Project Nexus")

local UtilTab = Window:CreateTab("Util")

UtilTab:CreateButton("Run Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

UtilTab:CreateButton("Run Simple Spy", function()
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpyBeta.lua"))()
end)

UtilTab:CreateButton("Run Owl Hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt"))();
end)

UtilTab:CreateButton("Server Hop", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Vcsk/RobloxScripts/refs/heads/main/ServerHop.lua"))();
end)
