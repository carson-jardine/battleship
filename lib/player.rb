require './lib/ship'
require './lib/board'
require './lib/turn'

class Player
  attr_reader :board, :ships

  def initialize(game_ships = {'Submarine' => 2, 'Cruiser' =>3 }, board_size = 4)
    @board = Board.new(board_size)
    @ships = build_ships(game_ships)
  end

  def build_ships(game_ships)
    game_ships.map { |name, length| Ship.new(name, length) }
  end

  def cell_placement(ship, cons_nums, cons_letters)
    if @board.valid_placement?(ship, cons_nums)
      @board.place(ship, cons_nums)
    elsif @board.valid_placement?(ship, cons_letters)
      @board.place(ship, cons_letters)
    else
      setup_cpu_coords(ship)
    end
  end

  def setup_cpu_coords(ship)
    initial_cell = @board.cells.keys.shuffle[0].split('-')
    initial_letter = initial_cell.shift
    initial_number = initial_cell.last.to_i
    cons_nums = find_cons_nums(ship, initial_number, initial_letter)
    cons_letters = find_cons_letters(ship, initial_number, initial_letter)
    cell_placement(ship, cons_nums, cons_letters)
  end

  def find_cons_nums(ship, initial_number, initial_letter)
    num_range = (initial_number..(initial_number + (ship.length - 1))).to_a
    num_range.map { |num| initial_letter + "-" + num.to_s }
  end

  def find_cons_letters(ship, initial_number, initial_letter)
    ordinal_range = (initial_letter.ord..(initial_letter.ord + (ship.length - 1)))
    letter_range = ordinal_range.to_a.map {|ord_value| ord_value.chr}
    letter_range.map { |letter| letter + "-" + initial_number.to_s }
  end

  def cpu_place_ships
    @ships.each {|ship| setup_cpu_coords(ship)}
  end

  def ships_have_sunk?
    @ships.all? {|ship| ship.sunk?}
  end

  def hooman_place_ships
    puts "I have laid out my ships on the grid. \nYou now need to lay out your ships. \n"
    puts @board.render
    place_ship_input
    puts @board.render(true)
  end

  def coord_letter(coord)
    if coord.include?("-")
      split_coord = coord.split('-')
      split_coord.first.upcase
    else
      split_coord = coord.split('')
      letters = []
      split_coord.each do |character|
        if !(48 .. 57).include?(character.ord)
          letters << character
        end
      end
      letters.join.upcase
    end

  end

  def coord_num(coord)
    if coord.include?("-")
      split_coord = coord.split('-')
      split_coord.last.to_i
    else
      split_coord = coord.split('')
      nums = []
      split_coord.each do |character|
        if (48 .. 57).include?(character.ord)
          nums << character
        end
      end
      nums.join.to_i
    end
  end

  def convert_input_coords(user_input)
    initial = user_input.split(" ")
    initial.map do |coord|
      coord_letter(coord) + "-" + coord_num(coord).to_s
    end
  end

  def place_ship_input
    @ships.each do |ship|
      print "Enter the squares for the #{ship.name} (#{ship.length.to_s} spaces): \n> "
      user_input = convert_input_coords(gets.strip.chomp)
      until @board.valid_placement?(ship, user_input)
        print "Those are invalid coordinates. Please try again. \n\u{1f644} "
        user_input = convert_input_coords(gets.strip.chomp)
      end
      hooman_cell_placement(ship, user_input)
    end
  end

  def hooman_cell_placement(ship = Ship.new("Cruiser", 3), user_input = ["A-1", "A-2", "A-3"])
    @board.place(ship, user_input)
  end
end
