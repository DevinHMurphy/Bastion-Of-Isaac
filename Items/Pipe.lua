local registry = include("ItemRegistry")
local Game = Game()
local item = {}

CollectibleType.COLLECTIBLE_PIPE = Isaac.GetItemIdByName("Pipe")

--KILL THIS LINE?
--boi.TimedActives[CollectibleType.COLLECTIBLE_PIPE] = true

--FOR EFFECTS
--EffectVariant.SNAP_BANG = Isaac.GetEntityVariantByName("Snap Bang")

--ITEM DESCRIPTION
--__eidItemDescriptions[CollectibleType.COLLECTIBLE_SNAP_BANG] = "On use places a small explosive charge on the floor#Explodes on contact with any monster#Deals 2x player damage and confuses enemies within explosion radius"

-- SEE Items.xml for the other half of what you need to do for this item!
local function EvalCache(_, player, cache)  
  if (cache & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE) then
    if (player:HasCollectible(registry.Pipe)) then
      local dat = player:GetData()["PipeUses"] or 0 -- dat is equal to whatever ElysiumUses equals, or 0 if it doesn't have a value.
      player.Damage = player.Damage * (dat + 1) -- multiply luck by the number of times Elysium has being used for the room + 1 (because 1 times anything is itself otherwise)
      sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_0, 1, 0, false, 1)
    end
  end
end

local function UseItem(_, collecitble, rng, player)
  local dat = player:GetData()["PipeUses"] -- grab the value of ElysiumUses
  player:GetData()["PipeUses"] = (dat and dat + 1) or 1
  -- set the ElysiumUses to what it currently is plus one, or if it doesn't exist yet, set it to 1
end

local function NewRoom()
  for i = 0, Game:GetNumPlayers()-1 do -- simple code to reset ElysiumUses for every player on a new room.
    local player = Isaac.GetPlayer(i)
    player:GetData()["PipeUses"] = 0
  end
end

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvalCache)
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseItem, registry.Pipe) -- USE_ITEM lets us give a third arg of a filter of what collectible we want to detect got used.
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, NewRoom)
end

return item
