module Resourceful
  module WeeeFlowers
    class BaseFlower < Resource
      self.block_id = 179
    end
    
    def self.Flower(data = 0)
      Class.new(BaseFlower).tap do |klass|
        klass.class_eval do
          self.block_data = data
        end
      end
    end
    
    WhiteRose = Flower(0)
    OrangePoppy = Flower(1)
    MagentaWildflower = Flower(2)
    BlueChrysanthemum = Flower(3)
    BrightGreenShrub = Flower(4)
    PinkDaisy = Flower(5)
    GreyPeonie = Flower(6)
    WildParsley = Flower(7)
    BlueWildflower = Flower(8)
    PurpleViolet = Flower(9)
    BlueHydrangea = Flower(10)
    DyingShrub = Flower(11)
    DarkGreenShrub = Flower(12)
    BlackRose = Flower(13)
  end
end
