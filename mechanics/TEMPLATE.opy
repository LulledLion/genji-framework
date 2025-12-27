#!mainFile "../framework.opy"

#!include "all.opy"

macro FwMechanicsHero():
    FwMechanicsAll()
    def ResetAbilities():
        @Name "Mechanic | TEMPLATE | SUB Reset Abilities"
        pass

    rule "Mechanic | TEMPLATE | Ability 1":
        @Event eachPlayer
        @Hero TEMPLATE
        @Condition eventPlayer.isUsingAbility1()
        pass

    rule "Mechanic | TEMPLATE | Ability 2":
        @Event eachPlayer
        @Hero TEMPLATE
        @Condition eventPlayer.isUsingAbility2()
        pass

    rule "Mechanic | TEMPLATE | Ultimate":
        @Event eachPlayer
        @Hero TEMPLATE
        @Condition eventPlayer.isUsingUltimate()
        pass