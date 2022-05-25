local registry = include("ItemRegistry")
local item = {}

local rng = RNG()
rng:SetSeed(Random(), 1)
-- SEE Items.xml for the other half of what you need to do for this item!

local function TriggerEffect(player)
 -- if (not player:GetData()["FeedingGuantletCharge"] or player:GetData()["FeedingGuantletCharge"] < 1) then return end
  --player:GetData()["FeedingGuantletCharge"] = player:GetData()["FeedingGuantletCharge"] - 1
--[[
  local enemies = Isaac.FindInRadius(player.Position, 1000, EntityPartition.ENEMY)
  for _, enemy in pairs(enemies) do
    enemy:Kill()
  end
  ]]

  sfx:Play(SoundEffect.SOUND_CHEST_DROP, 1, 0, false, 0.6)
  for _, e in pairs(Isaac.GetRoomEntities()) do
		if e:IsEnemy() and e:IsVulnerableEnemy() and e:IsActiveEnemy() and e.Type ~= 302 then
      local x = rng:RandomInt(99)
      if e:ToNPC():IsBoss() then
          e.HitPoints = e.HitPoits - (e.MaxHitPoints * 15/100)
          if (e.HitPoints <= 0) then
            if(x > 55) then 
              Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, e.Position, Vector(0,0), nil)
            end
            if(x > 90) then 
              Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, e.Position,Vector(0,0), nil)
            end
            Isaac.Spawn(5, 10, rng:RandomInt(13), e.Position, Vector(1,0), nil)
            Isaac.Spawn(5, 30, rng:RandomInt(4), e.Position, Vector(0,1), nil)
            Isaac.Spawn(5, 20, rng:RandomInt(8), e.Position, Vector(1,1), nil)
            Isaac.Spawn(5, 40, rng:RandomInt(8), e.Position, Vector(0,0), nil)
            sfx:Play(SoundEffect.SOUND_CHEST_DROP, 1, 0, false, 0.6)
            return
          end
      else
        e:Kill()
        if(x > 75) then 
          Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, e.Position, Vector(0,0), nil)
        end
        if(x > 96) then 
          Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, e.Position,Vector(0,0), nil)
        end
        Isaac.Spawn(5, 10, rng:RandomInt(13), e.Position, Vector(1,0), nil)
        Isaac.Spawn(5, 30, rng:RandomInt(4), e.Position, Vector(0,1), nil)
        Isaac.Spawn(5, 20, rng:RandomInt(8), e.Position, Vector(1,1), nil)
        Isaac.Spawn(5, 40, rng:RandomInt(8), e.Position, Vector(0,0), nil)
        sfx:Play(SoundEffect.SOUND_CHEST_DROP, 1, 0, false, 0.6)
        return
      end
	  end
  end
end

local function Post_Player_Update(_, player)
  if (player == nil or not player:HasCollectible(registry.FeedingGauntlet)) then return end
  -- this update is ran even on the main menu ... so we have to check if player even exists.
  -- first pickup
    --[[
  if (not player:GetData()["FeedingGuantletCharge"]) then
    player:GetData()["FeedingGuantletCharge"] = 5
  end
    ]]

  -- effect trigger
  if (Input.IsActionTriggered(ButtonAction.ACTION_ITEM, player.ControllerIndex)) then
    TriggerEffect(player)
  end
  --[[
  -- sync
  if (player:GetActiveCharge() ~= player:GetData()["FeedingGuantletCharge"]) then
    player:SetActiveCharge(player:GetData()["FeedingGuantletCharge"])
  end
  ]]
end

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Post_Player_Update)
end

return item
