require './lib/player'

class Turn
  attr_reader :hooman, :cpu

  def initialize
    @hooman = Player.new
    @cpu = Player.new
  end

  def game_turn
    display_boards
    hooman_fires_shot
    cpu_fires_zee_missle
  end

  def display_boards
    system "clear"
    puts "\n \n"
    puts "=============COMPUTER BOARD============="
    print @cpu.board.render
    puts "\n"
    puts "==============HOOMAN BOARD=============="
    print @hooman.board.render(true)
  end

  def hooman_shot_results(cell)
    shot_type = nil
    if cell.shots_fired > 1
      shot_type =  "failure. You already fired there. Try again \u{1f644}"
    elsif cell.render == "M"
      shot_type = "miss"
    elsif cell.render == "X"
      shot_type = "hit, the ship is sunk"
    elsif cell.render == "H"
      shot_type = "hit"
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
    shot_input = gets.strip.chomp.upcase
    until @board.valid_coordinate?(shot_input)
      print "Please enter a valid coordinate \n\u{1f644} "
      shot_input = gets.strip.chomp.upcase
    end
    cell_shot = @board.cells.fetch(shot_input)
    hooman_fires_duplicated_shot?(cell_shot)
    hooman_shot_results(cell_shot)
  end

  def hooman_fires_duplicated_shot?(cell_shot)
    if cell_shot.shots_fired > 0
      cell_shot.fire_upon
      hooman_shot_results(cell_shot)
      hooman_fires_shot
    else
      hooman_take_shot(cell_shot)
    end
  end

  def hooman_take_shot(cell_shot)
    cell_shot.fire_upon
  end

  def cpu_fires_zee_missle
    cell_shot = cpu_fire_helper
    cpu_shot_results(cell_shot)
    sleep(1)
  end

  def cpu_fire_helper
    cell_shot = pick_a_cell

    if cell_shot.shots_fired == 0
      cell_shot.fire_upon
      return cell_shot
    else
      pick_a_cell
    end
  end

  def pick_a_cell
    if find_cells_hit == []
      cpu_shot = @board.cells.keys.shuffle[0]
      until @board.valid_coordinate?(cpu_shot) && !@board.cells[cpu_shot].fired_upon?
        cpu_shot = @board.cells.keys.shuffle[0]
      end
    else
      generate_adjacent_cells(find_cells_hit).each do |coord|
        cpu_shot = coord if @board.valid_coordinate?(coord) && !@board.cells[coord].fired_upon?
      end
    end
    cell_shot = @board.cells.fetch(cpu_shot)
  end

  def find_cells_hit
    cpu_hits_cells = @board.cells.values.select do |cell|
      cell if cell.fired_upon? && cell.empty? == false && cell.ship.sunk? == false
    end
    cpu_hits_cells.map do |cell|
      @board.cells.key(cell)
    end
  end

  def generate_adjacent_cells(coord_array)
    coord_array.map do |coord|
      split_coord = coord.split('')
      ord_letter = split_coord.first.ord
      int_num = split_coord.last(split_coord.count-1).join.to_i
      letters = [ord_letter.chr, ord_letter.chr, (ord_letter - 1).chr, (ord_letter + 1).chr]
      numbers = [(int_num + 1).to_s, (int_num - 1).to_s, split_coord[1], split_coord[1]]
      letters.zip(numbers).map { |coords| coords.join }
    end.flatten
  end

end
