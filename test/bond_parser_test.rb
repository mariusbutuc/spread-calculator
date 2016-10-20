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

  def test_parse_returns_bonds_from_valid_csv_file
    parser = BondParser.new(file_path: 'data/sample_input.csv')
    bonds = parser.parse

    refute_empty bonds
    assert_instance_of Bond, bonds.first
  end

  def test_parse_requires_csv_header
    Tempfile.open(['foo', '.csv'], '/tmp') do |headerless_csv|
      headerless_csv.write <<-CSV.gsub(' ', '')
        C1,corporate,10.3 years,5.30%
        G1,government,9.4 years,3.70%
        G2,government,12 years,4.80%
      CSV
      headerless_csv.rewind

      assert_raises BondParser::InvalidCsvHeaderError do
        BondParser.new(file_path: headerless_csv.path).parse
      end
    end
  end

  def test_parse_requires_all_bond_attributes
    Tempfile.open(['foo', '.csv'], '/tmp') do |yield_missing_csv|
      yield_missing_csv.write <<-CSV.gsub(' ', '')
        bond,type,term
        C1,corporate,10.3 years
        G1,government,9.4 years
        G2,government,12 years
      CSV
      yield_missing_csv.rewind

      assert_raises BondParser::InvalidCsvHeaderError do
        BondParser.new(file_path: yield_missing_csv.path).parse
      end
    end
  end
end
