require 'bundler'
Bundler.require(:default)
require 'csv'
require_relative 'movie'
require_relative 'ranking'

CSV.foreach('../movies.csv', headers: true) do |movie|
  title = movie.delete 'title'
  rankings = []
  poster_url = nil
  movie.to_a.each_slice(3) do |(poster, place, score)|
    next if score[1].nil?
    poster_url = poster[1]
    source = place[0].split('_').first
    rankings << Ranking.new(score[1], place[1], source)
  end
  Movie.new title[1], poster_url, rankings
end

# binding.pry
ap Movie.summary

