require_relative 'test_helper'
require_relative '../lib/bond'

class BondTest < Minitest::Test
  def test_bond_type_must_be_valid
    invalid_bond_type = 'invalid_bond_type'

    error = assert_raises ArgumentError do
      Bond.new(**valid_bond_arguments.merge(type: invalid_bond_type))
    end
    assert_equal "Invalid bond type: #{invalid_bond_type}", error.message
  end

  def test_term_removes_non_numeric_charaters
    bond = Bond.new(valid_bond_arguments)

    assert_equal 10.3, bond.term
  end

  def test_yield_spread_removes_non_numeric_charaters
    bond = Bond.new(valid_bond_arguments)

    assert_equal 5.3, bond.yield_spread
  end

  private

  def valid_bond_arguments
    @valid_bond_arguments ||= {
      id:           'C1',
      type:         'corporate',
      term:         '10.3 years',
      yield_spread: '5.30%',
    }
  end
end
