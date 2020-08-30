require './lib/ship'
require './lib/board'
require './lib/message'

class Player
  attr_reader :board, :cruiser, :submarine, :message

  def initialize
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @message = Message.new
  end

  def ships_have_sunk?
    @cruiser.sunk? && @submarine.sunk?
  end

  def cpu_place_cruiser
    cpu_cruiser = @board.cells.keys.shuffle[0..2]
    if @board.valid_placement?(@cruiser, cpu_cruiser)
      @board.place(@cruiser, cpu_cruiser)
    else
      cpu_place_cruiser
    end
  end

  def cpu_place_sub
    cpu_sub = @board.cells.keys.shuffle[0..1]
    if @board.valid_placement?(@submarine, cpu_sub)
      @board.place(@submarine, cpu_sub)
    else
      cpu_place_sub
    end
  end

  def cpu_place_ships
    cpu_place_cruiser
    cpu_place_sub
  end

  def hooman_place_ships
    @message.hooman_instructions
    puts @board.render
    hooman_place_cruiser
    hooman_place_sub
  end

  def hooman_place_cruiser
    @message.hooman_cruiser_instructions

    cruiser_input = gets.chomp.upcase.split(" ")
    if @board.valid_placement?(@cruiser, cruiser_input)
      @board.place(@cruiser, cruiser_input)
      puts @board.render(true)
    else
      @message.invalid_coordinate_entry
      hooman_place_cruiser
    end
  end

  def hooman_place_sub
    @message.hooman_sub_instructions

    sub_input = gets.chomp.upcase.split(" ")
    if @board.valid_placement?(@submarine, sub_input)
      @board.place(@submarine, sub_input)
      puts @board.render(true)
    else
      @message.invalid_coordinate_entry
      hooman_place_sub
    end
  end

  def hooman_fires_shot
    @message.hooman_shot_coordinate_entry
    shot_input = gets.chomp.upcase
    cell_shot = @board.cells.fetch(shot_input) if @board.valid_coordinate?(shot_input)
    if cell_shot == nil
      @message.hooman_invalid_shot_entry
      hooman_fires_shot
    elsif cell_shot.shots_fired == 0
      cell_shot.fire_upon
      @message.hooman_shot_results(cell_shot)
    elsif cell_shot.shots_fired > 0
      cell_shot.fire_upon
      @message.hooman_shot_results(cell_shot)
      hooman_fires_shot
    end
  end

  def cpu_fires_zee_missle
    cpu_shot = @board.cells.keys.shuffle[3]
    cell_shot = @board.cells.fetch(cpu_shot) if @board.valid_coordinate?(cpu_shot)
    if cell_shot.shots_fired == 0
      cell_shot.fire_upon
      @message.cpu_shot_results(cell_shot)
    else
      cpu_fires_zee_missle
    end
  end


end
