class TemplateGenerationService
  def self.generate_csv
    CSV.generate do |csv|
      csv << ["Name", "Email"]
      csv << ["John Doe", "john.doe@example.com"]
    end
  end

  def self.generate_xlsx
    package = Axlsx::Package.new
    package.workbook.add_worksheet(name: "Bulk Invite") do |sheet|
      sheet.add_row ["Name", "Email"]
      sheet.add_row ["John Doe", "john.doe@example.com"]
    end
    package.to_stream.read
  end
end
