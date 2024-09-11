#!mainFile "parkour.opy"
# code 代码
settings {
    "main": {
        "description": "  ~ The Official Genji Parkour Editor ~\nCode: 54CRY\nAdapted by: nebula#11571/FishoFire#2431",
        #"description": "  ~ The Official Genji Parkour Editor ~\nCode: 54CRY\nAdapted by: nebula#11571/FishoFire#2431",
        "modeName": "Genji Parkour - 源氏跑酷 - v" + versionhere
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "enableMatchVoiceChat": true,
        "spectatorSlots": 3,
        "team1Slots": 11,
        "team2Slots": 0,
        "returnToLobby": "never",
        "swapTeamsAfterMatch": false
    },
    "gamemodes": {
        "skirmish": {
            "enabledMaps": [
                "workshopIsland"
                #selectedmap
            ]
        },
        "tdm": {
            "enabledMaps": [],
            "gameLengthInMn": 15,
            "enableMercyRezKillCancel": false,
            "enableSelfInitiatedRespawn": false
        },
        "general": {
            "enableHeroSwitching": false,
            "enableEnemyHealthBars": false,
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "enableKillCam": false,
            "enableKillFeed": false,
            "respawnTime%": 0,
            "spawnHealthPacks": "disabled",
            "enableRandomHeroes": true,
        }
    },
    "heroes": {
        "allTeams": {
            "enabledHeroes": [
                "ana"
            ],
            "general": {
                "ultDuration%": 25,
                "passiveUltGen%": 0
            }
        }
    }
}

# extensions
#!extension playMoreEffects

#Global variables
globalvar CP_Pos 0
globalvar CP_Radius 1
globalvar CP_Hero 2


#Player variables
playervar CP_Index 0
playervar Immune 1

#Subroutine names

subroutine ResetPlayer 0
subroutine ResetAbilities 1