class Seat
  attr_reader(:n, :m, :k)
  def initialize(n, m, k)
    @n = n
    @m = m
    @k = k
  end

  def rowlimit
    m * 2
  end

  def p
    k % rowlimit
  end

  def row
    if(p == 0)
      (k / rowlimit)
    else
      1 + (k / rowlimit)
    end
  end

  def column
    if(p == 0)
      m
    else
      (p + 1) / 2
    end
  end

  def pos
    return "L" if p % 2 == 1
    return "R"
  end

  def to_s
    "#{row} #{column} #{pos}"
  end

end

vars = gets.strip.split(" ").map(&:to_i)
s = Seat.new(*vars)
puts s
