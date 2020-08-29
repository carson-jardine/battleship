class Message

  def initialize

  end

  def main_menu
    statement = "Welcome to BATTLESHIP \nEnter p to play. Enter q to quit. \n> "
    puts statement
    statement
  end

  def hooman_instructions
    statement = "I have laid out my ships on the grid. \n
    You now need to lay out your two ships. \n
    The Cruiser is three units long and the Submarine is two units long."
    puts statement
    statement
  end

  def hooman_cruiser_instructions
    statement = "Enter the squares for the Cruiser (3 spaces): \n> "
    puts statement
    statement
  end

  def hooman_sub_instructions
    statement = "Enter the squares for the Submarine (2 spaces): \n> "
    puts statement
    statement
  end

  def invalid_coordinate_entry
    statement = "Those are invalid coordinates. Please try again."
    puts statement
    statement
  end

  def hooman_shot_coordinate_entry
    statement = "Enter the coordinate for your shot: \n> "
    puts statement
    statement
  end

  def hooman_invalid_shot_entry
    statement = "Please enter a valid coordinate."
    puts statement
    statement
  end

  def hooman_shot_results(cell)
    shot_type = nil
    if cell.shots_fired > 1
      shot_type =  "failure. You already fired there. Try again"
    elsif cell.render == "M"
      shot_type = "miss"
    elsif cell.render == "X"
      shot_type = "hit, the ship is sunk"
    elsif cell.render == "H"
      shot_type = "hit"
    else
      shot_type = "WTF PPL"
    end
      statement = "Your shot on #{cell.coordinate} was a #{shot_type}."
      puts statement
      statement
  end

  def cpu_shot_results(cell)
    shot_type = nil
    if cell.render == "M"
      shot_type = "miss"
    elsif cell.render == "X"
      shot_type = "hit, the ship is sunk"
    elsif cell.render == "H"
      shot_type = "hit"
    else
      shot_type = "WTF PPL"
    end
      statement = "My shot on #{cell.coordinate} was a #{shot_type}."
      puts statement
      statement
  end

  def hooman_wins
      statement = "You won!"
      puts statement
      statement
  end

  def cpu_wins
      statement = "I won!"
      puts statement
      statement
  end

end
