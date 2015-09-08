require 'thor'
require 'json'

class Lang < Thor
  desc 'clone', 'Clone all the teams repos'
  def clone
    teams = JSON.parse(File.read('teams.json'))

    puts 'Cloning repos...'
    teams.each do |name, team_data|
      puts "Cloning #{name} repo"
      puts "Members: #{team_data['members'].join(', ')}"
      %x(git clone #{team_data['repo']})
      puts "Clone Finished\n"
    end
  end

  desc 'pull', 'Pull all the code from each team repo.'
  def pull
    teams = JSON.parse(File.read('teams.json'))

    puts 'Pulling repos...'
    teams.each do |name, team_data|
      match = team_data['repo'].match %r{\/([^\/]*)\.git}
      dir = match[1]
      puts "Pulling #{name} repo: #{dir}"
      puts %x(cd #{dir}; git pull)
    end
  end

  desc 'status', 'Print the git status from each team repo.'
  def status
    teams = JSON.parse(File.read('teams.json'))

    teams.each do |name, team_data|
      match = team_data['repo'].match %r{\/([^\/]*)\.git}
      dir = match[1]
      puts "Status #{name} repo: #{dir}"
      puts %x(cd #{dir}; git status)
    end
  end
end

Lang.start(ARGV)
