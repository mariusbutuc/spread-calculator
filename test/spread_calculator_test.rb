require_relative 'test_helper'
require_relative '../lib/spread_calculator'

class SpreadCalculatorTest < Minitest::Test
  def test_expects_file_path_as_input
    error = assert_raises ArgumentError do
      SpreadCalculator.new
    end

    assert_equal 'missing keyword: file_path', error.message
  end

  def test_extracts_the_corporate_bonds
    calculator = SpreadCalculator.new(file_path: 'data/happy_path.csv')
    bonds = calculator.corporate_bonds

    refute_empty bonds
    bonds.each do |bond|
      assert_instance_of Bond, bond
      assert_equal :corporate, bond.type
    end
  end

  def test_extracts_the_government_bonds
    calculator = SpreadCalculator.new(file_path: 'data/happy_path.csv')
    bonds = calculator.government_bonds

    refute_empty bonds
    bonds.each do |bond|
      assert_instance_of Bond, bond
      assert_equal :government, bond.type
    end
  end

  def test_calculate_returns_expected_results
    calculator = SpreadCalculator.new(file_path: 'data/happy_path.csv')
    expected_output = <<-CSV.gsub(' ', '')
      bond,benchmark,spread_to_benchmark
      C1,G1,1.60%
    CSV

    assert_equal expected_output, calculator.calculate
  end

  def test_calculate_selects_first_of_two_government_bonds_with_same_term
    calculator = SpreadCalculator.new(file_path: 'data/same_term.csv')
    expected_output = <<-CSV.gsub(' ', '')
      bond,benchmark,spread_to_benchmark
      C1,G1,0.50%
    CSV

    assert_equal expected_output, calculator.calculate
  end

  def test_calculate_sample_input
    calculator = SpreadCalculator.new(file_path: 'data/sample_input.csv')
    output = <<-CSV.gsub(' ', '')
      bond,benchmark,spread_to_benchmark
      C1,G1,1.60%
      C2,G2,1.50%
      C3,G3,2.00%
      C4,G3,2.90%
      C5,G4,0.90%
      C6,G5,1.80%
      C7,G6,2.50%
    CSV

    assert_equal output, calculator.calculate
  end
end
