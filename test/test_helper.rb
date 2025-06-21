ENV['RACK_ENV'] ||= 'test'

require 'dotenv/load'

require 'minitest/autorun'
require 'sequel'
require 'erb'
require 'yaml'

config_path = File.expand_path('../config/database.yml', __dir__)
raw_config = ERB.new(File.read(config_path)).result
configs = YAML.safe_load(raw_config, aliases: true)
db_conf = configs.fetch(ENV['RACK_ENV'])

DB = Sequel.connect(db_conf)

Sequel.extension :migration
Sequel::Migrator.run(DB, File.expand_path('../db/migrate', __dir__))

Dir[File.expand_path('../models/*.rb', __dir__)].each { |f| require f }

class Minitest::Test
  def before_setup
    super
    DB.tables.each { |t| DB[t].truncate(cascade: true) }
  end
end
