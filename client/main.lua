local cfg = require 'config.client'
local location = cfg.location

local Upper = function(str)
    return (str:gsub("^%l", string.upper))
end

local makeBlips = function()
	for _, info in pairs(location) do
        -- print(info.Blipsicon)
        info.blips = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
        SetBlipAsShortRange(info.blips, true)
        SetBlipSprite(info.blips, info.Blipsicon)
        SetBlipColour(info.blips, info.color)
        SetBlipScale(info.blips, 0.8)
        SetBlipDisplay(info.blips, 6)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blips)
    end
end

local FramTarget = function()
    for k, v in pairs(location) do
        -- print(v.points)
        exports.ox_target:addPolyZone({
            name = k,
            points = v.points,
            thickness = v.thickness,
            debug = cfg.debug,
            options = {
                {
                    name = k,
                    label = v.name,
                    icon = v.icon,
                    onSelect = function()
                        -- print("Memtik "..Upper(k))
                        local skill = lib.skillCheck({'easy'}, {'w'})
                        if not skill then return lib.notify({title = 'Gagal memetik', type = 'error'}) end
                        if skill then
                            -- if lib.progressCircle({
                            --     duration = v.animDuration,
                            --     position = 'bottom',
                            --     useWhileDead = false,
                            --     canCancel = true,
                            --     disable = {
                            --         car = true,
                            --         move = true,
                            --         combat = true
                            --     },
                            --     anim = {
                            --         dict = v.dict,
                            --         clip = v.clip
                            --     },
                            -- }) then 
                            --     local call = lib.callback.await('nz_petani:callback:giveitem', false, v.item, v.amount) 
                            --     if not call then lib.notify({title = "Inventory penuh", type = 'error'}) end
                            -- end
                            if lib.progressBar({
                                duration = v.animDuration,
                                label = v.name,
                                useWhileDead = false,
                                canCancel = true,
                                disable = {
                                    car = true,
                                    move = true,
                                    combat = true,
                                },
                                anim = {
                                    dict = v.dict,
                                    clip = v.clip
                                },
                            }) then 
                                local call = lib.callback.await('nz_petani:callback:giveitem', false, v.item, v.amount) 
                                if not call then lib.notify({title = "Inventory penuh", type = 'error'}) end 
                            end
                            
                        end
                    end,
                    distance = 1.5,
                }
            }
        })
    end
end

------- event -------
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    makeBlips()
    FramTarget()
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function() 
    makeBlips()
    FramTarget()
end)
