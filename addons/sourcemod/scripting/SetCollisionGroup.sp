///////////////////////////////////////////////////////////////////////////////
// Credits:
//      https://bugs.alliedmods.net/show_bug.cgi?id=6348
//      https://web.archive.org/web/20190406220848/https://forum.facepunch.com/gmoddev/likl/Crazy-Physics-cause-found/1/
///////////////////////////////////////////////////////////////////////////////

#pragma semicolon 1

#define PLUGIN_NAME         "CollisionGroup"
#define PLUGIN_AUTHOR       "destoer & Dunder"
#define PLUGIN_DESCRIPTION  "Uses the correct way to set collision groups"
#define PLUGIN_VERSION      "1.0.0"
#define PLUGIN_URL          "https://github.com/ashort96/SetCollisionGroup"

#include <cstrike>
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
    if(game != Engine_CSS)
    {
        SetFailState("This plugin has only been tested for CS:S!");
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

public APLRes ASkPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    CreateNative("SetClientCollision", NativeSetClientCollision);
    CreateNative("SetAllCollision", NativeSetAllCollision);
    return APLRes_Success;
}

public int NativeSetClientCollision(Handle plugin, int numParams)
{
    int client = GetNativeCell(1);
    int group = GetNativeCell(2);
    SDKCall(SetCollisionGroup, client, group);
}


public int NativeSetAllCollision(Handle plugin, int numParams)
{
    int group = GetNativeCell(1);
    for(int i = 1; i < MaxClients; i++)
    {
        if(IsValidClient(i))
            SetClientCollision(i, group);
    }
}

stock bool IsValidClient(int client)
{
    if(client <= 0 || client > MaxClients)
        return false;
    if(!IsClientConnected(client))
        return false;
    if(!IsClientInGame(client))
        return false;
    if(!IsPlayerAlive(client))
        return false;
    return true;
}