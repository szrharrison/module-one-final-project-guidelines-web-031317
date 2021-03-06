require 'bundler'
Bundler.require
require 'json'

ActiveRecord::Base.logger = nil
Geocoder.configure(:units => :mi, :timeout => 5000)

Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), "../app", "*.rb")].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), "../app/adapters", "*.rb")].each { |f| require f }

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
