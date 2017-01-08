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

    def expectations
      Dir["expectations/#{problem}*.txt"]
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

    def safe_read(path)
      begin
        File.read(path)
      rescue
        ""
      end
    end

    def run!
      testcases.zip(expectations).each do |testpath, expectpath|
        puts "input: #{testpath}"
        puts File.read(testpath)
        puts "output:"
        start = DateTime.now
        system "cat #{testpath} | #{runner} #{script_path}"
        # puts "expected:"
        # puts safe_read(expectpath)
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
