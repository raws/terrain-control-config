module Resourceful
  module RedPower
    class BaseBlock < Resource
      self.block_id = 167
    end
    
    class Marble < BaseBlock; end
    
    class Basalt < BaseBlock
      self.block_data = 1
    end
  end
end
