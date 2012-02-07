module Resourceful
  class Wood < Resource
    self.block_id = 17
  end
  
  class PineWood < Wood
    self.block_data = 1
  end
  
  class BirchWood < Wood
    self.block_data = 2
  end
  
  class Leaves < Resource
    self.block_id = 18
  end
  
  class Glass < Resource
    self.block_id = 20
  end
  
  class Sandstone < Resource
    self.block_id = 24
  end
  
  class Netherrack < Resource
    self.block_id = 87
  end
  
  class SoulSand < Resource
    self.block_id = 88
  end
  
  class Fire < Resource
    self.block_id = 51
  end
  
  class Wool < Resource
    self.block_id = 35
  end
  
  def self.Wool(block_data)
    Class.new(Wool).tap do |klass|
      klass.block_data = block_data
    end
  end
  
  WhiteWool = Wool(0)
  OrangeWool = Wool(1)
  MagentaWool = Wool(2)
  LightBlueWool = Wool(3)
  YellowWool = Wool(4)
  LimeWool = Wool(5)
  PinkWool = Wool(6)
  GrayWool = Wool(7)
  LightGrayWool = Wool(8)
  CyanWool = Wool(9)
  PurpleWool = Wool(10)
  BlueWool = Wool(11)
  BrownWool = Wool(12)
  GreenWool = Wool(13)
  RedWool = Wool(14)
  BlackWool = Wool(15)
end
