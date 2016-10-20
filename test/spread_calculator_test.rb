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
    calculator = SpreadCalculator.new(file_path: 'data/spread_to_benchmark_sample.csv')
    bonds = calculator.corporate_bonds

    refute_empty bonds
    bonds.each do |bond|
      assert_instance_of Bond, bond
      assert_equal :corporate, bond.type
    end
  end

  def test_extracts_the_government_bonds
    calculator = SpreadCalculator.new(file_path: 'data/spread_to_benchmark_sample.csv')
    bonds = calculator.government_bonds

    refute_empty bonds
    bonds.each do |bond|
      assert_instance_of Bond, bond
      assert_equal :government, bond.type
    end
  end

  def test_spread_to_benchmark_confirms_sample_output_results
    calculator = SpreadCalculator.new(file_path: 'data/spread_to_benchmark_sample.csv')
    expected_output = <<-CSV.gsub(' ', '')
      bond,benchmark,spread_to_benchmark
      C1,G1,1.60%
    CSV

    assert_equal expected_output, calculator.spread_to_benchmark
  end

  def test_spread_to_benchmark_selects_first_of_two_government_bonds_with_same_term
    calculator = SpreadCalculator.new(file_path: 'data/same_term.csv')
    expected_output = <<-CSV.gsub(' ', '')
      bond,benchmark,spread_to_benchmark
      C1,G1,0.50%
    CSV

    assert_equal expected_output, calculator.spread_to_benchmark
  end

  def test_spread_to_benchmark_calculates_expected_values_from_sample_input
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

    assert_equal output, calculator.spread_to_benchmark
  end

  def test_spread_to_curve_confirms_sample_output_results
    calculator = SpreadCalculator.new(file_path: 'data/spread_to_curve_sample.csv')
    expected_output = <<-CSV.gsub(' ', '')
      bond,spread_to_curve
      C1,1.22%
      C2,2.98%
    CSV

    assert_equal expected_output, calculator.spread_to_curve
  end

  def test_spread_to_curve_calculates_expected_values_from_sample_input
    calculator = SpreadCalculator.new(file_path: 'data/sample_input.csv')
    output = <<-CSV.gsub(' ', '')
      bond,spread_to_curve
      C1,1.43%
      C2,1.63%
      C3,2.47%
      C4,2.27%
      C5,1.90%
      C6,1.57%
      C7,2.83%
    CSV

    assert_equal output, calculator.spread_to_curve
  end
end
