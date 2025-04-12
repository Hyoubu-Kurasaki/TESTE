
if not _G.P2Win.Key or not _G.P2Win.Type then
    return
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")

local API = "https://hyoubu.discloud.app/" .. _G.P2Win.Type .. "/" ..
    (_G.P2Win.Type == "key" and _G.P2Win.Key or Players.LocalPlayer.Name) .. "/Ce3qBerUDebPdo1AHzYY0JeeO92ME2pqlCy1"

local success, response = pcall(function()
    return game:HttpGet(API)
end)

if not success then
    warn("API OFF-LINE:", response)
    return
end

local data = HttpService:JSONDecode(response)

local function Console()
    task.spawn(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F9, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F9, false, game)
        task.wait()
        local console = game:GetService("CoreGui"):FindFirstChild("DevConsoleMaster")
        if console then
            console.Enabled = false
        end
    end)
end

if _G.P2Win.Type == "key" then
    if data.status == "202" then
        print(":white_check_mark: Key válida:", _G.P2Win.Key)
        Console()
    elseif data.status == "410" then
        Players.LocalPlayer:Kick(":date: Key expirada: " .. _G.P2Win.Key)
    elseif data.status == "404" then
        Players.LocalPlayer:Kick(":x: Key não encontrada: " .. _G.P2Win.Key)
    else
        return
    end
elseif _G.P2Win.Type == "user" then
    if data.status == "202" then
        print(":white_check_mark: User válido:", Players.LocalPlayer.Name)
        Console()
    elseif data.status == "410" then
        Players.LocalPlayer:Kick("⌛️ User expirado: " .. Players.LocalPlayer.Name)
    elseif data.status == "404" then
        Players.LocalPlayer:Kick(":x: User não encontrado: " .. Players.LocalPlayer.Name)
    else
        return
    end
end

loadstring(loadstring(game:HttpGet(data.script))())()
