repeat wait(0.1) until game:IsLoaded()

getgenv().Star = "⭐"
getgenv().Danger = "⚠️"
getgenv().ExploitSpecific = "📜"

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/jeqshka/jeq-bss/main/liblary.lua"))()
getgenv().api = loadstring(game:HttpGet("https://raw.githubusercontent.com/jeqshka/jeq-bss/main/jequi.lua"))()
local bssapi = loadstring(game:HttpGet("https://raw.githubusercontent.com/jeqshka/jeq-bss/main/jeqapi.lua"))()
