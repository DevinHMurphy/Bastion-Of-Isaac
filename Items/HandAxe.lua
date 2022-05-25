local registry = include("ItemRegistry")
local item = {}

local hasitem = false
local haditem = false

local function bit(p)
  return 2 ^ (p - 1)  -- 1-based indexing
end

-- Typical call:  if hasbit(x, bit(3)) then ...
local function hasbit(x, p)
  return x % (p + p) >= p       
end

local function setbit(x, p)
  return x | p
end



local function Entity_Take_Damage(_, target, DamageAmount, DamageFlags, DamageSource, DamageCountDownFrames)
    if DamageSource.Type == EntityType.ENTITY_TEAR then
        if DamageSource.Entity.SpawnerType == EntityType.ENTITY_PLAYER or (DamageSource.Entity.SpawnerType == EntityType.ENTITY_FAMILIAR and DamageSource.Entity.SpawnerVariant == FamiliarVariant.INCUBUS) then
          if DamageSource.Entity.Parent then
            local p = DamageSource.Entity.Parent:ToPlayer()
            if p:HasCollectible(registry.HandAxe) then
            -- check if the damaged enemy is an actual enemy
            if target:IsEnemy() and target:IsVulnerableEnemy() and target:IsActiveEnemy() and target.Type ~= 302 then
                -- charm the damaged enemy
                target:TakeDamage((target.MaxHitPoints * 2/100), DamageFlag.DAMAGE_NO_MODIFIERS, EntityRef(player), 0)
            end
          end
          end
        end
    end
end


local function EvalCache(_, player, cache)
  --local d = player:GetData()
	if player:HasCollectible(registry.HandAxe) then
    if (cache == CacheFlag.CACHE_DAMAGE) then
      player.Damage = player.Damage * 2
    elseif (cache == CacheFlag.CACHE_SHOTSPEED) then
        player.ShotSpeed = player.ShotSpeed 
    elseif (cache == CacheFlag.CACHE_SPEED) then
        player.MoveSpeed = player.MoveSpeed
    elseif (cache == CacheFlag.CACHE_RANGE) then
      player.TearRange = player.TearRange + 20
    elseif (cache == CacheFlag.CACHE_FIREDELAY) then
      player.MaxFireDelay = player.MaxFireDelay + 10
    elseif(cache == CacheFlag.CACHE_TEARFLAG) then
      --player.TearFlags = setbit(player.TearFlags, bit(3))
      player.TearFlags = player.TearFlags | TearFlags.TEAR_BOOMERANG | TearFlags.TEAR_PERSISTENT
      --player.TearFlags = setbit(player.TearFlags, bit(65))--add flag 2 (piercing) to the player's TearFlags
    end
  end
 --[[
  TEAR_HOMING
  end
  ]]

end

local function PostFireTear(_, t)
	if t.SpawnerType == 1 and t.Parent then
		local p = t.Parent:ToPlayer()
		if p:HasCollectible(registry.HandAxe) then
     -- t.SpriteScale = t.SpriteScale * 0.6;
     -- if t.Variant ~= TearVariant.NAIL then
    --	t:ChangeVariant(TearVariant.NAIL)
			--end
      t.Height = -25
      --t.FallingAcceleration = 0
      t.FallingSpeed = -0.1
      p:GetShootingInput( )
			local s = t:GetSprite()
      --sfx:Play(Isaac.GetSoundIdByName("Falco_Laser"), 1, 0, false, 1)
      --s:ReplaceSpritesheet(0, "gfx/BButton_tears.png")
      --s:LoadGraphics()
      local d = t:GetData()
			d.ember = Isaac.Spawn(1000, 104, 4, t.Position + Vector(0, -16), t.Velocity, t)
			d.ember.Visible = false
			d.ember.SpriteScale = d.ember.SpriteScale * 1.5
		end
	end
end

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, PostFireTear)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvalCache)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Entity_Take_Damage)
end

return item
