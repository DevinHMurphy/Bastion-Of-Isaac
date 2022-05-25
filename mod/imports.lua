local includes = {}

local items = {
  include("Items/Exodus"),
  include("Items/HermesBoots"),
  include("Items/Pipe"),
  include("Items/lvl9"),
  include("Items/FapRing"),
  include("Items/FapRinga"),
  include("Items/Sportsball"),
  include("Items/Position1"),
  include("Items/Cannon"),
  include("Items/AtGMk2"),
  include("Items/FeedingGuantlet"),
  include("Items/RedTearstoneRing"),
  include("Items/SigningBonus"),
  include("Items/GKController"),
  include("Items/ZinogrePlate"),
  include("Items/BButton"),
  include("Items/MasterSeal"),
  include("Items/GlassArtifact"),
  include("Items/FullEcon"),
  include("Items/HandAxe")
}

function includes:Init(mod)
  -- do your inits here
  for _, item in pairs(items) do
    item:Init(mod)
  end
end

return includes