task :default => :euler

desc "Run Euler n-th problem or all"
task :euler, [:n] do |t, args|
  require_relative 'euler/problems'

  if args[:n]
    EulerProblem.list.fetch(Integer(args[:n])).go
  else
    EulerProblem.list.each_value(&:go)
  end
end
