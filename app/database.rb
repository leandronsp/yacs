require 'yaml'
require 'pg'

class Database
  def self.connection
    config = YAML.load_file('config/database.yml')[ENV['APP_ENV']]
    PG.connect(**config)
  end
end
