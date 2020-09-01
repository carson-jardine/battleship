def set_custom_ships
  puts "Hokay, now it's time to build some ships"
  @ships.clear
  print "How many ships would you like to have? \n> "
  ship_count = gets.chomp.to_i

  loop_counter = 1
  loop do
      print "What would you like ship number #{loop_counter.to_s} to be called? \n> "
      ship_name = gets.chomp.capitalize

      print "How long do you want #{ship_name} to be? Please enter a number less than #{@board_size.to_s} \n> "
      ship_length = gets.chomp.to_i

     until ship_length <= @board_size
       print "I told you LESS than #{@board_size.to_s}. Try again  \n> "
       ship_length = gets.chomp.to_i
     end
     loop_counter += 1
     if (loop_counter - 1) == ship_count
       break
     end

 end
 @ships[ship_name] = ship_length
 p @ships
end
