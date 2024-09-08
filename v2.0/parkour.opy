#!define versionhere "2.0"
#!include "settings.opy"

rule "Credits":
    #disableInspector()


rule "[Import Your Data Here]":
    CP_StartPos = [vect(16, 0, 16), vect(12, 0, 16), vect(8, 0, 16), vect(-4, 0, -4)]
    #CP_EndPos = []
    #CP_Radius = 1.4
    CP_Hero = [Hero.ZENYATTA, Hero.ANA, Hero.GENJI]


rule "Unpack compressed map":
    if CP_EndPos == null:
        CP_EndPos = CP_StartPos
        del CP_EndPos[null]
    elif null in CP_EndPos:
        CP_EndPos = [player if player else CP_StartPos[i + true] for player, i in CP_EndPos]
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
        createEffect(getAllPlayers(), Effect.RING, Color.WHITE, CP_StartPos[localPlayer.CP_Index], CP_Radius[localPlayer.CP_Index], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.RING, Color.GREEN, CP_EndPos[localPlayer.CP_Index], CP_Radius[localPlayer.CP_Index], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    else:
        createEffect(getAllPlayers(), Effect.RING, Color.WHITE, CP_StartPos[localPlayer.CP_Index], evalOnce(CP_Radius), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.RING, Color.GREEN, CP_EndPos[localPlayer.CP_Index], evalOnce(CP_Radius), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


def ResetPlayer():
    @Name "Reset player"
    
    eventPlayer.cancelPrimaryAction()
    eventPlayer.applyImpulse(-1 * eventPlayer.getVelocity(), 0, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.teleport(CP_StartPos[eventPlayer.CP_Index])
    eventPlayer.resurrect()
    ResetAbilities()
   

def ResetAbilities():
    @Name "Reset abilities"

    eventPlayer.setAllowedHeroes(CP_Hero[eventPlayer.CP_Index] if len(CP_Hero) else CP_Hero)


rule "Player died":
    @Event playerDied
    @Condition eventPlayer.isDummy() == false
    
    ResetPlayer()


rule "On ground":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == eventPlayer.isAlive()
    @Condition eventPlayer.isOnGround() == true
 
    if distance(eventPlayer.getPosition(), CP_StartPos[eventPlayer.CP_Index]) < (CP_Radius[eventPlayer.CP_Index] if len(CP_Radius) else CP_Radius):
    elif distance(eventPlayer.getPosition(), CP_EndPos[eventPlayer.CP_Index]) < (CP_Radius[eventPlayer.CP_Index] if len(CP_Radius) else CP_Radius):
        eventPlayer.CP_Index += true
        ResetAbilities()
    else:
        ResetPlayer()
    wait(false)
    if RULE_CONDITION:
        goto RULE_START


