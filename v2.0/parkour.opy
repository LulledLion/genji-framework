#!define versionhere "2.0"
#!include "settings.opy"
#!define Default_Radius 1.4

rule "Credits":
    disableInspector()


rule "[Import Your Data Here]":
    CP_Pos = [vect(16, 0, 16), vect(12, 0, 16), vect(8, 0, 16).concat(vect(4, 0, 16)), vect(-4, 0, -4), vect(-8, 0, -4)]
    CP_Hero = [ Hero.ZENYATTA, 0, Hero.ANA, 1, Hero.GENJI, 2]
    CP_Ability= []

rule "Player init":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false

    eventPlayer.CachedIndex = -1
    eventPlayer.disablePlayerCollision()
    eventPlayer.startCamera(updateEveryTick(eventPlayer.getFacingDirection() + (raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() - eventPlayer.getFacingDirection() * 5, [], [], false).getHitPosition())), updateEveryTick(eventPlayer.getEyePosition()), false)


rule "Local player effects":
    createEffect(localPlayer, Effect.RING, Color.WHITE, CP_Pos[localPlayer.CP_Index].last(), Default_Radius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(localPlayer, Effect.RING, Color.GREEN, CP_Pos[localPlayer.CP_Index + true], Default_Radius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createIcon(localPlayer, CP_Pos[localPlayer.CP_Index + true],Icon.ARROW_DOWN,IconReeval.VISIBILITY_AND_POSITION,Color.GREEN, false)


rule "Player died":
    @Event playerDied
    @Condition eventPlayer.isDummy() == false
    
    ResetPlayer()


def ResetPlayer():
    @Name "Reset Player"
    
    eventPlayer.cancelPrimaryAction()
    eventPlayer.applyImpulse(-1 * eventPlayer.getVelocity(), 0, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.teleport(CP_Pos[eventPlayer.CP_Index].last())
    eventPlayer.resurrect()
    ResetAbilities()


def ResetAbilities():
    @Name "Reset Abilities"
    if eventPlayer.CachedIndex != eventPlayer.CP_Index:
        eventPlayer.CachedIndex = eventPlayer.CP_Index
        eventPlayer.setAllowedHeroes(CP_Hero[CP_Hero.index(eventPlayer.CP_Index) - true])
        eventPlayer.preloadHero(CP_Hero[CP_Hero.index(eventPlayer.CP_Index + true) - true])
        eventPlayer.CachedAbilityIndex = CP_Ability.index(eventPlayer.CP_Index) - true
    eventPlayer.Ability = CP_Ability[eventPlayer.CachedAbilityIndex]
    SetAbilities()


def SetAbilities():
    @Name "Set Abilities"
    eventPlayer.Ability = eventPlayer.Ability % 4
    eventPlayer.Ability = eventPlayer.Ability / 4 % 4
    eventPlayer.Ability = eventPlayer.Ability / 16 % 4
    eventPlayer.Ability = eventPlayer.Ability / 64 % 4
    eventPlayer.Ability = eventPlayer.Ability / 256 % 4
    eventPlayer.Ability = eventPlayer.Ability / 1024 % 4
    eventPlayer.Ability = eventPlayer.Ability / 4096 % 4
    eventPlayer.Ability = eventPlayer.Ability / 16384 % 4
    eventPlayer.Ability = eventPlayer.Ability / 65536 % 4
    eventPlayer.Ability = eventPlayer.Ability / 262144 % 4
    eventPlayer.Ability = eventPlayer.Ability / 1048576 % 4
    eventPlayer.Ability = eventPlayer.Ability / 4194304 % 4
    eventPlayer.Ability = eventPlayer.Ability / 16777216 % 4
/*
        eventPlayer.CachedAbility = CP_Ability.index(eventPlayer.CP_Index) + true
        eventPlayer.CachedButton = CP_Button.index(eventPlayer.CP_Index) + true

        eventPlayer.CachedReset[1] = CP_Ability1[CP_Ability1.index(eventPlayer.CP_Index) + true]
        eventPlayer.CachedReset[2] = CP_Ability2[CP_Ability2.index(eventPlayer.CP_Index) + true]
        eventPlayer.CachedReset[3] = CP_Crouch[CP_Crouch.index(eventPlayer.CP_Index) + true]
        eventPlayer.CachedReset[4] = CP_Jump[CP_Jump.index(eventPlayer.CP_Index) + true]
        eventPlayer.CachedReset[5] = CP_Primary[CP_Primary.index(eventPlayer.CP_Index) + true]
        eventPlayer.CachedReset[6] = CP_Secondary[CP_Secondary.index(eventPlayer.CP_Index) + true]
        eventPlayer.CachedReset[7] = CP_Ult[CP_Ult.index(eventPlayer.CP_Index) + true]
    eventPlayer.setAbility1Enabled(eventPlayer.CachedReset[2])
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, null)
    eventPlayer.setAbility2Enabled(eventPlayer.CachedReset[3])
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, null)

    eventPlayer.allowButton(Button.CROUCH)
    eventPlayer.setAbilityCooldown(Button.CROUCH, null)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.setAbilityCooldown(Button.JUMP, null)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, null)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, null)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.setUltCharge(0)
    */


rule "On ground":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == eventPlayer.isAlive()
    @Condition eventPlayer.isOnGround() == true
    
    if distance(eventPlayer.getPosition(), CP_Pos[eventPlayer.CP_Index].last()) < Default_Radius:
        waitUntil(eventPlayer.getPosition() != evalOnce(eventPlayer.getPosition()), 99999)
    elif distance(eventPlayer.getPosition(), CP_Pos[eventPlayer.CP_Index + true]) < Default_Radius:
        eventPlayer.CP_Index += true
        ResetAbilities()
    elif eventPlayer.Immune:
    else:
        ResetPlayer()
    wait(false)
    if RULE_CONDITION:
        goto RULE_START