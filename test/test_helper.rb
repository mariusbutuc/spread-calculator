require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!

require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov
