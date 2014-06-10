require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: ruby appraise.rb -v <integer> -b <integer> [optional: -r integer -e boolean]"

  opts.on("-v", "--value VALUE", "actual value of the item") do |v|
    options[:val] = v.to_i
  end

  opts.on("-b", "--bonus BONUS", "PC's bonus to Appraise") do |b|
    options[:bonus] = b.to_i
  end

  opts.on("-r", "--round ROUND", "Optional, round to this many digits. Default to 1 (nearest 10)") do |r|
    options[:round] = -(r).to_i
  end

  opts.on "-e", "--estimate ESTIMATE", "Optional, allow estimates above actual item value. Default to true" do |e|
    options[:estimate] = e
  end
end.parse!

if options[:val].nil? || options[:bonus].nil?
  exec 'ruby appraise.rb -h'
  exit
end

options[:round] ||= 1
options[:estimate] ||= "true"
roll = (1 + rand(20))
  
puts "PC rolls 1d20+#{options[:bonus]}: #{roll}+#{options[:bonus]} = #{roll+options[:bonus]}"
puts "Results:"

if roll+options[:bonus] >= 25
  puts "  PC appraises correct value of #{options[:val]} and determines if the item has magic properties."
elsif roll+options[:bonus] >= 20
  puts "  PC appraises correct value of #{options[:val]}."
elsif roll+options[:bonus] >= 15
  low = (options[:val] - (options[:val] * 0.2)).to_i
  if options[:estimate] == "true"
    high = (options[:val] + (options[:val] * 0.2)).to_i
    guess = (low..high).to_a.sample
  else
    guess = (low..options[:val]).to_a.sample
  end
  puts "  PC guesses value within 20% to be #{guess.round(options[:round])}."
else
  pct = (50..100).to_a.sample
  low = (options[:val] - (options[:val] * (pct / 100.0))).to_i
  if options[:estimate] == "true"
    high = (options[:val] + (options[:val] * (pct / 100.0))).to_i
    guess = (low..high).to_a.sample
  else
    guess = (low..options[:val]).to_a.sample
  end
  puts "  PC guesses value within #{pct}% to be #{guess.round(options[:round])}."
end
