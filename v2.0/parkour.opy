#!define versionhere "2.0"
#!include "settings.opy"

rule "Credits":
    #disableInspector()


rule "[Import Your Data Here]":
    CP_StartPositions = [vect(16, 0, 16), vect(12, 0, 16), vect(8, 0, 16)]
    #CP_EndPositions = []
    #CP_Radii = 1.4


rule "Unpack compressed map":
    if CP_EndPositions == null:
        CP_EndPositions = CP_StartPositions
        del CP_EndPositions[null]
    elif null in CP_EndPositions:
        CP_EndPositions = [player if player else CP_StartPositions[i + true] for player, i in CP_EndPositions]
    if CP_Radii == null:
        CP_Radii = 1.4


rule "Player init":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.disablePlayerCollision()


rule "Local player effects":
    if len(CP_Radii):
        createEffect(getAllPlayers(), Effect.RING, Color.WHITE, CP_StartPositions[localPlayer.CP_Index], CP_Radii[localPlayer.CP_Index], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.RING, Color.GREEN, CP_EndPositions[localPlayer.CP_Index], CP_Radii[localPlayer.CP_Index], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    else:
        createEffect(getAllPlayers(), Effect.RING, Color.WHITE, CP_StartPositions[localPlayer.CP_Index], evalOnce(CP_Radii), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.RING, Color.GREEN, CP_EndPositions[localPlayer.CP_Index], evalOnce(CP_Radii), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


def ResetPlayer():
    @Name "Reset player"
    
    eventPlayer.cancelPrimaryAction()
    eventPlayer.applyImpulse(eventPlayer.getVelocity() * -1, 0, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.teleport(CP_StartPositions[eventPlayer.CP_Index])
    eventPlayer.resurrect()


rule "Player died":
    @Event playerDied
    @Condition eventPlayer.isDummy() == false
    
    ResetPlayer()


rule "On ground":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == eventPlayer.isAlive()
    @Condition eventPlayer.isOnGround() == true
 
    if distance(eventPlayer.getPosition(), CP_StartPositions[eventPlayer.CP_Index]) < (CP_Radii[eventPlayer.CP_Index] if len(CP_Radii) else CP_Radii):
    elif distance(eventPlayer.getPosition(), CP_EndPositions[eventPlayer.CP_Index]) < (CP_Radii[eventPlayer.CP_Index] if len(CP_Radii) else CP_Radii):
        eventPlayer.CP_Index += true
    else:
        ResetPlayer()
    wait(false)
    if RULE_CONDITION:
        goto RULE_START


