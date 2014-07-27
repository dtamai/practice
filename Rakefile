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

desc "Run Kata n-th problem or all"
task :kata, [:n] do |t, args|
  if args[:n]
    fname = './kata/%02d.rb' % Integer(args[:n])
    load fname
  else
    TODO implement
  end
end
