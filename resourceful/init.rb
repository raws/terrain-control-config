require "resourceful"

$:.unshift(File.join(File.dirname(__FILE__), "lib"))
require "perkele/resources/buildcraft"
require "perkele/resources/desertcraft"
require "perkele/resources/harvestcraft/bushes"
require "perkele/resources/harvestcraft/ores"
require "perkele/resources/harvestcraft/trees"
require "perkele/resources/redpower/blocks"
require "perkele/resources/redpower/ores"
require "perkele/resources/redpower/plants"
require "perkele/resources/vanilla"
require "perkele/resources/weee_flowers"
require "perkele/biomes/island"
require "perkele/biomes/mountains"
include Resourceful

class Array
  def random_range(size_range = nil)
    if size_range.respond_to?(:random)
      size = size_range.random
    else
      size = rand((size_range || self.size).to_i - 1) + 1
    end
    offset = rand(self.size + 1 - size)
    self[offset..(offset + size)]
  end
end

class Range
  def random
    to_a.shuffle.first
  end
  
  def random_range(size_range = nil)
    to_a.random_range(size_range)
  end
end

@world = World.new do |world|
  world.iterations = 10
  world.rarity_scale = 500
  world.land_size = 1
  world.land_rarity = 99
  world.land_fuzzy = 3
  
  world.ice_size = 2
  world.ice_rarity = 25
  world.frozen_rivers = false
  
  world.surface_stone = false
  world.river_size = 1
end

def add_common_resources(biome)
  biome.ore :coal, :size => 20, :frequency => 5,  :rarity => 33, :between =>  0..32,  :in => :stone
  biome.ore :coal, :size => 10, :frequency => 8,  :rarity => 55, :between => 32..48,  :in => :stone
  biome.ore :coal, :size => 8,  :frequency => 5,  :rarity => 50, :between => 48..128, :in => :stone
  biome.ore :iron, :size => 12, :frequency => 8,  :rarity => 55, :between =>  0..48,  :in => :stone
  biome.ore :iron, :size => 8,  :frequency => 5,  :rarity => 50, :between => 48..128, :in => :stone
  biome.ore :clay, :size => 8, :frequency => (5..10).random, :rarity => (35..65).random, :between => (0..128).random_range(35..128), :in => [:stone, :dirt]
  biome.ore HarvestCraft::Salt, :size => 8, :frequency => 12, :rarity => 33, :between => 0..128, :in => [:stone, :dirt]
  biome.ore RedPower::Basalt, :size => 12, :frequency => 2, :rarity => 40, :between => 0..48, :in => :stone
  biome.ore RedPower::Marble, :size => 12, :frequency => 2, :rarity => 40, :between => 0..64, :in => :stone
  
  [:lapis_lazuli, :diamond, RedPower::Emerald, RedPower::Ruby, RedPower::Sapphire, RedPower::Nikolite].each do |resource|
    biome.ore resource, :size => (3..7).random,
                        :frequency => 1,
                        :rarity => (5..20).random,
                        :between => (0..48).random_range(10..48),
                        :in => :stone
  end
end

def add_fruit_plants(biome, density = 1.0)
  trees = %w(apple banana cherry coconut lemon orange peach lime mango cocoa
  walnut pear plum olive cinnamon honey).shuffle.random_range(0..8).map do |name|
    "HarvestCraft::#{name.camelcase}Tree".classify
  end.each do |sapling|
    biome.grass sapling, :frequency => 1, :rarity => (5 * density).round, :between => 0..128, :in => [:dirt, :grass]
  end
  
  bushes = %w(blueberry blackberry raspberry kiwifruit strawberry grape).shuffle.random_range(0..4).map do |name|
    "HarvestCraft::#{name.camelcase}Bush".classify
  end.each do |bush|
    biome.grass bush, :frequency => 1, :rarity => (25 * density).round, :between => 0..128, :in => [:dirt, :grass]
  end
end

