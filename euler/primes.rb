# Amazing!
class PrimeCandidateGenerator

  def initialize
    @candidates = Enumerator.new do |c|
      c.yield 2
      t = 1
      loop { c.yield t += 2 }
    end
  end

  def next
    @candidates.next
  end
end
