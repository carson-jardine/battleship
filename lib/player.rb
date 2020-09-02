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

  # def hooman_shot_results(cell)
  #   shot_type = nil
  #   if cell.shots_fired > 1
  #     shot_type =  "failure. You already fired there. Try again \u{1f644}"
  #   elsif cell.render == "M"
  #     shot_type = "miss"
  #   elsif cell.render == "X"
  #     shot_type = "hit, the ship is sunk"
  #   elsif cell.render == "H"
  #     shot_type = "hit"
  #   end
  #   puts "Your shot on #{cell.coordinate} was a #{shot_type}."
  # end
  #
  # def cpu_shot_results(cell)
  #   shot_type = nil
  #   if cell.render == "M"
  #     shot_type = "miss"
  #   elsif cell.render == "X"
  #     shot_type = "hit, the ship is sunk"
  #   elsif cell.render == "H"
  #     shot_type = "hit"
  #   else
  #     shot_type = "WTF PPL"
  #   end
  #   puts "My shot on #{cell.coordinate} was a #{shot_type}."
  # end
  #
  # def hooman_fires_shot
  #   print "Enter the coordinate for your shot: \n> "
  #   shot_input = convert_input_coords(gets.strip.chomp)[0]
  #   until @board.valid_coordinate?(shot_input)
  #     print "Please enter a valid coordinate \n\u{1f644} "
  #     shot_input = convert_input_coords(gets.strip.chomp)[0]
  #   end
  #   cell_shot = @board.cells.fetch(shot_input)
  #   hooman_fires_duplicated_shot?(cell_shot)
  #   hooman_shot_results(cell_shot)
  # end
  #
  # def hooman_fires_duplicated_shot?(cell_shot)
  #   if cell_shot.shots_fired > 0
  #     cell_shot.fire_upon
  #     hooman_shot_results(cell_shot)
  #     hooman_fires_shot
  #   else
  #     hooman_take_shot(cell_shot)
  #   end
  # end
  #
  # def hooman_take_shot(cell_shot)
  #     cell_shot.fire_upon
  # end
  #
  # def cpu_fires_zee_missle
  #   cell_shot = cpu_fire_helper
  #   cpu_shot_results(cell_shot)
  #   sleep(1)
  # end
  #
  # def cpu_fire_helper
  #   cell_shot = pick_a_cell
  #
  #   if cell_shot.shots_fired == 0
  #     cell_shot.fire_upon
  #     return cell_shot
  #   else
  #     pick_a_cell
  #   end
  # end
  #
  # def pick_a_cell
  #   if find_cells_hit == []
  #     cpu_shot = @board.cells.keys.shuffle[0]
  #     until @board.valid_coordinate?(cpu_shot) && !@board.cells[cpu_shot].fired_upon?
  #       cpu_shot = @board.cells.keys.shuffle[0]
  #     end
  #   else
  #     generate_adjacent_cells(find_cells_hit).each do |coord|
  #       cpu_shot = coord if @board.valid_coordinate?(coord) && !@board.cells[coord].fired_upon?
  #     end
  #   end
  #     cell_shot = @board.cells.fetch(cpu_shot)
  # end
  #
  # def find_cells_hit
  #   cpu_hits_cells = @board.cells.values.select do |cell|
  #     cell if cell.fired_upon? && cell.empty? == false && cell.ship.sunk? == false
  #   end
  #   cpu_hits_cells.map do |cell|
  #     @board.cells.key(cell)
  #   end
  # end
  #
  # def generate_adjactent_letters(coord)
  #   ord_letter_array = coord_letter(coord).split('').map { |letter| letter.ord }
  #   same_double = ord_letter_array.map { |ord| ord.chr }.join
  #   if ord_letter_array[0] == 90 && ord_letter_array.count == 1
  #     letters = [ord_letter_array[0].chr, ord_letter_array[0].chr, (ord_letter_array[0] - 1).chr, "AA"]
  #   elsif ord_letter_array.count == 1
  #     letters = [ord_letter_array[0].chr, ord_letter_array[0].chr, (ord_letter_array[0] - 1).chr, (ord_letter_array[0] + 1).chr]
  #   elsif ord_letter_array[0] == 65 && ord_letter_array[1] == 65
  #     plus_one = [ord_letter_array[0].chr, (ord_letter_array[1] + 1).chr].join
  #     letters = [same_double, same_double, "Z", plus_one]
  #   elsif ord_letter_array[1] == 90
  #     plus_one = [(ord_letter_array[0] + 1).chr, "A"].join
  #     minus_one = [ord_letter_array[0].chr, (ord_letter_array[1] - 1).chr].join
  #     letters = [same_double, same_double, minus_one, plus_one]
  #   elsif ord_letter_array[1] == 65
  #     plus_one = [ord_letter_array[0].chr, (ord_letter_array[1] + 1).chr].join
  #     minus_one = [(ord_letter_array[0] + 1).chr, "Z".chr].join
  #     letters = [same_double, same_double, minus_one, plus_one]
  #   else
  #     plus_one = [ord_letter_array[0].chr, (ord_letter_array[1] + 1).chr].join
  #     minus_one = [ord_letter_array[0].chr, (ord_letter_array[1] - 1).chr].join
  #     letters = [same_double, same_double, minus_one, plus_one]
  #   end
  #   letters
  # end
  #
  # def generate_adjacent_cells(coord_array)
  #   coord_array.map do |coord|
  #     int_num = coord_num(coord)
  #     numbers = [(int_num + 1).to_s, (int_num - 1).to_s, int_num, int_num]
  #     dashes = ["-", "-", "-", "-"]
  #     generate_adjactent_letters(coord).zip(dashes, numbers).map { |coords| coords.join }
  #   end.flatten
  # end

end
