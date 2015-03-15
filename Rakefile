#!/usr/bin/env rake
require 'bundler/gem_tasks'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/odeon_uk'
  t.test_files = FileList[
    'test/lib/odeon_uk/*_test.rb',
    'test/lib/odeon_uk/api/*_test.rb',
    'test/lib/odeon_uk/html/*_test.rb',
    'test/lib/odeon_uk/html/parser/*_test.rb',
    'test/lib/odeon_uk/internal/*_test.rb'
  ]
  t.verbose = true
end

# http://erniemiller.org/2014/02/05/7-lines-every-gems-rakefile-should-have/
desc 'run gem console'
task :console do
  require 'irb'
  require 'irb/completion'
  require 'odeon_uk'
  ARGV.clear
  IRB.start
end

desc 'recreate test fixtures'
namespace :fixtures do
  require 'odeon_uk'
  require_relative 'rake/fixture_creator'

  desc 'html'
  task :html do
    FixtureCreator::Html.new(nil).sitemap!
    FixtureCreator::Html.new(71).cinema!        # brighton
    FixtureCreator::Html.new(211).cinema!       # bfi imax
    FixtureCreator::Html.new(105).cinema!       # leceister square
    FixtureCreator::Html.new(71).showtimes!
    FixtureCreator::Html.new(71).film_node!(0)
    FixtureCreator::Html.new(11).film_node!('imax')   # manchester imax
    FixtureCreator::Html.new(171).film_node!('d-box') # liverpool dbox
  end

  desc 'api'
  task :api do
    FixtureCreator::Api.new.app_init!
    FixtureCreator::Api.new.all_cinemas!
    FixtureCreator::Api.new.film_times!(71)
  end
end

task default: :test
