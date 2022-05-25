local registry = include("ItemRegistry")
local item = {}
local mod = RegisterMod("GK Controller", 1)
TrinketType.TRINKET_GK_CONTROLLER = Isaac.GetTrinketIdByName("GK Controller")

__eidTrinketDescriptions[TrinketType.TRINKET_GK_CONTROLLER] = "#↑ 0.125 Speed#↑ -0.5 FireDelay"

local function EvalCache(_, player, cache)
	if (player:HasTrinket(TrinketType.TRINKET_GK_CONTROLLER)) then
		if (cache & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED) then
		player.MoveSpeed = player.MoveSpeed + 0.125
		elseif(cache & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY) then
		player.MaxFireDelay = player.MaxFireDelay - 0.5
	  	end
	end
end
  

  
 --[[ `
local function EvalCache(_, player, cache)
	if player:HasTrinket(Isaac.GetTrinketIdByName("GK Controller")) then
		player.Speed = player.Speed + 0.125
		player.MaxFireDelay = player.MaxFireDelay - 0.5
	end
end
]]
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvalCache)