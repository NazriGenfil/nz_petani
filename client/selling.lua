local cfg = require 'config.client'
local sel = cfg.selling

-- Function
local makeBlip = function()
    if not sel.blip then return end
    local blipCfg = sel.blipProperti
    blips = AddBlipForCoord(blipCfg.coords.x, blipCfg.coords.y, blipCfg.coords.z)
    SetBlipAsShortRange(blips, true)
    SetBlipSprite(blips, blipCfg.icon)
    SetBlipColour(blips, blipCfg.color)
    SetBlipScale(blips, 0.8)
    SetBlipDisplay(blips, 6)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(blipCfg.title)
    EndTextCommandSetBlipName(blips)
end

local sellingMenu = function()
    local menus = {}
    for k, v in pairs(sel.items) do
        -- print(k, json.encode(v))
        menus[k] = {
            title = v.label,
            description = 'MRI$ '..v.price,
            -- icon = 'circle',
            onSelect = function()
                local call = lib.callback.await('nz_petani:callback:checkItem', false, k)
                if call ~= 0 then
                    -- if lib.progressCircle({
                        -- duration = sel.duration * call,
                        -- position = 'bottom',
                        -- useWhileDead = false,
                        -- canCancel = false,
                        -- disable = {
                        --     car = true,
                        --     move = true,
                        --     combat = true,
                        -- },
                        -- anim = {
                        --     dict = sel.animation.dict,
                        --     clip = sel.animation.clip,
                        -- },
                        -- prop = {
                        --     model = sel.animation.prop.model,
                        --     bone = sel.animation.prop.bone,
                        --     pos = sel.animation.prop.pos,
                        --     rot = sel.animation.prop.rot,
                        -- },
                    -- }) then lib.callback.await('nz_petani:callback:sellItem', false, k, call, v.price) end
                    if lib.progressBar({
                        duration = sel.duration * call,
                        label = sel.progLabel,
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true,
                            combat = true,
                        },
                        anim = {
                            dict = sel.animation.dict,
                            clip = sel.animation.clip,
                        },
                        prop = {
                            model = sel.animation.prop.model,
                            bone = sel.animation.prop.bone,
                            pos = sel.animation.prop.pos,
                            rot = sel.animation.prop.rot,
                        },
                    }) then lib.callback.await('nz_petani:callback:sellItem', false, k, call, v.price) end
                end
            end,
        }
    end
    lib.registerContext({
        id = 'petani_selling',
        title = 'Jual hasil kebun',
        options = menus
    })
    lib.showContext('petani_selling')

end

local createPad = function()
    local model = lib.requestModel(sel.ped.model, sel.ped.timeout)
    if not model then return end
    ped = CreatePed(5, sel.ped.model, sel.ped.coords)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            name = "petani_shop",
            label = "Jual hasil tani",
            icon = 'fa-brands fa-pagelines',
            onSelect = function(data)
                sellingMenu()
            end
        },
    })
end

-- Event 

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    makeBlip()
    createPad()
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function() 
    makeBlip()
    createPad()
end)
