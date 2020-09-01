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
    letter_range = ("A"..(("A".ord) + (@board_size - 1)).chr).to_a

    letter_range.each do |letter|
      num_range.each do |num|
        coordinate =  letter + num.to_s
        cells[coordinate] = Cell.new(coordinate)
      end
    end
    cells
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
    "  " + (1..@board_size).to_a.map { |num| num.to_s.concat(" ") }.join
  end

  def board_groups
    (1..@board_size).to_a.map do |i|
      @cells.keys[((@board_size*i)-@board_size)..((@board_size*i)-1)]
    end
  end

  def rest_of_rows
    if @board_size >= 10
      board_groups.map do |group|
        run = 0
        "\n" + split_letter(group)[0] + " " +
        @cells.values_at(*group).map do |cell_object|
          run += 1
          cell_object.render +
          if run < 10
            " "
          else run >= 10
            "  "
          end
        end.join
      end
    else
      board_groups.map do |group|
        "\n" + split_letter(group)[0] + " " +
        @cells.values_at(*group).map { |cell_object| cell_object.render + " " }.join
      end
    end
  end

  def rest_of_rows_show_ship_true
    if @board_size >= 10
      board_groups.map do |group|
        run = 0
        "\n" + split_letter(group)[0] + " " +
        @cells.values_at(*group).map do |cell_object|
          run += 1
          cell_object.render(true) +
          if run < 10
            " "
          else run >= 10
            "  "
          end
        end.join
      end
    else
      board_groups.map do |group|
        "\n" + split_letter(group)[0] + " " +
        @cells.values_at(*group).map { |cell_object| cell_object.render(true) + " " }.join
      end
    end
  end

end
