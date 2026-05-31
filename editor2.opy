#!mainFile "framework.opy"

rule "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Editor v2 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒":
    @Delimiter

#!include "menu/menu.opy"

macro hostUpdateCache():
    hostPlayer.editor_callSUB = 1
macro hostCheckpointFailReset():
    hostPlayer.editor_callSUB = 2
macro hostUpdateReset():
    hostPlayer.editor_callSUB = true

rule "Editor | Call Player SUB":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition hostPlayer.editor_callSUB
    if hostPlayer.editor_callSUB == 1:
        UpdateCache()
    if hostPlayer.editor_callSUB == 2:
        CheckpointFailReset()
    hostPlayer.editor_callSUB = null

rule "Editor | Menu - HUD":
    @Condition EditorOn
    #!disableOptimizations
    hudText(hostPlayer if hostPlayer.MenuIsVisible() else false,
        #hostPlayer.MenuText_Translated_Vertical(),
        hostPlayer.MenuText_Translated(),
        hostPlayer.MenuPreview_Translated(),
        LeftAlign128, HudPosition.LEFT, null, Color.WHITE, Color.WHITE, null, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #!optimizeForSize
    #createInWorldText(hostPlayer if hostPlayer.MenuIsVisible() else false, hostPlayer.MenuText_Translated(), worldVector(100 * Vector.FORWARD, hostPlayer, Transform.ROTATION_AND_TRANSLATION), 2)

rule "Editor | Menu - Visibility":
    @Condition EditorOn
    @Condition hostPlayer.isHoldingButton(Button.MELEE)
    hostPlayer.MenuToggleVisibility()

rule "Editor | Menu - Move Selection":
    @Condition hostPlayer.MenuIsVisible()
    @Condition hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) != hostPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    if hostPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        hostPlayer.MenuNext()
    else:
        hostPlayer.MenuPrev()

rule "Editor | Menu - Selected Menu or Action":
    @Condition hostPlayer.MenuIsVisible()
    #@Condition hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) != hostPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition hostPlayer.isHoldingButton(Button.JUMP) != hostPlayer.isHoldingButton(Button.CROUCH)
    #hostPlayer.__MenuSelection__ = hostPlayer.MenuGetVerticalSelect()
    if hostPlayer.isHoldingButton(Button.CROUCH): # if hostPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        hostPlayer.__MenuSelection__ = null
    hostPlayer.MenuSelect()

