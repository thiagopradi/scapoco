$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'scapoco'
require "pry"

PG_SPEC = {
  :adapter  => 'postgresql',
  :host     => 'localhost',
  :database => 'scapoco',
  :username => 'postgres',
  :encoding => 'utf8'
}

# drops and create need to be performed with a connection to the 'postgres' (system) database
ActiveRecord::Base.establish_connection(PG_SPEC.merge('database' => 'postgres', 'schema_search_path' => 'public'))
# drop the old database (if it exists)
ActiveRecord::Base.connection.drop_database(PG_SPEC[:database])
# create new
ActiveRecord::Base.connection.create_database(PG_SPEC[:database])
ActiveRecord::Base.establish_connection(PG_SPEC)

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end
