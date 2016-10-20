require 'csv'

module OutputFormatter
  SPREAD_FORMAT = '%.2f%'.freeze

  def to_csv(headers:, rows:)
    CSV.generate(headers: :first_row) do |csv|
      csv << headers
      rows.each do |row|
        csv << with_printable_spread(row)
      end
    end
  end

  def with_printable_spread(row)
    row[-1] = sprintf(SPREAD_FORMAT, row.last)
    row
  end
end
