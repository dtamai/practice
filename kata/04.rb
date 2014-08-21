module Kata04

  class Weather

    # line 1: header
    # line 2: separator
    # lines 3-31: observations
    # line 32: summary
    def lines
      @lines ||= File.readlines 'kata/data/weather.dat'
    end

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

    def extract_values(cols, &conversion)
      observations.map do |l|
        conversion.call(l[cols].strip)
      end
    end

  end

end

w = Kata04::Weather.new
min = [w.day, w.min_temp, w.max_temp].transpose.map do |day, min, max|
  [day, max - min]
end.min{|a,b| b[1] <=> a[1]}
puts "Minimum temperature spread (#{min[1]}) on day #{min[0]}"

module Kata04

  class Football

    # line 1: header
    # lines 2-18,20-22: observations
    # line 19: separator
    def lines
      @lines ||= File.readlines 'kata/data/football.dat'
    end

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

    def extract_values(cols, &conversion)
      observations.map do |l|
        conversion.call(l[cols].strip)
      end
    end

  end

end

f = Kata04::Football.new
min = [f.name, f.for_goals, f.against_goals].transpose.map do |name, f, a|
  [name, f - a]
end.min{|a,b| b[1] <=> a[1]}
puts "Team with best goal balance (#{min[1]}) is #{min[0]}"
