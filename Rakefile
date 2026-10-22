#!/usr/bin/env rake
require 'bundler/gem_tasks'

require 'rake/testtask'
require 'cinebase/vista/package_task'

Cinebase::Vista::PackageTask.new('odeon_uk.gemspec', root: __dir__)

Rake::TestTask.new do |t|
  t.libs << 'lib/odeon_uk'
  t.test_files = FileList[
    'test/lib/odeon_uk/*_test.rb',
    'test/lib/odeon_uk/internal/*_test.rb',
    'test/lib/odeon_uk/internal/parser/api/*_test.rb'
  ]
  t.verbose = true
end

Rake::TestTask.new do |t|
  t.libs << 'lib/odeon_uk'
  t.name = :live
  t.test_files = FileList[
    'test/live/*_test.rb'
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

task default: :test
