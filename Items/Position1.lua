local registry = include("ItemRegistry")
local item = {}
local hasitem = false
local roomKillCount = 0

local rng = RNG()
rng:SetSeed(Random(), 1)

local bonus_stats = {
  b_damage = 0, --int
  b_firedelay = 0, -- float
  b_shotspeed = 0, -- float
  b_range = 0, -- float
  b_speed = 0, -- float
  b_luck = 0 -- float
}

boi.Position1_blacklist = {
	["85.0"] = true, -- Spider
	["18.0"] = true, -- Attack Fly
	["13.0"] = true, -- Fly
	["296.0"] = true, -- Hush Fly
}

local function Post_Player_Update(_, player)

end

local function Post_Npc_Death(_, e)
  if e:IsEnemy() and not e:ToNPC():IsBoss() then
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(registry.Position1) then
      if (roomKillCount < 15) then
        local temp = rng:RandomInt(6)
        if (temp == 0) then
          --player.Damage = player.Damage + (0.03)
          bonus_stats.b_damage = bonus_stats.b_damage + 1
          player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
          player:EvaluateItems()
        elseif (temp == 1) then
            --player.MaxFireDelay = player.MaxFireDelay - (0.02)
          bonus_stats.b_firedelay = bonus_stats.b_firedelay + 1
          player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
          player:EvaluateItems()
        elseif (temp == 2) then
          -- player.ShotSpeed = player.ShotSpeed + (0.03)
          bonus_stats.b_shotspeed = bonus_stats.b_shotspeed + 1
          player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
          player:EvaluateItems()
        elseif (temp == 3) then
            --player.MoveSpeed = player.MoveSpeed + (0.02)
          bonus_stats.b_speed = bonus_stats.b_speed + 1
          player:AddCacheFlags(CacheFlag.CACHE_SPEED)
          player:EvaluateItems()
        elseif (temp == 4) then
          --player.Luck = player.Luck + (0.03)
          bonus_stats.b_luck = bonus_stats.b_luck + 1
          player:AddCacheFlags(CacheFlag.CACHE_LUCK)
          player:EvaluateItems()
        elseif (temp == 5) then
          --player.TearRange = player.TearRange + (0.05)
        bonus_stats.b_range = bonus_stats.b_range + 1
        player:AddCacheFlags(CacheFlag.CACHE_RANGE)
        player:EvaluateItems()
        end
        roomKillCount = roomKillCount + 1
      end
    end
  end
end

local function EvalCache(_, player, cache)
  local d = player:GetData()
	if player:HasCollectible(registry.Position1) then
    if (cache == CacheFlag.CACHE_DAMAGE) then
        player.Damage = player.Damage + (0.03 * bonus_stats.b_damage)
    elseif (cache == CacheFlag.CACHE_FIREDELAY) then
        player.MaxFireDelay = player.MaxFireDelay - (0.02 * bonus_stats.b_firedelay)
      elseif (cache == CacheFlag.CACHE_SHOTSPEED) then
        player.ShotSpeed = player.ShotSpeed + (0.03 * bonus_stats.b_shotspeed)
      elseif (cache == CacheFlag.CACHE_SPEED) then
        player.MoveSpeed = player.MoveSpeed + (0.01 * bonus_stats.b_speed)
    elseif (cache == CacheFlag.CACHE_LUCK) then
      player.Luck = player.Luck + (0.05 * bonus_stats.b_luck)
    elseif (cache == CacheFlag.CACHE_RANGE) then
      player.TearRange = player.TearRange + (0.2 * bonus_stats.b_range)
    end
  end
end

local function NewRoom(_)
  roomKillCount = 0
end

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, NewRoom)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, Post_Npc_Death)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Post_Player_Update)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvalCache)
end

return item
