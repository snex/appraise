if ARGV[0].nil? || ARGV[1].nil?
  puts "Usage: ruby appraise.rb <val> <bonus>"
  puts "<val> - actual value of the item"
  puts "<bonus> - PC's bonus to Appraise"
  puts "<round> - Optional, round to this many digits. Default to 1 (nearest 10)."
  puts "<allow estimates above value> Optional, allow estimates above actual item value. Default to true."
  exit
end

val = ARGV[0].to_i
bonus = ARGV[1].to_i
round = -(ARGV[2] || 1).to_i
estimate = (ARGV[2] && ["true", "false"].include?(ARGV[2].downcase) ? ARGV[2] : ARGV[3]) || "true"

roll = (1 + rand(20))
puts "PC rolls 1d20+#{bonus}: #{roll}+#{bonus} = #{roll+bonus}"
puts "Results:"

if roll+bonus >= 25
  puts "  PC appraises correct value of #{val} and determines if the item has magic properties."
elsif roll+bonus >= 20
  puts "  PC appraises correct value of #{val}."
elsif roll+bonus >= 15
  low = (val - (val * 0.2)).to_i
  if estimate == "true"
    high = (val + (val * 0.2)).to_i
    guess = (low..high).to_a.sample
  else
    guess = (low..val).to_a.sample
  end
  puts "  PC guesses value within 20% to be #{guess.round(round)}."
else
  pct = (50..100).to_a.sample
  low = (val - (val * (pct / 100.0))).to_i
  if estimate == "true"
    high = (val + (val * (pct / 100.0))).to_i
    guess = (low..high).to_a.sample
  else
    guess = (low..val).to_a.sample
  end
  puts "  PC guesses value within #{pct}% to be #{guess.round(round)}."
end
