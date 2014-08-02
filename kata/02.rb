module Kata02
  module Iterative
    def chop(x, ary)
      return -1 if ary.empty?
      return -1 if x < ary[0] || x > ary[-1]

      offset = -1
      while ary.length > 1
        min = 0
        max = ary.length - 1
        mid = max/2

        if x > ary[mid]
          offset += mid + 1
          ary = ary.slice (mid + 1)..max
        else
          ary = ary.slice min..mid
        end

      end
      x == ary[0] ? offset + 1 : -1
    end

    def l(min, mid, max, offset, ary)
      puts "min: #{min} mid: #{mid} max: #{max} offset: #{offset} ary: #{ary}"
    end
  end

  module Recursive
    def chop(x, ary)
      binary_search(x, ary, 0, ary.length - 1)
    end

    def binary_search(x, ary, min, max)
      return -1 if min > max

      mid = (min + max)/2

      if x < ary[mid]
        return binary_search(x, ary, min, mid-1)
      elsif x > ary[mid]
        return binary_search(x, ary, mid+1, max)
      else
        return mid
      end
    end
  end

  module Functional
    def chop(x, ary)
      binary_search(x, ary, 0)
    end

    def binary_search(x, ary, offset)
      return -1 if ary.empty?
      return -1 if x < ary[0] || x > ary[-1]

      mid = (ary.length - 1)/2
      if x < ary[mid]
        return binary_search(x, ary.slice(0..mid), offset)
      elsif x > ary[mid]
        return binary_search(x, ary.slice((mid+1)..-1), offset+mid+1)
      else
        return offset + mid
      end
    end
  end

  module Parallel
    def chop(x, ary)
      return -1 if ary.empty?
      parallel_search(x, ary, 0, ary.length - 1)
    end

    def parallel_search(x, ary, min, max)
      return -1 if min > max

      mid = (min + max)/2
      return mid if x == ary[mid]

      lo = Thread.new { parallel_search(x, ary, min, mid-1) }
      hi = Thread.new { parallel_search(x, ary, mid+1, max) }

      if lo.value > -1
        return lo.value
      else
        return hi.value
      end
    end
  end

  module Unnecessary
    def chop(x, ary)
      return -1 if ary.empty?
      @split = Split.new(ary, 0, ary.length - 1) unless ary.equal? @ary
      @ary = ary
      @split.find(x)
    end

    class Split
      def initialize(ary, min_idx, max_idx)
        mid_idx = (min_idx + max_idx)/2

        if min_idx < max_idx
          @left_down = Split.new(ary, min_idx, mid_idx)
          @right_down = Split.new(ary, mid_idx+1, max_idx)
        else
          @left_down = SplitTerminal.new(mid_idx)
          @right_down = SplitTerminal.new(mid_idx+1)
        end
        @left_range = ary[min_idx]..ary[mid_idx]
        @right_range = ary[mid_idx]..ary[max_idx]
      end

      def find(x)
        case x
        when @left_range then left(x)
        when @right_range then right(x)
        else -1
        end
      end

      def left(x)
        @left_down.find(x)
      end

      def right(x)
        @right_down.find(x)
      end
    end

    class SplitTerminal
      def initialize(idx)
        @idx = idx
      end

      def find(x)
        @idx
      end
    end
  end
end

require 'minitest/autorun'
require 'minitest/pride'

module ChopAssertion
  def test_chop
    assert_equal(-1, chop(3, []))
    assert_equal(-1, chop(3, [1]))
    assert_equal(0,  chop(1, [1]))

    assert_equal(0,  chop(1, [1, 3, 5]))
    assert_equal(1,  chop(3, [1, 3, 5]))
    assert_equal(2,  chop(5, [1, 3, 5]))
    assert_equal(-1, chop(0, [1, 3, 5]))
    assert_equal(-1, chop(2, [1, 3, 5]))
    assert_equal(-1, chop(4, [1, 3, 5]))
    assert_equal(-1, chop(6, [1, 3, 5]))

    assert_equal(0,  chop(1, [1, 3, 5, 7]))
    assert_equal(1,  chop(3, [1, 3, 5, 7]))
    assert_equal(2,  chop(5, [1, 3, 5, 7]))
    assert_equal(3,  chop(7, [1, 3, 5, 7]))
    assert_equal(-1, chop(0, [1, 3, 5, 7]))
    assert_equal(-1, chop(2, [1, 3, 5, 7]))
    assert_equal(-1, chop(4, [1, 3, 5, 7]))
    assert_equal(-1, chop(6, [1, 3, 5, 7]))
    assert_equal(-1, chop(8, [1, 3, 5, 7]))
  end
end

class TestKata02_Iterative < Minitest::Test
  include ChopAssertion
  include Kata02::Iterative
end

class TestKata02_Recursive < Minitest::Test
  include ChopAssertion
  include Kata02::Recursive
end

class TestKata02_Functional < Minitest::Test
  include ChopAssertion
  include Kata02::Functional
end

class TestKata02_Parallel < Minitest::Test
  include ChopAssertion
  include Kata02::Parallel
end

class TestKata02_Unnecessary < Minitest::Test
  include ChopAssertion
  include Kata02::Unnecessary

  def setup
    @split = nil
  end
end

