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
  for i = 0, 2, 1 do
  local spawnPos = Vector(player.Position.X + math.random(-80, 80), player.Position.Y + math.random(0, 80))
  spawnPos = Isaac.GetFreeNearPosition(spawnPos, 1)
  local x = rng:RandomInt(6) + 2
    if(x == 2 or x == 4) then
        Isaac.Spawn(5, 20, 2, spawnPos, Vector(1,0), nil)
    elseif (x == 3 or x == 6) then 
      Isaac.Spawn(5, 20, 3, spawnPos, Vector(1,0), nil)
    elseif (x == 5) then 
      Isaac.Spawn(5, 20, 5, spawnPos, Vector(1,0), nil)
    else 
      Isaac.Spawn(5, 20, 7, spawnPos, Vector(1,0), nil)
    end
  end
  player:RemoveCollectible(registry.SigningBonus)
end


local function Post_Player_Update(_, player)
  if (player == nil or not player:HasCollectible(registry.SigningBonus)) then return end
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
