require "resourceful"

$:.unshift(File.join(File.dirname(__FILE__), "lib"))
require "resourceful/biomes/island"
require "resourceful/resources/buildcraft"
require "resourceful/resources/desertcraft"
require "resourceful/resources/harvestcraft/bushes"
require "resourceful/resources/harvestcraft/ores"
require "resourceful/resources/harvestcraft/trees"
require "resourceful/resources/redpower/blocks"
require "resourceful/resources/redpower/ores"
require "resourceful/resources/redpower/plants"
require "resourceful/resources/vanilla"
require "resourceful/resources/weee_flowers"
include Resourceful

@world = World.new do |world|
  world.iterations = 10
  world.rarity_scale = 500
  world.land_size = 1
  world.land_rarity = 99
  world.land_fuzzy = 3
  
  world.ice_size = 2
  world.ice_rarity = 75
  world.frozen_rivers = false
  
  world.surface_stone = false
  world.river_size = 1
end

@world.isle :desert => "DesertOasis" do |oasis|
  oasis.size = 8
  oasis.rarity = 300
  oasis.color = 0x83cd0f
  oasis.temperature = 0.7
  oasis.wetness = 0.7
  oasis.ponds = true
  oasis.height = -0.2
  oasis.replacements = []
  oasis.clear_resources! :grass
  oasis.grass DesertCraft::RoundGreenRedCactus, :frequency => 2, :rarity => 50, :in => :sand
  oasis.grass DesertCraft::RoundPinkFlowerCactus, :frequency => 2, :rarity => 50, :in => :sand
  oasis.grass DesertCraft::GnarlyPinkFlowerCactus, :frequency => 2, :rarity => 50, :in => :sand
  oasis.grass DesertCraft::LargeDeadShrub, :frequency => 2, :rarity => 50, :in => :sand
  # TODO Configure desert oasis resources
end

@world.biome :desert do |desert|
  desert.size = 1
  desert.rarity = 500
  desert.isles << "DesertOasis"
  desert.clear_resources! :grass
  desert.grass :dead_bush, :frequency => 4, :rarity => 5, :in => :sand
  desert.grass DesertCraft::GnarlyBrownCactus, :frequency => 1, :rarity => 3, :in => :sand
  desert.grass DesertCraft::RoundBrownCactus, :frequency => 1, :rarity => 3, :in => :sand
  desert.grass DesertCraft::RoundFadedPinkFlowerCactus, :frequency => 1, :rarity => 1, :in => :sand
  desert.grass DesertCraft::LargeDeadShrub, :frequency => 2, :rarity => 5, :in => :sand
  desert.grass DesertCraft::SmallDeadShrub, :frequency => 2, :rarity => 5, :in => :sand
  # TODO Configure desert resources
end

@world.biome :desert => "SandstoneFlats" do |flats|
  flats.size = 3
  flats.rarity = 200
  flats.color = 0xdbcc9d
  flats.surface = :sandstone
  flats.ground = :sandstone
  flats.height = 0.0
  flats.volatility = 0.0
  flats.clear_resources!
end

@world.isle :forest => "ForestRedwoodGrove" do |grove|
  grove.size = 5
  grove.rarity = 400
  grove.color = 0x753e3e
  grove.clear_resources! :tree
  grove.tree :frequency => 5, :trees => ["Forest", 10, "Tree", 50]
end

@world.biome :forest do |forest|
  forest.size = 2
  forest.rarity = 500
  forest.isles << "ForestRedwoodGrove"
  # TODO Configure forest resources
end

@world.biome :forest => "BirchForest" do |forest|
  forest.size = 2
  forest.rarity = 200
  forest.volatility = 0.1
  forest.isles << "ForestRedwoodGrove"
  forest.replace :wood, :with => :birch_wood
  # TODO Configure forest resources
end

