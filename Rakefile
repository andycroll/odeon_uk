#!/usr/bin/env rake
require 'bundler/gem_tasks'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/odeon_uk'
  t.test_files = FileList[
    'test/lib/odeon_uk/*_test.rb',
    'test/lib/odeon_uk/api/*_test.rb',
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
task :fixtures do
  require 'odeon_uk'
  require_relative 'rake/fixture_creator'
  require 'fileutils'

  FixtureCreator::Api.new.app_init!
  FixtureCreator::Api.new.all_cinemas!
  FileUtils.rm FileList['test/fixtures/api/film_times/*.plist']
  FixtureCreator::Api.new.film_times!(71)
end

task default: :test
