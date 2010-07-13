require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "CouchAr" do
  before :all do
    @test_db = TestDB.open
  end

  describe 'Database' do
    it 'can generate new class' do
      TempTestDB = CouchAr::Database.setup(TEST_COUCHDB_NAME, TEST_COUCHDB_CONF)
      TempTestDB.superclass.should == CouchAr::Database
    end

    it 'can get a db infomation' do
      # @test_db.class.should   == TestDB
      @test_db.db_name.should == TestDB.element_name
    end
  end
end
