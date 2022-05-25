local registry = include("ItemRegistry")
local item = {}

TearVariant.SPORTSBALL = Isaac.GetEntityVariantByName("Sportsball")

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


local function EvalCache(_, player, cache)
  --local d = player:GetData()
	if player:HasCollectible(registry.Sportsball) then
    if (cache == CacheFlag.CACHE_SHOTSPEED) then
        player.ShotSpeed = player.ShotSpeed - 3
    elseif (cache == CacheFlag.CACHE_SPEED) then
        player.MoveSpeed = player.MoveSpeed + 0.12
    elseif (cache == CacheFlag.CACHE_RANGE) then
      player.TearRange = player.TearRange + 20
    elseif(cache == CacheFlag.CACHE_TEARFLAG) then
      --player.TearFlags = setbit(player.TearFlags, bit(3))
      player.TearFlags = setbit(player.TearFlags, bit(20))--add flag 2 (piercing) to the player's TearFlags
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
    local data = t:GetData()
		if p:HasCollectible(registry.Sportsball) then
      --t.SpriteScale = t.SpriteScale * 1.4;
      if t.Variant ~= TearVariant.NAIL then
				t:ChangeVariant(TearVariant.NAIL)
      else
        if (t.Height >= -5 or t:CollideWithGrid()) and data.Gram == nil then
          --data.Ball = 
        end
      end
      p:GetShootingInput()
			local s = t:GetSprite()
      --local tearAnimation = s:Load("gfx/sportsball_tears.anm2", true)
      s:ReplaceSpritesheet(0, "gfx/sportsball_tears.png")
      s:Play("Idle", true)
      s:LoadGraphics()
      --[[ adds light around tears
      local d = t:GetData()
			d.customtype = "arrowoflight"
			d.ember = Isaac.Spawn(1000, 104, 4, t.Position + Vector(0, -16), t.Velocity, t)
			d.ember.Visible = false
			d.ember.SpriteScale = d.ember.SpriteScale * 1.5
      ]]
		end
	end
end

local function onDamage(TookDamage, DamageAmount, DamageFlags, DamageSource, DamageCountDownFrames)  
 -- if DamageSource.Type == EntityType.ENTITY_TEAR and DamageSource.Variant == TearVariant.SPORTSBALL then
    -- DO SOMETHING
  --end
end

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, PostFireTear)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvalCache)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, onDamage)

end


--SET UP ENTITY CODE --



return item

