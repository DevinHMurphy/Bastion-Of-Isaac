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


local function EvalCache(_, player, cache)
  --local d = player:GetData()
	if player:HasCollectible(registry.Cannon) then
    if (cache == CacheFlag.CACHE_DAMAGE) then
      player.Damage = player.Damage * 3
    elseif (cache == CacheFlag.CACHE_SHOTSPEED) then
        player.ShotSpeed = player.ShotSpeed + 3
    elseif (cache == CacheFlag.CACHE_SPEED) then
        player.MoveSpeed = player.MoveSpeed - 0.35
    elseif (cache == CacheFlag.CACHE_RANGE) then
      player.TearRange = player.TearRange + 100
    elseif (cache == CacheFlag.CACHE_FIREDELAY) then
      player.MaxFireDelay = player.MaxFireDelay + 25
    elseif(cache == CacheFlag.CACHE_TEARFLAG) then
      --player.TearFlags = setbit(player.TearFlags, bit(3))
      player.TearFlags = setbit(player.TearFlags, bit(13))
      player.TearFlags = setbit(player.TearFlags, bit(10))--add flag 2 (piercing) to the player's TearFlags
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
		if p:HasCollectible(registry.Cannon) then
      t.SpriteScale = t.SpriteScale * 1.2;
      p:GetShootingInput()
			local s = t:GetSprite()
      s:ReplaceSpritesheet(0, "gfx/Cannon_tears.png")
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

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, PostFireTear)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvalCache)

end

return item
