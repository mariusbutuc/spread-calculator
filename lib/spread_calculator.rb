require_relative 'bond_parser'
require_relative 'output_formatter'

class SpreadCalculator
  include OutputFormatter

  SPREAD_TO_BENCHMARK_HEADERS = %w(bond benchmark spread_to_benchmark).freeze.map(&:freeze)
  SPREAD_TO_CURVE_HEADERS     = %w(bond spread_to_curve).freeze.map(&:freeze)
  CORPORATE_BOND_TYPE         = :corporate

  attr_reader :corporate_bonds, :government_bonds

  def initialize(bonds:)
    @corporate_bonds, @government_bonds = bonds.partition do |bond|
      bond.type == CORPORATE_BOND_TYPE
    end
  end

  def spread_to_benchmark
    benchmarks = corporate_bonds.map do |corporate_bond|
      benchmark = closest_government_bond(corporate_bond: corporate_bond)
      spread    = delta(corporate_bond.yield_spread, benchmark.yield_spread)

      [corporate_bond.id, benchmark.id, spread]
    end

    to_csv(headers: SPREAD_TO_BENCHMARK_HEADERS, rows: benchmarks)
  end

  def spread_to_curve
    curves = corporate_bonds.map do |corporate_bond|
      lower, upper = closest_government_bonds(corporate_bond: corporate_bond)
      spread = interpolated_yield(corporate: corporate_bond, lower: lower, upper: upper)

      [corporate_bond.id, spread]
    end

    to_csv(headers: SPREAD_TO_CURVE_HEADERS, rows: curves)
  end

  private

  def closest_government_bond(corporate_bond:)
    government_bonds.min_by do |bond|
      delta(bond.term, corporate_bond.term)
    end
  end

  def closest_government_bonds(corporate_bond:)
    lower_bonds, upper_bonds = government_bonds.partition do |bond|
      bond.term <= corporate_bond.term
    end

    [lower_bonds.max_by(&:term), upper_bonds.min_by(&:term)]
  end

  def interpolated_yield(corporate:, lower:, upper:)
    delta(
      corporate.yield_spread,
      (
        (
          (corporate.term - lower.term) * upper.yield_spread +
          (upper.term - corporate.term) * lower.yield_spread
        ) / (upper.term - lower.term)
      )
    )
  end

  def delta(minuend, subtrahend)
    (minuend - subtrahend).abs
  end
end
