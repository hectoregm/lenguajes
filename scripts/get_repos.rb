require 'csv'

INDEX_TEAM = 11
INDEX_REPO = 12
teams = {}

CSV.foreach('lenguajes20161.csv') do |row|
  team_name = row[9]
  teams[team_name] = row[10] if team_name && !teams[team_name]
end

teams.sort.each do |name, repo|
  puts "#{name}: #{repo}"
end
