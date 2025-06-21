require 'telegram/bot'
require 'sequel'
require 'dotenv/load'
require 'yaml'
require 'erb'

ENV['RACK_ENV'] ||= 'development'
config_path = File.expand_path('config/database.yml', __dir__)
raw_config = ERB.new(File.read(config_path)).result
configs = YAML.safe_load(raw_config, aliases: true)
db_conf = configs.fetch(ENV['RACK_ENV'])

DB = Sequel.connect(db_conf)

Sequel.extension :migration
Sequel::Migrator.run(DB, File.expand_path('db/migrate', __dir__))

Dir[File.expand_path('models/*.rb', __dir__)].sort.each { |f| require f }
Dir[File.expand_path('services/*.rb', __dir__)].sort.each { |f| require f }

Dir[File.expand_path('bot/commands/**/*.rb', __dir__)].each { |f| require f }
require_relative 'bot/command_router'

TOKEN = ENV.fetch('TOKEN')
BASE_URL = ENV.fetch('BASE_URL', 'http://127.0.0.1:4567')

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    Bot::CommandRouter.new(bot, message).route
  end
end
