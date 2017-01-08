require 'memoist'
require 'set'
class Dice

  extend Memoist
  attr_reader(:n, :dice)
  def initialize(n, dice)
    @n = n
    @dice = dice
  end

  def testrun
    (1..100000).map do
      Array.new(n){ Random.rand(0..(dice - 1))}.inject(:+)
    end
  end
  memoize(:testrun)

  def probs_for(x)
    testrun.select{|t| t == x }.length
  end

  def probs3
    (0..3).map do |i|
      (0..3).map do |j|
        (0..3).map do |k|
          (0..3).map do |l|
            i + j + k + l
          end
        end
      end
    end.flatten
  end
  memoize(:probs3)

end

d = Dice.new(2, 3)
y = d.probs3
s = d.probs3.to_set
z = s.map{|i| y.select{|x| x == i}.length }
print z.join(" ")
# puts (0..19).map{|i| "#{i}: #{d.probs_for(i)}" }
