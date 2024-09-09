#!define versionhere "2.0"
#!include "settings.opy"

rule "Credits":
    disableInspector()


rule "[Import Your Data Here]":
    CP_Pos = [vect(16, 0, 16), vect(12, 0, 16), vect(8, 0, 16).concat(vect(4, 0, 16)), vect(-4, 0, -4), vect(-8, 0, -4)]
    #CP_EndPos = []
    #CP_Radius = 1.4
    CP_Hero = [Hero.ZENYATTA, Hero.ANA, Hero.GENJI]


rule "Incomplete data":
    if CP_Radius == null:
        CP_Radius = 1.4
    if CP_Hero == null:
        CP_Hero = Hero.ANA


rule "Player init":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.disablePlayerCollision()
    eventPlayer.startCamera(updateEveryTick(eventPlayer.getFacingDirection() + (raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() - eventPlayer.getFacingDirection() * 5, [], [], false).getHitPosition())), updateEveryTick(eventPlayer.getEyePosition()), false)


rule "Local player effects":
    if len(CP_Radius):
        createEffect(getAllPlayers(), Effect.RING, Color.WHITE, CP_Pos[localPlayer.CP_Index][0], CP_Radius[localPlayer.CP_Index], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.RING, Color.GREEN, CP_Pos[localPlayer.CP_Index].last() if len(CP_Pos[localPlayer.CP_Index]) else CP_Pos[localPlayer.CP_Index + true], CP_Radius[localPlayer.CP_Index], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    else:
        createEffect(getAllPlayers(), Effect.RING, Color.WHITE, CP_Pos[localPlayer.CP_Index][0], evalOnce(CP_Radius), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.RING, Color.GREEN, CP_Pos[localPlayer.CP_Index].last() if len(CP_Pos[localPlayer.CP_Index]) else CP_Pos[localPlayer.CP_Index + true], evalOnce(CP_Radius), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


def ResetPlayer():
    @Name "Reset Player"
    
    eventPlayer.cancelPrimaryAction()
    eventPlayer.applyImpulse(-1 * eventPlayer.getVelocity(), 0, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.teleport(CP_Pos[eventPlayer.CP_Index][0])
    eventPlayer.resurrect()
    ResetAbilities()


def ResetAbilities():
    @Name "Reset Abilities"
    
    eventPlayer.setAllowedHeroes(CP_Hero[eventPlayer.CP_Index] if len(CP_Hero) else CP_Hero)
    eventPlayer.preloadHero(CP_Hero[eventPlayer.CP_Index + true])


rule "Player died":
    @Event playerDied
    @Condition eventPlayer.isDummy() == false
    
    ResetPlayer()


rule "On ground":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == eventPlayer.isAlive()
    @Condition eventPlayer.isOnGround() == true
    
    if distance(eventPlayer.getPosition(), CP_Pos[eventPlayer.CP_Index][0]) < (CP_Radius[eventPlayer.CP_Index] if len(CP_Radius) else CP_Radius):
    elif (distance(eventPlayer.getPosition(), CP_Pos[eventPlayer.CP_Index].last() if len(CP_Pos[eventPlayer.CP_Index]) else CP_Pos[eventPlayer.CP_Index + true])) < (CP_Radius[eventPlayer.CP_Index] if len(CP_Radius) else CP_Radius):
        eventPlayer.CP_Index += true
        ResetAbilities()
    else:
        ResetPlayer()
    wait(false)
    if RULE_CONDITION:
        goto RULE_START