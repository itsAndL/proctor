class FileParsingService
  def self.parse_bulk_invite_file(file)
    case File.extname(file.original_filename)
    when '.csv'
      parse_csv(file)
    when '.xlsx', '.xls'
      parse_excel(file)
    else
      []
    end
  end

  private

  def self.parse_csv(file)
    CSV.read(file.path, headers: true).map do |row|
      { name: row['Name'], email: row['Email'] }
    end
  end

  def self.parse_excel(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    headers = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[headers, spreadsheet.row(i)].transpose]
      { name: row['Name'], email: row['Email'] }
    end
  end
end
