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
    t0 = Time.now
    runner = Thread.new do
      @@problems[number] = body.call
    end
    limit = Thread.new(runner) do |r|
      sleep 60
      r.raise RuntimeError.new "Timeout"
    end
    runner.join
    limit.kill

    t2 = Time.now
    puts "Problem #{number} [#{(t2 - t0).round 3}s]: #{@@problems[number]}"
  end
end