@world.biome :forest => "Jungle" do |jungle|
  jungle.size = 2
  jungle.rarity = 400
  jungle.color = 0x128107
  jungle.volatility = 0.5
  jungle.temperature = 0.8
  jungle.wetness = 1.0
  jungle.clear_resources!
  jungle.tree :frequency => 20, :trees => ["Tree", 10, "SwampTree", 65, "BigTree", 100]
  jungle.grass :tall_grass, :frequency => 50, :rarity => 100, :in => :grass
  jungle.grass :fern, :frequency => 50, :rarity => 100, :in => :grass
  # TODO Configure jungle resources
end

@world.isle :taiga => "TaigaRedwoodGrove" do |grove|
  grove.size = 5
  grove.rarity = 400
  grove.color = 0x753e3e
  grove.clear_resources! :tree
  grove.tree :frequency => 5, :trees => ["Taiga1", 10, "Taiga2", 50]
end

@world.biome :taiga do |taiga|
  taiga.size = 2
  taiga.rarity = 350
  taiga.isles << "TaigaRedwoodGrove"
  # TODO Configure taiga resources
end

@world.biome :taiga => "SnowyTaiga" do |taiga|
  taiga.size = 2
  taiga.rarity = 350
  taiga.ice = true
  taiga.temperature = 0.0
  taiga.wetness = 0.4
  taiga.isles << "TaigaRedwoodGrove"
  # TODO Configure taiga resources
end

@world.biome :mountains do |mountains|
  mountains.size = 2
  mountains.rarity = 250
  # TODO Configure generic mountain resources
end

@world.biome :mountains => "WoodedMountains" do |mountains|
  mountains.size = 2
  mountains.rarity = 250
  mountains.color = 0x95b95b
  mountains.tree :frequency => 10, :trees => ["Forest", 20, "BigTree", 10, "Tree", 100]
  mountains.grass :tall_grass, :frequency => 15, :rarity => 100, :in => [:grass, :dirt]
  # TODO Configure generic wooded mountain resources
end

@world.biome :mountains => "SnowyMountains" do |mountains|
  mountains.size = 2
  mountains.rarity = 250
  mountains.color = 0xb4c2d7
  mountains.ice = true
  mountains.temperature = 0.0
  mountains.wetness = 0.5
  mountains.clear_resources! :grass
  mountains.grass :tall_grass, :frequency => 5, :rarity => 50, :in => [:dirt, :grass]
  # TODO Configure generic ice mountain resources
end

@world.isle :plains => "WildHills" do |hills|
  hills.size = 5
  hills.rarity = 450
  hills.color = 0x27ab37
  hills.height = 0.6
  hills.volatility = 1.8
  hills.temperature = 0.6
  hills.wetness = 0.5
  hills.ponds = true
  hills.rivers = true
  hills.tree :frequency => 1, :trees => ["Forest", 33, "BigTree", 15, "Tree", 66]
end

@world.biome :plains => "HappyHills" do |hills|
  hills.size = 2
  hills.rarity = 500
  hills.height = 0.2
  hills.volatility = 0.2
  hills.temperature = 0.6
  hills.wetness = 0.5
  hills.ponds = true
  hills.rivers = true
  hills.isles << "WildHills"
  hills.tree :frequency => 1, :trees => ["Forest", 33, "BigTree", 15, "Tree", 66]
end

@world.biome :plains do |plains|
  plains.size = 1
  plains.rarity = 500
  plains.height = 0.0
  plains.volatility = 0.0
  plains.rivers = false
  # TODO Configure plains resources
end

@world.biome :plains => "SnowyPlains" do |plains|
  plains.size = 2
  plains.rarity = 500
  plains.color = 0xd3dded
  plains.ice = true
  plains.temperature = 0.0
  plains.wetness = 0.5
  plains.height = 0.0
  plains.volatility = 0.0
  plains.rivers = false
  plains.clear_resources! :grass
  plains.grass :tall_grass, :frequency => 5, :rarity => 50, :in => [:dirt, :grass]
  # TODO Configure ice plains resources
end

