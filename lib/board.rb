require './lib/cell'

class Board
  attr_reader :cells

  def initialize
    @cells = build_cells
    @num_count = 4
    @letter_count = 4
  end

  def build_cells
    @cells = {
      "A1" => Cell.new("A1"),
      "A2" => Cell.new("A2"),
      "A3" => Cell.new("A3"),
      "A4" => Cell.new("A4"),
      "B1" => Cell.new("B1"),
      "B2" => Cell.new("B2"),
      "B3" => Cell.new("B3"),
      "B4" => Cell.new("B4"),
      "C1" => Cell.new("C1"),
      "C2" => Cell.new("C2"),
      "C3" => Cell.new("C3"),
      "C4" => Cell.new("C4"),
      "D1" => Cell.new("D1"),
      "D2" => Cell.new("D2"),
      "D3" => Cell.new("D3"),
      "D4" => Cell.new("D4")
    }
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
    coord_array.map { |coord| coord.split('').shift }
  end

  def split_num(coord_array)
    coord_array.map { |coord| (coord.split('')[1]).to_i }
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
    cons_letter = split_letter(coord_array).each_cons(2).all? { |x, y| x.ord == y.ord - 1 }
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
    "  " + (1..@num_count).to_a.map { |num| num.to_s.concat(" ") }.join
  end

  def board_groups
    (1..@letter_count).to_a.map do |i|
      @cells.keys[((@num_count*i)-@num_count)..((@num_count*i)-1)]
    end
  end

  def rest_of_rows
    board_groups.map do |group|
      "\n" + split_letter(group)[0] + " " +
      @cells.values_at(*group).map { |cell_object| cell_object.render + " " }.join
    end
  end

  def rest_of_rows_show_ship_true
    board_groups.map do |group|
      "\n" + split_letter(group)[0] + " " +
      @cells.values_at(*group).map { |cell_object| cell_object.render(true) + " " }.join
    end
  end

end
