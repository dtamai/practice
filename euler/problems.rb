require_relative 'problem'

EulerProblem.new 1 do
  (1...1000).to_a.keep_if do |n|
    n % 3 == 0 || n % 5 == 0
  end.reduce(&:+)
end

EulerProblem.new 2 do
  fib = lambda do |accum, max|
    t = accum[-1] + accum[-2]
    return accum if t > max
    accum << t
    fib.call(accum, max)
  end
  fib.call([1,2], 4_000_000).select(&:even?).reduce(&:+)
end

EulerProblem.new 3 do
  # Amazing prime number candidate generator!
  candidates = Enumerator.new do |c|
    c.yield 2
    t = 1
    loop { c.yield t += 2 }
  end

  k = 600_851_475_143
  int_factors = []
  # Trial division
  while i = candidates.next do
    break if i*i > k

    while k % i == 0 do
      int_factors << i
      k /= i
    end
  end
  int_factors << k if k > 1
  int_factors.last
end

