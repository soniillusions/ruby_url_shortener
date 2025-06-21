require 'dotenv/load'
require 'sinatra'
require 'sequel'
require 'yaml'
require 'erb'

ENV['RACK_ENV'] ||= 'development'
config_path = File.expand_path('config/database.yml', __dir__)
raw_config = ERB.new(File.read(config_path)).result
configs = YAML.safe_load(raw_config, aliases: true)
db_conf = configs.fetch(ENV['RACK_ENV'])

DB = Sequel.connect(db_conf)

require_relative 'models/link'

get '/:code' do
  link = Link.first(short_url: params[:code])
  if link
    redirect link.original_url, 302
  else
    status 404
    "404 — not found: #{params[:code]}"
  end
end
