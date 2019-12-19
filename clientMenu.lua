local menuInterface = nil
local bool = false
local isConnecting = true

AddEvent("OnPlayerSpawn", function()
    if(isConnecting) then
        local width, height = GetScreenSize()
        menuInterface = CreateWebUI(0, 0, 0, 0, 0, 32)
        SetWebAlignment(menuInterface, 0, 0)
        SetWebAnchors(menuInterface, 0, 0, 1, 1)
        SetWebURL(menuInterface, "http://asset/" .. GetPackageName() .. "/ui/ui.html")
        SetWebVisibility(menuInterface, WEB_HIDDEN)
        isConnecting = false
    end
end)

AddEvent("OnKeyPress", function(key)
    if(key == "F6") then
        if(bool) then
            SetWebVisibility(menuInterface, WEB_HIDDEN)
            ShowMouseCursor(false)
            SetInputMode(INPUT_GAME)
            bool = false
            ExecuteWebJS(menuInterface, "deleteValue();")
        else
            CallRemoteEvent("adminMenu:isAdmin")
        end
    end
end)

AddRemoteEvent("adminMenu:show", function()
    SetWebVisibility(menuInterface, WEB_VISIBLE)
    CallRemoteEvent("adminMenu:getData")
    ShowMouseCursor(true)
    SetInputMode(INPUT_GAMEANDUI)
    bool = true
end)

AddRemoteEvent("adminMenu:openMenu", function(pList)
    ExecuteWebJS(menuInterface, "deleteValue();")
    for _,user in pairs(pList) do
        ExecuteWebJS(menuInterface, "setValue('"..Base64Encode(user.id).."','"..Base64Encode(user.identifier).."','"..Base64Encode(user.ping).."','"..Base64Encode(user.firstname).."','"..Base64Encode(user.name).."');")
    end
end)

-- 'Kick', 'Ban', 'Spawn', 'NoClip', 'Teleport'
AddEvent("onKick", function(id)
    CallRemoteEvent("onKickServer", id)
end)

AddEvent("onBan", function(id)
    CallRemoteEvent("onBanServer", id)
end)

AddEvent("onSpawn", function(id)
    CallRemoteEvent("onSpawnServer", id)
end)

AddEvent("onNoClip", function(id)
    -- End it!
end)

AddEvent("onTeleport", function(id)
    CallRemoteEvent("onTeleportServer", id)
end)
