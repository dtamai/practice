require './answer'

LIMIT ||= 100

class Basic

  def self.run
    answer = (1..LIMIT).map do |n|
      case
      when n % 15 == 0 then 'FizzBuzz'
      when n % 5 == 0 then 'Buzz'
      when n % 3 == 0 then 'Fizz'
      else n.to_s
      end
    end

    answer
  end

end

