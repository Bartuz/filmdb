require 'csv'

class CSVExporter

  FIELDS_TO_EXPORT = %w(poster place score).freeze

  def initialize(file_name, movies)
    @file_name = file_name
    @movies = movies
    generate_csv_headers!
  end

  def export!
    CSV.open( "../#{@file_name}", 'w') do |writer|

      writer << headers
      movies.each do |key, details|
        row = [details[:title]]
        headers[1..-1].each_slice(3) do |fields|
          ranking = fields.first.split('_').first.to_sym
          if details[:ranking][ranking].is_a? Hash
            fields.map do |field|
              row << details[:ranking][ranking][field.remove("#{ranking}_").to_sym]
            end
          else
            row += [nil, nil, nil]
          end
        end
        writer << row
      end
    end
  end

  private

  def generate_csv_headers!
    @headers = rankings_names.map do |ranking|
      FIELDS_TO_EXPORT.map do |category|
        "#{ranking}_#{category}"
      end
    end
    @headers.unshift('title').flatten!
  end

  def rankings_names
    rankings = movies.map { |movie| movie[1][:ranking].keys }
    rankings.flatten.uniq
  end

  attr_reader :movies, :headers

end