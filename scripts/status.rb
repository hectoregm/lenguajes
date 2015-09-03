require 'github_api'

github = Github.new

stats = github.repos.stats.contributors 'Pernath', 'lenguajes20161_ReyVenado'

puts stats.body.inspect
