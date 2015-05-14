class Movie

  attr_reader :title, :poster, :external_rankings, :internal_ranking

  include Comparable

  @@all_movies = []

  def initialize(title, poster, rankings)
    @title              = title
    @poster             = poster
    @external_rankings  = rankings
    calculate_internal_ranking! unless rankings.empty?
    @@all_movies << self
  end

  def <=>(movie)
    internal_ranking <=> movie.internal_ranking
  end

  def calculate_internal_ranking!
    external_rankings_size =  external_rankings.size
    score = external_rankings.map(&:score).map(&:to_f).inject(0,&:+) / external_rankings_size
    place = external_rankings.map(&:place).map(&:to_i).inject(0,&:+) / external_rankings_size
    @internal_ranking = Ranking.new(score, place)
  end

  def to_s
    "#{place}. (#{friendly_place_change}) #{title} - Based on: #{internal_ranking}"
  end

  def self.summary
    @@all_movies.sort!.each_with_index do |movie, index|
      movie.send(:place=, index + 1)
    end
    @@all_movies.map(&:to_s)
  end

  private 

  def place_change
    @place_change ||= place ? -place + internal_ranking.place : nil
  end

  def friendly_place_change
     "#{place_change_indicator} #{place_change.abs}"  
  end

  def place_change_indicator
    case place_change <=> 0
    when 0 then '='
    when 1 then '↑'
    when -1 then '↓'
    end
  end

  attr_accessor :place

end