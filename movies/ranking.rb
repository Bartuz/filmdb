class Ranking

  attr_reader :source, :score, :place

  include Comparable

  def initialize(score, place, source = 'Calculated')
    @source = source
    @place  = place
    @score  = score
  end

  def <=>(ranking)
    [place, 1/score] <=> [ranking.place, 1/ranking.score]
  end

  def to_s
    "#{source} on place #{place}. and with score #{score}"
  end

end