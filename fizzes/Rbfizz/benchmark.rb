require 'benchmark'

LIMIT = 160_000
N_PARTS = 8
n = 20

require './basic'
require './cycling'
require './parallel'
require './single_if'

Benchmark.bmbm(9) do |b|
  b.report("Basic")     { n.times do ; Basic.run; end }
  b.report("Cycling")   { n.times do ; Cycling.run; end }
  b.report("Parallel")  { n.times do ; Parallel.run; end }
  b.report("SingleIf")  { n.times do ; SingleIf.run; end }
end
