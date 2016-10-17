require_relative 'test_helper'
require_relative '../lib/bond_parser'

class BondParserTest < Minitest::Test
  def test_expects_a_file_path_as_input
    error = assert_raises ArgumentError do
      BondParser.new
    end
    assert_equal 'missing keyword: file_path', error.message
  end

  def test_expects_path_to_an_existing_file_as_input
    missing_file_path = 'no_file_here'

    error = assert_raises ArgumentError do
      BondParser.new(file_path: missing_file_path)
    end
    assert_equal "#{missing_file_path} does not exist", error.message
  end

  def test_parse_returns_no_bonds_for_invalid_csv_file
    Tempfile.open('foo', '/tmp') do |not_a_csv|
      parser = BondParser.new(file_path: not_a_csv)

      assert_empty parser.parse
    end
  end

  def test_parse_returns_bonds_from_valid_csv_file
    parser = BondParser.new(file_path: 'data/happy_path.csv')
    bonds = parser.parse

    refute_empty bonds
    assert_instance_of Bond, bonds.first
  end

  def test_parse_expects_csv_header_to_be_present
    # CSV_HEADER = 'bond,type,term,yield'
  end
end
