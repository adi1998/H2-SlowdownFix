local function clear_engine_simspeed_values()
    local sgg_world_offset = 0x4dcc1b0
    local base_addr = rom.memory.get_module_base_address()
    local world_ptr_ptr = base_addr:add(sgg_world_offset)
    if world_ptr_ptr:is_valid() then
        local world_ptr = world_ptr_ptr:deref()
        local world_mSpeedModifier = world_ptr:add(0x30)
        local world_mSpeedModifierTarget = world_ptr:add(0x34)
        local world_mSpeedModifierChangeSpeed = world_ptr:add(0x38)

        print(world_mSpeedModifier:get_float(),
            world_mSpeedModifierTarget:get_float(),
            world_mSpeedModifierChangeSpeed:get_float()
        )

        world_mSpeedModifier:set_float(1.0)
        world_mSpeedModifierTarget:set_float(1.0)
        world_mSpeedModifierChangeSpeed:set_float(999.0)

        print(world_mSpeedModifier:get_float(),
            world_mSpeedModifierTarget:get_float(),
            world_mSpeedModifierChangeSpeed:get_float()
        )
    end
end

modutil.mod.Path.Wrap("LeaveRoom", function (base, ...)
    game.AdjustSimulationSpeed({ Fraction = 1.0, LerpTime = 0 })
    game.SessionState.GameplaySlows = {}
    game.SessionState.PlayerGameplaySlows = {}
    game._G.SessionState.GameplaySlows = {}
    game._G.SessionState.PlayerGameplaySlows = {}
    clear_engine_simspeed_values()
    return base(...)
end)