#!define versionhere "2.0"
#!include "settings.opy"

rule "Credits":
    disableInspector()


rule "[Import Your Data Here]":
    CP_Pos = [vect(16, 0, 16), vect(12, 0, 16), vect(8, 0, 16).concat(vect(4, 0, 16)), vect(-4, 0, -4), vect(-8, 0, -4)]
    CP_Radius = [vect(1.4, 0.5, 0), vect(1,1.4,0), 0.25]
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
    createEffect(getAllPlayers() if localPlayer.CP_Index < len(CP_Pos) else [], Effect.RING, Color.WHITE, CP_Pos[localPlayer.CP_Index][0], (CP_Radius[localPlayer.CP_Index] * Vector.LEFT).x if (CP_Radius[localPlayer.CP_Index] *Vector.LEFT).x else (CP_Radius.last() * Vector.UP).y, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers() if localPlayer.CP_Index < len(CP_Pos) else [], Effect.RING, Color.GREEN, CP_Pos[localPlayer.CP_Index].last() if len(CP_Pos[localPlayer.CP_Index]) else CP_Pos[localPlayer.CP_Index + true], (CP_Radius[localPlayer.CP_Index] * Vector.UP).y if (CP_Radius[localPlayer.CP_Index] * Vector.UP).y else ((CP_Radius[localPlayer.CP_Index+true] * Vector.LEFT).x if (CP_Radius[localPlayer.CP_Index+true] * Vector.LEFT).x else (CP_Radius.last() * Vector.UP).y), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createIcon(getAllPlayers() if localPlayer.CP_Index < len(CP_Pos) else [], CP_Pos[localPlayer.CP_Index].last() if len(CP_Pos[localPlayer.CP_Index]) else CP_Pos[localPlayer.CP_Index + true],Icon.ARROW_DOWN,IconReeval.VISIBILITY_AND_POSITION,Color.GREEN,false)

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
    
    
    if distance(eventPlayer.getPosition(), CP_Pos[eventPlayer.CP_Index][0]) < ((CP_Radius[eventPlayer.CP_Index] * Vector.LEFT).x if (CP_Radius[eventPlayer.CP_Index] * Vector.LEFT).x else (CP_Radius.last() * Vector.UP).y):
    elif (distance(eventPlayer.getPosition(), CP_Pos[eventPlayer.CP_Index].last() if len(CP_Pos[eventPlayer.CP_Index]) else CP_Pos[eventPlayer.CP_Index + true])) < ((CP_Radius[eventPlayer.CP_Index]*Vector.UP).y if (CP_Radius[eventPlayer.CP_Index] * Vector.UP).y else ((CP_Radius[eventPlayer.CP_Index + true] * Vector.LEFT).x if (CP_Radius[eventPlayer.CP_Index + true] * Vector.LEFT).x else (CP_Radius.last() * Vector.UP).y)):
        eventPlayer.CP_Index += true
        ResetAbilities()
    elif eventPlayer.Immune:
    else:
        ResetPlayer()
    wait(false)
    if RULE_CONDITION:
        goto RULE_START