def add_resource_range(resource, rarity = 1.0, options = { :sparse => {}, :dense => {} })
  resource_name = Resource.find(resource).class.name[/::(\w+)$/, 1]
  
  sparse_defaults = { :size => 8, :frequency => 20, :rarity => 100, :between => proc { (85..128).random_range(10..43) }, :in => :stone }
  dense_defaults = { :size => 16, :frequency => 20, :rarity => 100, :between => proc { (0..85).random_range(10..85) }, :in => :stone }
  
  %w(Mountains WoodedMountains).each do |base_biome|
    base_biome_name = base_biome.underscore.to_sym
    new_biome_name = base_biome.sub(/Mountains$/, "") << "#{resource_name}Range"
    
    @world.biome base_biome_name => new_biome_name do |biome|
      biome.size = 6
      biome.rarity = (100 * rarity).round
      biome.color = 0xa864a8

      # Very rare surface deposits to help explorers
      biome.ore resource, :size => 4, :frequency => 8, :rarity => 85, :between => 64..128, :in => [:dirt, :grass]

      # Higher, sparser deposits
      biome.ore(resource, sparse_defaults.merge(options[:sparse]).inject({}) do |hash, (k, v)|
        hash[k] = v.respond_to?(:call) ? v.call : v
        hash[k] = (hash[k] * rarity).round if [:frequency, :rarity].include?(k) && hash[k].respond_to?(:round)
        hash
      end)

      # Deeper, denser deposits
      biome.ore(resource, dense_defaults.merge(options[:dense]).inject({}) do |hash, (k, v)|
        hash[k] = v.respond_to?(:call) ? v.call : v
        hash[k] = (hash[k] * rarity).round if [:frequency, :rarity].include?(k) && hash[k].respond_to?(:round)
        hash
      end)
      
      add_common_resources(biome)

      yield biome if block_given?
    end
  end
end

add_resource_range :iron, 0.7
add_resource_range :coal, 0.3
add_resource_range RedPower::Copper, 0.5
add_resource_range RedPower::Tin, 0.4
add_resource_range RedPower::Tungsten, 0.3
add_resource_range RedPower::Nikolite, 0.3

add_resource_range RedPower::Silver, 0.3 do |silver|
  silver.ore :gold, :size => 8, :frequency => 10, :rarity => 50, :between => 0..64, :in => :stone
end

add_resource_range :gold, 0.3 do |gold|
  gold.ore RedPower::Silver, :size => 8, :frequency => 10, :rarity => 50, :between => 0..64, :in => :stone
end

def add_desert_oil(biome)
  biome.ore BuildCraft::Oil, :size => 8, :frequency => 1, :rarity => 15, :between => 60..128, :in => [:sand, :sandstone]
  biome.ore BuildCraft::Oil, :size => 32, :frequency => 5, :rarity => 75, :between => 0..40, :in => :stone
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
  oasis.ore HarvestCraft::Salt, :size => 10, :frequency => 10, :rarity => 65, :between => 0..128, :in => [:stone, :sandstone]
  add_desert_oil(oasis)
  add_common_resources(oasis)
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
  desert.ore HarvestCraft::Salt, :size => 8, :frequency => 5, :rarity => 50, :between => 0..128, :in => [:stone, :sandstone]
  add_desert_oil(desert)
  add_common_resources(desert)
end

@world.biome :desert => "SandstoneFlats" do |flats|
  flats.size = 3
  flats.rarity = 200
  flats.color = 0xdbcc9d
  flats.temperature = 1.0
  flats.wetness = 0.0
  flats.surface = :sandstone
  flats.ground = :sandstone
  flats.height = 0.0
  flats.volatility = 0.0
  flats.clear_resources!
  flats.grass DesertCraft::SmallDeadShrub, :frequency => 1, :rarity => 1, :in => :sand
  flats.ore HarvestCraft::Salt, :size => 10, :frequency => 20, :rarity => 85, :between => 0..128, :in => [:stone, :sandstone]
  add_desert_oil(flats)
  add_common_resources(flats)
end

def redwood_grove(biome)
  biome.size = 5
  biome.rarity = 400
  biome.color = 0x753e3e
  biome.clear_resources! :tree
  biome.tree :frequency => 5, :trees => ["Forest", 10, "Tree", 50]
  biome.clear_resources! :plant
  biome.plant :rose, :frequency => 25, :rarity => 85, :in => :grass
  biome.plant WeeeFlowers::MagentaWildflower, :frequency => 10, :rarity => 50, :in => :grass
  biome.ore :redstone, :size => 10, :frequency => 25, :rarity => 100, :between => 0..128, :in => [:stone]
  biome.ore HarvestCraft::Salt, :size => 8, :frequency => 10, :rarity => 85, :between => 0..128, :in => [:stone, :dirt]
  add_common_resources(biome)
end

@world.isle :forest => "ForestRedwoodGrove" do |grove|
  redwood_grove(grove)
end

@world.biome :forest do |forest|
  forest.size = 2
  forest.rarity = 500
  forest.isles << "ForestRedwoodGrove"
  forest.plant WeeeFlowers::BlueChrysanthemum, :frequency => 5, :rarity => 35, :between => 0..128, :in => :grass
  forest.plant WeeeFlowers::PinkDaisy, :frequency => 5, :rarity => 25, :between => 0..128, :in => :grass
  forest.plant WeeeFlowers::WildParsley, :frequency => 1, :rarity => 5, :between => 0..128, :in => :grass
  add_fruit_plants(forest)
  add_common_resources(forest)
end

@world.biome :forest => "BirchForest" do |forest|
  forest.size = 2
  forest.rarity = 200
  forest.volatility = 0.1
  forest.isles << "ForestRedwoodGrove"
  forest.replace :wood, :with => :birch_wood
  forest.plant WeeeFlowers::BlueChrysanthemum, :frequency => 5, :rarity => 5, :in => :grass
  forest.plant WeeeFlowers::PinkDaisy, :frequency => 5, :rarity => 5, :in => :grass
  forest.plant WeeeFlowers::WildParsley, :frequency => 1, :rarity => 10, :in => :grass
  forest.plant WeeeFlowers::GreyPeonie, :frequency => 2, :rarity => 15, :in => :grass
  add_common_resources(forest)
end

@world.biome :forest => "Jungle" do |jungle|
  jungle.size = 2
  jungle.rarity = 500
  jungle.color = 0x128107
  jungle.volatility = 0.6
  jungle.temperature = 0.8
  jungle.wetness = 1.0
  jungle.clear_resources!
  jungle.tree :frequency => 20, :trees => ["Tree", 10, "SwampTree", 65, "BigTree", 100]
  jungle.grass :tall_grass, :frequency => 35, :rarity => 100, :in => :grass
  jungle.grass :fern, :frequency => 35, :rarity => 100, :in => :grass
  jungle.grass WeeeFlowers::BrightGreenShrub, :frequency => 35, :rarity => 100, :in => :grass
  jungle.grass WeeeFlowers::DarkGreenShrub, :frequency => 35, :rarity => 85, :in => :grass
  jungle.grass WeeeFlowers::MagentaWildflower, :frequency => 5, :rarity => 50, :in => :grass
  jungle.grass WeeeFlowers::BlueWildflower, :frequency => 5, :rarity => 50, :in => :grass
  jungle.reed :sugar_cane, :frequency => 10, :rarity => 100, :between => 0..128, :in => [:grass, :dirt, :sand]
  add_fruit_plants(jungle)
  add_common_resources(jungle)
end

@world.isle :taiga => "TaigaRedwoodGrove" do |grove|
  redwood_grove(grove)
  grove.clear_resources! :tree
  grove.tree :frequency => 5, :trees => ["Taiga1", 10, "Taiga2", 50]
end

@world.biome :taiga do |taiga|
  taiga.size = 2
  taiga.rarity = 350
  taiga.isles << "TaigaRedwoodGrove"
  taiga.plant WeeeFlowers::OrangePoppy, :frequency => 2, :rarity => 65, :between => 0..128, :in => :grass
  taiga.plant WeeeFlowers::PurpleViolet, :frequency => 2, :rarity => 65, :between => 0..128, :in => :grass
  add_fruit_plants(taiga)
  add_common_resources(taiga)
end

@world.biome :taiga => "SnowyTaiga" do |taiga|
  taiga.size = 2
  taiga.rarity = 350
  taiga.ice = true
  taiga.temperature = 0.0
  taiga.wetness = 0.4
  taiga.isles << "TaigaRedwoodGrove"
  add_common_resources(taiga)
end

@world.biome :mountains do |mountains|
  add_common_resources(mountains)
end

@world.biome :wooded_mountains do |mountains|
  add_fruit_plants(mountains)
  add_common_resources(mountains)
end

@world.biome :snowy_mountains do |mountains|
  mountains.rarity = 50
  add_common_resources(mountains)
end

@world.biome :wooded_snowy_mountains do |mountains|
  add_common_resources(mountains)
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
  hills.plant RedPower::IndigoPlant, :frequency => 1, :rarity => 25, :between => 0..128, :in => :grass
  add_fruit_plants(hills, 0.1)
  add_common_resources(hills)
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
  add_fruit_plants(hills, 0.1)
  add_common_resources(hills)
end

@world.biome :plains do |plains|
  plains.size = 2
  plains.rarity = 500
  plains.height = 0.0
  plains.volatility = 0.0
  plains.rivers = false
  plains.plant WeeeFlowers::BlueWildflower, :frequency => 4, :rarity => 65, :between => 0..128, :in => :grass
  plains.plant HarvestCraft::Sunflower, :frequency => 5, :rarity => 65, :between => 0..128, :in => :grass
  plains.grass WeeeFlowers::BlackRose, :frequency => 1, :rarity => 2, :in => :grass
  plains.grass WeeeFlowers::BrightGreenShrub, :frequency => 2, :rarity => 10, :in => :grass
  plains.grass WeeeFlowers::MagentaWildflower, :frequency => 3, :rarity => 50, :in => :grass
  plains.grass WeeeFlowers::PinkDaisy, :frequency => 2, :rarity => 50, :in => :grass
  add_common_resources(plains)
end

@world.biome :plains => "SnowyPlains" do |plains|
  plains.size = 2
  plains.rarity = 50
  plains.color = 0xd3dded
  plains.ice = true
  plains.temperature = 0.0
  plains.wetness = 0.5
  plains.height = 0.0
  plains.volatility = 0.0
  plains.rivers = false
  plains.clear_resources! :grass
  plains.grass :tall_grass, :frequency => 5, :rarity => 50, :in => [:dirt, :grass]
  plains.plant WeeeFlowers::WhiteRose, :frequency => 1, :rarity => 10, :between => 0..128, :in => :grass
  plains.plant WeeeFlowers::GreyPeonie, :frequency => 10, :rarity => 25, :between => 0..128, :in => :grass
  plains.plant WeeeFlowers::BlueWildflower, :frequency => 2, :rarity => 50, :between => 0..128, :in => :grass
  add_common_resources(plains)
end

@world.biome :plains => "Savannah" do |savannah|
  savannah.size = 2
  savannah.rarity = 200
  savannah.color = 0xc4a64a
  savannah.temperature = 1.0
  savannah.wetness = 0.0
  savannah.height = 0.0
  savannah.volatility = 0.0
  savannah.rivers = false
  savannah.clear_resources! :grass
  savannah.grass :tall_grass, :frequency => 100, :rarity => 100, :in => :grass
  savannah.clear_resources! :plant
  add_common_resources(savannah)
end

@world.biome :plains => "Scrubland" do |scrubland|
  scrubland.size = 2
  scrubland.rarity = 200
  scrubland.color = 0x64c58f
  scrubland.clear_resources! :grass
  scrubland.clear_resources! :plant
  add_common_resources(scrubland)
end

@world.biome :swamp do |swamp|
  swamp.size = 2
  swamp.rarity = 350
  swamp.ore :clay, :size => 12, :frequency => 10, :rarity => 75, :between => 0..128, :in => :stone
  swamp.ore :soul_sand, :size => 48, :frequency => 10, :rarity => 50, :between => 0..128, :in => [:dirt, :grass]
  swamp.grass WeeeFlowers::DyingShrub, :frequency => 5, :rarity => 25, :in => :grass
  swamp.reed :sugar_cane, :frequency => 10, :rarity => 33, :between => 0..128, :in => [:grass, :dirt, :sand]
  add_fruit_plants(swamp)
  add_common_resources(swamp)
end

@world.isle :plains => "HellFireRegion" do |fire|
  fire.color = 0xd15012
  fire.size = 6
  fire.rarity = 250
  fire.ground = :netherrack
  fire.surface = :fire
  fire.temperature = 1.0
  fire.wetness = 0.0
  fire.rivers = false
  fire.ore :stationary_lava, :size => 32, :frequency => 20, :rarity => 100, :between => 0..128, :in => [:stone, :netherrack]
  fire.replace :stationary_water, :with => :fire
end

@world.isle :plains => "HellLavaRegion" do |lava|
  lava.color = 0xd15012
  lava.size = 6
  lava.rarity = 250
  lava.ground = :netherrack
  lava.surface = :stationary_lava
  lava.temperature = 1.0
  lava.wetness = 0.0
  lava.rivers = false
  lava.replace :stationary_water, :with => :stationary_lava
end

def hellify(hell)
  hell.color = 0xf26522
  hell.size = 4
  hell.rarity = 15
  hell.ground = :netherrack
  hell.surface = :netherrack
  hell.temperature = 1.0
  hell.wetness = 0.0
  hell.rivers = false
  hell.isles = %w(HellFireRegion HellLavaRegion)
  hell.ore :fire, :size => 32, :frequency => 20, :rarity => 100, :between => 0..128, :in => :netherrack
  hell.ore :stationary_lava, :size => 32, :frequency => 20, :rarity => 100, :between => 0..128, :in => [:stone, :netherrack]
  hell.grass :dead_bush, :frequency => 3, :rarity => 50, :between => 0..128, :in => :netherrack
  hell.replace :stationary_water, :with => :fire
end

@world.biome :plains => "HellPlains" do |hell|
  hellify(hell)
end

@world.biome :mountains => "HellMountains" do |hell|
  hellify(hell)
end

@world.isle :island => "GrassyIsland" do |island|
  island.rarity = 200
  island.tree :frequency => 1, :trees => ["BigTree", 10, "Tree", 100]
  island.plant RedPower::IndigoPlant, :frequency => 8, :rarity => 100, :between => 0..128, :in => :grass
  island.reed :sugar_cane, :frequency => 5, :rarity => 75, :between => 0..128, :in => [:grass, :dirt, :sand]
  add_fruit_plants(island, 0.2)
  add_common_resources(island)
end

@world.isle :island => "SnowyIsland" do |island|
  island.color = 0xd4ebef
  island.rarity = 200
  island.ice = true
  island.temperature = 0.0
  island.wetness = 0.4
  island.tree :frequency => 1, :trees => ["BigTree", 10, "Tree", 100]
  island.plant WeeeFlowers::WhiteRose, :frequency => 1, :rarity => 10, :between => 0..128, :in => :grass
  island.plant WeeeFlowers::GreyPeonie, :frequency => 10, :rarity => 25, :between => 0..128, :in => :grass
  add_common_resources(island)
end

@world.border :mushroom_island_shore
@world.isle :mushroom_island do |shrooms|
  shrooms.color = 0xa7744f
  shrooms.rarity = 10
  shrooms.border = "MushroomIslandShore"
  add_common_resources(shrooms)
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

def add_water_resources(water)
  water.ore HarvestCraft::Salt, :size => 10, :frequency => 25, :rarity => 85, :between => 0..128, :in => [:stone, :dirt]
end

@world.biome :ocean do |ocean|
  ocean.size = 1
  ocean.rarity = 15
  ocean.isles = %w(CidsaIsland GrassyIsland MushroomIsland WoolIsland)
  add_water_resources(ocean)
  add_common_resources(ocean)
end

@world.biome :frozen_ocean do |ocean|
  ocean.size = 3
  ocean.rarity = 15
  ocean.isles = %w(CidsaIsland SnowyIsland MushroomIsland WoolIsland)
  add_water_resources(ocean)
  add_common_resources(ocean)
end

@world.other :river do |river|
  add_water_resources(river)
  add_common_resources(river)
  river.reed :sugar_cane, :frequency => 5, :rarity => 33, :between => 0..128, :in => [:grass, :dirt, :sand]
end

world_path = File.join(File.dirname(__FILE__), "..")
@world.write(world_path)
