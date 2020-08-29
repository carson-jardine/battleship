class Message

  def initialize

  end

  def main_menu
    print "Welcome to BATTLESHIP \nEnter p to play. Enter q to quit. \n> "
  end

  def hooman_instructions
    p "I have laid out my ships on the grid. \n
    You now need to lay out your two ships. \n
    The Cruiser is three units long and the Submarine is two units long."
  end

  def hooman_cruiser_instructions
    p "Enter the squares for the Cruiser (3 spaces): \n> "
  end

  def hooman_sub_instructions
    p "Enter the squares for the Submarine (2 spaces): \n> "
  end

  def invalid_coordinate_entry
    p "Those are invalid coordinates. Please try again: \n> "
  end

  def hooman_shot_coordinate_entry
    p "Enter the coordinate for your shot: \n> "
  end

  def hooman_valid_shot_entry
    p "Please enter a valid coordinate: \n> "
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
      p "Your shot on #{cell.coordinate} was a #{shot_type}."
  end

  def hooman_wins
      p "You won!"
  end

  def cpu_wins
      p "I won!"
  end

end
