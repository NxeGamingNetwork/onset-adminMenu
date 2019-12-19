
AddRemoteEvent("adminMenu:isAdmin", function(player)
    if(tostring(userObj(player).getGroup()) == "admin") then -- MODIFY
        CallRemoteEvent(player, "adminMenu:show")
    end
end)

AddRemoteEvent("adminMenu:getData", function(player)
    local users = {}
    for _,v in pairs(GetAllPlayers()) do
        local identifier = string.format("steam:%x", (GetPlayerSteamId(v) * 256))
        local ping = GetPlayerPing(v)
        local firstname = userObj(v).getInformations()["prenom"] -- MODIFY
        local name = userObj(v).getInformations()["nom"] -- MODIFY
        table.insert(users, {identifier=identifier, ping=ping, id=v, firstname=firstname, name=name})
    end
    CallRemoteEvent(player, "adminMenu:openMenu", users)
end)

AddRemoteEvent("onKickServer", function(player, id)
    KickPlayer(id, "Kicked!")
end)

AddRemoteEvent("onBanServer", function(player, id)
    -- MODIFY
    KickPlayer(id, "Banned!")
end)

AddRemoteEvent("onSpawnServer", function(player, id)
    local x,y,z = GetPlayerLocation(id)
    local h = GetPlayerHeading(id)
    SetPlayerInVehicle(id, CreateVehicle(tonumber(1), x, y, z, h))
end)

AddRemoteEvent("onTeleportServer", function(player, id)
    local x,y,z = GetPlayerLocation(id)
    SetPlayerLocation(player, x, y, z)
end)
