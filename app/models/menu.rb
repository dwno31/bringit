class Menu < ActiveRecord::Base
  belongs_to :shop
def self.import(file)
  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    post = find_by_id(row["id"]) || new
    x=0
    header.each do |att_name|
      if !spreadsheet.row(i)[x].nil?
     post[att_name] = spreadsheet.row(i)[x]
      end
    x = x+1  
    end
    post.save!
  end
end

def self.open_spreadsheet(file)
  case File.extname(file.path)
  when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
  when ".xls" then Roo::Excel.new(file.path)
  when ".xlsx" then Roo::Excelx.new(file.path)
  else raise "Unknown file type"
  end
end

end
