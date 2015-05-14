#!/bin/rake

task default: %w[generate_rankig]

task :generate_rankig do
  cd 'parser'
  puts "--- SCRAPPING DATA FROM FILMWEB & IMDB"
  ruby 'runner.rb'
  cd '../movies'
  puts "--- GENERATING NEW RATING"
  ruby 'runner.rb'

  "FINISHED:"
end