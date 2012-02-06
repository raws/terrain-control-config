module Resourceful
  module RedPower
    class BaseOre < Resource
      self.block_id = 165
    end
    
    class Ruby < BaseOre; end
    
    class Emerald < BaseOre
      self.block_data = 1
    end
    
    class Sapphire < BaseOre
      self.block_data = 2
    end
    
    class Silver < BaseOre
      self.block_data = 3
    end
    
    class Tin < BaseOre
      self.block_data = 4
    end
    
    class Copper < BaseOre
      self.block_data = 5
    end
    
    class Tungsten < BaseOre
      self.block_data = 6
    end
    
    class Nikolite < BaseOre
      self.block_data = 7
    end
  end
end
