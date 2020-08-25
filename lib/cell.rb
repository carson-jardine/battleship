class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
     ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    @ship.hit if !empty?
    @fired_upon = true     
  end

  def render(show_ship = false)
    if fired_upon? && empty?
      "M"
    elsif fired_upon? && !empty?
      "H"
    elsif fired_upon? && @ship.sunk?
      "X"
    elsif show_ship == true
      "S"
    else
      '.'
    end
  end

end
