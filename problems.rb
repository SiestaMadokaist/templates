require "memoist"
require "hashie"
require File.expand_path("../scripts/base.rb", __FILE__)
class A < Problem
  def n
    random_int(1, 20)
  end
  memoize(:n)

  def options
    ["A", "B"]
  end

  def line
    replicate(random_int(3, 20)){ random_options(options)}.join("")
  end

  def generated
    [line]
  end
end

class B < Problem
  def n
    random_int(1, 10)
  end
  memoize(:n)

  def line
    (1..4).map{ random_options(['o', 'x', '.', '.'])}.join("")
  end

  def generated
    (1..4).map{ line }
  end

end

class C < Problem

  def initialize
    @values = []
  end

  def randint(x, y)
    random_int(x, y)
  end

  def lines
    s = randint(1, 10)
    [
      [s, randint(0, s), randint(0, s)].join(" "),
      [randint(1, 10), randint(1, 10)].join(" "),
      [randint(0, s), random_options([-1, 1])].join(" ")
    ]
  end

  def generated
    lines
  end

end

class H < Problem
  extend Memoist
  def n
    random_int(2, 10)
  end
  memoize(:n)

  def k
    random_int(2, 10)
  end
  memoize(:k)

  def ys
    (1..n).to_a.shuffle.take(k).sort.join(" ")
  end
  memoize(:ys)

  def header
    ["#{n} #{k}"]
  end

  def options
    ["A", "B", "C", "D"]
  end

  def body
    x = random_int(1, 10)
    replicate(n) do |i|
      replicate(x){ random_options(options) }.join
    end
  end

  def generated
    [header] + body + [ys]
  end

end
def main
  ArgParser.validate!
  tc = ArgParser.tc
  (0..tc).each do |i|
    prob = ArgParser.constructor.new
    prob.run!(i)
  end
end

main
