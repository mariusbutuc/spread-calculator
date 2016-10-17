require_relative 'bond_parser'

class SpreadCalculator
  OUTPUT_HEADERS = %w(bond benchmark spread_to_benchmark).freeze.map(&:freeze)
  CORPORATE_BOND_TYPE = :corporate

  attr_reader :corporate_bonds, :government_bonds

  def initialize(file_path:)
    bonds = BondParser.new(file_path: file_path).parse

    @corporate_bonds, @government_bonds = bonds.partition do |bond|
      bond.type == CORPORATE_BOND_TYPE
    end
  end

  def calculate
    benchmarks = corporate_bonds.map do |corporate_bond|
      benchmark = closest_government_bond(corporate_bond: corporate_bond)
      spread    = spread_to_benchmark(corporate_bond, benchmark)

      [corporate_bond, benchmark, spread]
    end

    output(benchmarks)
  end

  private

  def closest_government_bond(corporate_bond:)
    government_bonds.min_by do |bond|
      difference(bond.term, corporate_bond.term)
    end
  end

  def difference(minuend, subtrahend)
    (minuend - subtrahend).abs
  end

  def spread_to_benchmark(corporate_bond, government_bond)
    difference(corporate_bond.yield_spread, government_bond.yield_spread)
  end

  def output(benchmarks)
    CSV.generate(headers: :first_row) do |csv|
      csv << OUTPUT_HEADERS
      benchmarks.each do |benchmark_details|
        corporate_bond, benchmark, spread = benchmark_details
        csv << [corporate_bond.id, benchmark.id, sprintf('%.2f%', spread)]
      end
    end
  end
end
