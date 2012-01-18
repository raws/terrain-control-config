module Resourceful
  module HarvestCraft
    class BaseBush < Resource
      self.block_id = 174
    end
    
    class BlueberryBush < BaseBush; end
    
    class BlackberryBush < BaseBush
      self.block_data = 1
    end
    
    class RaspberryBush < BaseBush
      self.block_data = 2
    end
    
    class KiwifruitBush < BaseBush
      self.block_data = 3
    end
    
    class StrawberryBush < BaseBush
      self.block_data = 4
    end
    
    class GrapeBush < BaseBush
      self.block_data = 5
    end
    
    class Sunflower < BaseBush
      self.block_data = 6
    end
  end
end
