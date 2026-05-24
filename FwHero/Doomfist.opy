#!mainFile "../framework.opy"
################################################################################
/* Rename Global Variables */
##!define 
################################################################################
/* Include Shared Skill Macros*/
#!include "all.opy"
################################################################################
/* Hero Key Bind Override  */

################################################################################

macro Fw_Parkour_Setup_Hero():
    Ability1Checkpoints = Ability1Checkpoints if len(Ability1Checkpoints) else []
    Ability2Checkpoints = Ability2Checkpoints if len(Ability2Checkpoints) else []
    SecondaryCheckpoints = SecondaryCheckpoints if len(SecondaryCheckpoints) else []
    UltCheckpoints = UltCheckpoints if len(UltCheckpoints) else []

macro Fw_Parkour_UpdateCache_Hero():
    if eventPlayer.checkpoint_notLast:
        eventPlayer.cache_startAbility1 = eventPlayer.checkpoint_current in Ability1Checkpoints
        if eventPlayer.cache_startAbility1:
            smallMessage(eventPlayer, f"   {abilityIconString(FwHero.Hero, Button.ABILITY_1)} {t' Is Ready'}")
        eventPlayer.cache_startAbility2 = eventPlayer.checkpoint_current in Ability2Checkpoints
        if eventPlayer.cache_startAbility2:
            smallMessage(eventPlayer, f"   {abilityIconString(FwHero.Hero, Button.ABILITY_2)} {t' Is Ready'}")
        eventPlayer.cache_startSecondary = eventPlayer.checkpoint_current in SecondaryCheckpoints
        if eventPlayer.cache_startSecondary:
            smallMessage(eventPlayer, f"   {abilityIconString(FwHero.Hero, Button.SECONDARY_FIRE)} {t' Is Ready'}")
        eventPlayer.cache_startUlt = eventPlayer.checkpoint_current in UltCheckpoints
        if eventPlayer.cache_startUlt:
            smallMessage(eventPlayer, f"   {abilityIconString(FwHero.Hero, Button.ULTIMATE)} {t' Is Ready'}")
    else:
        eventPlayer.cache_startAbility1 = true
        eventPlayer.cache_startAbility2 = true
        eventPlayer.cache_startSecondary = true
        eventPlayer.cache_startUlt = true

################################################################################

macro Fw_Mechanics_GroundReset_Hero():
    pass

macro Fw_Mechanics_Hero():
    Fw_Mechanics_All(Fw_Mechanics_GroundReset_Hero())

    def ResetAbilities():
        @Name "Mechanic | Doomfist | SUB Reset Abilities"
        if eventPlayer.toggle_invincible or (eventPlayer == hostPlayer and EditorOn):
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setAbility2Enabled(true)
            eventPlayer.setSecondaryFireEnabled(true)
            eventPlayer.setUltEnabled(true)
        else:
            eventPlayer.setAbility1Enabled(eventPlayer.cache_startAbility1)
            eventPlayer.setAbility2Enabled(eventPlayer.cache_startAbility2)
            eventPlayer.setSecondaryFireEnabled(eventPlayer.cache_startSecondary)
            eventPlayer.setUltEnabled(eventPlayer.cache_startUlt)
        eventPlayer.setUltCharge(100)

    rule "Mechanic | Doomfist | Ability 1":
        @Event eachPlayer
        @Hero doomfist
        @Condition eventPlayer.isUsingAbility1()
        if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast: return
        pass

    rule "Mechanic | Doomfist | Ability 2":
        @Event eachPlayer
        @Hero doomfist
        @Condition eventPlayer.isUsingAbility2()
        if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast: return
        pass

    rule "Mechanic | Doomfist | Ultimate":
        @Event eachPlayer
        @Hero doomfist
        @Condition eventPlayer.isUsingUltimate()
        if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast: return
        pass

################################################################################
macro Fw_AddonsPg1_Hero():
    rule "Addon | Doomfist | Momentum Grace":
        @Event eachPlayer
        @Hero doomfist
        @Condition eventPlayer.getSpeed() >= 15
        eventPlayer.skill_safe += true
        waitUntil(eventPlayer.getSpeed() < 15)
        eventPlayer.skill_safe -= true

macro Fw_AddonsPg2_Hero():
    rule ""::@Disabled