class Cell
  attr_reader :coordinate, :ship, :shots_fired

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
    @shots_fired = 0
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
    @shots_fired += 1
  end

  def render(show_ship = false)
    if fired_upon? && empty?
      "M"
    elsif fired_upon? && ship.sunk?
      "X"
    elsif fired_upon? && !empty?
      "H"
    elsif show_ship == true && !empty?
      "S"
    else
      '.'
    end
  end

end
