class CircularArray
  attr_reader :array, :cursor

  def initialize(size, &block)
    @array = Array.new(size, &block)
    @cursor = 0
  end

  def remove_and_move(m)
    removed = @array.delete_at @cursor
    @cursor = 0 if @cursor >= @array.size

    move_cursor(m - 1)

    removed
  end

  private

  def move_cursor(m)
    m.times { step }
  end

  def step
    @cursor += 1
    @cursor = 0 if @cursor >= @array.size
    nil
  end
end

WELLINGTON = 13

def find_m_for(n)
  m = 1
  loop do
    districts = CircularArray.new(n) { |i| i + 1 }
    if n.times.map{ districts.remove_and_move(m) }.last != WELLINGTON
      m += 1
      next
    else
      break m
    end
  end
end

def execute
  results = {}
  13.upto(99) do |i|
    results[i] = find_m_for i
  end
  results
end
