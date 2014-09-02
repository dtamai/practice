require './answer'

LIMIT ||= 100
N_PARTS ||= 5

class Parallel

  FB_MAP = { 0 => 'FizzBuzz',
                3 => 'Fizz',
                5 => 'Buzz',
                6 => 'Fizz',
                9 => 'Fizz',
                10 => 'Buzz',
                12 => 'Fizz' }

  def self.map_fizzbuzz(numbers)
    numbers.map do |n|
      r = n % 15
      FB_MAP.has_key?(r) ? FB_MAP[r] : n.to_s
    end
  end

  def self.run
    part_size = LIMIT/N_PARTS
    threads = []
    answer = []

    N_PARTS.times do |n|
      min = n*part_size + 1
      part = min..min + part_size - 1

      threads << Thread.new do
        self.instance_variable_set("@part_#{n}", map_fizzbuzz(part))
      end
    end

    threads.each { |thr| thr.join }

    N_PARTS.times do |n|
      answer << self.instance_variable_get("@part_#{n}")
    end

    answer.flatten!(1)
  end

end

