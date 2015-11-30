class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :shop

def self.open_spreadsheet(file)
  case File.extname(file.path)
  when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
  when ".xls" then Roo::Excel.new(file.path)
  when ".xlsx" then Roo::Excelx.new(file.path)
  else raise "Unknown file type"
  end
end

end
