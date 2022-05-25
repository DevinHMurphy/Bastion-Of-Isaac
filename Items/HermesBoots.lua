local registry = include("ItemRegistry")
local item = {}
local hasitem = false

-- SEE Items.xml for the other half of what you need to do for this item!
--[[
local function EvalCache(_, player, cache)
  if (cache & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED) then
    if (player:HasCollectible(registry.Hermes)) then
      player.MoveSpeed = player.MoveSpeed * 2
    end
  end
end

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvalCache)
end

]]

local function Post_Player_Update(_, player)
  if (player == nil or not player:HasCollectible(registry.Hermes)) then hasitem =false return
  else hasitem = true
  end
end

local function NewRoom(_)
  if (hasitem == true) then
    for _, e in pairs(Isaac.GetRoomEntities()) do
      if e:IsEnemy() and e:IsVulnerableEnemy() and e:IsActiveEnemy() and e.Type ~= 302 and not e:ToNPC():IsChampion() then
      e:ToNPC():MakeChampion(Random(),-1, false)
      end
    end
  end
end

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, NewRoom)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Post_Player_Update)
end

return item
