require "memoist"
require "hashie"
class Problem
  extend Memoist

  # should return array of string
  def generate!
    raise NotImplementedError
  end

  # @param start [Integer]
  # @param stop [Integer]
  def random_float(start, stop)
    diff = stop - start
    (Random.rand * diff) + start
  end

  # @param start [Integer]
  # @param stop [Integer]
  def random_int(start, stop)
    random_float(start, stop).to_i
  end

  # @param options [Array<t>]
  def random_options(options)
    options.shuffle.first
  end

  def replicate(n, &block)
    (0..(n-1)).map{ |i|  block.call(i) }
  end

  # @param sequence_number [Integer]
  def run!(sequence_number)
    lines = generate!.join("\n")
    class_name = self.class.name
    File.open("testcases/#{class_name}#{sequence_number}.txt", "wb"){|f| f.write(lines)  }
  end

end

class ArgParser
  class SecurityError < StandardError; end
  class << self
    def validate!
      if arguments[:problem].nil? || arguments[:tc].nil?
        puts("    Program usage should be:")
        puts("    ruby problems.rb --problem=<ProblemName> --tc=<AmountOfTestToCreate>")
        puts
        puts("    e.g: ruby problems.rb --problem=B --tc=4")
        exit
      end
    end

    def arguments
      parsed = ARGV.map{|x| x.match(/\A-*(?<var>[^=]+)=(?<value>.+)\z/) }.map{|x| [x[:var], x[:value]]}
      Hashie::Mash[Hash[parsed]]
    end

    def problem
      arguments[:problem].upcase
    end

    def constructor
      if(problem.length == 1 && problem >= "A" &&  problem <= "Z")
        eval(problem)
      else
        raise SecurityError
      end
    end

    def tc
      arguments[:tc].to_i
    end

  end
end

