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
    #refactor to return false if
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

  def split_letter(coord_array)
    coord_array.map { |coord| coord.split('').shift }
  end

  def split_num(coord_array)
    coord_array.map { |coord| (coord.split('')[1]).to_i }
  end

  def consecutive_spaces?(coord_array)
    #refactor to shorten
    if split_letter(coord_array).all? { |letter| letter == split_letter(coord_array)[0] }
      if split_num(coord_array).each_cons(2).all? { |x, y| x == y - 1 }
        true
      else
        false
      end
    else
      if split_letter(coord_array).each_cons(2).all? { |x, y| x.ord == y.ord - 1 }
        if split_num(coord_array).all? { |num| num == split_num(coord_array)[0] }
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
      coord_array.each { |coord| @cells[coord].place_ship(ship)}
    end
  end

  def render_helper
     "  1 2 3 4 \nA #{@cells["A1"].render} #{@cells["A2"].render} #{@cells["A3"].render} #{@cells["A4"].render} \nB #{@cells["B1"].render} #{@cells["B2"].render} #{@cells["B3"].render} #{@cells["B4"].render} \nC #{@cells["C1"].render} #{@cells["C2"].render} #{@cells["C3"].render} #{@cells["C4"].render} \nD #{@cells["D1"].render} #{@cells["D2"].render} #{@cells["D3"].render} #{@cells["D4"].render} \n"
  end

  def render_true_helper
       "  1 2 3 4 \nA #{@cells["A1"].render(true)} #{@cells["A2"].render(true)} #{@cells["A3"].render(true)} #{@cells["A4"].render(true)} \nB #{@cells["B1"].render(true)} #{@cells["B2"].render(true)} #{@cells["B3"].render(true)} #{@cells["B4"].render(true)} \nC #{@cells["C1"].render(true)} #{@cells["C2"].render(true)} #{@cells["C3"].render(true)} #{@cells["C4"].render(true)} \nD #{@cells["D1"].render(true)} #{@cells["D2"].render(true)} #{@cells["D3"].render(true)} #{@cells["D4"].render(true)} \n"
  end

  def render(show_ship = false)
    unless show_ship == true
      return render_helper
    else
      return render_true_helper
    end
  end


end
