#!optimizeForSize
##!suppressWarnings w_ow2_communicate_bug
##!suppressWarnings w_tags
#!suppressWarnings w_lone_else
#!suppressWarnings w_enum_constant
###############################################################################
#!define versionhere "v1.10.3G"
#♨ Dev Build Icon
###############################################################################
#!define editortoggle(x) __script__("test-maps/togglescript.js")
editortoggle(0) # 0 is editor, rest is numbers
###############################################################################
#!define importHero(Hero) __script__('mechanics/fwHero.js')
###############################################################################
macro COMPILE_FOR_CHINESE = false
# Enable Invis Command (Invis Command cant be pasted in CN client die to null and none translating to same symbol)
# Debug force CN mode on (No longers works)
##!define checkCN if true else
###############################################################################
# Max orbs can be made
macro fxLimit = 193
# Portal distance: 1.3
macro portalDistance = 1.3
# Circle radius: 1.4
macro cpcircleradius = 1.4
# Default fx: 1
macro cpCirkleFx = 1
# Orb range for player: 1.4
macro bounceorbdistance = 1.4
# Height added to player for orb detection: 0.7
macro bounceoffset = 0.7
# Enable perks: false
macro usePerks = false
# non-practice cheat mode: false
macro cpCheat = false
# defaults: off, attempt:5, 120 min, restart:false
macro compModeToggle = false
macro attemptCount = 5
macro compTimeLimit = 120
macro compRestartLimit = false
###############################################################################
#!include "settings.opy"
###############################################################################
#!include "definitions.opy"
###############################################################################
#!globalvarInitRuleName "OverPy | Global Init"
#!playervarInitRuleName "OverPy | Player Init"
###############################################################################
#$$ TODO multi-lingual support
##!translations en ko zh
###############################################################################
#!include "parkour.opy"
###############################################################################
#$$ TODO proper multi-hero support
#!include "mechanics/all.opy"
importHero(["GENJI" /*, "HANZO", "HAZARD", "KIRIKO"*/][0])
###############################################################################
#!include "editor.opy"
###############################################################################
#!include "commands.opy"
###############################################################################
#!include "huds.opy"
###############################################################################
#!include "effects.opy"
###############################################################################
#!include "addons-page1.opy"
###############################################################################
rule "MAP DATA - 地图数据":
    @NewPage ("<tx0C000000000207B5><fgFFFF00FF> "
    "Map Data & Addon Settings Are On Page 2 - 地图数据和附加组件的设置在第2页")
###############################################################################
testData
###############################################################################
#!include "customize.opy"
###############################################################################
#!include "addons-page2.opy"
###############################################################################
# Enable/disable the include
##!include "test-scripts.opy"