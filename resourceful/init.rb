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
  world.land_size = 1
  world.land_rarity = 99
  world.land_fuzzy = 3
  
  world.ice_size = 2
  world.ice_rarity = 75
  world.frozen_rivers = false
  
  world.surface_stone = false
  world.river_size = 1
end

@world.biome :desert do |desert|
  desert.size = 1
  # TODO Configure desert resources
end

@world.biome :forest do |forest|
  forest.size = 2
  # TODO Configure forest resources
end

@world.biome :mountains do |mountains|
  mountains.size = 2
  # TODO Configure generic mountain resources
end

@world.biome :mountains => "WoodedMountains" do |mountains|
  mountains.size = 2
  mountains.color = 0x95b95b
  mountains.tree :frequency => 10, :trees => ["Forest", 20, "BigTree", 10, "Tree", 100]
  mountains.grass :tall_grass, :frequency => 15, :rarity => 100, :in => [:grass, :dirt]
  # TODO Configure generic wooded mountain resources
end

@world.biome :mountains => "SnowyMountains" do |mountains|
  mountains.size = 2
  mountains.color = 0xb4c2d7
  mountains.ice = true
  mountains.temperature = 0.0
  mountains.wetness = 0.5
  mountains.clear_resources! :grass
  mountains.grass :tall_grass, :frequency => 5, :rarity => 50, :in => [:dirt, :grass]
  # TODO Configure generic ice mountain resources
end

@world.biome :plains do |plains|
  plains.size = 1
  plains.height = 0.0
  plains.volatility = 0.0
  # TODO Configure plains resources
end

@world.biome :plains => "SnowyPlains" do |plains|
  plains.size = 2
  plains.color = 0xd3dded
  plains.ice = true
  plains.temperature = 0.0
  plains.wetness = 0.5
  plains.height = 0.0
  plains.volatility = 0.0
  plains.clear_resources! :grass
  plains.grass :tall_grass, :frequency => 5, :rarity => 50, :in => [:dirt, :grass]
  # TODO Configure ice plains resources
end

@world.biome :swamp do |swamp|
  swamp.size = 2
  # TODO Configure swamp resources
end

@world.biome :taiga do |taiga|
  taiga.size = 2
  # TODO Configure taiga resources
end

@world.isle :island => "GrassyIsland" do |island|
  island.tree :frequency => 1, :trees => ["BigTree", 10, "Tree", 100]
  # TODO Configure grassy island resources
end

@world.isle :island => "SnowyIsland" do |island|
  island.color = 0xd4ebef
  island.ice = true
  island.temperature = 0.0
  island.wetness = 0.4
  island.tree :frequency => 1, :trees => ["BigTree", 10, "Tree", 100]
  # TODO Configure snowy island resources
end

@world.border :mushroom_island_shore
@world.isle :mushroom_island do |shrooms|
  shrooms.border = "MushroomIslandShore"
end

@world.border :shore => "CidsaIslandShore" do |shore|
  shore.color = 0x4f59b9
  shore.size = 4
  shore.rarity = 100
  shore.clear_resources!
  [:stone, :grass, :dirt, :sand, :gravel, :wood, :leaves].each do |block|
    shore.replace block, :with => :glass
  end
end

@world.isle :island => "CidsaIsland" do |island|
  island.color = 0xff4dba
  island.size = 6
  island.rarity = 50
  island.height = 0.6
  island.volatility = 0.1
  island.border = "CidsaIslandShore"
  island.clear_resources!
  island.tree :frequency => 3, :trees => ["BigTree", 10, "Tree", 100]
  [:stone, :grass, :dirt, :sand, :gravel, :wood, :leaves].each do |block|
    island.replace block, :with => :glass
  end
end

@world.other :ocean do |ocean|
  ocean.isles = %w(CidsaIsland GrassyIsland MushroomIsland)
end

@world.other :frozen_ocean do |ocean|
  ocean.isles = %w(CidsaIsland SnowyIsland MushroomIsland)
end

@world.other :river

world_path = File.join(File.dirname(__FILE__), "..")
@world.write(world_path)
