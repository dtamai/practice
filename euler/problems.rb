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
  require_relative './primes'
  candidates = PrimeCandidateGenerator.new

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

EulerProblem.new 4 do
  is_palindromic = lambda { |n| n.to_s == n.to_s.reverse }

  max_palindrome = 0
  # Lower triangle of a matrix[i x j]
  999.downto(100) { |i| 999.downto(i) { |j|
    x = i*j
    max_palindrome = x if x > max_palindrome && is_palindromic[x]
  }}
  max_palindrome
end

EulerProblem.new 5 do
  divide_or_skip = lambda do |numbers, denominator|
    numbers.map do |n|
      n % denominator == 0 ? n/denominator : n
    end
  end

  factorization = lambda do |numbers, candidate, factors|
    new = divide_or_skip[numbers, candidate].delete_if { |n| n == 1}

    if new.length < numbers.length
      factors << candidate
    else
      candidate += 1
    end

    factorization[new, candidate, factors] unless new.empty?
    factors
  end

  factorization[(1..20).to_a, 2, []].reduce(&:*)
end

EulerProblem.new 6 do
  numbers = 1.upto(100).to_a
  sq_sum = numbers.map{ |n| n**2 }.reduce(&:+)
  sum_sq = numbers.reduce(&:+)**2
  sum_sq - sq_sum
end

