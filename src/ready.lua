local function clear_engine_simspeed_values()
    local sgg_world_offset = 0x4dcc1b0
    local base_addr = rom.memory.get_module_base_address()
    local world_ptr_ptr = base_addr:add(sgg_world_offset)
    if world_ptr_ptr:is_valid() then
        local world_ptr = world_ptr_ptr:deref()
        local world_mSpeedModifier = world_ptr:add(0x30)
        local world_mSpeedModifierTarget = world_ptr:add(0x34)
        local world_mSpeedModifierChangeSpeed = world_ptr:add(0x38)

        print("Before memory write", world_mSpeedModifier:get_float(),
            world_mSpeedModifierTarget:get_float(),
            world_mSpeedModifierChangeSpeed:get_float()
        )

        world_mSpeedModifier:set_float(1.0)
        world_mSpeedModifierTarget:set_float(1.0)
        world_mSpeedModifierChangeSpeed:set_float(999.0)

        print("After memory write", world_mSpeedModifier:get_float(),
            world_mSpeedModifierTarget:get_float(),
            world_mSpeedModifierChangeSpeed:get_float()
        )
    end
end

modutil.mod.Path.Wrap("LeaveRoom", function (base, ...)
    game.AdjustSimulationSpeed({ Fraction = 1.0, LerpTime = 0 })
    print("Before force clear speed state",
        mod.dump(game.SessionState.GameplaySlows),
        mod.dump(game.SessionState.PlayerGameplaySlows),
        mod.dump(game._G.SessionState.GameplaySlows),
        mod.dump(game._G.SessionState.PlayerGameplaySlows)
    )
    game.SessionState.GameplaySlows = {}
    game.SessionState.PlayerGameplaySlows = {}
    game._G.SessionState.GameplaySlows = {}
    game._G.SessionState.PlayerGameplaySlows = {}
    clear_engine_simspeed_values()
    local retval =  base(...)
    print("After force clear speed state",
        mod.dump(game.SessionState.GameplaySlows),
        mod.dump(game.SessionState.PlayerGameplaySlows),
        mod.dump(game._G.SessionState.GameplaySlows),
        mod.dump(game._G.SessionState.PlayerGameplaySlows)
    )
    return retval
end)