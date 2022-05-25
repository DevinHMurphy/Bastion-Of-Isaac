local registry = include("ItemRegistry")
local item = {}
local hasitem = false
local rng = RNG()
rng:SetSeed(Random(), 1)
local cachedLuck = 0.0
local allowedPickupVariants = {
  10, 20, 30, 40, 41, 42, 50, 60, 70, 
}
local allowedChestVariants = {
  51, 52, 53, 54, 55, 56, 57, 58
}

local function Post_Player_Update(_, player)
  if (player == nil or not player:HasCollectible(registry.lvl9)) then hasitem =false return -- Check to see if player has item
  else hasitem = true 
  end
end

local function NewRoom(_)
  if (hasitem == true) then
    for _, e in pairs(Isaac.GetRoomEntities()) do -- get all entities in a new room
      if e:IsEnemy() and e:IsVulnerableEnemy() and e:IsActiveEnemy() and e.Type ~= 302 and not e:ToNPC():IsChampion() and not e:ToNPC():IsBoss() then -- check if they are not a boss or invincible
      e:ToNPC():MakeChampion(Random(),-1, false) -- make them a random champion
      end
    end
  end
end

local function Post_Npc_Death(_, e)
 if e:IsEnemy() and e:ToNPC():IsChampion() and not e:ToNPC():IsBoss() then -- check to see if the NPC dying is an enemy effected by lvl 
    if Isaac.GetPlayer(0):HasCollectible(registry.lvl9) then-- check to see if either player has Item 
      --Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, e.Position,Vector(0,0), nil)
      local x = rng:RandomInt(999)  -- set the base RNG to take an int out of 100 (100%)
    -- calculate the luck impacted proc chance

      if (x + (10 * cachedLuck) > 960) then 
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, e.Position,Vector(0,0), nil) -- spawn an item
        return
      elseif (x + (10 * cachedLuck) > 900) then 
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, e.Position, Vector(0,0), nil) -- spawn a trinket
        return
      elseif (x + (10 * cachedLuck) > 750) then --spawn a pickup
        local y = rng:RandomInt(8) -- get a new random int
          if (allowedPickupVariants[y] == 50) then  -- 
            local y2 = rng:RandomInt(7)
            Isaac.Spawn(5, allowedChestVariants[y2], -1, e.Position, Vector(1,0), nil)
          else 
            Isaac.Spawn(5, allowedPickupVariants[y], -1, e.Position, Vector(1,0), nil)
          end
          return
      else 
          return
      end
    end
 end
end

local function EvalCache(_, player, cache)
  local d = player:GetData()
	if player:HasCollectible(registry.lvl9) then
    if (cache == CacheFlag.CACHE_LUCK) then
      cachedLuck = player.Luck
    end
  end
end

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, NewRoom)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Post_Player_Update)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, Post_Npc_Death)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvalCache)

end

return item