#!mainFile "../framework.opy"

#!include "all.opy"

macro FwMechanicsHero():
    FwMechanicsAll()
    def ResetAbilities():
        @Name "Mechanic | TEMPLATE | SUB Reset Abilities"
        if eventPlayer.toggle_invincible or (eventPlayer == hostPlayer and EditorOn):
            pass
        else:
            pass

    rule "Mechanic | TEMPLATE | Ability 1":
        @Event eachPlayer
        @Hero TEMPLATE
        @Condition eventPlayer.isUsingAbility1()
        if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast: return
        pass

    rule "Mechanic | TEMPLATE | Ability 2":
        @Event eachPlayer
        @Hero TEMPLATE
        @Condition eventPlayer.isUsingAbility2()
        if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast: return
        pass

    rule "Mechanic | TEMPLATE | Ultimate":
        @Event eachPlayer
        @Hero TEMPLATE
        @Condition eventPlayer.isUsingUltimate()
        if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast: return
        pass