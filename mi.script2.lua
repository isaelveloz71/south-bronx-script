-- Sistema completo: Autofarm, Speed Hack, Antiban, Aimbot y ESP

-- Función Anti-Ban
local function antiban()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local oldIndex = mt.__index

        mt.__index = function(self, key)
            if self == LocalPlayer.Character.Humanoid and key == "WalkSpeed" then
                return 16
            end
            return oldIndex(self, key)
        end
    end)

    for _, player in ipairs(Players:GetPlayers()) do
        player.Chatted:Connect(function(msg)
            if string.find(string.lower(msg), "hacker") or string.find(string.lower(msg), "report") then
                LocalPlayer:Kick("Anti-Ban activado: alguien te reportó.")
            end
        end)
    end

    local function blockRemoteCalls()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if tostring(method) == "FireServer" and tostring(self) == "ReportRemote" then
                return
            end
            return oldNamecall(self, ...)
        end)
    end

    blockRemoteCalls()
end

-- Función Speed Hack
local function speedHack(speedValue)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
end

-- Función AutoFarm
local function autofarm()
    while true do
        game:GetService("ReplicatedStorage").Remotes.GiveCash:FireServer(1000)
        wait(1)
    end
end

-- Función Aimbot
local function aimbot()
    local players = game:GetService("Players")
    local mouse = players.LocalPlayer:GetMouse()

    mouse.Button1Down:Connect(function()
        local closest = nil
        local dist = math.huge
        for i,v in pairs(players:GetPlayers()) do
            if v ~= players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local pos = workspace.CurrentCamera:WorldToScreenPoint(v.Character.Head.Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
                if magnitude < dist then
                    closest = v
                    dist = magnitude
                end
            end
        end

        if closest then
            mousemoveabs(closest.Character.Head.Position.X, closest.Character.Head.Position.Y)
        end
    end)
end

-- Función ESP
local function esp()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            local espBox = Instance.new("BillboardGui")
            espBox.Name = "ESP"
            espBox.Adornee = v.Character:WaitForChild("Head")
            espBox.Size = UDim2.new(0, 100, 0, 40)
            espBox.StudsOffset = Vector3.new(0, 2, 0)
            espBox.AlwaysOnTop = true

            local textLabel = Instance.new("TextLabel", espBox)
            textLabel.Size = UDim2.new(1,0,1,0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = v.Name
            textLabel.TextColor3 = Color3.new(1,0,0)
            textLabel.TextStrokeTransparency = 0
            textLabel.TextScaled = true

            espBox.Parent = v.Character
        end
    end
end

-- Activar funciones
antiban()
speedHack(100)
spawn(autofarm)
aimbot()
esp()
-- Intentar ejecutar el código del script de manera segura
local success, errorMessage = pcall(function()
    -- Aquí va la carga del script
    loadstring(game:HttpGet("https://github.com/tuUsuario/mi-scripts-roblox/raw/main/miScript.lua"))()
end)

-- Si ocurre un error, mostrar el mensaje de error
if not success then
    warn("Hubo un error al ejecutar el script: " .. errorMessage)
end
