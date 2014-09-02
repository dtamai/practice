require './answer'

LIMIT ||= 100

class SingleIf

  FIZZES = ['Fizz', 'Buzz', 'Fizz', 'Fizz', 'Buzz', 'Fizz', 'FizzBuzz'].cycle

  def self.run
    answer = (1..LIMIT).map do |n|
      if n % 3 == 0 || n % 5 == 0
        FIZZES.next
      else
        n.to_s
      end
    end

    answer
  end

end

check SingleIf.run


