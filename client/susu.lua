local cfg = require 'config.client'
local spawnCow = function()
    if not cfg.cow then return end
    lib.requestModel(cfg.cowProp.model, cfg.cowProp.timeout)
    for k, v in pairs(cfg.cowProp.location) do
        if cfg.debug then print(k, v) end
        ped = CreatePed(5, cfg.cowProp.model, v)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        exports.ox_target:addLocalEntity(ped, {
            {
                name = "perahsusu",
                label = cfg.cowProp.target.label,
                icon = cfg.cowProp.target.icon,
                onSelect = function(data)
                    local count = lib.callback.await('nz_petani:callback:checkItem', false, cfg.cowProp.buket)
                    if count == 0 then return lib.notify({description = 'Kamu membutuhkan ember kosong',type = 'error'})end
                    local skill = lib.skillCheck({'easy'}, {'w'})
                    if not skill then return lib.notify({title = 'Gagal memetik', type = 'error'}) end
                    -- if lib.progressCircle({
                    --     duration = cfg.cowProp.animDuration,
                    --     position = 'bottom',
                    --     useWhileDead = false,
                    --     canCancel = true,
                    --     disable = {
                    --         car = true,
                    --         move = true,
                    --         combat = true,
                    --     },
                    --     anim = {
                    --         dict = cfg.cowProp.dict,
                    --         clip = cfg.cowProp.clip
                    --     },
                    -- }) then lib.callback.await('nz_petani:callback:giveitem', false, cfg.cowProp.item, cfg.cowProp.amount) lib.callback.await('nz_petani:callback:removeItem', false, cfg.cowProp.buket) end
                    if skill then
                    if lib.progressBar({
                            duration = cfg.cowProp.animDuration,
                            label = cfg.cowProp.target.label,
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true,
                                move = true,
                                combat = true,
                            },
                            anim = {
                                dict = cfg.cowProp.dict,
                                clip = cfg.cowProp.clip
                            },
                        }) then lib.callback.await('nz_petani:callback:giveitem', false, cfg.cowProp.item, cfg.cowProp.amount) lib.callback.await('nz_petani:callback:removeItem', false, cfg.cowProp.buket) end
                    end    
                end,
                distance = 1.5,
            },
        })
    end
end

-- Event  

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    spawnCow()
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function() 
    spawnCow()
end)