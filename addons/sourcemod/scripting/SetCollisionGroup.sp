///////////////////////////////////////////////////////////////////////////////
// Credits:
//      https://bugs.alliedmods.net/show_bug.cgi?id=6348
//      https://web.archive.org/web/20190406220848/https://forum.facepunch.com/gmoddev/likl/Crazy-Physics-cause-found/1/
//      Scags (https://github.com/Scags) for adding TF2 signature
///////////////////////////////////////////////////////////////////////////////

#pragma semicolon 1

#define PLUGIN_NAME         "CollisionGroup"
#define PLUGIN_AUTHOR       "destoer & Dunder"
#define PLUGIN_DESCRIPTION  "Uses the correct way to set collision groups"
#define PLUGIN_VERSION      "1.1.0"
#define PLUGIN_URL          "https://github.com/ashort96/SetCollisionGroup"

#include <sdktools>
#include <SetCollisionGroup>
#include <sourcemod>

Handle SetCollisionGroup;

public Plugin:myinfo =
{
    name = PLUGIN_NAME,
    author = PLUGIN_AUTHOR,
    description = PLUGIN_DESCRIPTION,
    version = PLUGIN_VERSION,
    url = PLUGIN_URL 
}

public OnPluginStart()
{
    EngineVersion game = GetEngineVersion();
    if(game != Engine_CSS && game != Engine_TF2)
    {
        SetFailState("This plugin only works for CS:S and TF2!");
    }

    Handle gameConf = LoadGameConfigFile("SetCollisionGroup");
    if(gameConf == INVALID_HANDLE)
    {
        ThrowError("Game data (SetCollisionGroup.txt) is unavailable!");
    }

    StartPrepSDKCall(SDKCall_Entity);
    if(!PrepSDKCall_SetFromConf(gameConf, SDKConf_Signature, "SetCollisionGroup"))
    {
        ThrowError("Signature not found in SetCollisionGroup.txt!");
    }

    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    SetCollisionGroup = EndPrepSDKCall();

    if(SetCollisionGroup == INVALID_HANDLE)
    {
        ThrowError("Function Handle invalid!");
    }

}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    CreateNative("SetEntityCollisionGroup", Native_SetEntityCollisionGroup);
    return APLRes_Success;
}

public int Native_SetEntityCollisionGroup(Handle plugin, int numParams)
{
    int entity = GetNativeCell(1);
    int group = GetNativeCell(2);
    SDKCall(SetCollisionGroup, entity, group);
}