require 'bundler'
Bundler.require

def save_with_json(data)
  File.open("./db/data.json", "w") do |content|
    content.write(JSON.pretty_generate(data))
  end
  puts "> database.json has been created in ./db/"
end

def save_with_gss(data)
  session = GoogleDrive::Session.from_config("./client_server.json")
  spreadsheet = session.spreadsheet_by_key("1TD1TF2813PHNL9kscoBU2Gl55Tx0vrOWPOorFB4tyt8")
  worksheet = spreadsheet.worksheets.first  # work = data.worksheets.first
  # work.rows.first(10).each{|row|puts row.first(6).join(" - ")}
  data.each do |key, value|
    row = worksheet.num_rows + 1
    worksheet[row, 1] = key
    worksheet[row, 2] = value
  end
  worksheet.save
  puts "> database.gss has been created in ./db/"
end

def save_with_csv(data)
  CSV.open("./db/data.csv", "w") do |content|
    data.each {|line| content << line}
  end
  puts "> database.csv has been created in ./db/"
end

def make_a_choice
  puts "> please, choose one between : JSON(1), Google Spreadsheet(2), CSV(3)"
  choice = gets.chomp
  while choice != "1" && choice != "2" &&choice != "3" do
    puts "ERROR : wrong input."
    puts "please, choose one between : JSON(1), Google Spreadsheet(2), CSV(3)"
    choice = gets.chomp
  end
  return choice
end

def main
  data = {
  "nombre d'habitant": 2,
  "habitants": ["Jean", "Josiane"],
  "ages": [30, 27],
  "ville": "Paris",
  "date d'arrivée": "26 juin 2018"
  }

  db_tool = make_a_choice
  if db_tool == "1"
    save_with_json(data)
  elsif db_tool == "2"
    save_with_gss(data)
  else
    save_with_csv(data)
  end
  puts "> programm will stop, thanks for using it."
end

main