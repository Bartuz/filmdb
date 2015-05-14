require 'bundler'
Bundler.require(:default)
require 'active_support/core_ext/string'
require 'active_support/core_ext/hash'

require_relative 'Parser'
require_relative 'csv_exporter'

imdb = Parser.new(
                 name: 'imdb',
                 url: 'imdb.html',
                 ranking_container: '#main > div > div.lister > table > tbody > tr',
                 poster_path: '.posterColumn > a > img',
                 place_path: '.titleColumn > span',
                 title_path: '.titleColumn > a',
                 score_path: '.imdbRating > strong'
)

filmweb = Parser.new(
    name: 'filmweb',
    url: 'filmweb.html',
    ranking_container: '.rankingTable > tbody > tr',
    poster_path: '.filmPosterParent > a > img',
    place_path: '.text-big.firstCol > .rankingPosition',
    title_path: '.place > div > .cap',
    score_path: '.place .s-16.vertical-align'
)

movies = imdb.parse!

movies.deep_merge! filmweb.parse!

exporter = CSVExporter.new('movies.csv', movies)

exporter.export!


