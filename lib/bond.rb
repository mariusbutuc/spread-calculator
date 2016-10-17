class Bond
  VALID_BOND_TYPES = %i(corporate government).freeze

  attr_reader :id, :type, :term, :yield_spread

  def initialize(id:, type:, term:, yield_spread:)
    @id             = id
    @type           = type.to_sym
    @term           = term.to_f
    @yield_spread   = yield_spread.to_f

    raise(ArgumentError, "Invalid bond type: #{type}") unless VALID_BOND_TYPES.include?(@type)
  end
end