@world.biome :plains => "Savannah" do |savannah|
  savannah.size = 2
  savannah.rarity = 250
  savannah.color = 0xc4a64a
  savannah.temperature = 1.0
  savannah.wetness = 0.0
  savannah.height = 0.0
  savannah.volatility = 0.0
  savannah.rivers = false
  savannah.clear_resources! :grass
  savannah.grass :tall_grass, :frequency => 100, :rarity => 100, :in => :grass
  savannah.clear_resources! :plant
  # TODO Configure savannah resources
end

@world.biome :swamp do |swamp|
  swamp.size = 2
  swamp.rarity = 350
  # TODO Configure swamp resources
end

@world.isle :island => "GrassyIsland" do |island|
  island.rarity = 200
  island.tree :frequency => 1, :trees => ["BigTree", 10, "Tree", 100]
  # TODO Configure grassy island resources
end

@world.isle :island => "SnowyIsland" do |island|
  island.color = 0xd4ebef
  island.rarity = 200
  island.ice = true
  island.temperature = 0.0
  island.wetness = 0.4
  island.tree :frequency => 1, :trees => ["BigTree", 10, "Tree", 100]
  # TODO Configure snowy island resources
end

@world.border :mushroom_island_shore
@world.isle :mushroom_island do |shrooms|
  shrooms.color = 0xa7744f
  shrooms.rarity = 10
  shrooms.border = "MushroomIslandShore"
end

@world.isle :island => "CidsaIsland" do |island|
  island.color = 0xff4dba
  island.rarity = 10
  island.size = 4
  island.height = 0.6
  island.volatility = 0.1
  island.border = "CidsaIslandShore"
  island.clear_resources!
  island.tree :frequency => 3, :trees => ["BigTree", 10, "Tree", 100]
  [:stone, :grass, :dirt, :sand, :gravel, :wood, :leaves].each do |block|
    island.replace block, :with => :glass
  end
end

@world.border :shore => "CidsaIslandShore" do |shore|
  shore.color = 0x4f59b9
  shore.clear_resources!
  [:stone, :grass, :dirt, :sand, :gravel, :wood, :leaves].each do |block|
    shore.replace block, :with => :glass
  end
end

@world.isle :island => "WoolIsland" do |island|
  island.color = 0xe9a625
  island.rarity = 10
  island.size = 4
  island.height = 0.6
  island.volatility = 0.1
  island.border = "WoolIslandShore"
  island.clear_resources!
  island.replace :stone, :with => :gray_wool
  island.replace :grass, :with => :green_wool
  island.replace :dirt, :with => :brown_wool
  island.replace :gravel, :with => :light_gray_wool
  island.replace :water, :with => :light_blue_wool
  island.replace :stationary_water, :with => :light_blue_wool
  island.replace :lava, :with => :orange_wool
  island.replace :stationary_lava, :with => :orange_wool
  island.replace :wood, :with => :brown_wool
  island.replace :leaves, :with => :lime_wool
end

@world.border :shore => "WoolIslandShore" do |shore|
  shore.clear_resources!
  shore.replace :stone, :with => :gray_wool
  shore.replace :grass, :with => :green_wool
  shore.replace :dirt, :with => :brown_wool
  shore.replace :gravel, :with => :light_gray_wool
  shore.replace :water, :with => :light_blue_wool
  shore.replace :stationary_water, :with => :light_blue_wool
  shore.replace :lava, :with => :orange_wool
  shore.replace :stationary_lava, :with => :orange_wool
  shore.replace :wood, :with => :brown_wool
  shore.replace :leaves, :with => :lime_wool
end

# @world.biome :ocean do |ocean|
#   ocean.size = 1
#   ocean.rarity = 15
#   ocean.isles = %w(CidsaIsland GrassyIsland MushroomIsland WoolIsland)
# end
# 
# @world.biome :frozen_ocean do |ocean|
#   ocean.size = 1
#   ocean.rarity = 15
#   ocean.isles = %w(CidsaIsland SnowyIsland MushroomIsland WoolIsland)
# end

@world.other :river

world_path = File.join(File.dirname(__FILE__), "..")
@world.write(world_path)
