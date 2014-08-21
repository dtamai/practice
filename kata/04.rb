module Kata04

  class SimpleFixedWidth

    attr_reader :lines

    def initialize(file)
      @lines = File.readlines file
    end

    def observations
      lines
    end

    def extract_values(cols, &conversion)
      observations.map do |l|
        conversion.call(l[cols].strip)
      end
    end

  end

  class Weather < SimpleFixedWidth

    # line 1: header
    # line 2: separator
    # lines 3-31: observations
    # line 32: summary
    def observations
      lines[2..30]
    end

    # cols 1-5
    def day
      extract_values(0..4, &:to_i)
    end

    # cols 6-11
    def max_temp
      extract_values(5..10, &:to_i)
    end

    # cols 12-17
    def min_temp
      extract_values(11..16, &:to_i)
    end

  end

  class Football < SimpleFixedWidth

    # line 1: header
    # lines 2-18,20-22: observations
    # line 19: separator
    def observations
      lines[(1..17)] + lines[19..22]
    end

    # cols 8-23
    def name
      extract_values(7..22, &:to_s)
    end

    # cols 44-47
    def for_goals
      extract_values(43..46, &:to_i)
    end

    # cols 51-54
    def against_goals
      extract_values(50..53, &:to_i)
    end

  end

end

def min_b_minus_c(a, b, c)
  [a, b, c].transpose.map do |a, b, c|
    [a, b - c]
  end.min{|a,b| b[1] <=> a[1]}
end

w = Kata04::Weather.new('./kata/data/weather.dat')
min_spread = min_b_minus_c(w.day, w.max_temp, w.min_temp)
puts "Minimum temperature spread (#{min_spread[1]}) on day #{min_spread[0]}"

f = Kata04::Football.new('./kata/data/football.dat')
min_balance = min_b_minus_c(f.name, f.for_goals, f.against_goals)
puts "Team with best goal balance (#{min_balance[1]}) is #{min_balance[0]}"
