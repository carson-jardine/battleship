require './lib/game'

puts "Welcome to BATTLESHIP"
puts "Enter p to play. Enter q to quit."
play = $stdin.gets.chomp.downcase

if play == "p"
  start
elsif play == "q"
  exit
else
  puts "Do what?"
end
