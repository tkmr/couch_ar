require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "CouchAr" do
  before :all do
    TestDB = CouchAr::Database.setup(TEST_COUCHDB_NAME, TEST_COUCHDB_CONF)
    @test_db = TestDB.open

    class Book < CouchAr::Document
      database TestDB
    end

    class MyDesign < CouchAr::Design
      database TestDB
    end
  end

  describe 'Database' do
    it 'can generate new class' do
      TestDB = CouchAr::Database.setup(TEST_COUCHDB_NAME, TEST_COUCHDB_CONF)
      TestDB.superclass.should == CouchAr::Database
    end

    it 'can get a db infomation' do
      # @test_db.class.should   == TestDB
      @test_db.db_name.should == TestDB.element_name
    end
  end

  describe 'Document' do
    it 'provide CRUD operation to CouchDB' do
      aut = {
        "name" => 'tatsuya',
        "age"  => 29
      }

      b = Book.new
      b.name = 'The book'
      b.author = aut
      b.tags = ['tech', 'free', 'pdf']
      b.save!

      b2 = Book.find(b.id)
      b2.name.should == 'The book'
      b2.author.should == aut
      b2.name = 'The super book'
      b2.save!
    end
  end

  describe 'Design' do
  end
end
