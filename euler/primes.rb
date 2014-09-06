require 'forwardable'

# Class to provide candidates for integer factorization
#
# The first call to #next returns 1, then 2, then every odd number
class FactorsCandidatesGenerator
  extend Forwardable


  def_delegators :@candidates, :next, :rewind, :peek

  def initialize
    @candidates = Enumerator.new do |c|
      c.yield 1
      c.yield 2
      t = 1
      loop { c.yield t += 2 }
    end
  end

end

# Amazing!
class PrimeCandidateGenerator
  extend Forwardable

  def_delegators :@candidates, :next, :rewind

  def initialize
    @candidates = FactorsCandidatesGenerator.new
    @candidates.next if @candidates.peek == 1
  end

end

class TrialDivision

  def initialize(candidates)
    @candidates = candidates
  end

  def factorize(n)
    @candidates.rewind
    factors = []
    k = n

    while i = @candidates.next
      break if i*i > k

      if k % i == 0
        factors << i
        quotient = k/i
        factors << quotient
        k = quotient
      end
    end

    factors.sort
  end

end

class ProperDivisors
  def self.for(n)
    max = n
    candidate = 2
    divisors = [1]
    while candidate < max do
      if n % candidate == 0
        divisors << candidate
        max = n/candidate
        divisors << max
      end
      candidate += 1
    end
    divisors.sort
  end
end

