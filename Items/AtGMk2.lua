
local registry = include("ItemRegistry")
local item = {}

local hasitem = false
local haditem = false
local x = 7
local missle_dmg = 3.5
local missle_proc = 1
local rng = RNG()
rng:SetSeed(Random(), 1)

local dirtovect = {
	[Direction.DOWN] = Vector(0, 1),
	[Direction.UP] = Vector(0, -1),
	[Direction.LEFT] = Vector(-1, 0),
	[Direction.RIGHT] = Vector(1, 0),
}

local dirtostring = {
	[Direction.DOWN] = "Down",
	[Direction.UP] = "Up",
	[Direction.LEFT] = "Side",
	[Direction.RIGHT] = "Side",
}

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

local function Post_Player_Update(_, player)
 if (player == nil or not player:HasCollectible(registry.AtGMk2)) then return end
	  if player:HasCollectible(registry.AtGMk2) then
      missle_dmg = player.Damage * 3
      missle_proc = 1 + ( (player.Luck * .1) + 0.2)
  end
end


local function EvalCache(_, player, cache)
end

local function PostFireTear(_, t)

	if t.SpawnerType == 1 and t.Parent then
		local p = t.Parent:ToPlayer()
    local dir = p:GetHeadDirection()

		if p:HasCollectible(registry.AtGMk2) then
      if(rng:RandomInt(99) < x) then
      --local missle = Game():Spawn(EntityType.ENTITY_TEAR,TearVariant.BLUE,ent.Position,dir,ent,0,ent.InitSeed):ToTear()  
        for i = 0, 2, 1 do
          local missle = Isaac.Spawn(2, 0, 0, p.Position + ( dirtovect[dir]:Resized(rng:RandomInt(5) *(rng:RandomFloat()))), dirtovect[dir]:Resized(9) + p.Velocity, p):ToTear()
          missle.CollisionDamage = p.Damage * 3 * (p:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 1 or 0.75)
          missle.TearFlags = TearFlags.TEAR_ORBIT | TearFlags.TEAR_HOMING | TearFlags.TEAR_SPECTRAL --TearFlags.TEAR_EXPLOSIVE | 
          --missle.FallingSpeed = 0.1
          missle.Height = t.Height + 7
          missle.FallingAcceleration = -0.1
          missle:ChangeVariant(TearVariant.NAIL)
          p:GetShootingInput()
          local s = missle:GetSprite()
          s:ReplaceSpritesheet(0, "gfx/missle_tears.png")
          s:LoadGraphics()
          local d = t:GetData()
          d.ember = Isaac.Spawn(1000, 104, 4, t.Position + Vector(0, -16), t.Velocity, t)
          d.ember.Visible = false
          d.ember.SpriteScale = d.ember.SpriteScale * 1.5
          sfx:Play(SoundEffect.SOUND_ROCKET_LAUNCH, 1, (i * 5), false, 1)
        end 
        x = 7
        return
      else 
        if (math.floor(x * missle_proc) << 5) then  x = 7
        else 
        x = x *missle_proc--- missle_proc -- Make better % chance, look at dota 2
        end
      end
		end
	end
end

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, PostFireTear)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvalCache)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Post_Player_Update)

end

return item
