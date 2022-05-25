local registry = include("ItemRegistry")
local item = {}

-- SEE Items.xml for the other half of what you need to do for this item!

local function TriggerEffect(player)
  if (not player:GetData()["ExodusCharge"] or player:GetData()["ExodusCharge"] < 1) then return end
  player:GetData()["ExodusCharge"] = player:GetData()["ExodusCharge"] - 1
--[[
  local enemies = Isaac.FindInRadius(player.Position, 1000, EntityPartition.ENEMY)
  for _, enemy in pairs(enemies) do
    enemy:Kill()
  end
  ]]

  sfx:Play(SoundEffect.SOUND_CHEST_DROP, 1, 0, false, 0.6)
  for _, e in pairs(Isaac.GetRoomEntities()) do
		if e:IsEnemy() and e:IsVulnerableEnemy() and e:IsActiveEnemy() and e.Type ~= 302 then
      if e:ToNPC():IsBoss() then
      else
        e:Kill()
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, e.Position, Vector(0,0), nil)
        sfx:Play(SoundEffect.SOUND_CHEST_DROP, 1, 0, false, 0.6)
        return
      end
	  end
  end
end

local function Post_Player_Update(_, player)
  if (player == nil or not player:HasCollectible(registry.Exodus)) then return end
  -- this update is ran even on the main menu ... so we have to check if player even exists.
  -- first pickup
  if (not player:GetData()["ExodusCharge"]) then
    player:GetData()["ExodusCharge"] = 5
  end

  -- effect trigger
  if (Input.IsActionTriggered(ButtonAction.ACTION_ITEM, player.ControllerIndex)) then
    TriggerEffect(player)
  end
  -- sync
  if (player:GetActiveCharge() ~= player:GetData()["ExodusCharge"]) then
    player:SetActiveCharge(player:GetData()["ExodusCharge"])
  end

end

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Post_Player_Update)
end

return item
