--!strict
print('Hello from zLibrary')

local z = {}
local events: {[string]: RemoteEvent} = {}

function z.receiveFromClient(name: string, func: any)
    if not events[name] then
        events[name] = Instance.new("RemoteEvent")
        events[name].Name = name
        events[name].Parent = game.ReplicatedStorage
    end
    events[name].OnServerEvent:Connect(func)
end

function z.sendToServer(name: string, ...)
    if not events[name] then
        events[name] = game.ReplicatedStorage:WaitForChild(name)
    end
    events[name]:FireServer(...)
end

local tracks: {[string]: AnimationTrack} = {}

function z.getNpcAnimationTrack(humanoid: Humanoid, id: number): AnimationTrack
    if humanoid.RootPart.Anchored then
        print("WARNING: Animation cannot work while", humanoid:GetFullName(), ".RootPart.anchored == true")
    end
    local key = humanoid:GetFullName() .. "|" .. id
    if not tracks[key] then
        local animation = Instance.new("Animation", bot)
        animation.Name = "Animation_"..tostring(id)
        animation.AnimationId = "rbxassetid://"..tostring(id)
        tracks[key] = humanoid:LoadAnimation(animation)
    end
    return tracks[key]
end

return z
