require_relative 'problem'
require_relative './primes'

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
  candidates = FactorsCandidatesGenerator.new
  trial_divider = TrialDivision.new(candidates)

  k = 600_851_475_143
  int_factors = trial_divider.factorize k
  int_factors.take_while { |n| n*n < k }.last
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
  require_relative './data/8'
  big = data.each_char.map(&:to_i)

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

EulerProblem.new 11 do
  require_relative './data/11'

  grid = data
  hmax = (0..19).map do |i|
    (0..16).map do |k|
      grid[i][k..k+3].reduce(&:*)
    end.max
  end.max

  vmax = (0..19).map do |j|
    (0..16).map do |k|
      (k..k+3).map{|l| grid[l][j]}.reduce(&:*)
    end.max
  end.max

  dmax1 = (0..16).map do |i|
    (0..16).map do |j|
      (0..3).map{|k| grid[i+k][j+k]}.reduce(&:*)
    end.max
  end.max

  dmax2 = (3..19).map do |i|
    (0..16).map do |j|
      (0..3).map{|k| grid[i-k][j+k]}.reduce(&:*)
    end.max
  end.max
  [vmax, hmax, dmax1, dmax2].max
end

EulerProblem.new 12 do
  triangles = Enumerator.new do |t|
    naturals = 1.upto Float::INFINITY
    sum = 0
    loop { t.yield sum += naturals.next }
  end

  factorize = ->(n) {
    factors = []
    max = Math.sqrt(n).floor
    1.upto max do |k|
      if n % k == 0
        factors << n
        factors << n/k
      end
    end
    factors
  }

  n = 0
  loop do
    n = triangles.next
    factors = factorize.call(n)
    break if factors.length > 500
  end
  n
end

EulerProblem.new 13 do
  require_relative './data/13'
  hundreds = data
  hundreds.reduce(&:+).to_s.slice(0, 10)
end

EulerProblem.new 14 do
  done = ->(n) { n == 1 }
  even = ->(n) { n.even? }
  odd = ->(n) { n.odd? }
  collatzes = {}
  collatz_seq = ->(n) {
    return collatzes[n] if collatzes[n]
    case n
    when done then return 1
    when even
      collatzes[n] = collatz_seq.call(n/2) + 1
    when odd
      collatzes[n] = collatz_seq.call(3*n + 1) + 1
    end
  }

  (1..1_000_000).each do |n|
    collatz_seq.call(n)
  end
  max = collatzes.values.max
  collatzes.select{ |k,v| v == max }.keys.first
end

EulerProblem.new 15 do
  factorial = ->(n) {
    (2..n).inject(1) { |t, n| t*n }
  }
  # 40 segments, 20 down, 20 right
  # 40!/(20!20!) => permutation of multisets
  factorial[40]/factorial[20]/factorial[20]
end

EulerProblem.new 16 do
  (2**1000).to_s.split('').map(&:to_i).reduce(&:+)
end

EulerProblem.new 17 do
  words = Hash.new do |hash, key|
    case key
    when 21..99
      tens = key/10
      upto_10 = key - 10*tens
      tentys = key/10*10
      str = hash[tentys] + hash[upto_10]
      hash[key] = str
    when 99..999
      hundreds = key/100
      upto_100 = key - 100*hundreds
      perfect_100 = upto_100 == 0
      if perfect_100
        hash[hundreds] + 'hundred'
      else
        hash[hundreds] + 'hundredand' + hash[upto_100]
      end
    end
  end
  words[1] = 'one';    words[11] = 'eleven';    words[30] = 'thirty'
  words[2] = 'two';    words[12] = 'twelve';    words[40] = 'forty'
  words[3] = 'three';  words[13] = 'thirteen';  words[50] = 'fifty'
  words[4] = 'four';   words[14] = 'fourteen';  words[60] = 'sixty'
  words[5] = 'five';   words[15] = 'fifteen';   words[70] = 'seventy'
  words[6] = 'six';    words[16] = 'sixteen';   words[80] = 'eighty'
  words[7] = 'seven';  words[17] = 'seventeen'; words[90] = 'ninety'
  words[8] = 'eight';  words[18] = 'eighteen';  words[1000] = 'onethousand'
  words[9] = 'nine';   words[19] = 'nineteen';
  words[10] = 'ten';   words[20] = 'twenty'

  1.upto(1000).reduce(0) do |t, n|
    t += words[n].length
  end
end

EulerProblem.new 18 do
  require_relative './data/18'
  tri = data

  h = tri.size
  ary = tri[h-1]
  h.downto(2) do |n|
    pre = tri[n-2]
    nl = ary.each_index.each_cons(2).map do |pair|
      parent = pre[pair[0]]
      pair.map do |el|
        ary[el] + parent
      end.max
    end
    ary = nl
  end
  ary[0]
end

EulerProblem.new 19 do
  require 'date'
  (Date.new(1901, 1, 1)..Date.new(2000, 12, 31)).to_a.keep_if do |d|
    d.sunday? && d.day == 1
  end.size
end

EulerProblem.new 20 do
  (1..100).reduce(&:*).to_s.each_char.map(&:to_i).reduce(&:+)
end

EulerProblem.new 67 do
  require_relative './data/67'
  tri = data

  h = tri.size
  ary = tri[h-1]
  h.downto(2) do |n|
    pre = tri[n-2]
    nl = ary.each_index.each_cons(2).map do |pair|
      parent = pre[pair[0]]
      pair.map do |el|
        ary[el] + parent
      end.max
    end
    ary = nl
  end
  ary[0]
end

