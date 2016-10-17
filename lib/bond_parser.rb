require 'csv'
require_relative 'bond'

class BondParser
  CSV_READ_OPTIONS = {
    header_converters:  :symbol,
    headers:            true,
    skip_blanks:        true,
  }.freeze

  attr_reader :file_path

  def initialize(file_path:)
    fail(ArgumentError, "#{file_path} does not exist") unless FileTest.file?(file_path)
    @file_path = file_path
  end

  def parse
    CSV.foreach(file_path, **CSV_READ_OPTIONS).with_object([]) do |row, bonds|
      bonds << Bond.new(id: row[:bond], type: row[:type], term: row[:term], yield_spread: row[:yield])
    end
  end
end
