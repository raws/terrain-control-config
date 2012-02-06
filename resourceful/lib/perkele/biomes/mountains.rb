module Resourceful
  class Mountains
    self.size = 2
    self.rarity = 250
    plant WeeeFlowers::BlueHydrangea, :frequency => 3, :rarity => 75, :between => 64..128, :in => :grass
  end
  
  class WoodedMountains < Mountains
    self.color = 0x95b95b
    tree :frequency => 10, :trees => ["Forest", 20, "BigTree", 10, "Tree", 100]
    grass :tall_grass, :frequency => 15, :rarity => 100, :in => [:grass, :dirt]
  end
  
  class SnowyMountains < Mountains
    self.color = 0xb4c2d7
    self.ice = true
    self.temperature = 0.0
    self.wetness = 0.5
    clear_resources! :grass
    grass :tall_grass, :frequency => 5, :rarity => 50, :in => [:dirt, :grass]
    plant WeeeFlowers::WhiteRose, :frequency => 1, :rarity => 10, :between => 0..128, :in => :grass
    plant WeeeFlowers::GreyPeonie, :frequency => 10, :rarity => 25, :between => 0..128, :in => :grass
  end
  
  class WoodedSnowyMountains < SnowyMountains
    tree :frequency => 10, :trees => ["Forest", 20, "BigTree", 10, "Tree", 100]
    plant WeeeFlowers::WhiteRose, :frequency => 1, :rarity => 10, :between => 0..128, :in => :grass
    plant WeeeFlowers::GreyPeonie, :frequency => 10, :rarity => 25, :between => 0..128, :in => :grass
  end
end