MenuCreate(menu = {
    text: `t"Main Menu
 1. Editor Options
 2. Create Checkpoint
 3. Delete Checkpoint
 4. Edit Checkpoint
 5. Next Checkpoint
 6. Previous Checkpoint
 7. Export Map Data
 0. Close"`,
    /* code: `smallMessage(true[0], "  Hello!") #hostPlayer.MenuToggleVisibility()`, */
    pages: [
        { //#Editor Options
            text: `t"Editor Options
 1. Fly
 2. Walk
 3. Collision Off
 4. Collision On
 5. Move Slow 3%
 6. Move Normal 100%
 7. Move Fast 300%
 8. Slow Motion 50%
 9. Slow Motion Off
 10. Toggle Visual Hitbox
 0. Back"`,
            pages: [
                { code: `hostPlayer.startForcingPosition(hostPlayer.getPosition() + hostPlayer.flyMovementDelta(), true)` },
                { code: `hostPlayer.stopForcingPosition()` },
                { code: `hostPlayer.disableEnvironmentCollision(false)` },
                { code: `hostPlayer.enableEnvironmentCollision()` },
                { code: `hostPlayer.setMoveSpeed(3)` },
                { code: `hostPlayer.setMoveSpeed(100)` },
                { code: `hostPlayer.setMoveSpeed(300)` },
                { code: `setSlowMotion(50)` },
                { code: `setSlowMotion(100)` },
                { code: `hostPlayer.editor_hitboxToggle = not hostPlayer.editor_hitboxToggle`}
            ]
        },
        { //#Create Checkpoint
            code: `
                if len(CheckpointPositions) and distance(hostPlayer, CheckpointPositions[hostPlayer.checkpoint_current]) <= cpCircleRadius:
                    smallMessage(hostPlayer, "   Cannot Place Checkpoint Too Close.") #"   放置的检查点距离太近"
                else:
                    hostPlayer.checkpoint_current++
                    CheckpointPositions.insertAt(hostPlayer.checkpoint_current, hostPlayer.getPosition())
                    #Abilities
                    UltCheckpoints.shiftAt(hostPlayer.checkpoint_current)
                    Ability1Checkpoints.shiftAt(hostPlayer.checkpoint_current)
                    #Bans
                    BanMulti.shiftAt(hostPlayer.checkpoint_current)
                    BanCreate.shiftAt(hostPlayer.checkpoint_current)
                    BanStand.shiftAt(hostPlayer.checkpoint_current)
                    BanDead.shiftAt(hostPlayer.checkpoint_current)
                    BanEmote.shiftAt(hostPlayer.checkpoint_current)
                    BanClimb.shiftAt(hostPlayer.checkpoint_current)
                    BanSaveDouble.shiftAt(hostPlayer.checkpoint_current)
                    BanBhop.shiftAt(hostPlayer.checkpoint_current)
                    BanDjump.shiftAt(hostPlayer.checkpoint_current)

                    smallMessage(hostPlayer, "   Checkpoint Created!")
                    hostUpdateCache()`
        },
        { //#Delete Checkpoint
            code: `
                #Abilities
                UltCheckpoints.removeAndShift(hostPlayer.checkpoint_current)
                Ability1Checkpoints.removeAndShift(hostPlayer.checkpoint_current)
                #Bans
                BanMulti.removeAndShift(hostPlayer.checkpoint_current)
                BanCreate.removeAndShift(hostPlayer.checkpoint_current)
                BanStand.removeAndShift(hostPlayer.checkpoint_current)
                BanDead.removeAndShift(hostPlayer.checkpoint_current)
                BanEmote.removeAndShift(hostPlayer.checkpoint_current)
                BanClimb.removeAndShift(hostPlayer.checkpoint_current)
                BanSaveDouble.removeAndShift(hostPlayer.checkpoint_current)
                BanBhop.removeAndShift(hostPlayer.checkpoint_current)
                BanDjump.removeAndShift(hostPlayer.checkpoint_current)
                
                del CheckpointPositions[hostPlayer.checkpoint_current]
                hostPlayer.checkpoint_current = max(hostPlayer.checkpoint_current - 1, 0 - not len(CheckpointPositions))
                smallMessage(hostPlayer, "   Checkpoint Deleted!")
                hostUpdateCache()`
        },
        { //#Edit Checkpoint
            text: `t"Edit Checkpoint
 1. Move Checkpoint
 2. Toggle Teleport
 3. Set Facing Angle
 4. Abilities
 5. Ban Skills
 6. Objects
 0. Back"`,
            code: `
    if not len(CheckpointPositions):
        smallMessage(hostPlayer, t"  ▶ Create Checkpoint")
        hostPlayer.MenuInvalidateSelect()
    `,
            pages: [
                { //#Move Checkpoint
                    code: `pass`
                },
                { //#Toggle Teleport
                    code: `
                        if hostPlayer.checkpoint_current <= 0:
                            smallMessage(hostPlayer, "   Teleport Unavailable For Level") # "   不能在第一个检查点设置传送门"
                        elif len(CheckpointPositions[hostPlayer.checkpoint_current]) > 1:
                            CheckpointPositions[hostPlayer.checkpoint_current] = CheckpointPositions[hostPlayer.checkpoint_current][0]
                            smallMessage(hostPlayer, "   Teleport Removed For Level") # "   关卡{0}的传送点已移除"
                        else:
                            CheckpointPositions[hostPlayer.checkpoint_current] = [CheckpointPositions[hostPlayer.checkpoint_current], hostPlayer.getPosition()]
                            smallMessage(hostPlayer, "   Teleport Added For Level") # "   传送点已添加到当前关卡"`
                },
                { //#Set Facing Angle
                    code: `pass`
                },
                { //#Abilities
                    text: `ft"Abilities
 1. Ultimate {abilityIconString(FwHero.Hero, Button.ULTIMATE)}
 2. Ability 1 {abilityIconString(FwHero.Hero, Button.ABILITY_1)}
 #. Ability 2 {abilityIconString(FwHero.Hero, Button.ABILITY_2)}
 #. Primary Fire
 #. Secondary Fire
 #. Crouch
 #. Jump
 0. Back"`,
                    pages: [
                        {
                            text: `ft"Ultimate: {hostPlayer.checkpoint_current in UltCheckpoints}\n 1. On\n 2. Off\n 0. Back"`,
                            update: true,
                            pages: [
                                {code: `UltCheckpoints.addUnique(hostPlayer.checkpoint_current)`},
                                {code: `UltCheckpoints.remove(hostPlayer.checkpoint_current)`}
                            ]
                        },
                        {
                            text: `ft"Ability 1: {hostPlayer.checkpoint_current in Ability1Checkpoints}\n 1. On\n 2. Off\n 0. Back"`,
                            update: true,
                            pages: [
                                {code: `Ability1Checkpoints.addUnique(hostPlayer.checkpoint_current)`},
                                {code: `Ability1Checkpoints.remove(hostPlayer.checkpoint_current)`}
                            ]
                        }
                    ]
                },
                { //#Ban Skills
                    text: `t"Ban Skills
 1. Multi-Climb ∞ 
 2. Create ♂
 3. Stand Create ♠
 4. Dead Hop X
 5. Emote ♥
 6. Save Double △
 7. Climb ↑
 - - - - - - - - - - - -
 8. Bhop ≥
 9. Double Jump »
 0. Back"`,
                    pages: [
                        {
                            text: `ft"Ban Multi-Climb ∞: {hostPlayer.checkpoint_current in BanMulti}\n 1. On\n 2. Off\n 0. Back"`,
                            update: true,
                            pages: [
                                {code: `BanMulti.addUnique(hostPlayer.checkpoint_current)`},
                                {code: `BanMulti.remove(hostPlayer.checkpoint_current)`}
                            ]
                        },
                        {
                            text: `ft"Ban Create ♂: {hostPlayer.checkpoint_current in BanCreate}\n 1. On\n 2. Off\n 0. Back"`,
                            update: true,
                            pages: [
                                {code: `BanCreate.addUnique(hostPlayer.checkpoint_current)`},
                                {code: `BanCreate.remove(hostPlayer.checkpoint_current)`}
                            ]
                        },
                        {
                            text: `ft"Ban Stand Create ♠: {hostPlayer.checkpoint_current in BanStand}\n 1. On\n 2. Off\n 0. Back"`,
                            update: true,
                            pages: [
                                {code: `BanStand.addUnique(hostPlayer.checkpoint_current)`},
                                {code: `BanStand.remove(hostPlayer.checkpoint_current)`}
                            ]
                        },
                        {
                            text: `ft"Ban Dead Hop ×: {hostPlayer.checkpoint_current in BanDead}\n 1. On\n 2. Off\n 0. Back"`,
                            update: true,
                            pages: [
                                {code: `BanDead.addUnique(hostPlayer.checkpoint_current)`},
                                {code: `BanDead.remove(hostPlayer.checkpoint_current)`}
                            ]
                        },
                        {
                            text: `ft"Ban Emote ♥: {hostPlayer.checkpoint_current in BanEmote}\n 1. On\n 2. Off\n 0. Back"`,
                            update: true,
                            pages: [
                                {code: `BanEmote.addUnique(hostPlayer.checkpoint_current)`},
                                {code: `BanEmote.remove(hostPlayer.checkpoint_current)`}
                            ]
                        },
                        {
                            text: `ft"Ban Save Double △: {hostPlayer.checkpoint_current in BanSaveDouble}\n 1. On\n 2. Off\n 0. Back"`,
                            update: true,
                            pages: [
                                {code: `BanSaveDouble.addUnique(hostPlayer.checkpoint_current)`},
                                {code: `BanSaveDouble.remove(hostPlayer.checkpoint_current)`}
                            ]
                        },
                        {
                            text: `ft"Ban Climb ↑: {hostPlayer.checkpoint_current in BanClimb}\n 1. On\n 2. Off\n 0. Back"`,
                            update: true,
                            pages: [
                                {code: `BanClimb.addUnique(hostPlayer.checkpoint_current)`},
                                {code: `BanClimb.remove(hostPlayer.checkpoint_current)`}
                            ]
                        },
                        {
                            text: `ft"Unused Bhop ≥: {hostPlayer.checkpoint_current in BanBhop}\n 1. On\n 2. Off\n 0. Back"`,
                            update: true,
                            pages: [
                                {code: `BanBhop.addUnique(hostPlayer.checkpoint_current)`},
                                {code: `BanBhop.remove(hostPlayer.checkpoint_current)`}
                            ]
                        },
                        {
                            text: `ft"Unused Double Jump »: {hostPlayer.checkpoint_current in BanDjump}\n 1. On\n 2. Off\n 0. Back"`,
                            update: true,
                            pages: [
                                {code: `BanDjump.addUnique(hostPlayer.checkpoint_current)`},
                                {code: `BanDjump.remove(hostPlayer.checkpoint_current)`}
                            ]
                        }
                    ]
                },
                { //#Objects
                    text: `t"Objects
 1. Collectibles
 2. Lava Spheres
 3. Portals
 4. Targets
 5. Group Up
 6. Safe Zones
 7. Dummies
 0. Back"`,
                    pages: [
                        {
                            text: `t"Collectable Orbs
 1. Create
 2. Move
 3. Delete
 4. Next
 5. Previous
 0. Back"`,
                            pages: [0, 0, 0, 0, 0]
                        },
                        {
                            text: `t"Lava Spheres
 1. Create
 2. Move
 3. Delete
 4. Next
 5. Previous
 0. Back"`,
                            pages: [0, 0, 0, 0, 0]
                        },
                        {
                            text: `t"Portals
 1. Create
 2. Move
 3. Delete
 4. Next
 5. Previous
 0. Back"`,
                            pages: [0, 0, 0, 0, 0]
                        },
                        {
                            text: `t"Targets
 1. Create
 2. Move
 3. Delete
 4. Next
 5. Previous
 0. Back"`,
                            pages: [0, 0, 0, 0, 0]
                        },
                        {
                            text: `t"Group Up
 1. Create
 2. Move
 3. Delete
 4. Next
 5. Previous
 0. Back"`,
                            pages: [0, 0, 0, 0, 0]
                        },
                        {
                            text: `t"Safe Zones
 1. Create
 2. Move
 3. Delete
 4. Next
 5. Previous
 0. Back"`,
                            pages: [0, 0, 0, 0, 0]
                        },
                        {
                            text: `t"Dummies
 1. Create
 2. Move
 3. Delete
 4. Next
 5. Previous
 0. Back"`,
                            pages: [0, 0, 0, 0, 0]
                        },
                    ]
                },
            ]
        },
        { //#Next Checkpoint
            code: `
                hostPlayer.checkpoint_current += true
                hostPlayer.checkpoint_current %= len(CheckpointPositions)
                hostUpdateReset()`
        },
        { //#Previous Checkpoint
            code: `
                hostPlayer.checkpoint_current += len(CheckpointPositions) - true
                hostPlayer.checkpoint_current %= len(CheckpointPositions)
                hostUpdateReset()`
        },
        { //#Export Map Data
            code: `
                hostPlayer.MenuToggleVisibility()
                hostPlayer.editor_saveCache = [TimeRemaining, ColorConfig, __MenuPointer__, __MenuString__]
                EditorOn = null
                TimeRemaining = null
                ColorConfig = null
                __MenuPointer__ = null
                __MenuString__ = null
                __overpyTranslationHelper__ = null
                if Name == "name here - 作者":
                    Name = "{}".format(hostPlayer)
                Cachedcredits = [Name, Code]
                Name = null
                Code = null

                enableInspector()
                disableInspector()

                EditorOn = true
                TimeRemaining = hostPlayer.editor_saveCache[0]
                ColorConfig = hostPlayer.editor_saveCache[1]
                __MenuPointer__ = hostPlayer.editor_saveCache[2]
                __MenuString__ = hostPlayer.editor_saveCache.last()
                __overpyTranslationHelper__ = "\uec480White0白色0흰색".split(null[0])`
        }
    ]
})