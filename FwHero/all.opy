#!mainFile "../framework.opy"

################################################################################
/* Default Command Input Binds*/

enum Command_Leaderboard:
    input = eventPlayer.isHoldingButton(Button.MELEE)
    condition = Command_Leaderboard.input

enum Command_Split:
    input = eventPlayer.isHoldingButton(Button.ABILITY_1) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) \
        and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    condition = Command_Split.input

enum Command_Invisible:
    input = eventPlayer.isHoldingButton(Button.ABILITY_2)
    condition = Command_Invisible.input

enum Command_Preview:
    input = hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) and hostPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    condition = Command_Preview.input

enum Command_Restart:
    input = eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.INTERACT) \
        and eventPlayer.isHoldingButton(Button.ABILITY_2)
    condition = Command_Restart.input

enum Command_Spectate:
    input = eventPlayer.isHoldingButton(Button.INTERACT)
    block = eventPlayer.isHoldingButton(Button.ABILITY_2)
    editor = EditorOn and (
        eventPlayer.isHoldingButton(Button.MELEE) or
        eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or
        eventPlayer.isHoldingButton(Button.SECONDARY_FIRE))
    condition = Command_Spectate.input and not Command_Spectate.block and not Command_Spectate.editor

enum Command_Invincible:
    input = eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.isHoldingButton(Button.RELOAD)
    block = eventPlayer.isHoldingButton(Button.INTERACT)
    condition = Command_Invincible.input and not Command_Invincible.block

enum Command_Practice:
    input = eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.isHoldingButton(Button.ULTIMATE)
    block = eventPlayer.isHoldingButton(Button.RELOAD)
    condition = Command_Practice.input and not Command_Practice.block

enum Command_PracticeRestart:
    input = eventPlayer.isHoldingButton(Button.INTERACT)
    block1 = eventPlayer.isHoldingButton(Button.CROUCH)
    block2 = eventPlayer.isHoldingButton(Button.ULTIMATE)
    block3 = eventPlayer.isHoldingButton(Button.MELEE)
    block4 = eventPlayer.isHoldingButton(Button.ABILITY_2)
    condition = Command_PracticeRestart.input and not Command_PracticeRestart.block1 and not Command_PracticeRestart.block2 \
        and not Command_PracticeRestart.block3 and not Command_PracticeRestart.block4

enum Command_PracticeSkip:
    input1 = eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    input2 = eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    input3 = eventPlayer.isHoldingButton(Button.CROUCH)
    condition = Command_PracticeSkip.input3 and Command_PracticeSkip.input1 != Command_PracticeSkip.input2

enum Command_QuickReset:
    input = eventPlayer.isHoldingButton(Button.RELOAD)
    block1 = eventPlayer.isHoldingButton(Button.MELEE)
    block2 = eventPlayer.isHoldingButton(Button.INTERACT)
    condition = Command_QuickReset.input and not Command_QuickReset.block1 and not Command_QuickReset.block2

enum Command_Huds:
    input = eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    block1 = eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    block2 = eventPlayer.isHoldingButton(Button.CROUCH) # don't activate during skipping
    editor = EditorOn and eventPlayer == hostPlayer and eventPlayer.isHoldingButton(Button.MELEE)
    condition = Command_Huds.input and not Command_Huds.block1 and not Command_Huds.block2 and not Command_Huds.editor

enum Command_Hints:
    input = eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.isHoldingButton(Button.ABILITY_2)
    condition = Command_Hints.input

enum Command_3rdPerson:
    input = eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.JUMP)
    condition = Command_3rdPerson.input

################################################################################
/* Generalized mechanics for all heroes here */
macro Fw_Mechanics_All(heroGroundReset = pass):
    rule "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Mechanics | Checks ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒":
        @Delimiter

    rule "Mechanic | All | Jump":
        @Event eachPlayer
        @Condition eventPlayer.isJumping()
        eventPlayer.skill_usedBhop = true
        if eventPlayer.skill_usedHop:
            smallMessage(eventPlayer, t"   Bhop") #"   小跳已用" checkCN "   Bhop"
            if antiCheat and eventPlayer.getVerticalSpeed() > 5.722:
                LobbyID = []
        else:
            eventPlayer.skill_usedHop = true

    rule "Mechanic | All | No Jump":
        @Event eachPlayer
        @Condition eventPlayer.skill_usedHop == null
        @Condition eventPlayer.isOnGround() == false
        eventPlayer.skill_usedHop = true

    rule "Mechanic | All | Bhop Reset":
        @Event eachPlayer
        @Condition eventPlayer.isOnGround()
        @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
        eventPlayer.skill_usedBhop = false

    rule "Mechanic | All | Emote":
        @Event eachPlayer
        @Condition eventPlayer.isCommunicatingEmote() == true
        eventPlayer.skill_usedBhop = false
        if eventPlayer.addon_toggle3rdPov:
            eventPlayer.addon_toggle3rdPov = false
            eventPlayer.stopCamera()
        if eventPlayer.ban_emote:
            waitUntil(not eventPlayer.isCommunicatingEmote(), Math.INFINITY)
            if eventPlayer.toggle_invincible: return
            #"   表情留小 ♥ 已禁用!" checkCN "   Emote Savehop ♥ is banned!"
            smallMessage(eventPlayer, t"   Emote Savehop ♥ Is Banned!")
            wait(0)
            CheckpointFailReset()

    rule "Mechanic | All | Ground Reset":
        @Event eachPlayer
        @Condition eventPlayer.isOnGround()
        eventPlayer.skill_usedHop = null
        eventPlayer.skill_countBhops = null
        heroGroundReset