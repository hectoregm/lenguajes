require 'csv'
require 'json'

INDEX_TEAM = 11
INDEX_REPO = 12
teams = {}

CSV.foreach('lenguajes20161.csv') do |row|
  team_name = row[10]

  if team_name
    puts team_name
    teams[team_name] = {} if team_name && !teams[team_name]
    teams[team_name][:members] = [] if team_name && !teams[team_name][:members]
    teams[team_name][:repo] = row[11]
    teams[team_name][:members] << "#{row[2]} #{row[3]} #{row[4]}"
  end
end

teams.sort.each do |name, data|
  puts "#{name}: #{data.inspect}"
end

File.open('teams.json', 'w') { |f| f.write(JSON.generate(teams)) }

puts 'Professional Level Languages'
professional_languages = {}
CSV.foreach('lenguajes20161.csv') do |row|
  pro_languages = row[13] ? row[13].split(':') : []

  pro_languages.each do |lang|
    professional_languages[lang] = 0 unless professional_languages[lang]
    professional_languages[lang] += 1
  end
end

professional_languages.sort.each do |lang, count|
  puts "#{lang}: #{count}"
end

puts 'Intermediate Level Languages'
intermediate_languages = {}
CSV.foreach('lenguajes20161.csv') do |row|
  inter_languages = row[14] ? row[14].split(':') : []

  inter_languages.each do |lang|
    intermediate_languages[lang] = 0 unless intermediate_languages[lang]
    intermediate_languages[lang] += 1
  end
end

intermediate_languages.sort.each do |lang, count|
  puts "#{lang}: #{count}"
end

puts 'Basic Level Languages'
basic_languages = {}
CSV.foreach('lenguajes20161.csv') do |row|
  bas_languages = row[15] ? row[15].split(':') : []

  bas_languages.each do |lang|
    basic_languages[lang] = 0 unless basic_languages[lang]
    basic_languages[lang] += 1
  end
end

basic_languages.sort.each do |lang, count|
  puts "#{lang}: #{count}"
end
