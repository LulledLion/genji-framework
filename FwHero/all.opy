#!mainFile "../framework.opy"

################################################################################
/* Default Command Input Binds*/

macro input@Fw_Commands_Leaderboard():
    @Condition eventPlayer.isHoldingButton(Button.MELEE)

macro input@Fw_Commands_Split():
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

macro input@Fw_Commands_Invisible():
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)

macro input@Fw_Commands_Preview():
    pass

macro input@Fw_Commands_Restart():
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)

macro input@Fw_Commands_Spectate():
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false
    @Condition (EditorOn and (
        eventPlayer.isHoldingButton(Button.MELEE) or
        eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or
        eventPlayer.isHoldingButton(Button.SECONDARY_FIRE))) == false

macro input@Fw_Commands_Invincible():
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false

macro input@Fw_Commands_Practice():
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == false
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)

macro input@input@Fw_Commands_PracticeRestart():
    pass

macro input@Fw_Commands_PracticeSkip():
    pass

macro input@Fw_Commands_QuickReset():
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == false
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false

macro input@Fw_Commands_Huds():
    @Condition (EditorOn and eventPlayer == hostPlayer and eventPlayer.isHoldingButton(Button.MELEE)) == false
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false # don't activate during skipping

macro input@Fw_Commands_Hints():
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)

macro input@Fw_Commands_3rdPerson():
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.JUMP)

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