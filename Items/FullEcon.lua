local registry = include("ItemRegistry")
local item = {}

local item_pickups = {
  Coin_Count = 0, --int
  Key_Count = 0, -- float
  Bomb_Count = 0, -- float
}

local pickups_threshold = {
Coin_calc = -1, 
Key_calc = -1, 
Bomb_calc = -1, 
}

local function Post_Player_Update(_, player)
  if (not player:HasCollectible(registry.FullEcon)) then return end
  if (pickups_threshold.Coin_calc == -1 and pickups_threshold.Key_calc == -1 and pickups_threshold.Bomb_calc == -1) then 
    pickups_threshold.Coin_calc = player:GetNumCoins()
    pickups_threshold.Key_calc = player:GetNumKeys()
    pickups_threshold.Bomb_calc = player:GetNumBombs()
  end
  if (player:GetNumCoins() > pickups_threshold.Coin_calc or player:GetNumKeys() > pickups_threshold.Key_calc or player:GetNumBombs() > pickups_threshold.Bomb_calc) then
    if (player:GetNumCoins() > pickups_threshold.Coin_calc) then
      sfx:Play(Isaac.GetSoundIdByName("Ya"), 1, 0, false, 1)
      item_pickups.Coin_Count = item_pickups.Coin_Count + 1
      player:AddCoins(-1)
      player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
      player:EvaluateItems()
    end
    if (player:GetNumKeys() > pickups_threshold.Key_calc) then
      sfx:Play(Isaac.GetSoundIdByName("Ya"), 1, 0, false, 1)
      item_pickups.Key_Count = item_pickups.Key_Count + 1
      player:AddKeys(-1)
      player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
      player:EvaluateItems()
    end
    if (player:GetNumBombs() > pickups_threshold.Bomb_calc) then
      sfx:Play(Isaac.GetSoundIdByName("Ya"), 1, 0, false, 1)
      item_pickups.Bomb_Count = item_pickups.Bomb_Count + 1
      player:AddBombs(-1)
      player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
      player:EvaluateItems()
    end
  end
end
  

local function EvalCache(_, player, cache)
	if player:HasCollectible(registry.FullEcon) then
    if (cache == CacheFlag.CACHE_DAMAGE) then
        player.Damage = player.Damage + (0.1 * item_pickups.Bomb_Count)
    elseif (cache == CacheFlag.CACHE_FIREDELAY) then
        player.MaxFireDelay = player.MaxFireDelay - (0.1 * item_pickups.Key_Count)
    elseif (cache == CacheFlag.CACHE_SHOTSPEED) then
        player.ShotSpeed = player.ShotSpeed + (0.04 * item_pickups.Coin_Count)
    end
  end
end

local function MC_POST_GAME_STARTED(_, continued)
  if (continued == false) then 
    item_pickups.Coin_Count = 0
    item_pickups.Key_Count = 0
    item_pickups.Bomb_Count = 0
    pickups_threshold.Coin_calc = -1
    pickups_threshold.Key_calc = -1
    pickups_threshold.Bomb_calc = -1
  end
end


function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, MC_POST_GAME_STARTED)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Post_Player_Update)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvalCache)
end

return item
