local registry = include("ItemRegistry")
local item = {}

local rng = RNG()
rng:SetSeed(Random(), 1)

-- SEE Items.xml for the other half of what you need to do for this item!

local function TriggerEffect(player)
end


local function Post_Player_Update(_, player)
  if (player == nil) then return
  elseif not player:HasCollectible(registry.FapRinga) then 
    if player:HasCollectible(registry.FapRing) then 
      for _, e in pairs(Isaac.GetRoomEntities()) do
        if e.Type == EntityType.ENTITY_PICKUP and e.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        sfx:Play(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 0.6)
        player:AnimateSad()
        e:Remove()
        player:RemoveCollectible(registry.FapRing)
        player:AddMaxHearts(-2)
        return
        end
      end
    end
  elseif player:HasCollectible(registry.FapRinga) and not player:HasCollectible(registry.FapRing) then
    player:AddCollectible(registry.FapRing)
  else return
  end
end

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Post_Player_Update)
end

return item
