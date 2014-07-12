class EulerProblem

  @@problems = {}
  def self.list
    @@problems
  end

  attr_reader :number, :body

  def initialize(number, &block)
    @number = Integer(number)
    @body = block
    @@problems[number] = self
  end

  def go
    runner = Thread.new do
      @@problems[number] = body.call
    end
    limit = Thread.new(runner) do |r|
      sleep 60
      r.raise RuntimeError.new "Timeout"
    end
    runner.join
    limit.kill

    puts "Problem #{number}: #{@@problems[number]}"
  end
end
