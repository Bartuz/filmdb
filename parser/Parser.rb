require 'open-uri'

class Parser

  def initialize(name:, url:, ranking_container:, poster_path:, title_path:, place_path:, score_path:)
    @name = name
    @url = url
    @ranking_container = ranking_container
    @poster_path = poster_path
    @title_path = title_path
    @place_path = place_path
    @score_path = score_path
    cache_web_page!
  end

  def cache_web_page!
    @page_results = Nokogiri::HTML(open(url)).css(ranking_container)
  end


  def parse!(limit = 100)
    @movies = Hash.new({})
    page_results[0...limit].each do |movie|
      title   = parse_title(movie)
      poster  = movie.at_css(poster_path)[:src]
      place   = movie.at_css(place_path).text.to_i
      score   = movie.at_css(score_path).text.to_f

      safe_title = title.gsub(/the/i,'').parameterize('_').to_sym

      movies[safe_title] = {
          title: title,
          ranking: {
              name.to_sym => {
                poster:   poster,
                place:    place,
                score:    score
              }
          }
      }
    end
    @movies
  end

  private

  def parse_title(movie)
    (url.include?('filmweb') && exists_translation?(movie)) ? movie.at_css(title_path).text : movie.at_css(title_path.gsub('.cap', 'a')).text
  end

  def exists_translation?(movie)
    !movie.at_css(title_path).nil?
  end

  attr_reader :url, :page_results, :ranking_container, :place_path, :score_path, :title_path, :name, :poster_path, :movies

end