local registry = include("ItemRegistry")
local item = {}

local mod = RegisterMod("Zinogre Plate", 1)
local spawned_heart = false
TrinketType.TRINKET_ZINOGRE_PLATE = Isaac.GetTrinketIdByName("Zinogre Plate")

__eidTrinketDescriptions[TrinketType.TRINKET_ZINOGRE_PLATE] = "Drops a soul heart on first pickup#↑ 1.125 luck"

local function EvalCache(_, player, cache)
	if (player:HasTrinket(TrinketType.TRINKET_ZINOGRE_PLATE)) then
		if (cache & CacheFlag.CACHE_LUCK == CacheFlag.CACHE_LUCK) then
			player.Luck = player.Luck + 1.125
			if (spawned_heart == false) then
				Isaac.Spawn(5, 10, 3, player.Position, Vector(1,0), nil)
				spawned_heart = true
			end
		end
	end
end

  

  
local function Post_Player_Update(_, player)
	if (player == nil) then 
		spawned_heart = false 
		return end
	if not player:HasTrinket(TrinketType.TRINKET_ZINOGRE_PLATE) then return end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvalCache)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Post_Player_Update)