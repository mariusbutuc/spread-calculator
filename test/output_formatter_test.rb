require_relative 'test_helper'
require_relative '../lib/output_formatter'

class OutputFormatterTest < Minitest::Test
  class DummyFormatter
    include OutputFormatter
  end

  def setup
    @formatter = DummyFormatter.new
  end

  def test_to_csv_outputs_given_headers
    headers = %w(foo bar baz)
    formated_output = @formatter.to_csv(headers: headers, rows: [])

    assert_match headers.join(','), formated_output
  end

  def test_to_csv_outputs_all_given_rows
    row = [1, 2, 3]
    formated_output = @formatter.to_csv(headers: [], rows: [row])

    assert_match '1,2,3.00%', formated_output
  end

  def test_with_printable_spread_formats_spread
    row = [1, 2, 3]
    formated_output = @formatter.with_printable_spread(row)

    assert_includes formated_output, '3.00%'
  end
end
