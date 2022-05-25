boi = RegisterMod("BastionOfIsaac", 1)
-- REGISTER MOD --

sfx = SFXManager()
-- INITIATE SFX MANAGER --

game = Game()
-- INITIATE GAME --

--######################################
--##### MAIN FROM PLAYER IMPORTER ######
--######################################

-- vars
local useCustomErrorChecker = true -- should the custom error checker be used?

-- file loc
local _, err = pcall(require, "")
local modName = err:match("/mods/(.*)/%.lua")
local path = "mods/" .. modName .. "/"

local function loadFile(loc, ...)
    return assert(loadfile(path .. loc .. ".lua"))(...)
end

local _, ogerr = pcall(function()
    local stats = loadFile("mod/stats")
    local imports = loadFile("mod/imports")
    include("EIDRegistry")
    loadFile("mod/MainMod",
             {modName, path, loadFile, stats, imports, useCustomErrorChecker})
end)

if (ogerr) then
    if (useCustomErrorChecker) then
        local errorChecker = loadFile("lib/cerror")
        errorChecker.registerError()

        errorChecker.mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED,
                                     function(_, IsContin)
            local room = Game():GetRoom()

            for i = 0, 8 do room:RemoveDoor(i) end
        end)

        local str = errorChecker.formatError(ogerr)

        if (str) then
            local file = str:match("%w+%.lua")
            local line = str:match(":(%d+):")
            local err = str:match(":%d+: (.*)")
            errorChecker.setMod(modName)
            errorChecker.setFile(file)
            errorChecker.setLine(line)
            errorChecker.printError("Error:", err)
            errorChecker.printError("")
            errorChecker.printError("For full error report, open log.txt")
            errorChecker.printError("")
            errorChecker.printError("Log Root: C:\\Users\\<YOUR USER>\\Documents\\My Games\\Binding of Isaac Repentance\\log.txt")
            errorChecker.printError("")
            errorChecker.printError("Reload the mod, then start a new run, Holding R works")
        else
            errorChecker.printError("Unexpected error occured, please open log.txt!")
            errorChecker.printError("Log Root: C:\\Users\\<YOUR USER>\\Documents\\My Games\\Binding of Isaac Repentance\\log.txt")
            errorChecker.printError("")
            errorChecker.printError(ogerr)
        end
        Isaac.DebugString("-- START OF " .. modName:upper() .. " ERROR --")
        Isaac.DebugString(ogerr)
        Isaac.DebugString("-- END OF " .. modName:upper() .. " ERROR --")

        local room = Game():GetRoom()

        for i = 0, 8 do room:RemoveDoor(i) end

        error()
    else
        Isaac.ConsoleOutput(modName ..
                                " has hit an error, see Log.txt for more info\n")
        Isaac.ConsoleOutput(
            "Log Root: C:\\Users\\<YOUR USER>\\Documents\\My Games\\Binding of Isaac Repentance\\log.txt")
        Isaac.DebugString("-- START OF " .. modName:upper() .. " ERROR --")
        Isaac.DebugString(ogerr)
        Isaac.DebugString("-- END OF " .. modName:upper() .. " ERROR --")
        error()
    end
end


--imports:Init(mod)
--SETTINGS
--local ROLL_KEY = Keyboard.KEY_LEFT_SHIFT; --you can see the values here https://moddingofisaac.com/docs/group___enumerations.html#gabcabfff8e6138e0943763148d70e5005
--local USE_DROP_KEY = true; --this is necessary if you play with a controller, but can be annoying otherwise

--local DEBUG = false; --makes random events 100%, enables debug strings, rolls for free

--To anyone looking through the code, if you see nested ifs and think "couldn't you have just put one if with and"? I think so, but nesting them may not call the second one if the first one isn't true, and maybe that could be more performance efficient. Or maybe not. If you know, pls tell me (I'm serious)

--CONSTANTS
boi.Items = {
    --EXAMPLE = Isaac.GetItemIdByName("Example Name")
    -- DIRK_PIPE = Isaac.GetItemIdByName("Dirk's Pipe"),
}

boi.Ents = {
    --ENTITIES GO HERE
    --BONFIRE = Isaac.GetEntityTypeByName("Bonfire"),
}

boi.Costumes = {
    -- COSTUMES GO HERE
    -- HOLLOW = Isaac.GetCostumeIdByPath("gfx/characters/costume_hollow.anm2")
}

boi.Challenges = {
    --CHALLENGES GO HERE
    --  ROLL = Isaac.GetChallengeIdByName("ROLL!");
}

--boi.TimedActives = {}}

local c = { -- CONSTANTS

UPDATE_MESSAGE = false, --if this version has an update boi.message
VERSION = 0.1,
LAST_MSG_VERSION = 0.1, -- version the user had before required to show the boi.message

DEFAULT_COLOR = Color(1,1,1,1,0,0,0),

}

--###########################
--#### METHODS/FUNCTIONS ####
--###########################

function GetPlayerUsingItem() -- Actives, Cards, Runes, and Pills
	for i = 1, Game():GetNumPlayers() - 1 do
    	local p = Isaac.GetPlayer(i)
 	    if Input.IsActionTriggered(ButtonAction.ACTION_ITEM, p.ControllerIndex) or Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, p.ControllerIndex) then
    		return p
	    end
	end
	return Isaac.GetPlayer(0)
end



