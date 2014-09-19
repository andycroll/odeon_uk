#!/usr/bin/env rake
require 'bundler/gem_tasks'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/odeon_uk'
  t.test_files = FileList[
    'test/lib/odeon_uk/*_test.rb',
    'test/lib/odeon_uk/internal/*_test.rb'
  ]
  t.verbose = true
end

end

task default: :test
