require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task default: :test

namespace :db do
  MIGRATIONS_DIR = 'db/migrate'

  desc "Generate a new Sequel migration: rake db:generate[name]"
  task :generate, [:name] do |_, args|
    name      = args[:name] or abort("Usage: rake db:generate[name]")
    ts        = Time.now.utc.strftime("%Y%m%d%H%M%S")
    filename  = "#{MIGRATIONS_DIR}/#{ts}_#{name}.rb"
    template  = <<~RUBY
      Sequel.migration do
        change do
          # TODO: describe schema changes
        end
      end
    RUBY

    FileUtils.mkdir_p(MIGRATIONS_DIR)
    File.write(filename, template)
    puts "Created #{filename}"
  end
end