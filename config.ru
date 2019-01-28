# frozen_string_literal: true

Dir.chdir(__dir__) unless Dir.getwd == __dir__
puts "Changed working directory to  #{__dir__}"

system('bundle install') unless system('bundle check')

require 'bundler'
Bundler.require

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'controller'

run ApplicationController
