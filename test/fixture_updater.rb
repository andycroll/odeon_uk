require File.expand_path('../../lib/odeon_uk.rb', __FILE__)

def fixture(name)
  File.expand_path("../fixtures/html/#{name}.html", __FILE__)
end

File.open(fixture('sitemap'), 'w+') do |file|
  puts '* Sitemap'
  file.write OdeonUk::Html::Website.new.sitemap
end

# BRIGHTON

File.open(fixture('cinema/brighton'), 'w+') do |file|
  puts '* Brighton Cinema'
  file.write OdeonUk::Html::Website.new.cinema(71)
end

File.open(fixture('showtimes/brighton'), 'w+') do |file|
  puts '* Brighton Showtimes'
  file.write OdeonUk::Html::Website.new.showtimes(71)
end

parser = OdeonUk::Html::Parser::ShowtimesPage.new(71)

File.open(fixture('showtimes/brighton/film_first'), 'w+') do |file|
  puts '* Brighton Film First'
  file.write parser.to_a.map(&:to_s)[0]
end

File.open(fixture('showtimes/brighton/film_last'), 'w+') do |file|
  puts '* Brighton Film Last'
  file.write parser.to_a.map(&:to_s)[-1]
end

# Manchester IMAX

parser          = OdeonUk::Html::Parser::ShowtimesPage.new(11)
imax_screenings = parser.to_a.map(&:to_s).select do |text|
  text.match 'imax'
end

File.open(fixture('showtimes/manchester/film_first_imax'), 'w+') do |file|
  puts '* Manchester Film First IMAX'
  file.write imax_screenings[0]
end

# Liverpool ONE

parser          = OdeonUk::Html::Parser::ShowtimesPage.new(171)
dbox_screenings = parser.to_a.map(&:to_s).select do |text|
  text.match 'D-Box'
end

File.open(fixture('showtimes/liverpool_one/film_first_dbox'), 'w+') do |file|
  puts '* Liverpool ONE Film First D-BOX'
  file.write dbox_screenings[0]
end

# London BFI IMAX

File.open(fixture('cinema/bfi_imax'), 'w+') do |file|
  puts '* BFI IMAX Cinema'
  file.write OdeonUk::Html::Website.new.cinema(211)
end

# London Leicester Square

File.open(fixture('cinema/leicester_square'), 'w+') do |file|
  puts '* Leceister Square Cinema'
  file.write OdeonUk::Html::Website.new.cinema(105)
end
