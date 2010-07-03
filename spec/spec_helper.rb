$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'couch_ar'
require 'spec'
require 'spec/autorun'

TEST_COUCHDB_NAME = 'test'
TEST_COUCHDB_CONF = {
  :host => 'localhost',
  :port => 5984
}
DEBUG_FOR_RSPEC = true

CouchAr::Base.logger = Logger.new(STDOUT)
Spec::Runner.configure do |config|

end
