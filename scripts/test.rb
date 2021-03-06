require File.expand_path("../base", __FILE__)
require "date"
class ArgParserTester < ArgParser
  class << self
    def params
      [
        :runner,
        :script
      ]
    end

    def valid?
      params.all?{|p| arguments.keys.include?(p.to_s) }
    end

    def validate!
      if(not valid?)
        puts("    programs usage example should be something like: ")
        puts("    ruby test.rb --runner=runhaskell --script=b.hs")
      end
    end

    def problem
      script.split(".").first.upcase
    end

    def testcases
      Dir["testcases/#{problem}*.txt"]
    end

    def runner
      arguments[:runner]
    end

    def script
      arguments[:script]
    end

    def script_path
      "solutions/#{script}"
    end

    def run!
     testcases.each do |path|
       puts "input:"
       puts File.read(path)
       puts "output:"
       start = DateTime.now
       system "cat #{path} | #{runner} #{script_path}"
       stop = DateTime.now
       delay = -(start.to_time.to_f - stop.to_time.to_f)
       puts "running for #{ "%03f" % [delay]}s"
       puts
      end
    end
  end
end

def main
  ArgParserTester.validate!
  ArgParserTester.run!
end

main
