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
TestDB = CouchAr::Database.setup(TEST_COUCHDB_NAME, TEST_COUCHDB_CONF)

class Book < CouchAr::Document
  database TestDB
end

class Author < CouchAr::Document
  database TestDB
end

class MyDesign < CouchAr::Design
  database TestDB
end

Spec::Runner.configure do |config|
end
