require './lib/game'


play = $stdin.gets.chomp.downcase

if play == "p"
  start
elsif play == "q"
  exit
else
  puts "Do what?"
end
