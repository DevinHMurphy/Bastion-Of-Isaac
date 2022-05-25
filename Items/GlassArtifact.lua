local registry = include("ItemRegistry")
local item = {}

local dmg_amp
local dmg_calc = true
local dmg_calc_value = 0

local function Entity_Take_Damage(_, tookdamage, damage_amount, damage_flags, damageSource, damageCountdownFrames)
  if (tookdamage.Type == EntityType.ENTITY_PLAYER) then
    if (tookdamage:ToPlayer():HasCollectible(registry.GlassArtifact)) then
      if (damageSource.Type ~= EntityType.ENTITY_PLAYER) then
      player = tookdamage:ToPlayer()
      --if dmg_amp == true then
      --dmg_amp = false
      damage_calc_value = math.floor(damage_amount * 4)
      player:TakeDamage(damage_calc_value, DamageFlag.DAMAGE_NO_MODIFIERS, EntityRef(player), 0)
      --dmg_amp = true
      --else 
      --return 
      --
      end
    end
  end
end


local function EvalCache(_, player, cache)
  --local d = player:GetData()
	if player:HasCollectible(registry.GlassArtifact) then
    if (cache == CacheFlag.CACHE_DAMAGE) then
      player.Damage = player.Damage * 5
    end
  end
end
  

function item:Init(mod)
 -- mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Post_Player_Update)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Entity_Take_Damage)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvalCache)
end

return item
