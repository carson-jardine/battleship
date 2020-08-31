require './lib/ship'
require './lib/board'

class Player
  attr_reader :board, :cruiser, :submarine, :ships

  def initialize
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @ships = [@cruiser, @submarine]
  end


  def cell_placement(ship)
    cons_num_place = setup_cpu_coords(ship)[0]
    cons_letter_place = setup_cpu_coords(ship)[1]

    if @board.valid_placement?(ship, cons_num_place)
      @board.place(ship, cons_num_place)
    elsif @board.valid_placement?(ship, cons_letter_place)
      @board.place(ship, cons_letter_place)
    else
      cell_placement(ship)
    end
  end

  def setup_cpu_coords(ship)
    initial_cell = @board.cells.keys.shuffle[0]
    initial_letter = initial_cell.split('').shift
    initial_number = initial_cell.split('')[1].to_i
    num_range = (initial_number..initial_number + (ship.length - 1)).to_a
    cons_num_place = num_range.map { |num| initial_letter + num.to_s }
    ordinal_range = (initial_letter.ord..(initial_letter.ord + (ship.length - 1)))
    letter_range = ordinal_range.to_a.map {|ord_value| ord_value.chr}
    cons_letter_place = letter_range.map { |letter| letter + initial_number.to_s }
    return cons_num_place, cons_letter_place
  end

  def cpu_place_ships
    @ships.each {|ship| cell_placement(ship)}
  end

  def ships_have_sunk?
    @cruiser.sunk? && @submarine.sunk?
  end

  def hooman_place_ships
    puts "I have laid out my ships on the grid. \nYou now need to lay out your two ships. \nThe Cruiser is three units long and the Submarine is two units long.\n"
    puts @board.render
    @ships.each do |ship|
      print "Enter the squares for the #{ship.name} (#{ship.length.to_s} spaces): \n> "
      user_input = gets.chomp.upcase.split(" ")
      hooman_cell_placement(ship, user_input)
    end
  end

  def hooman_cell_placement(ship, user_input)
    if @board.valid_placement?(ship, user_input)
      @board.place(ship, user_input)
      puts @board.render(true)
    else
      print "Those are invalid coordinates. Please try again. \n>"
      user_input = gets.chomp.upcase.split(" ")
      hooman_cell_placement(ship, user_input)
    end
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
    puts "Your shot on #{cell.coordinate} was a #{shot_type}."
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
    puts "My shot on #{cell.coordinate} was a #{shot_type}."
  end

  def hooman_fires_shot
    print "Enter the coordinate for your shot: \n> "
    shot_input = gets.chomp.upcase
    cell_shot = @board.cells.fetch(shot_input) if @board.valid_coordinate?(shot_input)
    if cell_shot == nil
      puts "Please enter a valid coordinate."
      hooman_fires_shot
    elsif cell_shot.shots_fired == 0
      cell_shot.fire_upon
      hooman_shot_results(cell_shot)
    elsif cell_shot.shots_fired > 0
      cell_shot.fire_upon
      hooman_shot_results(cell_shot)
      hooman_fires_shot
    end
  end

  def cpu_fires_zee_missle
    cpu_shot = @board.cells.keys.shuffle[3]
    cell_shot = @board.cells.fetch(cpu_shot) if @board.valid_coordinate?(cpu_shot)
    if cell_shot.shots_fired == 0
      cell_shot.fire_upon
      cpu_shot_results(cell_shot)
    else
      cpu_fires_zee_missle
    end
  end


end
