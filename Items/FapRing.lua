local registry = include("ItemRegistry")
local item = {}


local hasitem = false
local haditem = false

local ringFap = Isaac.GetItemIdByName("Ring of Favor and Protection")


local function Post_Player_Update(_, player)
  for _, e in pairs(Isaac.GetRoomEntities()) do
    if e.Type == EntityType.ENTITY_PICKUP and e.Variant == PickupVariant.PICKUP_COLLECTIBLE then
      if e.SubType > 0 and not (e:IsShopItem()) then
        if (itemToRift.SubType == registry.FapRing and haditem == true) then
        -- remove item
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, itemToRift.Position, Vector(0,0), Isaac.GetPlayer(0))
        --SFXManager():Play(SoundEffect.SOUND_DIVINE_INTERVENTION, 1.5, 0, false, 0.8)
        e:Remove()
        end
      end
    end
  end        

  if (player == nil or not player:HasCollectible(registry.FapRing)) then 
    if (hasitem == true) then haditem = true
    else hasitem = false
    end
  else hasitem = true
  end
end

local function EvalCache(_, player, cache)
  local d = player:GetData()
	if player:HasCollectible(registry.FapRing) then
    if (cache == CacheFlag.CACHE_DAMAGE) then
        player.Damage = player.Damage + 0.3
    elseif (cache == CacheFlag.CACHE_FIREDELAY) then
        player.MaxFireDelay = player.MaxFireDelay - 2
    elseif (cache == CacheFlag.CACHE_SPEED) then
        player.MoveSpeed = player.MoveSpeed + 0.2
    elseif (cache == CacheFlag.CACHE_LUCK) then
      player.Luck = player.Luck + 1.2
    elseif (cache == CacheFlag.CACHE_RANGE) then
      player.TearRange = player.TearRange + 20
    end
  elseif (haditem == true) then
      player.AddMaxHearts(-2)
  end   --[[
  if (cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE) then
    if (player:HasCollectible(registry.FapRing)) then
      player.Damage = player.Damage + 0.5
    end
  end
  ]]

end

function item:Init(mod)
 --mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Post_Player_Update)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvalCache)
end

return item
