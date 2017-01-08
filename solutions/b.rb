require 'memoist'

class WeightMultiplier
  attr_reader(:weight, :multiplier)
  def initialize(weight, multiplier)
    @weight = weight
    @multiplier = multiplier
  end

  def to_s
    inspect
  end
end

class LazyLoader
  MinimumWeight = 50
  MagicArray = [50, 25, 17, 13, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
  MagicMultipliers = MagicArray.map{|x| WeightMultiplier.new(x, (50.0/x).ceil)}

  attr_reader(:items, :runtime)
  def initialize(items)
    @items = items.sort
    @runtime = 0
  end

  def finished?
    items.sum < MinimumWeight
  end

  def put_one!
    w = items.pop
    return false if w.nil?
    m = MagicMultipliers.select{|x| x.weight <= w }.first
    return false if (items.length < (m.multiplier - 1))
    @items = @items.drop(m.multiplier - 1)
    @runtime += 1
    return true
  end

end

def print_solution!(index)
  n = gets.to_i
  qs = Array.new(n){ gets.to_i }
  ll = LazyLoader.new(qs)
  while ll.put_one!; end
  puts "Case ##{index}: #{ll.runtime}"
end


def main
  tc = gets.to_i
  (1..tc).each{|i| print_solution!(i) }
end

main

