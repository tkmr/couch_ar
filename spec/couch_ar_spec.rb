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

  describe 'Document' do
    it 'provide CRUD operations to CouchDB' do
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
    it 'should provide to access some views' do
      test_tag = "tag_#{rand}"

      b = Book.new
      b.name = 'The Computer book'
      b.tags = ['cpu', 'hdd', 'tech', test_tag]
      b.save!

      javascript = <<EOT
function(doc){
  if(doc.tags){
    for(var tag in doc.tags){
      emit(doc.tags[tag], 1);
    }
  }
}
EOT
      map_reduce = {'map' => javascript}

      begin
        test_design = MyDesign.find_by_name('testview')
      rescue
        test_design = MyDesign.new('name' => 'testview')
      end

      test_design.views['tags'] = CouchAr::View.new('tags', test_design, map_reduce)
      test_design.save!

      books = Book.find_by_view(test_design.views['tags'])
      books[test_tag].size.should == 1
      books[test_tag][0].id.should == b.id
    end
  end
end
