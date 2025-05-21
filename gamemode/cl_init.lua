hook.Run("DarkRPStartedLoading")

GM.Version = "2.7.0"
GM.Name = "DarkRP"
GM.Author = "By FPtje Falco et al."

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")
GM.Sandbox = BaseClass


--[[
    Previously used SortedPairs but it never had any effect since file.Find returned sequential tables so SortedPairsByValue would have needed to be used.
    Now changing this could break others shit if they didn't account for their loading order
]]
local function LoadModules()
    local root = GM.FolderName .. "/gamemode/modules/"
    local _, folders = file.Find(root .. "*", "LUA")

    for _, folder in ipairs(folders) do
        if DarkRP.disabledDefaults["modules"][folder] then continue end

        for _, File in ipairs(file.Find(root .. folder .. "/*.lua", "LUA")) do
            if File:StartsWith("sh_") then
                if File == "sh_interface.lua" then continue end
                include(root .. folder .. "/" .. File)
                continue
            end

            if File:StartsWith("cl_") then
                if File == "cl_interface.lua" then continue end
                include(root .. folder .. "/" .. File)
                continue
            end
        end
    end
end

GM.Config = {} -- config table
GM.NoLicense = GM.NoLicense or {}

include("config/config.lua")
include("libraries/sh_cami.lua")
include("libraries/simplerr.lua")
include("libraries/fn.lua")
include("libraries/tablecheck.lua")
include("libraries/interfaceloader.lua")
include("libraries/disjointset.lua")
include("config/licenseweapons.lua")

include("libraries/modificationloader.lua")

hook.Call("DarkRPPreLoadModules", GM)

LoadModules()

DarkRP.DARKRP_LOADING = true
include("config/jobrelated.lua")
include("config/addentities.lua")
include("config/ammotypes.lua")
DarkRP.DARKRP_LOADING = nil

DarkRP.finish()

hook.Call("DarkRPFinishedLoading", GM)
