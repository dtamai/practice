require 'rubygems'
require 'bundler/setup'
require 'celluloid/autostart'

LIMIT ||= 100

class Fizzer
  include Celluloid

  def fizz(n)
    case
    when n % 15 == 0 then 'FizzBuzz'
    when n % 5 == 0 then 'Buzz'
    when n % 3 == 0 then 'Fizz'
    else n.to_s
    end
  end

end

$fizzers = Fizzer.pool
class FizzActor

  def self.run
    answer = (1..LIMIT).to_a.map { |n| $fizzers.future.fizz(n) }

    answer.map! &:value
  end
end

