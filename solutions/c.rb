require 'memoist'
class PascalTriangle
  extend Memoist
  attr_reader(:n, :parent, :generation_number)
  def initialize(n, generation_number = 1, parent = nil)
    @n = n
    @parent = parent
    @generation_number = generation_number
  end

  def line
    return Array.new(n){ 1 } if parent.nil?
    my_generation
  end
  memoize(:line)

  def stops
    (1..parent.line.length + n - 1)
  end

  def starts
    stops.map{|s| [s - n, 0].max }
  end

  def accumulative
    (1..line.length).map do |i|
      line.take(i).inject(:+)
    end.reverse
  end
  memoize(:accumulative)

  def my_generation
    starts.zip(stops).map do |s0, s1|
      parent.line.take(s1).drop(s0).inject(:+)
    end
  end

  def go_down(n)
    return self if n == 0
    return child.go_down(n - 1)
  end

  def child
    PascalTriangle.new(n, generation_number + 1, self)
  end
  memoize(:child)

  def inspect
    "PascalTriangle(#{line}, #{accumulative})"
  end

  def sum
    line.inject(:+)
  end
  memoize(:sum)

  def offset
    n
  end

  def probs_for_gt(x)
    return 1 if x <= generation_number
    index = [x - generation_number, 0].max
    (accumulative[index] / accumulative.first.to_f).round(7)
  end

  def to_s
    inspect
  end
end

class PascalTriangle
  Dices = [4, 6, 8, 10, 12, 20]
  Memo = Hash[Dices.map{|i| [i, PascalTriangle.new(i)] }]
end

PascalTriangle::Memo.each do |k, pt|
  pt.go_down(21)
end

require 'pry'
binding.pry
