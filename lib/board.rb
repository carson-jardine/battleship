require './lib/cell'

class Board
  attr_reader :cells

  def initialize(board_size = 4)
    @board_size = board_size
    @cells = build_cells
  end

  def build_cells
    cells = {}
    num_range = (1..@board_size).to_a

    moar_letters.each do |letter|
      num_range.each do |num|
        coordinate = letter + "-" + num.to_s
        cells[coordinate] = Cell.new(coordinate)
      end
    end
    cells
  end

  def make_letters(set)
    if @board_size - (26 * (set-1)) > 26
      remainder = 26
    else
      remainder = @board_size - (26 * (set-1))
    end
    ("A"..(("A".ord) + (remainder - 1)).chr).to_a
  end

  def moar_letters
    alpha_array = ("A".."Z").to_a
    rounds_needed = (@board_size / 26.0).ceil
    letters = []
    (1..rounds_needed).to_a.each do |set|
      if set == 1
        letters << make_letters(set)
      elsif set > 1
        make_letters(set).each do |second_letter|
          letters << (alpha_array[set - 2] + second_letter)
        end
      end
    end
    letters.flatten
  end

  def valid_coordinate?(cell)
    @cells.keys.include?(cell)
  end

  def valid_placement?(ship, coord_array)
    return false if ship.length != coord_array.length
    return false if invalid_coord_array_input(coord_array)
    return false if coord_is_occupied(coord_array)
    consecutive_spaces?(coord_array)
  end

  def split_letter(coord_array)
    coord_array.map { |coord| coord.split('-').shift }
  end

  def split_num(coord_array)
    coord_array.map { |coord| (coord.split('-')[1]).to_i }
  end

  def same_letter_cons_num?(coord_array)
    first_letter = split_letter(coord_array)[0]
    same_letter = split_letter(coord_array).all? { |letter| letter == first_letter }
    cons_num = split_num(coord_array).each_cons(2).all? { |x, y| x == y - 1 }
    same_letter && cons_num
  end

  def same_num_cons_letter?(coord_array)
    first_num = split_num(coord_array)[0]
    same_num = split_num(coord_array).all? { |num| num == first_num }
    cons_letter = split_letter(coord_array).each_cons(2).all? do |x, y|
      moar_letters.find_index(x) == moar_letters.find_index(y) - 1
    end
    same_num && cons_letter
  end

  def consecutive_spaces?(coord_array)
    same_letter_cons_num?(coord_array) || same_num_cons_letter?(coord_array)
  end

  def invalid_coord_array_input(coord_array)
    coord_array.any? { |coord| !valid_coordinate?(coord)}
  end

  def coord_is_occupied(coord_array)
    coord_array.any? { |coord| @cells[coord].ship}
  end

  def place(ship, coord_array)
    if valid_placement?(ship, coord_array)
      coord_array.each { |coord| @cells[coord].place_ship(ship)}
    end
  end

  def render(show_ship = false)
    unless show_ship == true
      return row_1_render + rest_of_rows.join + "\n"
    else
      return row_1_render + rest_of_rows_show_ship_true.join + "\n"
    end
  end

  def row_1_render
    "  " + (1..@board_size).to_a.map { |num| num.to_s.concat(" ") }.join
  end

  def board_groups
    (1..@board_size).to_a.map do |i|
      @cells.keys[((@board_size*i)-@board_size)..((@board_size*i)-1)]
    end
  end

  def rest_of_rows
    if @board_size >= 27
      board_spacing_greater_26
    elsif @board_size > 10
      board_spacing_greater_10
    else
      board_spacing
    end
  end

  def board_spacing
    board_groups.map do |group|
      "\n" + split_letter(group)[0] + " " +
      @cells.values_at(*group).map { |cell_object| cell_object.render + " " }.join
    end
  end

  def board_spacing_true
    board_groups.map do |group|
      "\n" + split_letter(group)[0] + " " +
      @cells.values_at(*group).map { |cell_object| cell_object.render(true) + " " }.join
    end
  end

  def double_letter_spacing(group)
    if split_letter(group)[0].length == 1
      "  "
    else
      " "
    end
  end

  def double_number_spacing(run)
    if run < 10
      " "
    else run >= 10
      "  "
    end
  end

  def board_spacing_greater_26
    board_groups.map do |group|
      run = 0
      "\n" + split_letter(group)[0] + double_letter_spacing(group) +
      @cells.values_at(*group).map do |cell_object|
        run += 1
        cell_object.render + double_number_spacing(run)
      end.join
    end
  end

  def board_spacing_greater_26_true
    board_groups.map do |group|
      run = 0
      "\n" + split_letter(group)[0] + double_letter_spacing(group) +
      @cells.values_at(*group).map do |cell_object|
        run += 1
        cell_object.render(true) + double_number_spacing(run)
      end.join
    end
  end

  def board_spacing_greater_10
    board_groups.map do |group|
      run = 0
      "\n" + split_letter(group)[0] + " " +
      @cells.values_at(*group).map do |cell_object|
        run += 1
        cell_object.render + double_number_spacing(run)
      end.join
    end
  end

  def board_spacing_greater_10_true
    board_groups.map do |group|
      run = 0
      "\n" + split_letter(group)[0] + " " +
      @cells.values_at(*group).map do |cell_object|
        run += 1
        cell_object.render(true) + double_number_spacing(run)
      end.join
    end
  end

  def rest_of_rows_show_ship_true
    if @board_size >= 27
      board_spacing_greater_26_true
    elsif @board_size > 10
      board_spacing_greater_10_true
    else
      board_spacing_true
    end
  end

end
