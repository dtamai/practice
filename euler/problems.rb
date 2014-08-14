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

EulerProblem.new 7 do
  require_relative './primes'
  candidates = PrimeCandidateGenerator.new
  primes = []

  while i = candidates.next do
    break if primes.length >= 10_001

    prime = true
    primes.each do |p|
      prime = (i.modulo(p) != 0)
      break if !prime
    end
    primes << i if prime
  end
  primes.last
end

EulerProblem.new 8 do
  big = <<EON.gsub(/\n/, '').each_char.map(&:to_i)
73167176531330624919225119674426574742355349194934
96983520312774506326239578318016984801869478851843
85861560789112949495459501737958331952853208805511
12540698747158523863050715693290963295227443043557
66896648950445244523161731856403098711121722383113
62229893423380308135336276614282806444486645238749
30358907296290491560440772390713810515859307960866
70172427121883998797908792274921901699720888093776
65727333001053367881220235421809751254540594752243
52584907711670556013604839586446706324415722155397
53697817977846174064955149290862569321978468622482
83972241375657056057490261407972968652414535100474
82166370484403199890008895243450658541227588666881
16427171479924442928230863465674813919123162824586
17866458359124566529476545682848912883142607690042
24219022671055626321111109370544217506941658960408
07198403850962455444362981230987879927244284909188
84580156166097919133875499200524063689912560717606
05886116467109405077541002256983155200055935729725
71636269561882670428252483600823257530420752963450
EON

  big.each_cons(13).map do |ary|
    0 if (ary.find_index 0)
    ary.reduce(&:*)
  end.max

end

EulerProblem.new 9 do
  -> {
    # Ordering c >= b >= a
    # Geometry: c < a + b, so c must be less than 500
    500.downto 1 do |c|
      c.downto 1 do |b|
        b.downto (c - b + 1) do |a|
          return a*b*c if (a + b + c == 1000) && (a*a + b*b == c*c)
        end
      end
    end
  }.call
end

EulerProblem.new 10 do
  primes = [2]

  sieve = ->(numbers, prev) {
    max = numbers.last
    prev.each do |p|
      break if p*p > max
      numbers.delete_if { |n| n % p == 0 }
    end
    new_primes = numbers.slice!(0, 1)
    new_primes.each do |p|
      break if p*p > max
      numbers.delete_if { |n| n % p == 0 }

      # Change the array while iterating!
      new_primes << numbers.shift if numbers[0]
    end
    primes.concat new_primes.concat numbers
  }
  (10_000..2_000_000).step(10_000).to_a.unshift(1).each_cons(2) do |l|
    numbers = Range.new(l[0] + 1, l[1]).to_a
    sieve.call(numbers, primes)
  end

  primes.reduce(&:+)
end

