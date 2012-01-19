module Resourceful
  class Island < Biome
    self.color = 0x41ae24
    
    self.size = 6
    self.rarity = 90
    
    self.height = 0.2
    self.volatility = 0.2
  end
  
  class Shore < Biome
    self.color = 0x37931e
    
    self.wetness = 1.0
    self.rivers = false
    
    self.height = -1.0
    self.volatility = 0.1
  end
end
