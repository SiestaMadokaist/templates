require "memoist"
require "hashie"
require File.expand_path("../scripts/base.rb", __FILE__)
class A < Problem
  def n
    random_int(1, 10)
  end
  memoize(:n)

  def line
    options = ["OO","OX", "XO", "XX"]
    replicate(n) do
      x = random_options(options)
      y = random_options(options)
      "#{x}|#{y}"
    end
  end

  def generate!
    [n] + line
  end
end

class B < Problem
  def n
    random_int(1, 5)
  end
  memoize(:n)

  def line
    replicate(n) do
      replicate(n){ random_int(1, 20) }.join(" ")
    end
  end

  def generate!
    [n] + line
  end

end

def main
  ArgParser.validate!
  tc = ArgParser.tc
  (1..tc).each do |i|
    prob = ArgParser.constructor.new
    prob.run!(i)
  end
end

main
