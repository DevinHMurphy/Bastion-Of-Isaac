local registry = include("ItemRegistry")
local item = {}

local rng = RNG()
local held_levels = 1
local held = false

-- SEE Items.xml for the other half of what you need to do for this item!

local function EvalCache(_, player, cache)
	if player:HasCollectible(registry.MasterSeal) then
    if (cache == CacheFlag.CACHE_DAMAGE) then
      player.Damage = player.Damage + (0.3 * held_levels)
    elseif (cache == CacheFlag.CACHE_FIREDELAY) then
      player.MaxFireDelay = player.MaxFireDelay - (0.5 * held_levels)
    elseif (cache == CacheFlag.CACHE_SPEED) then
      player.MoveSpeed = player.MoveSpeed + (0.05 * held_levels)
    elseif (cache == CacheFlag.CACHE_LUCK) then
      player.Luck = player.Luck + (0.5 * held_levels)
    elseif (cache == CacheFlag.CACHE_RANGE) then
      player.TearRange = player.TearRange + (4 * held_levels)
    end
  end 
end

local function Post_Player_Update(_, player)
  if (player == nil) then return end
  if not player:HasCollectible(registry.MasterSeal) then held = false
  else held = true 
  end

end

local function MC_POST_GAME_STARTED(_, continued)
  if (continued == false) then 
    held_levels = 1
    held = false
  end
end

local function MC_POST_NEW_LEVEL()
  if held then
    held_levels = held_levels + 1
    Isaac.GetPlayer(0):EvaluateItems()
  end
end


function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Post_Player_Update)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, MC_POST_NEW_LEVEL)
  mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, MC_POST_GAME_STARTED)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvalCache)
  
end

return item
