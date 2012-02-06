module Resourceful
  module HarvestCraft
    class BaseTree < Resource
      self.block_id = 175
    end
    
    def self.Tree(data = 0)
      Class.new(BaseTree).tap do |klass|
        klass.class_eval do
          self.block_data = data
        end
      end
    end
    
    AppleTree = Tree(0)
    BananaTree = Tree(1)
    CherryTree = Tree(2)
    CoconutTree = Tree(3)
    LemonTree = Tree(4)
    OrangeTree = Tree(5)
    PeachTree = Tree(6)
    LimeTree = Tree(7)
    MangoTree = Tree(8)
    CocoaTree = Tree(9)
    WalnutTree = Tree(10)
    PearTree = Tree(11)
    PlumTree = Tree(12)
    OliveTree = Tree(13)
    CinnamonTree = Tree(14)
    HoneyTree = Tree(15)
  end
end
