require 'yaml'
require 'pg'

class Database
  def self.connection
    config = YAML.load(
      ERB.new(
        File.read('config/database.yml')
      ).result
    )[ENV['APP_ENV']]

    PG.connect(**config)
  end
end
