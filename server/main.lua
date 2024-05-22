local cfg = require 'config.server'
local inv = exports.ox_inventory
math = lib.math
-- lib.callback.register('nz_petani:callback:giveitem', function(source, item, amount)
    
-- end)

-- event
local sendWebhook = function(source, amount, price)
    local player = exports.qbx_core:GetPlayer(source)
    local citizenId = player.PlayerData.citizenid
    local steam = player.PlayerData.license
    local name = player.PlayerData.charinfo.firstname..' '..player.PlayerData.charinfo.lastname
    local cash = math.groupdigits(player.PlayerData.money.cash, '.')
    local bank = math.groupdigits(player.PlayerData.money.bank, '.')
    if cfg.debug then print(citizenId, steam, name, cash, bank) end
    local embed = {
        {
            ["color"] = cfg.webhookProperti.color,
            ["title"] = cfg.webhookProperti.title,
            ["description"] = "Player : **".. name.. "** \nJumlah Item : **"..amount.. "** \nTotal Harga : **MRI$ "..price.."** \nTotal uang dibank : **"..bank.."** \nTotal uang dikantong : **"..cash..'**\n License : **'..steam..'**\n CitizenId : **'..citizenId..'**',
            ["footer"] = {
                ["text"] = 'Make with ❤ by Curel',
            },
        }
    }

  PerformHttpRequest(cfg.webhookProperti.url, function(err, text, headers) end, 'POST', json.encode({username = "Petani", embeds = embed}), { ['Content-Type'] = 'application/json' })

end

-- callback 
lib.callback.register('nz_petani:callback:giveitem', function(source, item, amount)
    if inv:CanCarryItem(source, item, amount) then
        local success, response = exports.ox_inventory:AddItem(source, item, amount)
        if cfg.debug then
            print(success, json.encode(response))
        end
        if success then return success end
        return 'Ada yang error silahkan hubungi developer'
    else
        return false
    end
end)

lib.callback.register('nz_petani:callback:checkItem', function(source, item)
    local count = inv:GetItemCount(source, item)
    return count
end)

lib.callback.register('nz_petani:callback:removeItem', function(source, item)
    local success = exports.ox_inventory:RemoveItem(source, item, 1)
    return success
end)

lib.callback.register('nz_petani:callback:sellItem', function(source, item, count, price)
    local success = exports.ox_inventory:RemoveItem(source, item, count)
    if cfg.debug then print("selling", success) end

    if not success then return TriggerClientEvent('ox_lib:notify', source, {description = 'Gagal menjual barang', type = 'error'}) end
    exports.ox_inventory:AddItem(source, cfg.moneyType, count*price)
    TriggerClientEvent('ox_lib:notify', source, {description = 'Berhasil menjual barang, mendapatkan MRI$'..count*price, type = 'success'})

    if cfg.discordWebhook then
        sendWebhook(source, count, count*price)
    end
    return true
end)