require './answer'

LIMIT ||= 100

class Cycling

  def self.run
    base = (1..LIMIT).to_a.map(&:to_s)
    rep1 = [nil, nil, 'Fizz'].cycle.take(LIMIT)
    rep2 = [nil, nil, nil, nil, 'Buzz'].cycle.take(LIMIT)

    answer = [base, rep1, rep2].transpose.map do |x|
      x.compact!
      x.shift if x.size > 1
      x.reduce(:+)
    end

  end

end

