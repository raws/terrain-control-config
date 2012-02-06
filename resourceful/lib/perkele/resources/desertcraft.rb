module Resourceful
  module DesertCraft
    class CactusBase < Resource
      self.block_id = 180
    end
    
    def self.Cactus(data = 0)
      Class.new(CactusBase).tap do |klass|
        klass.class_eval do
          self.block_data = data
        end
      end
    end
    
    RoundGreenRedCactus = Cactus(0)
    GnarlyBrownCactus = Cactus(1)
    RoundBrownCactus = Cactus(2)
    RoundPinkFlowerCactus = Cactus(3)
    RoundFadedPinkFlowerCactus = Cactus(4)
    GnarlyPinkFlowerCactus = Cactus(5)
    LargeDeadShrub = Cactus(6)
    SmallDeadShrub = Cactus(7)
  end
end
