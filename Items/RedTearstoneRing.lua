local registry = include("ItemRegistry")
local item = {}

local ring_active = false
local ring_dmg_calc = 0

local function Entity_Take_Damage(_, tookdamage, damage_amount, damage_flags, damageSoource, damageCountdownFrames)
  --if 
  --end
end

local function Post_Player_Update(_, player)
  if (player == nil) then ring_active = false return end
  if (not player:HasCollectible(registry.RTSR)) then
    if (ring_active == true) then ring_active = false return end
  end
  if (player:HasCollectible(registry.RTSR)) then
    if (ring_active == false and ((player:GetHearts()/(player:GetMaxHearts())) <= 1/3)) then 
      ring_dmg_calc = player.Damage * 1.5
      player.Damage = player.Damage + ring_dmg_calc
      ring_active = true
      return
    elseif (ring_active == true and ((player:GetHearts()/(player:GetMaxHearts())) > 1/3)) then
      player.Damage = player.Damage - ring_dmg_calc
    ring_active = false
    return
    else 
    return end
  end
end
  

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Post_Player_Update)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Entity_Take_Damage)
end

return item
