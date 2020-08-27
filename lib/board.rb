class Board
  attr_reader :cells

  def initialize
    @cells = build_cells
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
    if ship.length != coord_array.length
      false
    elsif invalid_coord_array_input(coord_array)
      false 
    elsif coord_is_occupied(coord_array)
      false
    else
      consecutive_spaces?(coord_array)
    end
  end

  def consecutive_spaces?(coord_array)
    split_letter = coord_array.map { |coord| coord.split('').shift }
    split_num = coord_array.map { |coord| (coord.split('')[1]).to_i }
    if split_letter.all? { |letter| letter == split_letter[0] }
      if split_num.each_cons(2).all? { |x, y| x == y - 1 }
        true
      else
        false
      end
    else
      if split_letter.each_cons(2).all? { |x, y| x.ord == y.ord - 1 }
        if split_num.all? { |num| num == split_num[0] }
          true
        else
          false
        end
      else
        false
      end
    end
  end

  def invalid_coord_array_input(coord_array)
    coord_array.any? { |coord| !valid_coordinate?(coord)}
  end

  def coord_is_occupied(coord_array)
    coord_array.any? { |coord| @cells[coord].ship}
  end

  def place(ship, coord_array)
    if valid_placement?(ship, coord_array)
      coord_array.each do |coord|
        @cells[coord].place_ship(ship)
      end
    end
  end


end
